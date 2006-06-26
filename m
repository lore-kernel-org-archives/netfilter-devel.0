From: Massimiliano Hofer <max@nucleus.it>
Subject: [PATCH] priv_data 1/2
Date: Mon, 26 Jun 2006 16:43:07 +0200
Message-ID: <200606261643.08269.max@nucleus.it>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_8J/nE1eogl/0Qhw"
Cc: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

--Boundary-00=_8J/nE1eogl/0Qhw
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,
this is the first part. Modifications to the core netfilter code.

-- 
Saluti,
   Massimiliano Hofer

--Boundary-00=_8J/nE1eogl/0Qhw
Content-Type: text/x-diff; charset="us-ascii";
	name="01-2.6.17.1-priv_data-core.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="01-2.6.17.1-priv_data-core.patch"

diff -Nru linux-2.6.17.1/include/linux/netfilter/x_tables.h linux-2.6.17.1-priv_data-core/include/linux/netfilter/x_tables.h
--- linux-2.6.17.1/include/linux/netfilter/x_tables.h	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data-core/include/linux/netfilter/x_tables.h	2006-06-24 18:57:28.000000000 +0200
@@ -20,6 +20,7 @@
 
 			/* Used inside the kernel */
 			struct xt_match *match;
+			void *priv_data;
 		} kernel;
 
 		/* Total length */
@@ -45,6 +46,7 @@
 
 			/* Used inside the kernel */
 			struct xt_target *target;
+			void *priv_data;
 		} kernel;
 
 		/* Total length */
@@ -166,20 +168,22 @@
 		     const void *matchinfo,
 		     int offset,
 		     unsigned int protoff,
-		     int *hotdrop);
+		     int *hotdrop,
+		     void *priv_data);
 
 	/* Called when user tries to insert an entry of this type. */
 	/* Should return true or false. */
-	int (*checkentry)(const char *tablename,
-			  const void *ip,
-			  const struct xt_match *match,
-			  void *matchinfo,
-			  unsigned int matchinfosize,
-			  unsigned int hook_mask);
+	int (*init)(const char *tablename,
+		    const void *ip,
+		    const struct xt_match *match,
+		    void *matchinfo,
+		    unsigned int matchinfosize,
+		    unsigned int hook_mask,
+		    void *priv_data);
 
 	/* Called when entry of this type deleted. */
 	void (*destroy)(const struct xt_match *match, void *matchinfo,
-			unsigned int matchinfosize);
+			unsigned int matchinfosize, void *priv_data);
 
 	/* Called when userspace align differs from kernel space one */
 	int (*compat)(void *match, void **dstptr, int *size, int convert);
@@ -189,6 +193,7 @@
 
 	char *table;
 	unsigned int matchsize;
+	size_t priv_size;
 	unsigned int hooks;
 	unsigned short proto;
 
@@ -212,22 +217,24 @@
 			       unsigned int hooknum,
 			       const struct xt_target *target,
 			       const void *targinfo,
-			       void *userdata);
+			       void *userdata,
+			       void *priv_data);
 
 	/* Called when user tries to insert an entry of this type:
            hook_mask is a bitmask of hooks from which it can be
            called. */
 	/* Should return true or false. */
-	int (*checkentry)(const char *tablename,
+	int (*init)(const char *tablename,
 			  const void *entry,
 			  const struct xt_target *target,
 			  void *targinfo,
 			  unsigned int targinfosize,
-			  unsigned int hook_mask);
+			  unsigned int hook_mask,
+			  void *priv_data);
 
 	/* Called when entry of this type deleted. */
 	void (*destroy)(const struct xt_target *target, void *targinfo,
-			unsigned int targinfosize);
+			unsigned int targinfosize, void *priv_data);
 
 	/* Called when userspace align differs from kernel space one */
 	int (*compat)(void *target, void **dstptr, int *size, int convert);
@@ -237,6 +244,7 @@
 
 	char *table;
 	unsigned int targetsize;
+	size_t priv_size;
 	unsigned int hooks;
 	unsigned short proto;
 
@@ -293,12 +301,16 @@
 extern int xt_register_match(struct xt_match *target);
 extern void xt_unregister_match(struct xt_match *target);
 
