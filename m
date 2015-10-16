From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: nfnetlink_log: autoload
 nf_conntrack_netlink module NFQA_CFG_F_CONNTRACK config flag
Date: Fri, 16 Oct 2015 19:05:32 +0200
Message-ID: <20151016170532.GA18148@salvia>
References: <1443724990-4014-1-git-send-email-pablo@netfilter.org>
 <1443724990-4014-2-git-send-email-pablo@netfilter.org>
 <20151005024454.GA14637@gmail.com>
 <20151005025046.GE14637@gmail.com>
 <20151005152315.GA11562@salvia>
 <20151006021001.GA30037@gmail.com>
 <20151006021246.GB30037@gmail.com>
 <20151006100728.GA2429@salvia>
 <20151007042016.GA23203@gmail.com>
 <20151007042550.GC23203@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37901 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752134AbbJPQ63 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 16 Oct 2015 12:58:29 -0400
Content-Disposition: inline
In-Reply-To: <20151007042550.GC23203@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Oct 07, 2015 at 01:25:50PM +0900, Ken-ichirou MATSUZAWA wrote:
> This patch enables to load nf_conntrack_netlink module if
> NFULNL_CFG_F_CONNTRACK config flag is specified.
> 
> Signed-off-by: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
> ---
>  net/netfilter/nfnetlink_log.c |   11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
> index e1d1187..f8d9bd8 100644
> --- a/net/netfilter/nfnetlink_log.c
> +++ b/net/netfilter/nfnetlink_log.c
> @@ -927,7 +927,16 @@ nfulnl_recv_config(struct sock *ctnl, struct sk_buff *skb,
>  		}
>  
>  		if (flags & NFULNL_CFG_F_CONNTRACK &&
> -		    rcu_access_pointer(nfnl_ct_hook) == NULL) {
> +		    !rcu_access_pointer(nfnl_ct_hook)) {
> +#ifdef CONFIG_MODULES
> +			nfnl_unlock(NFNL_SUBSYS_ULOG);
> +			request_module("ip_conntrack_netlink");
> +			nfnl_lock(NFNL_SUBSYS_ULOG);
> +			if (rcu_access_pointer(nfnl_ct_hook)) {
> +				ret = -EAGAIN;
> +				goto out;
> +			}
> +#endif

I know this is not your fault, but could you have a look to see if we
can get resolved the broken atomicity problems in first place when
applying configuration updates to nfnetlink_queue in a similar way to
what I did for nfnetlink_log?

I mean, move code that check for things right up the beginning of the
functions, then we pass the preparation phase and we're good, we apply
the configuration changes.

Again not your fault, but there's another nasty thing in that code: We
can destroy a queue in NFQNL_CFG_CMD_UNBIND, then we can keep going on
configuring it when it is actually destroyed. This is working only by
luck because we're using call_rcu so the object is still there, but
this is sloppy and it should be fixed.

After having that resolved, we can go back to adding module autoload.

Let me know,
Thanks.
