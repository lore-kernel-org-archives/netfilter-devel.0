From: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Subject: --reject-with admin-prohib - Suggested Solution.
Date: Tue, 12 Nov 2002 17:16:47 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0211121712540.1461-100000@dns.toxicfilms.tv>
References: <Pine.LNX.4.44.0211120952040.29168-100000@dns.toxicfilms.tv>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.samba.org
In-Reply-To: <Pine.LNX.4.44.0211120952040.29168-100000@dns.toxicfilms.tv>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

Let's say the patch below has been submitted to 2.5 kernel, at 2.5.48
stage. It adds admin-prohib to the REJECT target.

--- /2/linux-2.4.19/include/linux/netfilter_ipv4/ipt_REJECT.h	2000-07-14 21:20:23.000000000 +0200
+++ /usr/src/linux-2.4.19/include/linux/netfilter_ipv4/ipt_REJECT.h	2002-11-12 14:31:13.000000000 +0100
@@ -9,7 +9,8 @@
 	IPT_ICMP_ECHOREPLY,
 	IPT_ICMP_NET_PROHIBITED,
 	IPT_ICMP_HOST_PROHIBITED,
-	IPT_TCP_RESET
+	IPT_TCP_RESET,
+	IPT_ICMP_ADMIN_PROHIBITED
 };

 struct ipt_reject_info {
--- /2/linux-2.4.19/net/ipv4/netfilter/ipt_REJECT.c	2002-11-12 14:40:08.000000000 +0100
+++ /usr/src/linux-2.4.19/net/ipv4/netfilter/ipt_REJECT.c	2002-11-12 14:31:25.000000000 +0100
@@ -1,6 +1,7 @@
 /*
  * This is a module which is used for rejecting packets.
  * Added support for customized reject packets (Jozsef Kadlecsik).
+ * Added support for ICMP type-3-code-13 (Maciej Soltysiak). [RFC 1812]
  */
 #include <linux/config.h>
 #include <linux/module.h>
@@ -308,6 +308,9 @@
 	case IPT_ICMP_HOST_PROHIBITED:
     		send_unreach(*pskb, ICMP_HOST_ANO);
     		break;
+    	case IPT_ICMP_ADMIN_PROHIBITED:
+		send_unreach(*pskb, ICMP_PKT_FILTERED);
+		break;
 	case IPT_TCP_RESET:
 		send_reset(*pskb, hooknum == NF_IP_LOCAL_IN);
 	case IPT_ICMP_ECHOREPLY:


Okay, having that, let's say we have patched the current userspace with
this patch:

--- iptables-1.2.8-20020825/extensions/libipt_REJECT.c	2002-05-29 15:08:16.000000000 +0200
+++ iptables/extensions/libipt_REJECT.c	2002-11-12 17:06:19.000000000 +0100
@@ -9,6 +9,11 @@
 #include <iptables.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_REJECT.h>
+#include <linux/version.h>
+
+#ifndef IPT_ICMP_ADMIN_PROHIBITED
+#define IPT_ICMP_ADMIN_PROHIBITED	8
+#endif

 struct reject_names {
 	const char *name;
@@ -36,6 +41,11 @@
 	 IPT_ICMP_HOST_PROHIBITED, "ICMP host prohibited"},
 	{"tcp-reset", "tcp-reset",
 	 IPT_TCP_RESET, "TCP RST packet"}
+#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,5,48))
+	,
+	{"icmp-admin-prohibited", "admin-prohib",
+	 IPT_ICMP_ADMIN_PROHIBITED, "ICMP administratively prohibited"}
+#endif
 };

 static void


Now, if the 2.5.48 kernel has the admin-prohib support, the userspace will
detect it, and will show the option in -j REJECT --help and will accept
admin-prohib.

What do you think?

I think we can safely submit the change to the 2.5 kernel, and when it is
there, we can patch the oficial userspace.

Best Regards,
Maciej Soltysiak