-extern int xt_check_match(const struct xt_match *match, unsigned short family,
-			  unsigned int size, const char *table, unsigned int hook,
-			  unsigned short proto, int inv_proto);
-extern int xt_check_target(const struct xt_target *target, unsigned short family,
-			   unsigned int size, const char *table, unsigned int hook,
-			   unsigned short proto, int inv_proto);
+extern int xt_init_match(struct xt_entry_match *m, char *module_prefix,
+			 unsigned short family, const char *table,
+			 unsigned int hook_mask, unsigned short proto,
+			 int inv_proto);
+extern void xt_destroy_match(struct xt_entry_match *m);
+extern int xt_init_target(struct xt_entry_target *t, char *module_prefix,
+			  unsigned short family, const char *table,
+			  unsigned int hook_mask, unsigned short proto,
+			  int inv_proto);
+extern void xt_destroy_target(struct xt_entry_target *t);
 
 extern int xt_register_table(struct xt_table *table,
 			     struct xt_table_info *bootstrap,
diff -Nru linux-2.6.17.1/net/ipv4/netfilter/arp_tables.c linux-2.6.17.1-priv_data-core/net/ipv4/netfilter/arp_tables.c
--- linux-2.6.17.1/net/ipv4/netfilter/arp_tables.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data-core/net/ipv4/netfilter/arp_tables.c	2006-06-25 00:23:58.000000000 +0200
@@ -210,7 +210,8 @@
 			       unsigned int hooknum,
 			       const struct xt_target *target,
 			       const void *targinfo,
-			       void *userinfo)
+			       void *userinfo,
+			       void *priv_data)
 {
 	if (net_ratelimit())
 		printk("arp_tables: error: '%s'\n", (char *)targinfo);
@@ -299,11 +300,10 @@
 				 * abs. verdicts
 				 */
 				verdict = t->u.kernel.target->target(pskb,
-								     in, out,
-								     hook,
-								     t->u.kernel.target,
-								     t->data,
-								     userdata);
+						in, out, hook,
+						t->u.kernel.target,
+						t->data, userdata,
+						t->u.kernel.priv_data);
 
 				/* Target might have changed stuff. */
 				arp = (*pskb)->nh.arph;
@@ -459,11 +459,10 @@
 
 static struct arpt_target arpt_standard_target;
 
-static inline int check_entry(struct arpt_entry *e, const char *name, unsigned int size,
-			      unsigned int *i)
+static inline int init_entry(struct arpt_entry *e, const char *name, unsigned int size,
+			     unsigned int *i)
 {
 	struct arpt_entry_target *t;
-	struct arpt_target *target;
 	int ret;
 
 	if (!arp_checkentry(&e->arp)) {
@@ -472,18 +471,10 @@
 	}
 
 	t = arpt_get_target(e);
-	target = try_then_request_module(xt_find_target(NF_ARP, t->u.user.name,
-							t->u.user.revision),
-					 "arpt_%s", t->u.user.name);
-	if (IS_ERR(target) || !target) {
-		duprintf("check_entry: `%s' not found\n", t->u.user.name);
-		ret = target ? PTR_ERR(target) : -ENOENT;
-		goto out;
-	}
-	t->u.kernel.target = target;
 
-	ret = xt_check_target(target, NF_ARP, t->u.target_size - sizeof(*t),
-			      name, e->comefrom, 0, 0);
+	ret = xt_init_target(t, "arpt", NF_ARP,
+			     name, e->comefrom, 0, 0);
+
 	if (ret)
 		goto err;
 
@@ -492,11 +483,12 @@
 			ret = -EINVAL;
 			goto out;
 		}
-	} else if (t->u.kernel.target->checkentry
-		   && !t->u.kernel.target->checkentry(name, e, target, t->data,
-						      t->u.target_size
-						      - sizeof(*t),
-						      e->comefrom)) {
+	} else if (t->u.kernel.target->init
+		   && !t->u.kernel.target->init(name, e, t->u.kernel.target,
+		   				t->data,
+						t->u.target_size - sizeof(*t),
+						e->comefrom,
+						t->u.kernel.priv_data)) {
 		duprintf("arp_tables: check failed for `%s'.\n",
 			 t->u.kernel.target->name);
 		ret = -EINVAL;
@@ -506,7 +498,7 @@
 	(*i)++;
 	return 0;
 err:
-	module_put(t->u.kernel.target->me);
+	xt_destroy_target(t);
 out:
 	return ret;
 }
