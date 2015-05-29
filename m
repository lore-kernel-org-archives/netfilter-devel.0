From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v2 -next 1/2] netfilter: iptables: separate counters from
 iptables rules
Date: Fri, 29 May 2015 12:05:16 +0200
Message-ID: <20150529100516.GI23992@breakpoint.cc>
References: <1432846296-26396-1-git-send-email-fw@strlen.de>
 <1432848817.7456.30.camel@edumazet-glaptop2.roam.corp.google.com>
 <20150528214540.GF23992@breakpoint.cc>
 <1432850096.7456.38.camel@edumazet-glaptop2.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:51011 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753773AbbE2KFS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 29 May 2015 06:05:18 -0400
Content-Disposition: inline
In-Reply-To: <1432850096.7456.38.camel@edumazet-glaptop2.roam.corp.google.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > How?  What address?  You mean relative offset to counter start?
> 
> No, the address itself. This is what I coded years ago.
> > when rule x matches, I need to increment the corresponding counter
> > for that rule.
> 
> Right. You have in the rule itself the storage for xt_counter. Thats 16
> bytes. You only need 8 bytes (on 64bit arch) to store the percpu
> address.

> Instead of leaving nothing in it, place the percpu address of the
> corresponding counter. access to it is in the cache line needed to
> analyze the entry anyway. Its free.

I'm dense.  So, what you're saying is that I should

alloc_percpu(sizeof(struct xt_counters));

for each rule and store the resulting address in ipt_entry?
Then it would be possible to get the correct location for current cpu
when counter has to be incremented.

Thanks Eric.
