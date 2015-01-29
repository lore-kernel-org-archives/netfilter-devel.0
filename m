From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH next] netfilter: reject: don't send icmp error if packet
 has invalid checksum
Date: Thu, 29 Jan 2015 11:21:57 +0100
Message-ID: <20150129102157.GB5794@salvia>
References: <1422525586-9760-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40622 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758840AbbA2KSw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Jan 2015 05:18:52 -0500
Content-Disposition: inline
In-Reply-To: <1422525586-9760-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jan 29, 2015 at 10:59:46AM +0100, Florian Westphal wrote:
> tcp resets are never emitted if the packet that triggers the
> reject/reset has an invalid checksum.
> 
> For icmp error responses there was no such check.
> It allows to distinguish icmp response generated via
> 
> iptables -I INPUT -p udp --dport 42 -j REJECT
> 
> and those emitted by network stack (won't respond if csum is invalid,
> REJECT does).
> 
> Arguably its possible to avoid this by using conntrack and only using
> REJECT with -m conntrack NEW/RELATED.
> 
> However, this doesn't work when connection tracking is not in use or
> when using nf_conntrack_checksum=0.
> 
> Furthermore, sending errors in response to invalid csums doesn't make
> much sense so just add similar test as in nf_send_reset.

Could you also review net/bridge/netfilter/nft_reject_bridge.c?

Thanks.
