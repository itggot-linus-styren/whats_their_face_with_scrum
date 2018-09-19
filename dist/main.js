/******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};
/******/
/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {
/******/
/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId]) {
/******/ 			return installedModules[moduleId].exports;
/******/ 		}
/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			i: moduleId,
/******/ 			l: false,
/******/ 			exports: {}
/******/ 		};
/******/
/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);
/******/
/******/ 		// Flag the module as loaded
/******/ 		module.l = true;
/******/
/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}
/******/
/******/
/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;
/******/
/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;
/******/
/******/ 	// define getter function for harmony exports
/******/ 	__webpack_require__.d = function(exports, name, getter) {
/******/ 		if(!__webpack_require__.o(exports, name)) {
/******/ 			Object.defineProperty(exports, name, { enumerable: true, get: getter });
/******/ 		}
/******/ 	};
/******/
/******/ 	// define __esModule on exports
/******/ 	__webpack_require__.r = function(exports) {
/******/ 		if(typeof Symbol !== 'undefined' && Symbol.toStringTag) {
/******/ 			Object.defineProperty(exports, Symbol.toStringTag, { value: 'Module' });
/******/ 		}
/******/ 		Object.defineProperty(exports, '__esModule', { value: true });
/******/ 	};
/******/
/******/ 	// create a fake namespace object
/******/ 	// mode & 1: value is a module id, require it
/******/ 	// mode & 2: merge all properties of value into the ns
/******/ 	// mode & 4: return value when already ns object
/******/ 	// mode & 8|1: behave like require
/******/ 	__webpack_require__.t = function(value, mode) {
/******/ 		if(mode & 1) value = __webpack_require__(value);
/******/ 		if(mode & 8) return value;
/******/ 		if((mode & 4) && typeof value === 'object' && value && value.__esModule) return value;
/******/ 		var ns = Object.create(null);
/******/ 		__webpack_require__.r(ns);
/******/ 		Object.defineProperty(ns, 'default', { enumerable: true, value: value });
/******/ 		if(mode & 2 && typeof value != 'string') for(var key in value) __webpack_require__.d(ns, key, function(key) { return value[key]; }.bind(null, key));
/******/ 		return ns;
/******/ 	};
/******/
/******/ 	// getDefaultExport function for compatibility with non-harmony modules
/******/ 	__webpack_require__.n = function(module) {
/******/ 		var getter = module && module.__esModule ?
/******/ 			function getDefault() { return module['default']; } :
/******/ 			function getModuleExports() { return module; };
/******/ 		__webpack_require__.d(getter, 'a', getter);
/******/ 		return getter;
/******/ 	};
/******/
/******/ 	// Object.prototype.hasOwnProperty.call
/******/ 	__webpack_require__.o = function(object, property) { return Object.prototype.hasOwnProperty.call(object, property); };
/******/
/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "";
/******/
/******/
/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(__webpack_require__.s = "./src/index.ts");
/******/ })
/************************************************************************/
/******/ ({

/***/ "./src/ajax.ts":
/*!*********************!*\
  !*** ./src/ajax.ts ***!
  \*********************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";
eval("\nObject.defineProperty(exports, \"__esModule\", { value: true });\nfunction get(url) {\n    var request = new XMLHttpRequest();\n    request.open(\"GET\", url, true);\n    var promise = new Promise(function (resolve, reject) {\n        request.onreadystatechange = function () {\n            if (request.readyState == XMLHttpRequest.DONE) {\n                if (request.status == 200) {\n                    if (request.getResponseHeader(\"Content-Type\") == \"application/json\") {\n                        resolve(JSON.parse(request.responseText));\n                    }\n                    else\n                        resolve(request.responseText);\n                }\n                else\n                    reject();\n            }\n        };\n    });\n    request.send();\n    return promise;\n}\nexports.get = get;\nfunction post(url, data) {\n    var request = new XMLHttpRequest();\n    request.open(\"POST\", url, true);\n    request.setRequestHeader(\"Content-Type\", \"application/x-www-form-urlencoded\");\n    var promise = new Promise(function (resolve, reject) {\n        request.onreadystatechange = function () {\n            if (request.readyState == XMLHttpRequest.DONE) {\n                if (request.status == 201)\n                    resolve(request.responseText);\n                else\n                    reject();\n            }\n        };\n    });\n    request.send(data);\n    return promise;\n}\nexports.post = post;\n\n\n//# sourceURL=webpack:///./src/ajax.ts?");

/***/ }),

/***/ "./src/index.ts":
/*!**********************!*\
  !*** ./src/index.ts ***!
  \**********************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";
eval("\nObject.defineProperty(exports, \"__esModule\", { value: true });\nvar test_1 = __webpack_require__(/*! ./test */ \"./src/test.ts\");\nconsole.log(\"hello, world!\");\ntest_1.test();\n\n\n//# sourceURL=webpack:///./src/index.ts?");

/***/ }),

/***/ "./src/test.ts":
/*!*********************!*\
  !*** ./src/test.ts ***!
  \*********************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";
eval("\nvar __importStar = (this && this.__importStar) || function (mod) {\n    if (mod && mod.__esModule) return mod;\n    var result = {};\n    if (mod != null) for (var k in mod) if (Object.hasOwnProperty.call(mod, k)) result[k] = mod[k];\n    result[\"default\"] = mod;\n    return result;\n};\nObject.defineProperty(exports, \"__esModule\", { value: true });\nvar AJAX = __importStar(__webpack_require__(/*! ./ajax */ \"./src/ajax.ts\"));\nfunction test() {\n    console.log(\"test\");\n    AJAX.get(\"https://swapi.co/api/people/1\").then(function (resp) {\n        console.log(resp);\n    }).catch(function (reason) {\n        console.error(\"get response error\");\n        console.log(reason);\n    });\n    console.log(\"ser\");\n    AJAX.post(\"https://reqres.in/api/users\", \"name=test&age=10\").then(function (resp) {\n        console.log(resp);\n    }).catch(function (reason) {\n        console.error(\"post response error\");\n        console.log(reason);\n    });\n}\nexports.test = test;\n\n\n//# sourceURL=webpack:///./src/test.ts?");

/***/ })

/******/ });