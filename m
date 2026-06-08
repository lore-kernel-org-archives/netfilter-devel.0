Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DE2C3382CB;
	Mon,  8 Jun 2026 11:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780918931; cv=none; b=scVXCJqhiEj8t1C5lssFMbsgLTc3BjAGMT72YRB8LBn2NPe/t/2752DSLD1n5XWF2Z/yhy+71/dfvEPcA/f9gcRaTPcqKw3BR+9tXvkAlubs5dvrB7oXozTBEkZ5lJ7e0PKmBIfg5tkOjoVsJnOsGTsg2N5+qu4QmTtkNu9hgU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780918931; c=relaxed/simple;
	bh=ov11AtdknOjbPbvEAuBtvvbQw4lFh5u2GwL6JfHXgHw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qwbKaDNwoZ22iGeGLmhLHKMoWcf565UQWmCV6A9E0AbJV65FPw3JN7xShEpxncILZmtCvzIFOIyz2l451djg/ohomo0wvFqEOkZEV/YAQMlPRFP/XQBfHSlBaemPOTz15QjHr0cJ5qxyK2NITJKphXol0QWQO98Ej86c579JPTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=QNEWST2G; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="QNEWST2G"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id C7CB8600B9;
	Mon,  8 Jun 2026 13:42:06 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1780918926;
	bh=ErubEafeLo+zjsNDtJUeukGYGLNVb+8KI47j6seZuTM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QNEWST2GoLlzAlfmanPqgD3vPuXvd6Py6x+rdG9Rw023QwtSPUSayqhm5bKkfaphE
	 Y0wnNyybrMEGrJmObV8JMD0NH7LhaEcNu2q0MF1GZN5WdCEPPoy5m/i8bgw+KynJRj
	 +OKNKIDx7HTR6+qyJ+R9jJFUGc8mpT4OhdSVP3KKDyO0AIIPCAKPoEG55ole1re3Qu
	 OdF30kz/xKM79XPxty+UzMlSiTzzy4SndlUiGjI5lpxAhutTfp6pWCQAELNRacTtfO
	 0iHkQkDpFhmfzTA2W0Z8cCUd0nR6mC4rdjjI5AfvLbU4lNRYQbI0iV4kyClvUUUmqU
	 HorIxBcRpJnYg==
Date: Mon, 8 Jun 2026 13:42:04 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Sayooj K Karun <sayooj@aerlync.com>
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>, netdev@vger.kernel.org,
	edumazet@google.com
Subject: Re: [PATCH nf-next] netfilter: nf_reject_ipv6: do not reject ICMPv6
 Redirect with an ICMPv6 error
Message-ID: <aiaqjP8q-UQ0YUK0@chamomile>
References: <20260608103155.8339-1-sayooj@aerlync.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260608103155.8339-1-sayooj@aerlync.com>

