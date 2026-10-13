Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D63B84E324D;
	Tue, 13 Oct 2026 23:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791934598; cv=none; b=IFQg+htOOoSHIhUKIFIomYfPlgJqY74DGRoJYVsbskyLXQjk/5g3BVwKTa1SDauojOmsiXwD75WadQit8YI+V/TVJwWhAOaiDTGuaGxP7o67Pq9ZJ3cfpWnTyA9KLdPcm2+0kzk63mUMtcTwpEGyPvcGrZ5MN/gvxBqVDWCSJmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791934598; c=relaxed/simple;
	bh=Ce8cicOS5z0ItaLXPL2Ql3h4uEoRx2vQ9NtI7XkE31o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lPOu+0o3YUD31DCxDbR92ZgfZn7lfc7PNf1G+lldNgo3LJF8qIrE24zuPPP7LsEtoXHp3tw6hlcCnPI3HWOGa7Wak+Fs511R8xvHMN8kEacU9odvduhfqS/nrmoKEfMmCqm952mkKpLrjJHjyXaphOwooOmh9e4UKcS6QqlY3uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=u2gFDmny; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="u2gFDmny"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1791934580;
	bh=grwBgkgno9BkL6eOhMPmakqn4LngPKm6vtO8+CsatwE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=u2gFDmnyn7DkPrCsCVJ5N/faghNyP8s7EPZ8Xor8e/11rLH7aXxrL26zzvWpp7ssC
	 x2ifLD5M7KZkal4u/iaRYFvgPsbve/eC8rIKd1Dns1PztmByWoRSIODnqee8Qz54Sk
	 QdLQ5HHtkOy01Z+Wt4I5sa6A/Oyds+EsJHyScCJwBjaR+7Rk0IJ51O74HrzHIZxoK4
	 ONgtyi6KdZ3bifRNLVqcME8cwhr3F9lNkOeJ4QWbDWYlB+fkZFe4xKd9wYjLVfNmLS
	 cegs8WHPf6TWv8SupnFPxr2NZsWKEynb6BA31ybmW0lkP8kv0Pawg44L453gP1VM9q
	 Liei/VGeKn+RQ==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 4617A60055;
	Wed, 14 Oct 2026 01:36:20 +0200 (CEST)
Date: Wed, 14 Oct 2026 01:36:17 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Guo Zihao <guozh23@xiaopeng.com>
Cc: Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH nf-next v3 1/2] netfilter: ebtables: ebt_802_3: check the
 LLC fields before reading them
Message-ID: <as7AcSGT8U2kbdH3@chamomile>
References: <20261012072449.3240201-1-guozh23@xiaopeng.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261012072449.3240201-1-guozh23@xiaopeng.com>

On Mon, Oct 12, 2026 at 03:24:48PM +0800, Guo Zihao wrote:
> ebt_802_3_mt() takes the frame pointer from skb_mac_header() and reads
> the LLC fields through it without making sure those bytes are there.
> Nothing between the receive path and this match pulls the LLC header,
> so a frame that carries nothing past the 14-byte Ethernet header is
> read past the linear area.

See:

 003f21868b2b ("llc: move the type 2 sockets out of tree")

We can handle this patch in nf-next as low priority.

