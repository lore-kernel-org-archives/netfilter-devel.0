From: "Ferry Huberts" <ferry@Hupie.com>
Subject: snat dropping packets???
Date: Sat, 16 Oct 2004 14:59:58 +0200 (CEST)
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <34896.192.168.0.192.1097931598.squirrel@192.168.0.192>
Reply-To: ferry@Hupie.com
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hi all!

I have a problem with dropped packets and I suspect netfilter connection
tracking.

The setup: I have set up a box doing full NAT for a box behind it: DNAT in
PREROUTING and SNAT in POSTROUTING.

The situation:
There seem to be multiple things going on. I can not put my finger on it.

1. When there is (heavy) traffic coming into the box towards itself or the
box behind it (for which the NAT is done) at the time of configuring these
iptables rules at startup, there seem to be false/incorrect connection
tracking records.

2. When looking at the situation with tcpdump, I see packets being sent
out to the interface, but I do not see them on the wire. As I understand,
tcpdump hooks in before POSTROUTING, so I suspect SNAT/POSTROUTING from
dropping my packets.

My question:
--> under what conditions are packets dropped? help! :-)
going through the kernel code seemed a bit too daunting at this time, I
thought the people here would have quicker answers...


Also, my external address is a DHCP assigned address and when it changes,
the old connection tracking records are in the way and should be flushed.
But I have no idea on how to accomplish this... help! :-)
I can not use MASQ because I have actually two external DHCP addresses:
one for the box itself and one for the box behind it...

--
Ferry Huberts
