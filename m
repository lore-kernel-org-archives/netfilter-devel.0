From: Joakim Axelsson <gozem@gozem.se>
Subject: Re: new ABI
Date: Wed, 16 Aug 2006 16:40:19 +0200
Message-ID: <20060816144019.GC31235@kriss.csbnet.se>
References: <200608142312.41851.max@nucleus.it>
	<20060816121653.GA31235@kriss.csbnet.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Massimiliano Hofer <max@nucleus.it>,
	netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20060816121653.GA31235@kriss.csbnet.se>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

And some more. About logging, debug and hit counters.

I think we can remove the hits counters. Allow a seperate module to count if
needed. I'm sure most firewalls do not need the counters on every rule. It's
just an expensive waste of locking in the kernel.

Also, people will want to log here and there. Both for the pure logging
purpose but also for the debugging purpose, "does my firewall work?". I
think it would be easier to allow each rule to have three flags for
debugging purpose. Log on entering the rule, Log on matching the rule and
Log on leaving the rule (after targets). This makes it very easy to trace
your firewall config. This config should of couse be able to change without
having to remove and readd the rule without debugging later.

For general logging (and debugging) we should remove -j LOG. The parseing of
the packet layout is something for userspace. Debugging only has a
"reserved" netlink channel. There is one set back doing this. If the machine
gets DoS-Attacked. All the logging will be more or less disabled as the
kernel uses all of the available CPU and you get nothing to try to figure
out the attack-vector (for counter firewall rules).

--
Joakim Axelsson
