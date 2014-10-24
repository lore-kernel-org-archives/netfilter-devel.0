From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/3] netfilter: nfnetlink_log: fix maximum packet length
 logged to userspace
Date: Fri, 24 Oct 2014 14:33:53 +0200
Message-ID: <20141024123352.GB4587@salvia>
References: <1414053368-29037-1-git-send-email-fw@strlen.de>
 <1414053368-29037-3-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41699 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756090AbaJXMca (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 24 Oct 2014 08:32:30 -0400
Content-Disposition: inline
In-Reply-To: <1414053368-29037-3-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Oct 23, 2014 at 10:36:07AM +0200, Florian Westphal wrote:
> don't try to queue payloads > 0xffff - NLA_HDRLEN, it does not work.
> The nla length includes the size of the nla struct, so anything larger
> results in u16 integer overflow.
> 
> This patch is similar to
> 9cefbbc9c8f9abe (netfilter: nfnetlink_queue: cleanup copy_range usage).

Indeed, if we find problem in nfqueue, we should also keep in mind
that we should revisit nflog too. Those two codebases are very similar
(I suspect one forked from another at some point, with ad-hoc
modifications to each case).

Applied, thanks a lot for taking the time to look into this.
