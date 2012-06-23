// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.0
import QtMobility.organizer 1.1
import "logic.js" as Logic
import "month.js" as Month



Page {
    id: whatItem
    tools: whatTools
    property string startTime: "00:00";
    property string day ;
    property OrganizerModel organizer: calendarView.organizer;
    property date current; // new Date();
    property OrganizerItem selecteditem: null;
    property string description : "";
    property string location: "";
    property bool isNew: true;
    property Event item: null;


    function remove() {
        organizer.removeItem(item.itemId);
        //mainStack.pageStack.pop();
    }
    //color: "#ffffff"

    function save () {
        //descriptionTextArea.closeSoftwareInputPanel();
        descriptionTextArea.focus = false;

        if (item === null) {
            console.log("NULL");
            item1.description = descriptionTextArea.text;
            item1.location = locationTextField.text;
            item1.startDateTime = current;
            item = item1;

        }

        console.log("what = " + descriptionTextArea.text);

        item.description = descriptionTextArea.text;
        item.location = locationTextField.text;
        item.endDateTime = Month.plusMinutes(current, Month.getMinutes(durationSelectionDialog.selectedIndex));

        console.log("SELE " + durationSelectionDialog.selectedIndex);
        console.log("getminutes " + Month.getMinutes(durationSelectionDialog.selectedIndex));


        console.log("current " + item.startDateTime + " desc " +  item.description + " end " + item.endDateTime);

        if ( isNew )
            organizer.saveItem(item);
        else {
            item.save();

        }

        organizer.update();

        console.log("In save N ITEM " + organizer.itemCount);
        var items = organizer.items;
        var i;
        for (i = 0; i < organizer.itemCount;i++) {
            console.log("item " + i + " start date" + items[i].itemStartTime);
        }

        //mainStack.pageStack.pop();
    }


    Event {
        id: item1;
        startDateTime: current;
        description: descriptionTextArea.text;
        location: location;
        endDateTime: Month.plus1Hour(current);
    }

    SelectionDialog {
        id: durationSelectionDialog
        titleText: "Duration"
        //selectedIndex: 1

        model: ListModel {
            ListElement { duration: "0 minute" }
            ListElement { duration: "15 minutes" }
            ListElement { duration: "30 minutes" }
            ListElement { duration: "45 minutes" }
            ListElement { duration: "1 hour" }
            ListElement { duration: "2 hour" }
            ListElement { duration: "day" }
        }
    }

    TimePickerDialog {
        id:timePickerDialog
        titleText: "Select Time"
        acceptButtonText: "Confirm"
        rejectButtonText: "Reject"
        fields: DateTime.Hours | DateTime.Minutes
        anchors.fill: parent
        onAccepted: { startTime = timePickerDialog.hour + ":" + timePickerDialog.minute}
    }

    ToolBarLayout {
        id: whatTools
        visible: true

        ToolIcon {
            id: toolBack
            platformIconId: "toolbar-back"
            onClicked: mainStack.pageStack.pop()
        }

        ToolIcon {
            id: toolDone
            platformIconId: "toolbar-done"
            onClicked: {
                save()
                mainStack.pageStack.pop()
            }
        }

        ToolIcon {
            id: toolDelete
            enabled: !isNew
            opacity: enabled ? 1 : 0.5
            platformIconId: "toolbar-delete"
            onClicked: {
                remove()
                mainStack.pageStack.pop()
            }
        }
    }


    onStatusChanged: {
        console.log("STATUS CHANGED " + status + " " + PageStatus.Activating);
        if (status == 2) {
            console.log("page widht" + whatItem.width);
            descriptionTextArea.forceActiveFocus();
            if (item == null) {
                durationSelectionDialog.selectedIndex = 0;
                console.log("index = " + durationSelectionDialog.selectedIndex);
            }
            else {
                console.log("index = " + durationSelectionDialog.selectedIndex);
                durationSelectionDialog.selectedIndex = Month.calculateIndex(item.startDateTime, item.endDateTime);
            }
        }
    }


    Flickable {
        anchors.fill: parent
        contentHeight: content.height

        Column {
            id: content
            spacing: 12

            anchors{top: parent.top; left: parent.left; right: parent.right; margins: 15}

            Row {
                spacing: 10
                width: parent.width

                Text {
                    id: subjectText
                    anchors.verticalCenter: parent.verticalCenter
                    text: qsTr("Subject")
                    font.pixelSize: 28
                }

                TextField {
                    id: subjectTextField

                    anchors.left: subjectText.right
                    anchors.leftMargin: 10
                    anchors.right: parent.right

                    placeholderText: (item) ? item.subject : "Add Subject"
                    font.pixelSize: 28
                }
            }

            Rectangle {
                width: parent.width
                height: timeValue.height * 1.5
                radius: timeValue.height * 0.5

                color: "black"
                opacity: timeMouseArea.pressed ? 0.5 : 0.2

                Text {
                    id: timeText

                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter

                    text: qsTr("Start")
                    font.pixelSize: 28
                }

                Text {
                    id: timeDay

                    anchors.left: timeText.right
                    anchors.leftMargin: 10
                    anchors.verticalCenter: parent.verticalCenter

                    text: day
                    font.pixelSize: 28
                }

                Text {
                    id: timeValue

                    anchors.left: timeDay.right
                    anchors.leftMargin: 10
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter

                    text: startTime
                    font.pixelSize: 28
                }

                MouseArea{
                    id: timeMouseArea
                    anchors.fill: parent

                    onClicked: timePickerDialog.open()
                }
            }

            Rectangle {
                width: parent.width
                height: durationValue.height * 1.5
                radius: durationValue.height * 0.5

                color: "black"
                opacity: durationMouseArea.pressed ? 0.5 : 0.2

                Text {
                    id: durationText

                    anchors.verticalCenter: parent.verticalCenter

                    text: qsTr("Duration")
                    font.pixelSize: 28
                }

                Text {
                    id: durationValue

                    anchors.left: durationText.right
                    anchors.leftMargin: 10
                    anchors.right: parent.right

                    text: durationSelectionDialog.model.get(durationSelectionDialog.selectedIndex).duration
                    font.pixelSize: 28
                }

                MouseArea{
                    id: durationMouseArea
                    anchors.fill: parent

                    onClicked: durationSelectionDialog.open()
                }
            }

            Row {
                spacing: 10
                width: parent.width

                Text {
                    id: locationText
                    anchors.verticalCenter: parent.verticalCenter

                    text: qsTr("Location")
                    font.pixelSize: 28
                }

                TextField {
                    id: locationTextField

                    anchors.left: locationText.right
                    anchors.leftMargin: 10
                    anchors.right: parent.right

                    //text: (item) ? item.location : "Here"
                    placeholderText: (item) ? item.location : "Add Location"
                    font.pixelSize: 28
                    onActiveFocusChanged: {
                        if ( locationTextField.activeFocus ) {

                            text_w.color = "orange";
                            //locationTextField.openSoftwareInputPanel();
                        }
                        else   {
                            text_w.color= "black";
                            //locationTextField.closeSoftwareInputPanel();
                        }
                    }
                }
            }

            Row {
                spacing: 10
                width: parent.width

                Text {
                    id: descriptionText
                    anchors.verticalCenter: parent.verticalCenter
                    text: qsTr("Description")
                    font.pixelSize: 28
                }

                TextArea {
                    id: descriptionTextArea

                    anchors.left: descriptionText.right
                    anchors.leftMargin: 10
                    anchors.right: parent.right

                    //text: (item)?item.description:"Add description"
                    placeholderText: (item) ? item.description : "Add Description"

                    font.pixelSize: 28
                }
            }
        }
    }
}

