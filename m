From: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Subject: Re: [PATCH] admin-prohibited option. Let us look at it again.
Date: Sat, 28 Jun 2003 11:58:00 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.51.0306281147310.8133@dns.toxicfilms.tv>
References: <Pine.LNX.4.51.0304091722270.12113@dns.toxicfilms.tv>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <Pine.LNX.4.51.0304091722270.12113@dns.toxicfilms.tv>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello,

I guess it is time to send admin-prohib to davem, as we discussed earlier
on.

Here is what I suggested back then:

 patch-o-matic/extra/admin-prohib.patch      |   34 ++++++++++++++++++++++++++++
 patch-o-matic/extra/admin-prohib.patch.help |    9 +++++++
 userspace/INCOMPATIBILITIES                 |    6 ++++
 userspace/extensions/libipt_REJECT.c        |   16 ++++++++++++-
 userspace/iptables.8                        |    7 ++++-
 5 files changed, 69 insertions(+), 3 deletions(-)

diff -Nru netfilter.orig/patch-o-matic/extra/admin-prohib.patch netfilter/patch-o-matic/extra/admin-prohib.patch
--- netfilter.orig/patch-o-matic/extra/admin-prohib.patch	1970-01-01 01:00:00.000000000 +0100
+++ netfilter/patch-o-matic/extra/admin-prohib.patch	2003-04-09 16:43:50.000000000 +0200
@@ -0,0 +1,34 @@
+diff -Nru linux.bak/include/linux/netfilter_ipv4/ipt_REJECT.h linux/include/linux/netfilter_ipv4/ipt_REJECT.h
+--- linux.bak/include/linux/netfilter_ipv4/ipt_REJECT.h	2003-04-08 20:21:22.000000000 +0200
++++ linux/include/linux/netfilter_ipv4/ipt_REJECT.h	2003-04-09 16:40:05.000000000 +0200
+@@ -9,7 +9,8 @@
+ 	IPT_ICMP_ECHOREPLY,
+ 	IPT_ICMP_NET_PROHIBITED,
+ 	IPT_ICMP_HOST_PROHIBITED,
+-	IPT_TCP_RESET
++	IPT_TCP_RESET,
++	IPT_ICMP_ADMIN_PROHIBITED
+ };
+
+ struct ipt_reject_info {
+diff -Nru linux.bak/net/ipv4/netfilter/ipt_REJECT.c linux/net/ipv4/netfilter/ipt_REJECT.c
+--- linux.bak/net/ipv4/netfilter/ipt_REJECT.c	2003-04-08 20:21:56.000000000 +0200
++++ linux/net/ipv4/netfilter/ipt_REJECT.c	2003-04-09 16:41:07.000000000 +0200
+@@ -1,6 +1,7 @@
+ /*
+  * This is a module which is used for rejecting packets.
+  * Added support for customized reject packets (Jozsef Kadlecsik).
++ * Added support for ICMP type-3-code-13 (Maciej Soltysiak). [RFC 1812]
+  */
+ #include <linux/config.h>
+ #include <linux/module.h>
+@@ -330,6 +331,9 @@
+ 	case IPT_ICMP_HOST_PROHIBITED:
+     		send_unreach(*pskb, ICMP_HOST_ANO);
+     		break;
++    	case IPT_ICMP_ADMIN_PROHIBITED:
++		send_unreach(*pskb, ICMP_PKT_FILTERED);
++		break;
+ 	case IPT_TCP_RESET:
+ 		send_reset(*pskb, hooknum == NF_IP_LOCAL_IN);
+ 	case IPT_ICMP_ECHOREPLY:
diff -Nru netfilter.orig/patch-o-matic/extra/admin-prohib.patch.help netfilter/patch-o-matic/extra/admin-prohib.patch.help
--- netfilter.orig/patch-o-matic/extra/admin-prohib.patch.help	1970-01-01 01:00:00.000000000 +0100
+++ netfilter/patch-o-matic/extra/admin-prohib.patch.help	2003-04-09 16:47:14.000000000 +0200
@@ -0,0 +1,9 @@
+Author: Maciej Soltysiak <solt@dns.toxicfilms.tv>
+Status: Working, causes incompatibilities.
+
+This patch adds --reject-with admin-prohib option to the REJECT targe
+making it compliant with RFC 1812 and making an incompatibility
+with kernels that do not support this ipt_REJECT.c option.
+
+Usage of this option with kernels that do not support will effect in
+a DROP, not REJECT.
diff -Nru netfilter.orig/userspace/INCOMPATIBILITIES netfilter/userspace/INCOMPATIBILITIES
--- netfilter.orig/userspace/INCOMPATIBILITIES	1970-01-01 01:00:00.000000000 +0100
+++ netfilter/userspace/INCOMPATIBILITIES	2003-04-09 16:53:01.000000000 +0200
@@ -0,0 +1,6 @@
+INCOMPATIBILITIES:
+
+- The REJECT target has an '--reject-with admin-prohib' option which used
+  with kernels that do not support it, will result in a plain DROP instead
+  of REJECT.  Use with caution.
+  Kernels that do support it:
diff -Nru netfilter.orig/userspace/extensions/libipt_REJECT.c netfilter/userspace/extensions/libipt_REJECT.c
--- netfilter.orig/userspace/extensions/libipt_REJECT.c	2003-04-08 21:49:15.000000000 +0200
+++ netfilter/userspace/extensions/libipt_REJECT.c	2003-04-09 16:59:53.000000000 +0200
@@ -9,6 +9,16 @@
 #include <iptables.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_REJECT.h>
+#include <linux/version.h>
+
+/* If we are compiling against a kernel that does not support
+ * IPT_ICMP_ADMIN_PROHIBITED, we are emulating it.
+ * The result will be a plain DROP of the packet instead of
+ * reject. -- Maciej Soltysiak <solt@dns.toxicfilms.tv>
+ */
+#ifndef IPT_ICMP_ADMIN_PROHIBITED
+#define IPT_ICMP_ADMIN_PROHIBITED	IPT_TCP_RESET + 1
+#endif

 struct reject_names {
 	const char *name;
@@ -35,7 +45,9 @@
 	{"icmp-host-prohibited", "host-prohib",
 	 IPT_ICMP_HOST_PROHIBITED, "ICMP host prohibited"},
 	{"tcp-reset", "tcp-reset",
-	 IPT_TCP_RESET, "TCP RST packet"}
+	 IPT_TCP_RESET, "TCP RST packet"},
+	{"icmp-admin-prohibited", "admin-prohib",
+	 IPT_ICMP_ADMIN_PROHIBITED, "ICMP administratively prohibited (*)"}
 };

 static void
