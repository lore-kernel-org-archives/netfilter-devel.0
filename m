From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [netfilter-core] bad performance: bug or missing optimisation?
Date: Wed, 27 Aug 2003 15:49:01 +1000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030827074745.A9C242C15B@lists.samba.org>
References: <20030826113317.GA2163@mt.lv>
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Karlis Peisenieks <karlis@mt.lv>
In-reply-to: Your message of "Tue, 26 Aug 2003 14:33:17 +0300."
             <20030826113317.GA2163@mt.lv>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

In message <20030826113317.GA2163@mt.lv> you write:
> Hello!
> 
> While fighting with ICMP flood we came across strange NAT problem.
> 
> When box is forwarding ICMP flood from one source address to random 
> destination addresses, it becomes unresponsive and CPU usage goes up.
> 
> No NAT was taking place, just conntrack and nat modules loaded.
> 
> Some debugging and profiling showed problem is that entry in
> ip_nat_core.c:bysource for flooding source address hash is growing very
> large and find_appropriate_src is walking all this list and always 
> failing.

Ah, there are a couple of problems here.

The code is trying to ensure that we are compliant with Dan Kegel's
proposed NAT RFC changes:

	http://www.alumni.caltech.edu/~dank/peer-nat.html

But there are several problems.  The first is that your application is
probably not varying the ICMP echo ID, so it's hitting a single hash
bucket for everything.  The second is that the in_range code seems to
have a logic bug:

	if ((mr->range[i].flags & IP_NAT_RANGE_PROTO_SPECIFIED)
	    && proto->in_range(&newtuple, IP_NAT_MANIP_SRC,
			       &mr->range[i].min, &mr->range[i].max))
		return 1;

This should be:

	if (!(mr->range[i].flags & IP_NAT_RANGE_PROTO_SPECIFIED)
	    || proto->in_range(&newtuple, IP_NAT_MANIP_SRC,
			       &mr->range[i].min, &mr->range[i].max))
		return 1;

Which means it will match the first entry...

Does that help?
Rusty.
--
  Anyone who quotes me in their sig is an idiot. -- Rusty Russell.
