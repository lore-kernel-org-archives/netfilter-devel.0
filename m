Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FA0135AC16
	for <netfilter-devel@vger.kernel.org>; Fri, 24 Apr 2026 11:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777030733; cv=none; b=pCPkr3UVooou8yGbvN0Xbv3jpKSYNIu29YU5K9RxVMJCqpc4YcNm6ijdJ5+J+S/xU4hoq+viSmdsGA2Xp8rxqT69yASzzWJiYINPAsrvdX2YDC0aKVKb2TgazkkoEZJI+Tp13RFXjgzyQBGx/cx5VXXX2i09TNjdZ9d+f8LAScw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777030733; c=relaxed/simple;
	bh=dd4VSX8zN52gWvtHxal+e9AJtvMRezMoRnA98S+0Rx4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JaFoOAseClA8q+0t/5vd7tBnb50T5EXy32sul9hGYRt1OVYCjdPnp925aQ3kCd/GN9Vz1UIJ8o0YXMW70UlIpFzjpZwUskHWSR/YXDfhv8G2I7bZHQfxxUvgpPCU48YqIoZIjAjgY9NFpuh4c4kDXHNKpS/c41PkTTba5WV5bns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ulw5rn4o; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ulw5rn4o"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 40544600B5;
	Fri, 24 Apr 2026 13:38:49 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1777030729;
	bh=FGkeGAy5imd3I5zZvlJxVTBProSb0PFCXfGkXsDPKdc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ulw5rn4ojgNTyTqyZpglgrDew2kggqrtTFNb+cv9Pq5GhCHYAQKloO8Qr4WiPS3So
	 2kzIbNg7Q89ojijoaLJrCs42RQlJ5nKAv+MpkZB1UnPPMEicMbt0SpmFNQGAU7Vo2f
	 CIhLZeDb8pjVyQz5YOQx0JtkMjo1LImOJ3jzpBVChUShwEJ5sc9svjWCwtDMxgdtVo
	 OvVDK0pVaIV50JJJqgFX+KOhRbMwQ3WEnJ4As4TwVfpWssLKvXYvFmWiNp+0kHO5ix
	 z9cU9/XHoqKfUOl0dWSpofu9yLCfks1v7bzrlfHDaUjNYZTX8uSuZxkncMjbP0wQbm
	 Y0+uFQNSwCuqg==
Date: Fri, 24 Apr 2026 13:38:46 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	ecklm94@gmail.com, phil@nwl.cc, fw@strlen.de
Subject: Re: [PATCH 3/3 nf v3] netfilter: xtables: fix L4 header parsing for
 non-first fragments
Message-ID: <aetWRt8_AlLabPtm@chamomile>
References: <20260421104409.5452-1-fmancera@suse.de>
 <20260421104409.5452-3-fmancera@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260421104409.5452-3-fmancera@suse.de>

On Tue, Apr 21, 2026 at 12:44:09PM +0200, Fernando Fernandez Mancera wrote:
> Multiple targets and matches relies on L4 header to operate. For
> fragmented packets, every fragment carries the transport protocol
> identifier, but only the first fragment contains the L4 header.
> 
> As the 'raw' table can be configured to run at priority -450 (before
> defragmentation at -400), the target/match can be reached before
> reassembly. In this case, non-first fragments have their payload
> incorrectly parsed as a TCP/UDP header. This would be of course a
> misconfiguration scenario. In most of the cases this just lead to a
> unreliable behavior for fragmented traffic.
> 
> Add a fragment check to ensure target/match only evaluates unfragmented
> packets or the first fragment in the stream.

AI reports xt_hashlimit could be a good candidate to check for
fragoff, I think it is, so I would suggest to expand it there to cover
this.

It also mentions synproxy as another candidate but IPv6 synproxy does
not do ipv6_find_hdr() on purpose I think (it assumed nexthdr is TCP)
for SYN and ACK packets, so checking for fragoff there is not
possible. Given this is to deal with flood, I think think it is worth
the fragoff validation.

