From: Henrik Nordstrom <hno@marasystems.com>
Subject: iptables userspace build patch (CLASSIFY & NETMAP extensions)
Date: Tue, 9 Sep 2003 12:40:37 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200309091239.43164@henrik.marasystems.com>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="------------Boundary-00=_PB0YQU5S71J7PD1P7TSC"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--------------Boundary-00=_PB0YQU5S71J7PD1P7TSC
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8bit

Both CLASSIFY and NETMAP are optional extensions and should not be 
built unless supported by the kernel headers.

This patch removes both from the default set of extensions and adds a 
new test for CLASSIFY.

 * removes the double dependency warning on NETMAP and allows the 
already defined test for NETMAP to function correcly to allow 
iptables to build even if the kernel is not patched with base/NETMAP

 * allows iptables userspace to be built even if the kernel is not 
patched with extras/CLASSIFY

Regards
Henrik


--------------Boundary-00=_PB0YQU5S71J7PD1P7TSC
Content-Type: text/x-diff;
  charset="us-ascii";
  name="iptables-extensions.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="iptables-extensions.patch"

Index: extensions/.CLASSIFY-test
===================================================================
RCS file: extensions/.CLASSIFY-test
diff -N extensions/.CLASSIFY-test
--- /dev/null	1 Jan 1970 00:00:00 -0000
+++ extensions/.CLASSIFY-test	9 Sep 2003 10:32:18 -0000
@@ -0,0 +1,2 @@
+#! /bin/sh
+[ -f $KERNEL_DIR/linux/netfilter_ipv4/ipt_CLASSIFY.h ] && echo CLASSIFY
Index: extensions/Makefile
===================================================================
RCS file: /cvspublic/netfilter/userspace/extensions/Makefile,v
retrieving revision 1.33
diff -u -w -p -r1.33 Makefile
--- extensions/Makefile	23 Aug 2003 22:10:11 -0000	1.33
+++ extensions/Makefile	9 Sep 2003 10:32:18 -0000
@@ -5,7 +5,7 @@
 # header files are present in the include/linux directory of this iptables
 # package (HW)
 #
-PF_EXT_SLIB:=ah connlimit conntrack dscp ecn esp helper icmp iprange length limit mac mark multiport owner physdev pkttype realm rpc standard state tcp tcpmss tos ttl udp unclean CLASSIFY CONNMARK DNAT DSCP ECN LOG MARK MASQUERADE MIRROR NETMAP REDIRECT REJECT SAME SNAT TARPIT TCPMSS TOS TTL ULOG
+PF_EXT_SLIB:=ah connlimit conntrack dscp ecn esp helper icmp iprange length limit mac mark multiport owner physdev pkttype realm rpc standard state tcp tcpmss tos ttl udp unclean CONNMARK DNAT DSCP ECN LOG MARK MASQUERADE MIRROR REDIRECT REJECT SAME SNAT TARPIT TCPMSS TOS TTL ULOG
 PF6_EXT_SLIB:=eui64 hl icmpv6 length limit mac mark multiport owner standard tcp udp HL LOG MARK
 
 # Optionals

--------------Boundary-00=_PB0YQU5S71J7PD1P7TSC--
