// Copyright (c) 2020 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/stringutils;
import ballerina/test;

@test:Config {}
function testParseEncryptedPrivateKeyFromP12() {
    KeyStore keyStore = {
        path: "src/crypto/tests/resources/datafiles/testKeystore.p12",
        password: "ballerina"
    };
    PrivateKey|Error result = decodePrivateKey(keyStore, "ballerina", "ballerina");
    if (result is PrivateKey) {
        test:assertEquals(result["algorithm"], "RSA");
    } else {
        test:assertFail(msg = "Error while decoding encrypted private-key from a p12 file. " + result.message());
    }
}

@test:Config {}
function testReadPrivateKeyFromNonExistingP12() {
    KeyStore keyStore = {
        path: "src/crypto/tests/resources/datafiles/testKeystore.p12.invalid",
        password: "ballerina"
    };
    PrivateKey|Error result = decodePrivateKey(keyStore, "ballerina", "ballerina");
    if (result is Error) {
        test:assertTrue(stringutils:contains(result.message(), "PKCS12 key store not found at:"),
            msg = "Incorrect error for reading private key from non existing p12 file.");
    } else {
        test:assertFail(msg = "No error while attempting to read a private key from a non-existing p12 file.");
    }
}
