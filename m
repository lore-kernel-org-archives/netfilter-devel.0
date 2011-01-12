From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 5/6] netfilter: allow NFQUEUE bypass if no listener is
 available
Date: Wed, 12 Jan 2011 20:03:15 +0100
Message-ID: <4D2DFAF3.9070101@netfilter.org>
References: <1293407904-31464-1-git-send-email-fw@strlen.de> <1293407904-31464-6-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fwestphal@astaro.com>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43840 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750741Ab1ALTDT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Jan 2011 14:03:19 -0500
In-Reply-To: <1293407904-31464-6-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 27/12/10 00:58, Florian Westphal wrote:
> If an skb is to be NF_QUEUE'd, but no program has opened the queue, the
> packet is dropped.
> 
> This adds a v2 target revision of xt_NFQUEUE that allows packets to
> continue through the ruleset instead.
> 
> Because the actual queueing happens outside of the target context, the
> 'bypass' flag has to be communicated back to the netfilter core.
> 
> Unfortunately the only choice to do this without adding a new function
> argument is to use the target function return value (i.e. the verdict).
> 
> In the NF_QUEUE case, the upper 16bit already contain the queue number
> to use.  The previous patch reduced NF_VERDICT_MASK to 0xff, i.e.
> we now have extra room for a new flag.
> 
> If a hook issued a NF_QUEUE verdict, then the netfilter core will
> continue packet processing if the queueing hook
> returns -ESRCH (== "this queue does not exist") and the new
> NF_VERDICT_FLAG_QUEUE_BYPASS flag is set in the verdict value.
> 
> Note: If the queue exists, but userspace does not consume packets fast
> enough, the skb will still be dropped.
> 
> Signed-off-by: Florian Westphal <fwestphal@astaro.com>
> ---
>  include/linux/netfilter.h            |    1 +
>  include/linux/netfilter/xt_NFQUEUE.h |    6 ++++++
>  net/netfilter/core.c                 |    6 +++++-
>  net/netfilter/nf_queue.c             |   10 ++++++++--
>  net/netfilter/xt_NFQUEUE.c           |   28 +++++++++++++++++++++++++---
>  5 files changed, 45 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
> index 231277f..041ec8f 100644
> --- a/include/linux/netfilter.h
> +++ b/include/linux/netfilter.h
> @@ -29,6 +29,7 @@
>  #define NF_VERDICT_MASK 0x000000ff
>  
>  /* extra verdict flags have mask 0x0000ff00 */
> +#define NF_VERDICT_FLAG_QUEUE_BYPASS	0x00008000
>  
>  /* queue number (NF_QUEUE) or errno (NF_DROP) */
>  #define NF_VERDICT_QMASK 0xffff0000
> diff --git a/include/linux/netfilter/xt_NFQUEUE.h b/include/linux/netfilter/xt_NFQUEUE.h
> index 2584f4a..9eafdbb 100644
> --- a/include/linux/netfilter/xt_NFQUEUE.h
> +++ b/include/linux/netfilter/xt_NFQUEUE.h
> @@ -20,4 +20,10 @@ struct xt_NFQ_info_v1 {
>  	__u16 queues_total;
>  };
>  
> +struct xt_NFQ_info_v2 {
> +	__u16 queuenum;
> +	__u16 queues_total;
> +	__u16 bypass;
> +};
> +
>  #endif /* _XT_NFQ_TARGET_H */
> diff --git a/net/netfilter/core.c b/net/netfilter/core.c
> index 18ee9b9..7dabbdd 100644
> --- a/net/netfilter/core.c
> +++ b/net/netfilter/core.c
> @@ -181,8 +181,12 @@ next_hook:
>  	} else if ((verdict & NF_VERDICT_MASK) == NF_QUEUE) {
>  		ret = nf_queue(skb, elem, pf, hook, indev, outdev, okfn,
>  			       verdict >> NF_VERDICT_QBITS);
> -		if (ret < 0)
> +		if (ret < 0) {
> +			if (ret == -ESRCH &&
> +			   (verdict & NF_VERDICT_FLAG_QUEUE_BYPASS))
> +				goto next_hook;

and then, next_hook appears again :-). Please, fix this patchset.

>  			kfree_skb(skb);
> +		}
>  		ret = 0;
>  	}
>  	rcu_read_unlock();
> diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
> index 1a5067c..f32d097 100644
> --- a/net/netfilter/nf_queue.c
> +++ b/net/netfilter/nf_queue.c
> @@ -128,8 +128,10 @@ static int __nf_queue(struct sk_buff *skb,
>  	rcu_read_lock();
>  
>  	qh = rcu_dereference(queue_handler[pf]);
> -	if (!qh)
> +	if (!qh) {
> +		error = -ESRCH;
>  		goto err_unlock;
> +	}
>  
>  	afinfo = nf_get_afinfo(pf);
>  	if (!afinfo)
> @@ -284,8 +286,12 @@ void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict)
>  		err = __nf_queue(skb, elem, entry->pf, entry->hook,
>  				 entry->indev, entry->outdev, entry->okfn,
>  				 verdict >> NF_VERDICT_QBITS);
> -		if (err < 0)
> +		if (err < 0) {
> +			if (err == -ESRCH &&
> +			   (verdict & NF_VERDICT_FLAG_QUEUE_BYPASS))
> +				goto next_hook;
>  			kfree_skb(skb);
> +		}
>  		break;
>  	case NF_STOLEN:
>  	default:
> diff --git a/net/netfilter/xt_NFQUEUE.c b/net/netfilter/xt_NFQUEUE.c
> index 039cce1..41da6c3 100644
> --- a/net/netfilter/xt_NFQUEUE.c
> +++ b/net/netfilter/xt_NFQUEUE.c
> @@ -81,9 +81,20 @@ nfqueue_tg_v1(struct sk_buff *skb, const struct xt_action_param *par)
>  	return NF_QUEUE_NR(queue);
>  }
>  
> -static int nfqueue_tg_v1_check(const struct xt_tgchk_param *par)
> +static unsigned int
> +nfqueue_tg_v2(struct sk_buff *skb, const struct xt_action_param *par)
>  {
> -	const struct xt_NFQ_info_v1 *info = par->targinfo;
> +	const struct xt_NFQ_info_v2 *info = par->targinfo;
> +	unsigned int ret = nfqueue_tg_v1(skb, par);
> +
> +	if (info->bypass)
> +		ret |= NF_VERDICT_FLAG_QUEUE_BYPASS;
> +	return ret;
> +}
> +
> +static int nfqueue_tg_check(const struct xt_tgchk_param *par)
> +{
> +	const struct xt_NFQ_info_v2 *info = par->targinfo;
>  	u32 maxid;
>  
>  	if (unlikely(!rnd_inited)) {
> @@ -100,6 +111,8 @@ static int nfqueue_tg_v1_check(const struct xt_tgchk_param *par)
>  		       info->queues_total, maxid);
>  		return -ERANGE;
>  	}
> +	if (par->target->revision == 2 && info->bypass > 1)
> +		return -EINVAL;
>  	return 0;
>  }
>  
> @@ -115,11 +128,20 @@ static struct xt_target nfqueue_tg_reg[] __read_mostly = {
>  		.name		= "NFQUEUE",
>  		.revision	= 1,
>  		.family		= NFPROTO_UNSPEC,
> -		.checkentry	= nfqueue_tg_v1_check,
> +		.checkentry	= nfqueue_tg_check,
>  		.target		= nfqueue_tg_v1,
>  		.targetsize	= sizeof(struct xt_NFQ_info_v1),
>  		.me		= THIS_MODULE,
>  	},
> +	{
> +		.name		= "NFQUEUE",
> +		.revision	= 2,
> +		.family		= NFPROTO_UNSPEC,
> +		.checkentry	= nfqueue_tg_check,
> +		.target		= nfqueue_tg_v2,
> +		.targetsize	= sizeof(struct xt_NFQ_info_v2),
> +		.me		= THIS_MODULE,
> +	},
>  };
>  
>  static int __init nfqueue_tg_init(void)

