From: Matteo Croce <rootkit85@yahoo.it>
Subject: UNWANTED state
Date: Thu, 30 Dec 2004 00:42:17 +0100
Message-ID: <200412300042.18561.rootkit85@yahoo.it>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_aD00B1WroffIB+3"
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

--Boundary-00=_aD00B1WroffIB+3
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,
time ago i wanted to stealth may gateway, so i start dropping outgoing 
icmp-port-unreachable packets, to avoid UDP scans.
But i had also a '--dport 113 -j REJECT' target to allow faster irc logins,
that stopped working since those ICMP were rejected by the new rule.
So i hacked the kernel with a patch i also attach, to prevent those packets 
being generated.
I also start dropping outgoing RST/ACK to prevent TCP scans, but now i have a 
question:
can an UNWANTED state be useful?
I mean, incoming packets which dstport is closed were classified as UNWANTED.
So were possible to drop UNWANTED packets, and a port will be open when some 
service listens to it and filtered (not closed) when the service doesn't 
listens.
A simple firewall is having a DROP default policy and open used ports.
But what happens when the service listening behind that port stop listenings?
The port remains not filtered, and send RST/ACK (or icmp-port-unreachable) 
when someone tries to connect to it.

Regards, Matteo

-- 
  .""`.     Matteo Croce <3297627799@wind.it>
 : :"  :    proud Debian admin and user
 `. `"`
   `-  Debian - when you have better things to do than fix a system

-- 
  .""`.     Matteo Croce <rootkit85@yahoo.it>
 : :"  :    proud Debian admin and user
 `. `"`
   `-  Debian - when you have better things to do than fix a system

--Boundary-00=_aD00B1WroffIB+3
Content-Type: text/x-diff;
  charset="us-ascii";
  name="udp.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="udp.diff"

diff -urN linux-2.6.10-vanilla/net/ipv4/udp.c linux-2.6.10/net/ipv4/udp.c
--- linux-2.6.10-vanilla/net/ipv4/udp.c	2004-12-26 17:17:09.000000000 +0100
+++ linux-2.6.10/net/ipv4/udp.c	2004-12-29 02:57:26.000000000 +0100
@@ -1165,7 +1165,7 @@
 		goto csum_error;
 
 	UDP_INC_STATS_BH(UDP_MIB_NOPORTS);
-	icmp_send(skb, ICMP_DEST_UNREACH, ICMP_PORT_UNREACH, 0);
+//	icmp_send(skb, ICMP_DEST_UNREACH, ICMP_PORT_UNREACH, 0);
 
 	/*
 	 * Hmm.  We got an UDP packet to a port to which we
diff -urN linux-2.6.10-vanilla/net/ipv6/udp.c linux-2.6.10/net/ipv6/udp.c
--- linux-2.6.10-vanilla/net/ipv6/udp.c	2004-12-26 17:17:10.000000000 +0100
+++ linux-2.6.10/net/ipv6/udp.c	2004-12-29 02:57:48.000000000 +0100
@@ -523,7 +523,7 @@
 			goto discard;
 		UDP6_INC_STATS_BH(UDP_MIB_NOPORTS);
 
-		icmpv6_send(skb, ICMPV6_DEST_UNREACH, ICMPV6_PORT_UNREACH, 0, dev);
+//		icmpv6_send(skb, ICMPV6_DEST_UNREACH, ICMPV6_PORT_UNREACH, 0, dev);
 
 		kfree_skb(skb);
 		return(0);

--Boundary-00=_aD00B1WroffIB+3--
