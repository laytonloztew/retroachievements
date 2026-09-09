const GOOGLE_FORM_ID = "1FAIpQLSc_3oap_CSgB711XPOVVvmEzv6OrvqfxwCFLeRFo-RlWOw9Rw";
const ENTRY_ID = "entry.104341090";
const ENTRY_ID_USER = "entry.654119116";
const ENTRY_ID_PROMPT = "entry.588355377";
const GOOGLE_SHEET_ID = "1xXP3nMv7hnLFeWX5J7hXupKZyU4EHURTnQeiSaZPDWM";

const CLIENT_ID = "b4fb95e0edc434c";
const GOOGLE_SHEET_URL = "https://docs.google.com/spreadsheets/d/" + GOOGLE_SHEET_ID + "/export?format=csv";
const GOOGLE_FORM_URL = "https://docs.google.com/forms/d/e/" + GOOGLE_FORM_ID + "/formResponse";

const paintCanvas = document.querySelector('.paint-canvas');
const context = paintCanvas.getContext('2d');
context.lineCap = 'round';
context.globalAlpha = 1;
context.globalCompositeOperation = 'source-over';
context.imageSmoothingEnabled = false;

var fileInput = document.getElementById('myFile');
var fReader = new FileReader();

const progressContainer = document.getElementById('progressContainer');
const progressBar = document.getElementById('progressBar');

const canvas_bg = document.getElementById("canvas_bg");

const color_pickers = document.getElementsByClassName("color-pick");
const pencil_pickers = document.getElementsByClassName("pencil-pick");
const tool_pickers = document.getElementsByClassName("tool-pick");

const save_button = document.getElementById("save");
const reset_button = document.getElementById("reset-button");
const submit_button = document.getElementById("submit");

const CANVAS_WIDTH = 195;
const CANVAS_HEIGHT = 175;

const OUTPUT_MAX = 2720;

const COLOR_ORDER = [15, 14, 8, 12, 11, 10, 1, 2, 4, 5, 13, 9, 7, 6, 3];
const PENCIL_ORDER = [1, 2, 3, 4];
const COLORS = ['rgb(251,251,251)', 'rgb(130,130,130)', 'rgb(195,195,195)', 'rgb(203,81,0)', 'rgb(251,178,219)', 'rgb(203,48,211)', 'rgb(251,130,0)', 'rgb(32,227,186)', 'rgb(16,138,16)', 'rgb(48,186,243)', 'rgb(251,251,251)', 'rgb(251,251,0)', 'rgb(0,0,251)', 'rgb(0,251,0)', 'rgb(251,0,0)', 'rgb(0,0,0)'];

X_OFFSET = -51;
Y_OFFSET = -10;

let scale = 1;

let drawColor = 15;
let lastColorUsed = 0;
let drawScale = 2;
let lastScaleUsed = 0;

let isViewing = false;
let viewingCommandCounter = 0;
let isAnimating = false;
let isDrawing = false;

let isPaintBucket = false;
let paintR = 0;
let paintG = 0;
let paintB = 0;

outputArray = [];

const DRAW_PENCIL = 1;
const PAINT_BUCKET = 2;
const CLEAR_CANVAS = 3;
const CHANGE_COLOR = 7;
const CHANGE_SIZE = 8;

var savefile;

const canvasStates = new Map();

function getCanvasState(canvas) {
	if (!canvasStates.has(canvas)) {
		canvasStates.set(canvas, {
			drawScale: 1,
			previousX: 0,
			previousY: 0,
		});
	}

	return canvasStates.get(canvas);
}


function hexToInt(offset, size) {
	var val = "";
	for (var i = 0; i < size; i++) {
		var code = savefile.charCodeAt(offset + i).toString(16);
		if (code.length < 2)
			code = "0" + code;
		val += code;
	}

	intVal = parseInt(val, 16);
	if (val.length == 4) {
		intVal = swap16(intVal);
	}
	if (val.length == 8) {
		intVal = swap32(intVal);
	}

	return intVal;
}

function getHexValue(offset, size, swap = true) {
	var output = "";
	for (var i = 0; i < size; i++) {
		var code = savefile.charCodeAt(offset + i).toString(16);
		if (code.length < 2)
			code = "0" + code;
		output += code;
	}

	if (output.length == 4) {
		if (swap) {
			output = swap16(parseInt(output, 16)).toString(16);
		} else {
			output = parseInt(output, 16).toString(16);
		}

		while (output.length < 4)
			output = "0" + output;
	}

	if (output.length == 8) {
		output = swap32(parseInt(output, 16)).toString(16);
		while (output.length < 8)
			output = "0" + output;
	}

	return output;
}

