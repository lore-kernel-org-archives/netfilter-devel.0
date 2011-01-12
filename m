From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 4/6] netfilter: reduce NF_VERDICT_MASK to 0xff
Date: Wed, 12 Jan 2011 20:02:29 +0100
Message-ID: <4D2DFAC5.8020802@netfilter.org>
References: <1293407904-31464-1-git-send-email-fw@strlen.de> <1293407904-31464-5-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45086 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751621Ab1ALTCf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Jan 2011 14:02:35 -0500
In-Reply-To: <1293407904-31464-5-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 27/12/10 00:58, Florian Westphal wrote:
> NF_VERDICT_MASK is currently 0xffff. This is because the upper
> 16 bits are used to store errno (for NF_DROP) or the queue number
> (NF_QUEUE verdict).
> 
> As there are up to 0xffff different queues available, there is
> no more room to store additional flags.
> 
> At the moment there are only 6 different verdicts, i.e. we can
> reduce NF_VERDICT_MASK to 0xff to allow storing additional flags
> in the 0xff00 space.
> 
> NF_VERDICT_BITS would then be reduced to 8, but because the value
> is exported to userspace, this might cause breakage; e.g.:
> 
> e.g. 'queuenr = (1 << NF_VERDICT_BITS) | NF_QUEUE'  would now break.
> 
> Thus, remove NF_VERDICT_BITS usage in the kernel and move the old
> value to the 'userspace compat' section.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  include/linux/netfilter.h |   20 +++++++++++++++-----
>  net/netfilter/core.c      |    4 ++--
>  net/netfilter/nf_queue.c  |    2 +-
>  3 files changed, 18 insertions(+), 8 deletions(-)
> 
> diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
> index 1893837..231277f 100644
> --- a/include/linux/netfilter.h
> +++ b/include/linux/netfilter.h
> @@ -24,16 +24,19 @@
>  #define NF_MAX_VERDICT NF_STOP
>  
>  /* we overload the higher bits for encoding auxiliary data such as the queue
> - * number. Not nice, but better than additional function arguments. */
> -#define NF_VERDICT_MASK 0x0000ffff
> -#define NF_VERDICT_BITS 16
> + * number or errno values. Not nice, but better than additional function
> + * arguments. */
> +#define NF_VERDICT_MASK 0x000000ff
> +
> +/* extra verdict flags have mask 0x0000ff00 */
>  
> +/* queue number (NF_QUEUE) or errno (NF_DROP) */
>  #define NF_VERDICT_QMASK 0xffff0000
>  #define NF_VERDICT_QBITS 16
>  
> -#define NF_QUEUE_NR(x) ((((x) << NF_VERDICT_BITS) & NF_VERDICT_QMASK) | NF_QUEUE)
> +#define NF_QUEUE_NR(x) ((((x) << 16) & NF_VERDICT_QMASK) | NF_QUEUE)
>  
> -#define NF_DROP_ERR(x) (((-x) << NF_VERDICT_BITS) | NF_DROP)
> +#define NF_DROP_ERR(x) (((-x) << 16) | NF_DROP)
>  
>  /* only for userspace compatibility */
>  #ifndef __KERNEL__
> @@ -41,6 +44,9 @@
>     <= 0x2000 is used for protocol-flags. */
>  #define NFC_UNKNOWN 0x4000
>  #define NFC_ALTERED 0x8000
> +
> +/* NF_VERDICT_BITS should be 8 now, but userspace might break if this changes */
> +#define NF_VERDICT_BITS 16
>  #endif

i don't find any use of this in user-space.

>  
>  enum nf_inet_hooks {
> @@ -72,6 +78,10 @@ union nf_inet_addr {
>  
>  #ifdef __KERNEL__
>  #ifdef CONFIG_NETFILTER
> +static inline int NF_DROP_GETERR(int verdict)
> +{
> +	return -(verdict >> NF_VERDICT_QBITS);
> +}
>  
>  static inline int nf_inet_addr_cmp(const union nf_inet_addr *a1,
>  				   const union nf_inet_addr *a2)
> diff --git a/net/netfilter/core.c b/net/netfilter/core.c
> index 73e44c4..18ee9b9 100644
> --- a/net/netfilter/core.c
> +++ b/net/netfilter/core.c
> @@ -175,12 +175,12 @@ next_hook:
>  		ret = 1;
>  	} else if ((verdict & NF_VERDICT_MASK) == NF_DROP) {
>  		kfree_skb(skb);
> -		ret = -(verdict >> NF_VERDICT_BITS);
> +		ret = NF_DROP_GETERR(verdict);
>  		if (ret == 0)
>  			ret = -EPERM;
>  	} else if ((verdict & NF_VERDICT_MASK) == NF_QUEUE) {
>  		ret = nf_queue(skb, elem, pf, hook, indev, outdev, okfn,
> -			       verdict >> NF_VERDICT_BITS);
> +			       verdict >> NF_VERDICT_QBITS);
>  		if (ret < 0)
>  			kfree_skb(skb);
>  		ret = 0;
> diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
> index 2a9b80c..1a5067c 100644
> --- a/net/netfilter/nf_queue.c
> +++ b/net/netfilter/nf_queue.c
> @@ -283,7 +283,7 @@ void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict)
>  	case NF_QUEUE:
>  		err = __nf_queue(skb, elem, entry->pf, entry->hook,
>  				 entry->indev, entry->outdev, entry->okfn,
> -				 verdict >> NF_VERDICT_BITS);
> +				 verdict >> NF_VERDICT_QBITS);
>  		if (err < 0)
>  			kfree_skb(skb);
>  		break;