> The match also reads more of the LLC header than rules look at. A
> SAP-only rule uses dsap/ssap; a rule without any SAP or TYPE constraint
> matches 802.3 frames without touching the LLC header at all, just as it
> did before this patch.
> 
> Require only the bytes each rule actually examines, and go through
> skb_header_pointer() with the mac header offset so short frames fail
> the match instead of being read past the linear area. A frame shorter
> than the fields the rule looks at simply does not match that rule;
> users who want such frames dropped can match 802.3 alone.
> 
> The match itself is not restricted to 802.3 frames: the ebtables
> userspace tool pairs it with "-p Length", but the kernel does not
> enforce that pairing and nft_compat does not run ebt_basic_match(),
> so a SAP or TYPE rule can still see Ethernet II payload bytes,
> bounds checks aside, same as before.
> 
> v2:
>  - rework to skb_header_pointer() with a per-rule length instead of
>    hotdrop, whose semantics differ between ebtables legacy and nftables
>  - read only dsap/ssap for SAP-only rules
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Reviewed-by: Liu Chao <liuc63@xiaopeng.com>
> Signed-off-by: Guo Zihao <guozh23@xiaopeng.com>
> ---
>  net/bridge/netfilter/ebt_802_3.c | 35 +++++++++++++++++++++++---------
>  1 file changed, 25 insertions(+), 10 deletions(-)
> 
> diff --git a/net/bridge/netfilter/ebt_802_3.c b/net/bridge/netfilter/ebt_802_3.c
> index 68c2519bd..fc49f7c7b 100644
> --- a/net/bridge/netfilter/ebt_802_3.c
> +++ b/net/bridge/netfilter/ebt_802_3.c
> @@ -9,32 +9,47 @@
>   *
>   */
>  #include <linux/module.h>
> +#include <linux/stddef.h>
>  #include <linux/netfilter/x_tables.h>
>  #include <linux/netfilter_bridge/ebtables.h>
>  #include <linux/skbuff.h>
>  #include <uapi/linux/netfilter_bridge/ebt_802_3.h>
>  
> -static struct ebt_802_3_hdr *ebt_802_3_hdr(const struct sk_buff *skb)
> -{
> -	return (struct ebt_802_3_hdr *)skb_mac_header(skb);
> -}
> -
>  static bool
>  ebt_802_3_mt(const struct sk_buff *skb, struct xt_action_param *par)
>  {
>  	const struct ebt_802_3_info *info = par->matchinfo;
> -	const struct ebt_802_3_hdr *hdr = ebt_802_3_hdr(skb);
> -	__be16 type = hdr->llc.ui.ctrl & IS_UI ? hdr->llc.ui.type : hdr->llc.ni.type;
> +	struct ebt_802_3_hdr _frame;
> +	const struct ebt_802_3_hdr *frame;
> +	unsigned int hlen;
> +	__be16 type;
> +
> +
> +	if (!(info->bitmask & (EBT_802_3_SAP | EBT_802_3_TYPE)))
> +		return true;
> +
> +
> +	hlen = sizeof(_frame);
> +	if (!(info->bitmask & EBT_802_3_TYPE))
> +		hlen = offsetof(struct ebt_802_3_hdr, llc.ui.ctrl);
> +
> +
> +	frame = skb_header_pointer(skb, skb_mac_offset(skb), hlen, &_frame);
> +	if (!frame)
> +		return false;
>  
>  	if (info->bitmask & EBT_802_3_SAP) {
> -		if (NF_INVF(info, EBT_802_3_SAP, info->sap != hdr->llc.ui.ssap))
> +		if (NF_INVF(info, EBT_802_3_SAP, info->sap != frame->llc.ui.ssap))
>  			return false;
> -		if (NF_INVF(info, EBT_802_3_SAP, info->sap != hdr->llc.ui.dsap))
> +		if (NF_INVF(info, EBT_802_3_SAP, info->sap != frame->llc.ui.dsap))
>  			return false;
>  	}
>  
>  	if (info->bitmask & EBT_802_3_TYPE) {
> -		if (!(hdr->llc.ui.dsap == CHECK_TYPE && hdr->llc.ui.ssap == CHECK_TYPE))
> +		type = frame->llc.ui.ctrl & IS_UI ? frame->llc.ui.type :
> +						    frame->llc.ni.type;
> +		if (!(frame->llc.ui.dsap == CHECK_TYPE &&
> +		      frame->llc.ui.ssap == CHECK_TYPE))
>  			return false;
>  		if (NF_INVF(info, EBT_802_3_TYPE, info->type != type))
>  			return false;
> -- 
> 2.50.1
> 
