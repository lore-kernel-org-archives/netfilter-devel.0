Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C8543A1A8
	for <netfilter-devel@vger.kernel.org>; Wed, 18 Sep 2024 08:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726648928; cv=none; b=agqUofkD4lwaiObzNCBEOps0kGMvkI60BXXBnKm09M2+EpwuAtW9TIdEQ+aQOHbUEV6YHgGJw0VpOWSFZjJxRs8bnHOLsgn5cmEaL40SzzyYGo1vCUUmAmzlDBbIJ8qZY16/F38jPQ3qWn8sfQjRUqkzkvoqCN0tWNE1z9ckIVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726648928; c=relaxed/simple;
	bh=Muj2oKI1r6Ykvcg2JuVZU5L7+yUi7P/XWqm0u5IIVkI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JXaQaDbobcCHsHbkuz/8lvCMPu3cQSr/FrUOJKZvr8ZM0uwIRIPXIBi5X+PQ0r3TqXhNjfAxgrDrcYNUljsrJzaOU31WeKbtdL7507OjtxvY+0X8P9QyTV7GLDkjoF2fiYvr1BjbBu7SclV3tTRRdey6rjsx9sxzO882AxV55eU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1sqqGA-0002js-Sl; Wed, 18 Sep 2024 10:42:02 +0200
Date: Wed, 18 Sep 2024 10:42:02 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Antonio Ojea <antonio.ojea.garcia@gmail.com>,
	netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nfnetlink_queue: reroute reinjected
 packets from postrouting
Message-ID: <20240918084202.GA10401@breakpoint.cc>
References: <20240912185832.11962-1-pablo@netfilter.org>
 <CABhP=tY2ceRAiZd3UCN3LqU8ZSO1G1W236XW+2rC6QhpeA9dsw@mail.gmail.com>
 <CABhP=taUnE6nxQ1ZPradgk7iNt3M_LCcFoM251OhpEJsasCoSw@mail.gmail.com>
 <ZuqPnLVqbQK6T_th@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZuqPnLVqbQK6T_th@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Ok, I finally managed to get this tested, and it does not seem to
> > solve the problem, it keeps dnating twice after the packet is enqueued
> > by nfqueue
> 
> dnatting twice is required to deal with the conntrack confirmation race.

Antonio could also try this hack:

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -379,7 +379,7 @@ static void nfqnl_reinject(struct nf_queue_entry *entry, unsigned int verdict)
                unsigned int ct_verdict = verdict;
 
                rcu_read_lock();
-               ct_hook = rcu_dereference(nf_ct_hook);
+               ct_hook = NULL;
                if (ct_hook)
                        ct_verdict = ct_hook->update(entry->state.net, entry->skb);
                rcu_read_unlock();

which defers this to the clash resolution logic.
The ct_hook->update infra predates this, I'm not sure we need
it anymore.
