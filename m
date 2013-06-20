From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH next] netfilter: conntrack: avoid large timeout for
 mid-stream pickup
Date: Thu, 20 Jun 2013 11:45:42 +0200
Message-ID: <20130620094542.GA11331@localhost>
References: <1371137488-16428-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59597 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756241Ab3FTJpu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Jun 2013 05:45:50 -0400
Content-Disposition: inline
In-Reply-To: <1371137488-16428-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jun 13, 2013 at 05:31:28PM +0200, Florian Westphal wrote:
> When loose tracking is enabled (default), non-syn packets cause
> creation of new conntracks in established state with default timeout for
> established state (5 days).  This causes the table to fill up with UNREPLIED
> when the 'new ack' packet happened to be the last-ack of a previous,
> already timed-out connection.
> 
> Consider:
> 
> A 192.168.x.52792 > 10.184.y.80: F, 426:426(0) ack 9237 win 255
> B 10.184.y.80 > 192.168.x.52792: ., ack 427 win 123
> <61 second pause>
> C 10.184.y.80 > 192.168.x.52792: F, 9237:9237(0) ack 427 win 123
> D 192.168.x.52792 > 10.184.y.80: ., ack 9238 win 255
> 
> B moves conntrack to CLOSE_WAIT and will kill it after 60 second timeout,
> C is ignored (FIN set), but last packet (D) causes new ct with 5-days timeout.
> 
> Use UNACK timeout (5 minutes) instead to get rid of these entries sooner
> when in ESTABLISHED state without having seen traffic in both directions.

Applied, thanks!
