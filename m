From: don-nf@isis.cs3-inc.com (Don Cohen)
Subject: Re: defense against conntrack attacks
Date: Sun, 16 Jun 2002 15:57:19 -0700
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <15629.6095.353639.29180@isis.cs3-inc.com>
References: <20020615132638.84C444509@lists.samba.org>
	<15627.49630.258601.138681@isis.cs3-inc.com>
	<20020616221633.J2543@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Harald Welte <laforge@gnumonks.org>
In-Reply-To: <20020616221633.J2543@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Harald Welte writes:
 > On Sat, Jun 15, 2002 at 03:38:22PM -0700, Don Cohen wrote:
 > 
 > > Here's a summary of some experiments that show this is true ...
 > 
 > thanks, this is the kind of testing/benchmarkin which is appreciated.
 > 
 > > These were done with 200MHz machines, one generating packets and
 > > the other forwarding.  They're connected by a 100Mbit link.
I should also have mentioned, 2.4.3 kernel.
The code might have changed a fair amount since then.

 ...
 > > This shows that conntrack is a bottleneck, at least dealing with new
 > > packets.
 > 
 > there are a couple of issues related to this:
 > 
 > 1 the number of hash buckets in your conntrack hash table (this is a module
 >   loadtime parameter and the default depends on your systems total RAM size)
 > 2 the conntrack hash function.  If all (or more/most) connections would end
 >   up in the same couple of buckets, performance would suffer significantly.
 > 3 did you see any messages in your kernel log ?  any OOM messages?
 >   I could imagine that the kernel has difficulties allocating the needed
 >   memory for conntrack entries

The only log messages I see that appear to be related are:
Jun 14 14:52:25 router1 kernel: ip_tables: (c)2000 Netfilter core team
and
Jun 14 15:01:10 router1 kernel: ip_conntrack (1024 buckets, 8192 max)
(I see several of those since I rmmod'ed and reloaded conntrack
several times).
I assumed without looking that the hash function would be mostly
different when only the destination port changed, which is what I was
doing.  Attacking the hash function is yet another approach that I was
planning to worry about, but I haven't gotten there yet.
(Anyone have ideas about defense against such an attack?  I have a few
that seem pretty obvious.) 

 > > I conclude that if the code for creating new connections could be made
 > > faster (it would have to be MUCH faster) there would be some benefit
 > > in doing so.  I've not looked at that.  I presume whoever wrote it was
 > > at least trying to make it efficient.  If anyone thinks this is a
 > > promising approach, please feel free to say so.
 > 
 > the question would be:  what exactly is so slow? why is it slow?

Of course, anyone who knows how to improve the code should please
speak up.  I still hope to read and understand it, but if/when I get
there I expect I'll then understand why it has to take as long as it
does as opposed to seeing how to fix it.

 > > What I'm really interested in is a defense that, e.g., rate limits
 > > syns.  The problem I see in the current implementation (again, correct
 > > me if I'm wrong) is that the very first thing that happens when a
 > > packet arrives is that conntrack processes it, and this includes the
 > > code for creating a conntrack record in the case where there is none.
 > 
 > yes, I think Jozsef is working on a 'conntrack exemption table' where you
 > could tell it that certain [maybe above a certain limit] packets are 
 > not conntracked.

Isn't that disastrous?  For instance, NAT can't work in that case,
right?  And any rules that refer to conntrack state.  Unless you just
drop the packets, of course.  And yes, that's what I want to do, but
of course I have some ideas about how to decide WHICH packets to drop.

 > Second, you need conntrack information before postrouting:
 > 
 > - for doing DNAT [which _needs_ to happen before the routing decision]
 > - for any stateful rules in the FORWARD chain of the filter table
 > - for any stateful rules in the INPUT chain of the filter table

The question is how much data is needed for those things.  A lot
depends on where the actual expense is, which I don't yet know.

I'll mention my other plan, which I was beginning to like better anyway.
It's a version of IMQ that runs before conntrack and rate limits the
"expensive" packets.  This could even read conntrack state in order to
decide which packets were expensive.
