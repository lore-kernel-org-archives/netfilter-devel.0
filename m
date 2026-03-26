Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3442933CEBB;
	Thu, 26 Mar 2026 20:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774556511; cv=none; b=JQvnH9elcWxC3m72j2O4aglkFoNVhl4VpzHKzBf2CxlUvV9k/g+B9cDfCW4KWUjheHPxjFn64IR6leQBzd9GsPVrdHIGB7Ls3Pd5FNRxne1EyNjv50cIeKUqjs70N4ChlQY47V/qWJZiRdH+eBL6VFRZOqAXNo6HVKpJ9QbwTMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774556511; c=relaxed/simple;
	bh=sjBIaQIJ3lM8oaURKVY3teKRZko/3BU/LQ5VCIK1n1w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Povc/nRdcJHnkbjt3Fb/OROP07VkUNY72j/361lyp7JU+LG4CFcWMUdCYfqvxpBa1LUVROH9BvTr+GPb6035XOxN+MWBXCakJ4h7kXjBGuKyr6iPHyda4vclGf57dxk45oBhAYzLFpPywlbukbiMSIUNSXF0RBMPwTmgYslBuBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=PfpHeDGn; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="PfpHeDGn"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id DDAA160262;
	Thu, 26 Mar 2026 21:21:46 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1774556507;
	bh=XVG1PdwNY/KMdNBwdSih/WCTXGUheIF/+ZYN0DkQ1Aw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PfpHeDGnDQjZouFiuDFWOTp+Z7MqLYSmhGwJkqh7OrIlVxfe19VpQxFIiKK3UAvrz
	 qfVnvnpVt1zSd41E9+6+T0RGjPdMatvAohvEwKg2L0PpX0pixN2cTmHL+eR+a/32yx
	 B8U+5MtHLbBAAJD96czYLgeYVJ1a8okuwDiFGEVSN/bv9iFf7qAaSuxFsEbEm65LLu
	 tLMwsVc3iuSMzLqt+AcUz6Scm7/zkmEbGJPGoJjWK0ZGGDOAb1780Fr7r0A9IUm98a
	 tHKo+XKRA/8zpOBfwkifrQR3rFrq8tLEgIdv3y0KiahjsTyTvev+Rdon9tr8C0aW+L
	 zrbEK60vbejIQ==
Date: Thu, 26 Mar 2026 21:21:43 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Weiming Shi <bestswngs@gmail.com>
Cc: Florian Westphal <fw@strlen.de>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Phil Sutter <phil@nwl.cc>, Simon Horman <horms@kernel.org>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Xiang Mei <xmei5@asu.edu>
Subject: Re: [PATCH nf] netfilter: nf_conntrack_sip: fix use of uninitialized
 rtp_addr in process_sdp
Message-ID: <acWVV__8xRMezYrU@chamomile>
References: <20260323080727.2932866-3-bestswngs@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260323080727.2932866-3-bestswngs@gmail.com>

On Mon, Mar 23, 2026 at 04:07:29PM +0800, Weiming Shi wrote:
> process_sdp() declares union nf_inet_addr rtp_addr on the stack and
> passes it to the nf_nat_sip sdp_session hook after walking the SDP
> media descriptions. However rtp_addr is only initialized inside the
> media loop when a recognized media type with a non-zero port is found.
> 
> If the SDP body contains no m= lines, only inactive media sections
> (m=audio 0 ...) or only unrecognized media types, rtp_addr is never
> assigned. Despite that, the function still calls hooks->sdp_session()
> with &rtp_addr, causing nf_nat_sdp_session() to format the stale stack
> value as an IP address and rewrite the SDP session owner and connection
> lines with it.
> 
> With CONFIG_INIT_STACK_ALL_ZERO (default on most distributions) this
> results in the session-level o= and c= addresses being rewritten to
> 0.0.0.0 for inactive SDP sessions. Without stack auto-init the
> rewritten address is whatever happened to be on the stack.
> 
> Fix this by pre-initializing rtp_addr from the session-level connection
> address (caddr) when available, and tracking via a have_rtp_addr flag
> whether any valid address was established. Skip the sdp_session hook
> entirely when no valid address exists.
> 
> Fixes: 4ab9e64e5e3c ("[NETFILTER]: nf_nat_sip: split up SDP mangling")
> Reported-by: Xiang Mei <xmei5@asu.edu>
> Signed-off-by: Weiming Shi <bestswngs@gmail.com>
> ---
>  net/netfilter/nf_conntrack_sip.c | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
> index 4ab5ef71d96db..17af0ff4ea7ab 100644
> --- a/net/netfilter/nf_conntrack_sip.c
> +++ b/net/netfilter/nf_conntrack_sip.c
> @@ -1040,6 +1040,7 @@ static int process_sdp(struct sk_buff *skb, unsigned int protoff,
>  	unsigned int port;
>  	const struct sdp_media_type *t;
>  	int ret = NF_ACCEPT;
> +	bool have_rtp_addr = false;
>  
>  	hooks = rcu_dereference(nf_nat_sip_hooks);
>  
> @@ -1056,8 +1057,11 @@ static int process_sdp(struct sk_buff *skb, unsigned int protoff,
>  	caddr_len = 0;
>  	if (ct_sip_parse_sdp_addr(ct, *dptr, sdpoff, *datalen,
>  				  SDP_HDR_CONNECTION, SDP_HDR_MEDIA,
> -				  &matchoff, &matchlen, &caddr) > 0)
> +				  &matchoff, &matchlen, &caddr) > 0) {
>  		caddr_len = matchlen;
> +		memcpy(&rtp_addr, &caddr, sizeof(rtp_addr));
> +		have_rtp_addr = true;
> +	}
>  
>  	mediaoff = sdpoff;
>  	for (i = 0; i < ARRAY_SIZE(sdp_media_types); ) {
> @@ -1091,9 +1095,11 @@ static int process_sdp(struct sk_buff *skb, unsigned int protoff,
>  					  &matchoff, &matchlen, &maddr) > 0) {
>  			maddr_len = matchlen;
>  			memcpy(&rtp_addr, &maddr, sizeof(rtp_addr));
> -		} else if (caddr_len)
> +			have_rtp_addr = true;
> +		} else if (caddr_len) {
>  			memcpy(&rtp_addr, &caddr, sizeof(rtp_addr));
> -		else {
> +			have_rtp_addr = true;

After this update, this loop sets over rtp_addr, but this was already
set by ct_sip_parse_sdp_addr() a bit above.

This new chunk results in:

                } else if (caddr_len) {
                       memcpy(&rtp_addr, &caddr, sizeof(rtp_addr));
                       have_rtp_addr = true;

which is not needed? Why does caddr need to be copied over and over
again to rtp_addr?

> +		} else {
>  			nf_ct_helper_log(skb, ct, "cannot parse SDP message");
>  			return NF_DROP;
>  		}