function swap16(val) {
	return ((val & 0xFF) << 8) |
		((val >> 8) & 0xFF);
}

function swap32(val) {
	return ((val & 0xFF) << 24) |
		((val & 0xFF00) << 8) |
		((val >> 8) & 0xFF00) |
		((val >> 24) & 0xFF);
}

function getHeader() {
	return hexToInt(0x0, 4);
}

function performViewAction(param_1, param_2, param_3) {
	switch (param_1) {
		case "01": // Draw
			x = parseInt(param_2, 16) + X_OFFSET;
			y = parseInt(param_3, 16) + Y_OFFSET;
			if (lastX != 0) {
				drawLine(lastX, lastY, x, y);
			} else {
				contextPencilDraw(drawScale, x, y);
			}
			lastX = x;
			lastY = y;
			break;
		case "02": //Paint Bucket
			x = parseInt(param_2, 16) + X_OFFSET;
			y = parseInt(param_3, 16) + Y_OFFSET;
			str = context.fillStyle.replace('#', '0x') + "FF";
			floodFill(context, x, y, str);
		case "03":
			//trashcan
			break;
		case "06":
			//pause?
			break;
		case "07": // Change Color
			c = parseInt(param_2, 16);
			drawColor = c;
			setContextDrawColor(c);
			break;
		case "08": // Change Size
			setContextDrawScale(parseInt(param_2, 16) + 1);
			break;
		case "09":
			//resume?
			lastX = 0;
			lastY = 0;
			break;
		default:
			console.log("Unknown param_1: " + param_1);
			break;
	}
	viewingCommandCounter += 1;
	updateInk();
}

const sleep = ms => new Promise(resolve => setTimeout(resolve, ms));

const viewDrawing = async (savefile) => {
	lastColorUsed = 0;
	lastScaleUsed = 0;
	lastX = lastY = 0;
	i = 0;
	while (i < (savefile.length - 8) / 3) {
		let param_1 = getHexValue((i * 3) + 8, 1);
		let param_2 = getHexValue((i * 3) + 8 + 1, 1);
		let param_3 = getHexValue((i * 3) + 8 + 2, 1);
		performViewAction(param_1, param_2, param_3);
		await sleep(5);
		i++;
	}
};

fReader.onload = function (e) {
	savefile = e.target.result;
	switch (getHeader()) {
		case 0x50495131:
			console.log("Valid file");
			break;
		default:
			console.log("Invalid file");
			return;
	}

	resetCanvas();
	isViewing = true;
	reset_button.disabled = true;
	reset_button.value = "Drawing...";
	save_button.disabled = submit_button.disabled = true;
	viewDrawing(savefile).then(() => {
		reset_button.disabled = false;
		reset_button.value = "Reset Canvas";
	});
}

fileInput.onchange = function (e) {
	var file = this.files[0];
	fReader.readAsBinaryString(file);
}

const zeroPad = (num, places) => String(num).padStart(places, '0')

function outputToArray(arr) {
	if (outputArray.length == 0) {
		outputArray = [49, 81, 73, 80, 0, 0, 0, 0];
		save_button.disabled = submit_button.disabled = false;
	}
	arr.forEach((e) => outputArray.push(e));
	updateInk();
}

function updateInk() {
	inkUsed = getInkUsed();

	inkUsedHex = zeroPad(inkUsed.toString(16), 4);

	let firstHalf = inkUsedHex.substring(0, 2);
	let secondHalf = inkUsedHex.substring(2, 4);

	if (outputArray.length > 0 && !isViewing) {
		save_button.disabled = submit_button.disabled = false;
	}

	if (outputArray.length == 0) {
		outputArray = [49, 81, 73, 80, 0, 0, 0, 0];

	}

	outputArray[4] = parseInt(secondHalf, 16);
	outputArray[5] = parseInt(firstHalf, 16);

	progressBar.style.width = ((OUTPUT_MAX - inkUsed) / OUTPUT_MAX) * 100 + "%";
}

function getInkUsed() {
	if (isViewing) {
		return viewingCommandCounter;
	} else {
		return (outputArray.length - 8) / 3;
	}

}

