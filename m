From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH 2/2] netfilter: conntrack: remove timer from ecache
 extension
Date: Thu, 5 Jun 2014 23:05:44 +0200
Message-ID: <20140605210544.GD23367@breakpoint.cc>
References: <1400751788-7923-1-git-send-email-fw@strlen.de>
 <1400751788-7923-3-git-send-email-fw@strlen.de>
 <20140605142549.GA24216@localhost>
 <20140605143311.GA24460@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:41346 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751440AbaFEVFq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Jun 2014 17:05:46 -0400
Content-Disposition: inline
In-Reply-To: <20140605143311.GA24460@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > In one test, I noticed around ~75 entries stuck in the dying list. In
> > another test, I noticed conntrackd -i | wc -l showed one entry that
> > got stuck in the cache, which was not in the dying list. I suspect
> > some problem in the retransmission logic.
> 
> Another interesting information. If I generate new entries that get
> stuck in the dying list because of undelivered events, the worker
> seems to give another chance to deliver, and the entries that were
> stuck are not there anymore.

Hmm, don't yet understand how we could end up with
pending events on the list without work queue being scheduled
for execution.

The eache worker will _always_ schedule itself _except_ when
it thinks that it has delivered all entries.

Its possible that a new entry was put on the dying list
immediately after we've done the hlist nulls test, however in that
case the delivery failure should also have scheduled the work
queue via nf_conntrack_ecache_delayed_work().

AFAICS delayed_work_pending() cannot return true for a work struct
that is still running since WORK_STRUCT_PENDING_BIT is cleared
before callback invocation.

Will look again tomorrow.
