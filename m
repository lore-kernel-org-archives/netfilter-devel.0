From: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 3/3] Simplify expectations
Date: Wed, 05 Jan 2005 21:51:18 +1100
Message-ID: <1104922278.20582.106.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter development mailing list <netfilter-devel@lists.netfilter.org>
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

Name: Simplify expect handling
Status: Tested on 2.6.10-rc2-bk6
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

Now we've changed expect handling, we can simplify it significantly.

1) struct ip_conntrack_expect only exists until the connection
   matching it is created.  Now NAT is done directly at the time the
   expectation is matched, we don't need to keep this information
   around.

2) The term "master" is used everywhere to mean the connection that
   expected this connection.  The "master" field in the new connection
   points straight to the master connection, and holds a reference.

3) There is no direct link from the connection to the expectations it
   has created: we walk the global list to find them if we need to
   clean them up.  Each expectation holds a reference.

4) The ip_conntrack_expect_tuple_lock is now a proper subset of
   ip_conntrack_lock, so we can eliminate it.

5) Remove flags from helper: the policy of evicting the oldest
   expectation seems to be appropriate for everyone.

6) ip_conntrack_expect_find_get() and ip_conntrack_expect_put() are no
   longer required.

7) Remove reference count from expectations, and don't free when we
   fail ip_conntrack_expect_related(): have user call
   ip_conntrack_expect_free().

Index: linux-2.6.10-bk7-Netfilter/include/linux/netfilter_ipv4/ip_nat_helper.h
===================================================================
--- linux-2.6.10-bk7-Netfilter.orig/include/linux/netfilter_ipv4/ip_nat_helper.h	2005-01-05 21:24:56.964103872 +1100
+++ linux-2.6.10-bk7-Netfilter/include/linux/netfilter_ipv4/ip_nat_helper.h	2005-01-05 21:27:16.548883760 +1100
@@ -62,5 +62,6 @@
 
 /* Setup NAT on this expected conntrack so it follows master, but goes
  * to port ct->master->saved_proto. */
-extern void ip_nat_follow_master(struct ip_conntrack *ct);
+extern void ip_nat_follow_master(struct ip_conntrack *ct,
+				 struct ip_conntrack_expect *this);
 #endif
Index: linux-2.6.10-bk7-Netfilter/net/ipv4/netfilter/ip_nat_helper.c
===================================================================
--- linux-2.6.10-bk7-Netfilter.orig/net/ipv4/netfilter/ip_nat_helper.c	2005-01-05 21:24:56.964103872 +1100
+++ linux-2.6.10-bk7-Netfilter/net/ipv4/netfilter/ip_nat_helper.c	2005-01-05 21:27:16.548883760 +1100
@@ -439,14 +439,15 @@
 
 /* Setup NAT on this expected conntrack so it follows master. */
 /* If we fail to get a free NAT slot, we'll get dropped on confirm */
-void ip_nat_follow_master(struct ip_conntrack *ct)
+void ip_nat_follow_master(struct ip_conntrack *ct,
+			  struct ip_conntrack_expect *this)
 {
-	struct ip_nat_info *master = &ct->master->expectant->nat.info;
+	struct ip_nat_info *master = &ct->master->nat.info;
 
 	/* This must be a fresh one. */
 	BUG_ON(ct->nat.info.initialized);
 
-	ip_nat_copy_manip(master, ct->master, ct);
+	ip_nat_copy_manip(master, this, ct);
 }
 
 static inline int
Index: linux-2.6.10-bk7-Netfilter/net/ipv4/netfilter/ip_conntrack_standalone.c
===================================================================
--- linux-2.6.10-bk7-Netfilter.orig/net/ipv4/netfilter/ip_conntrack_standalone.c	2005-01-05 21:24:56.964103872 +1100
+++ linux-2.6.10-bk7-Netfilter/net/ipv4/netfilter/ip_conntrack_standalone.c	2005-01-05 21:43:15.988026840 +1100
@@ -200,7 +200,6 @@
 	/* strange seq_file api calls stop even if we fail,
 	 * thus we need to grab lock since stop unlocks */
 	READ_LOCK(&ip_conntrack_lock);
-	READ_LOCK(&ip_conntrack_expect_tuple_lock);
 
 	if (list_empty(e))
 		return NULL;
@@ -227,7 +226,6 @@
 
 static void exp_seq_stop(struct seq_file *s, void *v)
 {
-	READ_UNLOCK(&ip_conntrack_expect_tuple_lock);
 	READ_UNLOCK(&ip_conntrack_lock);
 }
 
