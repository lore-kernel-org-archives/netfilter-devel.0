From: Peter Stamfest <peter@stamfest.at>
Subject: [PATCH] Efficient matching of many IP blocks
Date: Sat, 5 Jun 2004 11:35:47 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0406051017530.16559-100000@peter.stamf.pr.at>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Hello List, 

I haven't had the time to follow this list closely in the last couple of 
weeks, but finally I get around to feed this back to the list.... I think 
that something like the proposed module does not exist yet - if it does, 
please tell me.

A while ago I had the problem to match many different IP-Adress Ranges 
efficiently (several 100 Nets). However, the simple apporoach to just add 
several hundred rules simply added to much latency to packet processing in 
kernel 2.4.25.

So I decided to implement a module to efficiently match many nets...

The idea is to keep a "balanced" [1] tree of ip-ranges and to walk the 
tree in order to decide if a given IP matches or not. That way, matching 
N nets is now O(ln(N)) instead of O(N). I tested the module using all the 
network assignments done by RIPE, APNIC and ARIN combined, and the speed 
is really incredible.

Where could it be used? I got into this during a DDoS attack where we 
thought about (temporarily) just blocking all traffic coming in from 
countries other than where the intended audience lives (as a first line of 
defence - this strategy can be questioned, but a DDoS situation somethimes 
requires questionable counter-measures).

Fighting spam by blocking out known spam-sources very early on is also an 
option.

The module gets configured through files in the /proc hierarchy (as this 
was the simplest way to do it).

I have written a README for the module which can be found here:

   http://oss.stamfest.net/ipt-match-table/README

And the code can be found here (a patch for the 2.4.25 kernel, some chunks 
may be off by a couple of lines, but it _should_ apply cleanly to vanilla 
2.4.25)

   http://oss.stamfest.net/ipt-match-table/ipt-table-match-2.4.25.diff

The iptables user-space support can be found here (sorry, no patch, just 
the source).

   http://oss.stamfest.net/ipt-match-table/libipt_table_match.c

I would like to submit this module to the netfilter project - the only 
trouble is that I simply do not have the time to put much more work into 
it, so I am looking for somebody dedicated to take over maintenance. The 
code is partly based on the condition module (but virtually no code is 
left), everything else is (c) 2004 by me and the whole thing is GPLed.

It has only been tested against kernel 2.4.25, I think it should work for 
2.4.26 as well and I guess it does not work for 2.6. It also only works 
for IPv4 nets and has only been tested on the i386 platform. The last 
changes I did had to do with the handling of the /proc interface and I 
hope this all works correctly right now - somebody cares to test this?



I really hope that somebody speaks up to take over this module, as I see 
many useful applications for it. Implementing it for IPv6 would be great 
as well... porting it to 2.6.x as well...

Any feedback wrt to the concept, etc, is welcome. However, rather sooner 
than later I have to give up maintenance of the code (due to lack of 
time [- even while I'm writing this -], AND the original project the whole 
beast was invented for has been halted as well).


Footnote
--------

[1] Currently two balancing strategies are implemented: one based on 
network-sizes and the other on previous matches for nets. The latter 
balancing further improves matching speed and is thought to be used for 
heavy-traffic machines. Rebalancing should be done periodically, to adapt 
for changes in the traffic pattern(s).


peter


_________________________________________________________________________
Dipl.-Ing. Peter Stamfest         UNIX, Networking & Computing Consultant
Tel: +43/699/10711205             Software Development - Internetservices
E-Mail: peter@stamfest.at         WWW: http://stamfest.at/
