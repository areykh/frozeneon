const STATUS_SUCCESS = 'success';
const STATUS_ERROR = 'error';

Vue.component('comments', {
	props: ['post', 'comments',],
	template: `
	<div>
		<div class="card-text" v-for="comment in comments" :key="comment.id">
			<comment :post='post' :comment='comment'></comment>
		</div>
	</div>`
});

Vue.component('comment', {
	props: ['post', 'comment',],
	data: function() {
		return {
			likes: 0,
			commentText: '',
		}
	},
	template: `
	<div>
			<div class="container">
  			<div class="row">
					<div class="col">
						{{ comment.user.personaname + ' - ' }} <small class="text-muted">{{ domDecoder(comment.text) }}</small>
						<a role="button" @click="addLike(comment.id)">
								<template v-if="likes > 0">
									<svg class="bi bi-heart-fill" width="1em" height="1em" viewBox="0 0 16 16" fill="currentColor" xmlns="http://www.w3.org/2000/svg">
										<path fill-rule="evenodd" d="M8 1.314C12.438-3.248 23.534 4.735 8 15-7.534 4.736 3.562-3.248 8 1.314z" clip-rule="evenodd"/>
									</svg>
									{{ likes }}
								</template>
								<template v-else>
									<svg class="bi bi-heart" width="1em" height="1em" viewBox="0 0 16 16" fill="currentColor" xmlns="http://www.w3.org/2000/svg">
										<path fill-rule="evenodd" d="M8 2.748l-.717-.737C5.6.281 2.514.878 1.4 3.053c-.523 1.023-.641 2.5.314 4.385.92 1.815 2.834 3.989 6.286 6.357 3.452-2.368 5.365-4.542 6.286-6.357.955-1.886.838-3.362.314-4.385C13.486.878 10.4.28 8.717 2.01L8 2.748zM8 15C-7.333 4.868 3.279-3.04 7.824 1.143c.06.055.119.112.176.171a3.12 3.12 0 01.176-.17C12.72-3.042 23.333 4.867 8 15z" clip-rule="evenodd"/>
									</svg>
									{{ comment.likes }}
								</template>
						</a>
					</div>
					<div class="col">
						<form class="form-inline">
							<div class="form-group">
								<input type="text" class="form-control" v-model="commentText">
							</div>
							<button type="button" class="btn btn-primary" @click="addComment(post.id, comment.id, commentText)">Reply comment</button>
						</form>
					</div>
				</div>
			</div>
			<hr>
			<div class="offset-md-1 md-11">
				<comments :post='post' :comments='comment.comments'></comments>
			</div>
	</div>`,
	methods: {
		addComment: function (id, reply_id, text) {
			app.addComment(id, reply_id, text);
			this.commentText = '';
		},
		addLike: function(id) {
			var self = this;
			const url = '/main_page/like_comment/' + id;
			axios.get(url).then(function(response) {
				if (response.data.status === STATUS_ERROR) {
					self.showError(response);
					return;
				}
				self.likes = response.data.likes;
				app.refreshLikeBalance();
			});
		},
		domDecoder(str) {
			let parser = new DOMParser();
			let dom = parser.parseFromString('<!doctype html><body>' + str,
					'text/html');
			return dom.body.textContent;
		},
	},
});

