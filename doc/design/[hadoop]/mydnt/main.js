var b=document.body;
b.addEventListener("click",checkSingleLink);
b.addEventListener("mousedown",checkSingleLink);
b.addEventListener("mouseover",checkSingleLink);

function checkSingleLink(evt) {
    var a=evt.target;

    if (a.tagName=="A") {
        a=[a];
    } else {
        a=[].slice.apply(a.getElementsByTagName("a"));
    }
    a.map(fixLink);
}
function fixLink(a) {
    if ((a.getAttribute("onmousedown")+"").indexOf("rwt(")>-1) {
		//a.onmousedown = null; 
		//a.setAttribute("onmousedown", " ");
        a.removeAttribute("onmousedown");
    }
}

setTimeout(function () {
    var input=document.getElementById("lst-ib");
    if (!input) {
        return setTimeout(arguments.callee,200);
    }
    input.addEventListener("keyup",function (evt) {
        if (evt instanceof KeyboardEvent && evt.keyIdentifier!=="Enter") {
            return;
        }
        delayCheckLinks();
    });
},200);

var tid;
function delayCheckLinks() {
    if (tid) {
        clearTimeout(tid);
    }
    tid=setTimeout(checkLinks,500);
}

function checkLinks() {
    var ires=document.getElementById("ires"),
        linksList=ires.getElementsByTagName("li"),
        cre=/\s*g\s*/,j,al,
        alist,a,i=0,l=l=linksList.length;
    for (;i<l;i++) {
        if (cre.test(linksList[i].className)) {
            alist=linksList[i].getElementsByTagName("a");
            al=alist.length;
            for (j=0;j<al;j++) {
                fixLink(alist[j]);
            }
            
        }
    }
}
