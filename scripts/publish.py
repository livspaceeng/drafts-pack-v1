#!/usr/bin/env python
from shutil import copyfile
from string import Template

class MyTemplate(Template):
    delimiter = '%%'
    idpattern = r'[a-z][_a-z0-9]*'

langs = {
    "php" : {
        "jxAgentLabel" : "jenkins-python",
        "jxAgent" : "python",
        "aRoot" : ".",
        "bRoot" : ".",
    },
    "go" : {
        "jxAgentLabel" : "jenkins-go",
        "jxAgent" : "go",
        "aRoot" : "/home/jenkins/go/src",
        "bRoot" : "/home/jenkins/go/src/REPLACE_ME_GIT_PROVIDER/REPLACE_ME_APP_NAME",
    },
    "gradle" : {
        "jxAgentLabel" : "jenkins-gradle",
        "jxAgent" : "gradle",
        "aRoot" : ".",
        "bRoot" : ".",
    },
    "javascript" : {
        "jxAgentLabel" : "jenkins-nodejs",
        "jxAgent" : "nodejs",
        "aRoot" : ".",
        "bRoot" : ".",
    },
    "maven" : {
        "jxAgentLabel" : "jenkins-maven",
        "jxAgent" : "maven",
        "aRoot" : ".",
        "bRoot" : ".",
    },
    "python" : {
        "jxAgentLabel" : "jenkins-python",
        "jxAgent" : "python",
        "aRoot" : ".",
        "bRoot" : ".",
    },
    "scala" : {
        "jxAgentLabel" : "jenkins-scala",
        "jxAgent" : "scala",
        "aRoot" : ".",
        "bRoot" : ".",
    },
}


for i in langs:
    copyfile("./lang/skaffold.yaml", "../packs/" + i + "/skaffold.yaml")
    copyfile("./lang/charts/Makefile", "../packs/" + i + "/charts/Makefile")
    copyfile("./lang/charts/values.yaml", "../packs/" + i + "/charts/values.yaml")
    copyfile("./lang/charts/templates/configmap.yaml", "../packs/" + i + "/charts/templates/configmap.yaml")
    copyfile("./lang/charts/templates/service.yaml", "../packs/" + i + "/charts/templates/service.yaml")
    copyfile("./lang/charts/templates/deployment.yaml", "../packs/" + i + "/charts/templates/deployment.yaml")


    filein = open( './lang/Jenkinsfile' )
    src = MyTemplate( filein.read() )
    result = src.substitute(langs[i])
    filein.close()

    fileout = open("../packs/" + i + "/Jenkinsfile", "w")
    fileout.write(result);
    fileout.close()