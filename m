From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/5] netfilter: xt extensions: use pr_<level> (2)
Date: Thu, 25 Mar 2010 14:08:26 +0100
Message-ID: <4BAB604A.2090808@trash.net>
References: <1269521809-29393-1-git-send-email-jengelh@medozas.de> <1269521809-29393-3-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:51488 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310Ab0CYNI2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Mar 2010 09:08:28 -0400
In-Reply-To: <1269521809-29393-3-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> diff --git a/net/bridge/netfilter/ebt_ulog.c b/net/bridge/netfilter/ebt_ulog.c
> index 84340ab..9faee5f 100644
> --- a/net/bridge/netfilter/ebt_ulog.c
> +++ b/net/bridge/netfilter/ebt_ulog.c
> @@ -27,7 +27,7 @@
>   *   flushed even if it is not full yet.
>   *
>   */
> -
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>  #include <linux/module.h>
>  #include <linux/spinlock.h>
>  #include <linux/socket.h>

Why don't you remove the now unused PRINTR macro?

> @@ -106,15 +106,15 @@ static struct sk_buff *ulog_alloc_skb(unsigned int size)
>  	n = max(size, nlbufsiz);
>  	skb = alloc_skb(n, GFP_ATOMIC);
>  	if (!skb) {
> -		PRINTR(KERN_ERR "ebt_ulog: can't alloc whole buffer "
> -		       "of size %ub!\n", n);
> +		if (net_ratelimit())
> +			pr_debug("cannot alloc whole buffer of size %ub!\n", n);

net_ratelimit() should not be used for debugging messages since
it will just print "n messages surpressed" without ever printing
a real message in case debugging is disabled. As this is a debug
messages only printed on a presumed rare occasion, just remove
the rate limit.

The same applies to ipt_ULOG.

>  		if (n > size) {
>  			/* try to allocate only as much as we need for
>  			 * current packet */
>  			skb = alloc_skb(size, GFP_ATOMIC);
> -			if (!skb)
> -				PRINTR(KERN_ERR "ebt_ulog: can't even allocate "
> -				       "buffer of size %ub\n", size);
> +			if (!skb && net_ratelimit())
> +				pr_debug("cannot even allocate "
> +					 "buffer of size %ub\n", size);
>  		}
>  	}
>  
> @@ -141,8 +141,9 @@ static void ebt_ulog_packet(unsigned int hooknr, const struct sk_buff *skb,
>  
>  	size = NLMSG_SPACE(sizeof(*pm) + copy_len);
>  	if (size > nlbufsiz) {
> -		PRINTR("ebt_ulog: Size %Zd needed, but nlbufsiz=%d\n",
> -		       size, nlbufsiz);
> +		if (net_ratelimit())
> +			pr_debug("Size %Zd needed, but nlbufsiz=%d\n",
> +				 size, nlbufsiz);
>  		return;
>  	}
>  
> @@ -216,8 +217,9 @@ unlock:
>  	return;
>  
>  nlmsg_failure:
> -	printk(KERN_CRIT "ebt_ulog: error during NLMSG_PUT. This should "
> -	       "not happen, please report to author.\n");
> +	if (net_ratelimit())
> +		pr_debug("error during NLMSG_PUT. This should "
> +			 "not happen, please report to author.\n");
>  	goto unlock;
>  alloc_failure:
>  	goto unlock;
> @@ -291,8 +293,8 @@ static int __init ebt_ulog_init(void)
>  	int i;
>  
>  	if (nlbufsiz >= 128*1024) {
> -		printk(KERN_NOTICE "ebt_ulog: Netlink buffer has to be <= 128kB,"
> -		       " please try a smaller nlbufsiz parameter.\n");
> +		pr_warning("Netlink buffer has to be <= 128kB,"
> +			   " please try a smaller nlbufsiz parameter.\n");
>  		return -EINVAL;
>  	}
>  
> diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
> index a20bee7..f019c34 100644
> --- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
> +++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
> @@ -9,6 +9,7 @@
>   * published by the Free Software Foundation.
>   *
>   */
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>  #include <linux/module.h>
>  #include <linux/proc_fs.h>
>  #include <linux/jhash.h>

> @@ -294,7 +294,8 @@ clusterip_tg(struct sk_buff *skb, const struct xt_target_param *par)
>  
>  	ct = nf_ct_get(skb, &ctinfo);
>  	if (ct == NULL) {
> -		printk(KERN_ERR "CLUSTERIP: no conntrack!\n");
> +		if (net_ratelimit())
> +			pr_info("no conntrack!\n");

There are a few changes in log level in this file and other files
that need more explanation in the changelog than "supplement to ...".

>  			/* FIXME: need to drop invalid ones, since replies
>  			 * to outgoing connections of other nodes will be
>  			 * marked as INVALID */
> @@ -357,14 +358,13 @@ static bool clusterip_tg_check(const struct xt_tgchk_param *par)
>  	if (cipinfo->hash_mode != CLUSTERIP_HASHMODE_SIP &&
>  	    cipinfo->hash_mode != CLUSTERIP_HASHMODE_SIP_SPT &&
>  	    cipinfo->hash_mode != CLUSTERIP_HASHMODE_SIP_SPT_DPT) {
> -		printk(KERN_WARNING "CLUSTERIP: unknown mode `%u'\n",
> -			cipinfo->hash_mode);
> +		pr_info("unknown mode %u\n", cipinfo->hash_mode);

pr_err() actually seems more appropriate, if we'd use it consistenly
to report error conditions.
