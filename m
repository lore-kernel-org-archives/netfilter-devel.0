From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 3/3] xt_owner match
Date: Mon, 19 Nov 2007 16:43:33 +0100
Message-ID: <4741AF25.5080604@trash.net>
References: <Pine.LNX.4.64.0711161357050.3340@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0711161400360.3340@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36264 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529AbXKSPnz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 Nov 2007 10:43:55 -0500
In-Reply-To: <Pine.LNX.4.64.0711161400360.3340@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Jan Engelhardt wrote:
> As with xt_tos and xt_TOS, the old header files are kept for the time,
> and we define a revision 0 which is compatible with ipt_tos/ipt_TOS -
> same for xt_owner.
> 
> --- net-2.6.25.orig/include/linux/netfilter_ipv4/Kbuild
> +++ net-2.6.25/include/linux/netfilter_ipv4/Kbuild
> @@ -29,7 +29,6 @@ header-y += ipt_limit.h
>  header-y += ipt_mac.h
>  header-y += ipt_mark.h
>  header-y += ipt_multiport.h
> -header-y += ipt_owner.h
>  header-y += ipt_physdev.h
>  header-y += ipt_pkttype.h
>  header-y += ipt_policy.h
> Index: net-2.6.25/include/linux/netfilter_ipv6/Kbuild
> ===================================================================
> --- net-2.6.25.orig/include/linux/netfilter_ipv6/Kbuild
> +++ net-2.6.25/include/linux/netfilter_ipv6/Kbuild
> @@ -13,7 +13,6 @@ header-y += ip6t_mac.h
>  header-y += ip6t_mark.h
>  header-y += ip6t_multiport.h
>  header-y += ip6t_opts.h
> -header-y += ip6t_owner.h
>  header-y += ip6t_physdev.h
>  header-y += ip6t_policy.h
>  header-y += ip6t_rt.h

Please keep both.

> +config NETFILTER_XT_MATCH_OWNER
> +	tristate '"owner" match support'
> +	depends on NETFILTER_XTABLES
> +	---help---
> +	Socket owner matching allows you to match locally-generated packets
> +	based on who created the socket: the user, group, process or session.

Only user and group are supported.

> +#include <linux/module.h>
> +#include <linux/skbuff.h>
> +#include <linux/file.h>
> +#include <net/sock.h>
> +#include <linux/netfilter/x_tables.h>
> +#include <linux/netfilter/xt_owner.h>
> +#include <linux/netfilter_ipv4/ipt_owner.h>
> +#include <linux/netfilter_ipv6/ip6t_owner.h>
> +
> +static bool
> +owner_mt_v0(const struct sk_buff *skb, const struct net_device *in,
> +            const struct net_device *out, const struct xt_match *match,
> +            const void *matchinfo, int offset, unsigned int protoff,
> +            bool *hotdrop)
> +{
> +	const struct ipt_owner_info *info = matchinfo;
> +	const struct file *filp;
> +
> +	if (skb->sk == NULL || skb->sk->sk_socket == NULL)
> +		return false;
> +
> +	filp = skb->sk->sk_socket->file;
> +	if (filp == NULL)
> +		return false;

What would be nice is to allow matching whether a socket exists,
without UID/GID. I had a patch for this for a long time, but
lost it somewhere.

> +
> +	if (info->match & IPT_OWNER_UID)
> +		if ((filp->f_uid != info->uid) ^
> +		    !!(info->invert & IPT_OWNER_UID))
> +			return false;
> +
> +	if (info->match & IPT_OWNER_GID)
> +		if ((filp->f_gid != info->gid) ^
> +		    !!(info->invert & IPT_OWNER_GID))
> +			return false;
> +
> +	return true;
> +}
> +
> +static struct xt_match owner_mt_reg[] __read_mostly = {
> +	{
> +		.name       = "owner",
> +		.revision   = 0,
> +		.family     = AF_INET,
> +		.match      = owner_mt_v0,
> +		.matchsize  = sizeof(struct ipt_owner_info),
> +		.checkentry = owner_mt_check_v0,
> +		.hooks      = (1 << NF_IP_LOCAL_OUT) |
> +		              (1 << NF_IP_POST_ROUTING),

This needs to use NF_INET_...

Please resend all your patches when you want me to apply them.
Thanks.