@@ -563,8 +555,9 @@
 	t = arpt_get_target(e);
 	if (t->u.kernel.target->destroy)
 		t->u.kernel.target->destroy(t->u.kernel.target, t->data,
-					    t->u.target_size - sizeof(*t));
-	module_put(t->u.kernel.target->me);
+					    t->u.target_size - sizeof(*t),
+					    t->u.kernel.priv_data);
+	xt_destroy_target(t);
 	return 0;
 }
 
@@ -637,7 +630,7 @@
 	/* Finally, each sanity check must pass */
 	i = 0;
 	ret = ARPT_ENTRY_ITERATE(entry0, newinfo->size,
-				 check_entry, name, size, &i);
+				 init_entry, name, size, &i);
 
 	if (ret != 0) {
 		ARPT_ENTRY_ITERATE(entry0, newinfo->size,
diff -Nru linux-2.6.17.1/net/ipv4/netfilter/ip_tables.c linux-2.6.17.1-priv_data-core/net/ipv4/netfilter/ip_tables.c
--- linux-2.6.17.1/net/ipv4/netfilter/ip_tables.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data-core/net/ipv4/netfilter/ip_tables.c	2006-06-25 00:31:31.000000000 +0200
@@ -182,7 +182,8 @@
 	  unsigned int hooknum,
 	  const struct xt_target *target,
 	  const void *targinfo,
-	  void *userinfo)
+	  void *userinfo,
+	  void *priv_data)
 {
 	if (net_ratelimit())
 		printk("ip_tables: error: `%s'\n", (char *)targinfo);
@@ -200,7 +201,8 @@
 {
 	/* Stop iteration if it doesn't match */
 	if (!m->u.kernel.match->match(skb, in, out, m->u.kernel.match, m->data,
-				      offset, skb->nh.iph->ihl*4, hotdrop))
+				      offset, skb->nh.iph->ihl*4, hotdrop,
+				      m->u.kernel.priv_data))
 		return 1;
 	else
 		return 0;
@@ -304,12 +306,11 @@
 				((struct ipt_entry *)table_base)->comefrom
 					= 0xeeeeeeec;
 #endif
-				verdict = t->u.kernel.target->target(pskb,
-								     in, out,
-								     hook,
-								     t->u.kernel.target,
-								     t->data,
-								     userdata);
+				verdict = t->u.kernel.target->target(
+						pskb, in, out, hook,
+						t->u.kernel.target,
+						t->data, userdata,
+						t->u.kernel.priv_data);
 
 #ifdef CONFIG_NETFILTER_DEBUG
 				if (((struct ipt_entry *)table_base)->comefrom
@@ -468,8 +469,9 @@
 
 	if (m->u.kernel.match->destroy)
 		m->u.kernel.match->destroy(m->u.kernel.match, m->data,
-					   m->u.match_size - sizeof(*m));
-	module_put(m->u.kernel.match->me);
+					   m->u.match_size - sizeof(*m),
+					   m->u.kernel.priv_data);
+	xt_destroy_match(m);
 	return 0;
 }
 
@@ -495,34 +497,25 @@
 }
 
 static inline int
