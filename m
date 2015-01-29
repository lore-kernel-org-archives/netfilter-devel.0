From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH next] netfilter: reject: don't send icmp error if packet
 has invalid checksum
Date: Thu, 29 Jan 2015 11:36:15 +0100
Message-ID: <20150129103615.GA16735@breakpoint.cc>
References: <1422525586-9760-1-git-send-email-fw@strlen.de>
 <20150129102157.GB5794@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:39309 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757488AbbA2KgR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Jan 2015 05:36:17 -0500
Content-Disposition: inline
In-Reply-To: <20150129102157.GB5794@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > For icmp error responses there was no such check.
> > It allows to distinguish icmp response generated via
> > 
> > iptables -I INPUT -p udp --dport 42 -j REJECT
> > 
> > and those emitted by network stack (won't respond if csum is invalid,
> > REJECT does).
> > 
> > Arguably its possible to avoid this by using conntrack and only using
> > REJECT with -m conntrack NEW/RELATED.
> > 
> > However, this doesn't work when connection tracking is not in use or
> > when using nf_conntrack_checksum=0.
> > 
> > Furthermore, sending errors in response to invalid csums doesn't make
> > much sense so just add similar test as in nf_send_reset.
> 
> Could you also review net/bridge/netfilter/nft_reject_bridge.c?

Looks like the ipv6 part doesn't check them either, I'll see how to best
address this (ipv4 part looks good).

Thanks.
