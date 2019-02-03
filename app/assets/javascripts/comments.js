$(() => {
	allComments()
	newCommentForm()
})
const allComments = () => {
	$('a.all_comments').on('click', (event) => {
		event.preventDefault()
		let url = event.target.href
		getIndexComments(url)
	})
}
const getIndexComments = (url) => {
	let newUrl = url + '.json'
	fetch(newUrl)
		.then(res => res.json())
		.then(comments => {
			$('div#comments').html('')
			comments.forEach((comment) => {
				let newComment = new Comment(comment)
				let commentHtml = newComment.formatShow()
				$('div#comments').append(commentHtml)
				listenshowComment()
				listenForSort(url)

			})
		})
}

const newCommentForm = () => {
	$('a.new_comment').on('click', (event) => {
		event.preventDefault()
		event.stopPropagation()
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
	$('form#new_comment').on('submit', function(event) {
		event.preventDefault()
		event.stopPropagation()
		let data = $(this).serialize()
		// let data = $('form#new_comment').serialize()
		let url = event.target.baseURI + '/comments'
		$.ajax({
			url: url,
			method: 'post',
			data: data
		}).done(function (response) {
			let newComment = new Comment(response)
			let commentHtml = newComment.formatShow()
			$('div#comments').append(commentHtml)
			$('form#new_comment').remove()
		})
	})
}
const listenshowComment = () => {
	$('div#comments').on('click', (event) => {
		event.preventDefault()
		let url = event.target.href
		getShowComment(url)
	})
}
const getShowComment = (url) => {
		let newUrl = url + '.json'
		fetch(newUrl)
			.then(res => res.json())
			.then(comment => {
				$('#comments').html('')
					let newComment = new Comment(comment)
					let commentHtml = newComment.formatIndex()
					$('div#comments').append(commentHtml)
			})

}

const listenForSort = (url) => {
	$('a.sort_comments').on('click', function(event) {
		event.preventDefault()
		newUrl = url + '/sort.json'
		fetch(newUrl)
			.then(res => res.json())
			.then(comments => {
				$('div#comments').html('')
					comments.forEach((comment) => {
						let newComment = new Comment(comment)
						let commentHtml = newComment.formatShow()
						$('div#comments').append(commentHtml)

			})
		})
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

	formatShow(){

		let commentHtml = `
		<a href= "/recipes/${this.recipe}/comments/${this.id}" data-id="${this.id}" id= "comment"
			<h5>${this.title}</h5><br>
		`
		return commentHtml
	}

	formatIndex(){
		
		let commentHtml = `
		<h4>Title: ${this.title}</h4>
		<h4>Content: ${this.content}</h4>
		<h4>User: ${this.user.name}</h4>
		<h4>Recipe: ${this.recipe}</h4>
		`
		return commentHtml

	}
	formatSort(){
		
		let commentHtml = `
		<a href= "/recipes/${this.recipe}/comments/${this.id}/sort" data-id="${this.id}"
		`
		return commentHtml

	}
}