function setDrawColor(i) {
	if (isViewing) {
		return;
	}
	drawColor = COLOR_ORDER[i];
	setColorButton(i);
}

function setColorButton(i) {
	j = 0;
	for (let item of color_pickers) {
		item.disabled = false;
		item.src = "img/picto/color_btn_" + (COLOR_ORDER[j]) + ".png";
		j++;
	}
	color_pickers[i].disabled = true;
	color_pickers[i].src = "img/picto/color_btn_" + (COLOR_ORDER[i]) + "_pressed.png";
}

function setContextDrawScale(s) {
	drawScale = s;
}

function setContextDrawColor(c) {
	context.fillStyle = COLORS[c];
}

function contextPencilDraw(s, x, y) {
	switch (s) {
		case 1:
			context.fillRect(x, y, 2, 2);
			break;
		case 2:
			context.fillRect(x + 1, y, 1, 1);
			context.fillRect(x, y + 1, 1, 1);
			context.fillRect(x - 1, y, 1, 1);
			context.fillRect(x, y - 1, 1, 1);
			context.fillRect(x, y, 1, 1);
			break;
		case 3:
			context.fillRect(x, y, 2, 2);

			context.fillRect(x, y - 1, 2, 2);
			context.fillRect(x - 1, y, 2, 2);
			context.fillRect(x, y + 1, 2, 2);
			context.fillRect(x + 1, y, 2, 2);
			break;
		case 4:
			context.fillRect(x - 1, y - 1, 6, 6);

			context.fillRect(x, y - 2, 4, 4);
			context.fillRect(x - 2, y, 4, 4);
			context.fillRect(x, y + 2, 4, 4);
			context.fillRect(x + 2, y, 4, 4);
			break;
	}
}

function canvasDrawRect(x, y) {

	if (drawColor != lastColorUsed) {
		outputToArray([CHANGE_COLOR, drawColor, 0]);
	}
	lastColorUsed = drawColor

	if (drawScale != lastScaleUsed) {
		outputToArray([CHANGE_SIZE, drawScale - 1, 0]);
	}
	lastScaleUsed = drawScale;

	setContextDrawColor(drawColor);
	if (isPaintBucket) {
		str = context.fillStyle.replace('#', '0x') + "FF";
		outputToArray([PAINT_BUCKET, (x - X_OFFSET), (y - Y_OFFSET)]);
		floodFill(context, x, y, str);
	} else {
		contextPencilDraw(drawScale, x, y);
	}

}

function setCanvasScale(newScale) {
	scale = newScale;

	paintCanvas.style.width = `${CANVAS_WIDTH * scale}px`;
	paintCanvas.style.height = `${CANVAS_HEIGHT * scale}px`;
	progressContainer.style.width = `${(CANVAS_WIDTH * scale) + 2}px`;
}

let lastX;
let lastY;


function drawLine(x0, y0, x1, y1) {
	let dx = Math.abs(x1 - x0);
	let dy = Math.abs(y1 - y0);

	let sx = x0 < x1 ? 1 : -1;
	let sy = y0 < y1 ? 1 : -1;

	let err = dx - dy;


	while (true) {
		canvasDrawRect(x0, y0);

		if (x0 === x1 && y0 === y1) {
			break;
		}

		const e2 = 2 * err;

		if (e2 > -dy) {
			err -= dy;
			x0 += sx;
		}

		if (e2 < dx) {
			err += dx;
			y0 += sy;
		}
	}
}

function clearCanvas() {
	if (getInkUsed() >= OUTPUT_MAX) {
		return;
	}
	context.clearRect(0, 0, paintCanvas.width, paintCanvas.height);
	outputToArray([CLEAR_CANVAS, 87, 3]);
	outputToArray([6, 192, 0]);
}

reset_button.addEventListener("click", function (e) { //e => event
	if (confirm("Reset the canvas?")) {
		resetCanvas();
	} else {
		return;
	}
});

function setTool(t) {
	if (t == 0) {
		isPaintBucket = false;
	} else {
		isPaintBucket = true;
	}

	j = 0;
	for (let item of tool_pickers) {
		item.disabled = false;
		item.src = "img/picto/tool_" + j + ".png";
		j++;
	}
	tool_pickers[t].disabled = true;
	tool_pickers[t].src = "img/picto/tool_" + t + "_pressed.png";
}



