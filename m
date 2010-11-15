From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nf-next-2.6] netfilter: add __rcu annotations
Date: Mon, 15 Nov 2010 17:53:37 +0100
Message-ID: <4CE16591.9030504@trash.net>
References: <1289839592.2607.91.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:35598 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932132Ab0KOQxj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Nov 2010 11:53:39 -0500
In-Reply-To: <1289839592.2607.91.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 15.11.2010 17:46, Eric Dumazet wrote:
> @@ -49,11 +52,15 @@ EXPORT_SYMBOL(nf_register_queue_handler);
>  /* The caller must flush their queue before this */
>  int nf_unregister_queue_handler(u_int8_t pf, const struct nf_queue_handler *qh)
>  {
> +	const struct nf_queue_handler *old;
> +
>  	if (pf >= ARRAY_SIZE(queue_handler))
>  		return -EINVAL;
>  
>  	mutex_lock(&queue_handler_mutex);
> -	if (queue_handler[pf] && queue_handler[pf] != qh) {
> +	old = rcu_dereference_protected(queue_handler[pf],
> +					lockdep_is_held(&queue_handler_mutex));
> +	if (old && old) {

This doesn't look like it was intended :)

if (old && old != qh)?
