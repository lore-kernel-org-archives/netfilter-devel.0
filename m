From: Florian Westphal <fw@strlen.de>
Subject: Re: nfqueue max copy_range broken, how to fix/mitigate?
Date: Fri, 17 Aug 2012 12:53:00 +0200
Message-ID: <20120817105300.GB12344@breakpoint.cc>
References: <20120817091207.GA12344@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:33614 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161012Ab2HQKxD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 17 Aug 2012 06:53:03 -0400
Content-Disposition: inline
In-Reply-To: <20120817091207.GA12344@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Florian Westphal <fw@strlen.de> wrote:
> Since this is a limitation of netlink this isn't fixable in nfqueue.
> How to best handle this situation?
> 
> We can either truncate and queue 0xffff - NLA_HDRLEN (i.e., cut off 4
> bytes from what will be queued), or we could refuse to queue the packet
> (userspace asked for the full packet, but we can't fullfill the
>  request).

Another method would be to "fix" this in userspace by checking
for attr->nla_len < NLA_HDRLEN in combination with
mnl_nlmsg_get_payload_tail(nlh) - (char *) attr >= 0xffff and then
assuming that the next attribute is at 0xffff - attr->nla_len instead
of attr->nla_len.

But that would mean cramming very ugly code into libmnl et al.
