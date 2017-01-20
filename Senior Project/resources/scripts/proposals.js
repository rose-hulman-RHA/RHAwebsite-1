function getOfficers() {
    var url = 'http://rha-website-1.csse.rose-hulman.edu:3000/api/v1/officers';
    function createCORSRequest(method, url) {
        var xhr = new XMLHttpRequest();
        if ("withCredentials" in xhr) {
            xhr.open(method, url, true);

        } else if (typeof XDomainRequest != "undefined") {
            xhr = new XDomainRequest();
            xhr.open(method, url);
        } else {
            xhr = null;
        }
        return xhr;
    }
    var xhr = createCORSRequest('GET', url);
    if (!xhr) {
        throw new Error('CORS not supported');
    }
    xhr.onload = function () {
    }
    xhr.onerror = function () {
        console.log("There was an error");
    }
    return xhr;
}

function setAdmin(officers) {
    if (userIsOfficer(officers)) {
        var addProposalButton = document.getElementById("addProposal");
        addProposalButton.style.display = "block";
    }
}


function setup() {

    var officersxhr = getOfficers();
    officersxhr.send();
    setTimeout(function () { setAdmin(officersxhr.responseText) }, 300);

    var createNewProposal = document.getElementById("addProposal");
}

function submit() {
    var photoAPIURL = location.protocol + '//' + location.hostname + (location.port ? ':' + location.port: '') + '/api/v1/eventPhoto';
    var photoxhr = new XMLHttpRequest();

    var dbAPIURL = 'http://rha-website-1.csse.rose-hulman.edu:3000/API/v1/proposal';

    var name = document.getElementById("name").value;
    var costToAttendee = document.getElementById("costToAttendee").value;
    var description = document.getElementById("description").value;
    var signUpOpenDate = document.getElementById("signUpOpenDate").value;
    var eventDate = document.getElementById("eventDate").value;
    var signUpCloseDate = document.getElementById("signUpCloseDate").value;
    var proposer = document.getElementById("proposer").value;
    var weekProposed = document.getElementById("weekProposed").value;
    var quarter = document.getElementById("quarterProposed").value;
    var moneyRequested = document.getElementById("moneyRequested").value;
    var approved = document.getElementById("approved").value;
    var moneyAllocated = document.getElementById("moneyAllocated").value;
    var files = document.getElementById("imageFile").files;


    var formData = new FormData();
    formData.append("imageFile", files[0]);
    photoxhr.open('POST', photoAPIURL, true);

    photoxhr.onreadystatechange = function (e) {
        console.log("I'm playing in the stateChange!");
        if(photoxhr.readyState == 4 && photoxhr.status == 200) {
            console.log("ReadyState was 4 and status 200!")
            var image_path = JSON.parse(photoxhr.responseText).filepath;
            var dbxhr = new XMLHttpRequest();
            var dbObject = {};
            dbObject["proposal_name"] = name;
            dbObject["cost_to_attendee"] = costToAttendee;
            dbObject["event_date"] = eventDate;
            dbObject["event_signup_open"] = signUpOpenDate;
            dbObject["event_signup_close"] = signUpCloseDate;
            dbObject["proposer"] = proposer;
            dbObject["week_proposed"] = weekProposed;
            dbObject["quarter_proposed"] = quarter;
            dbObject["money_requested"] = moneyRequested;
            dbObject["approved"] = approved;
            dbObject["money_allocated"] = moneyAllocated;
            dbObject["image_path"] = image_path;

            dbxhr.open('POST', dbAPIURL, true);
            dbxhr.setRequestHeader('Content-Type', 'application/json');
            dbxhr.onerror = function () {
                console.log("There was an error");
            }

            dbxhr.send(JSON.stringify(dbObject));
            
        }
    };

    photoxhr.send(formData);
    
    

}

$(document).ready(function() {
    setup();
});