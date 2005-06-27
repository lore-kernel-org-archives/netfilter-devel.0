From: "Andrew Hall" <temp02@bluereef.com.au>
Subject: Re: Iptables snapshot compile failure with 2.6.12 headers: - please
	disregard
Date: Tue, 28 Jun 2005 09:23:07 +1000
Message-ID: <166b01c57b6f$2d0d7490$5001010a@bluereef.local>
References: <008901c57ab9$e6946330$5001010a@bluereef.local>
	<07f301c57acb$19aaa250$5001010a@bluereef.local>
	<20050627091342.GF19928@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Harald Welte" <laforge@netfilter.org>
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

Here's the missing headers patch that was supplied by Tom Eastep to allow 
Patrick's IPSec code changes to compile cleanly with the iptables:

diff -Naur linux-2.6.11.orig/include/linux/netfilter_ipv4.h 
linux-2.6.11/include/linux/netfilter_ipv4.h
--- linux-2.6.11.orig/include/linux/netfilter_ipv4.h 2005-03-03 
10:55:24.895484995 -0800
+++ linux-2.6.11/include/linux/netfilter_ipv4.h 2005-03-03 
10:55:13.496133352 -0800
@@ -7,8 +7,10 @@

 #include <linux/config.h>
 #include <linux/netfilter.h>
+#ifdef __KERNEL__
 #include <linux/netdevice.h>
 #include <net/protocol.h>
+#endif

 /* IP Cache bits. */
 /* Src IP address. */
diff -Naur linux-2.6.11.orig/include/net/ip.h linux-2.6.11/include/net/ip.h
--- linux-2.6.11.orig/include/net/ip.h 2005-03-03 10:54:34.418212127 -0800
+++ linux-2.6.11/include/net/ip.h 2005-03-03 10:54:25.250342049 -0800
@@ -30,8 +30,10 @@
 #include <linux/netdevice.h>
 #include <linux/inetdevice.h>
 #include <linux/in_route.h>
+#ifdef __KERNEL__
 #include <linux/netfilter.h>
 #include <linux/netfilter_ipv4.h>
+#endif
 #include <net/route.h>
 #include <net/arp.h>
 #include <net/snmp.h>
