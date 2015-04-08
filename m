From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] Add NFPROTO_ARP for mark
Date: Wed, 8 Apr 2015 19:49:11 +0200
Message-ID: <20150408174911.GA4683@salvia>
References: <1428374716-15108-1-git-send-email-zhangcy@cn.fujitsu.com>
 <1428374716-15108-2-git-send-email-zhangcy@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Zhang Chunyu <zhangcy@cn.fujitsu.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56378 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754076AbbDHRpG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Apr 2015 13:45:06 -0400
Content-Disposition: inline
In-Reply-To: <1428374716-15108-2-git-send-email-zhangcy@cn.fujitsu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Apr 06, 2015 at 10:45:16PM -0400, Zhang Chunyu wrote:
> need add NFPROTO_ARP and MODULE_ALIAS for arptables -mark
> 
> Signed-off-by: Zhang Chunyu <zhangcy@cn.fujitsu.com>
> ---
>  net/netfilter/xt_mark.c | 31 +++++++++++++++++++++----------
>  1 file changed, 21 insertions(+), 10 deletions(-)
> 
> diff --git a/net/netfilter/xt_mark.c b/net/netfilter/xt_mark.c
> index 2334523..5778062 100644
> --- a/net/netfilter/xt_mark.c
> +++ b/net/netfilter/xt_mark.c
> @@ -23,6 +23,7 @@ MODULE_ALIAS("ipt_mark");
>  MODULE_ALIAS("ip6t_mark");
>  MODULE_ALIAS("ipt_MARK");
>  MODULE_ALIAS("ip6t_MARK");
> +MODULE_ALIAS("arpt_MARK");

This little change above is fine.

>  static unsigned int
>  mark_tg(struct sk_buff *skb, const struct xt_action_param *par)
> @@ -41,13 +42,23 @@ mark_mt(const struct sk_buff *skb, struct xt_action_param *par)
>  	return ((skb->mark & info->mask) == info->mark) ^ info->invert;
>  }
>  
> -static struct xt_target mark_tg_reg __read_mostly = {
> -	.name           = "MARK",
> -	.revision       = 2,
> -	.family         = NFPROTO_UNSPEC,
> -	.target         = mark_tg,
> -	.targetsize     = sizeof(struct xt_mark_tginfo2),
> -	.me             = THIS_MODULE,
> +static struct xt_target mark_tg_reg[] __read_mostly = {
> +	{
> +		.name           = "MARK",
> +		.revision       = 2,
> +		.family         = NFPROTO_UNSPEC,
> +		.target         = mark_tg,
> +		.targetsize     = sizeof(struct xt_mark_tginfo2),
> +		.me             = THIS_MODULE,
> +	},
> +	{
> +		.name           = "MARK",
> +		.revision       = 2,
> +		.family         = NFPROTO_ARP,
> +		.target         = mark_tg,
> +		.targetsize     = sizeof(struct xt_mark_tginfo2),
> +		.me             = THIS_MODULE,
> +	}
>  };

You don't need this.

The problem is here that your patch:

http://patchwork.ozlabs.org/patch/455966/

is missing this chunk:

diff --git a/libarptc/libarptc_incl.c b/libarptc/libarptc_incl.c
index a034930..87404ce 100644
--- a/libarptc/libarptc_incl.c
+++ b/libarptc/libarptc_incl.c
@@ -872,7 +872,7 @@ map_target(const TC_HANDLE_T handle,
        /* memset to all 0 for your memcmp convenience. */
        memset(t->u.user.name + strlen(t->u.user.name),
               0,
-              FUNCTION_MAXNAMELEN - strlen(t->u.user.name));
+              FUNCTION_MAXNAMELEN - 1 - strlen(t->u.user.name));
        return 1;
 }

Otherwise, the revision number is zeroed.

And you don't need: http://patchwork.ozlabs.org/patch/455965/.

Please, rebase your userspace patches on top of current arptables git
and resubmit. Thanks.
