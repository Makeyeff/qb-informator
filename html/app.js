const app = Vue.createApp({
    mounted() {
        this.listener = window.addEventListener("message", (event) => {
            switch (event.data.type) {
                case "audio":
                    this.playAudio(event.data)
                    break;
                default:
                    break;
            }
        })
    },
    beforeUnmount() {
        window.removeEventListener(this.listener);
    },
    methods: {
        playAudio(data) {
            var volume = (data.audio['volume'] / 10) * data.sfx
            if (data.distance !== 0) volume /= data.distance;
            if (volume > 1.0) volume = 1.0;
            const sound = new Audio('sounds/' + data.audio['file']);
            sound.volume = volume;
            sound.play();
        }
    }
}).mount('#mainContainer');
