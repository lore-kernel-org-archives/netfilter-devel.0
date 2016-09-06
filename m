From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH 8/7] net/netfilter/nf_conntrack_core: Remove another
 memory barrier
Date: Tue, 6 Sep 2016 18:56:48 +0100
Message-ID: <20160906175648.GC29382@arm.com>
References: <1472743673-15585-1-git-send-email-manfred@colorfullife.com>
 <20160901153039.GN6721@arm.com>
 <20160901164126.GZ10153@twins.programming.kicks-ass.net>
 <1971bcf8-0f42-c0b7-5e59-2ceaa6e024a7@colorfullife.com>
 <20160902192213.GM10153@twins.programming.kicks-ass.net>
 <5d88110f-cf0e-c72e-7acc-518b736e715e@colorfullife.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Peter Zijlstra <peterz@infradead.org>, benh@kernel.crashing.org,
        paulmck@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>,
        Boqun Feng <boqun.feng@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, 1vier1@web.de,
        Davidlohr Bueso <dave@stgolabs.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
To: Manfred Spraul <manfred@colorfullife.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:60896 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755322AbcIFR4p (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Sep 2016 13:56:45 -0400
Content-Disposition: inline
In-Reply-To: <5d88110f-cf0e-c72e-7acc-518b736e715e@colorfullife.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Sep 05, 2016 at 08:57:19PM +0200, Manfred Spraul wrote:
> On 09/02/2016 09:22 PM, Peter Zijlstra wrote:
> Anyone around with a ppc or arm? How slow is the loop of the
> spin_unlock_wait() calls?
> Single CPU is sufficient.
> 
> Question 1: How large is the difference between:
> #./sem-scalebench -t 10 -c 1 -p 1 -o 4 -f -d 1
> #./sem-scalebench -t 10 -c 1 -p 1 -o 4 -f -d 256
> https://github.com/manfred-colorfu/ipcscale

Not sure exactly what you want me to run here, but with an arm64
defconfig -rc3 kernel, those two invocations give me "Max total" values
where the first is 20x bigger than the second.

Will
