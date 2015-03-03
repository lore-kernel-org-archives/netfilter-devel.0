From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH -next v3] netfilter: reject: don't send icmp error if
 csum is invalid
Date: Tue, 3 Mar 2015 02:12:27 +0100
Message-ID: <20150303011227.GA4286@salvia>
References: <1424109244-23649-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60303 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754527AbbCCBIu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Mar 2015 20:08:50 -0500
Content-Disposition: inline
In-Reply-To: <1424109244-23649-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Feb 16, 2015 at 06:54:04PM +0100, Florian Westphal wrote:
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
> Arguably its possible to avoid this by using conntrack and only
> using REJECT with -m conntrack NEW/RELATED.
> 
> However, this doesn't work when connection tracking is not in use
> or when using nf_conntrack_checksum=0.
> 
> Furthermore, sending errors in response to invalid csums doesn't make
> much sense so just add similar test as in nf_send_reset.
> 
> Validate csum if needed and only send the response if it is ok.

Applied, thanks Florian.
