export function get(url : string) : Promise<string> {
    let request = new XMLHttpRequest();

    request.open("GET", url, true);

    let promise = new Promise((resolve : (resp:string) => void, reject) => {
        request.onreadystatechange = () => {
            if (request.readyState == XMLHttpRequest.DONE) {
                if (request.status == 200) {
                    if (request.getResponseHeader("Content-Type") == "application/json") {
                        resolve(JSON.parse(request.responseText));
                    } else resolve(request.responseText);
                }
                else reject();
            }
        };
    });

    request.send();

    return promise;
}

export function post(url : string, data : string)  : Promise<string> {
    let request = new XMLHttpRequest();

    request.open("POST", url, true);

    request.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

    let promise = new Promise((resolve : (resp:string) => void, reject) => {
        request.onreadystatechange = () => {
            if (request.readyState == XMLHttpRequest.DONE) {
                if (request.status == 201) resolve(request.responseText);
                else reject();
            }
        };
    });

    request.send(data);

    return promise;
}