@@ -235,14 +233,13 @@
 {
 	struct ip_conntrack_expect *expect = v;
 
-	if (expect->expectant->helper->timeout)
+	if (expect->timeout.function)
 		seq_printf(s, "%lu ", timer_pending(&expect->timeout)
 			   ? (expect->timeout.expires - jiffies)/HZ : 0);
 	else
 		seq_printf(s, "- ");
 
-	seq_printf(s, "use=%u proto=%u ", atomic_read(&expect->use),
-		   expect->tuple.dst.protonum);
+	seq_printf(s, "proto=%u ", expect->tuple.dst.protonum);
 
 	print_tuple(s, &expect->tuple,
 		    ip_ct_find_proto(expect->tuple.dst.protonum));
@@ -910,14 +907,12 @@
 EXPORT_SYMBOL(ip_ct_find_proto);
 EXPORT_SYMBOL(ip_ct_find_helper);
 EXPORT_SYMBOL(ip_conntrack_expect_alloc);
+EXPORT_SYMBOL(ip_conntrack_expect_free);
 EXPORT_SYMBOL(ip_conntrack_expect_related);
 EXPORT_SYMBOL(ip_conntrack_unexpect_related);
-EXPORT_SYMBOL_GPL(ip_conntrack_expect_find_get);
-EXPORT_SYMBOL_GPL(ip_conntrack_expect_put);
 EXPORT_SYMBOL(ip_conntrack_tuple_taken);
 EXPORT_SYMBOL(ip_ct_gather_frags);
 EXPORT_SYMBOL(ip_conntrack_htable_size);
-EXPORT_SYMBOL(ip_conntrack_expect_list);
 EXPORT_SYMBOL(ip_conntrack_lock);
 EXPORT_SYMBOL(ip_conntrack_hash);
 EXPORT_SYMBOL(ip_conntrack_untracked);
Index: linux-2.6.10-bk7-Netfilter/net/ipv4/netfilter/ip_conntrack_amanda.c
===================================================================
--- linux-2.6.10-bk7-Netfilter.orig/net/ipv4/netfilter/ip_conntrack_amanda.c	2005-01-05 21:24:56.964103872 +1100
+++ linux-2.6.10-bk7-Netfilter/net/ipv4/netfilter/ip_conntrack_amanda.c	2005-01-05 21:27:16.547883912 +1100
@@ -45,7 +45,6 @@
 static DECLARE_LOCK(amanda_buffer_lock);
 
 unsigned int (*ip_nat_amanda_hook)(struct sk_buff **pskb,
-				   struct ip_conntrack *ct,
 				   enum ip_conntrack_info ctinfo,
 				   unsigned int matchoff,
 				   unsigned int matchlen,
@@ -110,6 +109,7 @@
 		}
 
 		exp->expectfn = NULL;
+		exp->master = ct;
 
 		exp->tuple.src.ip = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip;
 		exp->tuple.src.u.tcp.port = 0;
@@ -124,11 +124,13 @@
 		exp->mask.dst.u.tcp.port = 0xFFFF;
 
 		if (ip_nat_amanda_hook)
-			ret = ip_nat_amanda_hook(pskb, ct, ctinfo,
+			ret = ip_nat_amanda_hook(pskb, ctinfo,
 						 tmp - amanda_buffer,
 						 len, exp);
-		else if (ip_conntrack_expect_related(exp, ct) != 0)
+		else if (ip_conntrack_expect_related(exp) != 0) {
+			ip_conntrack_expect_free(exp);
 			ret = NF_DROP;
+		}
 	}
 
 out:
Index: linux-2.6.10-bk7-Netfilter/net/ipv4/netfilter/ip_nat_ftp.c
===================================================================
--- linux-2.6.10-bk7-Netfilter.orig/net/ipv4/netfilter/ip_nat_ftp.c	2005-01-05 21:24:56.964103872 +1100
+++ linux-2.6.10-bk7-Netfilter/net/ipv4/netfilter/ip_nat_ftp.c	2005-01-05 21:27:16.548883760 +1100
@@ -103,7 +103,6 @@
 /* So, this packet has hit the connection tracking matching code.
    Mangle it, and change the expectation to match the new version. */
 static unsigned int ip_nat_ftp(struct sk_buff **pskb,
-			       struct ip_conntrack *ct,
 			       enum ip_conntrack_info ctinfo,
 			       enum ip_ct_ftp_type type,
 			       unsigned int matchoff,
@@ -114,6 +113,7 @@
 	u_int32_t newip;
 	u_int16_t port;
 	int dir = CTINFO2DIR(ctinfo);
+	struct ip_conntrack *ct = exp->master;
 
 	DEBUGP("FTP_NAT: type %i, off %u len %u\n", type, matchoff, matchlen);
 
@@ -128,17 +128,13 @@
 
 	/* Try to get same port: if not, try to change it. */
 	for (port = ntohs(exp->saved_proto.tcp.port); port != 0; port++) {
-		int err;
 		exp->tuple.dst.u.tcp.port = htons(port);
-		atomic_inc(&exp->use);
-		err = ip_conntrack_expect_related(exp, ct);
-		/* Success, or retransmit. */
-		if (!err || err == -EEXIST)
+		if (ip_conntrack_expect_related(exp) == 0)
 			break;
 	}
 
 	if (port == 0) {
-		ip_conntrack_expect_put(exp);
+		ip_conntrack_expect_free(exp);
 		return NF_DROP;
 	}
 
Index: linux-2.6.10-bk7-Netfilter/include/linux/netfilter_ipv4/ip_conntrack.h
===================================================================
--- linux-2.6.10-bk7-Netfilter.orig/include/linux/netfilter_ipv4/ip_conntrack.h	2005-01-05 21:24:56.964103872 +1100
+++ linux-2.6.10-bk7-Netfilter/include/linux/netfilter_ipv4/ip_conntrack.h	2005-01-05 21:27:16.550883456 +1100
@@ -107,33 +107,19 @@
 	/* Internal linked list (global expectation list) */
 	struct list_head list;
 
-	/* reference count */
-	atomic_t use;
-
-	/* expectation list for this master */
-	struct list_head expected_list;
+	/* We expect this tuple, with the following mask */
+	struct ip_conntrack_tuple tuple, mask;
+ 
+	/* Function to call after setup and insertion */
+	void (*expectfn)(struct ip_conntrack *new,
+			 struct ip_conntrack_expect *this);
 
 	/* The conntrack of the master connection */
-	struct ip_conntrack *expectant;
-
-	/* The conntrack of the sibling connection, set after
-	 * expectation arrived */
-	struct ip_conntrack *sibling;
-
-	/* Tuple saved for conntrack */
-	struct ip_conntrack_tuple ct_tuple;
+	struct ip_conntrack *master;
 
 	/* Timer function; deletes the expectation. */
 	struct timer_list timeout;
 
-	/* Data filled out by the conntrack helpers follow: */
-
-	/* We expect this tuple, with the following mask */
-	struct ip_conntrack_tuple tuple, mask;
-
-	/* Function to call after setup and insertion */
-	void (*expectfn)(struct ip_conntrack *new);
-
 #ifdef CONFIG_IP_NF_NAT_NEEDED
 	/* This is the original per-proto part, used to map the
 	 * expected connection the way the recipient expects. */
@@ -141,8 +127,6 @@
 	/* Direction relative to the master connection. */
 	enum ip_conntrack_dir dir;
 #endif
-
-	union ip_conntrack_expect_proto proto;
 };
 
 struct ip_conntrack_counter
@@ -169,17 +153,12 @@
 	/* Accounting Information (same cache line as other written members) */
 	struct ip_conntrack_counter counters[IP_CT_DIR_MAX];
 #endif
+	/* If we were expected by an expectation, this will be it */
+	struct ip_conntrack *master;
 
-	/* If we're expecting another related connection, this will be
-           in expected linked list */
-	struct list_head sibling_list;
-	
 	/* Current number of expected connections */
 	unsigned int expecting;
 
-	/* If we were expected by an expectation, this will be it */
-	struct ip_conntrack_expect *master;
-
 	/* Helper, if any. */
 	struct ip_conntrack_helper *helper;
 
@@ -209,7 +188,7 @@
 };
 
 /* get master conntrack via master expectation */
-#define master_ct(conntr) (conntr->master ? conntr->master->expectant : NULL)
+#define master_ct(conntr) (conntr->master)
 
 /* Alter reply tuple (maybe alter helper). */
 extern void
@@ -233,13 +212,6 @@
 /* decrement reference count on a conntrack */
 extern inline void ip_conntrack_put(struct ip_conntrack *ct);
 
-/* find unconfirmed expectation based on tuple */
-struct ip_conntrack_expect *
-ip_conntrack_expect_find_get(const struct ip_conntrack_tuple *tuple);
-
-/* decrement reference count on an expectation */
-void ip_conntrack_expect_put(struct ip_conntrack_expect *exp);
-
 /* call to create an explicit dependency on ip_conntrack. */
 extern void need_ip_conntrack(void);
 
