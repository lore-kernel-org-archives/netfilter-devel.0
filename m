From: Bernardo Innocenti <bernie@develer.com>
Subject: Intermittent NAT failure when multiple hosts send UDP packets
Date: Sat, 17 Sep 2005 05:01:22 +0200
Message-ID: <432B8702.3060801@develer.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1750836AbVIQDBb@vger.kernel.org>
To: lkml <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This smells like a bug in UDP ip_nat_proto_udp.c or nearby.
I'm seeing this on 2.6.12-1.1447_FC4, but code in 2.6.13 is
still the same.

I've setup SNAT the usual way:

 iptables -A POSTROUTING -t nat -o ppp0 -j SNAT --to-source 151.38.19.110

When multiple clients in the LAN send UDP packets to the same port of
the same remote host, I see something like this in my /proc/net/ip_conntrack:

 udp      17 170 src=10.3.3.2 dst=194.185.88.60 sport=5060 dport=5060 src=194.185.88.60 dst=151.38.19.110 sport=5060 dport=5060 [ASSURED] use=1
 udp      17 29 src=10.3.3.2 dst=212.97.59.76 sport=5060 dport=5060 [UNREPLIED] src=212.97.59.76 dst=151.38.19.110 sport=5060 dport=5060 use=1
 udp      17 177 src=10.3.3.250 dst=194.185.88.60 sport=5060 dport=5060 src=194.185.88.60 dst=151.38.19.110 sport=5060 dport=1024 [ASSURED] use=1

In the last line, the destination port has been properly remapped from
5060 to 1024 to distingish between incoming packets.

However, I see packets going out over ppp0 without the source
address properly rewritten to 151.38.19.110:

 04:38:28.739514 IP 10.3.3.2.5060 > 194.185.88.60.5060: UDP, length 536

This doesn't happen when there's just a single host sending to port 5060.
Sometimes I must restart the interface to trigger this bug.  



-- 
  // Bernardo Innocenti - Develer S.r.l., R&D dept.
\X/  http://www.develer.com/
