From: don-nf@isis.cs3-inc.com (Don Cohen)
Subject: Re: iptables u32 match code for review/testing/...
Date: Wed, 8 Jan 2003 11:53:49 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <15900.33229.827518.797424@isis.cs3-inc.com>
References: <200212271854.gBRIsf131987@isis.cs3-inc.com>
	<20030106125720.GF9467@sunbeam.de.gnumonks.org>
	<15897.46884.822054.847738@isis.cs3-inc.com>
	<20030107185748.GV9467@sunbeam.de.gnumonks.org>
	<15899.51201.381520.438520@isis.cs3-inc.com>
	<20030108105646.GH9467@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>
In-Reply-To: <20030108105646.GH9467@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Harald Welte writes:
 > Hm. A recursive grep through the kernel doesn't find any occurrance of 
 > 'ipt_matchinfo' at all.
/usr/src/linux-2.4.18/include/linux/netfilter_ipv4/ipt_multiport.h

 > > Ok, then I'll leave it at 10x10x10 (perhaps a lot of overhead for
 > > a single match?)
 > It also means that every single rule containing the u32 match will
 > occupy smp_num_cpus*1000*sizeof(your structure) bytes of non-swappable
 > kernel memory.
Well, not quite that bad.  It's actually o(10x(10+10)).  The structure
sizes seem to be 5+8 so actually using 1300 bytes.  I don't know
whether there's more space wasted on alignment.
Would it work to make that 10 into a module parm (or three) ?

 > >  > I like the content (code/implementation/idea of having u32).
 > >  > The only issue is that it doesn't really fit into the current iptables
 > >  > architecture. Why?
 > >  > 	- because it is a whole classification engine on it's own
 > > Why is this bad?  I wrote it to do things I wanted to do but didn't
 > > see how.  I think that's good.  If it subsumes a few others that are
 > > out there, even better.  (But it's almost certainly a lot slower than 
 > > any more specialized match, so they're still useful.)
 > 
 > Sorry, I didn't make myself clear.  if u32 is used the right way, it is
 > way better than lots of the static matches within iptables.  However, it
I don't know what "the right way" means.  A more specific match will
be faster to execute and easier to specify.  The advantage of u32 is
generality.
 > is more like a replacement of the whole iptables packet matching engine,
 > than a plugin/extension to it.  Making it a plugin/extension will
 > unfortunately become a sort-of clumsy approach.   I don't blame or
 > critisize you... this is not an issue of implementation, but a
 > fundamental architectural problem.

Perhaps you should view it as temporary until something better
arrives.  You might consider changing the architecture later.
My impression is that jamal <hadi@cyberus.ca> is well on the way to
using tc to replace iptables.  And I begin to see that his approach
(or at least what I imagine to be his approach) might actually be
a lot more efficient.  

I notice, btw, that u32 does not do what you'd want for ipv6.
In that case you want to look for a particular header, or of course,
for the end of the headers.  Oh, well.  Another project.

 > yes.  If you now would be as friendly to post it as a unified diff
 > against current patch-o-matic CVS, attached in MIME format?  (And for
 > posting habits and/or coding style hints there are plenty of examples in
 > the list archives respectively CVS).
As you can tell, I'm new at this.  But will give it a try...