function resetCanvas() {
	context.clearRect(0, 0, paintCanvas.width, paintCanvas.height);

	//context.drawImage(canvas_bg, 0, 0, 197, 176);

	outputArray = [];
	isViewing = false;
	viewingCommandCounter = 0;
	save_button.disabled = submit_button.disabled = true;
	lastColorUsed = 0;
	lastScaleUsed = 0;
	lastX = lastY = 0;
	updateInk();
}

let x = 0, y = 0;

const stopDrawing = event => {
	if (!isDrawing) {
		return;
	}
	if (isViewing) {
		return;
	}

	if (getInkUsed() <= OUTPUT_MAX) {
		if (x < 0) {
			x = 0;
		}
		if (x > 255 + X_OFFSET) {
			x = 255 + X_OFFSET;
		}

		if (y < 0) {
			y = 0;
		}
		if (y > 255 + Y_OFFSET) {
			y = 255 + Y_OFFSET;
		}
		outputToArray([6, x - X_OFFSET, y - Y_OFFSET]);
	}

	isDrawing = false;

}

function setDrawScale(i) {
	if (isViewing) {
		return;
	}

	setContextDrawScale(PENCIL_ORDER[i]);

	j = 0;
	for (let item of pencil_pickers) {
		item.disabled = false;
		item.src = "img/picto/pencil_btn_" + (PENCIL_ORDER[j]) + ".png";
		j++;
	}
	pencil_pickers[i].disabled = true;
	pencil_pickers[i].src = "img/picto/pencil_btn_" + (PENCIL_ORDER[i]) + "_pressed.png";
}

const startDrawing = event => {
	isDrawing = true;
	if (isViewing) {
		return;
	}

	if (getInkUsed() >= OUTPUT_MAX) {
		isDrawing = false;
		return;
	}

	const rect = paintCanvas.getBoundingClientRect();

	lastX = Math.floor(
		(event.clientX - rect.left) * 195 / rect.width
	);

	lastY = Math.floor(
		(event.clientY - rect.top) * 175 / rect.height
	);

	if (lastX < 0) {
		lastX = 0;
	}
	if (lastX > 255 + X_OFFSET) {
		lastX = 255 + X_OFFSET;
	}

	if (lastY < 0) {
		lastY = 0;
	}
	if (lastY > 255 + Y_OFFSET) {
		lastY = 255 + Y_OFFSET;
	}

	canvasDrawRect(lastX, lastY);
	outputToArray([9, (lastX - X_OFFSET), (lastY - Y_OFFSET)]); //TODO:
	outputToArray([DRAW_PENCIL, (lastX - X_OFFSET), (lastY - Y_OFFSET)]);
}

function getCanvasLayerData() {
	return context.getImageData(0, 0, paintCanvas.width, paintCanvas.height);
}

const draw = event => {
	if (isPaintBucket) {
		return;
	}
	if (!isDrawing) {
		return;
	}
	if (isViewing) {
		return;
	}

	if (getInkUsed() >= OUTPUT_MAX) {
		return;
	}

	const rect = paintCanvas.getBoundingClientRect();

	x = Math.floor(
		(event.clientX - rect.left) * 195 / rect.width
	);

	y = Math.floor(
		(event.clientY - rect.top) * 175 / rect.height
	);

	if (x < 0) {
		x = 0;
	}
	if (x > 255 + X_OFFSET) {
		x = 255 + X_OFFSET;
	}

	if (y < 0) {
		y = 0;
	}
	if (y > 255 + Y_OFFSET) {
		y = 255 + Y_OFFSET;
	}

	if (
		event.clientX >= rect.left &&
		event.clientX < rect.right &&
		event.clientY >= rect.top &&
		event.clientY < rect.bottom
	) {
		drawLine(lastX, lastY, x, y);
		if (x != lastX || y != lastY) {
			outputToArray([1, (x - X_OFFSET), (y - Y_OFFSET)]);
		}


		if (getInkUsed() >= OUTPUT_MAX) {
			outputToArray([6, (x - X_OFFSET), (y - Y_OFFSET)]);
		}
	}

	lastX = x;
	lastY = y;
}

paintCanvas.addEventListener('mousedown', startDrawing);
document.addEventListener('mousemove', draw);
document.addEventListener('mouseup', stopDrawing);

paintCanvas.addEventListener("touchstart", startDrawing);
document.addEventListener("touchmove", draw);
document.addEventListener("touchend", stopDrawing);