@@ -64,6 +76,8 @@
 "                                a reply packet according to type:\n");

 	print_reject_types();
+
+	printf("(*) See man page or read the INCOMPATIBILITES file for compatibility issues.\n");
 }

 static struct option opts[] = {
diff -Nru netfilter.orig/userspace/iptables.8 netfilter/userspace/iptables.8
--- netfilter.orig/userspace/iptables.8	2003-04-08 21:49:17.000000000 +0200
+++ netfilter/userspace/iptables.8	2003-04-09 17:11:20.000000000 +0200
@@ -852,8 +852,9 @@
 .BR icmp-host-unreachable ,
 .BR icmp-port-unreachable ,
 .BR icmp-proto-unreachable ,
-.BR "icmp-net-prohibited or"
-.BR icmp-host-prohibited ,
+.BR icmp-net-prohibited ,
+.BR "icmp-host-prohibited or"
+.BR "icmp-admin-prohibited (*)"
 which return the appropriate ICMP error message (\fBport-unreachable\fP is
 the default).  The option
 .B tcp-reset
@@ -862,6 +863,8 @@
 .I ident
 (113/tcp) probes which frequently occur when sending mail to broken mail
 hosts (which won't accept your mail otherwise).
+.TP
+(*) Using icmp-admin-prohibited with kernels that do not support it will result in a plain DROP instead of REJECT
 .SS SNAT
 This target is only valid in the
 .B nat
