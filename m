From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: nf_conntrack [was Re: [PATCH 1/4] RFC: fast string matching
	infrastrure for netfilter]
Date: Fri, 14 Jan 2005 21:22:45 +1100
Message-ID: <1105698165.22689.7.camel@localhost.localdomain>
References: <41E1AECD.6020209@eurodev.net> <41E1B9F1.7010106@trash.net>
	<Pine.LNX.4.58.0501102041430.28819@blackhole.kfki.hu>
	<41E2E631.3060102@trash.net>
	<20050110212807.GZ18568@sunbeam.de.gnumonks.org>
	<41E73258.7030002@trash.net>
	<1105686102.7311.101.camel@localhost.localdomain>
	<20050114083731.GI9070@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Pablo Neira <pablo@eurodev.net>, Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20050114083731.GI9070@sunbeam.de.gnumonks.org>
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

On Fri, 2005-01-14 at 09:37 +0100, Harald Welte wrote:
> On Fri, Jan 14, 2005 at 06:01:42PM +1100, Rusty Russell wrote:
> 
> > It was IRC, and for IPv6 I agree with Harald that it's probably not the
> > right mechanism.  I prefer a simple discriminated union and two slab
> > caches (IPv4 and IPv6), which is hardcoded, but still fairly easy to
> > read.
> 
> so what about the nat_info ?  If you load iptable_nat, it will be needed
> for all connections...

My current patches reduce the nat_info to one list_head.  If we were to
use a hash tree as per Gandalf's recent work, it'd be 0.  IMHO it's not
worth the pain even if it's still a list_head.

> > Does that mean I should *not* send the expectation and NAT patches to
> > DaveM now?  (Posted before the ct_extend patches):
> 
> I was wondering all the time why we keep talking about maintainance mode
> for ip_conntrack and the coincidential spike in new development for
> ip_conntrack.

That's why I asked.  Unfortunately, I only just found time to do some
netfilter work 8(

I definitely think ct_extend should wait for nf_conntrack (but I wanted
the patches out there, since I think they're complimentary).  For the
others, I think it's better to merge them now so nf_conntrack only has
to sync once (presumably it will have to sync with some of the existing
changes already), and plan nf_conntrack for 2.6.11.

Rusty.
-- 
A bad analogy is like a leaky screwdriver -- Richard Braakman