document.getElementById("save").addEventListener("click", () => {
	const bytes = new Uint8Array(outputArray);

	const blob = new Blob([bytes], {
		type: "application/octet-stream"
	});

	const link = document.createElement("a");
	link.href = URL.createObjectURL(blob);
	link.download = "0000.PIQ";
	link.click();

	URL.revokeObjectURL(link.href);
});

function onLoad() {
	resetCanvas();
	setTool(0);
	setDrawScale(1);
	setDrawColor(0);
	lastColorUsed = 0;
	lastScaleUsed = 0;
}

submit_button.addEventListener("click", async function () {
	const submitButton = document.getElementById("submit");

	submitButton.disabled = true;

	const imageData = paintCanvas.toDataURL("image/png");
	const blob = await (await fetch(imageData)).blob();
	const formData = new FormData();
	formData.append("image", blob, "drawing.png");

	try {
		const googleFormData = new FormData();
		const csvRow = `"${outputArray.join(".")}"`;

		let username = prompt("Please enter your name", "Anonymous");
		let art_name = prompt("What is your drawing of?", "");

		if (username && art_name) {
			googleFormData.append(ENTRY_ID, csvRow);
			googleFormData.append(ENTRY_ID_USER, username);
			googleFormData.append(ENTRY_ID_PROMPT, art_name);

			await fetch(GOOGLE_FORM_URL, {
				method: "POST",
				body: googleFormData,
				mode: "no-cors",
			});

			alert("Upload Successful");
			location.reload();
		}


	} catch (error) {
		console.error(error);
		alert("Error submitting to Google Form.");
	} finally {
		submitButton.disabled = false;
	}
});

