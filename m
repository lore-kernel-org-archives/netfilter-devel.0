From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH NF_CONNTRACK 3/9]: unifies the definitions of ftp.
Date: Tue, 22 Mar 2005 22:48:45 +0900 (JST)
Message-ID: <200503221348.j2MDmj5D016588@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Tue_Mar_22_22:48:45_2005_409)--"
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

----Next_Part(Tue_Mar_22_22:48:45_2005_409)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


This patch unifies the definitions of ftp in {ip,nf}_conntrack.

Signed-off-by: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>

-----------------------------------------------------------------
Yasuyuki KOZAKAI @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>


----Next_Part(Tue_Mar_22_22:48:45_2005_409)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="03-defs-ftp.patch"

diff -Nur linux-2.6.11-nfct-defs-tuple/include/linux/netfilter/nf_conntrack.h linux-2.6.11-nfct-defs-ftp/include/linux/netfilter/nf_conntrack.h
--- linux-2.6.11-nfct-defs-tuple/include/linux/netfilter/nf_conntrack.h	2005-03-22 16:29:10.000000000 +0900
+++ linux-2.6.11-nfct-defs-ftp/include/linux/netfilter/nf_conntrack.h	2005-03-22 16:48:32.000000000 +0900
@@ -45,7 +45,7 @@
 /* per conntrack: application helper private data */
 union nf_conntrack_help {
 	/* insert conntrack helper private data (master) here */
-	struct nf_ct_ftp_master ct_ftp_info;
+	struct ip_ct_ftp_master ct_ftp_info;
 };
 
 #include <linux/types.h>
diff -Nur linux-2.6.11-nfct-defs-tuple/include/linux/netfilter/nf_conntrack_ftp.h linux-2.6.11-nfct-defs-ftp/include/linux/netfilter/nf_conntrack_ftp.h
--- linux-2.6.11-nfct-defs-tuple/include/linux/netfilter/nf_conntrack_ftp.h	2005-03-22 16:29:10.000000000 +0900
+++ linux-2.6.11-nfct-defs-ftp/include/linux/netfilter/nf_conntrack_ftp.h	2005-03-22 16:48:09.000000000 +0900
@@ -1,59 +1,43 @@
-/*
- * nf_conntrack_ftp.h
- *
- * Definitions and Declarations for FTP tracking.
- *
- * Derived from include/linux/netfiter_ipv4/ip_conntrack_ftp.h
- *
- * 16 Dec 2003: Yasuyuki Kozakai @ USAGI <yasuyuki.kozakai@toshiba.co.jp>
- *	- IPv6 support.
- */
-
 #ifndef _NF_CONNTRACK_FTP_H
 #define _NF_CONNTRACK_FTP_H
 /* FTP tracking. */
 
 #ifdef __KERNEL__
 
-#include <linux/netfilter_ipv4/lockhelp.h>
-
-/* Protects ftp part of conntracks */
-DECLARE_LOCK_EXTERN(ip_ftp_lock);
-
 #define FTP_PORT	21
 
 #endif /* __KERNEL__ */
 
-enum nf_ct_ftp_type
+enum ip_ct_ftp_type
 {
 	/* PORT command from client */
-	NF_CT_FTP_PORT,
+	IP_CT_FTP_PORT,
 	/* PASV response from server */
-	NF_CT_FTP_PASV,
+	IP_CT_FTP_PASV,
 	/* EPRT command from client */
-	NF_CT_FTP_EPRT,
+	IP_CT_FTP_EPRT,
 	/* EPSV response from server */
-	NF_CT_FTP_EPSV,
+	IP_CT_FTP_EPSV,
 };
 
-#define NUM_SEQ_TO_REMEMBER	2
+#define NUM_SEQ_TO_REMEMBER 2
 /* This structure exists only once per master */
