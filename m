From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCHv2 2/2] Addrtype match extension: limit addrtype check
 on the packet's interface
Date: Wed, 14 Nov 2007 11:25:01 +0100
Message-ID: <473ACCFD.50604@trash.net>
References: <11932356911253-git-send-email-panther@balabit.hu> <1193235691233-git-send-email-panther@balabit.hu> <1193235691956-git-send-email-panther@balabit.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Laszlo Attila Toth <panther@balabit.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:40292 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbXKNKZM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 14 Nov 2007 05:25:12 -0500
In-Reply-To: <1193235691956-git-send-email-panther@balabit.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Laszlo Attila Toth wrote:
> Addrtype match has a new revision (1), which lets address type checking
> limit to the interface the current packet belongs to. The limitation
> cannot be applied in the FORWARD hook.
> 
> Revision 0 lets older userspace programs use the match as earlier.

Dave has opened his net-2.6.25 tree, so time to look at this again.


> +static bool addrtype_match_v1(const struct sk_buff *skb,
> +		const struct net_device *in, const struct net_device *out,
> +		const struct xt_match *match, const void *matchinfo,
> +		int offset, unsigned int protoff, bool *hotdrop)
> +{
> +	const struct ipt_addrtype_info_v1 *info = matchinfo;
> +	const struct iphdr *iph = ip_hdr(skb);
> +	const struct net_device *limit_dev = NULL;
> +	bool ret = true;
> +
> +	/* not valid in the FORWARD hook */
> +	if (info->flags & IPT_ADDRTYPE_LIMIT_IFACE)
> +		limit_dev = (in ? in : out); 

I would prefer if the user specifies the device to use (in/out)
and have proper checks that its not used on hooks where its
invalid. That would also allow to use it in the FORWARD hook.
Using a single device also doesn't seem to make much sense
in case the match is on both source and dest.

> +
> +	if (info->source)
> +		ret &= match_type(iph->saddr, limit_dev, info->source) ^
> +			(info->flags & IPT_ADDRTYPE_INVERT_SOURCE);
> +	if (ret && (info->dest))

Unnecessary parens.

> +		ret &= match_type(iph->daddr, limit_dev, info->dest) ^
> +			(info->flags & IPT_ADDRTYPE_INVERT_DEST);
> +	
> +	return ret;
> +}
> +
> +static bool addrtype_checkentry_v1(const char *tablename, const void *ip_void,
> +		const struct xt_match *match,
> +		void *matchinfo, unsigned int hook_mask)
> +{
> +	struct ipt_addrtype_info_v1 *info = matchinfo;
> +
> +	if (hook_mask & (1 << NF_IP_FORWARD)
> +	   && info->flags & IPT_ADDRTYPE_LIMIT_IFACE) {

Please don't reintroduce the weird && on continuation line style, I
try to get rid of it whenever I touch some code.



