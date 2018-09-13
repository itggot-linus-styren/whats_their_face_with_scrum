function shuffle(a) {
    for (let i = a.length - 1; i > 0; i--) {
        const j = Math.floor(Math.random() * (i + 1));
        [a[i], a[j]] = [a[j], a[i]];
    }
    return a;
}

Vue.component("letter-button", {
    props: {
        letter: {
            type: String
        }
    },
    data() {
        return {
            disabled: false
        }
    },
    methods: {
        clicked() {
            this.disabled = true;
            this.$eventHub.$emit("hangman-check", this.letter);
        }
    },
    created() {
        this.$eventHub.$on('enable-all', () => {
            this.disabled = false;
        });
    },
    template:
        `
        <button class="keyboard-row-letter" :disabled="disabled" @click="clicked">{{letter}}</button>
        `
});

Vue.component('hangman-component', {
    props: {
        people: {
            type: Array
        }
    },
    data() {
        return {
            letters: [
                ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"],
                ["A", "S", "D", "F", "G", "H", "J", "K", "L"],
                ["Z", "X", "C", "V", "B", "N", "M"]
            ],
            word_divs: [],
            guesses: 0,
            game_over: false,
            game_init: false,
            next_game: false,
            first_name: "",
            person: undefined,
            canvas: "",
            ctx: ""
        }
    },
    methods: {
        drawGallows: function(ctx) {
			ctx.clearRect(0, 0, this.canvas.width, this.canvas.height);
			ctx.fillStyle = "#FF9800";
			ctx.strokeStyle = "#FF9800";
			ctx.beginPath();
			// left side
			ctx.moveTo(this.canvas.width / 10, this.canvas.height / 10);
			ctx.lineTo(this.canvas.width / 10, this.canvas.height * 0.95);
			// bottom side
			ctx.lineTo(this.canvas.width * 0.8, this.canvas.height * 0.95);
			// top side
			ctx.moveTo(this.canvas.width / 10, this.canvas.height / 10);
			ctx.lineTo(this.canvas.width * 0.4, this.canvas.height / 10);
			// hanging notch
			ctx.lineTo(this.canvas.width * 0.4, this.canvas.height / 5);
			ctx.stroke();
			ctx.closePath();
        },
        updateCanvas: function(ctx) {
			// this.drawGallows(ctx);
			// draw the head
			if (this.guesses === 0) {
				ctx.beginPath();
				ctx.arc(this.canvas.width * 0.4, (this.canvas.height / 5) + 20, 20, 0, 2 * Math.PI);
				ctx.stroke();
				ctx.closePath();
			} 
			// draw the torso
			else if (this.guesses === 1) {
				ctx.beginPath();
				ctx.moveTo(this.canvas.width * 0.4, (this.canvas.height / 5) + 40);
				ctx.lineTo(this.canvas.width * 0.4, this.canvas.height / 2);
				ctx.stroke();
				ctx.closePath();
			}
			// draw the right leg
			else if (this.guesses === 2) {
				ctx.beginPath();
				ctx.moveTo(this.canvas.width * 0.4, this.canvas.height / 2);
				ctx.lineTo((this.canvas.width * 0.4) + 30, this.canvas.height * 0.7);
				ctx.stroke();
				ctx.closePath();
			}
			// draw the left leg
			else if (this.guesses === 3) {
				ctx.beginPath();
				ctx.moveTo(this.canvas.width * 0.4, this.canvas.height / 2);
				ctx.lineTo((this.canvas.width * 0.4) - 30, this.canvas.height * 0.7);
				ctx.stroke();
				ctx.closePath();
			}
			// draw the right arm
			else if (this.guesses === 4) {
				ctx.beginPath();
				ctx.moveTo(this.canvas.width * 0.4, (this.canvas.height / 5) + 55);
				ctx.lineTo((this.canvas.width * 0.4) + 35, (this.canvas.height / 2) + 10);
				ctx.stroke();
				ctx.closePath();
			} 
			// draw the left arm and handle game over
			else if (this.guesses === 5) {
				ctx.beginPath();
				ctx.moveTo(this.canvas.width * 0.4, (this.canvas.height / 5) + 55);
				ctx.lineTo((this.canvas.width * 0.4) - 35, (this.canvas.height / 2) + 10);
				ctx.stroke();
				ctx.closePath();
				// game over
				ctx.font = "24px Roboto, sans-serif";
				ctx.fillText("Game Over", this.canvas.width * 0.4 - 30, this.canvas.height * 0.9);
				this.next_game = true;
				// fill in the word with the correct answer
				for (var i = 0; i < this.first_name.length; i++) {
					Vue.set(this.word_divs, i, this.first_name[i]);
				}
			}
			this.guesses++
        },
        next() {
            this.$eventHub.$emit("get-remaining", 1);          
        },
        replay() {
            this.game_over = false;
            this.$eventHub.$emit("start-game", this.people);
            this.$eventHub.$emit("get-remaining", 1);
        }
    },
    mounted() {
        this.canvas = this.$el.querySelector(".hangman-canvas");
        this.canvas.width = this.$el.querySelector(".hangman-board").offsetWidth;
        this.canvas.height = this.$el.querySelector(".hangman-board").offsetHeight;
        this.ctx = this.canvas.getContext("2d");
        this.ctx.lineWidth = 2;
        this.drawGallows(this.ctx);

        let new_letters = [];

        for (let i = 0; i < this.people.length; i++) {
            let other_name = this.people[i].name.toUpperCase().split(" ")[0];
            for (let j = 0; j < other_name.length; j++) {
                if (!this.letters.flat().includes(other_name[j])) new_letters.push(other_name[j]);
            }
        }

        if (new_letters.length > 0) {
            this.letters.push(new_letters);
        }
    },
    created() {
        this.$eventHub.$on('hangman-check', (letter) => {
            if (this.next_game) return;

            let guess_correct = false;

            // check if the letter is in the word, if so, fill it in
            for (let i = 0; i < this.first_name.length; i++) {
                if (letter == this.first_name[i]) {
                    Vue.set(this.word_divs, i, letter);
                    guess_correct = true;
                }
            }
            // if there are no more blanks in the word, you win
            if (!this.word_divs.some(function(value) {return value == ""})) {
                this.next_game = true;
                this.$eventHub.$emit("update-remaining", this.person);
                this.ctx.font = "24px Roboto, sans-serif";
                this.ctx.fillText("You Win!", this.canvas.width * 0.4 - 30, this.canvas.height * 0.9);
            }
            // if they guess wrong, draw the man
            if (!guess_correct) {
                this.updateCanvas(this.ctx);
            }
        });
        this.$eventHub.$on('post-remaining', (alternatives) => {
            this.word_divs = [];
            this.person = alternatives[0];
            this.first_name = alternatives[0].name.toUpperCase().split(" ")[0];
            console.log(this.first_name);
            for (let i = 0; i < this.first_name.length; i++) this.word_divs.push("");
            this.game_init = true;
            this.next_game = false;
            this.$eventHub.$emit("enable-all");
            console.log("game init");
        });
        this.$eventHub.$on('game-over', () => {
            this.game_over = true;
        });

        this.$eventHub.$emit("start-game", this.people);
        this.$eventHub.$emit("get-remaining", 1);
    },
    template:
        `
        <div class="hangman-component" v-if="game_init">
            <div v-if="game_over">
                <h1>Well done, you have guessed everyone correctly!</h1>
                <button @click="replay">Replay game</button>
            </div>
            <div class="hangman" v-if="!game_over">
                <div class="side-by-side">
                    <img :src="person.image_path"></img>
                    <div class="hangman-board">
                        <canvas class="hangman-canvas"></canvas>
                    </div>
                </div>
                <div class="hangman-word">
                    <div class="word-blankletter" v-for="letter in word_divs">{{letter}}</div>
                </div>
                <div class="hangman-keyboard">
                    <div v-for="row in letters" class="keyboard-row">
                        <letter-button v-for="letter in row" :letter="letter" :key="letter"></letter-button>
                    </div>
                </div>
                <button v-if="next_game" @click="next">Hang next person!</button>
            </div>
        </div>
        `
});

