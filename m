From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] netfilter: nf_conntrack: don't release a conntrack with
 non-zero refcnt
Date: Tue, 4 Feb 2014 00:29:25 +0100
Message-ID: <20140203232925.GA3695@breakpoint.cc>
References: <1391465397-3856-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, avagin@parallels.com,
	fw@strlen.de, eric.dumazet@gmail.com
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:33725 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753995AbaBCX33 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 3 Feb 2014 18:29:29 -0500
Content-Disposition: inline
In-Reply-To: <1391465397-3856-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
> index 4d1fb5d..356bef5 100644
> --- a/net/netfilter/nf_conntrack_core.c
> +++ b/net/netfilter/nf_conntrack_core.c
> @@ -448,7 +448,9 @@ nf_conntrack_hash_check_insert(struct nf_conn *ct)
>  			goto out;
>  
>  	add_timer(&ct->timeout);
> -	nf_conntrack_get(&ct->ct_general);
> +	smp_wmb();
> +	/* The caller holds a reference to this object */
> +	atomic_set(&ct->ct_general.use, 2);

What happens when the skb is dropped before confirmation?
How is skb_clone etc. solved (it increments refcnt of underlying
conntrack object?)
