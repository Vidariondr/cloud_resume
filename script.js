async function visitors() {
	const url = "https://api.jkaszczuk.com/visitors";
	try {
		const response = await fetch(url);
		if (!response.ok) {
			throw new Error(`Error with the server: ${response.status}`);
		}

		const result = await response.json();
		return result;
	} catch (error) {
		console.error(error.message);
		return error;
	}
}

let visitors_number;
const visitors_element = document.getElementById("counter");

visitors().then((result) => {
	visitors_number = result;
	visitors_element.textContent = visitors_number;
});