-check_match(struct ipt_entry_match *m,
-	    const char *name,
-	    const struct ipt_ip *ip,
-	    unsigned int hookmask,
-	    unsigned int *i)
+init_match(struct ipt_entry_match *m,
+	   const char *name,
+	   const struct ipt_ip *ip,
+	   unsigned int hookmask,
+	   unsigned int *i)
 {
-	struct ipt_match *match;
 	int ret;
 
-	match = try_then_request_module(xt_find_match(AF_INET, m->u.user.name,
-						   m->u.user.revision),
-					"ipt_%s", m->u.user.name);
-	if (IS_ERR(match) || !match) {
-		duprintf("check_match: `%s' not found\n", m->u.user.name);
-		return match ? PTR_ERR(match) : -ENOENT;
-	}
-	m->u.kernel.match = match;
-
-	ret = xt_check_match(match, AF_INET, m->u.match_size - sizeof(*m),
-			     name, hookmask, ip->proto,
-			     ip->invflags & IPT_INV_PROTO);
+	ret = xt_init_match(m, "ipt", AF_INET,
+			    name, hookmask, ip->proto,
+			    ip->invflags & IPT_INV_PROTO);
 	if (ret)
 		goto err;
 
-	if (m->u.kernel.match->checkentry
-	    && !m->u.kernel.match->checkentry(name, ip, match, m->data,
-					      m->u.match_size - sizeof(*m),
-					      hookmask)) {
+	if (m->u.kernel.match->init
+	    && !m->u.kernel.match->init(name, ip, m->u.kernel.match,
+	    				m->data,
+					m->u.match_size - sizeof(*m),
+					hookmask, m->u.kernel.priv_data)) {
 		duprintf("ip_tables: check failed for `%s'.\n",
 			 m->u.kernel.match->name);
 		ret = -EINVAL;
@@ -532,18 +525,17 @@
 	(*i)++;
 	return 0;
 err:
-	module_put(m->u.kernel.match->me);
+	xt_destroy_match(m);
 	return ret;
 }
 
 static struct ipt_target ipt_standard_target;
 
 static inline int
-check_entry(struct ipt_entry *e, const char *name, unsigned int size,
-	    unsigned int *i)
+init_entry(struct ipt_entry *e, const char *name, unsigned int size,
+	   unsigned int *i)
 {
 	struct ipt_entry_target *t;
-	struct ipt_target *target;
 	int ret;
 	unsigned int j;
 
@@ -553,25 +545,15 @@
 	}
 
 	j = 0;
-	ret = IPT_MATCH_ITERATE(e, check_match, name, &e->ip, e->comefrom, &j);
+	ret = IPT_MATCH_ITERATE(e, init_match, name, &e->ip, e->comefrom, &j);
 	if (ret != 0)
 		goto cleanup_matches;
 
 	t = ipt_get_target(e);
-	target = try_then_request_module(xt_find_target(AF_INET,
-						     t->u.user.name,
-						     t->u.user.revision),
-					 "ipt_%s", t->u.user.name);
-	if (IS_ERR(target) || !target) {
-		duprintf("check_entry: `%s' not found\n", t->u.user.name);
-		ret = target ? PTR_ERR(target) : -ENOENT;
-		goto cleanup_matches;
-	}
-	t->u.kernel.target = target;
 
-	ret = xt_check_target(target, AF_INET, t->u.target_size - sizeof(*t),
-			      name, e->comefrom, e->ip.proto,
-			      e->ip.invflags & IPT_INV_PROTO);
+	ret = xt_init_target(t, "ipt", AF_INET,
+			     name, e->comefrom, e->ip.proto,
+			     e->ip.invflags & IPT_INV_PROTO);
 	if (ret)
 		goto err;
 
@@ -580,11 +562,12 @@
 			ret = -EINVAL;
 			goto cleanup_matches;
 		}
-	} else if (t->u.kernel.target->checkentry
-		   && !t->u.kernel.target->checkentry(name, e, target, t->data,
-						      t->u.target_size
-						      - sizeof(*t),
-						      e->comefrom)) {
+	} else if (t->u.kernel.target->init
+		   && !t->u.kernel.target->init(name, e, t->u.kernel.target,
+						t->data,
+						t->u.target_size - sizeof(*t),
+						e->comefrom,
+						t->u.kernel.priv_data)) {
 		duprintf("ip_tables: check failed for `%s'.\n",
 			 t->u.kernel.target->name);
 		ret = -EINVAL;
@@ -594,7 +577,7 @@
 	(*i)++;
 	return 0;
  err:
-	module_put(t->u.kernel.target->me);
+	xt_destroy_target(t);
  cleanup_matches:
 	IPT_MATCH_ITERATE(e, cleanup_match, &j);
 	return ret;
@@ -656,8 +639,9 @@
 	t = ipt_get_target(e);
 	if (t->u.kernel.target->destroy)
 		t->u.kernel.target->destroy(t->u.kernel.target, t->data,
-					    t->u.target_size - sizeof(*t));
-	module_put(t->u.kernel.target->me);
+					    t->u.target_size - sizeof(*t),
+					    t->u.kernel.priv_data);
+	xt_destroy_target(t);
 	return 0;
 }
 
