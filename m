From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: evict stale entries when user reads
 /proc/net/nf_conntrack
Date: Sun, 25 Sep 2016 13:47:01 +0200
Message-ID: <20160925114701.GA8623@salvia>
References: <1474580957-26032-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41382 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936523AbcIYLrG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 25 Sep 2016 07:47:06 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id CD18BED087
        for <netfilter-devel@vger.kernel.org>; Sun, 25 Sep 2016 13:47:04 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BACF0DA7E9
        for <netfilter-devel@vger.kernel.org>; Sun, 25 Sep 2016 13:47:04 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 942C9DA815
        for <netfilter-devel@vger.kernel.org>; Sun, 25 Sep 2016 13:47:02 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1474580957-26032-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Sep 22, 2016 at 11:49:17PM +0200, Florian Westphal wrote:
> Fabian reports a possible conntrack memory leak (could not reproduce so
> far), however, one minor issue can be easily resolved:
> 
> > cat /proc/net/nf_conntrack | wc -l = 5
> > 4 minutes required to clean up the table.
> 
> We should not report those timed-out entries to the user in first place.
> And instead of just skipping those timed-out entries while iterating over
> the table we can also zap them (we already do this during ctnetlink
> walks, but I forgot about the /proc interface).
> 
> Fixes: f330a7fdbe16 ("netfilter: conntrack: get rid of conntrack timer")
> Reported-by: Fabian Frederick <fabf@skynet.be>
> Signed-off-by: Florian Westphal <fw@strlen.de>

Applied, thanks.
