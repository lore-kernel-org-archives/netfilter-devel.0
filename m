From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH NF_CONNTRACK 6/9]: unifies the definitions in sctp.
Date: Tue, 22 Mar 2005 22:55:48 +0900 (JST)
Message-ID: <200503221355.j2MDtn2B020205@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Tue_Mar_22_22:55:48_2005_736)--"
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

----Next_Part(Tue_Mar_22_22:55:48_2005_736)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


This patch unifies the definitions in {ip,nf}_conntrack_sctp.h

Signed-off-by: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>

-----------------------------------------------------------------
Yasuyuki KOZAKAI @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>

----Next_Part(Tue_Mar_22_22:55:48_2005_736)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="06-defs-sctp.patch"

diff -Nur linux-2.6.11-nfct-defs-icmp/include/linux/netfilter/nf_conntrack.h linux-2.6.11-nfct-defs-sctp/include/linux/netfilter/nf_conntrack.h
--- linux-2.6.11-nfct-defs-icmp/include/linux/netfilter/nf_conntrack.h	2005-03-22 17:22:38.000000000 +0900
+++ linux-2.6.11-nfct-defs-sctp/include/linux/netfilter/nf_conntrack.h	2005-03-22 17:39:17.000000000 +0900
@@ -29,7 +29,7 @@
 /* per conntrack: protocol private data */
 union nf_conntrack_proto {
 	/* insert conntrack proto private data here */
-	struct nf_ct_sctp sctp;
+	struct ip_ct_sctp sctp;
 	struct ip_ct_tcp tcp;
 	struct ip_ct_icmp icmp;
 	struct nf_ct_icmpv6 icmpv6;
diff -Nur linux-2.6.11-nfct-defs-icmp/include/linux/netfilter/nf_conntrack_sctp.h linux-2.6.11-nfct-defs-sctp/include/linux/netfilter/nf_conntrack_sctp.h
--- linux-2.6.11-nfct-defs-icmp/include/linux/netfilter/nf_conntrack_sctp.h	2005-03-22 17:17:37.000000000 +0900
+++ linux-2.6.11-nfct-defs-sctp/include/linux/netfilter/nf_conntrack_sctp.h	2005-03-22 17:43:20.000000000 +0900
@@ -1,11 +1,6 @@
-/*
- * SCTP tracking.
- *
- * Derived from include/linux/netfiter_ipv4/ip_conntrack_tcp.h
- */
-
 #ifndef _NF_CONNTRACK_SCTP_H
 #define _NF_CONNTRACK_SCTP_H
+/* SCTP tracking. */
 
 enum sctp_conntrack {
 	SCTP_CONNTRACK_NONE,
@@ -19,7 +14,7 @@
 	SCTP_CONNTRACK_MAX
 };
 
-struct nf_ct_sctp
+struct ip_ct_sctp
 {
 	enum sctp_conntrack state;
 
diff -Nur linux-2.6.11-nfct-defs-icmp/include/linux/netfilter_ipv4/ip_conntrack_sctp.h linux-2.6.11-nfct-defs-sctp/include/linux/netfilter_ipv4/ip_conntrack_sctp.h
--- linux-2.6.11-nfct-defs-icmp/include/linux/netfilter_ipv4/ip_conntrack_sctp.h	2005-03-22 17:17:37.000000000 +0900
+++ linux-2.6.11-nfct-defs-sctp/include/linux/netfilter_ipv4/ip_conntrack_sctp.h	2005-03-22 17:47:33.000000000 +0900
@@ -1,25 +1,6 @@
 #ifndef _IP_CONNTRACK_SCTP_H
 #define _IP_CONNTRACK_SCTP_H
-/* SCTP tracking. */
 
-enum sctp_conntrack {
-	SCTP_CONNTRACK_NONE,
-	SCTP_CONNTRACK_CLOSED,
-	SCTP_CONNTRACK_COOKIE_WAIT,
-	SCTP_CONNTRACK_COOKIE_ECHOED,
-	SCTP_CONNTRACK_ESTABLISHED,
-	SCTP_CONNTRACK_SHUTDOWN_SENT,
-	SCTP_CONNTRACK_SHUTDOWN_RECD,
-	SCTP_CONNTRACK_SHUTDOWN_ACK_SENT,
-	SCTP_CONNTRACK_MAX
-};
-
-struct ip_ct_sctp
-{
-	enum sctp_conntrack state;
-
-	u_int32_t vtag[IP_CT_DIR_MAX];
-	u_int32_t ttag[IP_CT_DIR_MAX];
-};
+#include <linux/netfilter/nf_conntrack_sctp.h>
 
 #endif /* _IP_CONNTRACK_SCTP_H */

----Next_Part(Tue_Mar_22_22:55:48_2005_736)----