@@ -726,7 +710,7 @@
 	/* Finally, each sanity check must pass */
 	i = 0;
 	ret = IPT_ENTRY_ITERATE(entry0, newinfo->size,
-				check_entry, name, size, &i);
+				init_entry, name, size, &i);
 
 	if (ret != 0) {
 		IPT_ENTRY_ITERATE(entry0, newinfo->size,
@@ -1545,7 +1529,7 @@
 						     t->u.user.revision),
 					 "ipt_%s", t->u.user.name);
 	if (IS_ERR(target) || !target) {
-		duprintf("check_entry: `%s' not found\n", t->u.user.name);
+		duprintf("init_entry: `%s' not found\n", t->u.user.name);
 		ret = target ? PTR_ERR(target) : -ENOENT;
 		goto out;
 	}
@@ -1600,10 +1584,10 @@
 	if (ret)
 		return ret;
 
-	if (m->u.kernel.match->checkentry
-	    && !m->u.kernel.match->checkentry(name, ip, match, dm->data,
-					      dm->u.match_size - sizeof(*dm),
-					      hookmask)) {
+	if (m->u.kernel.match->init
+	    && !m->u.kernel.match->init(name, ip, match, dm->data,
+					dm->u.match_size - sizeof(*dm),
+					hookmask)) {
 		duprintf("ip_tables: check failed for `%s'.\n",
 			 m->u.kernel.match->name);
 		return -EINVAL;
@@ -2152,7 +2136,8 @@
 	   const void *matchinfo,
 	   int offset,
 	   unsigned int protoff,
-	   int *hotdrop)
+	   int *hotdrop,
+	   void *priv_data)
 {
 	struct icmphdr _icmph, *ic;
 	const struct ipt_icmp *icmpinfo = matchinfo;
@@ -2180,12 +2165,13 @@
 
 /* Called when user tries to insert an entry of this type. */
 static int
-icmp_checkentry(const char *tablename,
-	   const void *info,
-	   const struct xt_match *match,
-	   void *matchinfo,
-	   unsigned int matchsize,
-	   unsigned int hook_mask)
+icmp_init(const char *tablename,
+	  const void *info,
+	  const struct xt_match *match,
+	  void *matchinfo,
+	  unsigned int matchsize,
+	  unsigned int hook_mask,
+	  void *priv_data)
 {
 	const struct ipt_icmp *icmpinfo = matchinfo;
 
@@ -2232,7 +2218,7 @@
 	.matchsize	= sizeof(struct ipt_icmp),
 	.proto		= IPPROTO_ICMP,
 	.family		= AF_INET,
-	.checkentry	= icmp_checkentry,
+	.init		= icmp_init,
 };
 
 static int __init ip_tables_init(void)
diff -Nru linux-2.6.17.1/net/ipv6/netfilter/ip6_tables.c linux-2.6.17.1-priv_data-core/net/ipv6/netfilter/ip6_tables.c
--- linux-2.6.17.1/net/ipv6/netfilter/ip6_tables.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data-core/net/ipv6/netfilter/ip6_tables.c	2006-06-25 00:23:54.000000000 +0200
@@ -221,7 +221,8 @@
 	  unsigned int hooknum,
 	  const struct xt_target *target,
 	  const void *targinfo,
-	  void *userinfo)
+	  void *userinfo,
+	  void *priv_data)
 {
 	if (net_ratelimit())
 		printk("ip6_tables: error: `%s'\n", (char *)targinfo);
@@ -240,7 +241,8 @@
 {
 	/* Stop iteration if it doesn't match */
 	if (!m->u.kernel.match->match(skb, in, out, m->u.kernel.match, m->data,
-				      offset, protoff, hotdrop))
+				      offset, protoff, hotdrop,
+				      m->u.kernel.priv_data))
 		return 1;
 	else
 		return 0;
@@ -345,12 +347,11 @@
 				((struct ip6t_entry *)table_base)->comefrom
 					= 0xeeeeeeec;
 #endif
-				verdict = t->u.kernel.target->target(pskb,
-								     in, out,
-								     hook,
-								     t->u.kernel.target,
-								     t->data,
-								     userdata);
+				verdict = t->u.kernel.target->target(
+						pskb, in, out, hook,
+						t->u.kernel.target,
+						t->data, userdata,
+						t->u.kernel.priv_data);
 
 #ifdef CONFIG_NETFILTER_DEBUG
 				if (((struct ip6t_entry *)table_base)->comefrom
@@ -508,8 +509,9 @@
 
 	if (m->u.kernel.match->destroy)
 		m->u.kernel.match->destroy(m->u.kernel.match, m->data,
-					   m->u.match_size - sizeof(*m));
-	module_put(m->u.kernel.match->me);
+					   m->u.match_size - sizeof(*m),
+					   m->u.kernel.priv_data);
+	xt_destroy_match(m);
 	return 0;
 }
 