Vue.component(`card-component`, {
    props: {
        card: {
            type: Object
        },
        can_open: {
            type: Boolean
        }
    },
    data() {
        return {
            is_card_shown: false,
            is_card_matched: false
        }
    },
    methods: {
        flipCard() {
            if (!this.is_card_shown && this.can_open) {
                this.is_card_shown = true;
                this.$eventHub.$emit('flipCard', this);
            }
        },
        closeCard() {
            this.is_card_shown = false;
        },
        matchCard() {
            this.is_card_matched = true;
        }
    },
    template:
        `
        <div class="card-component" @click="flipCard" :class="{'card-outline': is_card_matched}">
            <div v-if="!card.is_image && is_card_shown" class="card_front person_name">{{card.name}}</div><img v-if="card.is_image && is_card_shown" :src="card.image_path" class="card_front"><img src="/cardback.png" class="card_back" v-if="!is_card_shown">
        </div>
        `
});

Vue.component(`chessboard-component`, {
    props: {
        people: {
            type: Array
        }
    },
    data() {
        return {
            cards: [],
            cards_open: [],
            can_open_card: true,
            match_card_count: 0,
            show_replay_button: false,
            game_init: false,
            game_over: false
        }
    },
    methods: {/*
        fetchCards() {
            let dup = this.people.slice(this.people);
            let alternatives = [];

            for (let i = 0; i < Math.min(this.people.length, 8); i++) {
                let index = Math.floor(Math.random() * dup.length);
                let removed = dup.splice(index, 1);
                alternatives.push(Object.assign({is_image: true}, removed[0]));
                alternatives.push(Object.assign({is_image: false}, removed[0]));
            }

            this.cards = shuffle(alternatives);
        },*/
        replay() {
            this.game_over = false;
            this.$eventHub.$emit("start-game", this.people);
            this.$eventHub.$emit("get-remaining", 8);
        },
        next() {
            this.$eventHub.$emit("get-remaining", 8);
        }
    },
    created() {
        this.$eventHub.$on('post-remaining', (alternatives) => {
            let other_alternatives = [];

            for (let i = 0; i < alternatives.length; i++) {
                other_alternatives.push(Object.assign({is_image: true}, alternatives[i]));
                other_alternatives.push(Object.assign({is_image: false}, alternatives[i]));
            }

            this.cards = shuffle(other_alternatives);
            this.game_init = true;
            console.log("game init");
        });
        this.$eventHub.$on('flipCard', (card) => {
            if (this.cards_open.push(card) >= 2) {
                this.can_open_card = false
                setTimeout(() => {
                    if (this.cards_open[0].card.id == this.cards_open[1].card.id) {
                        this.$eventHub.$emit("update-remaining", this.cards_open[0].card);
                        for (let open_card of this.cards_open) {
                            open_card.matchCard();
                            this.match_card_count += 1;                            
                            this.show_replay_button = this.match_card_count == this.cards.length;
                        }
                    } else {
                        for (let open_card of this.cards_open) {
                            open_card.closeCard();
                        }
                    }
                    this.cards_open = [];
                    this.can_open_card = true;
                }, 1000);
            }
        });
        this.$eventHub.$on('game-over', () => {
            this.game_over = true;
        });

        this.$eventHub.$emit("start-game", this.people);
        this.$eventHub.$emit("get-remaining", 8);
    },
    template:
        `
        <div class="chessboard-component" v-if="game_init">
            <div v-if="game_over">
                <h1>Well done, you have guessed everyone correctly!</h1>
                <button @click="replay">Replay game</button>
            </div>
            <div class="chessboard" v-if="!game_over">
                <card-component v-for="card in cards" :key="card.is_image ? \`card-image-\${card.id}\` : \`card-text-\${card.id}\`" :card="card" :can_open="can_open_card"></card-component>
                <p v-if="show_replay_button">Well done, you won this round!</p>
                <button v-if="show_replay_button" @click="next">Next people</button>
            </div>
        </div>
        `
});

