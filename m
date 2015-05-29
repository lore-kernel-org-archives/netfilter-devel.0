From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v2 -next 2/2] netfilter: store rules per NUMA node
 instead of per cpu
Date: Fri, 29 May 2015 11:41:46 +0200
Message-ID: <20150529094146.GH23992@breakpoint.cc>
References: <1432846296-26396-1-git-send-email-fw@strlen.de>
 <1432846296-26396-2-git-send-email-fw@strlen.de>
 <1432849093.7456.32.camel@edumazet-glaptop2.roam.corp.google.com>
 <20150528215223.GG23992@breakpoint.cc>
 <1432850655.7456.45.camel@edumazet-glaptop2.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:50922 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752836AbbE2Jls (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 29 May 2015 05:41:48 -0400
Content-Disposition: inline
In-Reply-To: <1432850655.7456.45.camel@edumazet-glaptop2.roam.corp.google.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Dumazet <eric.dumazet@gmail.com> wrote:
> On Thu, 2015-05-28 at 23:52 +0200, Florian Westphal wrote:
> > Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > > Are we copying kernel text to each NUMA node ? ;)
> > 
> > Beats me.  I was under impression that cpu accessing memory on other node
> > takes access penalty, thats why I changed it to per node allocation.
> 
> Well, it depends. If one core is busy while others are idle, then
> fetching data from 2 NUMA nodes is actually faster. (Some workloads are
> actually faster with 'random' NUMA interleaving)
> 
> If you constrain all memory access being done from local node, then you
> might loose total bandwidth. In practice, intensive workloads will
> populate L1/L2/L3 cache, and actual memory location does not really
> matter.

OK; convinced.  I'll kill the per numa part of the change, thanks Eric.