@@ -535,34 +537,25 @@
 }
 
 static inline int
-check_match(struct ip6t_entry_match *m,
-	    const char *name,
-	    const struct ip6t_ip6 *ipv6,
-	    unsigned int hookmask,
-	    unsigned int *i)
+init_match(struct ip6t_entry_match *m,
+	   const char *name,
+	   const struct ip6t_ip6 *ipv6,
+	   unsigned int hookmask,
+	   unsigned int *i)
 {
-	struct ip6t_match *match;
 	int ret;
 
-	match = try_then_request_module(xt_find_match(AF_INET6, m->u.user.name,
-			      		m->u.user.revision),
-					"ip6t_%s", m->u.user.name);
-	if (IS_ERR(match) || !match) {
-	  	duprintf("check_match: `%s' not found\n", m->u.user.name);
-		return match ? PTR_ERR(match) : -ENOENT;
-	}
-	m->u.kernel.match = match;
-
-	ret = xt_check_match(match, AF_INET6, m->u.match_size - sizeof(*m),
-			     name, hookmask, ipv6->proto,
-			     ipv6->invflags & IP6T_INV_PROTO);
+	ret = xt_init_match(m, "ip6t", AF_INET6,
+			    name, hookmask, ipv6->proto,
+			    ipv6->invflags & IP6T_INV_PROTO);
 	if (ret)
 		goto err;
 
-	if (m->u.kernel.match->checkentry
-	    && !m->u.kernel.match->checkentry(name, ipv6, match,  m->data,
-					      m->u.match_size - sizeof(*m),
-					      hookmask)) {
+	if (m->u.kernel.match->init
+	    && !m->u.kernel.match->init(name, ipv6, m->u.kernel.match,
+	    				m->data,
+					m->u.match_size - sizeof(*m),
+					hookmask, m->u.kernel.priv_data)) {
 		duprintf("ip_tables: check failed for `%s'.\n",
 			 m->u.kernel.match->name);
 		ret = -EINVAL;
@@ -572,18 +565,17 @@
 	(*i)++;
 	return 0;
 err:
-	module_put(m->u.kernel.match->me);
+	xt_destroy_match(m);
 	return ret;
 }
 
 static struct ip6t_target ip6t_standard_target;
 
 static inline int
-check_entry(struct ip6t_entry *e, const char *name, unsigned int size,
-	    unsigned int *i)
+init_entry(struct ip6t_entry *e, const char *name, unsigned int size,
+	   unsigned int *i)
 {
 	struct ip6t_entry_target *t;
-	struct ip6t_target *target;
 	int ret;
 	unsigned int j;
 
@@ -593,25 +585,15 @@
 	}
 
 	j = 0;
-	ret = IP6T_MATCH_ITERATE(e, check_match, name, &e->ipv6, e->comefrom, &j);
+	ret = IP6T_MATCH_ITERATE(e, init_match, name, &e->ipv6, e->comefrom, &j);
 	if (ret != 0)
 		goto cleanup_matches;
 
 	t = ip6t_get_target(e);
-	target = try_then_request_module(xt_find_target(AF_INET6,
-							t->u.user.name,
-							t->u.user.revision),
-					 "ip6t_%s", t->u.user.name);
-	if (IS_ERR(target) || !target) {
-		duprintf("check_entry: `%s' not found\n", t->u.user.name);
-		ret = target ? PTR_ERR(target) : -ENOENT;
-		goto cleanup_matches;
-	}
-	t->u.kernel.target = target;
 
-	ret = xt_check_target(target, AF_INET6, t->u.target_size - sizeof(*t),
-			      name, e->comefrom, e->ipv6.proto,
-			      e->ipv6.invflags & IP6T_INV_PROTO);
+	ret = xt_init_target(t, "ip6t", AF_INET6,
+			     name, e->comefrom, e->ipv6.proto,
+			     e->ipv6.invflags & IP6T_INV_PROTO);
 	if (ret)
 		goto err;
 
@@ -620,11 +602,12 @@
 			ret = -EINVAL;
 			goto cleanup_matches;
 		}
-	} else if (t->u.kernel.target->checkentry
-		   && !t->u.kernel.target->checkentry(name, e, target, t->data,
-						      t->u.target_size
-						      - sizeof(*t),
-						      e->comefrom)) {
+	} else if (t->u.kernel.target->init
+		   && !t->u.kernel.target->init(name, e, t->u.kernel.target,
+		   				t->data,
+						t->u.target_size - sizeof(*t),
+						e->comefrom,
+						t->u.kernel.priv_data)) {
 		duprintf("ip_tables: check failed for `%s'.\n",
 			 t->u.kernel.target->name);
 		ret = -EINVAL;
@@ -634,7 +617,7 @@
 	(*i)++;
 	return 0;
  err:
-	module_put(t->u.kernel.target->me);
+	xt_destroy_target(t);
  cleanup_matches:
 	IP6T_MATCH_ITERATE(e, cleanup_match, &j);
 	return ret;
@@ -696,8 +679,9 @@
 	t = ip6t_get_target(e);
 	if (t->u.kernel.target->destroy)
 		t->u.kernel.target->destroy(t->u.kernel.target, t->data,
-					    t->u.target_size - sizeof(*t));
-	module_put(t->u.kernel.target->me);
+					    t->u.target_size - sizeof(*t),
+					    t->u.kernel.priv_data);
+	xt_destroy_target(t);
 	return 0;
 }
 
