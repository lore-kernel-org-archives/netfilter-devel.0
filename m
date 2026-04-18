Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B34D012B94
	for <netfilter-devel@vger.kernel.org>; Sat, 18 Apr 2026 07:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776497725; cv=none; b=DPMrUzZeYuu7fYRcjf9+UNY9XS9Rq/ofnEeNoCsAPh2s7ZmDYYPnbbUT7IsHRKwqwV2xiDTXRsJLBvvQtdEjI7KsQvfK4G9jEoPZ4fIB6hg6Qap2UjrPXZs0/ISGHlL4AgHaqOEXnT2gjys8Ot1YMOWywVY92suksUUzuIiC4MY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776497725; c=relaxed/simple;
	bh=Cf/pJrTZLEiAV616Nmw9XUtngQdekDMLt/ow+U9z+VA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K2V0OL0G8RPihtXhAF3HGy31BGOkwc7opqTQr8RIKdkTIb6SET0+/kDF3HLBXloWrdAep8AVsGyGuE7CUxfW+epg/ThHJgM4bBibe2Q/tciLuOPokUPmgpH+9q+mNLl5BKZoMuXOg1odrZFoYCCoSUYrad/ZNzRdg+l6TMxbzfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=G/XkuYNg; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="G/XkuYNg"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id B5A4760177;
	Sat, 18 Apr 2026 09:28:07 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1776497287;
	bh=2xmlsraU38wls5r3dWhGbOWtCifRuAxGsJm3ose5Zxo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=G/XkuYNgq7WlKQX2BDhNe2GD8TbKRV2Zo5KmGzIJKgvYqejQMBhPLBUKIm8YSyn7J
	 0excfr3bBOfMjfRowYeFN2pzqI9evzZGE5ygBoL2t55dk+6LjSmcdOXWPsvnWf3aNc
	 OXrUK0BXPSpDTzpKlfC1sCOb/tjbvGYpy+nzzw+we7IrnZBne0yZkZvXCeCNERMTXs
	 /kzr4dV7SGDH/Bz9V//5gomih+J1s0P+MpXGPZoeht3Ry4Qmts8lhLEzscoSzBEKE0
	 ot3vw1YEWiXs5thYC1fhFMkQ/jBTcsJKk/nXag/kBljjcI9qOkxmdPcC+1RDAxuDKG
	 gOLHcYDtQN70w==
Date: Sat, 18 Apr 2026 09:28:05 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: arp_tables: fix IEEE1394 ARP payload
 mangling
Message-ID: <aeMyhUwPwj2kB6Xa@chamomile>
References: <20260417131910.17932-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260417131910.17932-1-fw@strlen.de>

Hi Florian,

On Fri, Apr 17, 2026 at 03:19:05PM +0200, Florian Westphal wrote:
> sashiko.dev noticed that similar bug pattern exists in arpt_mangle:
>   "IEEE1394 ARP payloads omit the target hardware address, advancing
>   arpptr by hln after the source IP address skips over the actual target
>   IP address."
> 
> Apply similar fix: check dev->type.  If we're asked to mangle what
> doesn't exist, drop the packet.

I included a fix for this in:

https://patchwork.kernel.org/project/netdevbpf/patch/20260417091422.342615-1-pablo@netfilter.org/

I forgot to mangle the patch title though to:

        netfilter: arp_tables: fix IEEE1394 ARP payload parsing

> Fixes: 6752c8db8e0c ("firewire net, ipv4 arp: Extend hardware address and remove driver-level packet inspection.")
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  Collides with a inflight patch.

Are you referring to the patch I made?

>  I'll rebase or discard depending on what netdev@ does.
> 
>  net/ipv4/netfilter/arpt_mangle.c | 23 ++++++++++++++++++++++-
>  1 file changed, 22 insertions(+), 1 deletion(-)
> 
> diff --git a/net/ipv4/netfilter/arpt_mangle.c b/net/ipv4/netfilter/arpt_mangle.c
> index a4e07e5e9c11..5a3560e1b59b 100644
> --- a/net/ipv4/netfilter/arpt_mangle.c
> +++ b/net/ipv4/netfilter/arpt_mangle.c
> @@ -13,6 +13,7 @@ static unsigned int
>  target(struct sk_buff *skb, const struct xt_action_param *par)
>  {
>  	const struct arpt_mangle *mangle = par->targinfo;
> +	bool has_tgt_devaddr = true;
>  	const struct arphdr *arp;
>  	unsigned char *arpptr;
>  	int pln, hln;
> @@ -39,13 +40,33 @@ target(struct sk_buff *skb, const struct xt_action_param *par)
>  		memcpy(arpptr, &mangle->u_s.src_ip, pln);
>  	}
>  	arpptr += pln;
> +
> +	if (IS_ENABLED(CONFIG_FIREWIRE_NET)) {
> +		const struct net_device *dev = skb->dev;
> +
> +		if (!dev) {
> +			/* can't munge without arphrd type. */
> +			if (mangle->flags & (ARPT_MANGLE_TDEV|ARPT_MANGLE_TIP))
> +				return NF_DROP;
> +			return mangle->target;
> +		}
> +
> +		if (dev->type == ARPHRD_IEEE1394)
> +			has_tgt_devaddr = false;
> +	}
> +
>  	if (mangle->flags & ARPT_MANGLE_TDEV) {
> +		if (!has_tgt_devaddr)
> +			return NF_DROP;
> +
>  		if (ARPT_DEV_ADDR_LEN_MAX < hln ||
>  		   (arpptr + hln > skb_tail_pointer(skb)))
>  			return NF_DROP;
>  		memcpy(arpptr, mangle->tgt_devaddr, hln);
>  	}
> -	arpptr += hln;
> +	if (has_tgt_devaddr)
> +		arpptr += hln;
> +
>  	if (mangle->flags & ARPT_MANGLE_TIP) {
>  		if (ARPT_MANGLE_ADDR_LEN_MAX < pln ||
>  		   (arpptr + pln > skb_tail_pointer(skb)))
> -- 
> 2.52.0
> 
> 
