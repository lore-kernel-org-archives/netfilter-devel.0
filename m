From: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 3/8] Netfilter:  Use ct_extend for conntrack protocol helpers
Date: Thu, 13 Jan 2005 07:58:31 +1100
Message-ID: <1105563512.12794.10.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter development mailing list <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
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

Name: Use ct_extend for conntrack protocol helpers
Status: Tested under nfsim
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

Instead of a "union ip_conntrack_help" inside the conntrack structure,
we can use the ext field for the helpers.  In fact, only
ip_conntrack_ftp.c uses it inside the current tree.

Index: linux-2.6.10-bk14-Netfilter/net/ipv4/netfilter/ip_conntrack_ftp.c
===================================================================
--- linux-2.6.10-bk14-Netfilter.orig/net/ipv4/netfilter/ip_conntrack_ftp.c	2005-01-12 23:35:56.113259320 +1100
+++ linux-2.6.10-bk14-Netfilter/net/ipv4/netfilter/ip_conntrack_ftp.c	2005-01-12 23:40:34.633917744 +1100
@@ -19,6 +19,7 @@
 #include <linux/netfilter_ipv4/lockhelp.h>
 #include <linux/netfilter_ipv4/ip_conntrack_helper.h>
 #include <linux/netfilter_ipv4/ip_conntrack_ftp.h>
+#include <linux/netfilter_ipv4/ct_extend.h>
 #include <linux/moduleparam.h>
 
 MODULE_LICENSE("GPL");
@@ -28,8 +29,6 @@
 /* This is slow, but it's simple. --RR */
 static char ftp_buffer[65536];
 
-static DECLARE_LOCK(ip_ftp_lock);
-
 #define MAX_PORTS 8
 static int ports[MAX_PORTS];
 static int ports_c;
@@ -294,7 +293,7 @@
 	u32 seq, array[6] = { 0 };
 	int dir = CTINFO2DIR(ctinfo);
 	unsigned int matchlen, matchoff;
-	struct ip_ct_ftp_master *ct_ftp_info = &ct->help.ct_ftp_info;
+	struct ip_ct_ftp_master *ct_ftp_info;
 	struct ip_conntrack_expect *exp;
 	unsigned int i;
 	int found = 0, ends_in_nl;
@@ -319,7 +318,17 @@
 	}
 	datalen = (*pskb)->len - dataoff;
 
-	LOCK_BH(&ip_ftp_lock);
+	WRITE_LOCK(&ip_conntrack_lock);
+	ct_ftp_info = ct_extend_find(ct->ext, CTE_FTP_CONN);
+	if (!ct_ftp_info) {
+		ct_ftp_info = ct_extend_add(&ct->ext, CTE_FTP_CONN,GFP_ATOMIC);
+		if (!ct_ftp_info) {
+			ret = NF_DROP;
+			goto out;
+		}
+		memset(ct_ftp_info, 0, sizeof(*ct_ftp_info));
+	}
+
 	fb_ptr = skb_header_pointer(*pskb, dataoff,
 				    (*pskb)->len - dataoff, ftp_buffer);
 	BUG_ON(fb_ptr == NULL);
@@ -423,6 +432,9 @@
 	exp->expectfn = NULL;
 	exp->master = ct;
 
+	/* Drop lock around ip_conntrack_expect_related. */
+	WRITE_UNLOCK(&ip_conntrack_lock);
+
 	/* Now, NAT might want to mangle the packet, and register the
 	 * (possibly changed) expectation itself. */
 	if (ip_nat_ftp_hook)
@@ -437,19 +449,37 @@
 			ret = NF_ACCEPT;
 	}
 
+	WRITE_LOCK(&ip_conntrack_lock);
+	ct_ftp_info = ct_extend_find(ct->ext, CTE_FTP_CONN);
+
 out_update_nl:
 	/* Now if this ends in \n, update ftp info.  Seq may have been
 	 * adjusted by NAT code. */
 	if (ends_in_nl)
-		update_nl_seq(seq, ct_ftp_info,dir);
+		update_nl_seq(seq, ct_ftp_info, dir);
  out:
