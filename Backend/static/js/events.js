document.addEventListener("DOMContentLoaded", function () {
    const events = [
        { title: "Ancient Ruins Tour", date: "2025-04-10", category: "Historical", location: "Mohenjo-daro" },
        { title: "Cultural Dance Festival", date: "2025-05-15", category: "Cultural", location: "Lahore Fort" },
        { title: "Archaeology Workshop", date: "2025-06-20", category: "Educational", location: "Taxila Museum" }
    ];

    const eventList = document.getElementById("eventList");
    const categoryFilter = document.getElementById("categoryFilter");

    function displayEvents(filteredEvents) {
        eventList.innerHTML = "";
        if (filteredEvents.length === 0) {
            eventList.innerHTML = "<p>No events found.</p>";
            return;
        }

        filteredEvents.forEach(event => {
            const eventCard = document.createElement("div");
            eventCard.classList.add("event-card");
            eventCard.innerHTML = `
                <h3>${event.title}</h3>
                <p><strong>Date:</strong> ${event.date}</p>
                <p><strong>Location:</strong> ${event.location}</p>
                <p><strong>Category:</strong> ${event.category}</p>
            `;
            eventList.appendChild(eventCard);
        });
    }

    categoryFilter.addEventListener("change", function () {
        const selectedCategory = categoryFilter.value;
        if (selectedCategory === "All") {
            displayEvents(events);
        } else {
            const filteredEvents = events.filter(event => event.category === selectedCategory);
            displayEvents(filteredEvents);
        }
    });

    displayEvents(events);
});
