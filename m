From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: xt_connbytes: handle negation correctly
Date: Fri, 23 Dec 2011 14:51:09 +0100
Message-ID: <20111223135109.GA10482@1984>
References: <1324056915-637-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39829 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757175Ab1LWNvM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 23 Dec 2011 08:51:12 -0500
Content-Disposition: inline
In-Reply-To: <1324056915-637-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Dec 16, 2011 at 06:35:15PM +0100, Florian Westphal wrote:
> "! --connbytes 23:42" should match if the packet/byte count is not in range.
> 
> As there is no explict "invert match" toggle in the match structure,
> userspace swaps the from and to arguments
> (i.e., as if "--connbytes 42:23" were given).
> 
> However, "what <= 23 && what >= 42" will always be false.
> 
> Change things so we use "||" in case "from" is larger than "to".
> 
> This change may look like it breaks backwards compatibility when "to" is 0.
> However, older iptables binaries will refuse "connbytes 42:0",
> and current releases treat it to mean "! --connbytes 0:42",
> so we should be fine.

Applied, thanks Florian. I'll pass this for 3.2-rc inclusion.
