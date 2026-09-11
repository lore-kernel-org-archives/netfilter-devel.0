Received: from mx.ssi.bg (mx.ssi.bg [193.238.174.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 581A13CCA12;
	Fri, 11 Sep 2026 09:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.238.174.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789120610; cv=none; b=UNvn06vUQ6gZz+G91QXGQ5F7SoKpyAtw2jrVwZc3DEl/ZTPtanbw8HKl2ETW0a6tGTHb/ZzAC7dc8/jbit7dKv+SENsV3iy6bz86AoTIfW+vkDnm5edXyoKwBqWWdPRd2qaTlltLJLZorEzrTUmRnID51SPLRAMcmBcdtcz11QA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789120610; c=relaxed/simple;
	bh=2/zgO5qFC0vD7GreCUnc4sngpDYat7tLdQtuKob/aK0=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=SSbQ0nSEa7OSt0GblUaF1RV8gWDNYa3ti1nSgQhJRYhSys5iNQngtjFd1UiNPbouNU9vBVeOG1IFfpdeX8bLfPv8HItVrRV/J63SocGgYCBGylaMDmDO8ObuO7y7unlO4dbRKR+j4UHGtOaNotdNkw1m9HLs+iaoXlOhZRTRYLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ssi.bg; spf=pass smtp.mailfrom=ssi.bg; dkim=pass (4096-bit key) header.d=ssi.bg header.i=@ssi.bg header.b=07rHOolG; arc=none smtp.client-ip=193.238.174.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ssi.bg
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ssi.bg
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=ssi.bg header.i=@ssi.bg header.b="07rHOolG"
Received: from mx.ssi.bg (localhost [127.0.0.1])
	by mx.ssi.bg (Potsfix) with ESMTP id B3FA822741;
	Fri, 11 Sep 2026 12:56:31 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ssi.bg; h=cc:cc
	:content-type:content-type:date:from:from:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=ssi;
	 bh=6bi4XJJww/dCl6im5jLb+/7zH+UuaGeerHxuvCaQzoA=; b=07rHOolGceeo
	mwuZQeFraDd7PWA+qFzRsR9aT+0m5nDwr60u01gT2BkxtAa1eNRpf1aMCpNTmq+o
	+FRgPVDUreiZoQkuT8KA5BZHhN77GD9yLgeoms+crfM1mRCW/wMJGZsTF/HRR+VD
	fino6IMu3rSuWTr9xdxky16wkkzVnkuVONaxx7+LwA+84Iyn9tdl0y79akX/KHhz
	bf05BbAUut6bhvuO2ZuoaAJ53x709xTVvtPtDYyj3pGrWLTiAmVpgma+zTecDz6f
	5mWCimtXr7o99JyaIbtV9LvXQSg7lGavsk+iGrgr00fOoyV4kysl7j2nO+Wl149s
	akUOp/70NRfIpQ0h2X64quYkZOZMIbU8taEw2Phu1gSsCEQ88uxHksyvtRXOj9aG
	C3Z8b7aAU4vjV4KFKuQFiTGWpDWijI0YBtxuvD6kDmMzcgejrMGLPunzHHFXXUKP
	MwyBJ8kJVO5pdCrCgHsS7EcNY0ddZNXTwj5gkPEKklhcpub8v/edmYkDm3mN6P5u
	AVz/WgTxFDN5SScRTdX8v0l4OWs3vBJZmLqo9T4lsN3TtFZTlCPHSAm4rfvgFkcD
	tP2Pq5/4SLEqs1dQCZde7tHKVQ7x/65Ro9GiklO1iW+n+584RSiwsQ24tGfoNfLG
	LbrCfvlcXDDbkrLn9GmeZnR4VVYHIRw=
Received: from box.ssi.bg (box.ssi.bg [193.238.174.46])
	by mx.ssi.bg (Potsfix) with ESMTPS;
	Fri, 11 Sep 2026 12:56:31 +0300 (EEST)
Received: from ja.ssi.bg (unknown [213.16.62.126])
	by box.ssi.bg (Potsfix) with ESMTPSA id 332E960948;
	Fri, 11 Sep 2026 12:56:33 +0300 (EEST)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by ja.ssi.bg (8.18.2/8.18.2) with ESMTP id 68B9uVLX020080;
	Fri, 11 Sep 2026 12:56:31 +0300
Date: Fri, 11 Sep 2026 12:56:31 +0300 (EEST)
From: Julian Anastasov <ja@ssi.bg>
To: Jakub Kicinski <kuba@kernel.org>
cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
        horms@kernel.org, fw@strlen.de
Subject: Re: [PATCH net 4/7] ipvs: revalidate ihl before icmp_send
In-Reply-To: <20260911004648.2877894-1-kuba@kernel.org>
Message-ID: <117ea9ac-0af3-9801-4ab4-78999f94849a@ssi.bg>
References: <20260909221844.1650275-5-pablo@netfilter.org> <20260911004648.2877894-1-kuba@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII


	Hello,

On Thu, 10 Sep 2026, Jakub Kicinski wrote:

> This is an AI-generated review of your patch. The human sending this
> email has considered the AI review valid, or at least plausible.
> ---
> ipvs: revalidate ihl before icmp_send
> 
> This adds a check in ip_vs_in_icmp() that drops the packet when the
> embedded IP header's ihl no longer matches the length that was validated
> from the frag copy, sets the transport header before icmp_send(), and
> passes the tunnel protocol to ipv4_update_pmtu() instead of 0.
> 
> Link: https://sashiko.dev/#/patchset/20260806105211.34622-1-ja%40ssi.bg
> 
> A few questions below.

	I'll send v2 to address the problems, thanks!

> 
> > diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
> > index ba0957798bad0..c41fac3ed873e 100644
> > --- a/net/netfilter/ipvs/ip_vs_core.c
> > +++ b/net/netfilter/ipvs/ip_vs_core.c
> > @@ -1934,7 +1934,8 @@ ip_vs_in_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb, int *related,
> >  			IP_VS_DBG(12, "ICMP for %s %pI4->%pI4: mtu=%u\n",
> >  				  outer_proto, &ip_hdr(skb)->saddr,
> >  				  &ip_hdr(skb)->daddr, mtu);
> > -			ipv4_update_pmtu(skb, ipvs->net, mtu, 0, 0);
> > +			ipv4_update_pmtu(skb, ipvs->net, mtu, 0,
> > +					 ip_hdr(skb)->protocol);
> 
> [Severity: Medium]
> 
> The new protocol argument becomes fl4.flowi4_proto inside
> ipv4_update_pmtu()->__build_flow_key(), and it is used both by
> __ip_route_output_key() and by the fib_lookup() in
> __ip_rt_update_pmtu().
> 
> The route IPVS actually transmits these tunnel packets on is looked up
> and cached by do_output_route4(), which leaves flowi4_proto at zero:
> 
> net/netfilter/ipvs/ip_vs_xmit.c:do_output_route4() {
> 	memset(&fl4, 0, sizeof(fl4));
> 	fl4.daddr = daddr;
> 	fl4.flowi4_flags = (rt_mode & IP_VS_RT_MODE_KNOWN_NH) ?
> 			   FLOWI_FLAG_KNOWN_NH : 0;
> 	...
> }
> 
> and fib4_rule_match() keys on that field:
> 
> net/ipv4/fib_rules.c:fib4_rule_match() {
> 	...
> 	if (rule->ip_proto && (rule->ip_proto != fl4->flowi4_proto))
> 		return 0;
> 	...
> }
> 
> With an FRA_IP_PROTO rule configured, can the two lookups now land in
> different tables, so the exception ends up on a nexthop IPVS never
> consults?  The read-back immediately below would then still return the
> unreduced MTU:
> 
> 			if (dest) {
> 				struct ip_vs_dest_dst *dest_dst;
> 
> 				dest_dst = rcu_dereference(dest->dest_dst);
> 				if (dest_dst)
> 					mtu = dst_mtu(dest_dst->dst_cache);
> 			}
> 
> and the ICMP relayed to the client would advertise the stale larger
> value, leaving the passive PMTUD added by f2edb9f7706d ineffective for
> such setups.
> 
> The multipath variant of this does not seem to apply, since
> __ip_rt_update_pmtu() installs the exception on every path when
> fib_info_num_path(res.fi) > 1.
> 
> Other in-tree callers of ipv4_update_pmtu() pass the real protocol, but
> they also set flowi4_proto on their transmit lookup; IPVS does not.
> Would it make sense to set flowi4_proto in do_output_route4() as well,
> so the two keys agree?
> 
> [Severity: Medium]
> 
> Under the same assumption the commit message makes, that a local process
> can mutate the bytes between the frag read and the pull, is the protocol
> byte read here trusted?
> 
> Everything that authorized this tunnel was checked on the on-stack copy
> taken earlier in ip_vs_in_icmp():
> 
> 	cih = skb_header_pointer(skb, offset, sizeof(_ciph), &_ciph);
> 	if (!cih)
> 		return NF_ACCEPT;	/* The packet looks wrong, ignore */
> 	hlen_ipip = cih->ihl * 4;
> 	if (!(cih->version == 4 && hlen_ipip >= sizeof(struct iphdr)))
> 		return NF_ACCEPT;	/* The packet looks wrong, ignore */
> 	raddr = (union nf_inet_addr *)&cih->daddr;
> 	...
> 	if (cih->protocol == IPPROTO_IPIP) {
> 	...
> 	} else if ((cih->protocol == IPPROTO_UDP ||
> 		    cih->protocol == IPPROTO_GRE) &&
> 
> whereas ip_hdr(skb)->protocol here is re-read from the linear area after
> pskb_may_pull(skb, hlen_ipip).  If those bytes can change, the value fed
> to ipv4_update_pmtu(), and hence fl4.flowi4_proto for
> __ip_route_output_key() and update_or_create_fnhe(), is not necessarily
> the IPIP/UDP/GRE value that was validated, which works against the
> "provide correct protocol to ipv4_update_pmtu()" goal.
> 
> Would saving cih->protocol into a local at validation time and passing
> that local here be preferable to re-reading the header?
> 
> For what it is worth, the saddr/daddr/tos that __build_flow_key() reads
> from skb->data at this call site have the same exposure, but that part
> predates this patch.
> 
> >  			/* Client uses PMTUD? */
> >  			if (!(frag_off & htons(IP_DF)))
> >  				goto ignore_tunnel;
> > @@ -1960,6 +1961,12 @@ ip_vs_in_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb, int *related,
> >  		/* Ensure the IP header is present in headroom */
> >  		if (!pskb_may_pull(skb, hlen_orig))
> >  			goto ignore_tunnel;
> > +		skb_set_transport_header(skb, hlen_orig);
> > +		/* Before now we may used ihl from skb frag, revalidate it after
> > +		 * copying it into skb head to prevent out-of-bounds access
> > +		 */
> > +		if (ip_hdr(skb)->ihl * 4 != hlen_orig)
> > +			goto ignore_tunnel;
> 
> [Severity: Medium]
> 
> Is the "out-of-bounds access" wording in this comment, and in the commit
> message, accurate for the current tree?
> 
> The commit message says:
> 
>     "we must be careful and revalidate the embedded headers after
>     reading them from the skb frags to prevent out-of-bounds
>     access"
> 
> and
> 
>     "local process can change the ihl field and after
>     pskb_may_pull() we can see larger value which is a problem
>     for the icmp_send() call."
> 
> Every ihl-derived access reachable from this icmp_send() call looks
> bounds-checked.  The tracepoint in include/trace/events/icmp.h reads the
> quoted header through skb_header_pointer() and copes with a NULL return:
> 
> 	if (iph->protocol == IPPROTO_UDP)
> 		uh = skb_header_pointer(skb,
> 					skb_network_offset(skb) +
> 					(iph->ihl << 2),
> 					sizeof(_uh), &_uh);
> 
> 	if (!uh) {
> 	...
> 
> __icmp_send() does the same for its inner probe:
> 
> net/ipv4/icmp.c:__icmp_send() {
> 	...
> 		itp = skb_header_pointer(skb_in,
> 					 skb_network_header(skb_in) +
> 					 (iph->ihl << 2) + ...
> 		if (!itp)
> 			goto out;
> 	...
> }
> 
> and __ip_options_echo() works on IPCB(skb)->opt, which is zeroed just
> above the pull:
> 
> 		memset(&(IPCB(skb)->opt), 0, sizeof(IPCB(skb)->opt));
> 
> so it returns immediately on optlen == 0.  With that, does a mutated ihl
> today produce anything worse than wrong or zeroed tracepoint fields?
> 
> Related question on the Fixes tag:
> 
>     Fixes: 7fcc2fe39fed ("net: icmp: avoid invalid transport header access in icmp_send tracepoint")
> 
> That commit replaced the skb_transport_header() dereference in the
> tracepoint with the bounds-checked skb_header_pointer() read shown above,
> so it introduced the ihl-based offset but not an out-of-bounds access.
> Since there is no remaining skb_transport_header() consumer in the
> icmp_send() path, what does the added skb_set_transport_header(skb,
> hlen_orig) feed?  Could the tag and the comment be reworded to describe
> this as hardening plus a transport-header fixup, rather than a fix for an
> out-of-bounds read?
> 
> >  		IP_VS_DBG(12, "Sending ICMP for %pI4->%pI4: t=%u, c=%u, i=%u\n",
> >  			&ip_hdr(skb)->saddr, &ip_hdr(skb)->daddr,
> >  			type, code, ntohl(info));
> 

Regards

--
Julian Anastasov <ja@ssi.bg>

