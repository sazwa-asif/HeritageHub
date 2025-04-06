document.addEventListener("DOMContentLoaded", async function () {
    try {
        const response = await fetch("/api/visitor-analytics");
        const data = await response.json();

        if (!data || data.length === 0) {
            console.error("No data received for visitor analytics.");
            return;
        }

        let labels = data.map(d => d.date);
        let visits = data.map(d => d.count);

        new Chart(document.getElementById("visitorChart"), {
            type: "line",
            data: {
                labels: labels,
                datasets: [{
                    label: "Daily Visits",
                    data: visits,
                    borderColor: "blue",
                    borderWidth: 2,
                    fill: false
                }]
            }
        });
    } catch (error) {
        console.error("Error fetching visitor analytics:", error);
    }
});
