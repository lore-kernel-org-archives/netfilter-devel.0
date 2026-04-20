Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7840138229E
	for <netfilter-devel@vger.kernel.org>; Mon, 20 Apr 2026 20:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776718713; cv=none; b=Lah9EJ7r1eJEPvt42NSFI+idFkUWTpHBNmOFBkw2L5CKKmX6ykGKsSYsA1X464X/jEcx+gGR7YV83RQpieV+jjn5Bz+CMO4OVxBSgYs6021fVcgLPpjAEGrV853lFw5x1abrQrUfWPUVV7SEJpdxSRfnnFVoRFksfF/QEySrEVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776718713; c=relaxed/simple;
	bh=ffTjBHLema4zelTZXm7uA2ao9Fr8rKvhGyJOEuzOAIY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DIa4kRNMPRxkRaZ5bJ6yMg2SRshacvmoE75Wd33OokBnoQapi6F2q+pbNJUC3sSLu6R2oO6NRd6kH4dylm7dOqWA4HlKzDhz6G7WiI9SNounSSYHlO8AcklUjlPs6Su46hCIMoyQQcMGkqhd9cMOz8xIW/TtGykBSRv/nry2F8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=DsE/l2xC; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="DsE/l2xC"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 9968960178;
	Mon, 20 Apr 2026 22:58:29 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1776718709;
	bh=++5aweUj5nrfUdk3DPaIqlUYm3UR2MB7HRq2Rqe3VjQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DsE/l2xCXmfq1ElNvc6LAAEk83c8ReLJa9Y4fgFbpnDP6kyP2TKfVqWLAvI9a0AdO
	 UuTrt8nG287uK7qOQkPJRpj0Z5hh5vN/0xeLwAqUkqkiQTH8XElMAuFnKB6RjfWC09
	 wFi++B8STo0Qf8IuXEmDkILwYm9qCtNMXvkJ0Ypw8IbGc0WytVsd+sKo5kON1MnJLR
	 4mKHvmDqfCb49YeDCvUDMDpNTEHFRRfgGyCXUZzDI17F5UzBvDiH49blaDKIevkLrT
	 i9KpADHnsHx+Oy+1lkNJr3iZXzyvyHDZyS7ZZbM+U39CZ9hF+1Tzxud3RFgVwJ+54Q
	 cqdHiP8HfL6vw==
Date: Mon, 20 Apr 2026 22:58:26 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	ecklm94@gmail.com, phil@nwl.cc, fw@strlen.de
Subject: Re: [PATCH 2/2 nf v2] netfilter: xtables: fix L4 header parsing for
 non-first fragments
Message-ID: <aeaTcpPAk1HDjUoD@chamomile>
References: <20260420104745.10338-1-fmancera@suse.de>
 <20260420104745.10338-2-fmancera@suse.de>
 <aeaQcrEMN-IYE7xI@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aeaQcrEMN-IYE7xI@chamomile>

On Mon, Apr 20, 2026 at 10:45:41PM +0200, Pablo Neira Ayuso wrote:
> Hi Fernando,
> 
> On Mon, Apr 20, 2026 at 12:47:45PM +0200, Fernando Fernandez Mancera wrote:
> > diff --git a/net/netfilter/xt_socket.c b/net/netfilter/xt_socket.c
> > index 76e01f292aaf..d366e294f1aa 100644
> > --- a/net/netfilter/xt_socket.c
> > +++ b/net/netfilter/xt_socket.c
> > @@ -55,8 +55,11 @@ socket_match(const struct sk_buff *skb, struct xt_action_param *par,
> >  	if (sk && !net_eq(xt_net(par), sock_net(sk)))
> >  		sk = NULL;
> >  
> > -	if (!sk)
> > +	if (!sk) {
> > +		if (par->fragoff)
> > +			return false;
> >  		sk = nf_sk_lookup_slow_v4(xt_net(par), skb, xt_in(par));
> > +	}
> >  
> >  	if (sk) {
> >  		bool wildcard;
> > @@ -116,8 +119,11 @@ socket_mt6_v1_v2_v3(const struct sk_buff *skb, struct xt_action_param *par)
> >  	if (sk && !net_eq(xt_net(par), sock_net(sk)))
> >  		sk = NULL;
> >  
> > -	if (!sk)
> > +	if (!sk) {
> > +		if (par->fragoff)
> > +			return false;
> 
> Your patch will work as intented in iptables over nf_tables, because
> it always sets on fragoff regardless user policy.
> 
> But, if ipv6_find_hdr() finds no layer 4 protocol, then fragoff
> remains zero, and pkt->flags does not set on NFT_PKTINFO_L4PROTO.
> There, in nftables, par->fragoff but itself is not reliable because
> maybe the layer 4 was not found.

This is where pkt->tprot comes into play. I think this series is fine
with nf_tables, it is just ip6_tables legacy that lags behind.

> Then, there is ip6_tables legacy which does not behave like ip_tables
> for fragments.
> 
> ip6t_do_table() only sets fragoff if IP6T_F_PROTO (-p in userspace) is
> used, unlike nftables which always sets on fragoff.
> 
> So par->fragoff is unreliable in ip6_tables legacy, and
> ipv6_find_hdr() is called over and over again ip6_packet_match() loop
> for each rule.
> 
> One way would be to call ipv6_find_hdr() inconditionally from
> ip6_tables legacy, but that belongs to a different patch and that
> would be touch core ip6_tables legacy.
> 
> Rewinding a bit, coming to back to the original issue: osf only
> supports ipv4 :-)
> 
> >  		sk = nf_sk_lookup_slow_v6(xt_net(par), skb, xt_in(par));
> > +	}
> >  
> >  	if (sk) {
> >  		bool wildcard;
> > diff --git a/net/netfilter/xt_tcpmss.c b/net/netfilter/xt_tcpmss.c
> > index 0d32d4841cb3..69844cc8dbb8 100644
> > --- a/net/netfilter/xt_tcpmss.c
> > +++ b/net/netfilter/xt_tcpmss.c
> > @@ -32,6 +32,9 @@ tcpmss_mt(const struct sk_buff *skb, struct xt_action_param *par)
> >  	u8 _opt[15 * 4 - sizeof(_tcph)];
> >  	unsigned int i, optlen;
> >  
> > +	if (par->fragoff)
> > +		return false;
> > +
> >  	/* If we don't have the whole header, drop packet. */
> >  	th = skb_header_pointer(skb, par->thoff, sizeof(_tcph), &_tcph);
> >  	if (th == NULL)
> > -- 
> > 2.53.0
> > 
