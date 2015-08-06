From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: per network namespace nfacct
Date: Thu, 6 Aug 2015 12:07:13 +0200
Message-ID: <20150806100713.GA18520@salvia>
References: <1438789905-5716-1-git-send-email-aschultz@tpip.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Andreas Schultz <aschultz@tpip.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56139 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753378AbbHFKBM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 6 Aug 2015 06:01:12 -0400
Content-Disposition: inline
In-Reply-To: <1438789905-5716-1-git-send-email-aschultz@tpip.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Aug 05, 2015 at 05:51:45PM +0200, Andreas Schultz wrote:
> @@ -478,34 +482,59 @@ int nfnl_acct_overquota(const struct sk_buff *skb, struct nf_acct *nfacct)
>  }
>  EXPORT_SYMBOL_GPL(nfnl_acct_overquota);
>  
> +static int __net_init nfnl_acct_net_init(struct net *net)
> +{
> +	INIT_LIST_HEAD(&net->nfnl_acct_list);
> +
> +        return 0;
   ^^^^^^^^

Minor comestic: Please, make sure we get indent as tabs of 8-chars long.

> +}
> +
> +static void __net_exit nfnl_acct_net_exit(struct net *net)
> +{
> +	struct nf_acct *cur, *tmp;
> +
> +	list_for_each_entry_safe(cur, tmp, &net->nfnl_acct_list, head) {
> +		list_del_rcu(&cur->head);
> +
> +		if (atomic_dec_and_test(&cur->refcnt))
> +			kfree_rcu(cur, rcu_head);
> +	}
> +}

You better use nfnl_acct_put() here, otherwise we leak a module
refcount.

Other than that, this looks fine with me. Please send a v2.

Thanks.
