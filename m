From: Roman Ammann <rammann@ita.hsr.ch>
Subject: Connection ID in conntrack and libctnetlink / Max connections
	showed by conntrack
Date: Sun, 01 May 2005 13:08:40 +0200
Message-ID: <1114945720.22582.26.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
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

Hello

Background:

(short version) I tried to use conntrack to delete connections in the
conntrack table.

(long version) I'm using iptables to give some customers access for some
time (1 or 2h). I allow established connections to pass and also the
customer's source IP. The problem is if I drop the rule which allows the
customer's IP address to pass, it doesn't drops his connections, because
they are handled in the state full part of iptables. So if he's using
VPN for example the connection is never dropped :-(. I need to use
state-full inspections because I have to NAT.

What I've done until now:

I've used patch-o-magic to patch my kernel with the nfnetlink, the
conntrack-event-api and the ctnetlink patch. I also compiled and
installed libnfnetlink, libctnetlink and conntrack (newest
SVN-Versions). Everthing seems to work.

Problems:

a) I can't drop a connections because I have to pass the connections ID
to the programm conntrack (conntrack -D conntrack -i <id>) and conntrack
doesn't listen dem (conntrack -L conntrack).

So i checked the source code and I found in the file
conntrack/src/libct.c (line 194) and also in dhe Kernel-Sources
(include/linux/netfilter_ipv4/ip_conntrack_netlink.h) that the ID part
is commented out.

Why? Is there a problem with the ID? I removed the comments and
recompile it. Afterwards the ID was showed but some connections had the
same ID. Is that correct?

b) I used conntrack (conntrack -L conntrack) to list my current
connections. But conntrack list just 16 connections. But if I
use /proc/net/ip_conntrack is see 31 connections. 

Is there a problem to get all connections over netlink? Is there a
difference between fetch the connections with netlink or
via /proc/net/ip_conntrack?

Thanks for any input
 Roman
