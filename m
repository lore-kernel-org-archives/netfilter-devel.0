From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v3 nf-next] netfilter: nft_set_rbtree: use seqcount to
 avoid lock in most cases
Date: Mon, 31 Jul 2017 19:50:51 +0200
Message-ID: <20170731175051.GA6442@salvia>
References: <20170728083442.9159-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33034 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752339AbdGaRu5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 31 Jul 2017 13:50:57 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9C76C3025A6
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Jul 2017 19:50:41 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8B861D2E49
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Jul 2017 19:50:41 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 75947DA57F
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Jul 2017 19:50:39 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170728083442.9159-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jul 28, 2017 at 10:34:42AM +0200, Florian Westphal wrote:
> switch to lockless lockup. write side now also increments sequence
> counter.  On lookup, sample counter value and only take the lock
> if we did not find a match and the counter has changed.
> 
> This avoids need to write to private area in normal (lookup) cases.
> 
> In case we detect a writer (seqretry is true) we fall back to taking
> the readlock.
> 
> The readlock is also used during dumps to ensure we get a consistent
> tree walk.
> 
> Similar technique (rbtree+seqlock) was used by David Howells in rxrpc.

Applied, thanks.

I think this is still going to be slower than any native rcu-friendly
tree implementation, so I still see value for the bonsai tree idea.