@@ -766,7 +750,7 @@
 	/* Finally, each sanity check must pass */
 	i = 0;
 	ret = IP6T_ENTRY_ITERATE(entry0, newinfo->size,
-				check_entry, name, size, &i);
+				 init_entry, name, size, &i);
 
 	if (ret != 0) {
 		IP6T_ENTRY_ITERATE(entry0, newinfo->size,
@@ -1320,7 +1304,8 @@
 	   const void *matchinfo,
 	   int offset,
 	   unsigned int protoff,
-	   int *hotdrop)
+	   int *hotdrop,
+	   void *priv_data)
 {
 	struct icmp6hdr _icmp, *ic;
 	const struct ip6t_icmp *icmpinfo = matchinfo;
@@ -1347,12 +1332,13 @@
 
 /* Called when user tries to insert an entry of this type. */
 static int
-icmp6_checkentry(const char *tablename,
+icmp6_init(const char *tablename,
 	   const void *entry,
 	   const struct xt_match *match,
 	   void *matchinfo,
 	   unsigned int matchsize,
-	   unsigned int hook_mask)
+	   unsigned int hook_mask,
+	   void *priv_data)
 {
 	const struct ip6t_icmp *icmpinfo = matchinfo;
 
@@ -1388,7 +1374,7 @@
 	.name		= "icmp6",
 	.match		= &icmp6_match,
 	.matchsize	= sizeof(struct ip6t_icmp),
-	.checkentry	= icmp6_checkentry,
+	.init		= icmp6_init,
 	.proto		= IPPROTO_ICMPV6,
 	.family		= AF_INET6,
 };
diff -Nru linux-2.6.17.1/net/netfilter/x_tables.c linux-2.6.17.1-priv_data-core/net/netfilter/x_tables.c
--- linux-2.6.17.1/net/netfilter/x_tables.c	2006-06-20 11:31:55.000000000 +0200
+++ linux-2.6.17.1-priv_data-core/net/netfilter/x_tables.c	2006-06-25 00:23:52.000000000 +0200
@@ -244,10 +244,27 @@
 }
 EXPORT_SYMBOL_GPL(xt_find_revision);
 