Vue.component(`guess-component`, {
    props: {
        people: {
            type: Array
        },
        show_image: {
            type: Boolean
        }
    },
    data() {
        return {            
            person_index: 0,
            correct_person_id: 0,
            alternatives: [],
            has_guessed: false,
            game_over: false,
            game_init: false,
            message: ""
        }
    },
    methods: {/*
        fetchAlternatives() {
            this.remaining = shuffle(this.remaining);
            let that = this;          
            let dup = this.people.filter(function( obj ) {
                return obj.id !== that.remaining[0].id;
            });
            let alternatives = [];

            for (let i = 0; i < 3; i++) {
                let index = Math.floor(Math.random() * dup.length);
                let removed = dup.splice(index, 1);
                alternatives.push(removed[0]);
            }

            this.alternatives = alternatives;
            this.person_index = Math.floor(Math.random() * 4);
            this.alternatives.splice(this.person_index, 0, this.remaining[0]);
            this.correct_person_id = this.alternatives[this.person_index].id;
        },*/
        guess(person) {            
            if (person.id == this.correct_person_id) {
                this.$eventHub.$emit("update-remaining", person);
                this.message = `You are correct, it is ${person.name}!`;
            } else {
                this.message = `You guessed on ${person.name} but it is ${this.alternatives[this.person_index].name}!`;
            }

            this.has_guessed = true;
        },
        next() {
            this.$eventHub.$emit("get-alternatives", 4);
            this.has_guessed = false;
        },
        replay() {
            this.game_over = false;
            this.has_guessed = false;
            this.$eventHub.$emit("start-game", this.people);
            this.$eventHub.$emit("get-alternatives", 4);
        }
    },
    created() {
        this.$eventHub.$on('game-over', () => {
            this.game_over = true;
        });
        this.$eventHub.$on('post-remaining', (obj) => {
            this.alternatives = obj.alternatives;
            this.person_index = obj.person_index;
            this.correct_person_id = this.alternatives[this.person_index].id;
            this.game_init = true;
            console.log("game init");
        });
        this.$eventHub.$on('flipCard', (card) => {
            if (this.cards_open.push(card) >= 2) {
                this.can_open_card = false
                setTimeout(() => {
                    if (this.cards_open[0].card.id == this.cards_open[1].card.id) {
                        for (let open_card of this.cards_open) {
                            open_card.matchCard();
                            this.match_card_count += 1;
                            this.show_replay_button = this.match_card_count == this.cards.length;
                        }
                    } else {
                        for (let open_card of this.cards_open) {
                            open_card.closeCard();
                        }
                    }
                    this.cards_open = [];
                    this.can_open_card = true;
                }, 1000);
            }
        });

        this.$eventHub.$emit("start-game", this.people);
        this.$eventHub.$emit("get-alternatives", 4);
    },
    template:
        `
        <div class="slideshow-component" v-if="game_init">
            <div v-if="game_over">
                <h1>Well done, you have guessed everyone correctly!</h1>
                <button @click="replay">Replay game</button>
            </div>
            <div v-if="!has_guessed && !game_over">
                <img v-if="show_image" :src="alternatives[person_index].image_path">
                <h1 v-if="!show_image">{{alternatives[person_index].name}}</h1>
                <span v-for="alternative in alternatives">
                    <button @click="guess(alternative)">
                        <span v-if="show_image">{{alternative.name}}</span>
                        <img v-if="!show_image" :src="alternative.image_path">
                    </button>
                </span>
            </div>
            <div v-if="has_guessed && !game_over">
                <img :src="alternatives[person_index].image_path">
                <h2>{{message}}</h2>
                <button @click="next()">Next person</button>
            </div>
        </div>
        `
});

