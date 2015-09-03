From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCHv2 nf-next 3/5] netfilter: nfnetlink_queue_ct: export
 functions
Date: Thu, 3 Sep 2015 12:10:34 +0200
Message-ID: <20150903101034.GA19011@salvia>
References: <20150824231038.GA20038@gmail.com>
 <20150824231520.GC20038@gmail.com>
 <20150826190553.GA18429@salvia>
 <20150901003436.GA2642@gmail.com>
 <20150901004146.GD2642@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
To: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54338 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752416AbbICKEE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Sep 2015 06:04:04 -0400
Content-Disposition: inline
In-Reply-To: <20150901004146.GD2642@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Sep 01, 2015 at 09:41:46AM +0900, Ken-ichirou MATSUZAWA wrote:
[...]
> diff --git a/net/netfilter/nfnetlink_queue_ct.c b/net/netfilter/nfnetlink_queue_ct.c
> index 2a30618..299b5a8 100644
> --- a/net/netfilter/nfnetlink_queue_ct.c
> +++ b/net/netfilter/nfnetlink_queue_ct.c
> @@ -14,6 +14,8 @@
>  #include <net/netfilter/nf_conntrack.h>
>  #include <net/netfilter/nfnetlink_queue.h>
>  
> +struct nfq_ct_hook __rcu *nfq_ct_hook __read_mostly;
> +
>  struct nf_conn *nfqnl_ct_get(struct sk_buff *entskb, size_t *size,
>  			     enum ip_conntrack_info *ctinfo)
>  {
> @@ -34,6 +36,7 @@ struct nf_conn *nfqnl_ct_get(struct sk_buff *entskb, size_t *size,
>  	}
>  	return ct;
>  }
> +EXPORT_SYMBOL_GPL(nfqnl_ct_get);

After this patchset these functions are not nfqueue specific anymore,
so we have to place this in a single module, eg. nfnetlink_ct_glue.c
(unless someone comes up with a better name...).

The idea is that nfnetlink_queue and nfnetlink_log request this module
to be loaded when the CONNTRACK flag is passed.

The nfqnl_ prefix should be also modified, I'd suggest you use nfnl_ct_

Does this sound good to you?