-	UNLOCK_BH(&ip_ftp_lock);
+	WRITE_UNLOCK(&ip_conntrack_lock);
 	return ret;
 }
 
 static struct ip_conntrack_helper ftp[MAX_PORTS];
 static char ftp_names[MAX_PORTS][10];
 
+static struct ct_extend_type ftp_extend =
+{
+	.len = sizeof(struct ip_ct_ftp_master),
+	.align = __alignof__(struct ip_ct_ftp_master),
+	.type = CTE_FTP_CONN,
+};
+
+/* Don't leave these lying around. */
+static int remove_ftp_ext(struct ip_conntrack *i, void *unused)
+{
+	if (i->ext)
+		i->ext = ct_extend_del(i->ext, CTE_FTP_CONN);
+	return 0;
+}
+
 /* Not __exit: called from init() */
 static void fini(void)
 {
@@ -459,6 +489,8 @@
 				ports[i]);
 		ip_conntrack_helper_unregister(&ftp[i]);
 	}
+	ip_ct_iterate_cleanup(remove_ftp_ext, NULL);
+	unregister_ct_extend_type(&ftp_extend);
 }
 
 static int __init init(void)
@@ -469,6 +501,8 @@
 	if (ports_c == 0)
 		ports[ports_c++] = FTP_PORT;
 
+	register_ct_extend_type(&ftp_extend);
+
 	for (i = 0; i < ports_c; i++) {
 		ftp[i].tuple.src.u.tcp.port = htons(ports[i]);
 		ftp[i].tuple.dst.protonum = IPPROTO_TCP;
Index: linux-2.6.10-bk14-Netfilter/include/linux/netfilter_ipv4/ip_conntrack.h
===================================================================
--- linux-2.6.10-bk14-Netfilter.orig/include/linux/netfilter_ipv4/ip_conntrack.h	2005-01-12 23:39:20.525183984 +1100
+++ linux-2.6.10-bk14-Netfilter/include/linux/netfilter_ipv4/ip_conntrack.h	2005-01-12 23:40:34.631918048 +1100
@@ -95,13 +95,6 @@
 #include <linux/netfilter_ipv4/ip_conntrack_ftp.h>
 #include <linux/netfilter_ipv4/ip_conntrack_irc.h>
 
-/* per conntrack: application helper private data */
-union ip_conntrack_help {
-	/* insert conntrack helper private data (master) here */
-	struct ip_ct_ftp_master ct_ftp_info;
-	struct ip_ct_irc_master ct_irc_info;
-};
-
 #ifdef CONFIG_IP_NF_NAT_NEEDED
 #include <linux/netfilter_ipv4/ip_nat.h>
 #endif
@@ -185,9 +178,7 @@
 	/* Storage reserved for other modules: */
 	union ip_conntrack_proto proto;
 
-	union ip_conntrack_help help;
-
-	/* Use for masqueraded connections: protected by ip_conntrack_lock */
+	/* Use for extra things: protected by ip_conntrack_lock */
 	struct ct_extend *ext;
 
 #ifdef CONFIG_IP_NF_NAT_NEEDED
Index: linux-2.6.10-bk14-Netfilter/include/linux/netfilter_ipv4/ct_extend.h
===================================================================
--- linux-2.6.10-bk14-Netfilter.orig/include/linux/netfilter_ipv4/ct_extend.h	2005-01-12 23:39:20.529183376 +1100
+++ linux-2.6.10-bk14-Netfilter/include/linux/netfilter_ipv4/ct_extend.h	2005-01-12 23:41:03.500529352 +1100
@@ -5,10 +5,12 @@
 enum ct_ext_type
 {
 	CTE_MASQ,
+	CTE_FTP_CONN,
 	CTE_MAX,
 } __attribute__((packed));
 
 #define CTE_MASQ_TYPE char 	/* Actually char[IFNAMSIZ] */
+#define CTE_FTP_CONN_TYPE struct ip_ct_ftp_master
 
 /* Extensions: optional stuff which isn't permanently in struct. */
 struct ct_extend {
