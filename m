From: Robert de Bath <robert$@mayday.cix.co.uk>
Subject: Iptables 1.3.1 still not very fast.
Date: Fri, 1 Apr 2005 21:47:05 +0100 (BST)
Message-ID: <0f598b09cef38490@mayday.cix.co.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

Okay, I'll admit is it a LOT faster that 1.2.11 it still seems to take a 
long time with big tables.

An example:
I have a program (I've called iptrange) that will take a file full of ip 
address ranges (192.168.42.10 192.168.42.25) and converts them into a set
of iptables chains that invokes another chain if the source (or dest) 
matches ie:

iptables -N CHECK
iptables -A CHECK -s 192.168.42.10/31 -j FOUND
iptables -A CHECK -s 192.168.42.12/30 -j FOUND
iptables -A CHECK -s 192.168.42.16/29 -j FOUND
iptables -A CHECK -s 192.168.42.24/31 -j FOUND

The good bit is that it will create a tree of subchains so that the
matching is efficient for large numbers of ip addresses.

This works well for a few hundred address ranges; I use it to match
recent 'evil' ips and ranges from dshield.org.

However, when I tried a 50000 range list from http://blocklist.org I
ran into problems.  After conversion it created 20000 chains with a
total of 70000 rules.  This tables took about an hour to load using
iptables-1.2.11!

Version 1.3.1 of libiptc is a LOT faster at about 5 minutes to do the
load. But this still seems very slow when it takes about half a second
to generate and print out the iptables rules to a script.

I hate to think how slow it would be with a million ranges; assuming 
it can be loaded it looks like it would be about 300000 chains, 1.3M
rules and about 100 rules checked per packet (to pick some figures out
of a single test) so it should be useable ...

BTW: iptables-restore is slower than my iptrange!

My problem is that I think that libiptc looks evil and I really don't
want to dive into messing with that code. So how can I help to make
libiptc run as fast as I'd like it to?

-- 
Rob.                          (Robert de Bath <robert$ @ debath.co.uk>)
