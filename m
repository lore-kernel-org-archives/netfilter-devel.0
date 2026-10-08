Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFF28438026;
	Thu,  8 Oct 2026 10:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791456713; cv=none; b=A3ggcOxQZOCipSk4rd8la5Z/thMwIcJQYA8wYgAXWsMtsX+/oX80zEc664i1IFMR2YybSVfaAFd6WXrxA2gpARl1jf7AVeztoDXjRQzFi+fqX6rBkmfHcFMk/LANe4eXs9RPuqbnkHMRri9IdTmvzPpQikJ8yniwHVTXXTqBHio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791456713; c=relaxed/simple;
	bh=IgSi8ze2FTXdDie611B60zd8rg52AoQub9eV5+WPkrY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f43ZcxJJ1gyPaVimEJa85kk7E4HieDUZi+wRYA045T1onMgOqwQ4z8VFEWrOXkltgRCdQ5QdUmhqkYLMri4eJGQV3F6Dog3S/coVW5FEZGf5oW+vGOJKBqSj175MS9J2Do1sCLdNs/kHQiq3txECI5A6FPngWseHfqGLp8NfI08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=N0ewA1g2; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="N0ewA1g2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1791456700;
	bh=4emq/40xD4/yc1153ChVOKdV9NbDgEhWISmsRkHHXCM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=N0ewA1g2OlAd2GMDP6e283JMJ8CdzYV+EWrO0PIsyow5bBGrckEOqIUXXB2l6MZry
	 7GAARP08XU6e7rq5d8RiemZNVVSYQyl6z3g/O9S8FGtuzXiADx7GHNU8kLxC1GmZhM
	 5w4nWTS6qHdvfLi3PF0nNK6kHfnYf/BHSjXCF7OVXs3q3oNOiE5vYgrX79q/c1Aggs
	 0tbD392lKNRSltJ7Uqd6Tf8+tEn/rgQtN1qqoQwAzCvutF4xej8gzT0EAbsxrgu++m
	 wOeexIguqAUdCsKyLf/bmkpigOhaUNXwigqAPemcqks5bY9NMxTsnmqgBPnjo6WRVF
	 1DARJUkHjvd2w==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 60B6F60055;
	Thu,  8 Oct 2026 12:51:40 +0200 (CEST)
Date: Thu, 8 Oct 2026 12:51:37 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Guo Zihao <guozh23@xiaopeng.com>
Cc: Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, bridge@lists.linux.dev,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2] netfilter: ebtables: ebt_802_3: check the LLC
 fields before reading them
Message-ID: <asd1uX2tWn9LtsUT@chamomile>
References: <20261008024539.4106699-1-guozh23@xiaopeng.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261008024539.4106699-1-guozh23@xiaopeng.com>

On Thu, Oct 08, 2026 at 10:45:39AM +0800, Guo Zihao wrote:
> ebt_802_3_mt() derives the frame pointer from skb_mac_header() and reads
> the LLC fields through it without making sure that those bytes are
> available at all. ebtables guarantees that the Ethernet header is linear,
> but nothing between the receive path and this match pulls the LLC header,
> so a frame that carries nothing past the 14-byte Ethernet header is read
> past the linear area.
> 
> Also, ebt_802_3_mt() does not need to look at every LLC field for every
> rule. A SAP-only rule reads only dsap and ssap, and a rule without any
> SAP or TYPE constraint selects frames by their 802.3 length field alone,
> which ebt_basic_match() has already handled. Reading the type field there
> was wasted work and could not be checked against anything.
> 
> Go through skb_header_pointer() with the mac header offset, which handles
> frames whose LLC header is not in the linear area, and require only the
> bytes each rule actually examines:
> 
>  - no SAP or TYPE constraint: nothing to look at, match right away;
>  - SAP-only rule: dsap/ssap, at machdr + 14..15;
>  - TYPE rule: the whole union, at machdr + 14..23, which also covers the
>    control byte that selects between the ui and ni views of the union.
> 
> A frame too short to hold the fields a rule examines now fails to match
> that rule. The previous hotdrop approach was dropped because ebtables
> legacy only honors hotdrop when every match of the rule so far has
> matched, so returning false is the only behaviour both front-ends agree
> on. Users who want truncated 802.3 frames dropped can match 802.3 alone.
> 
> Discovered by a static-analysis scan of net/; confirmed by code
> inspection of the receive path and the ebtables core. Not triggered in
> testing; no runtime report is available.

If no reproducible crash, then this has to be targeted at nf-next.

And llc support has been removed from the kernel IIRC.

> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Reviewed-by: Liu Chao <liuc63@xiaopeng.com>
> Signed-off-by: Guo Zihao <guozh23@xiaopeng.com>
> ---
>  net/bridge/netfilter/ebt_802_3.c | 47 +++++++++++++++++++++++++-------
>  1 file changed, 37 insertions(+), 10 deletions(-)
> 
> diff --git a/net/bridge/netfilter/ebt_802_3.c b/net/bridge/netfilter/ebt_802_3.c
> index 68c2519bd..1a67376d1 100644
> --- a/net/bridge/netfilter/ebt_802_3.c
> +++ b/net/bridge/netfilter/ebt_802_3.c
> @@ -9,32 +9,59 @@
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
> +	/* Without SAP or TYPE constraints the match only selects 802.3
> +	 * frames, which ebt_basic_match() has already decided from the
> +	 * ethertype/length field. Nothing in the LLC header is read.
> +	 */
> +	if (!(info->bitmask & (EBT_802_3_SAP | EBT_802_3_TYPE)))
> +		return true;
> +
> +	/* Only the dsap/ssap pair is examined for a SAP-only rule; the
> +	 * type field (and the control byte that selects between the ui
> +	 * and ni views of the union) is needed for a TYPE rule alone.
> +	 */
> +	hlen = sizeof(_frame);
> +	if (!(info->bitmask & EBT_802_3_TYPE))
> +		hlen = offsetof(struct ebt_802_3_hdr, llc.ui.ctrl);
> +
> +	/* skb->data sits past the Ethernet header on the receive path, so
> +	 * the frame starts at a negative offset from skb->data. Pass the
> +	 * mac header offset so the check follows the frame wherever the
> +	 * hook reset the mac header, and covers paged frames too. A frame
> +	 * too short to hold the LLC fields simply does not match; users
> +	 * who want such frames dropped can match 802.3 alone.
> +	 */

I don't think it is worth to add so many comments in the code for
this, the skb_header_pointer() call plus what you can retrieve via
'git annotate' is sufficient to document why this
skb_header_pointer() is needed.

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
