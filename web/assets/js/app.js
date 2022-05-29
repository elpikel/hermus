// We import the CSS which is extracted to its own file by esbuild.
// Remove this line if you add a your own CSS build pipeline (e.g postcss).
import "../css/app.css"
// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"
import topbar from "../vendor/topbar"
import Chart from 'chart.js/auto';

let Hooks = {};
Hooks.Chart = {
    devices() { return JSON.parse(this.el.dataset.devices);},
    labels() { return [...Array(20).keys()]; },
    datasets(devices) { return devices.map(device => {
        return {
            id: device.id,
            label: device.name,
            borderColor: 'rgb(255, 99, 132)',
            data: device.probes.map(device => device.pm10)
        };
    });
    },
    mounted() {
        let ctx = document.getElementById("probeChart").getContext('2d');
        let chart = new Chart(ctx, {
            type: 'line',
            data: {
                labels: this.labels(),
                datasets: this.datasets(this.devices())
            },
            options: {}
        });

        this.handleEvent("probe", (data) => {
            const datasetIndex = chart.data.datasets.findIndex(dataset => dataset.id == data.device_id);
            chart.data.datasets[datasetIndex].data.pop();
            chart.data.datasets[datasetIndex].data.unshift(data.pm10);

            chart.update();
        });
    }
};

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {hooks: Hooks, params: {_csrf_token: csrfToken}})

// Show progress bar on live navigation and form submits
topbar.config({barColors: {0: "#29d"}, shadowColor: "rgba(0, 0, 0, .3)"})
window.addEventListener("phx:page-loading-start", info => topbar.show())
window.addEventListener("phx:page-loading-stop", info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

