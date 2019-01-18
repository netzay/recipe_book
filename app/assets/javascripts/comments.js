$(() => {
	// console.log('commentsjs loaded');
	allComments()
	newCommentForm()

})

const allComments = () => {
	$('a.all_comments').on('click', (e) => {
		e.preventDefault()
		let url = e.target.href
		getIndexComments(url)
	})

}


const getIndexComments = (url) => {
	let newUrl = url + '.json'
	fetch(newUrl)
	.then(res => res.json()
		.then(comments => {
			$('#app-container').html('')
			comments.forEach((comment) => {
				let newComment = new Comment(comment)
				let commentHtml = newComment.formatShow()
				$('div#app-container').append(commentHtml)
				showComment()


			})
		})
	)
}

const newCommentForm = () => {
	$('a.new_comment').on('click', (event) => {
		event.preventDefault()
		event.stopPropagation()

		// let url = 'http://localhost:3000/ajax_new'
		let url = event.target.href

		$.ajax({
			url: url,
			method: 'get'
		}).done(function (htmlData) {
			$('div#comment_form').html(htmlData)
			createComment()
		})
	})
}

const createComment = () => {
	$('form#new_comment').on('submit', (event) => {
		event.preventDefault()
		event.stopPropagation()
		let data = $('form#new_comment').serialize()
		let url = event.target.baseURI + '/comments'

		$.ajax({
			url: url,
			method: 'post',
			data: data
		}).done(function (response) {
			let newComment = new Comment(response)
			let commentHtml = newComment.formatShow()
			$('div#new_comment_response').append(commentHtml)
			$('form#new_comment').remove()
		})
	})
}

const showComment = () => {
	console.log("showComment")
	$('a#a_comment').on('click', (event) => {
		event.preventDefault()	
		let url = event.target.href
		console.log(url)
		fetch(url)
		.then(res => res.json()
			.then(comment => {
				$('#app-container').html('')
				comments.forEach((comment) => {
					let newComment = new Comment(comment)
					let commentHtml = newComment.formatIndex()
					$('div#app-container').append(commentHtml)

				})
			})
		)
	})
}


class Comment {
	constructor(commentObj) {
		this.id = commentObj.id
		this.title = commentObj.title
		this.content = commentObj.content
		this.user = commentObj.user
		this.recipe = commentObj.recipe.id
	}
}
Comment.prototype.formatShow = function () {

	let commentHtml = `
	<a href= "/recipes/${this.recipe}/comments/${this.id}" data-id="${this.id}" id= "a_comment"
	<h5>${this.title}</h5><br>
	`
	return commentHtml
}
Comment.prototype.formatIndex = function(){
	let commentHtml = `
	<h4>${this.title}</h4>
	<h4>${this.content}</h4>
	<h4>${this.user}</h4>
	`
	return commentHtml
}