async function fetchImages() {
	try {
		const response = await fetch(GOOGLE_SHEET_URL);
		const csvText = await response.text();
		const rows = csvText.split("\n").slice(1);

		const gallery = document.getElementById("gallery");
		gallery.innerHTML = "";

		i = 0;
		for (const row of rows.reverse()) {
			const columns = row.split(",");
			if (columns.length < 2) return;

			const timestamp = columns[0].trim().split(" ")[0];
			const piqdata_value = columns[2];
			const piqdata = piqdata_value.replace(/['"]+/g, '').split(".").map(Number);

			const user = columns[3].trim();
			const prompt = columns[4].trim();
			const user_url = columns[5].trim();
			const is_verified_value = columns[6].trim();
			const is_verified = is_verified_value == "TRUE";

			if (is_verified) {
				const div = document.createElement("div");

				let user_field = user;

				if (user_url) {
					user_field = `<a href="${user_url}">${user}</a>`
				}

				div.innerHTML = `
                    <canvas id="canvas_${i}" width="${CANVAS_WIDTH}" height="${CANVAS_HEIGHT} alt="drawing"></canvas>
                    <p style="text-align:center;margin-top:0;margin-bottom:30px;margin-left:30px;">"${prompt}"<br/>
                    ${user_field}<br/>
                    ${timestamp}</p>
                `;
				gallery.appendChild(div);

				const cnvs = document.getElementById("canvas_" + i);

				cnvs.piqdata = piqdata;

				cnvs.addEventListener("click", () => {
					if (!isAnimating) {
						isAnimating = true;
						const cntx = cnvs.getContext("2d");
						cntx.clearRect(0, 0, cnvs.width, cnvs.height);
						dwnlViewDrawing(cnvs, cnvs.piqdata, 3);
					}

				});

				getCanvasState(cnvs);

				await dwnlViewDrawing(cnvs, piqdata);
			}

			i += 1;
		}
	} catch (error) {
		console.error("Error fetching images:", error);
		document.getElementById("gallery").textContent = "Failed to load images.";
	}
}

fetchImages();

const dwnlViewDrawing = async (cnv, piq_data, delay = 0) => {
	const state = getCanvasState(cnv);
	let this_x = 0;
	let this_y = 0;

	state.drawScale = 2;
	state.previousX = 0;
	state.previousY = 0;

	const cntx = cnv.getContext("2d");
	inst = 0;
	while (inst < (piq_data.length - 8) / 3) {
		let param_1 = piq_data[(inst * 3) + 8];
		let param_2 = piq_data[(inst * 3) + 8 + 1];
		let param_3 = piq_data[(inst * 3) + 8 + 2];

		switch (param_1) {
			case 1: // Draw
				this_x = param_2 + X_OFFSET;
				this_y = param_3 + Y_OFFSET;
				if (state.previousX != 0) {
					dwnlDrawLine(cntx, state, this_x, this_y);
				} else {
					dwnlPencilDraw(cntx, state, this_x, this_y);
				}
				state.previousX = this_x;
				state.previousY = this_y;
				break;
			case 2: //Paint Bucket
				this_x = param_2 + X_OFFSET;
				this_y = param_3 + Y_OFFSET;
				str = cntx.fillStyle.replace('#', '0x') + "FF";
				floodFill(cntx, this_x, this_y, str);
				break;
			case 3:
				break;
			case 6:
				break;
			case 7: // Change Color
				dwnlSetColor(cntx, param_2);
				break;
			case 8: // Change Size
				state.drawScale = param_2 + 1;
				break;
			case 9:
				state.previousX = 0;
				state.previousY = 0;
				break;
			default:
				break;
		}

		if (delay > 0) {
			await sleep(delay);
		}
		inst++;

	}
	isAnimating = false;
};

function dwnlDrawLine(ctxt, state, x1, y1) {
	x0 = state.previousX;
	y0 = state.previousY;
	let dx = Math.abs(x1 - x0);
	let dy = Math.abs(y1 - y0);

	let sx = x0 < x1 ? 1 : -1;
	let sy = y0 < y1 ? 1 : -1;

	let err = dx - dy;

	while (true) {
		dwnlCanvasDrawRect(ctxt, state, x0, y0);

		if (x0 === x1 && y0 === y1) {
			break;
		}

		const e2 = 2 * err;

		if (e2 > -dy) {
			err -= dy;
			x0 += sx;
		}

		if (e2 < dx) {
			err += dx;
			y0 += sy;
		}
	}
}

function dwnlSetColor(cntx, i) {
	cntx.fillStyle = COLORS[i];
}

function dwnlCanvasDrawRect(cntx, s, x, y) {
	dwnlPencilDraw(cntx, s, x, y);
}

function dwnlPencilDraw(cntx, state, x, y) {
	switch (state.drawScale) {
		case 1:
			cntx.fillRect(x, y, 2, 2);
			break;
		case 2:
			cntx.fillRect(x + 1, y, 1, 1);
			cntx.fillRect(x, y + 1, 1, 1);
			cntx.fillRect(x - 1, y, 1, 1);
			cntx.fillRect(x, y - 1, 1, 1);
			cntx.fillRect(x, y, 1, 1);
			break;
		case 3:
			cntx.fillRect(x, y, 2, 2);

			cntx.fillRect(x, y - 1, 2, 2);
			cntx.fillRect(x - 1, y, 2, 2);
			cntx.fillRect(x, y + 1, 2, 2);
			cntx.fillRect(x + 1, y, 2, 2);
			break;
		case 4:
			cntx.fillRect(x - 1, y - 1, 6, 6);

			cntx.fillRect(x, y - 2, 4, 4);
			cntx.fillRect(x - 2, y, 4, 4);
			cntx.fillRect(x, y + 2, 4, 4);
			cntx.fillRect(x + 2, y, 4, 4);
			break;
	}
}

function getPixel(pixelData, x, y) {
	if (x < 0 || y < 0 || x >= pixelData.width || y >= pixelData.height) {
		return -1;  // impossible color
	} else {
		return pixelData.data[y * pixelData.width + x];
	}
}

function floodFill(ctx, x, y, fillColor) {
	// read the pixels in the canvas
	const imageData = ctx.getImageData(0, 0, ctx.canvas.width, ctx.canvas.height);

	// make a Uint32Array view on the pixels so we can manipulate pixels
	// one 32bit value at a time instead of as 4 bytes per pixel
	const pixelData = {
		width: imageData.width,
		height: imageData.height,
		data: new Uint32Array(imageData.data.buffer),
	};

	// get the color we're filling
	const targetColor = getPixel(pixelData, x, y);

	// check we are actually filling a different color
	if (targetColor !== fillColor) {

		const pixelsToCheck = [x, y];
		while (pixelsToCheck.length > 0) {
			const y = pixelsToCheck.pop();
			const x = pixelsToCheck.pop();

			const currentColor = getPixel(pixelData, x, y);
			if (currentColor === targetColor) {
				pixelData.data[y * pixelData.width + x] = fillColor;
				ctx.fillRect(x, y, 1, 1);

				pixelsToCheck.push(x + 1, y);
				pixelsToCheck.push(x - 1, y);
				pixelsToCheck.push(x, y + 1);
				pixelsToCheck.push(x, y - 1);
			}
		}
	}
}
