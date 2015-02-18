From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: xt_recent: don't reject rule if new hitcount
 exceeds table max
Date: Thu, 19 Feb 2015 00:45:08 +0100
Message-ID: <20150218234508.GA21756@salvia>
References: <1423828070-10667-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, chris@cvine.freeserve.co.uk
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33386 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751144AbbBRXlu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Feb 2015 18:41:50 -0500
Content-Disposition: inline
In-Reply-To: <1423828070-10667-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Feb 13, 2015 at 12:47:50PM +0100, Florian Westphal wrote:
> given:
> -A INPUT -m recent --update --seconds 30 --hitcount 4
> and
> iptables-save > foo
> 
> then
> iptables-restore < foo
> 
> will fail with:
> kernel: xt_recent: hitcount (4) is larger than packets to be remembered (4) for table DEFAULT
> 
> Even when the check is fixed, the restore won't work if the hitcount is
> increased to e.g. 6, since by the time checkentry runs it will find the
> 'old' incarnation of the table.
> 
> We can avoid this by increasing the maximum threshold silently; we only
> have to rm all the current entries of the table (these entries would
> not have enough room to handle the increased hitcount).
> 
> This even makes (not-very-useful)
> -A INPUT -m recent --update --seconds 30 --hitcount 4
> -A INPUT -m recent --update --seconds 30 --hitcount 42
> work.

Applied, thanks Florian.
