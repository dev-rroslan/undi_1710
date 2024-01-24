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

// assets/js/app.js
let Hooks = {}

Hooks.Chart = {
    mounted() {
        const chartConfig = JSON.parse(this.el.dataset.config)
        const seriesData = JSON.parse(this.el.dataset.series)
        const categoriesData = JSON.parse(this.el.dataset.categories)
        const questionData = JSON.parse(this.el.dataset.question)
        console.log(seriesData)
        const options = {
            chart: Object.assign({
                background: 'transparent',
            }, chartConfig),
            series: seriesData,
            xaxis: {
                categories: categoriesData
            },
            height: window.innerWidth < 768 ? 300 : 500, // Adjust for smaller screens
            responsive: [{
                breakpoint: 768,
                options: {
                    chart: {
                        width: '100%', // Ensure full width on smaller screens
                        height: '100%', // Ensure full width on smaller screens
                    },
                },
            }],
             tooltip: {
            custom: function({ series, seriesIndex, dataPointIndex, w }) {
                const globalDataPointIndex = seriesIndex * categoriesData.length + dataPointIndex;
                const question = questionData[globalDataPointIndex];

                const questionDetails = Object.entries(question)
                    .map(([key, value]) => {
                        const capitalizedKey = key
                            .split('_')
                            .map(word => word.charAt(0).toUpperCase() + word.slice(1))
                            .join(' ');

                        const keyColor = {
                            sokong_fedaral: 'text-red-500',
                            sokong_negeri: 'text-blue-400',
                            datar_padu: 'text-green-500',
                        }[key] || ''; // Retrieve color based on key

                        const translatedValue = Object.entries(value)
                            .map(([subKey, subValue]) => {
                                const translatedKey = subKey === 'no' ? 'tidak' : (subKey === 'yes' ? 'ya' : subKey);
                                return `${translatedKey}: ${subValue}`; // Use translatedKey and keep value as-is
                            })
                            .join('<br>');

                        return `<span class="capitalize font-bold ${keyColor}">${capitalizedKey}</span><br>${translatedValue}`;
                    })
                    .join('<br>');

                return (
                    '<div class="arrow_box">' +
                    questionDetails +
                    "</div>"
                );
            }
            }
        }

        const chart = new ApexCharts(this.el, options);

        chart.render();
        this.handleEvent("update-dataset", data => {

            const questionData = data.question

            chart.updateOptions({
                series: data.dataset,
                tooltip: {
                    custom: function ({series, seriesIndex, dataPointIndex, w}) {
                        const globalDataPointIndex = seriesIndex * categoriesData.length + dataPointIndex;
                        const question = questionData[globalDataPointIndex];

                        const questionDetails = Object.entries(question)
                            .map(([key, value]) => {
                                const capitalizedKey = key
                                    .split('_')
                                    .map(word => word.charAt(0).toUpperCase() + word.slice(1))
                                    .join(' ');

                                const translatedValue = Object.entries(value)
                                    .map(([subKey, subValue]) => {
                                        const translatedKey = subKey === 'no' ? 'tidak' : (subKey === 'yes' ? 'ya' : subKey);
                                        return `${translatedKey}: ${subValue}`; // Use translatedKey and keep value as-is
                                    })
                                    .join('<br>');

                                return `${capitalizedKey}<br>${translatedValue}`;
                            })
                            .join('<br>');

                        return (
                            '<div class="arrow_box">' +
                            questionDetails +
                            "</div>"
                        );
                    }
                }

            });
        })

    }
}

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {params: {_csrf_token: csrfToken}, hooks: Hooks})



// Show progress bar on live navigation and form submits
topbar.config({barColors: {0: "#29d"}, shadowColor: "rgba(0, 0, 0, .3)"})
window.addEventListener("phx:page-loading-start", _info => topbar.show(300))
window.addEventListener("phx:page-loading-stop", _info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

