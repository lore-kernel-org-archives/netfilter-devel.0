From: Patrick Schaaf <bof@bof.de>
Subject: Re: Table duplication on smp machine
Date: Mon, 31 Mar 2003 15:45:04 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030331134504.GD1098@oknodo.bof.de>
References: <3E881DD6.8090206@hipac.org> <20030331110709.GE7718@sunbeam.de.gnumonks.org> <3E882F52.1040705@hipac.org> <20030331123326.GO7718@sunbeam.de.gnumonks.org> <20030331125610.GC1098@oknodo.bof.de> <3E8843DD.8060501@hipac.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick Schaaf <bof@bof.de>, Harald Welte <laforge@netfilter.org>,
  netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Thomas Heinz <creatix@hipac.org>
Content-Disposition: inline
In-Reply-To: <3E8843DD.8060501@hipac.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> >of all the data structures: non-uniform-memory-architecture machines.
> >An example (hopefully) not far from widespread adoption, would be the
> >new AMD Hammer SMP architecture. On such an architecture, there is
> >a performance benefit even from CPU (or node) local copies of even
> >readonly data, because of the reduced local memory latency. In the
> >Hammer example, there would be one copy of the ruleset in each
> >single Hammer's locally attached DRAM.
> >
> >Not so common today, but I always thought that the existing separation
> >in the current iptables code was good preparation for that future.
> 
> Very interesting. I guess one has to use a special API to address the
> per cpu memory so that the current implementation wouldn't work out
> of the box. Right?

I assume that the existing per-cpu API in Linux 2.5.xxx will suffice
to do the right thing on NUMA boxen. It's just a question of carefully
selecting what physical pages each per-cpu slab is put into. The problem
can and should be solved in generic allocators.

I have not followed the relevant development very closely, but there
were lively discussions on linux-kernel during the last year.

Regarding the limit target, not current implementation, but seen
a bit more abstractly, it is possible to arrange things so each
CPU has its own copy of a partial token bucket, and refills it
from locked shared pingponging storage only when it empties.
I have no idea whether it makes sense to add the required
code complexity, but it is a distinct optimization possible
for high-volume applications.

I feel that there's a lot more to worry about before that becomes
a problem in real life, though.

best regards
  Patrick
