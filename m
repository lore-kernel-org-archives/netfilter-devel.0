From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 3/5] netfilter: move skb_gso_segment into nfnetlink_queue
 module
Date: Sat, 27 Apr 2013 19:46:18 +0200
Message-ID: <20130427174618.GB4891@localhost>
References: <1366383507-16633-1-git-send-email-fw@strlen.de>
 <1366383507-16633-4-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38766 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751698Ab3D0RqX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 27 Apr 2013 13:46:23 -0400
Content-Disposition: inline
In-Reply-To: <1366383507-16633-4-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Apr 19, 2013 at 04:58:25PM +0200, Florian Westphal wrote:
> There is nothing wrong with the current code.
> 
> However, skb_gso_segment is expensive, so it would be nice
> if we could avoid it in the future.
> 
> Since userspace must be prepared to receive larger-than-mtu-packets
> (which will also have incorrect l3/l4 checksums), we cannot simply
> remove it.
> 
> The plan is to add a per-queue feature flag that userspace can
> set when binding the queue.
> 
> The problem is that in nf_queue, we only have a queue number,
> not the queue context/configuration settings.
> 
> This patch should have no impact other than the skb_gso_segment
> call now being in a function that has access to the queue config data.
> 
> The size new size attribute in nf_queue_entry is needed so
> nfnetlink_queue can duplicate the entry of the gso skb
> when segmenting the skb while also copying the route key.
> 
> Next step: avoid skb_gso_segment when queue config says so.

Applied, thanks.
