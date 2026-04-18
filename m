Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67EAA3644CB;
	Sat, 18 Apr 2026 07:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776498690; cv=none; b=T64rZAg+h5Xdui8wTPw2se91YjO/ueSLNWMvH0M5qUDGnPrqpCtvUMuGiGXB4wNQOQYWwKg+vdaNABuBPBXb2jRU4ZbWzocELi6t6XWRS4rMfBxGJWXdO4++HBJgNu8z+2td8KXSOAgtB/23CgMWSwFmkW6ZcOWw3wh94Avv+Hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776498690; c=relaxed/simple;
	bh=BMkgJzDL+oiqv9x9HEIkTgqyb/PaHrYn6jFf03Lj2f4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WWGihI0p6bdStp/8clRjZXOZpfhJ2pO/ummFWaKWaV58yVgbLt1d+4R1pgiSxK1nEdZ1bHMm7pteHkBt7isTyXLH+aDp5mGR8xJEnm4Al4MXwAZXARyjBGLK23RGliKWikoeT6vA3UeKFGJR4Qpgc12YVogJAi7tnrrYLsUfQxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=WRIFZ5PH; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="WRIFZ5PH"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 680896017D;
	Sat, 18 Apr 2026 09:51:27 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1776498687;
	bh=9hg+2DmKNidHN0aBbUt5Dnqce9J1vTMyv2N9DM7xdfo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WRIFZ5PHPx2s2HAmGljclCrvjb6ft4y/+/lSbCWTHaLBS7nv/3vJb622HG4de9pU/
	 zinsigPyl/BL2mZPcF9zCWw91XttgJuKh61d7WYs7OiDbzSpb+019pMcFFZScqWbYI
	 kEj/AmCE4RTjPtG3hZ2hSZLmI19h4kUiFzOLaFQlB3YDQkUepcdE7Ja5KZWJatTA73
	 J901b6aAGcnYTp9BSD42f1ysRXH5ocaONQvHGixt7ydAWYZ7rVoEPe7uMPI+fAB+ki
	 CueN1cnGYzRzv6421V033aKCHVjXjkaIhfGw+8f79SbqbkmkMJ2/Ryx1joLCQYVPp1
	 DxF3FFNVBdfyw==
Date: Sat, 18 Apr 2026 09:51:24 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
	coreteam@netfilter.org, fw@strlen.de, phil@nwl.cc
Subject: Re: [PATCH 4/4 nf] netfilter: xtables: fix L4 header parsing for
 non-first fragments
Message-ID: <aeM3_LYycra3M1qZ@chamomile>
References: <20260417183433.4739-1-fmancera@suse.de>
 <20260417183433.4739-6-fmancera@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260417183433.4739-6-fmancera@suse.de>

On Fri, Apr 17, 2026 at 08:34:35PM +0200, Fernando Fernandez Mancera wrote:
> The TPROXY target and osf match relies on L4 header to operate. For
> fragmented packets, every fragment carries the transport protocol
> identifier, but only the first fragment contains the L4 header.
> 
> As the 'raw' table can be configured to run at priority -450 (before
> defragmentation at -400), the target/match can be reached before
> reassembly. In this case, non-first fragments have their payload
> incorrectly parsed as a TCP/UDP header.

I see, this refers to a misconfiguration scenario.

> Add a fragment check to ensure TPROXY/osf only evaluates unfragmented
> packets or the first fragment in the stream.

LGTM this combo patch for osf and TPROXY in xtables.

Thanks.

> Fixes: 902d6a4c2a4f ("netfilter: nf_defrag: Skip defrag if NOTRACK is set")
> Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
> ---
>  net/netfilter/xt_TPROXY.c | 8 ++++++--
>  net/netfilter/xt_osf.c    | 3 +++
>  2 files changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/net/netfilter/xt_TPROXY.c b/net/netfilter/xt_TPROXY.c
> index e4bea1d346cf..ac4b011ce48c 100644
> --- a/net/netfilter/xt_TPROXY.c
> +++ b/net/netfilter/xt_TPROXY.c
> @@ -40,6 +40,9 @@ tproxy_tg4(struct net *net, struct sk_buff *skb, __be32 laddr, __be16 lport,
>  	struct udphdr _hdr, *hp;
>  	struct sock *sk;
>  
> +	if (ip_is_fragment(iph))
> +		return NF_DROP;
> +
>  	hp = skb_header_pointer(skb, ip_hdrlen(skb), sizeof(_hdr), &_hdr);
>  	if (hp == NULL)
>  		return NF_DROP;
> @@ -106,6 +109,7 @@ tproxy_tg6_v1(struct sk_buff *skb, const struct xt_action_param *par)
>  {
>  	const struct ipv6hdr *iph = ipv6_hdr(skb);
>  	const struct xt_tproxy_target_info_v1 *tgi = par->targinfo;
> +	unsigned short fragoff = 0;
>  	struct udphdr _hdr, *hp;
>  	struct sock *sk;
>  	const struct in6_addr *laddr;
> @@ -113,8 +117,8 @@ tproxy_tg6_v1(struct sk_buff *skb, const struct xt_action_param *par)
>  	int thoff = 0;
>  	int tproto;
>  
> -	tproto = ipv6_find_hdr(skb, &thoff, -1, NULL, NULL);
> -	if (tproto < 0)
> +	tproto = ipv6_find_hdr(skb, &thoff, -1, &fragoff, NULL);
> +	if (tproto < 0 || fragoff)
>  		return NF_DROP;
>  
>  	hp = skb_header_pointer(skb, thoff, sizeof(_hdr), &_hdr);
> diff --git a/net/netfilter/xt_osf.c b/net/netfilter/xt_osf.c
> index dc9485854002..889dff4daff0 100644
> --- a/net/netfilter/xt_osf.c
> +++ b/net/netfilter/xt_osf.c
> @@ -27,6 +27,9 @@
>  static bool
>  xt_osf_match_packet(const struct sk_buff *skb, struct xt_action_param *p)
>  {
> +	if (ip_is_fragment(ip_hdr(skb)))
> +		return false;
> +
>  	return nf_osf_match(skb, xt_family(p), xt_hooknum(p), xt_in(p),
>  			    xt_out(p), p->matchinfo, xt_net(p), nf_osf_fingers);
>  }
> -- 
> 2.53.0
> 