On Mon, Jun 08, 2026 at 04:01:55PM +0530, Sayooj K Karun wrote:
> While fixing is_ineligible() for the L3 reject path, the bridge/netdev
> reject path was found to have the same defect. RFC 4443 section 2.4(e.2)
> mandates that an ICMPv6 error MUST NOT be originated in response to an
> ICMPv6 Redirect message (type 137).
> 
> There are two IPv6 reject paths, and they suppress this in different
> places. The L3 path (ip6t_REJECT / nft_reject -> nf_send_unreach6())
> goes through icmpv6_send(), where is_ineligible() decides whether the
> triggering packet may generate an error; a companion fix makes that gate
> drop errors in response to a Redirect. The bridge/netdev path
> (nft_reject_bridge / nft_reject_netdev -> nf_reject_skb_v6_unreach())
> builds the ICMPv6 packet itself and never reaches is_ineligible().
> Its local guard, nf_skb_is_icmp6_unreach(), only matched
> ICMPV6_DEST_UNREACH and let every other type through,
> including Redirect.
> 
> A triggerable scenario: a bridge or netdev firewall with a REJECT rule
> applied to incoming ICMPv6 traffic (e.g., dropping Redirects from an
> untrusted segment). When the Redirect hits the REJECT rule,
> nf_reject_skb_v6_unreach() builds and transmits a Destination Unreachable
> in response. Without this fix the guard lets the Redirect through and the
> error is erroneously sent, violating the RFC.
> 
> Extend the guard, renamed nf_skb_is_icmp6_unreach_or_redirect(), to also
> match NDISC_REDIRECT so that Redirect packets are skipped and both reject
> paths behave consistently.
> 
> Link: https://lore.kernel.org/ah_hYJa3byoUyose@chamomile
> Signed-off-by: Sayooj K Karun <sayooj@aerlync.com>
> ---
>  net/ipv6/netfilter/nf_reject_ipv6.c | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/net/ipv6/netfilter/nf_reject_ipv6.c b/net/ipv6/netfilter/nf_reject_ipv6.c
> index ef5b7e85c..d4eec8d9a 100644
> --- a/net/ipv6/netfilter/nf_reject_ipv6.c
> +++ b/net/ipv6/netfilter/nf_reject_ipv6.c
> @@ -8,6 +8,7 @@
>  #include <net/ip6_route.h>
>  #include <net/ip6_fib.h>
>  #include <net/ip6_checksum.h>
> +#include <net/ndisc.h>
>  #include <net/netfilter/ipv6/nf_reject.h>
>  #include <linux/netfilter_ipv6.h>
>  #include <linux/netfilter_bridge.h>
> @@ -104,7 +105,7 @@ struct sk_buff *nf_reject_skb_v6_tcp_reset(struct net *net,
>  }
>  EXPORT_SYMBOL_GPL(nf_reject_skb_v6_tcp_reset);
>  
> -static bool nf_skb_is_icmp6_unreach(const struct sk_buff *skb)
> +static bool nf_skb_is_icmp6_unreach_or_redirect(const struct sk_buff *skb)
>  {
>  	const struct ipv6hdr *ip6h = ipv6_hdr(skb);
>  	u8 proto = ip6h->nexthdr;
> @@ -127,7 +128,7 @@ static bool nf_skb_is_icmp6_unreach(const struct sk_buff *skb)
>  	if (!tp)
>  		return false;
>  
> -	return *tp == ICMPV6_DEST_UNREACH;
> +	return *tp == ICMPV6_DEST_UNREACH || *tp == NDISC_REDIRECT;
>  }
>  
>  struct sk_buff *nf_reject_skb_v6_unreach(struct net *net,
> @@ -143,8 +144,13 @@ struct sk_buff *nf_reject_skb_v6_unreach(struct net *net,
>  	if (!nf_reject_ip6hdr_validate(oldskb))
>  		return NULL;
>  
> -	/* Don't reply to ICMPV6_DEST_UNREACH with ICMPV6_DEST_UNREACH */
> -	if (nf_skb_is_icmp6_unreach(oldskb))
> +	/* Don't reply to ICMPV6_DEST_UNREACH with ICMPV6_DEST_UNREACH, and
> +	 * per RFC 4443 section 2.4(e.2) never originate an ICMPv6 error in
> +	 * response to an ICMPv6 Redirect. The L3 reject path enforces this
> +	 * via icmpv6_send()/is_ineligible(); this bridge/netdev path builds
> +	 * the packet itself, so it must check explicitly.

Please, shorter comment. With all these AI generated comments,
codebase will bloat soon. Comments are usually reserve to non-obvious
stuff IIRC, this extra validation can be possibly documented in the
new nf_skb_is_icmp6_unreach_or_redirect_or_something_else().

> +	 */
> +	if (nf_skb_is_icmp6_unreach_or_redirect(oldskb))

Please, use more generic function:

        nf_skb_icmp6_is_valid()

so this can grown with any other future extension without adding
another _or_something_else() to the function name.

Thanks.

>  		return NULL;
>  
>  	/* Include "As much of invoking packet as possible without the ICMPv6
> -- 
> 2.54.0
> 
