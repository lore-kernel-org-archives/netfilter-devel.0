From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH NF_CONNTRACK 5/9]: unifies the definitions in icmp.
Date: Tue, 22 Mar 2005 22:54:25 +0900 (JST)
Message-ID: <200503221354.j2MDsP1w019371@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Tue_Mar_22_22:54:25_2005_678)--"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: kaber@trash.net
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

----Next_Part(Tue_Mar_22_22:54:25_2005_678)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


This patch unifies the definitions in {ip,nf}_conntrack_icmp.h

Signed-off-by: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>

-----------------------------------------------------------------
Yasuyuki KOZAKAI @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>

----Next_Part(Tue_Mar_22_22:54:25_2005_678)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="05-defs-icmp.patch"

diff -Nur linux-2.6.11-nfct-defs-tcp/include/linux/netfilter/ipv4/nf_conntrack_icmp.h linux-2.6.11-nfct-defs-icmp/include/linux/netfilter/ipv4/nf_conntrack_icmp.h
--- linux-2.6.11-nfct-defs-tcp/include/linux/netfilter/ipv4/nf_conntrack_icmp.h	2005-03-22 16:58:51.000000000 +0900
+++ linux-2.6.11-nfct-defs-icmp/include/linux/netfilter/ipv4/nf_conntrack_icmp.h	2005-03-22 17:31:07.000000000 +0900
@@ -1,17 +1,11 @@
-/*
- * ICMP tracking.
- *
- * Derived from include/linux/netfiter_ipv4/ip_conntrack_icmp.h
- */
-
 #ifndef _NF_CONNTRACK_ICMP_H
 #define _NF_CONNTRACK_ICMP_H
+/* ICMP tracking. */
 #include <asm/atomic.h>
 
-struct nf_ct_icmp
+struct ip_ct_icmp
 {
 	/* Optimization: when number in == number out, forget immediately. */
 	atomic_t count;
 };
-
 #endif /* _NF_CONNTRACK_ICMP_H */
diff -Nur linux-2.6.11-nfct-defs-tcp/include/linux/netfilter/nf_conntrack.h linux-2.6.11-nfct-defs-icmp/include/linux/netfilter/nf_conntrack.h
--- linux-2.6.11-nfct-defs-tcp/include/linux/netfilter/nf_conntrack.h	2005-03-22 17:07:24.000000000 +0900
+++ linux-2.6.11-nfct-defs-icmp/include/linux/netfilter/nf_conntrack.h	2005-03-22 17:22:38.000000000 +0900
@@ -31,7 +31,7 @@
 	/* insert conntrack proto private data here */
 	struct nf_ct_sctp sctp;
 	struct ip_ct_tcp tcp;
-	struct nf_ct_icmp icmp;
+	struct ip_ct_icmp icmp;
 	struct nf_ct_icmpv6 icmpv6;
 };
 
diff -Nur linux-2.6.11-nfct-defs-tcp/include/linux/netfilter_ipv4/ip_conntrack_icmp.h linux-2.6.11-nfct-defs-icmp/include/linux/netfilter_ipv4/ip_conntrack_icmp.h
--- linux-2.6.11-nfct-defs-tcp/include/linux/netfilter_ipv4/ip_conntrack_icmp.h	2005-03-22 16:58:51.000000000 +0900
+++ linux-2.6.11-nfct-defs-icmp/include/linux/netfilter_ipv4/ip_conntrack_icmp.h	2005-03-22 17:32:12.000000000 +0900
@@ -1,11 +1,6 @@
 #ifndef _IP_CONNTRACK_ICMP_H
 #define _IP_CONNTRACK_ICMP_H
-/* ICMP tracking. */
-#include <asm/atomic.h>
 
-struct ip_ct_icmp
-{
-	/* Optimization: when number in == number out, forget immediately. */
-	atomic_t count;
-};
+#include <linux/netfilter/ipv4/nf_conntrack_icmp.h>
+
 #endif /* _IP_CONNTRACK_ICMP_H */

----Next_Part(Tue_Mar_22_22:54:25_2005_678)----