Index: linux-2.6.10-bk7-Netfilter/net/ipv4/netfilter/ip_nat_amanda.c
===================================================================
--- linux-2.6.10-bk7-Netfilter.orig/net/ipv4/netfilter/ip_nat_amanda.c	2005-01-05 21:24:56.965103720 +1100
+++ linux-2.6.10-bk7-Netfilter/net/ipv4/netfilter/ip_nat_amanda.c	2005-01-05 21:27:16.549883608 +1100
@@ -32,7 +32,6 @@
 MODULE_LICENSE("GPL");
 
 static unsigned int help(struct sk_buff **pskb,
-			 struct ip_conntrack *ct,
 			 enum ip_conntrack_info ctinfo,
 			 unsigned int matchoff,
 			 unsigned int matchlen,
@@ -52,22 +51,18 @@
 
 	/* Try to get same port: if not, try to change it. */
 	for (port = ntohs(exp->saved_proto.tcp.port); port != 0; port++) {
-		int err;
 		exp->tuple.dst.u.tcp.port = htons(port);
-		atomic_inc(&exp->use);
-		err = ip_conntrack_expect_related(exp, ct);
-		/* Success, or retransmit. */
-		if (!err || err == -EEXIST)
+		if (ip_conntrack_expect_related(exp) == 0)
 			break;
 	}
 
 	if (port == 0) {
-		ip_conntrack_expect_put(exp);
+		ip_conntrack_expect_free(exp);
 		return NF_DROP;
 	}
 
 	sprintf(buffer, "%u", port);
-	ret = ip_nat_mangle_udp_packet(pskb, ct, ctinfo,
+	ret = ip_nat_mangle_udp_packet(pskb, exp->master, ctinfo,
 				       matchoff, matchlen,
 				       buffer, strlen(buffer));
 	if (ret != NF_ACCEPT)
Index: linux-2.6.10-bk7-Netfilter/net/ipv4/netfilter/ip_conntrack_ftp.c
===================================================================
--- linux-2.6.10-bk7-Netfilter.orig/net/ipv4/netfilter/ip_conntrack_ftp.c	2005-01-05 21:24:56.965103720 +1100
+++ linux-2.6.10-bk7-Netfilter/net/ipv4/netfilter/ip_conntrack_ftp.c	2005-01-05 21:27:16.549883608 +1100
@@ -40,7 +40,6 @@
 module_param(loose, int, 0600);
 
 unsigned int (*ip_nat_ftp_hook)(struct sk_buff **pskb,
-				struct ip_conntrack *ct,
 				enum ip_conntrack_info ctinfo,
 				enum ip_ct_ftp_type type,
 				unsigned int matchoff,
@@ -407,7 +406,7 @@
 		   networks, or the packet filter itself). */
 		if (!loose) {
 			ret = NF_ACCEPT;
-			ip_conntrack_expect_put(exp);
+			ip_conntrack_expect_free(exp);
 			goto out_update_nl;
 		}
 		exp->tuple.dst.ip = htonl((array[0] << 24) | (array[1] << 16)
@@ -423,17 +422,19 @@
 		  { 0xFFFFFFFF, { .tcp = { 0xFFFF } }, 0xFFFF }});
 
 	exp->expectfn = NULL;
+	exp->master = ct;
 
 	/* Now, NAT might want to mangle the packet, and register the
 	 * (possibly changed) expectation itself. */
 	if (ip_nat_ftp_hook)
-		ret = ip_nat_ftp_hook(pskb, ct, ctinfo, search[i].ftptype,
+		ret = ip_nat_ftp_hook(pskb, ctinfo, search[i].ftptype,
 				      matchoff, matchlen, exp, &seq);
 	else {
 		/* Can't expect this?  Best to drop packet now. */
-		if (ip_conntrack_expect_related(exp, ct) != 0)
+		if (ip_conntrack_expect_related(exp) != 0) {
+			ip_conntrack_expect_free(exp);
 			ret = NF_DROP;
-		else
+		} else
 			ret = NF_ACCEPT;
 	}
 
@@ -476,7 +477,6 @@
 		ftp[i].mask.dst.protonum = 0xFFFF;
 		ftp[i].max_expected = 1;
 		ftp[i].timeout = 0;
-		ftp[i].flags = IP_CT_HELPER_F_REUSE_EXPECT;
 		ftp[i].me = ip_conntrack_ftp;
 		ftp[i].help = help;
 
Index: linux-2.6.10-bk7-Netfilter/net/ipv4/netfilter/ip_conntrack_tftp.c
===================================================================
--- linux-2.6.10-bk7-Netfilter.orig/net/ipv4/netfilter/ip_conntrack_tftp.c	2005-01-05 21:24:56.965103720 +1100
+++ linux-2.6.10-bk7-Netfilter/net/ipv4/netfilter/ip_conntrack_tftp.c	2005-01-05 21:27:16.549883608 +1100
@@ -39,7 +39,6 @@
 #endif
 
 unsigned int (*ip_nat_tftp_hook)(struct sk_buff **pskb,
-				 struct ip_conntrack *ct,
 				 enum ip_conntrack_info ctinfo,
 				 struct ip_conntrack_expect *exp);
 EXPORT_SYMBOL_GPL(ip_nat_tftp_hook);
@@ -76,14 +75,17 @@
 		exp->mask.dst.u.udp.port = 0xffff;
 		exp->mask.dst.protonum = 0xffff;
 		exp->expectfn = NULL;
+		exp->master = ct;
 
 		DEBUGP("expect: ");
 		DUMP_TUPLE(&exp->tuple);
 		DUMP_TUPLE(&exp->mask);
 		if (ip_nat_tftp_hook)
-			ret = ip_nat_tftp_hook(pskb, ct, ctinfo, exp);
-		else if (ip_conntrack_expect_related(exp, ct) != 0)
+			ret = ip_nat_tftp_hook(pskb, ctinfo, exp);
+		else if (ip_conntrack_expect_related(exp) != 0) {
+			ip_conntrack_expect_free(exp);
 			ret = NF_DROP;
+		}
 		break;
 	case TFTP_OPCODE_DATA:
 	case TFTP_OPCODE_ACK:
Index: linux-2.6.10-bk7-Netfilter/include/linux/netfilter_ipv4/ip_conntrack_ftp.h
===================================================================
--- linux-2.6.10-bk7-Netfilter.orig/include/linux/netfilter_ipv4/ip_conntrack_ftp.h	2005-01-05 21:24:56.964103872 +1100
+++ linux-2.6.10-bk7-Netfilter/include/linux/netfilter_ipv4/ip_conntrack_ftp.h	2005-01-05 21:27:16.550883456 +1100
@@ -34,7 +34,6 @@
 /* For NAT to hook in when we find a packet which describes what other
  * connection we should expect. */
 extern unsigned int (*ip_nat_ftp_hook)(struct sk_buff **pskb,
-				       struct ip_conntrack *ct,
 				       enum ip_conntrack_info ctinfo,
 				       enum ip_ct_ftp_type type,
 				       unsigned int matchoff,
Index: linux-2.6.10-bk7-Netfilter/net/ipv4/netfilter/ip_nat_tftp.c
===================================================================
--- linux-2.6.10-bk7-Netfilter.orig/net/ipv4/netfilter/ip_nat_tftp.c	2005-01-05 21:27:06.988337184 +1100
+++ linux-2.6.10-bk7-Netfilter/net/ipv4/netfilter/ip_nat_tftp.c	2005-01-05 21:27:31.201656200 +1100
@@ -46,7 +46,7 @@
 	exp->dir = IP_CT_DIR_REPLY;
 	exp->expectfn = ip_nat_follow_master;
 	if (ip_conntrack_expect_related(exp) != 0) {
-		ip_conntrack_expect_put(exp);
+		ip_conntrack_expect_free(exp);
 		return NF_DROP;
 	}
 	return NF_ACCEPT;
Index: linux-2.6.10-bk7-Netfilter/net/ipv4/netfilter/ipt_helper.c
===================================================================
--- linux-2.6.10-bk7-Netfilter.orig/net/ipv4/netfilter/ipt_helper.c	2005-01-05 21:24:56.965103720 +1100
+++ linux-2.6.10-bk7-Netfilter/net/ipv4/netfilter/ipt_helper.c	2005-01-05 21:27:16.550883456 +1100
@@ -38,7 +38,6 @@
       int *hotdrop)
 {
 	const struct ipt_helper_info *info = matchinfo;
-	struct ip_conntrack_expect *exp;
 	struct ip_conntrack *ct;
 	enum ip_conntrack_info ctinfo;
 	int ret = info->invert;
@@ -54,28 +53,21 @@
 		return ret;
 	}
 
-	exp = ct->master;
 	READ_LOCK(&ip_conntrack_lock);
-	if (!exp->expectant) {
-		DEBUGP("ipt_helper: expectation %p without expectant !?!\n", 
-			exp);
-		goto out_unlock;
-	}
-
-	if (!exp->expectant->helper) {
+	if (!ct->master->helper) {
 		DEBUGP("ipt_helper: master ct %p has no helper\n", 
 			exp->expectant);
 		goto out_unlock;
 	}
 
 	DEBUGP("master's name = %s , info->name = %s\n", 
-		exp->expectant->helper->name, info->name);
+		ct->master->helper->name, info->name);
 
 	if (info->name[0] == '\0')
 		ret ^= 1;
 	else
-		ret ^= !strncmp(exp->expectant->helper->name, info->name, 
-		                strlen(exp->expectant->helper->name));
+		ret ^= !strncmp(ct->master->helper->name, info->name, 
+		                strlen(ct->master->helper->name));
 out_unlock:
 	READ_UNLOCK(&ip_conntrack_lock);
 	return ret;
Index: linux-2.6.10-bk7-Netfilter/net/ipv4/netfilter/ip_nat_irc.c
===================================================================
--- linux-2.6.10-bk7-Netfilter.orig/net/ipv4/netfilter/ip_nat_irc.c	2005-01-05 21:24:56.965103720 +1100
+++ linux-2.6.10-bk7-Netfilter/net/ipv4/netfilter/ip_nat_irc.c	2005-01-05 21:27:16.550883456 +1100
@@ -37,7 +37,6 @@
 /* FIXME: Time out? --RR */
 
 static unsigned int help(struct sk_buff **pskb,
-			 struct ip_conntrack *ct,
 			 enum ip_conntrack_info ctinfo,
 			 unsigned int matchoff,
 			 unsigned int matchlen,
@@ -63,18 +62,13 @@
 
 	/* Try to get same port: if not, try to change it. */
 	for (port = ntohs(exp->saved_proto.tcp.port); port != 0; port++) {
-		int err;
-
 		exp->tuple.dst.u.tcp.port = htons(port);
-		atomic_inc(&exp->use);
-		err = ip_conntrack_expect_related(exp, ct);
-		/* Success, or retransmit. */
-		if (!err || err == -EEXIST)
+		if (ip_conntrack_expect_related(exp) == 0)
 			break;
 	}
 
 	if (port == 0) {
-		ip_conntrack_expect_put(exp);
+		ip_conntrack_expect_free(exp);
 		return NF_DROP;
 	}
 
@@ -95,7 +89,7 @@
 	DEBUGP("ip_nat_irc: Inserting '%s' == %u.%u.%u.%u, port %u\n",
 	       buffer, NIPQUAD(exp->tuple.src.ip), port);
 
-	ret = ip_nat_mangle_tcp_packet(pskb, ct, ctinfo, 
+	ret = ip_nat_mangle_tcp_packet(pskb, exp->master, ctinfo, 
 				       matchoff, matchlen, buffer, 
 				       strlen(buffer));
 	if (ret != NF_ACCEPT)
Index: linux-2.6.10-bk7-Netfilter/include/linux/netfilter_ipv4/ip_conntrack_tftp.h
===================================================================
--- linux-2.6.10-bk7-Netfilter.orig/include/linux/netfilter_ipv4/ip_conntrack_tftp.h	2005-01-05 21:24:56.964103872 +1100
+++ linux-2.6.10-bk7-Netfilter/include/linux/netfilter_ipv4/ip_conntrack_tftp.h	2005-01-05 21:27:16.551883304 +1100
@@ -14,7 +14,6 @@
 #define TFTP_OPCODE_ERROR	5
 
 unsigned int (*ip_nat_tftp_hook)(struct sk_buff **pskb,
-				 struct ip_conntrack *ct,
 				 enum ip_conntrack_info ctinfo,
 				 struct ip_conntrack_expect *exp);
 
Index: linux-2.6.10-bk7-Netfilter/net/ipv4/netfilter/ip_conntrack_irc.c
===================================================================
--- linux-2.6.10-bk7-Netfilter.orig/net/ipv4/netfilter/ip_conntrack_irc.c	2005-01-05 21:24:56.965103720 +1100
+++ linux-2.6.10-bk7-Netfilter/net/ipv4/netfilter/ip_conntrack_irc.c	2005-01-05 21:27:16.551883304 +1100
@@ -44,7 +44,6 @@
 static DECLARE_LOCK(irc_buffer_lock);
 
 unsigned int (*ip_nat_irc_hook)(struct sk_buff **pskb,
-				struct ip_conntrack *ct,
 				enum ip_conntrack_info ctinfo,
 				unsigned int matchoff,
 				unsigned int matchlen,
@@ -220,13 +219,16 @@
 				{ { 0, { 0 } },
 				  { 0xFFFFFFFF, { .tcp = { 0xFFFF } }, 0xFFFF }});
 			exp->expectfn = NULL;
+			exp->master = ct;
 			if (ip_nat_irc_hook)
-				ret = ip_nat_irc_hook(pskb, ct, ctinfo, 
+				ret = ip_nat_irc_hook(pskb, ctinfo, 
 						      addr_beg_p - ib_ptr,
 						      addr_end_p - addr_beg_p,
 						      exp);
-			else if (ip_conntrack_expect_related(exp, ct) != 0)
+			else if (ip_conntrack_expect_related(exp) != 0) {
+				ip_conntrack_expect_free(exp);
 				ret = NF_DROP;
+			}
 			goto out;
 		} /* for .. NUM_DCCPROTO */
 	} /* while data < ... */
Index: linux-2.6.10-bk7-Netfilter/include/linux/netfilter_ipv4/ip_conntrack_irc.h
===================================================================
--- linux-2.6.10-bk7-Netfilter.orig/include/linux/netfilter_ipv4/ip_conntrack_irc.h	2005-01-05 21:24:56.964103872 +1100
+++ linux-2.6.10-bk7-Netfilter/include/linux/netfilter_ipv4/ip_conntrack_irc.h	2005-01-05 21:27:16.551883304 +1100
@@ -20,7 +20,6 @@
 
 #ifdef __KERNEL__
 extern unsigned int (*ip_nat_irc_hook)(struct sk_buff **pskb,
-				       struct ip_conntrack *ct,
 				       enum ip_conntrack_info ctinfo,
 				       unsigned int matchoff,
 				       unsigned int matchlen,
Index: linux-2.6.10-bk7-Netfilter/include/linux/netfilter_ipv4/ip_conntrack_core.h
===================================================================
--- linux-2.6.10-bk7-Netfilter.orig/include/linux/netfilter_ipv4/ip_conntrack_core.h	2005-01-05 21:24:56.964103872 +1100
+++ linux-2.6.10-bk7-Netfilter/include/linux/netfilter_ipv4/ip_conntrack_core.h	2005-01-05 21:27:16.553883000 +1100
@@ -48,6 +48,5 @@
 extern struct list_head *ip_conntrack_hash;
 extern struct list_head ip_conntrack_expect_list;
 DECLARE_RWLOCK_EXTERN(ip_conntrack_lock);
-DECLARE_RWLOCK_EXTERN(ip_conntrack_expect_tuple_lock);
 #endif /* _IP_CONNTRACK_CORE_H */
 
Index: linux-2.6.10-bk7-Netfilter/include/linux/netfilter_ipv4/ip_conntrack_helper.h
===================================================================
--- linux-2.6.10-bk7-Netfilter.orig/include/linux/netfilter_ipv4/ip_conntrack_helper.h	2005-01-05 21:24:56.964103872 +1100
+++ linux-2.6.10-bk7-Netfilter/include/linux/netfilter_ipv4/ip_conntrack_helper.h	2005-01-05 21:27:16.553883000 +1100
@@ -5,15 +5,11 @@
 
 struct module;
 
-/* Reuse expectation when max_expected reached */
-#define IP_CT_HELPER_F_REUSE_EXPECT	0x01
-
 struct ip_conntrack_helper
 {	
 	struct list_head list; 		/* Internal use. */
 
 	const char *name;		/* name of the module */
-	unsigned char flags;		/* Flags (see above) */
 	struct module *me;		/* pointer to self */
 	unsigned int max_expected;	/* Maximum number of concurrent 
 					 * expected connections */
@@ -39,9 +35,10 @@
 /* Allocate space for an expectation: this is mandatory before calling 
    ip_conntrack_expect_related. */
 extern struct ip_conntrack_expect *ip_conntrack_expect_alloc(void);
+extern void ip_conntrack_expect_free(struct ip_conntrack_expect *exp);
+
 /* Add an expected connection: can have more than one per connection */
-extern int ip_conntrack_expect_related(struct ip_conntrack_expect *exp,
-				       struct ip_conntrack *related_to);
+extern int ip_conntrack_expect_related(struct ip_conntrack_expect *exp);
 extern void ip_conntrack_unexpect_related(struct ip_conntrack_expect *exp);
 
 #endif /*_IP_CONNTRACK_HELPER_H*/
Index: linux-2.6.10-bk7-Netfilter/include/linux/netfilter_ipv4/ip_conntrack_amanda.h
===================================================================
--- linux-2.6.10-bk7-Netfilter.orig/include/linux/netfilter_ipv4/ip_conntrack_amanda.h	2005-01-05 21:24:56.964103872 +1100
+++ linux-2.6.10-bk7-Netfilter/include/linux/netfilter_ipv4/ip_conntrack_amanda.h	2005-01-05 21:27:16.553883000 +1100
@@ -4,7 +4,6 @@
 
 struct ip_conntrack_expect;
 extern unsigned int (*ip_nat_amanda_hook)(struct sk_buff **pskb,
-					  struct ip_conntrack *ct,
 					  enum ip_conntrack_info ctinfo,
 					  unsigned int matchoff,
 					  unsigned int matchlen,
Index: linux-2.6.10-bk7-Netfilter/net/ipv4/netfilter/ip_conntrack_core.c
===================================================================
--- linux-2.6.10-bk7-Netfilter.orig/net/ipv4/netfilter/ip_conntrack_core.c	2005-01-05 21:24:56.965103720 +1100
+++ linux-2.6.10-bk7-Netfilter/net/ipv4/netfilter/ip_conntrack_core.c	2005-01-05 21:27:16.553883000 +1100
@@ -58,7 +58,6 @@
 #endif
 
 DECLARE_RWLOCK(ip_conntrack_lock);
-DECLARE_RWLOCK(ip_conntrack_expect_tuple_lock);
 
 /* ip_conntrack_standalone needs this */
 atomic_t ip_conntrack_count = ATOMIC_INIT(0);
@@ -136,129 +135,70 @@
 
 
 /* ip_conntrack_expect helper functions */
-
-/* Compare tuple parts depending on mask. */
-static inline int expect_cmp(const struct ip_conntrack_expect *i,
-			     const struct ip_conntrack_tuple *tuple)
+static void destroy_expect(struct ip_conntrack_expect *exp)
 {
-	MUST_BE_READ_LOCKED(&ip_conntrack_expect_tuple_lock);
-	return ip_ct_tuple_mask_cmp(tuple, &i->tuple, &i->mask);
-}
-
-static void
-destroy_expect(struct ip_conntrack_expect *exp)
-{
-	DEBUGP("destroy_expect(%p) use=%d\n", exp, atomic_read(&exp->use));
-	IP_NF_ASSERT(atomic_read(&exp->use) == 0);
+	ip_conntrack_put(exp->master);
 	IP_NF_ASSERT(!timer_pending(&exp->timeout));
-
 	kmem_cache_free(ip_conntrack_expect_cachep, exp);
 	CONNTRACK_STAT_INC(expect_delete);
 }
 
-inline void ip_conntrack_expect_put(struct ip_conntrack_expect *exp)
-{
-	IP_NF_ASSERT(exp);
-
-	if (atomic_dec_and_test(&exp->use)) {
-		/* usage count dropped to zero */
-		destroy_expect(exp);
-	}
-}
-
-static inline struct ip_conntrack_expect *
-__ip_ct_expect_find(const struct ip_conntrack_tuple *tuple)
+static void unlink_expect(struct ip_conntrack_expect *exp)
 {
-	MUST_BE_READ_LOCKED(&ip_conntrack_lock);
-	MUST_BE_READ_LOCKED(&ip_conntrack_expect_tuple_lock);
-	return LIST_FIND(&ip_conntrack_expect_list, expect_cmp, 
-			 struct ip_conntrack_expect *, tuple);
+	MUST_BE_WRITE_LOCKED(&ip_conntrack_lock);
+	list_del(&exp->list);
+	/* Logically in destroy_expect, but we hold the lock here. */
+	exp->master->expecting--;
 }
 
-/* Find a expectation corresponding to a tuple. */
-struct ip_conntrack_expect *
-ip_conntrack_expect_find_get(const struct ip_conntrack_tuple *tuple)
+static void expectation_timed_out(unsigned long ul_expect)
 {
-	struct ip_conntrack_expect *exp;
+	struct ip_conntrack_expect *exp = (void *)ul_expect;
 
-	READ_LOCK(&ip_conntrack_lock);
-	READ_LOCK(&ip_conntrack_expect_tuple_lock);
-	exp = __ip_ct_expect_find(tuple);
-	if (exp)
-		atomic_inc(&exp->use);
-	READ_UNLOCK(&ip_conntrack_expect_tuple_lock);
-	READ_UNLOCK(&ip_conntrack_lock);
-
-	return exp;
+	WRITE_LOCK(&ip_conntrack_lock);
+	unlink_expect(exp);
+	WRITE_UNLOCK(&ip_conntrack_lock);
+	destroy_expect(exp);
 }
 
-/* remove one specific expectation from all lists and drop refcount,
- * does _NOT_ delete the timer. */
-static void __unexpect_related(struct ip_conntrack_expect *expect)
+/* If an expectation for this connection is found, it gets delete from
+ * global list then returned. */
+static struct ip_conntrack_expect *
+find_expectation(const struct ip_conntrack_tuple *tuple)
 {
-	DEBUGP("unexpect_related(%p)\n", expect);
-	MUST_BE_WRITE_LOCKED(&ip_conntrack_lock);
-
-	/* we're not allowed to unexpect a confirmed expectation! */
-	IP_NF_ASSERT(!expect->sibling);
-
-	/* delete from global and local lists */
-	list_del(&expect->list);
-	list_del(&expect->expected_list);
-
-	/* decrement expect-count of master conntrack */
-	if (expect->expectant)
-		expect->expectant->expecting--;
-
-	ip_conntrack_expect_put(expect);
-}
-
-/* remove one specific expecatation from all lists, drop refcount
- * and expire timer. 
- * This function can _NOT_ be called for confirmed expects! */
-static void unexpect_related(struct ip_conntrack_expect *expect)
-{
-	IP_NF_ASSERT(expect->expectant);
-	IP_NF_ASSERT(expect->expectant->helper);
-	/* if we are supposed to have a timer, but we can't delete
-	 * it: race condition.  __unexpect_related will
-	 * be calledd by timeout function */
-	if (expect->expectant->helper->timeout
-	    && !del_timer(&expect->timeout))
-		return;
+	struct ip_conntrack_expect *i;
 
-	__unexpect_related(expect);
+	list_for_each_entry(i, &ip_conntrack_expect_list, list) {
+		/* If master is not in hash table yet (ie. packet hasn't left
+		   this machine yet), how can other end know about expected?
+		   Hence these are not the droids you are looking for (if
+		   master ct never got confirmed, we'd hold a reference to it
+		   and weird things would happen to future packets). */
+		if (ip_ct_tuple_mask_cmp(tuple, &i->tuple, &i->mask)
+		    && is_confirmed(i->master)
+		    && (!i->timeout.function || del_timer(&i->timeout))) {
+			unlink_expect(i);
+			return i;
+		}
+	}
+	return NULL;
 }
 
-/* delete all unconfirmed expectations for this conntrack */
-static void remove_expectations(struct ip_conntrack *ct, int drop_refcount)
+/* delete all expectations for this conntrack */
+static void remove_expectations(struct ip_conntrack *ct)
 {
-	struct list_head *exp_entry, *next;
-	struct ip_conntrack_expect *exp;
+	struct ip_conntrack_expect *i, *tmp;
 
-	DEBUGP("remove_expectations(%p)\n", ct);
+	/* Optimization: most connection never expect any others. */
+	if (ct->expecting == 0)
+		return;
 
-	list_for_each_safe(exp_entry, next, &ct->sibling_list) {
-		exp = list_entry(exp_entry, struct ip_conntrack_expect,
-				 expected_list);
-
-		/* we skip established expectations, as we want to delete
-		 * the un-established ones only */
-		if (exp->sibling) {
-			DEBUGP("remove_expectations: skipping established %p of %p\n", exp->sibling, ct);
-			if (drop_refcount) {
-				/* Indicate that this expectations parent is dead */
-				ip_conntrack_put(exp->expectant);
-				exp->expectant = NULL;
-			}
-			continue;
+	list_for_each_entry_safe(i, tmp, &ip_conntrack_expect_list, list) {
+		if (i->master == ct
+		    && (!i->timeout.function || del_timer(&i->timeout))) {
+			unlink_expect(i);
+			destroy_expect(i);
 		}
-
-		IP_NF_ASSERT(list_inlist(&ip_conntrack_expect_list, exp));
-		IP_NF_ASSERT(exp->expectant == ct);
-
-		/* delete expectation from global and private lists */
-		unexpect_related(exp);
 	}
 }
 
@@ -275,14 +215,14 @@
 	LIST_DELETE(&ip_conntrack_hash[ho], &ct->tuplehash[IP_CT_DIR_ORIGINAL]);
 	LIST_DELETE(&ip_conntrack_hash[hr], &ct->tuplehash[IP_CT_DIR_REPLY]);
 
-	/* Destroy all un-established, pending expectations */
-	remove_expectations(ct, 1);
+	/* Destroy all pending expectations */
+	remove_expectations(ct);
 }
 
 static void
 destroy_conntrack(struct nf_conntrack *nfct)
 {
-	struct ip_conntrack *ct = (struct ip_conntrack *)nfct, *master = NULL;
+	struct ip_conntrack *ct = (struct ip_conntrack *)nfct;
 	struct ip_conntrack_protocol *proto;
 
 	DEBUGP("destroy_conntrack(%p)\n", ct);
@@ -304,8 +244,7 @@
 	 * except TFTP can create an expectation on the first packet,
 	 * before connection is in the list, so we need to clean here,
 	 * too. */
-	if (ct->expecting)
-		remove_expectations(ct, 1);
+	remove_expectations(ct);
 
 	/* We overload first tuple to link into unconfirmed list. */
 	if (!is_confirmed(ct)) {
@@ -313,21 +252,11 @@
 		list_del(&ct->tuplehash[IP_CT_DIR_ORIGINAL].list);
 	}
 
-	/* Delete our master expectation */
-	if (ct->master) {
-		if (ct->master->expectant) {
-			/* can't call __unexpect_related here,
-			 * since it would screw up expect_list */
-			list_del(&ct->master->expected_list);
-			master = ct->master->expectant;
-		}
-		kmem_cache_free(ip_conntrack_expect_cachep, ct->master);
-	}
 	CONNTRACK_STAT_INC(delete);
 	WRITE_UNLOCK(&ip_conntrack_lock);
 
-	if (master)
-		ip_conntrack_put(master);
+	if (ct->master)
+		ip_conntrack_put(ct->master);
 
 	DEBUGP("destroy_conntrack: returning ct=%p to slab\n", ct);
 	kmem_cache_free(ip_conntrack_cachep, ct);
@@ -529,7 +458,7 @@
 	struct ip_conntrack *conntrack;
 	struct ip_conntrack_tuple repl_tuple;
 	size_t hash;
-	struct ip_conntrack_expect *expected;
+	struct ip_conntrack_expect *exp;
 
 	if (!ip_conntrack_hash_rnd_initted) {
 		get_random_bytes(&ip_conntrack_hash_rnd, 4);
@@ -577,73 +506,39 @@
 	conntrack->timeout.data = (unsigned long)conntrack;
 	conntrack->timeout.function = death_by_timeout;
 
-	INIT_LIST_HEAD(&conntrack->sibling_list);
-
 	WRITE_LOCK(&ip_conntrack_lock);
-	/* Need finding and deleting of expected ONLY if we win race */
-	READ_LOCK(&ip_conntrack_expect_tuple_lock);
-	expected = LIST_FIND(&ip_conntrack_expect_list, expect_cmp,
-			     struct ip_conntrack_expect *, tuple);
-	READ_UNLOCK(&ip_conntrack_expect_tuple_lock);
-
-	if (expected) {
-		/* If master is not in hash table yet (ie. packet hasn't left
-		   this machine yet), how can other end know about expected?
-		   Hence these are not the droids you are looking for (if
-		   master ct never got confirmed, we'd hold a reference to it
-		   and weird things would happen to future packets). */
-		if (!is_confirmed(expected->expectant)) {
-			conntrack->helper = ip_ct_find_helper(&repl_tuple);
-			goto end;
-		}
-
-		/* Expectation is dying... */
-		if (expected->expectant->helper->timeout
-		    && !del_timer(&expected->timeout))
-			goto end;	
+	exp = find_expectation(tuple);
 
+	if (exp) {
 		DEBUGP("conntrack: expectation arrives ct=%p exp=%p\n",
-			conntrack, expected);
+			conntrack, exp);
 		/* Welcome, Mr. Bond.  We've been expecting you... */
-		IP_NF_ASSERT(expected->expectant);
 		__set_bit(IPS_EXPECTED_BIT, &conntrack->status);
-		conntrack->master = expected;
-		expected->sibling = conntrack;
+		conntrack->master = exp->master;
 #if CONFIG_IP_NF_CONNTRACK_MARK
-		conntrack->mark = expected->expectant->mark;
+		conntrack->mark = exp->master->mark;
 #endif
-		LIST_DELETE(&ip_conntrack_expect_list, expected);
-		expected->expectant->expecting--;
-		nf_conntrack_get(&master_ct(conntrack)->ct_general);
-
-		/* this is a braindead... --pablo */
-		atomic_inc(&ip_conntrack_count);
-
-		/* Overload tuple linked list to put us in unconfirmed list. */
-		list_add(&conntrack->tuplehash[IP_CT_DIR_ORIGINAL].list,
-			 &unconfirmed);
-		WRITE_UNLOCK(&ip_conntrack_lock);
-
-		if (expected->expectfn)
-			expected->expectfn(conntrack);
-	
+		nf_conntrack_get(&conntrack->master->ct_general);
 		CONNTRACK_STAT_INC(expect_new);
-
-		goto ret;
-	} else  {
+	} else {
 		conntrack->helper = ip_ct_find_helper(&repl_tuple);
 
 		CONNTRACK_STAT_INC(new);
 	}
 
-end:
 	/* Overload tuple linked list to put us in unconfirmed list. */
 	list_add(&conntrack->tuplehash[IP_CT_DIR_ORIGINAL].list, &unconfirmed);
 
 	atomic_inc(&ip_conntrack_count);
 	WRITE_UNLOCK(&ip_conntrack_lock);
 
-ret:	return &conntrack->tuplehash[IP_CT_DIR_ORIGINAL];
+	if (exp) {
+		if (exp->expectfn)
+			exp->expectfn(conntrack, exp);
+		destroy_expect(exp);
+	}
+
+	return &conntrack->tuplehash[IP_CT_DIR_ORIGINAL];
 }
 
 /* On success, returns conntrack ptr, sets skb->nfct and ctinfo */
@@ -795,55 +690,50 @@
 				  ip_ct_find_proto(orig->dst.protonum));
 }
 
-static inline int resent_expect(const struct ip_conntrack_expect *i,
-			        const struct ip_conntrack_tuple *tuple,
-			        const struct ip_conntrack_tuple *mask)
-{
-	DEBUGP("resent_expect\n");
-	DEBUGP("   tuple:   "); DUMP_TUPLE(&i->tuple);
-	DEBUGP("ct_tuple:   "); DUMP_TUPLE(&i->ct_tuple);
-	DEBUGP("test tuple: "); DUMP_TUPLE(tuple);
-	return (((i->ct_tuple.dst.protonum == 0 && ip_ct_tuple_equal(&i->tuple, tuple))
-	         || (i->ct_tuple.dst.protonum && ip_ct_tuple_equal(&i->ct_tuple, tuple)))
-		&& ip_ct_tuple_equal(&i->mask, mask));
-}
-
 /* Would two expected things clash? */
-static inline int expect_clash(const struct ip_conntrack_expect *i,
-			       const struct ip_conntrack_tuple *tuple,
-			       const struct ip_conntrack_tuple *mask)
+static inline int expect_clash(const struct ip_conntrack_expect *a,
+			       const struct ip_conntrack_expect *b)
 {
 	/* Part covered by intersection of masks must be unequal,
            otherwise they clash */
 	struct ip_conntrack_tuple intersect_mask
-		= { { i->mask.src.ip & mask->src.ip,
-		      { i->mask.src.u.all & mask->src.u.all } },
-		    { i->mask.dst.ip & mask->dst.ip,
-		      { i->mask.dst.u.all & mask->dst.u.all },
-		      i->mask.dst.protonum & mask->dst.protonum } };
+		= { { a->mask.src.ip & b->mask.src.ip,
+		      { a->mask.src.u.all & b->mask.src.u.all } },
+		    { a->mask.dst.ip & b->mask.dst.ip,
+		      { a->mask.dst.u.all & b->mask.dst.u.all },
+		      a->mask.dst.protonum & b->mask.dst.protonum } };
 
-	return ip_ct_tuple_mask_cmp(&i->tuple, tuple, &intersect_mask);
+	return ip_ct_tuple_mask_cmp(&a->tuple, &b->tuple, &intersect_mask);
 }
 
-inline void ip_conntrack_unexpect_related(struct ip_conntrack_expect *expect)
+static inline int expect_matches(const struct ip_conntrack_expect *a,
+				 const struct ip_conntrack_expect *b)
 {
-	WRITE_LOCK(&ip_conntrack_lock);
-	unexpect_related(expect);
-	WRITE_UNLOCK(&ip_conntrack_lock);
+	return a->master == b->master
+		&& ip_ct_tuple_equal(&a->tuple, &b->tuple)
+		&& ip_ct_tuple_equal(&a->mask, &b->mask);
 }
-	
-static void expectation_timed_out(unsigned long ul_expect)
+
+/* Generally a bad idea to call this: could have matched already. */
+void ip_conntrack_unexpect_related(struct ip_conntrack_expect *exp)
 {
-	struct ip_conntrack_expect *expect = (void *) ul_expect;
+	struct ip_conntrack_expect *i;
 
-	DEBUGP("expectation %p timed out\n", expect);	
 	WRITE_LOCK(&ip_conntrack_lock);
-	__unexpect_related(expect);
+	/* choose the the oldest expectation to evict */
+	list_for_each_entry_reverse(i, &ip_conntrack_expect_list, list) {
+		if (expect_matches(i, exp)
+		    && (!i->timeout.function || del_timer(&i->timeout))) {
+			unlink_expect(i);
+			WRITE_UNLOCK(&ip_conntrack_lock);
+			destroy_expect(i);
+			return;
+		}
+	}
 	WRITE_UNLOCK(&ip_conntrack_lock);
 }
 
-struct ip_conntrack_expect *
-ip_conntrack_expect_alloc(void)
+struct ip_conntrack_expect *ip_conntrack_expect_alloc(void)
 {
 	struct ip_conntrack_expect *new;
 
@@ -852,136 +742,98 @@
 		DEBUGP("expect_related: OOM allocating expect\n");
 		return NULL;
 	}
+	new->master = NULL;
+	return new;
+}
 
-	/* tuple_cmp compares whole union, we have to initialized cleanly */
-	memset(new, 0, sizeof(struct ip_conntrack_expect));
-	atomic_set(&new->use, 1);
+void ip_conntrack_expect_free(struct ip_conntrack_expect *expect)
+{
+	kmem_cache_free(ip_conntrack_expect_cachep, expect);
+}
 
-	return new;
+static void ip_conntrack_expect_insert(struct ip_conntrack_expect *exp)
+{
+	atomic_inc(&exp->master->ct_general.use);
+	exp->master->expecting++;
+	list_add(&exp->list, &ip_conntrack_expect_list);
+
+	if (exp->master->helper->timeout) {
+		init_timer(&exp->timeout);
+		exp->timeout.data = (unsigned long)exp;
+		exp->timeout.function = expectation_timed_out;
+		exp->timeout.expires
+			= jiffies + exp->master->helper->timeout * HZ;
+		add_timer(&exp->timeout);
+	} else
+		exp->timeout.function = NULL;
+
+	CONNTRACK_STAT_INC(expect_create);
 }
 
-static void
-ip_conntrack_expect_insert(struct ip_conntrack_expect *new,
-			   struct ip_conntrack *related_to)
+/* Race with expectations being used means we could have none to find; OK. */
+static void evict_oldest_expect(struct ip_conntrack *master)
 {
-	DEBUGP("new expectation %p of conntrack %p\n", new, related_to);
-	new->expectant = related_to;
-	new->sibling = NULL;
-
-	/* add to expected list for this connection */
-	list_add_tail(&new->expected_list, &related_to->sibling_list);
-	/* add to global list of expectations */
-	list_prepend(&ip_conntrack_expect_list, &new->list);
-	/* add and start timer if required */
-	if (related_to->helper->timeout) {
-		init_timer(&new->timeout);
-		new->timeout.data = (unsigned long)new;
-		new->timeout.function = expectation_timed_out;
-		new->timeout.expires = jiffies +
-					related_to->helper->timeout * HZ;
-		add_timer(&new->timeout);
-	}
-	related_to->expecting++;
-}
-
-/* Add a related connection. */
-int ip_conntrack_expect_related(struct ip_conntrack_expect *expect,
-				struct ip_conntrack *related_to)
+	struct ip_conntrack_expect *i;
+
+	list_for_each_entry_reverse(i, &ip_conntrack_expect_list, list) {
+		if (i->master == master) {
+			if (!i->timeout.function || del_timer(&i->timeout)) {
+				unlink_expect(i);
+				destroy_expect(i);
+			}
+			break;
+		}
+	}
+}
+
+static inline int refresh_timer(struct ip_conntrack_expect *i)
 {
-	struct ip_conntrack_expect *old;
-	int ret = 0;
+	if (!i->timeout.function)
+		return 1;
 
-	WRITE_LOCK(&ip_conntrack_lock);
-	/* Because of the write lock, no reader can walk the lists,
-	 * so there is no need to use the tuple lock too */
+	if (!del_timer(&i->timeout))
+		return 0;
+
+	i->timeout.expires = jiffies + i->master->helper->timeout*HZ;
+	add_timer(&i->timeout);
+	return 1;
+}
+
+int ip_conntrack_expect_related(struct ip_conntrack_expect *expect)
+{
+	struct ip_conntrack_expect *i;
+	int ret;
 
 	DEBUGP("ip_conntrack_expect_related %p\n", related_to);
 	DEBUGP("tuple: "); DUMP_TUPLE(&expect->tuple);
 	DEBUGP("mask:  "); DUMP_TUPLE(&expect->mask);
 
-	old = LIST_FIND(&ip_conntrack_expect_list, resent_expect,
-		        struct ip_conntrack_expect *, &expect->tuple, 
-			&expect->mask);
-	if (old && old->expectant == related_to) {
-		/* Helper private data may contain offsets but no pointers
-		   pointing into the payload - otherwise we should have to copy 
-		   the data filled out by the helper over the old one */
-		DEBUGP("expect_related: resent packet\n");
-		if (related_to->helper->timeout) {
-			if (!del_timer(&old->timeout)) {
-				/* expectation is dying. Fall through */
+	WRITE_LOCK(&ip_conntrack_lock);
+	list_for_each_entry(i, &ip_conntrack_expect_list, list) {
+		if (expect_matches(i, expect)) {
+			/* Refresh timer: if it's dying, ignore.. */
+			if (refresh_timer(i)) {
+				ret = 0;
+				/* We don't need the one they've given us. */
+				ip_conntrack_expect_free(expect);
 				goto out;
-			} else {
-				old->timeout.expires = jiffies + 
-					related_to->helper->timeout * HZ;
-				add_timer(&old->timeout);
 			}
+		} else if (expect_clash(i, expect)) {
+			ret = -EBUSY;
+			goto out;
 		}
-
-		WRITE_UNLOCK(&ip_conntrack_lock);
-		ip_conntrack_expect_put(expect);
-		return -EEXIST;
-
-	} else if (related_to->helper->max_expected && 
-		   related_to->expecting >= related_to->helper->max_expected) {
-		/* old == NULL */
-		if (!(related_to->helper->flags & 
-		      IP_CT_HELPER_F_REUSE_EXPECT)) {
-			WRITE_UNLOCK(&ip_conntrack_lock);
- 		    	if (net_ratelimit())
- 			    	printk(KERN_WARNING
-				       "ip_conntrack: max number of expected "
-				       "connections %i of %s reached for "
-				       "%u.%u.%u.%u->%u.%u.%u.%u\n",
-				       related_to->helper->max_expected,
-				       related_to->helper->name,
- 		    	       	       NIPQUAD(related_to->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip),
- 		    	       	       NIPQUAD(related_to->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip));
-			ip_conntrack_expect_put(expect);
-			return -EPERM;
-		}
-		DEBUGP("ip_conntrack: max number of expected "
-		       "connections %i of %s reached for "
-		       "%u.%u.%u.%u->%u.%u.%u.%u, reusing\n",
- 		       related_to->helper->max_expected,
-		       related_to->helper->name,
-		       NIPQUAD(related_to->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip),
-		       NIPQUAD(related_to->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip));
- 
-		/* choose the the oldest expectation to evict */
-		list_for_each_entry(old, &related_to->sibling_list, 
-		                                      expected_list)
-			if (old->sibling == NULL)
-				break;
-
-		/* We cannot fail since related_to->expecting is the number
-		 * of unconfirmed expectations */
-		IP_NF_ASSERT(old && old->sibling == NULL);
-
-		/* newnat14 does not reuse the real allocated memory
-		 * structures but rather unexpects the old and
-		 * allocates a new.  unexpect_related will decrement
-		 * related_to->expecting. 
-		 */
-		unexpect_related(old);
-		ret = -EPERM;
-	} else if (LIST_FIND(&ip_conntrack_expect_list, expect_clash,
-			     struct ip_conntrack_expect *, &expect->tuple, 
-			     &expect->mask)) {
-		WRITE_UNLOCK(&ip_conntrack_lock);
-		DEBUGP("expect_related: busy!\n");
-
-		ip_conntrack_expect_put(expect);
-		return -EBUSY;
 	}
 
-out:	ip_conntrack_expect_insert(expect, related_to);
-
+	/* Will be over limit? */
+	if (expect->master->helper->max_expected && 
+	    expect->master->expecting >= expect->master->helper->max_expected)
+		evict_oldest_expect(expect->master);
+
+	ip_conntrack_expect_insert(expect);
+	ret = 0;
+out:
 	WRITE_UNLOCK(&ip_conntrack_lock);
-
-	CONNTRACK_STAT_INC(expect_create);
-
-	return ret;
+ 	return ret;
 }
 
 /* Alter reply tuple (maybe alter helper).  This is for NAT, and is
@@ -997,7 +849,7 @@
 	DUMP_TUPLE(newreply);
 
 	conntrack->tuplehash[IP_CT_DIR_REPLY].tuple = *newreply;
-	if (!conntrack->master && list_empty(&conntrack->sibling_list))
+	if (!conntrack->master && conntrack->expecting == 0)
 		conntrack->helper = ip_ct_find_helper(newreply);
 	WRITE_UNLOCK(&ip_conntrack_lock);
 }
@@ -1014,23 +866,30 @@
 static inline int unhelp(struct ip_conntrack_tuple_hash *i,
 			 const struct ip_conntrack_helper *me)
 {
-	if (i->ctrack->helper == me) {
-		/* Get rid of any expected. */
-		remove_expectations(i->ctrack, 0);
-		/* And *then* set helper to NULL */
+	if (i->ctrack->helper == me)
 		i->ctrack->helper = NULL;
-	}
 	return 0;
 }
 
 void ip_conntrack_helper_unregister(struct ip_conntrack_helper *me)
 {
 	unsigned int i;
+	struct ip_conntrack_expect *exp, *tmp;
 
 	/* Need write lock here, to delete helper. */
 	WRITE_LOCK(&ip_conntrack_lock);
 	LIST_DELETE(&helpers, me);
 
+	/* Get rid of expectations */
+	list_for_each_entry_safe(exp, tmp, &ip_conntrack_expect_list, list) {
+		if (exp->master->helper == me) {
+			if (!exp->timeout.function
+			    || del_timer(&exp->timeout)) {
+				unlink_expect(exp);
+				destroy_expect(exp);
+			}
+		}
+	}
 	/* Get rid of expecteds, set helpers to NULL. */
 	LIST_FIND_W(&unconfirmed, unhelp, struct ip_conntrack_tuple_hash*, me);
 	for (i = 0; i < ip_conntrack_htable_size; i++)

-- 
A bad analogy is like a leaky screwdriver -- Richard Braakman
