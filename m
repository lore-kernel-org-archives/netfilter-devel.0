From: Matthew Wilcox <willy@debian.org>
Subject: [PATCH] Use net/checksum.h, not asm/checksum.h
Date: Sat, 20 Sep 2003 01:19:17 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030920001917.GG21596@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: James Morris <jmorris@intercode.com.au>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


On PA-RISC, I get the warning:

In file included from net/ipv4/netfilter/ip_nat_snmp_basic.c:56:
include/asm/checksum.h:127: warning: `struct in6_addr' declared inside parameter
 list
include/asm/checksum.h:127: warning: its scope is only this definition or declar
ation, which is probably not what you want.

This patch fixes that:

Index: net/ipv4/netfilter/ip_nat_snmp_basic.c
===================================================================
RCS file: /var/cvs/linux-2.6/net/ipv4/netfilter/ip_nat_snmp_basic.c,v
retrieving revision 1.3
diff -u -p -r1.3 ip_nat_snmp_basic.c
--- net/ipv4/netfilter/ip_nat_snmp_basic.c      8 Sep 2003 21:42:58 -0000      1.3
+++ net/ipv4/netfilter/ip_nat_snmp_basic.c      20 Sep 2003 00:15:46 -0000
@@ -51,9 +51,9 @@
 #include <linux/netfilter_ipv4/ip_nat.h>
 #include <linux/netfilter_ipv4/ip_nat_helper.h>
 #include <linux/ip.h>
+#include <net/checksum.h>
 #include <net/udp.h>
 #include <asm/uaccess.h>
-#include <asm/checksum.h>
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("James Morris <jmorris@intercode.com.au>");


-- 
"It's not Hollywood.  War is real, war is primarily not about defeat or
victory, it is about death.  I've seen thousands and thousands of dead bodies.
Do you think I want to have an academic debate on this subject?" -- Robert Fisk
