Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792707088;
	b=Vj/iA9cNEBPGl6pQYowHWpHYUzgEyatzzyEvaiwalCOTMNneoMANdB+MSoPSWle7F5of
	 T1+HNnea/hZ1hTZlQrClNvGbHgnkxQ/WgbwlVsgiZsM90kN1+/QoZk4YxVEJRMiZvwusH
	 vB4193kzZxLRcnXRCp+DVjy6+e5FOQrJIoDY1+msjX+1SLPWNHJU3/2lSDRIch1yUr/RK
	 pwiAJ5x2X19qT2lfcVJZ1TpHgkrYML7SyMcAqobN6zyiRriGvPcwZXrVY5S/HAM3S7YVI
	 NOY4MruyfvCS3lMVWwz71VVXfCpeSzvTw27/kc1+5xD9LaxFf8+aKyXUAeuxyE85d8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792707088;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Status:X-Spam-Checker-Version;
	bh=gDCc8bYTabW9GpVpUmevMVkl4eEzvJg1MShw16KA2dQ=;
	b=kzF83QhMnJkXnARuD63CIXCzeL/jlHJl8hhA9kruVZjQ2+K/FtNyzIw0+zzSzRsv3Zf1
	 /hpFeNxBssdi4HwMt5hWnOyXUs2tfYMOp+TD19jkCp+T4LdtIetyQ8//1+mpzK8qD62kC
	 uvnp7/+ylKxDuUprUZiMY74X5V1UgOTf1FaD/ZH2fdub5aQBm4HkFxiFYXnRby0VZPrdZ
	 obn3DsWzNnrX2Ta0jiKAqV6j3oYHJPTvup+QqMm+qmP8UnVlL2VgzBSfe3rhTE4IlVfl1
	 uiuufJ1U16jo9EvKJjnM2zE2Z3V/LuTvvQp9wbwtgF/AebJN5IRSup51MEd25F4PXnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=qG9pG1Ro;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 19DDE606A31A
	for <netfilter-devel@vger.kernel.org>; Thu, 22 Oct 2026 22:11:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 19DDE606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=qG9pG1Ro
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1792707085;
	bh=gDCc8bYTabW9GpVpUmevMVkl4eEzvJg1MShw16KA2dQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qG9pG1Ro/cpT8ymfJAZD6OQW4k+lXT+HWli9TIAHqWwk11nYcECxLlXlyjtfNSLEf
	 bpbI39xiaFKTfum82ozJr2aI+d848Q2ZVBiRwRGGKjB1cC5y0JF0hzhABRcrzMcsWT
	 qEtaxWRS9t0ugnsUBLRj0qkpUaEPQctcy833DINDzHOiMDyJBrTXHzPQQudCOg6rAb
	 07WW1nxBDAuu28LzAOuMbpjHJ/GoBcta4QfRiz/ENoMqbrcN+HdwQUauys9OlGRxd+
	 hXPtFjV1N2lWkXJugwOi2F4Brnmu92619WzWeISYuD5U109iwZxpoGNQSyOtmZGcv9
	 NQKIP0fgaEQnA==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id EA1646005E;
	Fri, 23 Oct 2026 00:11:24 +0200 (CEST)
Date: Fri, 23 Oct 2026 00:11:22 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf,v4] netfilter: nf_reject_ipv6: fix locally generated
 packet to local address
Message-ID: <atqKCsIbAn35HIse@chamomile>
References: <20261022155854.2004977-1-pablo@netfilter.org>
 <396660ef-055b-4311-8e85-455f82636910@suse.de>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <396660ef-055b-4311-8e85-455f82636910@suse.de>

On Thu, Oct 22, 2026 at 07:16:01PM +0200, Fernando Fernandez Mancera wrote:
> On 10/22/26 5:58 PM, Pablo Neira Ayuso wrote:
> > Fix reject expression in inet/ingress for locally generated IPv6 packets
> > that are sent to a local address on ethX arrives through lo, really
> > perform the similar handling as ip6_rcv_core().
> > 
> > Reported by sashiko.
> > 
> > Fixes: 73a73d442f99 ("netfilter: nf_reject: initialize IPCB at inet ingress")
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > ---
> > v4: do not move route lookup before, this seems to interfer with the special loopback case.
> > 
> >   net/ipv6/netfilter/nf_reject_ipv6.c | 13 ++++++++++++-
> >   1 file changed, 12 insertions(+), 1 deletion(-)
> > 
> > diff --git a/net/ipv6/netfilter/nf_reject_ipv6.c b/net/ipv6/netfilter/nf_reject_ipv6.c
> > index 5e08d8529cc8..8551e40faf04 100644
> > --- a/net/ipv6/netfilter/nf_reject_ipv6.c
> > +++ b/net/ipv6/netfilter/nf_reject_ipv6.c
> > @@ -445,8 +445,19 @@ void nf_send_unreach6(struct net *net, struct sk_buff *skb_in,
> >   		skb_in->dev = net->loopback_dev;
> >   	if (hooknum == NF_INET_INGRESS) {
> > +		const struct inet6_dev *idev;
> > +
> >   		memset(IP6CB(skb_in), 0, sizeof(*IP6CB(skb_in)));
> > -		IP6CB(skb_in)->iif = skb_in->skb_iif;
> > +
> > +		if (skb_valid_dst(skb_in)) {
> > +			idev = ip6_dst_idev(skb_dst(skb_in));
> > +			if (idev)
> > +				IP6CB(skb_in)->iif = idev->dev->ifindex;
> > +			else
> > +				IP6CB(skb_in)->iif = skb_in->dev->ifindex;
> > +		} else {
> > +			IP6CB(skb_in)->iif = skb_in->dev->ifindex;
> > +		}
> >   	}
> 
> 
> Hi Pablo, I did a bit of testing and patch LGTM.

May I have your Tested-by: tag?

> Could we maybe simplify the code a bit by using a helper? Something like:
> 
> static int nf_reject6_ingress_iff(const struct sk_buff *skb)
> {
> 	const struct inet6_dev *idev;
> 
> 	if (skb_valid_dst(skb)) {
> 		idev = ip6_dst_idev(skb_dst(skb));
> 		if (idev)
> 			return idev->dev->ifindex;
> 	}
> 
> 	return skb->dev->ifindex;
> }
> 
> Then at nf_send_unreach6() we can do:
> 
> IP6CB(skb_in)->iif = nf_reject6_ingress_iif(skb_in);
>
> If I am not wrong, compiler should just inline the helper and there should
> not be a performance hit. In addition, the code is cleaner from my point of
> view.
> 
> What do you think?

That sounds fine, I will post a v5.

