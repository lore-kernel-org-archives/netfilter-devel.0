From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/4] nf_conntrack_ipv[4|6] load on demand for x_tables
 matches/targets, take #2
Date: Mon, 13 Feb 2006 03:41:36 +0100
Message-ID: <43EFF1E0.8090102@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------000000080005040908020304"
Cc: Harald Welte <laforge@netfilter.org>, Patrick McHardy <kaber@trash.net>,
	Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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

This is a multi-part message in MIME format.
--------------000000080005040908020304
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Thanks to Yasuyuki Kozakai for all the feedback.

[NF_CONNTRACK] nf_conntrack_ipv[4|6] load on demand for x_tables
matches/targets, take #2

x_tables matches and targets that require nf_conntrack_ipv[4|6] to work
don't have enough information to load on demand these modules. This
patch introduces the following changes to solve this issue:

o checkentry and destroy now take an argument that gives information
about the layer 3 protocol from which they are called.
o nf_ct_l3proto_try_module_get: try to load the layer 3 connection
tracker module and increases the refcount.
o nf_ct_l3proto_module put: drop the refcount of the module.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris

--------------000000080005040908020304
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

[PATCH] nf_conntrack_ipv[4|6] load on demand for x_tables matches/targets

x_tables matches and targets that require nf_conntrack_ipv[4|6] to work
don't have enough information to load on demand these modules. This patch 
introduces the following changes to solve this issue:

o checkentry and destroy now take an argument that gives information about
the layer 3 protocol from which they are called.
o nf_ct_l3proto_try_module_get: try to load the layer 3 connection tracker
module and increases the refcount.
o nf_ct_l3proto_module put: drop the refcount of the module.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: net-2.6.git/include/linux/netfilter/x_tables.h
===================================================================
--- net-2.6.git.orig/include/linux/netfilter/x_tables.h	2006-02-12 20:49:57.000000000 +0100
+++ net-2.6.git/include/linux/netfilter/x_tables.h	2006-02-12 22:41:11.000000000 +0100
@@ -109,14 +109,14 @@ struct xt_match
 
 	/* Called when user tries to insert an entry of this type. */
 	/* Should return true or false. */