var app = new Vue({
	el: '#app',
	data: {
		login: '',
		pass: '',
		post: false,
		invalidLogin: false,
		invalidPass: false,
		invalidSum: false,
		posts: [],
		addSum: 0,
		amount: 0,
		likes: 0,
		commentText: '',
		boosterpacks: [],
		analytics: [],
		like_balance: 0,
	},
	computed: {
		test: function () {
			var data = [];
			return data;
		}
	},
	created(){
		var self = this
		axios
		.get('/main_page/get_all_posts')
		.then(function (response) {
			self.posts = response.data.posts;
		})

		axios
		.get('/main_page/get_boosterpacks')
		.then(function (response) {
			if(response.data.status === STATUS_ERROR){
				self.showError(response);
				return;
			}
			self.boosterpacks = response.data.boosterpacks;
		})

		this.refreshLikeBalance();
	},
	methods: {
		logout: function () {
			console.log ('logout');
		},
		logIn: function () {
			var self= this;
			if(self.login === ''){
				self.invalidLogin = true
			}
			else if(self.pass === ''){
				self.invalidLogin = false
				self.invalidPass = true
			}
			else{
				self.invalidLogin = false
				self.invalidPass = false

				form = new FormData();
				form.append("login", self.login);
				form.append("password", self.pass);

				axios.post('/main_page/login', form)
				.then(function (response) {
					if(response.data.status === STATUS_ERROR){
						self.showError(response);
						return;
					}
					if(response.data.user) {
						location.reload();
					}
					self.hideModal('#loginModal');
				})
			}
		},
		addComment: function(id, reply_id, text) {
			if(!text){
				return;
			}
			var self= this;
			var comment = new FormData();
			comment.append('postId', id);
			comment.append('replyId', reply_id);
			comment.append('commentText', text);

			axios.post(
					'/main_page/comment',
					comment
			).then(function (response) {
				if(response.data.status === STATUS_ERROR){
					self.showError(response);
					return;
				}
				self.commentText = '';
				self.openPost(id);
			});
		},
		refill: function () {
			var self= this;
			if(self.addSum <= 0){
				self.invalidSum = true
			}
			else{
				self.invalidSum = false
				sum = new FormData();
				sum.append('sum', self.addSum);
				axios.post('/main_page/add_money', sum)
				.then(function (response) {
					if(response.data.status === STATUS_ERROR){
						self.showError(response);
						return;
					}
					self.hideModal('#addModal');
					self.addSum = 0;
				})
			}
		},
		openPost: function (id) {
			var self= this;
			axios
			.get('/main_page/get_post/' + id)
			.then(function (response) {
				if(response.data.status === STATUS_ERROR){
					self.showError(response);
					return;
				}
				self.likes = 0;
				self.commentText = '';
				self.post = response.data.post;
				if(self.post){
					self.showModal('#postModal');
				}
			})
		},
		addLike: function (id) {
			var self = this;
			const url = '/main_page/like_post/' + id;
			axios
			.get(url)
			.then(function (response) {
				if(response.data.status === STATUS_ERROR){
					self.showError(response);
					return;
				}
				self.likes = response.data.likes;
				self.refreshLikeBalance();
			})
		},
		buyPack: function (id) {
			var self= this;
			var pack = new FormData();
			pack.append('id', id);
			axios.post('/main_page/buy_boosterpack', pack)
			.then(function (response) {
				if(response.data.status === STATUS_ERROR){
					self.showError(response);
					return;
				}
				self.amount = response.data.amount;
				if(self.amount !== 0){
					self.showModal('#amountModal');
					self.refreshLikeBalance();
				}
			})
		},
		refreshLikeBalance: function() {
			var self = this;
			axios
			.get('/main_page/get_like_balance/')
			.then(function (response) {
				if(response.data.status === STATUS_ERROR){
					self.showError(response);
					return;
				}
				self.like_balance = response.data.amount;
			})
		},
		getAnalytics: function(){
			var self= this;
			axios
			.get('/main_page/get_analytics')
			.then(function (response) {
				if(response.data.status === STATUS_ERROR){
					self.showError(response);
					return;
				}
				self.analytics = response.data;
				if(self.analytics){
					self.showModal('#analyticsModal');
				}
			})
		},
		showModal: function (model_id) {
			setTimeout(function () {
				$(model_id).modal('show');
			}, 500);
		},
		hideModal: function (model_id) {
			setTimeout(function () {
				$(model_id).modal('hide');
			}, 500);
		},
		showError: function (response) {
			// console.log(response);
			// alert(response.data.error_message);
		}
	}
});