Vue.component(`slideshow-component`, {
    props: {
        people: {
            type: Array
        }
    },
    data() {
        return {
            person_index: 0,
            do_show_name: false
        }
    },
    methods: {
        nextPerson() {
            this.person_index += 1;
            if (this.person_index >= this.people.length) this.person_index = 0;
        }
    },
    template:
        `
        <div class="slideshow-component">
            <img @mouseover="do_show_name = true" @mouseleave="do_show_name = false" :src="people[person_index].image_path">
            <h1 :class="{transparent: true, opaque: do_show_name}">{{people[person_index].name}}</h1>            
            <button @click="nextPerson">Next!</button>
        </div>
        `
});

Vue.prototype.$eventHub = new Vue(); // Global event bus

var app = new Vue({
    el: '#app',
    data: {
        score: 0,
        correct: 0,
        total: 0,
        remaining: [],
        people: []
    },
    created() {
        let vue_that = this;
        this.$eventHub.$on('start-game', (people) => {
            this.people = people;
            this.remaining = this.people.slice(this.people);
            this.correct = 0;
            this.total = this.people.length;
        });
        this.$eventHub.$on('get-alternatives', (num_people) => {
            this.remaining = shuffle(this.remaining);
            let that = this;

            let dup = this.people.filter(function( obj ) {
                return obj.id !== that.remaining[0].id;
            });
            
            let alternatives = [];

            for (let i = 0; i < Math.min(this.people.length, num_people - 1); i++) {
                let index = Math.floor(Math.random() * dup.length);
                let removed = dup.splice(index, 1);
                alternatives.push(removed[0]);
            }

            person_index = Math.floor(Math.random() * Math.min(this.people.length, num_people));
            alternatives.splice(person_index, 0, this.remaining[0]);

            console.log("game alternativeas");

            vue_that.$eventHub.$emit("post-remaining", {alternatives: alternatives, person_index: person_index});
        });
        this.$eventHub.$on('get-remaining', (num_people) => {
            this.remaining = shuffle(this.remaining);
            let dup = this.remaining.slice(this.remaining);   
            let alternatives = [];

            for (let i = 0; i < Math.min(this.people.length, num_people); i++) {
                let index = Math.floor(Math.random() * dup.length);
                let removed = dup.splice(index, 1);
                alternatives.push(removed[0]);
            }

            vue_that.$eventHub.$emit("post-remaining", alternatives);
        });
        this.$eventHub.$on('update-remaining', (person) => {
            this.remaining = this.remaining.filter(function( obj ) {
                return obj.id !== person.id;
            });
            this.score += 1;
            this.correct = this.people.length - this.remaining.length;
            this.total = this.people.length;

            if (this.total == this.correct) {
                this.$eventHub.$emit("game-over");
            }
        });
    }
})