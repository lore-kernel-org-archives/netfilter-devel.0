From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: nf_conntrack [was Re: [PATCH 1/4] RFC: fast string matching
	infrastrure for netfilter]
Date: Fri, 14 Jan 2005 18:01:42 +1100
Message-ID: <1105686102.7311.101.camel@localhost.localdomain>
References: <41E1AECD.6020209@eurodev.net> <41E1B9F1.7010106@trash.net>
	<Pine.LNX.4.58.0501102041430.28819@blackhole.kfki.hu>
	<41E2E631.3060102@trash.net>
	<20050110212807.GZ18568@sunbeam.de.gnumonks.org>
	<41E73258.7030002@trash.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Pablo Neira <pablo@eurodev.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <41E73258.7030002@trash.net>
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

On Fri, 2005-01-14 at 03:45 +0100, Patrick McHardy wrote:
> Harald Welte wrote:
> 
> >On Mon, Jan 10, 2005 at 09:31:45PM +0100, Patrick McHardy wrote:
> >  
> >
> >>>The infrastructure is there in the patch to support IPv4/IPv6 conntrack
> >>>separatedly in spite of the common code and not to waste so many bytes at
> >>>every IPv4 connections for the sake of supporting IPv6.
> >>>      
> >>>
> >>You mean the get_features stuff and seperate caches ? I'm don't like this
> >>part very much, I thing Rusty's "structure extension stuff" (ct_extend)
> >>is a nicer way to do this, although its probably not useable for the tuples.
> >>    
> >>
> >
> >Unfortunately I have to disagree.  I think I pointed it out in an
> >earlier email, but I'm not sure whether it was on IRC or whether you've
> >been on the list of recipients.
> >
> Hmm, I can't recall talking about this earlier.

It was IRC, and for IPv6 I agree with Harald that it's probably not the
right mechanism.  I prefer a simple discriminated union and two slab
caches (IPv4 and IPv6), which is hardcoded, but still fairly easy to
read.

Note that I don't think ct_extend should go in now: we need more
benchmarking and work (particularly locking).

> >Now you can argue about conntrack/nat helper private data.  Here my
> >argument is weaker, since normally you have something like < 1% of your
> >connections with a helper.  For this I would be willing to accept the
> >additional allocation and whatever.
> >
> >But, then think of a firewall in front of an FTP (IRC/...) Server, and
> >your traffic pattern immediately looks like 50% of your connections (not
> >talking about traffic) have helper private data... and my argument
> >becomes stronger again.

I don't think so.  While you will have to do an additional allocation on
connection creation, the only real per-packet cost is the extra
cacheline (the memchr to find the data in the extend is deliberately
trivial).   They'll gain more by removing the copying into buffer on
those helpers, and the lock that goes with it.

Current size with ct_extend is about 180 bytes (192 in nfsim, which has
larger struct timer_list).  128 is the goal.  Potential areas for
shrinkage using 32-bit machine numbers (I'm not saying these are all
good ideas)

	timeout: move to a 32-bit seconds counter, and use a sweep-method to
clean up connections rather than a timer per conn.  Save 28 bytes.

	counters: use 32-bits for packet counts.  Save 8 bytes.

	ip_conntrack_proto: merge fields and flags.  Save 8 bytes.

	ip_nat_info: use hash tree.  Save 8 bytes.

	tuplehash: use hash tree, put proto in status word.  Save 24 bytes.

That gets us to 104 bytes without doing anything too insane.

> >>I think we should put ip_conntrack in maintenance mode, than we can
> >>resync nf_conntrack and make changes like this before we submit it.
> >>    
> >>
> >
> >At last, we again agree :)

Does that mean I should *not* send the expectation and NAT patches to
DaveM now?  (Posted before the ct_extend patches):

# Fix overlapping expectations in existing expectation code
expectation_overlap_fix-plus-put.patch.gz
# Call NAT Helper Modules Directly from Conntrack Modules, fixup FTP
direct_nat_expect.patch.gz
# Fix Up IRC, AMANDA, TFTP and SNMP Helpers
update-other-helpers.patch.gz
# Simplify expect handling
simplify-expect.patch.gz
# Make Expectations Timeouts Compulsory 
compulsory_timers.patch.gz
# Remove remaining multirange related code
cleanup-manips-left.patch.gz
# Adrian Bunk's Cleanup Patches
adrian-bunk.patch.gz
# Remove manip array from conntrack entry
remove-nat-manips.patch.gz
# Remove ip_conntrack_tuple_hash "ctrack" pointer
remove_ctrack_backpointer.patch.gz
# Use a bit in conntrack status to indicate sequence number adjustment
nat-seq_adjust-bit.patch.gz
# Get rid of initialized in nat structure: use conntrack status bits
nat-initialized-in-status.patch.gz

Thanks,
Rusty.
-- 
A bad analogy is like a leaky screwdriver -- Richard Braakman
