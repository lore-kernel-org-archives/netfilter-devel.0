From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: add extended accounting infrastructure over
 nfnetlink
Date: Sat, 24 Dec 2011 02:33:51 +0100
Message-ID: <20111224013351.GA12788@1984>
References: <1324689946-20269-1-git-send-email-pablo@netfilter.org>
 <1324689946-20269-2-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kaber@trash.net, xiaosuo@gmail.com, eric.dumazet@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35744 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753178Ab1LXBdy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 23 Dec 2011 20:33:54 -0500
Content-Disposition: inline
In-Reply-To: <1324689946-20269-2-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

In case you notice:

On Sat, Dec 24, 2011 at 02:25:46AM +0100, pablo@netfilter.org wrote:
> +struct nf_acct *nfnl_acct_find_get(const char *acct_name)
> +{
> +	struct nf_acct *cur, *acct = NULL;
> +
> +	rcu_read_lock();
> +	list_for_each_entry_rcu(cur, &nfnl_acct_list, head) {
> +		if (strncmp(cur->name, acct_name, NFACCT_NAME_MAX)!= 0)
> +			continue;
> +
> +		if (!try_module_get(THIS_MODULE))
> +			goto err;
> +
> +		if (!atomic_inc_not_zero(&cur->refcnt)) {
> +			module_put(THIS_MODULE);
> +			goto err;
> +		}
> +
> +		acct = cur;
> +		break;
> +	}
> +	rcu_read_unlock();
> +err:

I've fixed this here. Now the err label goes before the rcu_read_unlock ;-)