-	int (*checkentry)(const char *tablename,
+	int (*checkentry)(int pf, const char *tablename,
 			  const void *ip,
 			  void *matchinfo,
 			  unsigned int matchinfosize,
 			  unsigned int hook_mask);
 
 	/* Called when entry of this type deleted. */
-	void (*destroy)(void *matchinfo, unsigned int matchinfosize);
+	void (*destroy)(int pf, void *matchinfo, unsigned int matchinfosize);
 
 	/* Set this to THIS_MODULE if you are a module, otherwise NULL */
 	struct module *me;
@@ -145,14 +145,14 @@ struct xt_target
            hook_mask is a bitmask of hooks from which it can be
            called. */
 	/* Should return true or false. */
-	int (*checkentry)(const char *tablename,
+	int (*checkentry)(int pf, const char *tablename,
 			  const void *entry,
 			  void *targinfo,
 			  unsigned int targinfosize,
 			  unsigned int hook_mask);
 
 	/* Called when entry of this type deleted. */
-	void (*destroy)(void *targinfo, unsigned int targinfosize);
+	void (*destroy)(int pf, void *targinfo, unsigned int targinfosize);
 
 	/* Set this to THIS_MODULE if you are a module, otherwise NULL */
 	struct module *me;
Index: net-2.6.git/net/ipv4/netfilter/ip_tables.c
===================================================================
--- net-2.6.git.orig/net/ipv4/netfilter/ip_tables.c	2006-02-12 20:49:57.000000000 +0100
+++ net-2.6.git/net/ipv4/netfilter/ip_tables.c	2006-02-12 22:41:11.000000000 +0100
@@ -464,7 +464,7 @@ cleanup_match(struct ipt_entry_match *m,
 		return 1;
 
 	if (m->u.kernel.match->destroy)
-		m->u.kernel.match->destroy(m->data,
+		m->u.kernel.match->destroy(PF_INET, m->data,
 					   m->u.match_size - sizeof(*m));
 	module_put(m->u.kernel.match->me);
 	return 0;
@@ -519,7 +519,7 @@ check_match(struct ipt_entry_match *m,
 	m->u.kernel.match = match;
 
 	if (m->u.kernel.match->checkentry
-	    && !m->u.kernel.match->checkentry(name, ip, m->data,
+	    && !m->u.kernel.match->checkentry(PF_INET, name, ip, m->data,
 					      m->u.match_size - sizeof(*m),
 					      hookmask)) {
 		module_put(m->u.kernel.match->me);
@@ -571,7 +571,7 @@ check_entry(struct ipt_entry *e, const c
 			goto cleanup_matches;
 		}
 	} else if (t->u.kernel.target->checkentry
-		   && !t->u.kernel.target->checkentry(name, e, t->data,
+		   && !t->u.kernel.target->checkentry(PF_INET, name, e, t->data,
 						      t->u.target_size
 						      - sizeof(*t),
 						      e->comefrom)) {
@@ -645,7 +645,7 @@ cleanup_entry(struct ipt_entry *e, unsig
 	IPT_MATCH_ITERATE(e, cleanup_match, NULL);
 	t = ipt_get_target(e);
 	if (t->u.kernel.target->destroy)
-		t->u.kernel.target->destroy(t->data,
+		t->u.kernel.target->destroy(PF_INET, t->data,
 					    t->u.target_size - sizeof(*t));
 	module_put(t->u.kernel.target->me);
 	return 0;
@@ -1308,7 +1308,7 @@ icmp_match(const struct sk_buff *skb,
 
 /* Called when user tries to insert an entry of this type. */
 static int
-icmp_checkentry(const char *tablename,
+icmp_checkentry(int pf, const char *tablename,
 	   const void *info,
 	   void *matchinfo,
 	   unsigned int matchsize,
Index: net-2.6.git/net/ipv4/netfilter/ipt_CLUSTERIP.c
===================================================================
--- net-2.6.git.orig/net/ipv4/netfilter/ipt_CLUSTERIP.c	2006-02-12 20:49:57.000000000 +0100
+++ net-2.6.git/net/ipv4/netfilter/ipt_CLUSTERIP.c	2006-02-12 22:41:12.000000000 +0100
@@ -378,7 +378,7 @@ target(struct sk_buff **pskb,
 }
 
 static int
-checkentry(const char *tablename,
+checkentry(int pf, const char *tablename,
 	   const void *e_void,
            void *targinfo,
            unsigned int targinfosize,
@@ -465,7 +465,7 @@ checkentry(const char *tablename,
 }
 
 /* drop reference count of cluster config when rule is deleted */
-static void destroy(void *matchinfo, unsigned int matchinfosize)
+static void destroy(int pf, void *matchinfo, unsigned int matchinfosize)
 {
 	struct ipt_clusterip_tgt_info *cipinfo = matchinfo;
 
Index: net-2.6.git/net/ipv4/netfilter/ipt_DSCP.c
===================================================================
--- net-2.6.git.orig/net/ipv4/netfilter/ipt_DSCP.c	2006-02-12 20:49:57.000000000 +0100
+++ net-2.6.git/net/ipv4/netfilter/ipt_DSCP.c	2006-02-12 22:41:12.000000000 +0100
@@ -56,7 +56,7 @@ target(struct sk_buff **pskb,
 }
 
 static int
-checkentry(const char *tablename,
+checkentry(int pf, const char *tablename,
 	   const void *e_void,
            void *targinfo,
            unsigned int targinfosize,
Index: net-2.6.git/net/ipv4/netfilter/ipt_ECN.c
===================================================================
--- net-2.6.git.orig/net/ipv4/netfilter/ipt_ECN.c	2006-02-12 20:49:57.000000000 +0100
+++ net-2.6.git/net/ipv4/netfilter/ipt_ECN.c	2006-02-12 22:41:12.000000000 +0100
@@ -112,7 +112,7 @@ target(struct sk_buff **pskb,
 }
 
 static int
-checkentry(const char *tablename,
+checkentry(int pf, const char *tablename,
 	   const void *e_void,
            void *targinfo,
            unsigned int targinfosize,
Index: net-2.6.git/net/ipv4/netfilter/ipt_LOG.c
===================================================================
--- net-2.6.git.orig/net/ipv4/netfilter/ipt_LOG.c	2006-02-12 20:49:57.000000000 +0100
+++ net-2.6.git/net/ipv4/netfilter/ipt_LOG.c	2006-02-12 22:41:12.000000000 +0100
@@ -430,7 +430,7 @@ ipt_log_target(struct sk_buff **pskb,
 	return IPT_CONTINUE;
 }
 
-static int ipt_log_checkentry(const char *tablename,
+static int ipt_log_checkentry(int pf, const char *tablename,
 			      const void *e,
 			      void *targinfo,
 			      unsigned int targinfosize,
Index: net-2.6.git/net/ipv4/netfilter/ipt_MASQUERADE.c
===================================================================
--- net-2.6.git.orig/net/ipv4/netfilter/ipt_MASQUERADE.c	2006-02-12 20:49:57.000000000 +0100
+++ net-2.6.git/net/ipv4/netfilter/ipt_MASQUERADE.c	2006-02-12 22:41:12.000000000 +0100
@@ -39,7 +39,7 @@ static DEFINE_RWLOCK(masq_lock);
 
 /* FIXME: Multiple targets. --RR */
 static int
-masquerade_check(const char *tablename,
+masquerade_check(int pf, const char *tablename,
 		 const void *e,
 		 void *targinfo,
 		 unsigned int targinfosize,
Index: net-2.6.git/net/ipv4/netfilter/ipt_NETMAP.c
===================================================================
--- net-2.6.git.orig/net/ipv4/netfilter/ipt_NETMAP.c	2006-02-12 20:49:57.000000000 +0100
+++ net-2.6.git/net/ipv4/netfilter/ipt_NETMAP.c	2006-02-12 22:41:12.000000000 +0100
@@ -30,7 +30,7 @@ MODULE_DESCRIPTION("iptables 1:1 NAT map
 #endif
 
 static int
-check(const char *tablename,
+check(int pf, const char *tablename,
       const void *e,
       void *targinfo,
       unsigned int targinfosize,
Index: net-2.6.git/net/ipv4/netfilter/ipt_REDIRECT.c
===================================================================
--- net-2.6.git.orig/net/ipv4/netfilter/ipt_REDIRECT.c	2006-02-12 20:49:57.000000000 +0100
+++ net-2.6.git/net/ipv4/netfilter/ipt_REDIRECT.c	2006-02-12 22:41:12.000000000 +0100
@@ -32,7 +32,7 @@ MODULE_DESCRIPTION("iptables REDIRECT ta
 
 /* FIXME: Take multiple ranges --RR */
 static int
-redirect_check(const char *tablename,
+redirect_check(int pf, const char *tablename,
 	       const void *e,
 	       void *targinfo,
 	       unsigned int targinfosize,
Index: net-2.6.git/net/ipv4/netfilter/ipt_REJECT.c
===================================================================
--- net-2.6.git.orig/net/ipv4/netfilter/ipt_REJECT.c	2006-02-12 20:49:57.000000000 +0100
+++ net-2.6.git/net/ipv4/netfilter/ipt_REJECT.c	2006-02-12 22:41:12.000000000 +0100
@@ -281,7 +281,7 @@ static unsigned int reject(struct sk_buf
 	return NF_DROP;
 }
 
-static int check(const char *tablename,
+static int check(int pf, const char *tablename,
 		 const void *e_void,
 		 void *targinfo,
 		 unsigned int targinfosize,
Index: net-2.6.git/net/ipv4/netfilter/ipt_SAME.c
===================================================================
--- net-2.6.git.orig/net/ipv4/netfilter/ipt_SAME.c	2006-02-12 20:49:57.000000000 +0100
+++ net-2.6.git/net/ipv4/netfilter/ipt_SAME.c	2006-02-12 22:41:12.000000000 +0100
@@ -48,7 +48,7 @@ MODULE_DESCRIPTION("iptables special SNA
 #endif
 
 static int
-same_check(const char *tablename,
+same_check(int pf, const char *tablename,
 	      const void *e,
 	      void *targinfo,
 	      unsigned int targinfosize,
@@ -127,8 +127,7 @@ same_check(const char *tablename,
 }
 
 static void 
-same_destroy(void *targinfo,
-		unsigned int targinfosize)
+same_destroy(int pf, void *targinfo, unsigned int targinfosize)
 {
 	struct ipt_same_info *mr = targinfo;
 
Index: net-2.6.git/net/ipv4/netfilter/ipt_TCPMSS.c
===================================================================
--- net-2.6.git.orig/net/ipv4/netfilter/ipt_TCPMSS.c	2006-02-12 20:49:57.000000000 +0100
+++ net-2.6.git/net/ipv4/netfilter/ipt_TCPMSS.c	2006-02-12 22:41:12.000000000 +0100
@@ -209,7 +209,7 @@ static inline int find_syn_match(const s
 
 /* Must specify -p tcp --syn/--tcp-flags SYN */
 static int
-ipt_tcpmss_checkentry(const char *tablename,
+ipt_tcpmss_checkentry(int pf, const char *tablename,
 		      const void *e_void,
 		      void *targinfo,
 		      unsigned int targinfosize,
Index: net-2.6.git/net/ipv4/netfilter/ipt_TOS.c
===================================================================
--- net-2.6.git.orig/net/ipv4/netfilter/ipt_TOS.c	2006-02-12 20:49:57.000000000 +0100
+++ net-2.6.git/net/ipv4/netfilter/ipt_TOS.c	2006-02-12 22:41:12.000000000 +0100
@@ -51,7 +51,7 @@ target(struct sk_buff **pskb,
 }
 
 static int
-checkentry(const char *tablename,
+checkentry(int pf, const char *tablename,
 	   const void *e_void,
            void *targinfo,
            unsigned int targinfosize,
Index: net-2.6.git/net/ipv4/netfilter/ipt_TTL.c
===================================================================
--- net-2.6.git.orig/net/ipv4/netfilter/ipt_TTL.c	2006-02-12 20:49:57.000000000 +0100
+++ net-2.6.git/net/ipv4/netfilter/ipt_TTL.c	2006-02-12 22:41:12.000000000 +0100
@@ -65,7 +65,7 @@ ipt_ttl_target(struct sk_buff **pskb, co
 	return IPT_CONTINUE;
 }
 
-static int ipt_ttl_checkentry(const char *tablename,
+static int ipt_ttl_checkentry(int pf, const char *tablename,
 		const void *e,
 		void *targinfo,
 		unsigned int targinfosize,
Index: net-2.6.git/net/ipv4/netfilter/ipt_ULOG.c
===================================================================
--- net-2.6.git.orig/net/ipv4/netfilter/ipt_ULOG.c	2006-02-12 20:49:57.000000000 +0100
+++ net-2.6.git/net/ipv4/netfilter/ipt_ULOG.c	2006-02-12 22:41:12.000000000 +0100
@@ -337,7 +337,7 @@ static void ipt_logfn(unsigned int pf,
 	ipt_ulog_packet(hooknum, skb, in, out, &loginfo, prefix);
 }
 
-static int ipt_ulog_checkentry(const char *tablename,
+static int ipt_ulog_checkentry(int pf, const char *tablename,
 			       const void *e,
 			       void *targinfo,
 			       unsigned int targinfosize,
Index: net-2.6.git/net/ipv4/netfilter/ipt_addrtype.c
===================================================================
--- net-2.6.git.orig/net/ipv4/netfilter/ipt_addrtype.c	2006-02-12 20:49:57.000000000 +0100
+++ net-2.6.git/net/ipv4/netfilter/ipt_addrtype.c	2006-02-12 22:41:12.000000000 +0100
@@ -43,7 +43,7 @@ static int match(const struct sk_buff *s
 	return ret;
 }
 
-static int checkentry(const char *tablename, const void *ip,
+static int checkentry(int pf, const char *tablename, const void *ip,
 		      void *matchinfo, unsigned int matchsize,
 		      unsigned int hook_mask)
 {
Index: net-2.6.git/net/ipv4/netfilter/ipt_ah.c
===================================================================
--- net-2.6.git.orig/net/ipv4/netfilter/ipt_ah.c	2006-02-12 20:49:57.000000000 +0100
+++ net-2.6.git/net/ipv4/netfilter/ipt_ah.c	2006-02-12 22:41:12.000000000 +0100
@@ -69,7 +69,7 @@ match(const struct sk_buff *skb,
 
 /* Called when user tries to insert an entry of this type. */
 static int
-checkentry(const char *tablename,
+checkentry(int pf, const char *tablename,
 	   const void *ip_void,
 	   void *matchinfo,
 	   unsigned int matchinfosize,
Index: net-2.6.git/net/ipv4/netfilter/ipt_dscp.c
===================================================================
--- net-2.6.git.orig/net/ipv4/netfilter/ipt_dscp.c	2006-02-12 20:49:57.000000000 +0100
+++ net-2.6.git/net/ipv4/netfilter/ipt_dscp.c	2006-02-12 22:41:12.000000000 +0100
@@ -31,7 +31,7 @@ static int match(const struct sk_buff *s
 	return ((iph->tos&IPT_DSCP_MASK) == sh_dscp) ^ info->invert;
 }
 
-static int checkentry(const char *tablename, const void *ip,
+static int checkentry(int pf, const char *tablename, const void *ip,
 		      void *matchinfo, unsigned int matchsize,
 		      unsigned int hook_mask)
 {
Index: net-2.6.git/net/ipv4/netfilter/ipt_ecn.c
===================================================================
--- net-2.6.git.orig/net/ipv4/netfilter/ipt_ecn.c	2006-02-12 20:49:57.000000000 +0100
+++ net-2.6.git/net/ipv4/netfilter/ipt_ecn.c	2006-02-12 22:41:12.000000000 +0100
@@ -85,7 +85,7 @@ static int match(const struct sk_buff *s
 	return 1;
 }
 
-static int checkentry(const char *tablename, const void *ip_void,
+static int checkentry(int pf, const char *tablename, const void *ip_void,
 		      void *matchinfo, unsigned int matchsize,
 		      unsigned int hook_mask)
 {
Index: net-2.6.git/net/ipv4/netfilter/ipt_esp.c
===================================================================
--- net-2.6.git.orig/net/ipv4/netfilter/ipt_esp.c	2006-02-12 20:49:57.000000000 +0100
+++ net-2.6.git/net/ipv4/netfilter/ipt_esp.c	2006-02-12 22:41:12.000000000 +0100
@@ -70,7 +70,7 @@ match(const struct sk_buff *skb,
 
 /* Called when user tries to insert an entry of this type. */
 static int
-checkentry(const char *tablename,
+checkentry(int pf, const char *tablename,
 	   const void *ip_void,
 	   void *matchinfo,
 	   unsigned int matchinfosize,
Index: net-2.6.git/net/ipv4/netfilter/ipt_hashlimit.c
===================================================================
--- net-2.6.git.orig/net/ipv4/netfilter/ipt_hashlimit.c	2006-02-12 20:49:57.000000000 +0100
+++ net-2.6.git/net/ipv4/netfilter/ipt_hashlimit.c	2006-02-12 22:41:12.000000000 +0100
@@ -504,7 +504,7 @@ hashlimit_match(const struct sk_buff *sk
 }
 
 static int
-hashlimit_checkentry(const char *tablename,
+hashlimit_checkentry(int pf, const char *tablename,
 		     const void *inf,
 		     void *matchinfo,
 		     unsigned int matchsize,
@@ -558,7 +558,7 @@ hashlimit_checkentry(const char *tablena
 }
 
 static void
-hashlimit_destroy(void *matchinfo, unsigned int matchsize)
+hashlimit_destroy(int pf, void *matchinfo, unsigned int matchsize)
 {
 	struct ipt_hashlimit_info *r = (struct ipt_hashlimit_info *) matchinfo;
 
Index: net-2.6.git/net/ipv4/netfilter/ipt_iprange.c
===================================================================
--- net-2.6.git.orig/net/ipv4/netfilter/ipt_iprange.c	2006-02-12 20:49:57.000000000 +0100
+++ net-2.6.git/net/ipv4/netfilter/ipt_iprange.c	2006-02-12 22:41:12.000000000 +0100
@@ -62,7 +62,7 @@ match(const struct sk_buff *skb,
 	return 1;
 }
 
-static int check(const char *tablename,
+static int check(int pf, const char *tablename,
 		 const void *inf,
 		 void *matchinfo,
 		 unsigned int matchsize,
Index: net-2.6.git/net/ipv4/netfilter/ipt_multiport.c
===================================================================
--- net-2.6.git.orig/net/ipv4/netfilter/ipt_multiport.c	2006-02-12 20:49:57.000000000 +0100
+++ net-2.6.git/net/ipv4/netfilter/ipt_multiport.c	2006-02-12 22:41:12.000000000 +0100
@@ -155,7 +155,7 @@ match_v1(const struct sk_buff *skb,
 
 /* Called when user tries to insert an entry of this type. */
 static int
-checkentry(const char *tablename,
+checkentry(int pf, const char *tablename,
 	   const void *ip,
 	   void *matchinfo,
 	   unsigned int matchsize,
@@ -165,7 +165,7 @@ checkentry(const char *tablename,
 }
 
 static int
-checkentry_v1(const char *tablename,
+checkentry_v1(int pf, const char *tablename,
 	      const void *ip,
 	      void *matchinfo,
 	      unsigned int matchsize,
Index: net-2.6.git/net/ipv4/netfilter/ipt_owner.c
===================================================================
--- net-2.6.git.orig/net/ipv4/netfilter/ipt_owner.c	2006-02-12 20:49:57.000000000 +0100
+++ net-2.6.git/net/ipv4/netfilter/ipt_owner.c	2006-02-12 22:41:12.000000000 +0100
@@ -51,7 +51,7 @@ match(const struct sk_buff *skb,
 }
 
 static int
-checkentry(const char *tablename,
+checkentry(int pf, const char *tablename,
            const void *ip,
            void *matchinfo,
            unsigned int matchsize,
Index: net-2.6.git/net/ipv4/netfilter/ipt_policy.c
===================================================================
--- net-2.6.git.orig/net/ipv4/netfilter/ipt_policy.c	2006-02-12 20:49:57.000000000 +0100
+++ net-2.6.git/net/ipv4/netfilter/ipt_policy.c	2006-02-12 22:41:12.000000000 +0100
@@ -119,7 +119,7 @@ static int match(const struct sk_buff *s
 	return ret;
 }
 
-static int checkentry(const char *tablename, const void *ip_void,
+static int checkentry(int pf, const char *tablename, const void *ip_void,
                       void *matchinfo, unsigned int matchsize,
                       unsigned int hook_mask)
 {
Index: net-2.6.git/net/ipv4/netfilter/ipt_recent.c
===================================================================
--- net-2.6.git.orig/net/ipv4/netfilter/ipt_recent.c	2006-02-12 20:49:57.000000000 +0100
+++ net-2.6.git/net/ipv4/netfilter/ipt_recent.c	2006-02-12 22:41:12.000000000 +0100
@@ -655,7 +655,7 @@ match(const struct sk_buff *skb,
  * rule exists, if not it is created.
  */
 static int
-checkentry(const char *tablename,
+checkentry(int pf, const char *tablename,
            const void *ip,
            void *matchinfo,
            unsigned int matchsize,
@@ -871,7 +871,7 @@ checkentry(const char *tablename,
  * up its memory.
  */
 static void
-destroy(void *matchinfo, unsigned int matchsize)
+destroy(int pf, void *matchinfo, unsigned int matchsize)
 {
 	const struct ipt_recent_info *info = matchinfo;
 	struct recent_ip_tables *curr_table, *last_table;
Index: net-2.6.git/net/ipv4/netfilter/ipt_tos.c
===================================================================
--- net-2.6.git.orig/net/ipv4/netfilter/ipt_tos.c	2006-02-12 20:49:57.000000000 +0100
+++ net-2.6.git/net/ipv4/netfilter/ipt_tos.c	2006-02-12 22:41:12.000000000 +0100
@@ -32,7 +32,7 @@ match(const struct sk_buff *skb,
 }
 
 static int
-checkentry(const char *tablename,
+checkentry(int pf, const char *tablename,
            const void *ip,
            void *matchinfo,
            unsigned int matchsize,
Index: net-2.6.git/net/ipv4/netfilter/ipt_ttl.c
===================================================================
--- net-2.6.git.orig/net/ipv4/netfilter/ipt_ttl.c	2006-02-12 20:49:57.000000000 +0100
+++ net-2.6.git/net/ipv4/netfilter/ipt_ttl.c	2006-02-12 22:41:12.000000000 +0100
@@ -47,7 +47,7 @@ static int match(const struct sk_buff *s
 	return 0;
 }
 
-static int checkentry(const char *tablename, const void  *ip,
+static int checkentry(int pf, const char *tablename, const void  *ip,
 		      void *matchinfo, unsigned int matchsize,
 		      unsigned int hook_mask)
 {
Index: net-2.6.git/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
===================================================================
--- net-2.6.git.orig/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c	2006-02-12 20:49:57.000000000 +0100
+++ net-2.6.git/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c	2006-02-12 22:41:12.000000000 +0100
@@ -571,6 +571,7 @@ static int init_or_cleanup(int init)
 	return ret;
 }
 
+MODULE_ALIAS("nf_conntrack-" __stringify(PF_INET));
 MODULE_LICENSE("GPL");
 
 static int __init init(void)
Index: net-2.6.git/net/ipv6/netfilter/ip6_tables.c
===================================================================
--- net-2.6.git.orig/net/ipv6/netfilter/ip6_tables.c	2006-02-12 20:49:57.000000000 +0100
+++ net-2.6.git/net/ipv6/netfilter/ip6_tables.c	2006-02-12 22:41:12.000000000 +0100
@@ -531,7 +531,7 @@ cleanup_match(struct ip6t_entry_match *m
 		return 1;
 
 	if (m->u.kernel.match->destroy)
-		m->u.kernel.match->destroy(m->data,
+		m->u.kernel.match->destroy(PF_INET6, m->data,
 					   m->u.match_size - sizeof(*m));
 	module_put(m->u.kernel.match->me);
 	return 0;
@@ -586,7 +586,7 @@ check_match(struct ip6t_entry_match *m,
 	m->u.kernel.match = match;
 
 	if (m->u.kernel.match->checkentry
-	    && !m->u.kernel.match->checkentry(name, ipv6, m->data,
+	    && !m->u.kernel.match->checkentry(PF_INET6, name, ipv6, m->data,
 					      m->u.match_size - sizeof(*m),
 					      hookmask)) {
 		module_put(m->u.kernel.match->me);
@@ -638,7 +638,8 @@ check_entry(struct ip6t_entry *e, const 
 			goto cleanup_matches;
 		}
 	} else if (t->u.kernel.target->checkentry
-		   && !t->u.kernel.target->checkentry(name, e, t->data,
+		   && !t->u.kernel.target->checkentry(PF_INET6, name,
+			   			      e, t->data,
 						      t->u.target_size
 						      - sizeof(*t),
 						      e->comefrom)) {
@@ -712,7 +713,7 @@ cleanup_entry(struct ip6t_entry *e, unsi
 	IP6T_MATCH_ITERATE(e, cleanup_match, NULL);
 	t = ip6t_get_target(e);
 	if (t->u.kernel.target->destroy)
-		t->u.kernel.target->destroy(t->data,
+		t->u.kernel.target->destroy(PF_INET6, t->data,
 					    t->u.target_size - sizeof(*t));
 	module_put(t->u.kernel.target->me);
 	return 0;
@@ -1363,7 +1364,7 @@ icmp6_match(const struct sk_buff *skb,
 
 /* Called when user tries to insert an entry of this type. */
 static int
-icmp6_checkentry(const char *tablename,
+icmp6_checkentry(int pf, const char *tablename,
 	   const void *entry,
 	   void *matchinfo,
 	   unsigned int matchsize,
Index: net-2.6.git/net/ipv6/netfilter/ip6t_REJECT.c
===================================================================
--- net-2.6.git.orig/net/ipv6/netfilter/ip6t_REJECT.c	2006-02-12 20:49:57.000000000 +0100
+++ net-2.6.git/net/ipv6/netfilter/ip6t_REJECT.c	2006-02-12 22:41:12.000000000 +0100
@@ -217,7 +217,7 @@ static unsigned int reject6_target(struc
 	return NF_DROP;
 }
 
-static int check(const char *tablename,
+static int check(int pf, const char *tablename,
 		 const void *entry,
 		 void *targinfo,
 		 unsigned int targinfosize,
Index: net-2.6.git/net/ipv6/netfilter/ip6t_ah.c
===================================================================
--- net-2.6.git.orig/net/ipv6/netfilter/ip6t_ah.c	2006-02-12 20:49:57.000000000 +0100
+++ net-2.6.git/net/ipv6/netfilter/ip6t_ah.c	2006-02-12 22:41:12.000000000 +0100
@@ -97,7 +97,7 @@ match(const struct sk_buff *skb,
 
 /* Called when user tries to insert an entry of this type. */
 static int
-checkentry(const char *tablename,
+checkentry(int pf, const char *tablename,
           const void *entry,
           void *matchinfo,
           unsigned int matchinfosize,
Index: net-2.6.git/net/ipv6/netfilter/ip6t_dst.c
===================================================================
--- net-2.6.git.orig/net/ipv6/netfilter/ip6t_dst.c	2006-02-12 20:49:57.000000000 +0100
+++ net-2.6.git/net/ipv6/netfilter/ip6t_dst.c	2006-02-12 22:41:12.000000000 +0100
@@ -177,7 +177,7 @@ match(const struct sk_buff *skb,
 
 /* Called when user tries to insert an entry of this type. */
 static int
-checkentry(const char *tablename,
+checkentry(int pf, const char *tablename,
 	   const void *info,
 	   void *matchinfo,
 	   unsigned int matchinfosize,
Index: net-2.6.git/net/ipv6/netfilter/ip6t_esp.c
===================================================================
--- net-2.6.git.orig/net/ipv6/netfilter/ip6t_esp.c	2006-02-12 20:49:57.000000000 +0100
+++ net-2.6.git/net/ipv6/netfilter/ip6t_esp.c	2006-02-12 22:41:12.000000000 +0100
@@ -75,7 +75,7 @@ match(const struct sk_buff *skb,
 
 /* Called when user tries to insert an entry of this type. */
 static int
-checkentry(const char *tablename,
+checkentry(int pf, const char *tablename,
 	   const void *ip,
 	   void *matchinfo,
 	   unsigned int matchinfosize,
Index: net-2.6.git/net/ipv6/netfilter/ip6t_eui64.c
===================================================================
--- net-2.6.git.orig/net/ipv6/netfilter/ip6t_eui64.c	2006-02-12 20:49:57.000000000 +0100
+++ net-2.6.git/net/ipv6/netfilter/ip6t_eui64.c	2006-02-12 22:41:12.000000000 +0100
@@ -61,7 +61,7 @@ match(const struct sk_buff *skb,
 }
 
 static int
-ip6t_eui64_checkentry(const char *tablename,
+ip6t_eui64_checkentry(int pf, const char *tablename,
 		      const void *ip,
 		      void *matchinfo,
 		      unsigned int matchsize,
Index: net-2.6.git/net/ipv6/netfilter/ip6t_frag.c
===================================================================
--- net-2.6.git.orig/net/ipv6/netfilter/ip6t_frag.c	2006-02-12 20:49:57.000000000 +0100
+++ net-2.6.git/net/ipv6/netfilter/ip6t_frag.c	2006-02-12 22:41:12.000000000 +0100
@@ -114,7 +114,7 @@ match(const struct sk_buff *skb,
 
 /* Called when user tries to insert an entry of this type. */
 static int
-checkentry(const char *tablename,
+checkentry(int pf, const char *tablename,
 	   const void *ip,
 	   void *matchinfo,
 	   unsigned int matchinfosize,
Index: net-2.6.git/net/ipv6/netfilter/ip6t_hbh.c
===================================================================
--- net-2.6.git.orig/net/ipv6/netfilter/ip6t_hbh.c	2006-02-12 20:49:57.000000000 +0100
+++ net-2.6.git/net/ipv6/netfilter/ip6t_hbh.c	2006-02-12 22:41:12.000000000 +0100
@@ -177,7 +177,7 @@ match(const struct sk_buff *skb,
 
 /* Called when user tries to insert an entry of this type. */
 static int
-checkentry(const char *tablename,
+checkentry(int pf, const char *tablename,
 	   const void *entry,
 	   void *matchinfo,
 	   unsigned int matchinfosize,
Index: net-2.6.git/net/ipv6/netfilter/ip6t_hl.c
===================================================================
--- net-2.6.git.orig/net/ipv6/netfilter/ip6t_hl.c	2006-02-12 20:49:57.000000000 +0100
+++ net-2.6.git/net/ipv6/netfilter/ip6t_hl.c	2006-02-12 22:41:12.000000000 +0100
@@ -48,7 +48,7 @@ static int match(const struct sk_buff *s
 	return 0;
 }
 
-static int checkentry(const char *tablename, const void *entry,
+static int checkentry(int pf, const char *tablename, const void *entry,
 		      void *matchinfo, unsigned int matchsize,
 		      unsigned int hook_mask)
 {
Index: net-2.6.git/net/ipv6/netfilter/ip6t_ipv6header.c
===================================================================
--- net-2.6.git.orig/net/ipv6/netfilter/ip6t_ipv6header.c	2006-02-12 20:49:57.000000000 +0100
+++ net-2.6.git/net/ipv6/netfilter/ip6t_ipv6header.c	2006-02-12 22:41:12.000000000 +0100
@@ -123,7 +123,7 @@ ipv6header_match(const struct sk_buff *s
 }
 
 static int
-ipv6header_checkentry(const char *tablename,
+ipv6header_checkentry(int pf, const char *tablename,
 		      const void *ip,
 		      void *matchinfo,
 		      unsigned int matchsize,
Index: net-2.6.git/net/ipv6/netfilter/ip6t_multiport.c
===================================================================
--- net-2.6.git.orig/net/ipv6/netfilter/ip6t_multiport.c	2006-02-12 20:49:57.000000000 +0100
+++ net-2.6.git/net/ipv6/netfilter/ip6t_multiport.c	2006-02-12 22:41:12.000000000 +0100
@@ -83,7 +83,7 @@ match(const struct sk_buff *skb,
 
 /* Called when user tries to insert an entry of this type. */
 static int
-checkentry(const char *tablename,
+checkentry(int pf, const char *tablename,
 	   const void *info,
 	   void *matchinfo,
 	   unsigned int matchsize,
Index: net-2.6.git/net/ipv6/netfilter/ip6t_owner.c
===================================================================
--- net-2.6.git.orig/net/ipv6/netfilter/ip6t_owner.c	2006-02-12 20:49:57.000000000 +0100
+++ net-2.6.git/net/ipv6/netfilter/ip6t_owner.c	2006-02-12 22:41:12.000000000 +0100
@@ -52,7 +52,7 @@ match(const struct sk_buff *skb,
 }
 
 static int
-checkentry(const char *tablename,
+checkentry(int pf, const char *tablename,
 	   const void *ip,
 	   void *matchinfo,
 	   unsigned int matchsize,
Index: net-2.6.git/net/ipv6/netfilter/ip6t_policy.c
===================================================================
--- net-2.6.git.orig/net/ipv6/netfilter/ip6t_policy.c	2006-02-12 20:49:57.000000000 +0100
+++ net-2.6.git/net/ipv6/netfilter/ip6t_policy.c	2006-02-12 22:41:12.000000000 +0100
@@ -119,7 +119,7 @@ static int match(const struct sk_buff *s
 	return ret;
 }
 
-static int checkentry(const char *tablename, const void *ip_void,
+static int checkentry(int pf, const char *tablename, const void *ip_void,
                       void *matchinfo, unsigned int matchsize,
                       unsigned int hook_mask)
 {
Index: net-2.6.git/net/ipv6/netfilter/ip6t_rt.c
===================================================================
--- net-2.6.git.orig/net/ipv6/netfilter/ip6t_rt.c	2006-02-12 20:49:57.000000000 +0100
+++ net-2.6.git/net/ipv6/netfilter/ip6t_rt.c	2006-02-12 22:41:12.000000000 +0100
@@ -192,7 +192,7 @@ match(const struct sk_buff *skb,
 
 /* Called when user tries to insert an entry of this type. */
 static int
-checkentry(const char *tablename,
+checkentry(int pf, const char *tablename,
 	   const void *entry,
 	   void *matchinfo,
 	   unsigned int matchinfosize,
Index: net-2.6.git/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
===================================================================
--- net-2.6.git.orig/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c	2006-02-12 20:49:57.000000000 +0100
+++ net-2.6.git/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c	2006-02-12 22:41:12.000000000 +0100
@@ -579,6 +579,7 @@ static int init_or_cleanup(int init)
 	return ret;
 }
 
+MODULE_ALIAS("nf_conntrack-" __stringify(PF_INET6));
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Yasuyuki KOZAKAI @USAGI <yasuyuki.kozakai@toshiba.co.jp>");
 
Index: net-2.6.git/net/netfilter/nf_conntrack_core.c
===================================================================
--- net-2.6.git.orig/net/netfilter/nf_conntrack_core.c	2006-02-12 20:49:57.000000000 +0100
+++ net-2.6.git/net/netfilter/nf_conntrack_core.c	2006-02-13 03:28:19.000000000 +0100
@@ -20,6 +20,8 @@
  *	- generalize L3 protocol denendent part.
  * 23 Mar 2004: Yasuyuki Kozakai @USAGI <yasuyuki.kozakai@toshiba.co.jp>
  *	- add support various size of conntrack structures.
+ * 05 Feb 2006: Pablo Neira Ayuso <pablo@eurodev.net>
+ * 	- add support for L3 protocol module load on demand.
  *
  * Derived from net/ipv4/netfilter/ip_conntrack_core.c
  */
@@ -238,6 +240,35 @@ void nf_ct_l3proto_put(struct nf_conntra
 	module_put(p->me);
 }
 
+int
+nf_ct_l3proto_try_module_get(u_int16_t l3proto)
+{
+	int ret;
+	struct nf_conntrack_l3proto *p;
+
+retry:	p = nf_ct_l3proto_find_get(l3proto);
+	if (p == &nf_conntrack_generic_l3proto) {
+		ret = request_module("nf_conntrack-%d", l3proto);
+		if (!ret)
+			goto retry;
+
+		return -EPROTOTYPE;
+	}
+
+	return 0;
+}
+
+void nf_ct_l3proto_module_put(u_int16_t l3num)
+{
+	struct nf_conntrack_l3proto *p;
+
+	preempt_disable();
+	p = __nf_ct_l3proto_find(l3num);
+	preempt_enable();
+
+	module_put(p->me);
+}
+
 static int nf_conntrack_hash_rnd_initted;
 static unsigned int nf_conntrack_hash_rnd;
 
Index: net-2.6.git/net/netfilter/nf_conntrack_standalone.c
===================================================================
--- net-2.6.git.orig/net/netfilter/nf_conntrack_standalone.c	2006-02-12 20:49:57.000000000 +0100
+++ net-2.6.git/net/netfilter/nf_conntrack_standalone.c	2006-02-12 22:41:12.000000000 +0100
@@ -834,6 +834,8 @@ EXPORT_SYMBOL_GPL(__nf_ct_event_cache_in
 EXPORT_PER_CPU_SYMBOL_GPL(nf_conntrack_ecache);
 EXPORT_SYMBOL_GPL(nf_ct_deliver_cached_events);
 #endif
+EXPORT_SYMBOL(nf_ct_l3proto_try_module_get);
+EXPORT_SYMBOL(nf_ct_l3proto_module_put);
 EXPORT_SYMBOL(nf_conntrack_l3proto_register);
 EXPORT_SYMBOL(nf_conntrack_l3proto_unregister);
 EXPORT_SYMBOL(nf_conntrack_protocol_register);
Index: net-2.6.git/net/netfilter/xt_CLASSIFY.c
===================================================================
--- net-2.6.git.orig/net/netfilter/xt_CLASSIFY.c	2006-02-12 20:49:57.000000000 +0100
+++ net-2.6.git/net/netfilter/xt_CLASSIFY.c	2006-02-12 22:41:12.000000000 +0100
@@ -40,7 +40,7 @@ target(struct sk_buff **pskb,
 }
 
 static int
-checkentry(const char *tablename,
+checkentry(int pf, const char *tablename,
            const void *e,
            void *targinfo,
            unsigned int targinfosize,
Index: net-2.6.git/net/netfilter/xt_CONNMARK.c
===================================================================
--- net-2.6.git.orig/net/netfilter/xt_CONNMARK.c	2006-02-12 20:49:57.000000000 +0100
+++ net-2.6.git/net/netfilter/xt_CONNMARK.c	2006-02-12 22:41:12.000000000 +0100
@@ -72,7 +72,7 @@ target(struct sk_buff **pskb,
 }
 
 static int
-checkentry(const char *tablename,
+checkentry(int pf, const char *tablename,
 	   const void *entry,
 	   void *targinfo,
 	   unsigned int targinfosize,
Index: net-2.6.git/net/netfilter/xt_MARK.c
===================================================================
--- net-2.6.git.orig/net/netfilter/xt_MARK.c	2006-02-12 20:49:57.000000000 +0100
+++ net-2.6.git/net/netfilter/xt_MARK.c	2006-02-12 22:41:12.000000000 +0100
@@ -70,7 +70,7 @@ target_v1(struct sk_buff **pskb,
 
 
 static int
-checkentry_v0(const char *tablename,
+checkentry_v0(int pf, const char *tablename,
 	      const void *entry,
 	      void *targinfo,
 	      unsigned int targinfosize,
@@ -99,7 +99,7 @@ checkentry_v0(const char *tablename,
 }
 
 static int
-checkentry_v1(const char *tablename,
+checkentry_v1(int pf, const char *tablename,
 	      const void *entry,
 	      void *targinfo,
 	      unsigned int targinfosize,
Index: net-2.6.git/net/netfilter/xt_NFQUEUE.c
===================================================================
--- net-2.6.git.orig/net/netfilter/xt_NFQUEUE.c	2006-02-12 20:49:57.000000000 +0100
+++ net-2.6.git/net/netfilter/xt_NFQUEUE.c	2006-02-12 22:41:12.000000000 +0100
@@ -37,7 +37,7 @@ target(struct sk_buff **pskb,
 }
 
 static int
-checkentry(const char *tablename,
+checkentry(int pf, const char *tablename,
 	   const void *entry,
            void *targinfo,
            unsigned int targinfosize,
Index: net-2.6.git/net/netfilter/xt_NOTRACK.c
===================================================================
--- net-2.6.git.orig/net/netfilter/xt_NOTRACK.c	2006-02-12 20:49:57.000000000 +0100
+++ net-2.6.git/net/netfilter/xt_NOTRACK.c	2006-02-12 22:41:12.000000000 +0100
@@ -34,7 +34,7 @@ target(struct sk_buff **pskb,
 }
 
 static int
-checkentry(const char *tablename,
+checkentry(int pf, const char *tablename,
 	   const void *entry,
            void *targinfo,
            unsigned int targinfosize,
Index: net-2.6.git/net/netfilter/xt_comment.c
===================================================================
--- net-2.6.git.orig/net/netfilter/xt_comment.c	2006-02-12 20:49:57.000000000 +0100
+++ net-2.6.git/net/netfilter/xt_comment.c	2006-02-12 22:41:12.000000000 +0100
@@ -29,7 +29,7 @@ match(const struct sk_buff *skb,
 }
 
 static int
-checkentry(const char *tablename,
+checkentry(int pf, const char *tablename,
            const void *ip,
            void *matchinfo,
            unsigned int matchsize,
Index: net-2.6.git/net/netfilter/xt_connbytes.c
===================================================================
--- net-2.6.git.orig/net/netfilter/xt_connbytes.c	2006-02-12 20:49:57.000000000 +0100
+++ net-2.6.git/net/netfilter/xt_connbytes.c	2006-02-12 22:41:12.000000000 +0100
@@ -120,7 +120,7 @@ match(const struct sk_buff *skb,
 		return (what >= sinfo->count.from);
 }
 
-static int check(const char *tablename,
+static int check(int pf, const char *tablename,
 		 const void *ip,
 		 void *matchinfo,
 		 unsigned int matchsize,
Index: net-2.6.git/net/netfilter/xt_connmark.c
===================================================================
--- net-2.6.git.orig/net/netfilter/xt_connmark.c	2006-02-12 20:49:57.000000000 +0100
+++ net-2.6.git/net/netfilter/xt_connmark.c	2006-02-12 22:41:12.000000000 +0100
@@ -50,7 +50,7 @@ match(const struct sk_buff *skb,
 }
 
 static int
-checkentry(const char *tablename,
+checkentry(int pf, const char *tablename,
 	   const void *ip,
 	   void *matchinfo,
 	   unsigned int matchsize,
@@ -66,19 +66,32 @@ checkentry(const char *tablename,
 		return 0;
 	}
 
+	if (nf_ct_l3proto_try_module_get(pf) < 0) {
+		printk(KERN_WARNING "can't load nf_conntrack (%d)\n", pf);
+		return 0;
+	}
+
 	return 1;
 }
 
+static void
+destroy(int pf, void *matchinfo, unsigned int matchsize)
+{
+	nf_ct_l3proto_module_put(pf);
+}
+
 static struct xt_match connmark_match = {
 	.name = "connmark",
 	.match = &match,
 	.checkentry = &checkentry,
+	.destroy = &destroy,
 	.me = THIS_MODULE
 };
 static struct xt_match connmark6_match = {
 	.name = "connmark",
 	.match = &match,
 	.checkentry = &checkentry,
+	.destroy = &destroy,
 	.me = THIS_MODULE
 };
 
Index: net-2.6.git/net/netfilter/xt_conntrack.c
===================================================================
--- net-2.6.git.orig/net/netfilter/xt_conntrack.c	2006-02-12 20:49:57.000000000 +0100
+++ net-2.6.git/net/netfilter/xt_conntrack.c	2006-02-12 22:41:12.000000000 +0100
@@ -201,7 +201,7 @@ match(const struct sk_buff *skb,
 
 #endif /* CONFIG_NF_IP_CONNTRACK */
 
-static int check(const char *tablename,
+static int check(int pf, const char *tablename,
 		 const void *ip,
 		 void *matchinfo,
 		 unsigned int matchsize,
@@ -210,13 +210,24 @@ static int check(const char *tablename,
 	if (matchsize != XT_ALIGN(sizeof(struct xt_conntrack_info)))
 		return 0;
 
+	if (nf_ct_l3proto_try_module_get(pf) < 0) {
+		printk(KERN_WARNING "can't load nf_conntrack (%d)\n", pf);
+		return 0;
+	}
+
 	return 1;
 }
 
+static void destroy(int pf, void *matchinfo, unsigned int matchsize)
+{
+	nf_ct_l3proto_module_put(pf);
+}
+
 static struct xt_match conntrack_match = {
 	.name		= "conntrack",
 	.match		= &match,
 	.checkentry	= &check,
+	.destroy	= &destroy,
 	.me		= THIS_MODULE,
 };
 
Index: net-2.6.git/net/netfilter/xt_dccp.c
===================================================================
--- net-2.6.git.orig/net/netfilter/xt_dccp.c	2006-02-12 20:49:57.000000000 +0100
+++ net-2.6.git/net/netfilter/xt_dccp.c	2006-02-12 22:41:12.000000000 +0100
@@ -127,7 +127,7 @@ match(const struct sk_buff *skb,
 }
 
 static int
-checkentry(const char *tablename,
+checkentry(int pf, const char *tablename,
 	   const void *inf,
 	   void *matchinfo,
 	   unsigned int matchsize,
@@ -147,7 +147,7 @@ checkentry(const char *tablename,
 }
 
 static int
-checkentry6(const char *tablename,
+checkentry6(int pf, const char *tablename,
 	   const void *inf,
 	   void *matchinfo,
 	   unsigned int matchsize,
Index: net-2.6.git/net/netfilter/xt_helper.c
===================================================================
--- net-2.6.git.orig/net/netfilter/xt_helper.c	2006-02-12 20:49:57.000000000 +0100
+++ net-2.6.git/net/netfilter/xt_helper.c	2006-02-12 22:41:13.000000000 +0100
@@ -131,7 +131,7 @@ out_unlock:
 }
 #endif
 
-static int check(const char *tablename,
+static int check(int pf, const char *tablename,
 		 const void *inf,
 		 void *matchinfo,
 		 unsigned int matchsize,
@@ -145,19 +145,31 @@ static int check(const char *tablename,
 	if (matchsize != XT_ALIGN(sizeof(struct xt_helper_info)))
 		return 0;
 
+	if (nf_ct_l3proto_try_module_get(pf) < 0) {
+		printk(KERN_WARNING "can't load nf_conntrack (%d)\n", pf);
+		return 0;
+	}
+
 	return 1;
 }
 
+static void destroy(int pf, void *matchinfo, unsigned int matchsize)
+{
+	nf_ct_l3proto_module_put(pf);
+}
+
 static struct xt_match helper_match = {
 	.name		= "helper",
 	.match		= &match,
 	.checkentry	= &check,
+	.destroy	= &destroy,
 	.me		= THIS_MODULE,
 };
 static struct xt_match helper6_match = {
 	.name		= "helper",
 	.match		= &match,
 	.checkentry	= &check,
+	.destroy	= &destroy,
 	.me		= THIS_MODULE,
 };
 
Index: net-2.6.git/net/netfilter/xt_length.c
===================================================================
--- net-2.6.git.orig/net/netfilter/xt_length.c	2006-02-12 20:49:57.000000000 +0100
+++ net-2.6.git/net/netfilter/xt_length.c	2006-02-12 22:41:13.000000000 +0100
@@ -51,7 +51,7 @@ match6(const struct sk_buff *skb,
 }
 
 static int
-checkentry(const char *tablename,
+checkentry(int pf, const char *tablename,
            const void *ip,
            void *matchinfo,
            unsigned int matchsize,
Index: net-2.6.git/net/netfilter/xt_limit.c
===================================================================
--- net-2.6.git.orig/net/netfilter/xt_limit.c	2006-02-12 20:49:57.000000000 +0100
+++ net-2.6.git/net/netfilter/xt_limit.c	2006-02-12 22:41:13.000000000 +0100
@@ -105,7 +105,7 @@ user2credits(u_int32_t user)
 }
 
 static int
-ipt_limit_checkentry(const char *tablename,
+ipt_limit_checkentry(int pf, const char *tablename,
 		     const void *inf,
 		     void *matchinfo,
 		     unsigned int matchsize,
Index: net-2.6.git/net/netfilter/xt_mac.c
===================================================================
--- net-2.6.git.orig/net/netfilter/xt_mac.c	2006-02-12 20:49:57.000000000 +0100
+++ net-2.6.git/net/netfilter/xt_mac.c	2006-02-12 22:41:13.000000000 +0100
@@ -43,7 +43,7 @@ match(const struct sk_buff *skb,
 }
 
 static int
-ipt_mac_checkentry(const char *tablename,
+ipt_mac_checkentry(int pf, const char *tablename,
 		   const void *inf,
 		   void *matchinfo,
 		   unsigned int matchsize,
Index: net-2.6.git/net/netfilter/xt_mark.c
===================================================================
--- net-2.6.git.orig/net/netfilter/xt_mark.c	2006-02-12 20:49:57.000000000 +0100
+++ net-2.6.git/net/netfilter/xt_mark.c	2006-02-12 22:41:13.000000000 +0100
@@ -34,7 +34,7 @@ match(const struct sk_buff *skb,
 }
 
 static int
-checkentry(const char *tablename,
+checkentry(int pf, const char *tablename,
            const void *entry,
            void *matchinfo,
            unsigned int matchsize,
Index: net-2.6.git/net/netfilter/xt_physdev.c
===================================================================
--- net-2.6.git.orig/net/netfilter/xt_physdev.c	2006-02-12 20:49:57.000000000 +0100
+++ net-2.6.git/net/netfilter/xt_physdev.c	2006-02-12 22:41:13.000000000 +0100
@@ -100,7 +100,7 @@ match_outdev:
 }
 
 static int
-checkentry(const char *tablename,
+checkentry(int pf, const char *tablename,
 		       const void *ip,
 		       void *matchinfo,
 		       unsigned int matchsize,
Index: net-2.6.git/net/netfilter/xt_pkttype.c
===================================================================
--- net-2.6.git.orig/net/netfilter/xt_pkttype.c	2006-02-12 20:49:57.000000000 +0100
+++ net-2.6.git/net/netfilter/xt_pkttype.c	2006-02-12 22:41:13.000000000 +0100
@@ -32,7 +32,7 @@ static int match(const struct sk_buff *s
 	return (skb->pkt_type == info->pkttype) ^ info->invert;
 }
 
-static int checkentry(const char *tablename,
+static int checkentry(int pf, const char *tablename,
 		   const void *ip,
 		   void *matchinfo,
 		   unsigned int matchsize,
Index: net-2.6.git/net/netfilter/xt_realm.c
===================================================================
--- net-2.6.git.orig/net/netfilter/xt_realm.c	2006-02-12 20:49:57.000000000 +0100
+++ net-2.6.git/net/netfilter/xt_realm.c	2006-02-12 22:41:13.000000000 +0100
@@ -38,7 +38,7 @@ match(const struct sk_buff *skb,
 	return (info->id == (dst->tclassid & info->mask)) ^ info->invert;
 }
 
-static int check(const char *tablename,
+static int check(int pf, const char *tablename,
                  const void *ip,
                  void *matchinfo,
                  unsigned int matchsize,
Index: net-2.6.git/net/netfilter/xt_sctp.c
===================================================================
--- net-2.6.git.orig/net/netfilter/xt_sctp.c	2006-02-12 20:49:57.000000000 +0100
+++ net-2.6.git/net/netfilter/xt_sctp.c	2006-02-12 22:41:13.000000000 +0100
@@ -160,7 +160,7 @@ match(const struct sk_buff *skb,
 }
 
 static int
-checkentry(const char *tablename,
+checkentry(int pf, const char *tablename,
 	   const void *inf,
 	   void *matchinfo,
 	   unsigned int matchsize,
@@ -185,7 +185,7 @@ checkentry(const char *tablename,
 }
 
 static int
-checkentry6(const char *tablename,
+checkentry6(int pf, const char *tablename,
 	   const void *inf,
 	   void *matchinfo,
 	   unsigned int matchsize,
Index: net-2.6.git/net/netfilter/xt_state.c
===================================================================
--- net-2.6.git.orig/net/netfilter/xt_state.c	2006-02-12 20:49:57.000000000 +0100
+++ net-2.6.git/net/netfilter/xt_state.c	2006-02-12 22:41:13.000000000 +0100
@@ -43,7 +43,7 @@ match(const struct sk_buff *skb,
 	return (sinfo->statemask & statebit);
 }
 
-static int check(const char *tablename,
+static int check(int pf, const char *tablename,
 		 const void *ip,
 		 void *matchinfo,
 		 unsigned int matchsize,
@@ -52,13 +52,24 @@ static int check(const char *tablename,
 	if (matchsize != XT_ALIGN(sizeof(struct xt_state_info)))
 		return 0;
 
+	if (nf_ct_l3proto_try_module_get(pf) < 0) {
+		printk(KERN_WARNING "can't load nf_conntrack (%d)\n", pf);
+		return 0;
+	}
+
 	return 1;
 }
 
+static void destroy(int pf, void *matchinfo, unsigned int matchsize)
+{
+	nf_ct_l3proto_module_put(pf);
+}
+
 static struct xt_match state_match = {
 	.name		= "state",
 	.match		= &match,
 	.checkentry	= &check,
+	.destroy	= &destroy,
 	.me		= THIS_MODULE,
 };
 
@@ -66,6 +77,7 @@ static struct xt_match state6_match = {
 	.name		= "state",
 	.match		= &match,
 	.checkentry	= &check,
+	.destroy	= &destroy,
 	.me		= THIS_MODULE,
 };
 
Index: net-2.6.git/net/netfilter/xt_string.c
===================================================================
--- net-2.6.git.orig/net/netfilter/xt_string.c	2006-02-12 20:49:57.000000000 +0100
+++ net-2.6.git/net/netfilter/xt_string.c	2006-02-12 22:41:13.000000000 +0100
@@ -41,7 +41,7 @@ static int match(const struct sk_buff *s
 
 #define STRING_TEXT_PRIV(m) ((struct xt_string_info *) m)
 
-static int checkentry(const char *tablename,
+static int checkentry(int pf, const char *tablename,
 		      const void *ip,
 		      void *matchinfo,
 		      unsigned int matchsize,
Index: net-2.6.git/net/netfilter/xt_tcpmss.c
===================================================================
--- net-2.6.git.orig/net/netfilter/xt_tcpmss.c	2006-02-12 20:49:57.000000000 +0100
+++ net-2.6.git/net/netfilter/xt_tcpmss.c	2006-02-12 22:41:13.000000000 +0100
@@ -93,7 +93,7 @@ match(const struct sk_buff *skb,
 }
 
 static int
-checkentry(const char *tablename,
+checkentry(int pf, const char *tablename,
            const void *ipinfo,
            void *matchinfo,
            unsigned int matchsize,
@@ -113,7 +113,7 @@ checkentry(const char *tablename,
 }
 
 static int
-checkentry6(const char *tablename,
+checkentry6(int pf, const char *tablename,
 	   const void *ipinfo,
            void *matchinfo,
            unsigned int matchsize,
Index: net-2.6.git/net/netfilter/xt_tcpudp.c
===================================================================
--- net-2.6.git.orig/net/netfilter/xt_tcpudp.c	2006-02-12 20:49:57.000000000 +0100
+++ net-2.6.git/net/netfilter/xt_tcpudp.c	2006-02-12 22:41:13.000000000 +0100
@@ -136,7 +136,7 @@ tcp_match(const struct sk_buff *skb,
 
 /* Called when user tries to insert an entry of this type. */
 static int
-tcp_checkentry(const char *tablename,
+tcp_checkentry(int pf, const char *tablename,
 	       const void *info,
 	       void *matchinfo,
 	       unsigned int matchsize,
@@ -154,7 +154,7 @@ tcp_checkentry(const char *tablename,
 
 /* Called when user tries to insert an entry of this type. */
 static int
-tcp6_checkentry(const char *tablename,
+tcp6_checkentry(int pf, const char *tablename,
 	       const void *entry,
 	       void *matchinfo,
 	       unsigned int matchsize,
@@ -206,7 +206,7 @@ udp_match(const struct sk_buff *skb,
 
 /* Called when user tries to insert an entry of this type. */
 static int
-udp_checkentry(const char *tablename,
+udp_checkentry(int pf, const char *tablename,
 	       const void *info,
 	       void *matchinfo,
 	       unsigned int matchinfosize,
@@ -237,7 +237,7 @@ udp_checkentry(const char *tablename,
 
 /* Called when user tries to insert an entry of this type. */
 static int
-udp6_checkentry(const char *tablename,
+udp6_checkentry(int pf, const char *tablename,
 	       const void *entry,
 	       void *matchinfo,
 	       unsigned int matchinfosize,
Index: net-2.6.git/net/ipv4/netfilter/arp_tables.c
===================================================================
--- net-2.6.git.orig/net/ipv4/netfilter/arp_tables.c	2006-02-12 20:49:57.000000000 +0100
+++ net-2.6.git/net/ipv4/netfilter/arp_tables.c	2006-02-12 22:41:13.000000000 +0100
@@ -486,7 +486,8 @@ static inline int check_entry(struct arp
 			goto out;
 		}
 	} else if (t->u.kernel.target->checkentry
-		   && !t->u.kernel.target->checkentry(name, e, t->data,
+		   && !t->u.kernel.target->checkentry(PF_UNSPEC, name, 
+			   			      e, t->data,
 						      t->u.target_size
 						      - sizeof(*t),
 						      e->comefrom)) {
@@ -555,7 +556,7 @@ static inline int cleanup_entry(struct a
 
 	t = arpt_get_target(e);
 	if (t->u.kernel.target->destroy)
-		t->u.kernel.target->destroy(t->data,
+		t->u.kernel.target->destroy(PF_UNSPEC, t->data,
 					    t->u.target_size - sizeof(*t));
 	module_put(t->u.kernel.target->me);
 	return 0;
Index: net-2.6.git/net/sched/act_ipt.c
===================================================================
--- net-2.6.git.orig/net/sched/act_ipt.c	2006-02-12 20:49:57.000000000 +0100
+++ net-2.6.git/net/sched/act_ipt.c	2006-02-12 22:41:13.000000000 +0100
@@ -70,7 +70,7 @@ ipt_init_target(struct ipt_entry_target 
 	t->u.kernel.target = target;
 
 	if (t->u.kernel.target->checkentry
-	    && !t->u.kernel.target->checkentry(table, NULL, t->data,
+	    && !t->u.kernel.target->checkentry(PF_INET, table, NULL, t->data,
 					       t->u.target_size - sizeof(*t),
 					       hook)) {
 		DPRINTK("ipt_init_target: check failed for `%s'.\n",
@@ -86,7 +86,7 @@ static void
 ipt_destroy_target(struct ipt_entry_target *t)
 {
 	if (t->u.kernel.target->destroy)
-		t->u.kernel.target->destroy(t->data,
+		t->u.kernel.target->destroy(PF_INET, t->data,
 		                            t->u.target_size - sizeof(*t));
         module_put(t->u.kernel.target->me);
 }
Index: net-2.6.git/include/net/netfilter/nf_conntrack.h
===================================================================
--- net-2.6.git.orig/include/net/netfilter/nf_conntrack.h	2006-02-12 20:49:57.000000000 +0100
+++ net-2.6.git/include/net/netfilter/nf_conntrack.h	2006-02-12 22:41:13.000000000 +0100
@@ -196,6 +196,10 @@ static inline void nf_ct_put(struct nf_c
 	nf_conntrack_put(&ct->ct_general);
 }
 
+/* Protocol module loading */
+extern int nf_ct_l3proto_try_module_get(u_int16_t l3proto);
+extern void nf_ct_l3proto_module_put(u_int16_t l3proto);
+
 extern struct nf_conntrack_tuple_hash *
 __nf_conntrack_find(const struct nf_conntrack_tuple *tuple,
 		    const struct nf_conn *ignored_conntrack);

--------------000000080005040908020304--
