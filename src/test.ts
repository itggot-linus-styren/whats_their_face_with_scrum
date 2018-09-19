import * as AJAX from './ajax'

function test() {
    console.log("test");
    AJAX.get("https://swapi.co/api/people/1").then((resp) => {
        console.log(resp);
    }).catch((reason) => {
        console.error("get response error");
        console.log(reason);
    })

    console.log("ser");

    AJAX.post("https://reqres.in/api/users", "name=test&age=10").then((resp) => {
        console.log(resp);
    }).catch((reason) => {
        console.error("post response error");
        console.log(reason);
    })
}

export {test}