> Fixes: 902d6a4c2a4f ("netfilter: nf_defrag: Skip defrag if NOTRACK is set")
> Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
> ---
> v2: handled ecn, socket and tcpmss matches
> v3: extracted socket to its own patch with a generic solution for
> nft/xt, added a comment specifying that par->fragoff is fine for
> ecn/tcpmss ipv6 as they enforce -p tcp. Keep on mind that osf only
> supports ipv4.
> ---
>  net/netfilter/xt_TPROXY.c | 11 +++++++++--
>  net/netfilter/xt_ecn.c    |  4 ++++
>  net/netfilter/xt_osf.c    |  3 +++
>  net/netfilter/xt_tcpmss.c |  4 ++++
>  4 files changed, 20 insertions(+), 2 deletions(-)
> 
> diff --git a/net/netfilter/xt_TPROXY.c b/net/netfilter/xt_TPROXY.c
> index e4bea1d346cf..5f60e7298a1e 100644
> --- a/net/netfilter/xt_TPROXY.c
> +++ b/net/netfilter/xt_TPROXY.c
> @@ -86,6 +86,9 @@ tproxy_tg4_v0(struct sk_buff *skb, const struct xt_action_param *par)
>  {
>  	const struct xt_tproxy_target_info *tgi = par->targinfo;
>  
> +	if (par->fragoff)
> +		return NF_DROP;
> +
>  	return tproxy_tg4(xt_net(par), skb, tgi->laddr, tgi->lport,
>  			  tgi->mark_mask, tgi->mark_value);
>  }
> @@ -95,6 +98,9 @@ tproxy_tg4_v1(struct sk_buff *skb, const struct xt_action_param *par)
>  {
>  	const struct xt_tproxy_target_info_v1 *tgi = par->targinfo;
>  
> +	if (par->fragoff)
> +		return NF_DROP;
> +
>  	return tproxy_tg4(xt_net(par), skb, tgi->laddr.ip, tgi->lport,
>  			  tgi->mark_mask, tgi->mark_value);
>  }
> @@ -106,6 +112,7 @@ tproxy_tg6_v1(struct sk_buff *skb, const struct xt_action_param *par)
>  {
>  	const struct ipv6hdr *iph = ipv6_hdr(skb);
>  	const struct xt_tproxy_target_info_v1 *tgi = par->targinfo;
> +	unsigned short fragoff = 0;
>  	struct udphdr _hdr, *hp;
>  	struct sock *sk;
>  	const struct in6_addr *laddr;
> @@ -113,8 +120,8 @@ tproxy_tg6_v1(struct sk_buff *skb, const struct xt_action_param *par)
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
> diff --git a/net/netfilter/xt_ecn.c b/net/netfilter/xt_ecn.c
> index b96e8203ac54..a8503f5d26bf 100644
> --- a/net/netfilter/xt_ecn.c
> +++ b/net/netfilter/xt_ecn.c
> @@ -30,6 +30,10 @@ static bool match_tcp(const struct sk_buff *skb, struct xt_action_param *par)
>  	struct tcphdr _tcph;
>  	const struct tcphdr *th;
>  
> +	/* this is fine for IPv6 as ecn_mt_check6() enforces -p tcp */
> +	if (par->fragoff)
> +		return false;
> +
>  	/* In practice, TCP match does this, so can't fail.  But let's
>  	 * be good citizens.
>  	 */
> diff --git a/net/netfilter/xt_osf.c b/net/netfilter/xt_osf.c
> index dc9485854002..e8807caede68 100644
> --- a/net/netfilter/xt_osf.c
> +++ b/net/netfilter/xt_osf.c
> @@ -27,6 +27,9 @@
>  static bool
>  xt_osf_match_packet(const struct sk_buff *skb, struct xt_action_param *p)
>  {
> +	if (p->fragoff)
> +		return false;
> +
>  	return nf_osf_match(skb, xt_family(p), xt_hooknum(p), xt_in(p),
>  			    xt_out(p), p->matchinfo, xt_net(p), nf_osf_fingers);
>  }
> diff --git a/net/netfilter/xt_tcpmss.c b/net/netfilter/xt_tcpmss.c
> index 0d32d4841cb3..b9da8269161d 100644
> --- a/net/netfilter/xt_tcpmss.c
> +++ b/net/netfilter/xt_tcpmss.c
> @@ -32,6 +32,10 @@ tcpmss_mt(const struct sk_buff *skb, struct xt_action_param *par)
>  	u8 _opt[15 * 4 - sizeof(_tcph)];
>  	unsigned int i, optlen;
>  
> +	/* this is fine for IPv6 as xt_tcpmss enforces -p tcp */
> +	if (par->fragoff)
> +		return false;
> +
>  	/* If we don't have the whole header, drop packet. */
>  	th = skb_header_pointer(skb, par->thoff, sizeof(_tcph), &_tcph);
>  	if (th == NULL)
> -- 
> 2.53.0
> 
