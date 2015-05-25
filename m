From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH 1/1] netfilter: Added vlan matching extension
Date: Mon, 25 May 2015 23:51:08 +0200
Message-ID: <20150525215108.GH3629@breakpoint.cc>
References: <1432586250-42147-1-git-send-email-eddi@guardicore.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Eddie Linder <eddi@guardicore.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:42073 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751085AbbEYVvK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 May 2015 17:51:10 -0400
Content-Disposition: inline
In-Reply-To: <1432586250-42147-1-git-send-email-eddi@guardicore.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eddie Linder <eddi@guardicore.com> wrote:
> Signed-off-by: Eddie Linder <eddi@guardicore.com>

Why do we need a vlan tag match in iptables?
For bridged traffic we have ebtables' net/bridge/netfilter/ebt_vlan.c .

And for routed traffic you'd just use -i vlan.id.0 or whatever?

What is this match being used for, and more importantly where/how?
(Is this for call-iptables=1 invocation from bridge netfilter?)

Nevertheless, a couple of comments below.

> diff --git a/include/uapi/linux/netfilter/Kbuild b/include/uapi/linux/netfilter/Kbuild
> index 1d973d2..2ca36db 100644
> --- a/include/uapi/linux/netfilter/Kbuild
> +++ b/include/uapi/linux/netfilter/Kbuild
> @@ -85,3 +85,4 @@ header-y += xt_tcpmss.h
>  header-y += xt_tcpudp.h
>  header-y += xt_time.h
>  header-y += xt_u32.h
> +header-y += xt_vlan.h
> diff --git a/include/uapi/linux/netfilter/xt_vlan.h b/include/uapi/linux/netfilter/xt_vlan.h
> new file mode 100644
> index 0000000..3c31b6b
> --- /dev/null
> +++ b/include/uapi/linux/netfilter/xt_vlan.h
> @@ -0,0 +1,11 @@
> +#ifndef _XT_VLAN_H
> +#define _XT_VLAN_H
> +
> +
> +struct xt_vlan_info {
> +	unsigned short vlan_id;
> +	unsigned char vlan_pcp;

Please consider using explicit types for all of these, i.e.
	__u16 vlan_id;
	__u8 vlan_pcp;

> +MODULE_ALIAS("ipt_vlan");
> +MODULE_ALIAS("ip6t_vlan");
> +MODULE_ALIAS("ipt_VLAN");
> +MODULE_ALIAS("ip6t_VLAN");

_VLAN aliases are only needed for -j VLAN target, which isn't
added here, please remove them.

> +static bool vlan_mt(const struct sk_buff *skb, struct xt_action_param *par)
> +{
> +	const struct xt_vlan_info *info = par->matchinfo;
> +	u16 vlan_tci = ~VLAN_TAG_PRESENT;
> +	bool ret;
> +
> +	if (skb->vlan_tci & VLAN_TAG_PRESENT)
> +		/* Strip the 4096 bit (invalid vlan) from the vlan tci bits */
> +		vlan_tci = skb->vlan_tci;

if (skb_vlan_tag_present(skb))
	vlan_tci = skb_vlan_tag_get(skb);

> +	else {
> +		if (unlikely(skb->len < VLAN_ETH_HLEN &&

This is weird.  Why test len < VLAN_ETH_HLEN (> ? >= ? )

> +			     skb->protocol == htons(ETH_P_8021Q)))
> +			if (unlikely(!parse_vlan(skb, &vlan_tci)))
> +				return false;
> +			else
> +				return false;
> +	}

Why call parse_vlan?  We always return false without looking at
vlan_tci...
