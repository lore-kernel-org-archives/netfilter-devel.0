From: Patrick Schaaf <bof@bof.de>
Subject: Re: Table duplication on smp machine
Date: Mon, 31 Mar 2003 14:56:10 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030331125610.GC1098@oknodo.bof.de>
References: <3E881DD6.8090206@hipac.org> <20030331110709.GE7718@sunbeam.de.gnumonks.org> <3E882F52.1040705@hipac.org> <20030331123326.GO7718@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>, Thomas Heinz <creatix@hipac.org>,
  netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20030331123326.GO7718@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> > I see. If this is the main reason it would suffice to have _one_ ruleset
> > for all cpu's but a block of counters for each rule like this:
> 
> then you start having cacheline ping-pong problems when match/target
> private data is written to (like in the limit match, ...)

There are other, generic APIs for allocation of per-cpu data. In a new
world, the rare match/target module with such a requirement, could use
that API.

But there is another, less common, incentive to have per-cpu copies
of all the data structures: non-uniform-memory-architecture machines.
An example (hopefully) not far from widespread adoption, would be the
new AMD Hammer SMP architecture. On such an architecture, there is
a performance benefit even from CPU (or node) local copies of even
readonly data, because of the reduced local memory latency. In the
Hammer example, there would be one copy of the ruleset in each
single Hammer's locally attached DRAM.

Not so common today, but I always thought that the existing separation
in the current iptables code was good preparation for that future.

best regards
  Patrick