-struct nf_ct_ftp_master {
+struct ip_ct_ftp_master {
 	/* Valid seq positions for cmd matching after newline */
 	u_int32_t seq_aft_nl[IP_CT_DIR_MAX][NUM_SEQ_TO_REMEMBER];
 	/* 0 means seq_match_aft_nl not set */
 	int seq_aft_nl_num[IP_CT_DIR_MAX];
 };
 
-struct nf_conntrack_expect;
+struct ip_conntrack_expect;
 
 /* For NAT to hook in when we find a packet which describes what other
  * connection we should expect. */
-extern unsigned int (*nf_nat_ftp_hook)(struct sk_buff **pskb,
+extern unsigned int (*ip_nat_ftp_hook)(struct sk_buff **pskb,
 				       enum ip_conntrack_info ctinfo,
-				       enum nf_ct_ftp_type type,
+				       enum ip_ct_ftp_type type,
 				       unsigned int matchoff,
 				       unsigned int matchlen,
-				       struct nf_conntrack_expect *exp,
+				       struct ip_conntrack_expect *exp,
 				       u32 *seq);
 #endif /* _NF_CONNTRACK_FTP_H */
diff -Nur linux-2.6.11-nfct-defs-tuple/include/linux/netfilter_ipv4/ip_conntrack_ftp.h linux-2.6.11-nfct-defs-ftp/include/linux/netfilter_ipv4/ip_conntrack_ftp.h
--- linux-2.6.11-nfct-defs-tuple/include/linux/netfilter_ipv4/ip_conntrack_ftp.h	2005-03-22 16:29:10.000000000 +0900
+++ linux-2.6.11-nfct-defs-ftp/include/linux/netfilter_ipv4/ip_conntrack_ftp.h	2005-03-22 16:49:47.000000000 +0900
@@ -1,43 +1,6 @@
 #ifndef _IP_CONNTRACK_FTP_H
 #define _IP_CONNTRACK_FTP_H
-/* FTP tracking. */
 
-#ifdef __KERNEL__
+#include <linux/netfilter/nf_conntrack_ftp.h>
 
-#define FTP_PORT	21
-
-#endif /* __KERNEL__ */
-
-enum ip_ct_ftp_type
-{
-	/* PORT command from client */
-	IP_CT_FTP_PORT,
-	/* PASV response from server */
-	IP_CT_FTP_PASV,
-	/* EPRT command from client */
-	IP_CT_FTP_EPRT,
-	/* EPSV response from server */
-	IP_CT_FTP_EPSV,
-};
-
-#define NUM_SEQ_TO_REMEMBER 2
-/* This structure exists only once per master */
-struct ip_ct_ftp_master {
-	/* Valid seq positions for cmd matching after newline */
-	u_int32_t seq_aft_nl[IP_CT_DIR_MAX][NUM_SEQ_TO_REMEMBER];
-	/* 0 means seq_match_aft_nl not set */
-	int seq_aft_nl_num[IP_CT_DIR_MAX];
-};
-
-struct ip_conntrack_expect;
-
-/* For NAT to hook in when we find a packet which describes what other
- * connection we should expect. */
-extern unsigned int (*ip_nat_ftp_hook)(struct sk_buff **pskb,
-				       enum ip_conntrack_info ctinfo,
-				       enum ip_ct_ftp_type type,
-				       unsigned int matchoff,
-				       unsigned int matchlen,
-				       struct ip_conntrack_expect *exp,
-				       u32 *seq);
 #endif /* _IP_CONNTRACK_FTP_H */
diff -Nur linux-2.6.11-nfct-defs-tuple/net/netfilter/nf_conntrack_ftp.c linux-2.6.11-nfct-defs-ftp/net/netfilter/nf_conntrack_ftp.c
--- linux-2.6.11-nfct-defs-tuple/net/netfilter/nf_conntrack_ftp.c	2005-03-22 16:29:10.000000000 +0900
+++ linux-2.6.11-nfct-defs-ftp/net/netfilter/nf_conntrack_ftp.c	2005-03-22 16:56:11.000000000 +0900
@@ -49,7 +49,7 @@
 
 unsigned int (*nf_nat_ftp_hook)(struct sk_buff **pskb,
 				enum ip_conntrack_info ctinfo,
-				enum nf_ct_ftp_type type,
+				enum ip_ct_ftp_type type,
 				unsigned int matchoff,
 				unsigned int matchlen,
 				struct nf_conntrack_expect *exp,
@@ -73,31 +73,31 @@
 	size_t plen;
 	char skip;
 	char term;
-	enum nf_ct_ftp_type ftptype;
+	enum ip_ct_ftp_type ftptype;
 	int (*getnum)(const char *, size_t, struct nf_conntrack_man *, char);
 } search[] = {
 	{
 		IP_CT_DIR_ORIGINAL,
 		"PORT", sizeof("PORT") - 1, ' ', '\r',
-		NF_CT_FTP_PORT,
+		IP_CT_FTP_PORT,
 		try_rfc959,
 	},
 	{
 		IP_CT_DIR_REPLY,
 		"227 ", sizeof("227 ") - 1, '(', ')',
-		NF_CT_FTP_PASV,
+		IP_CT_FTP_PASV,
 		try_rfc959,
 	},
 	{
 		IP_CT_DIR_ORIGINAL,
 		"EPRT", sizeof("EPRT") - 1, ' ', '\r',
-		NF_CT_FTP_EPRT,
+		IP_CT_FTP_EPRT,
 		try_eprt,
 	},
 	{
 		IP_CT_DIR_REPLY,
 		"229 ", sizeof("229 ") - 1, '(', ')',
-		NF_CT_FTP_EPSV,
+		IP_CT_FTP_EPSV,
 		try_epsv_response,
 	},
 };
@@ -394,7 +394,7 @@
 }
 
 /* Look up to see if we're just after a \n. */
-static int find_nl_seq(u32 seq, const struct nf_ct_ftp_master *info, int dir)
+static int find_nl_seq(u32 seq, const struct ip_ct_ftp_master *info, int dir)
 {
 	unsigned int i;
 
@@ -405,7 +405,7 @@
 }
 
 /* We don't update if it's older than what we have. */
-static void update_nl_seq(u32 nl_seq, struct nf_ct_ftp_master *info, int dir)
+static void update_nl_seq(u32 nl_seq, struct ip_ct_ftp_master *info, int dir)
 {
 	unsigned int i, oldest = NUM_SEQ_TO_REMEMBER;
 
@@ -437,7 +437,7 @@
 	u32 seq;
 	int dir = CTINFO2DIR(ctinfo);
 	unsigned int matchlen, matchoff;
-	struct nf_ct_ftp_master *ct_ftp_info = &ct->help->ct_ftp_info;
+	struct ip_ct_ftp_master *ct_ftp_info = &ct->help->ct_ftp_info;
 	struct nf_conntrack_expect *exp;
 	struct nf_conntrack_man cmd = {};
 

----Next_Part(Tue_Mar_22_22:48:45_2005_409)----
