Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E93DF30CDA5;
	Thu, 28 Aug 2025 12:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756382433; cv=none; b=ahlbY8kQVxGDxzh/L3KoDP0+epyMGCVZI2ECzGFSKm28l3uVUl6aUJULIngQIJbxYk5EEf202cPgVprn5DIEPyDG6ag5HzWE3gbO86V3ixYS6qloJjj2k47ICgH++ReoFgSNZ5uIoYReRNC1nNfxL7XZ5Un6q4s0kJkPYFvvJv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756382433; c=relaxed/simple;
	bh=3fBYa02GGUyO5ZDt61o9vUhK73n+F3lSgJu64QvsnXI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m2lnFmq8agbeUjMR9KkDdQtiVER2HMBZQBFngf8SOjEtbj8QSmhG2LXT+eGrAdfAYoLvDLH4OQX3q4QW588Mh8Tp+6+SfYLGvktjNxtogzUy8e7U2mmHCIuGMIBgoHlTAWffplAEJu1hFzJklJYlIxPttZXgbUV+L7vZcudEawY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=CIQpT33d; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=cPq2RHEx; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="CIQpT33d";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="cPq2RHEx"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id C5C2060634; Thu, 28 Aug 2025 14:00:28 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1756382428;
	bh=HjVj7tasxLhD6OPcmErYYrA4srC7AUHm5WpZ8Ny4Ypg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CIQpT33dxG6R2o9f1k0nXR+NCvncJrYPJyXalMOTTA6Slpb7IxoFZ4IAeKao7BlZV
	 r2iscAtcelM4iJ/ptmSe5J+M6dX2Kby+0DXqrom2lE7sGetgJ0fejPdDkdqBJjHd1y
	 XMSJXfgwJqHUOo4O3a2zhFVoAU+UrJYHdnl3nYGe/hABUqG5ZUunPI62LLO8DSt9TR
	 9HupeC+M94tDjd6z9bBqae8+cYtBewy3fkhVBTeTjdcr+eqEIPDUiSQpr0gmJsmcMV
	 ozIWBYenLhwjmwqtXCVpYQELuaJuGEWLDXFPBT265ov0B5LC1vdU/sbQO0v+v4Sf47
	 Po+5z08LdryBA==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 4E92D60624;
	Thu, 28 Aug 2025 14:00:27 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1756382427;
	bh=HjVj7tasxLhD6OPcmErYYrA4srC7AUHm5WpZ8Ny4Ypg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cPq2RHExwCNHNURhY2TlTaji4JsiAAf1EFAe8WjchAtczc0dr0SpekkjlSo81u848
	 mzsjBkQFBFgnnQCRWH5HbCD0MWLiwNQT26qS2irjhLVztD+zaS5WfcXjSjqUJDJeHi
	 A5pQ2CtJaNmEeiDufI1/g2GX9/NCgN721af2TMaQr9N9jjPP5XJzp6/6g6GuGWPQmT
	 Gv7N/ymP1RSqKzzwT1hKW4G/XckNgnVCZLSKtbURum9IavPPMBEnIH3ReDrtK2AzBY
	 El32MEaz5MNoonONuEHg8nnXp0S1/rE4vxscJQVk5o97OLSUNFB/BG0NxFUKMdgIgc
	 Ko9IYo66MYsbg==
Date: Thu, 28 Aug 2025 14:00:24 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Fabian =?utf-8?B?QmzDpHNl?= <fabian@blaese.de>
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v3] icmp: fix icmp_ndo_send address translation for reply
 direction
Message-ID: <aLBE2Ee7pUBzUupH@calendula>
References: <20250825203826.3231093-1-fabian@blaese.de>
 <20250828091435.161962-1-fabian@blaese.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250828091435.161962-1-fabian@blaese.de>

On Thu, Aug 28, 2025 at 11:14:35AM +0200, Fabian Bläse wrote:
> The icmp_ndo_send function was originally introduced to ensure proper
> rate limiting when icmp_send is called by a network device driver,
> where the packet's source address may have already been transformed
> by SNAT.
> 
> However, the original implementation only considers the
> IP_CT_DIR_ORIGINAL direction for SNAT and always replaced the packet's
> source address with that of the original-direction tuple. This causes
> two problems:
> 
> 1. For SNAT:
>    Reply-direction packets were incorrectly translated using the source
>    address of the CT original direction, even though no translation is
>    required.
> 
> 2. For DNAT:
>    Reply-direction packets were not handled at all. In DNAT, the original
>    direction's destination is translated. Therefore, in the reply
>    direction the source address must be set to the reply-direction
>    source, so rate limiting works as intended.
> 
> Fix this by using the connection direction to select the correct tuple
> for source address translation, and adjust the pre-checks to handle
> reply-direction packets in case of DNAT.
> 
> Additionally, wrap the `ct->status` access in READ_ONCE(). This avoids
> possible KCSAN reports about concurrent updates to `ct->status`.

