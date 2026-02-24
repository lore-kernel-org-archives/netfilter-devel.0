Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1D6039A801;
	Tue, 24 Feb 2026 12:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771937660; cv=none; b=DGhe4A06+FKGAYGVPp2+3fuikdpmz8x/mFdSSamBj81EkJ+UWlT2A7BjeJrM0j6up8yKcz5BCNRMSYIJUTTGh7j2uwdfylWrff2mOrL/iFft9Mi7o6xRgfoCvGVt4iyJzPazbtte49Vb5+3xYuwk9F2KKwBJeNpZXBa88uGgDlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771937660; c=relaxed/simple;
	bh=lrBv9czbl1hL9cSkBEu5yTa1ueGrWZsLMzYO8VchdkY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FBPObDj/4TU6+6whp+mXWfjSq1QLENlLgxUJufeTjaRyFc19BluJUzQcbrjb3z7h2G0ld+ttA3MKxS+jxB1zfgRtL+E9jJCvG/yGNRjqAQn/Fkb2nd/SmDhwROquJ7U6uqhjre+FqPWyrgVx/Dn3F5wZHOlZl/smuaaEFzakGWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 9C09A604AA; Tue, 24 Feb 2026 13:54:16 +0100 (CET)
Date: Tue, 24 Feb 2026 13:54:16 +0100
From: Florian Westphal <fw@strlen.de>
To: Eric Dumazet <edumazet@google.com>
Cc: "David S . Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	eric.dumazet@gmail.com
Subject: Re: [PATCH nf-next] netfilter: nf_log_syslog: no longer acquire
 sk_callback_lock in nf_log_dump_sk_uid_gid()
Message-ID: <aZ2feO_xVKN8bT3g@strlen.de>
References: <20260224123347.3163030-1-edumazet@google.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260224123347.3163030-1-edumazet@google.com>

Eric Dumazet <edumazet@google.com> wrote:
> After commit 983512f3a87f ("net: Drop the lock in skb_may_tx_timestamp()")
> from Sebastian Andrzej Siewior, apply the same logic in nf_log_dump_sk_uid_gid()
> to avoid touching sk_callback_lock.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> ---
>  net/netfilter/nf_log_syslog.c | 18 ++++++++++++++----
>  1 file changed, 14 insertions(+), 4 deletions(-)
> 
> diff --git a/net/netfilter/nf_log_syslog.c b/net/netfilter/nf_log_syslog.c
> index 41503847d9d7fb21824fabb1b57b45f2622b9310..dee6be17440c6c0f202fc2ba67129437879e45a6 100644
> --- a/net/netfilter/nf_log_syslog.c
> +++ b/net/netfilter/nf_log_syslog.c
> @@ -165,18 +165,28 @@ static struct nf_logger nf_arp_logger __read_mostly = {
>  static void nf_log_dump_sk_uid_gid(struct net *net, struct nf_log_buf *m,
>  				   struct sock *sk)
>  {
> +	const struct socket *sock;
> +	const struct file *file;
> +
>  	if (!sk || !sk_fullsock(sk) || !net_eq(net, sock_net(sk)))
>  		return;
>  
> -	read_lock_bh(&sk->sk_callback_lock);
> -	if (sk->sk_socket && sk->sk_socket->file) {
> -		const struct cred *cred = sk->sk_socket->file->f_cred;
> +	/* The sk pointer remains valid as long as the skb is. The sk_socket and
> +	 * file pointer may become NULL if the socket is closed. Both structures
> +	 * (including file->cred) are RCU freed which means they can be accessed
> +	 * within a RCU read section.
> +	 */
> +	rcu_read_lock();
> +	sock = READ_ONCE(sk->sk_socket);
> +	file = sock ? READ_ONCE(sock->file) : NULL;
> +	if (file) {
> +		const struct cred *cred = file->f_cred;
>  
>  		nf_log_buf_add(m, "UID=%u GID=%u ",
>  			       from_kuid_munged(&init_user_ns, cred->fsuid),
>  			       from_kgid_munged(&init_user_ns, cred->fsgid));
>  	}
> -	read_unlock_bh(&sk->sk_callback_lock);
> +	rcu_read_unlock();

Thanks Eric!  The explicit rcu_read_lock()/unlock are not required,
caller guarantees RCU read-side section.

Aside of that nit:
Reviewed-by: Florian Westphal <fw@strlen.de>