-int xt_check_match(const struct xt_match *match, unsigned short family,
-                   unsigned int size, const char *table, unsigned int hook_mask,
-		   unsigned short proto, int inv_proto)
-{
+int xt_init_match(struct xt_entry_match *m, char *module_prefix,
+		  unsigned short family, const char *table,
+		  unsigned int hook_mask,
+		  unsigned short proto, int inv_proto)
+{
+	struct xt_match *match;
+	unsigned int size = (m->u.match_size - sizeof(*m));
+
+	match = try_then_request_module(xt_find_match(family, m->u.user.name,
+						   m->u.user.revision),
+					"%s_%s",
+					module_prefix, m->u.user.name);
+	if (IS_ERR(match) || !match) {
+		duprintf("init_match: `%s' not found\n", m->u.user.name);
+		m->u.kernel.match = NULL;
+		m->u.kernel.priv_data = NULL;
+		return match ? PTR_ERR(match) : -ENOENT;
+	}
+	m->u.kernel.match = match;
+	m->u.kernel.priv_data = NULL;
+
 	if (XT_ALIGN(match->matchsize) != size) {
 		printk("%s_tables: %s match: invalid size %Zu != %u\n",
 		       xt_prefix[family], match->name,
@@ -269,9 +286,30 @@
 		       xt_prefix[family], match->name, match->proto);
 		return -EINVAL;
 	}
+
+	if (match->priv_size) {
+		m->u.kernel.priv_data = kzalloc(match->priv_size,
+						GFP_KERNEL);
+		if (!m->u.kernel.priv_data) {
+			printk("%s_tables: %s match: "
+			       "unable to allocate memory\n",
+			       xt_prefix[family], match->name);
+			return -ENOMEM;
+		}
+	}
+
 	return 0;
 }
-EXPORT_SYMBOL_GPL(xt_check_match);
+EXPORT_SYMBOL_GPL(xt_init_match);
+
+void xt_destroy_match(struct xt_entry_match *m)
+{
+	BUG_ON(!m);
+	kfree(m->u.kernel.priv_data);
+	if (m->u.kernel.match)
+		module_put(m->u.kernel.match->me);
+}
+EXPORT_SYMBOL_GPL(xt_destroy_match);
 
 #ifdef CONFIG_COMPAT
 int xt_compat_match(void *match, void **dstptr, int *size, int convert)
@@ -321,10 +359,28 @@
 EXPORT_SYMBOL_GPL(xt_compat_match);
 #endif
 
-int xt_check_target(const struct xt_target *target, unsigned short family,
-		    unsigned int size, const char *table, unsigned int hook_mask,
-		    unsigned short proto, int inv_proto)
+int xt_init_target(struct xt_entry_target *t, char *module_prefix,
+		   unsigned short family, const char *table,
+		   unsigned int hook_mask, unsigned short proto,
+		   int inv_proto)
 {
+	struct xt_target *target;
+	unsigned int size = t->u.target_size - sizeof(*t);
+	
+	target = try_then_request_module(xt_find_target(family,
+						     t->u.user.name,
+						     t->u.user.revision),
+					 "%s_%s",
+					 module_prefix, t->u.user.name);
+	if (IS_ERR(target) || !target) {
+		duprintf("init_target: `%s' not found\n", t->u.user.name);
+		t->u.kernel.target = NULL;
+		t->u.kernel.priv_data = NULL;
+		return target ? PTR_ERR(target) : -ENOENT;
+	}
+	t->u.kernel.target = target;
+	t->u.kernel.priv_data = NULL;
+
 	if (XT_ALIGN(target->targetsize) != size) {
 		printk("%s_tables: %s target: invalid size %Zu != %u\n",
 		       xt_prefix[family], target->name,
@@ -346,9 +402,30 @@
 		       xt_prefix[family], target->name, target->proto);
 		return -EINVAL;
 	}
+
+	if (target->priv_size) {
+		t->u.kernel.priv_data = kzalloc(target->priv_size,
+						GFP_KERNEL);
+		if (!t->u.kernel.priv_data) {
+			printk("%s_tables: %s target: "
+			       "unable to allocate memory\n",
+			       xt_prefix[family], target->name);
+			return -ENOMEM;
+		}
+	}
+
 	return 0;
 }
-EXPORT_SYMBOL_GPL(xt_check_target);
+EXPORT_SYMBOL_GPL(xt_init_target);
+
+void xt_destroy_target(struct xt_entry_target *t)
+{
+	BUG_ON(!t);
+	kfree(t->u.kernel.priv_data);
+	if (t->u.kernel.target)
+		module_put(t->u.kernel.target->me);
+}
+EXPORT_SYMBOL_GPL(xt_destroy_target);
 
 #ifdef CONFIG_COMPAT
 int xt_compat_target(void *target, void **dstptr, int *size, int convert)

--Boundary-00=_8J/nE1eogl/0Qhw--