I think such concurrent update cannot not happen, NAT bits are only
set for the first packet of a connection, which sets up the nat
configuration, so READ_ONCE() can go away.

Florian?

> Fixes: 0b41713b6066 ("icmp: introduce helper for nat'd source address in network device context")
> 
> Signed-off-by: Fabian Bläse <fabian@blaese.de>
> Cc: Jason A. Donenfeld <Jason@zx2c4.com>
> Cc: Florian Westphal <fw@strlen.de>
> ---
> Changes v1->v2:
> - Implement fix for ICMPv6 as well
> 
> Changes v2->v3:
> - Collapse conditional tuple selection into a single direction lookup [Florian]
> - Always apply source address translation if IPS_NAT_MASK is set [Florian]
> - Wrap ct->status in READ_ONCE()
> - Add a clearer explanation of the behaviour change for DNAT
> ---
>  net/ipv4/icmp.c     | 6 ++++--
>  net/ipv6/ip6_icmp.c | 6 ++++--
>  2 files changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
> index 2ffe73ea644f..c48c572f024d 100644
> --- a/net/ipv4/icmp.c
> +++ b/net/ipv4/icmp.c
> @@ -799,11 +799,12 @@ void icmp_ndo_send(struct sk_buff *skb_in, int type, int code, __be32 info)
>  	struct sk_buff *cloned_skb = NULL;
>  	struct ip_options opts = { 0 };
>  	enum ip_conntrack_info ctinfo;
> +	enum ip_conntrack_dir dir;
>  	struct nf_conn *ct;
>  	__be32 orig_ip;
>  
>  	ct = nf_ct_get(skb_in, &ctinfo);
> -	if (!ct || !(ct->status & IPS_SRC_NAT)) {
> +	if (!ct || !(READ_ONCE(ct->status) & IPS_NAT_MASK)) {
>  		__icmp_send(skb_in, type, code, info, &opts);
>  		return;
>  	}
> @@ -818,7 +819,8 @@ void icmp_ndo_send(struct sk_buff *skb_in, int type, int code, __be32 info)
>  		goto out;
>  
>  	orig_ip = ip_hdr(skb_in)->saddr;
> -	ip_hdr(skb_in)->saddr = ct->tuplehash[0].tuple.src.u3.ip;
> +	dir = CTINFO2DIR(ctinfo);
> +	ip_hdr(skb_in)->saddr = ct->tuplehash[dir].tuple.src.u3.ip;
>  	__icmp_send(skb_in, type, code, info, &opts);
>  	ip_hdr(skb_in)->saddr = orig_ip;
>  out:
> diff --git a/net/ipv6/ip6_icmp.c b/net/ipv6/ip6_icmp.c
> index 9e3574880cb0..233914b63bdb 100644
> --- a/net/ipv6/ip6_icmp.c
> +++ b/net/ipv6/ip6_icmp.c
> @@ -54,11 +54,12 @@ void icmpv6_ndo_send(struct sk_buff *skb_in, u8 type, u8 code, __u32 info)
>  	struct inet6_skb_parm parm = { 0 };
>  	struct sk_buff *cloned_skb = NULL;
>  	enum ip_conntrack_info ctinfo;
> +	enum ip_conntrack_dir dir;
>  	struct in6_addr orig_ip;
>  	struct nf_conn *ct;
>  
>  	ct = nf_ct_get(skb_in, &ctinfo);
> -	if (!ct || !(ct->status & IPS_SRC_NAT)) {
> +	if (!ct || !(READ_ONCE(ct->status) & IPS_NAT_MASK)) {
>  		__icmpv6_send(skb_in, type, code, info, &parm);
>  		return;
>  	}
> @@ -73,7 +74,8 @@ void icmpv6_ndo_send(struct sk_buff *skb_in, u8 type, u8 code, __u32 info)
>  		goto out;
>  
>  	orig_ip = ipv6_hdr(skb_in)->saddr;
> -	ipv6_hdr(skb_in)->saddr = ct->tuplehash[0].tuple.src.u3.in6;
> +	dir = CTINFO2DIR(ctinfo);
> +	ipv6_hdr(skb_in)->saddr = ct->tuplehash[dir].tuple.src.u3.in6;
>  	__icmpv6_send(skb_in, type, code, info, &parm);
>  	ipv6_hdr(skb_in)->saddr = orig_ip;
>  out:
> -- 
> 2.51.0
> 
> 
