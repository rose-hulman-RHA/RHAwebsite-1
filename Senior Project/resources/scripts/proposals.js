

function addProposal() {
    var modal = document.getElementById('editModal');
    var span = document.getElementsByClassName("closeEdit")[0];

    var name = "Event name: ";
    var costToAttendee = "Cost to attendee: ";
    var image = "Image: ";
    var description = "Description: ";
    var signUpOpenDate = "Sign-up open date: ";
    var eventDate = "Event date: ";
    var signUpCloseDate = "Sign-up close date: ";
    var proposer = "Proposer: ";

    var nameInput = document.createElement("textarea");
    nameInput.setAttribute("rows", "1");
    nameInput.setAttribute("cols", "30");

    var costToAttendeeInput = document.createElement("textarea");
    costToAttendeeInput.setAttribute("rows", "1");
    costToAttendeeInput.setAttribute("cols", "30");

    var imageInput = document.createElement("textarea");
    imageInput.setAttribute("rows", "1");
    imageInput.setAttribute("cols", "30");

    var descriptionInput = document.createElement("textarea");
    descriptionInput.setAttribute("rows", "4");
    descriptionInput.setAttribute("cols", "30");

    var signUpOpenDateInput = document.createElement("textarea");
    signUpOpenDateInput.setAttribute("rows", "1");
    signUpOpenDateInput.setAttribute("cols", "30");

    var eventDateInput = document.createElement("textarea");
    eventDateInput.setAttribute("rows", "1");
    eventDateInput.setAttribute("cols", "30");

    var signUpCloseDateInput = document.createElement("textarea");
    signUpCloseDateInput.setAttribute("rows", "1");
    signUpCloseDateInput.setAttribute("cols", "30");

    var proposerInput = document.createElement("textarea");
    proposerInput.setAttribute("rows", "1");
    proposerInput.setAttribute("cols", "30");

    var nameNode = document.getElementById("nameInput");
    var costToAttendeeNode = document.getElementById("costToAttendeeInput");
    var imageNode = document.getElementById("imageInput");
    var descriptionNode = document.getElementById("descriptionInput");
    var signUpOpenDateNode = document.getElementById("signUpOpenDateInput");
    var eventDateNode = document.getElementById("eventDateInput");
    var signUpCloseDateNode = document.getElementById("signUpCloseDateInput");
    var proposerNode = document.getElementById("proposerInput");


    document.getElementById("name").innerHTML = name;
    nameNode.appendChild(nameInput);
    document.getElementById("costToAttendee").innerHTML = costToAttendee;
    costToAttendeeNode.appendChild(costToAttendeeInput);
    document.getElementById("image").innerHTML = image;
    imageNode.appendChild(imageInput);
    document.getElementById("description").innerHTML = description;
    descriptionNode.appendChild(descriptionInput);
    document.getElementById("signUpOpenDate").innerHTML = signUpOpenDate;
    signUpOpenDateNode.appendChild(signUpOpenDateInput);
    document.getElementById("eventDate").innerHTML = eventDate;
    eventDateNode.appendChild(eventDateInput);
    document.getElementById("signUpCloseDate").innerHTML = signUpCloseDate;
    signUpCloseDateNode.appendChild(signUpCloseDateInput);
    document.getElementById("proposer").innerHTML = proposer;
    proposerNode.appendChild(proposerInput);


    modal.style.display = "block";
    span.onclick = function () {
        modal.style.display = "none";
        nameNode.removeChild(nameNode.firstChild);
        costToAttendeeNode.removeChild(costToAttendeeNode.firstChild);
        imageNode.removeChild(imageNode.firstChild);
        descriptionNode.removeChild(descriptionNode.firstChild);
        signUpOpenDateNode.removeChild(signUpOpenDateNode.firstChild);
        eventDateNode.removeChild(eventDateNode.firstChild);
        signUpCloseDateNode.removeChild(signUpCloseDateNode.firstChild);
        proposerNode.removeChild(proposerNode.firstChild);

    }
    window.onclick = function (event) {
        if (event.target == modal) {
            modal.style.display = "none";
            nameNode.removeChild(nameNode.firstChild);
            costToAttendeeNode.removeChild(costToAttendeeNode.firstChild);
            imageNode.removeChild(imageNode.firstChild);
            descriptionNode.removeChild(descriptionNode.firstChild);
            signUpOpenDateNode.removeChild(signUpOpenDateNode.firstChild);
            eventDateNode.removeChild(eventDateNode.firstChild);
            signUpCloseDateNode.removeChild(signUpCloseDateNode.firstChild);
            proposerNode.removeChild(proposerNode.firstChild);
        }
    }
}