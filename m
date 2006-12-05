From: Massimiliano Hofer <max@nucleus.it>
Subject: [PATCH 2/4][data-condition]: instance data support in targets'
	prototypes and structures
Date: Tue, 5 Dec 2006 23:16:12 +0100
Message-ID: <200612052316.13419.max@nucleus.it>
References: <200612052312.28824.max@nucleus.it>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <200612052312.28824.max@nucleus.it>
Content-Disposition: inline
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

=46rom cb9bace80424e5835778634778047806ac104710 Mon Sep 17 00:00:00 2001
=46rom: Massimiliano Hofer <max@nucleus.it>
Date: Tue, 5 Dec 2006 22:51:12 +0100
Subject: [PATCH] [NETFILTER]: instance data support in targets' prototypes =
and structures

This patch adds support for instance specific data in targets.
Only prototype and structure changes are included here.
The real code will come in a separate patch.

Signed-off-by: Massimiliano Hofer <max@nucleus.it>
=2D--
 include/linux/netfilter/x_tables.h  |   25 ++++++++++++++---------
 net/ipv4/netfilter/arp_tables.c     |   21 ++++++++++++-------
 net/ipv4/netfilter/arpt_mangle.c    |    8 +++---
 net/ipv4/netfilter/ip_nat_rule.c    |   32 +++++++++++++++++-------------
 net/ipv4/netfilter/ip_tables.c      |   37 ++++++++++++++++++++-----------=
=2D--
 net/ipv4/netfilter/ipt_CLUSTERIP.c  |   19 ++++++++++-------
 net/ipv4/netfilter/ipt_ECN.c        |   16 ++++++++------
 net/ipv4/netfilter/ipt_LOG.c        |   24 ++++++++++++----------
 net/ipv4/netfilter/ipt_MASQUERADE.c |   16 ++++++++------
 net/ipv4/netfilter/ipt_NETMAP.c     |   16 ++++++++------
 net/ipv4/netfilter/ipt_REDIRECT.c   |   16 ++++++++------
 net/ipv4/netfilter/ipt_REJECT.c     |   16 ++++++++------
 net/ipv4/netfilter/ipt_SAME.c       |   18 +++++++++-------
 net/ipv4/netfilter/ipt_TCPMSS.c     |   24 ++++++++++++----------
 net/ipv4/netfilter/ipt_TOS.c        |   16 ++++++++------
 net/ipv4/netfilter/ipt_TTL.c        |   23 +++++++++++----------
 net/ipv4/netfilter/ipt_ULOG.c       |   24 ++++++++++++----------
 net/ipv4/netfilter/nf_nat_rule.c    |   32 +++++++++++++++++-------------
 net/ipv6/netfilter/ip6_tables.c     |   23 +++++++++++++--------
 net/ipv6/netfilter/ip6t_HL.c        |   24 ++++++++++++----------
 net/ipv6/netfilter/ip6t_LOG.c       |   24 ++++++++++++----------
 net/ipv6/netfilter/ip6t_REJECT.c    |   24 ++++++++++++----------
 net/netfilter/x_tables.c            |    8 +++---
 net/netfilter/xt_CLASSIFY.c         |    3 +-
 net/netfilter/xt_CONNMARK.c         |   18 +++++++++-------
 net/netfilter/xt_CONNSECMARK.c      |   12 +++++-----
 net/netfilter/xt_DSCP.c             |   21 +++++++++++--------
 net/netfilter/xt_MARK.c             |   34 ++++++++++++++++++--------------
 net/netfilter/xt_NFLOG.c            |   12 +++++-----
 net/netfilter/xt_NFQUEUE.c          |    3 +-
 net/netfilter/xt_NOTRACK.c          |    3 +-
 net/netfilter/xt_SECMARK.c          |   12 +++++-----
 32 files changed, 338 insertions(+), 266 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x=
_tables.h
index 73147b4..17aa03b 100644
=2D-- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -46,6 +46,7 @@ struct xt_entry_target
=20
 			/* Used inside the kernel */
 			struct xt_target *target;
+			void *data;
 		} kernel;
=20
 		/* Total length */
@@ -193,20 +194,23 @@ struct xt_target
 			       const struct net_device *out,
 			       unsigned int hooknum,
 			       const struct xt_target *target,
=2D			       const void *targinfo);
+			       const void *targinfo,
+			       void *data);
=20
 	/* Called when user tries to insert an entry of this type:
            hook_mask is a bitmask of hooks from which it can be
            called. */
 	/* Should return true or false. */
=2D	int (*checkentry)(const char *tablename,
=2D			  const void *entry,
=2D			  const struct xt_target *target,
=2D			  void *targinfo,
=2D			  unsigned int hook_mask);
+	int (*init)(const char *tablename,
+		    const void *entry,
+		    const struct xt_target *target,
+		    void *targinfo,
+		    void *data,
+		    unsigned int hook_mask);
=20
 	/* Called when entry of this type deleted. */
=2D	void (*destroy)(const struct xt_target *target, void *targinfo);
+	void (*destroy)(const struct xt_target *target, void *targinfo,
+			void *data);
=20
 	/* Called when userspace align differs from kernel space one */
 	void (*compat_from_user)(void *dst, void *src);
@@ -216,6 +220,7 @@ struct xt_target
 	struct module *me;
=20
 	char *table;
+	unsigned int datasize;
 	unsigned int targetsize;
 	unsigned int compatsize;
 	unsigned int hooks;
@@ -282,9 +287,9 @@ extern void xt_unregister_matches(struct
 extern int xt_init_match(const struct xt_match *match, unsigned short fami=
ly,
 			 unsigned int size, const char *table, unsigned int hook,
 			 unsigned short proto, int inv_proto);
=2Dextern int xt_check_target(const struct xt_target *target, unsigned shor=
t family,
=2D			   unsigned int size, const char *table, unsigned int hook,
=2D			   unsigned short proto, int inv_proto);
+extern int xt_init_target(const struct xt_target *target, unsigned short f=
amily,
+			  unsigned int size, const char *table, unsigned int hook,
+			  unsigned short proto, int inv_proto);
=20
 extern int xt_register_table(struct xt_table *table,
 			     struct xt_table_info *bootstrap,
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_table=
s.c
index 413c2d0..683179f 100644
=2D-- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -206,7 +206,8 @@ static unsigned int arpt_error(struct sk
 			       const struct net_device *out,
 			       unsigned int hooknum,
 			       const struct xt_target *target,
=2D			       const void *targinfo)
+			       const void *targinfo,
+			       void *data)
 {
 	if (net_ratelimit())
 		printk("arp_tables: error: '%s'\n", (char *)targinfo);
@@ -298,7 +299,8 @@ unsigned int arpt_do_table(struct sk_buf
 								     in, out,
 								     hook,
 								     t->u.kernel.target,
=2D								     t->data);
+								     t->data,
+								     t->u.kernel.data);
=20
 				/* Target might have changed stuff. */
 				arp =3D (*pskb)->nh.arph;
@@ -483,19 +485,21 @@ static inline int check_entry(struct arp
 	}
 	t->u.kernel.target =3D target;
=20
=2D	ret =3D xt_check_target(target, NF_ARP, t->u.target_size - sizeof(*t),
=2D			      name, e->comefrom, 0, 0);
+	ret =3D xt_init_target(target, NF_ARP, t->u.target_size - sizeof(*t),
+			     name, e->comefrom, 0, 0);
 	if (ret)
 		goto err;
=20
+	t->u.kernel.data=3DNULL;
 	if (t->u.kernel.target =3D=3D &arpt_standard_target) {
 		if (!standard_check(t, size)) {
 			ret =3D -EINVAL;
 			goto err;
 		}
=2D	} else if (t->u.kernel.target->checkentry
=2D		   && !t->u.kernel.target->checkentry(name, e, target, t->data,
=2D						      e->comefrom)) {
+	} else if (t->u.kernel.target->init
+		   && !t->u.kernel.target->init(name, e, target, t->data,
+						t->u.kernel.data,
+						e->comefrom)) {
 		duprintf("arp_tables: check failed for `%s'.\n",
 			 t->u.kernel.target->name);
 		ret =3D -EINVAL;
@@ -561,7 +565,8 @@ static inline int cleanup_entry(struct a
=20
 	t =3D arpt_get_target(e);
 	if (t->u.kernel.target->destroy)
=2D		t->u.kernel.target->destroy(t->u.kernel.target, t->data);
+		t->u.kernel.target->destroy(t->u.kernel.target, t->data,
+					    t->u.kernel.data);
 	module_put(t->u.kernel.target->me);
 	return 0;
 }
diff --git a/net/ipv4/netfilter/arpt_mangle.c b/net/ipv4/netfilter/arpt_man=
gle.c
index d12b1df..49ae77a 100644
=2D-- a/net/ipv4/netfilter/arpt_mangle.c
+++ b/net/ipv4/netfilter/arpt_mangle.c
@@ -11,7 +11,7 @@ static unsigned int
 target(struct sk_buff **pskb,
        const struct net_device *in, const struct net_device *out,
        unsigned int hooknum, const struct xt_target *target,
=2D       const void *targinfo)
+       const void *targinfo, void *data)
 {
 	const struct arpt_mangle *mangle =3D targinfo;
 	struct arphdr *arp;
@@ -66,8 +66,8 @@ target(struct sk_buff **pskb,
 }
=20
 static int
=2Dcheckentry(const char *tablename, const void *e, const struct xt_target =
*target,
=2D           void *targinfo, unsigned int hook_mask)
+init(const char *tablename, const void *e, const struct xt_target *target,
+     void *targinfo, void *data, unsigned int hook_mask)
 {
 	const struct arpt_mangle *mangle =3D targinfo;
=20
@@ -85,7 +85,7 @@ static struct arpt_target arpt_mangle_re
 	.name		=3D "mangle",
 	.target		=3D target,
 	.targetsize	=3D sizeof(struct arpt_mangle),
=2D	.checkentry	=3D checkentry,
+	.init	=3D init,
 	.me		=3D THIS_MODULE,
 };
=20
diff --git a/net/ipv4/netfilter/ip_nat_rule.c b/net/ipv4/netfilter/ip_nat_r=
ule.c
index a176aa3..8c24c1d 100644
=2D-- a/net/ipv4/netfilter/ip_nat_rule.c
+++ b/net/ipv4/netfilter/ip_nat_rule.c
@@ -100,7 +100,8 @@ static unsigned int ipt_snat_target(stru
 				    const struct net_device *out,
 				    unsigned int hooknum,
 				    const struct ipt_target *target,
=2D				    const void *targinfo)
+				    const void *targinfo,
+				    void *data)
 {
 	struct ip_conntrack *ct;
 	enum ip_conntrack_info ctinfo;
@@ -142,7 +143,8 @@ static unsigned int ipt_dnat_target(stru
 				    const struct net_device *out,
 				    unsigned int hooknum,
 				    const struct ipt_target *target,
=2D				    const void *targinfo)
+				    const void *targinfo,
+				    void *data)
 {
 	struct ip_conntrack *ct;
 	enum ip_conntrack_info ctinfo;
@@ -164,11 +166,12 @@ static unsigned int ipt_dnat_target(stru
 	return ip_nat_setup_info(ct, &mr->range[0], hooknum);
 }
=20
=2Dstatic int ipt_snat_checkentry(const char *tablename,
=2D			       const void *entry,
=2D			       const struct ipt_target *target,
=2D			       void *targinfo,
=2D			       unsigned int hook_mask)
+static int ipt_snat_init(const char *tablename,
+			 const void *entry,
+			 const struct ipt_target *target,
+			 void *targinfo,
+			 void *data,
+			 unsigned int hook_mask)
 {
 	struct ip_nat_multi_range_compat *mr =3D targinfo;
=20
@@ -180,11 +183,12 @@ static int ipt_snat_checkentry(const cha
 	return 1;
 }
=20
=2Dstatic int ipt_dnat_checkentry(const char *tablename,
=2D			       const void *entry,
=2D			       const struct ipt_target *target,
=2D			       void *targinfo,
=2D			       unsigned int hook_mask)
+static int ipt_dnat_init(const char *tablename,
+			 const void *entry,
+			 const struct ipt_target *target,
+			 void *targinfo,
+			 void *data,
+			 unsigned int hook_mask)
 {
 	struct ip_nat_multi_range_compat *mr =3D targinfo;
=20
@@ -263,7 +267,7 @@ static struct ipt_target ipt_snat_reg =3D
 	.targetsize	=3D sizeof(struct ip_nat_multi_range_compat),
 	.table		=3D "nat",
 	.hooks		=3D 1 << NF_IP_POST_ROUTING,
=2D	.checkentry	=3D ipt_snat_checkentry,
+	.init		=3D ipt_snat_init,
 };
=20
 static struct ipt_target ipt_dnat_reg =3D {
@@ -272,7 +276,7 @@ static struct ipt_target ipt_dnat_reg =3D
 	.targetsize	=3D sizeof(struct ip_nat_multi_range_compat),
 	.table		=3D "nat",
 	.hooks		=3D (1 << NF_IP_PRE_ROUTING) | (1 << NF_IP_LOCAL_OUT),
=2D	.checkentry	=3D ipt_dnat_checkentry,
+	.init		=3D ipt_dnat_init,
 };
=20
 int __init ip_nat_rule_init(void)
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 75fae96..4077577 100644
=2D-- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -180,7 +180,8 @@ ipt_error(struct sk_buff **pskb,
 	  const struct net_device *out,
 	  unsigned int hooknum,
 	  const struct xt_target *target,
=2D	  const void *targinfo)
+	  const void *targinfo,
+	  void *data)
 {
 	if (net_ratelimit())
 		printk("ip_tables: error: `%s'\n", (char *)targinfo);
@@ -307,7 +308,8 @@ ipt_do_table(struct sk_buff **pskb,
 								     in, out,
 								     hook,
 								     t->u.kernel.target,
=2D								     t->data);
+								     t->data,
+								     t->u.kernel.data);
=20
 #ifdef CONFIG_NETFILTER_DEBUG
 				if (((struct ipt_entry *)table_base)->comefrom
@@ -573,20 +575,22 @@ check_entry(struct ipt_entry *e, const c
 	}
 	t->u.kernel.target =3D target;
=20
=2D	ret =3D xt_check_target(target, AF_INET, t->u.target_size - sizeof(*t),
=2D			      name, e->comefrom, e->ip.proto,
=2D			      e->ip.invflags & IPT_INV_PROTO);
+	ret =3D xt_init_target(target, AF_INET, t->u.target_size - sizeof(*t),
+			     name, e->comefrom, e->ip.proto,
+			     e->ip.invflags & IPT_INV_PROTO);
 	if (ret)
 		goto err;
=20
+	t->u.kernel.data =3D NULL;
 	if (t->u.kernel.target =3D=3D &ipt_standard_target) {
 		if (!standard_check(t, size)) {
 			ret =3D -EINVAL;
 			goto err;
 		}
=2D	} else if (t->u.kernel.target->checkentry
=2D		   && !t->u.kernel.target->checkentry(name, e, target, t->data,
=2D						      e->comefrom)) {
+	} else if (t->u.kernel.target->init
+		   && !t->u.kernel.target->init(name, e, target, t->data,
+						t->u.kernel.data,
+						e->comefrom)) {
 		duprintf("ip_tables: check failed for `%s'.\n",
 			 t->u.kernel.target->name);
 		ret =3D -EINVAL;
@@ -657,7 +661,8 @@ cleanup_entry(struct ipt_entry *e, unsig
 	IPT_MATCH_ITERATE(e, cleanup_match, NULL);
 	t =3D ipt_get_target(e);
 	if (t->u.kernel.target->destroy)
=2D		t->u.kernel.target->destroy(t->u.kernel.target, t->data);
+		t->u.kernel.target->destroy(t->u.kernel.target, t->data,
+					    t->u.kernel.data);
 	module_put(t->u.kernel.target->me);
 	return 0;
 }
@@ -1589,19 +1594,21 @@ static int compat_copy_entry_from_user(s
=20
 	t =3D ipt_get_target(de);
 	target =3D t->u.kernel.target;
=2D	ret =3D xt_check_target(target, AF_INET, t->u.target_size - sizeof(*t),
=2D			      name, e->comefrom, e->ip.proto,
=2D			      e->ip.invflags & IPT_INV_PROTO);
+	ret =3D xt_init_target(target, AF_INET, t->u.target_size - sizeof(*t),
+			     name, e->comefrom, e->ip.proto,
+			     e->ip.invflags & IPT_INV_PROTO);
 	if (ret)
 		goto err;
=20
 	ret =3D -EINVAL;
+	t->u.kernel.data =3D NULL;
 	if (t->u.kernel.target =3D=3D &ipt_standard_target) {
 		if (!standard_check(t, *size))
 			goto err;
=2D	} else if (t->u.kernel.target->checkentry
=2D		   && !t->u.kernel.target->checkentry(name, de, target,
=2D						      t->data, de->comefrom)) {
+	} else if (t->u.kernel.target->init
+		   && !t->u.kernel.target->init(name, de, target,
+						t->data, t->u.kernel.data,
+						de->comefrom)) {
 		duprintf("ip_tables: compat: check failed for `%s'.\n",
 			 t->u.kernel.target->name);
 		goto err;
diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CL=
USTERIP.c
index 0983650..4e9817d 100644
=2D-- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -305,7 +305,8 @@ target(struct sk_buff **pskb,
        const struct net_device *out,
        unsigned int hooknum,
        const struct xt_target *target,
=2D       const void *targinfo)
+       const void *targinfo,
+       void *data)
 {
 	const struct ipt_clusterip_tgt_info *cipinfo =3D targinfo;
 	enum ip_conntrack_info ctinfo;
@@ -371,11 +372,12 @@ target(struct sk_buff **pskb,
 }
=20
 static int
=2Dcheckentry(const char *tablename,
=2D	   const void *e_void,
=2D	   const struct xt_target *target,
=2D           void *targinfo,
=2D           unsigned int hook_mask)
+init(const char *tablename,
+     const void *e_void,
+     const struct xt_target *target,
+     void *targinfo,
+     void *data,
+     unsigned int hook_mask)
 {
 	struct ipt_clusterip_tgt_info *cipinfo =3D targinfo;
 	const struct ipt_entry *e =3D e_void;
@@ -451,7 +453,8 @@ checkentry(const char *tablename,
 }
=20
 /* drop reference count of cluster config when rule is deleted */
=2Dstatic void destroy(const struct xt_target *target, void *targinfo)
+static void destroy(const struct xt_target *target, void *targinfo,
+		    void *data)
 {
 	struct ipt_clusterip_tgt_info *cipinfo =3D targinfo;
=20
@@ -466,7 +469,7 @@ static struct ipt_target clusterip_tgt =3D
 	.name		=3D "CLUSTERIP",
 	.target		=3D target,
 	.targetsize	=3D sizeof(struct ipt_clusterip_tgt_info),
=2D	.checkentry	=3D checkentry,
+	.init		=3D init,
 	.destroy	=3D destroy,
 	.me		=3D THIS_MODULE
 };
diff --git a/net/ipv4/netfilter/ipt_ECN.c b/net/ipv4/netfilter/ipt_ECN.c
index b55d670..7cd17f9 100644
=2D-- a/net/ipv4/netfilter/ipt_ECN.c
+++ b/net/ipv4/netfilter/ipt_ECN.c
@@ -82,7 +82,8 @@ target(struct sk_buff **pskb,
        const struct net_device *out,
        unsigned int hooknum,
        const struct xt_target *target,
=2D       const void *targinfo)
+       const void *targinfo,
+       void *data)
 {
 	const struct ipt_ECN_info *einfo =3D targinfo;
=20
@@ -99,11 +100,12 @@ target(struct sk_buff **pskb,
 }
=20
 static int
=2Dcheckentry(const char *tablename,
=2D	   const void *e_void,
=2D	   const struct xt_target *target,
=2D           void *targinfo,
=2D           unsigned int hook_mask)
+init(const char *tablename,
+     const void *e_void,
+     const struct xt_target *target,
+     void *targinfo,
+     void *data,
+     unsigned int hook_mask)
 {
 	const struct ipt_ECN_info *einfo =3D (struct ipt_ECN_info *)targinfo;
 	const struct ipt_entry *e =3D e_void;
@@ -132,7 +134,7 @@ static struct ipt_target ipt_ecn_reg =3D {
 	.target		=3D target,
 	.targetsize	=3D sizeof(struct ipt_ECN_info),
 	.table		=3D "mangle",
=2D	.checkentry	=3D checkentry,
+	.init		=3D init,
 	.me		=3D THIS_MODULE,
 };
=20
diff --git a/net/ipv4/netfilter/ipt_LOG.c b/net/ipv4/netfilter/ipt_LOG.c
index c96de16..14e7801 100644
=2D-- a/net/ipv4/netfilter/ipt_LOG.c
+++ b/net/ipv4/netfilter/ipt_LOG.c
@@ -421,7 +421,8 @@ ipt_log_target(struct sk_buff **pskb,
 	       const struct net_device *out,
 	       unsigned int hooknum,
 	       const struct xt_target *target,
=2D	       const void *targinfo)
+	       const void *targinfo,
+	       void *data)
 {
 	const struct ipt_log_info *loginfo =3D targinfo;
 	struct nf_loginfo li;
@@ -435,11 +436,12 @@ ipt_log_target(struct sk_buff **pskb,
 	return IPT_CONTINUE;
 }
=20
=2Dstatic int ipt_log_checkentry(const char *tablename,
=2D			      const void *e,
=2D			      const struct xt_target *target,
=2D			      void *targinfo,
=2D			      unsigned int hook_mask)
+static int ipt_log_init(const char *tablename,
+			const void *e,
+			const struct xt_target *target,
+			void *targinfo,
+			void *data,
+			unsigned int hook_mask)
 {
 	const struct ipt_log_info *loginfo =3D targinfo;
=20
@@ -459,7 +461,7 @@ static struct ipt_target ipt_log_reg =3D {
 	.name		=3D "LOG",
 	.target		=3D ipt_log_target,
 	.targetsize	=3D sizeof(struct ipt_log_info),
=2D	.checkentry	=3D ipt_log_checkentry,
+	.init		=3D ipt_log_init,
 	.me		=3D THIS_MODULE,
 };
=20
@@ -469,7 +471,7 @@ static struct nf_logger ipt_log_logger =3D
 	.me		=3D THIS_MODULE,
 };
=20
=2Dstatic int __init ipt_log_init(void)
+static int __init ipt_log_module_init(void)
 {
 	if (ipt_register_target(&ipt_log_reg))
 		return -EINVAL;
@@ -483,11 +485,11 @@ static int __init ipt_log_init(void)
 	return 0;
 }
=20
=2Dstatic void __exit ipt_log_fini(void)
+static void __exit ipt_log_module_fini(void)
 {
 	nf_log_unregister_logger(&ipt_log_logger);
 	ipt_unregister_target(&ipt_log_reg);
 }
=20
=2Dmodule_init(ipt_log_init);
=2Dmodule_exit(ipt_log_fini);
+module_init(ipt_log_module_init);
+module_exit(ipt_log_module_fini);
diff --git a/net/ipv4/netfilter/ipt_MASQUERADE.c b/net/ipv4/netfilter/ipt_M=
ASQUERADE.c
index 28b9233..51fed4c 100644
=2D-- a/net/ipv4/netfilter/ipt_MASQUERADE.c
+++ b/net/ipv4/netfilter/ipt_MASQUERADE.c
@@ -42,11 +42,12 @@ static DEFINE_RWLOCK(masq_lock);
=20
 /* FIXME: Multiple targets. --RR */
 static int
=2Dmasquerade_check(const char *tablename,
=2D		 const void *e,
=2D		 const struct xt_target *target,
=2D		 void *targinfo,
=2D		 unsigned int hook_mask)
+masquerade_init(const char *tablename,
+		const void *e,
+		const struct xt_target *target,
+		void *targinfo,
+		void *data,
+		unsigned int hook_mask)
 {
 	const struct ip_nat_multi_range_compat *mr =3D targinfo;
=20
@@ -67,7 +68,8 @@ masquerade_target(struct sk_buff **pskb,
 		  const struct net_device *out,
 		  unsigned int hooknum,
 		  const struct xt_target *target,
=2D		  const void *targinfo)
+		  const void *targinfo,
+		  void *data)
 {
 #ifdef CONFIG_NF_NAT_NEEDED
 	struct nf_conn_nat *nat;
@@ -193,7 +195,7 @@ static struct ipt_target masquerade =3D {
 	.targetsize	=3D sizeof(struct ip_nat_multi_range_compat),
 	.table		=3D "nat",
 	.hooks		=3D 1 << NF_IP_POST_ROUTING,
=2D	.checkentry	=3D masquerade_check,
+	.init		=3D masquerade_init,
 	.me		=3D THIS_MODULE,
 };
=20
diff --git a/net/ipv4/netfilter/ipt_NETMAP.c b/net/ipv4/netfilter/ipt_NETMA=
P.c
index 9390e90..9cb56ea 100644
=2D-- a/net/ipv4/netfilter/ipt_NETMAP.c
+++ b/net/ipv4/netfilter/ipt_NETMAP.c
@@ -33,11 +33,12 @@ MODULE_DESCRIPTION("iptables 1:1 NAT map
 #endif
=20
 static int
=2Dcheck(const char *tablename,
=2D      const void *e,
=2D      const struct xt_target *target,
=2D      void *targinfo,
=2D      unsigned int hook_mask)
+init(const char *tablename,
+     const void *e,
+     const struct xt_target *target,
+     void *targinfo,
+     void *data,
+     unsigned int hook_mask)
 {
 	const struct ip_nat_multi_range_compat *mr =3D targinfo;
=20
@@ -58,7 +59,8 @@ target(struct sk_buff **pskb,
        const struct net_device *out,
        unsigned int hooknum,
        const struct xt_target *target,
=2D       const void *targinfo)
+       const void *targinfo,
+       void *data)
 {
 	struct ip_conntrack *ct;
 	enum ip_conntrack_info ctinfo;
@@ -95,7 +97,7 @@ static struct ipt_target target_module =3D
 	.table		=3D "nat",
 	.hooks		=3D (1 << NF_IP_PRE_ROUTING) | (1 << NF_IP_POST_ROUTING) |
 			  (1 << NF_IP_LOCAL_OUT),
=2D	.checkentry 	=3D check,
+	.init		=3D init,
     	.me 		=3D THIS_MODULE=20
 };
=20
diff --git a/net/ipv4/netfilter/ipt_REDIRECT.c b/net/ipv4/netfilter/ipt_RED=
IRECT.c
index 462eceb..74b6116 100644
=2D-- a/net/ipv4/netfilter/ipt_REDIRECT.c
+++ b/net/ipv4/netfilter/ipt_REDIRECT.c
@@ -36,11 +36,12 @@ MODULE_DESCRIPTION("iptables REDIRECT ta
=20
 /* FIXME: Take multiple ranges --RR */
 static int
=2Dredirect_check(const char *tablename,
=2D	       const void *e,
=2D	       const struct xt_target *target,
=2D	       void *targinfo,
=2D	       unsigned int hook_mask)
+redirect_init(const char *tablename,
+	      const void *e,
+	      const struct xt_target *target,
+	      void *targinfo,
+	      void *data,
+	      unsigned int hook_mask)
 {
 	const struct ip_nat_multi_range_compat *mr =3D targinfo;
=20
@@ -61,7 +62,8 @@ redirect_target(struct sk_buff **pskb,
 		const struct net_device *out,
 		unsigned int hooknum,
 		const struct xt_target *target,
=2D		const void *targinfo)
+		const void *targinfo,
+		void *data)
 {
 	struct ip_conntrack *ct;
 	enum ip_conntrack_info ctinfo;
@@ -110,7 +112,7 @@ static struct ipt_target redirect_reg =3D
 	.targetsize	=3D sizeof(struct ip_nat_multi_range_compat),
 	.table		=3D "nat",
 	.hooks		=3D (1 << NF_IP_PRE_ROUTING) | (1 << NF_IP_LOCAL_OUT),
=2D	.checkentry	=3D redirect_check,
+	.init		=3D redirect_init,
 	.me		=3D THIS_MODULE,
 };
=20
diff --git a/net/ipv4/netfilter/ipt_REJECT.c b/net/ipv4/netfilter/ipt_REJEC=
T.c
index f0319e5..64d6198 100644
=2D-- a/net/ipv4/netfilter/ipt_REJECT.c
+++ b/net/ipv4/netfilter/ipt_REJECT.c
@@ -171,7 +171,8 @@ static unsigned int reject(struct sk_buf
 			   const struct net_device *out,
 			   unsigned int hooknum,
 			   const struct xt_target *target,
=2D			   const void *targinfo)
+			   const void *targinfo,
+			   void *data)
 {
 	const struct ipt_reject_info *reject =3D targinfo;
=20
@@ -215,11 +216,12 @@ static unsigned int reject(struct sk_buf
 	return NF_DROP;
 }
=20
=2Dstatic int check(const char *tablename,
=2D		 const void *e_void,
=2D		 const struct xt_target *target,
=2D		 void *targinfo,
=2D		 unsigned int hook_mask)
+static int init(const char *tablename,
+		const void *e_void,
+		const struct xt_target *target,
+		void *targinfo,
+		void *data,
+		unsigned int hook_mask)
 {
  	const struct ipt_reject_info *rejinfo =3D targinfo;
 	const struct ipt_entry *e =3D e_void;
@@ -245,7 +247,7 @@ static struct ipt_target ipt_reject_reg
 	.table		=3D "filter",
 	.hooks		=3D (1 << NF_IP_LOCAL_IN) | (1 << NF_IP_FORWARD) |
 			  (1 << NF_IP_LOCAL_OUT),
=2D	.checkentry	=3D check,
+	.init		=3D init,
 	.me		=3D THIS_MODULE,
 };
=20
diff --git a/net/ipv4/netfilter/ipt_SAME.c b/net/ipv4/netfilter/ipt_SAME.c
index 3dcf294..938e954 100644
=2D-- a/net/ipv4/netfilter/ipt_SAME.c
+++ b/net/ipv4/netfilter/ipt_SAME.c
@@ -52,11 +52,12 @@ MODULE_DESCRIPTION("iptables special SNA
 #endif
=20
 static int
=2Dsame_check(const char *tablename,
=2D	      const void *e,
=2D	      const struct xt_target *target,
=2D	      void *targinfo,
=2D	      unsigned int hook_mask)
+same_init(const char *tablename,
+	  const void *e,
+	  const struct xt_target *target,
+	  void *targinfo,
+	  void *data,
+	  unsigned int hook_mask)
 {
 	unsigned int count, countess, rangeip, index =3D 0;
 	struct ipt_same_info *mr =3D targinfo;
@@ -119,7 +120,7 @@ same_check(const char *tablename,
 }
=20
 static void=20
=2Dsame_destroy(const struct xt_target *target, void *targinfo)
+same_destroy(const struct xt_target *target, void *targinfo, void *data)
 {
 	struct ipt_same_info *mr =3D targinfo;
=20
@@ -135,7 +136,8 @@ same_target(struct sk_buff **pskb,
 		const struct net_device *out,
 		unsigned int hooknum,
 		const struct xt_target *target,
=2D		const void *targinfo)
+		const void *targinfo,
+		void *data)
 {
 	struct ip_conntrack *ct;
 	enum ip_conntrack_info ctinfo;
@@ -192,7 +194,7 @@ static struct ipt_target same_reg =3D {
 	.targetsize	=3D sizeof(struct ipt_same_info),
 	.table		=3D "nat",
 	.hooks		=3D (1 << NF_IP_PRE_ROUTING | 1 << NF_IP_POST_ROUTING),
=2D	.checkentry	=3D same_check,
+	.init		=3D same_init,
 	.destroy	=3D same_destroy,
 	.me		=3D THIS_MODULE,
 };
diff --git a/net/ipv4/netfilter/ipt_TCPMSS.c b/net/ipv4/netfilter/ipt_TCPMS=
S.c
index 93eb5c3..70f70ac 100644
=2D-- a/net/ipv4/netfilter/ipt_TCPMSS.c
+++ b/net/ipv4/netfilter/ipt_TCPMSS.c
@@ -37,7 +37,8 @@ ipt_tcpmss_target(struct sk_buff **pskb,
 		  const struct net_device *out,
 		  unsigned int hooknum,
 		  const struct xt_target *target,
=2D		  const void *targinfo)
+		  const void *targinfo,
+		  void *data)
 {
 	const struct ipt_tcpmss_info *tcpmssinfo =3D targinfo;
 	struct tcphdr *tcph;
@@ -160,11 +161,12 @@ static inline int find_syn_match(const s
=20
 /* Must specify -p tcp --syn/--tcp-flags SYN */
 static int
=2Dipt_tcpmss_checkentry(const char *tablename,
=2D		      const void *e_void,
=2D		      const struct xt_target *target,
=2D		      void *targinfo,
=2D		      unsigned int hook_mask)
+ipt_tcpmss_init(const char *tablename,
+		const void *e_void,
+		const struct xt_target *target,
+		void *targinfo,
+		void *data,
+		unsigned int hook_mask)
 {
 	const struct ipt_tcpmss_info *tcpmssinfo =3D targinfo;
 	const struct ipt_entry *e =3D e_void;
@@ -189,19 +191,19 @@ static struct ipt_target ipt_tcpmss_reg
 	.target		=3D ipt_tcpmss_target,
 	.targetsize	=3D sizeof(struct ipt_tcpmss_info),
 	.proto		=3D IPPROTO_TCP,
=2D	.checkentry	=3D ipt_tcpmss_checkentry,
+	.init		=3D ipt_tcpmss_init,
 	.me		=3D THIS_MODULE,
 };
=20
=2Dstatic int __init ipt_tcpmss_init(void)
+static int __init ipt_tcpmss_module_init(void)
 {
 	return ipt_register_target(&ipt_tcpmss_reg);
 }
=20
=2Dstatic void __exit ipt_tcpmss_fini(void)
+static void __exit ipt_tcpmss_module_fini(void)
 {
 	ipt_unregister_target(&ipt_tcpmss_reg);
 }
=20
=2Dmodule_init(ipt_tcpmss_init);
=2Dmodule_exit(ipt_tcpmss_fini);
+module_init(ipt_tcpmss_module_init);
+module_exit(ipt_tcpmss_module_fini);
diff --git a/net/ipv4/netfilter/ipt_TOS.c b/net/ipv4/netfilter/ipt_TOS.c
index 18e74ac..cb54627 100644
=2D-- a/net/ipv4/netfilter/ipt_TOS.c
+++ b/net/ipv4/netfilter/ipt_TOS.c
@@ -26,7 +26,8 @@ target(struct sk_buff **pskb,
        const struct net_device *out,
        unsigned int hooknum,
        const struct xt_target *target,
=2D       const void *targinfo)
+       const void *targinfo,
+       void *data)
 {
 	const struct ipt_tos_target_info *tosinfo =3D targinfo;
 	struct iphdr *iph =3D (*pskb)->nh.iph;
@@ -44,11 +45,12 @@ target(struct sk_buff **pskb,
 }
=20
 static int
=2Dcheckentry(const char *tablename,
=2D	   const void *e_void,
=2D	   const struct xt_target *target,
=2D           void *targinfo,
=2D           unsigned int hook_mask)
+init(const char *tablename,
+     const void *e_void,
+     const struct xt_target *target,
+     void *targinfo,
+     void *data,
+     unsigned int hook_mask)
 {
 	const u_int8_t tos =3D ((struct ipt_tos_target_info *)targinfo)->tos;
=20
@@ -68,7 +70,7 @@ static struct ipt_target ipt_tos_reg =3D {
 	.target		=3D target,
 	.targetsize	=3D sizeof(struct ipt_tos_target_info),
 	.table		=3D "mangle",
=2D	.checkentry	=3D checkentry,
+	.init		=3D init,
 	.me		=3D THIS_MODULE,
 };
=20
diff --git a/net/ipv4/netfilter/ipt_TTL.c b/net/ipv4/netfilter/ipt_TTL.c
index fffe5ca..ff8dd4b 100644
=2D-- a/net/ipv4/netfilter/ipt_TTL.c
+++ b/net/ipv4/netfilter/ipt_TTL.c
@@ -23,7 +23,7 @@ static unsigned int
 ipt_ttl_target(struct sk_buff **pskb,
 	       const struct net_device *in, const struct net_device *out,
 	       unsigned int hooknum, const struct xt_target *target,
=2D	       const void *targinfo)
+	       const void *targinfo, void *data)
 {
 	struct iphdr *iph;
 	const struct ipt_TTL_info *info =3D targinfo;
@@ -62,11 +62,12 @@ ipt_ttl_target(struct sk_buff **pskb,
 	return IPT_CONTINUE;
 }
=20
=2Dstatic int ipt_ttl_checkentry(const char *tablename,
=2D		const void *e,
=2D		const struct xt_target *target,
=2D		void *targinfo,
=2D		unsigned int hook_mask)
+static int ipt_ttl_init(const char *tablename,
+			const void *e,
+			const struct xt_target *target,
+			void *targinfo,
+			void *data,
+			unsigned int hook_mask)
 {
 	struct ipt_TTL_info *info =3D targinfo;
=20
@@ -85,19 +86,19 @@ static struct ipt_target ipt_TTL =3D {
 	.target 	=3D ipt_ttl_target,=20
 	.targetsize	=3D sizeof(struct ipt_TTL_info),
 	.table		=3D "mangle",
=2D	.checkentry 	=3D ipt_ttl_checkentry,=20
+	.init		=3D ipt_ttl_init,
 	.me 		=3D THIS_MODULE,
 };
=20
=2Dstatic int __init ipt_ttl_init(void)
+static int __init ipt_ttl_module_init(void)
 {
 	return ipt_register_target(&ipt_TTL);
 }
=20
=2Dstatic void __exit ipt_ttl_fini(void)
+static void __exit ipt_ttl_module_fini(void)
 {
 	ipt_unregister_target(&ipt_TTL);
 }
=20
=2Dmodule_init(ipt_ttl_init);
=2Dmodule_exit(ipt_ttl_fini);
+module_init(ipt_ttl_module_init);
+module_exit(ipt_ttl_module_fini);
diff --git a/net/ipv4/netfilter/ipt_ULOG.c b/net/ipv4/netfilter/ipt_ULOG.c
index dbd3478..fc9bae1 100644
=2D-- a/net/ipv4/netfilter/ipt_ULOG.c
+++ b/net/ipv4/netfilter/ipt_ULOG.c
@@ -308,7 +308,8 @@ static unsigned int ipt_ulog_target(stru
 				    const struct net_device *out,
 				    unsigned int hooknum,
 				    const struct xt_target *target,
=2D				    const void *targinfo)
+				    const void *targinfo,
+				    void *data)
 {
 	struct ipt_ulog_info *loginfo =3D (struct ipt_ulog_info *) targinfo;
=20
@@ -342,11 +343,12 @@ static void ipt_logfn(unsigned int pf,
 	ipt_ulog_packet(hooknum, skb, in, out, &loginfo, prefix);
 }
=20
=2Dstatic int ipt_ulog_checkentry(const char *tablename,
=2D			       const void *e,
=2D			       const struct xt_target *target,
=2D			       void *targinfo,
=2D			       unsigned int hookmask)
+static int ipt_ulog_init(const char *tablename,
+			 const void *e,
+			 const struct xt_target *target,
+			 void *targinfo,
+			 void *data,
+			 unsigned int hookmask)
 {
 	struct ipt_ulog_info *loginfo =3D (struct ipt_ulog_info *) targinfo;
=20
@@ -367,7 +369,7 @@ static struct ipt_target ipt_ulog_reg =3D
 	.name		=3D "ULOG",
 	.target		=3D ipt_ulog_target,
 	.targetsize	=3D sizeof(struct ipt_ulog_info),
=2D	.checkentry	=3D ipt_ulog_checkentry,
+	.init	=3D ipt_ulog_init,
 	.me		=3D THIS_MODULE,
 };
=20
@@ -377,7 +379,7 @@ static struct nf_logger ipt_ulog_logger
 	.me		=3D THIS_MODULE,
 };
=20
=2Dstatic int __init ipt_ulog_init(void)
+static int __init ipt_ulog_module_init(void)
 {
 	int i;
=20
@@ -410,7 +412,7 @@ static int __init ipt_ulog_init(void)
 	return 0;
 }
=20
=2Dstatic void __exit ipt_ulog_fini(void)
+static void __exit ipt_ulog_module_fini(void)
 {
 	ulog_buff_t *ub;
 	int i;
@@ -438,5 +440,5 @@ static void __exit ipt_ulog_fini(void)
=20
 }
=20
=2Dmodule_init(ipt_ulog_init);
=2Dmodule_exit(ipt_ulog_fini);
+module_init(ipt_ulog_module_init);
+module_exit(ipt_ulog_module_fini);
diff --git a/net/ipv4/netfilter/nf_nat_rule.c b/net/ipv4/netfilter/nf_nat_r=
ule.c
index b868ee0..08c5006 100644
=2D-- a/net/ipv4/netfilter/nf_nat_rule.c
+++ b/net/ipv4/netfilter/nf_nat_rule.c
@@ -133,7 +133,8 @@ static unsigned int ipt_snat_target(stru
 				    const struct net_device *out,
 				    unsigned int hooknum,
 				    const struct xt_target *target,
=2D				    const void *targinfo)
+				    const void *targinfo,
+				    void *data)
 {
 	struct nf_conn *ct;
 	enum ip_conntrack_info ctinfo;
@@ -175,7 +176,8 @@ static unsigned int ipt_dnat_target(stru
 				    const struct net_device *out,
 				    unsigned int hooknum,
 				    const struct xt_target *target,
=2D				    const void *targinfo)
+				    const void *targinfo,
+				    void *data)
 {
 	struct nf_conn *ct;
 	enum ip_conntrack_info ctinfo;
@@ -197,11 +199,12 @@ static unsigned int ipt_dnat_target(stru
 	return nf_nat_setup_info(ct, &mr->range[0], hooknum);
 }
=20
=2Dstatic int ipt_snat_checkentry(const char *tablename,
=2D			       const void *entry,
=2D			       const struct xt_target *target,
=2D			       void *targinfo,
=2D			       unsigned int hook_mask)
+static int ipt_snat_init(const char *tablename,
+			 const void *entry,
+			 const struct xt_target *target,
+			 void *targinfo,
+			 void *data,
+			 unsigned int hook_mask)
 {
 	struct nf_nat_multi_range_compat *mr =3D targinfo;
=20
@@ -213,11 +216,12 @@ static int ipt_snat_checkentry(const cha
 	return 1;
 }
=20
=2Dstatic int ipt_dnat_checkentry(const char *tablename,
=2D			       const void *entry,
=2D			       const struct xt_target *target,
=2D			       void *targinfo,
=2D			       unsigned int hook_mask)
+static int ipt_dnat_init(const char *tablename,
+			 const void *entry,
+			 const struct xt_target *target,
+			 void *targinfo,
+			 void *data,
+			 unsigned int hook_mask)
 {
 	struct nf_nat_multi_range_compat *mr =3D targinfo;
=20
@@ -296,7 +300,7 @@ static struct ipt_target ipt_snat_reg =3D
 	.targetsize	=3D sizeof(struct nf_nat_multi_range_compat),
 	.table		=3D "nat",
 	.hooks		=3D 1 << NF_IP_POST_ROUTING,
=2D	.checkentry	=3D ipt_snat_checkentry,
+	.init		=3D ipt_snat_init,
 	.family		=3D AF_INET,
 };
=20
@@ -306,7 +310,7 @@ static struct xt_target ipt_dnat_reg =3D {
 	.targetsize	=3D sizeof(struct nf_nat_multi_range_compat),
 	.table		=3D "nat",
 	.hooks		=3D (1 << NF_IP_PRE_ROUTING) | (1 << NF_IP_LOCAL_OUT),
=2D	.checkentry	=3D ipt_dnat_checkentry,
+	.init		=3D ipt_dnat_init,
 	.family		=3D AF_INET,
 };
=20
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_table=
s.c
index dc5e1ad..f14fe12 100644
=2D-- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -219,7 +219,8 @@ ip6t_error(struct sk_buff **pskb,
 	  const struct net_device *out,
 	  unsigned int hooknum,
 	  const struct xt_target *target,
=2D	  const void *targinfo)
+	  const void *targinfo,
+	  void *data)
 {
 	if (net_ratelimit())
 		printk("ip6_tables: error: `%s'\n", (char *)targinfo);
@@ -347,7 +348,8 @@ ip6t_do_table(struct sk_buff **pskb,
 								     in, out,
 								     hook,
 								     t->u.kernel.target,
=2D								     t->data);
+								     t->data,
+								     t->u.kernel.data);
=20
 #ifdef CONFIG_NETFILTER_DEBUG
 				if (((struct ip6t_entry *)table_base)->comefrom
@@ -613,20 +615,22 @@ check_entry(struct ip6t_entry *e, const
 	}
 	t->u.kernel.target =3D target;
=20
=2D	ret =3D xt_check_target(target, AF_INET6, t->u.target_size - sizeof(*t),
=2D			      name, e->comefrom, e->ipv6.proto,
=2D			      e->ipv6.invflags & IP6T_INV_PROTO);
+	ret =3D xt_init_target(target, AF_INET6, t->u.target_size - sizeof(*t),
+			     name, e->comefrom, e->ipv6.proto,
+			     e->ipv6.invflags & IP6T_INV_PROTO);
 	if (ret)
 		goto err;
=20
+	t->u.kernel.data=3DNULL;
 	if (t->u.kernel.target =3D=3D &ip6t_standard_target) {
 		if (!standard_check(t, size)) {
 			ret =3D -EINVAL;
 			goto err;
 		}
=2D	} else if (t->u.kernel.target->checkentry
=2D		   && !t->u.kernel.target->checkentry(name, e, target, t->data,
=2D						      e->comefrom)) {
+	} else if (t->u.kernel.target->init
+		   && !t->u.kernel.target->init(name, e, target, t->data,
+						t->u.kernel.data,
+						e->comefrom)) {
 		duprintf("ip_tables: check failed for `%s'.\n",
 			 t->u.kernel.target->name);
 		ret =3D -EINVAL;
@@ -697,7 +701,8 @@ cleanup_entry(struct ip6t_entry *e, unsi
 	IP6T_MATCH_ITERATE(e, cleanup_match, NULL);
 	t =3D ip6t_get_target(e);
 	if (t->u.kernel.target->destroy)
=2D		t->u.kernel.target->destroy(t->u.kernel.target, t->data);
+		t->u.kernel.target->destroy(t->u.kernel.target, t->data,
+					    t->u.kernel.data);
 	module_put(t->u.kernel.target->me);
 	return 0;
 }
diff --git a/net/ipv6/netfilter/ip6t_HL.c b/net/ipv6/netfilter/ip6t_HL.c
index 435750f..796c0d1 100644
=2D-- a/net/ipv6/netfilter/ip6t_HL.c
+++ b/net/ipv6/netfilter/ip6t_HL.c
@@ -22,7 +22,8 @@ static unsigned int ip6t_hl_target(struc
 				   const struct net_device *out,
 				   unsigned int hooknum,
 				   const struct xt_target *target,
=2D				   const void *targinfo)
+				   const void *targinfo,
+				   void *data)
 {
 	struct ipv6hdr *ip6h;
 	const struct ip6t_HL_info *info =3D targinfo;
@@ -58,11 +59,12 @@ static unsigned int ip6t_hl_target(struc
 	return IP6T_CONTINUE;
 }
=20
=2Dstatic int ip6t_hl_checkentry(const char *tablename,
=2D		const void *entry,
=2D		const struct xt_target *target,
=2D		void *targinfo,
=2D		unsigned int hook_mask)
+static int ip6t_hl_init(const char *tablename,
+			const void *entry,
+			const struct xt_target *target,
+			void *targinfo,
+			void *data,
+			unsigned int hook_mask)
 {
 	struct ip6t_HL_info *info =3D targinfo;
=20
@@ -84,19 +86,19 @@ static struct ip6t_target ip6t_HL =3D {
 	.target		=3D ip6t_hl_target,=20
 	.targetsize	=3D sizeof(struct ip6t_HL_info),
 	.table		=3D "mangle",
=2D	.checkentry	=3D ip6t_hl_checkentry,=20
+	.init		=3D ip6t_hl_init,
 	.me		=3D THIS_MODULE
 };
=20
=2Dstatic int __init ip6t_hl_init(void)
+static int __init ip6t_hl_module_init(void)
 {
 	return ip6t_register_target(&ip6t_HL);
 }
=20
=2Dstatic void __exit ip6t_hl_fini(void)
+static void __exit ip6t_hl_module_fini(void)
 {
 	ip6t_unregister_target(&ip6t_HL);
 }
=20
=2Dmodule_init(ip6t_hl_init);
=2Dmodule_exit(ip6t_hl_fini);
+module_init(ip6t_hl_module_init);
+module_exit(ip6t_hl_module_fini);
diff --git a/net/ipv6/netfilter/ip6t_LOG.c b/net/ipv6/netfilter/ip6t_LOG.c
index 33b1faa..d50f666 100644
=2D-- a/net/ipv6/netfilter/ip6t_LOG.c
+++ b/net/ipv6/netfilter/ip6t_LOG.c
@@ -431,7 +431,8 @@ ip6t_log_target(struct sk_buff **pskb,
 		const struct net_device *out,
 		unsigned int hooknum,
 		const struct xt_target *target,
=2D		const void *targinfo)
+		const void *targinfo,
+		void *data)
 {
 	const struct ip6t_log_info *loginfo =3D targinfo;
 	struct nf_loginfo li;
@@ -446,11 +447,12 @@ ip6t_log_target(struct sk_buff **pskb,
 }
=20
=20
=2Dstatic int ip6t_log_checkentry(const char *tablename,
=2D			       const void *entry,
=2D			       const struct xt_target *target,
=2D			       void *targinfo,
=2D			       unsigned int hook_mask)
+static int ip6t_log_init(const char *tablename,
+			 const void *entry,
+			 const struct xt_target *target,
+			 void *targinfo,
+			 void *data,
+			 unsigned int hook_mask)
 {
 	const struct ip6t_log_info *loginfo =3D targinfo;
=20
@@ -470,7 +472,7 @@ static struct ip6t_target ip6t_log_reg =3D
 	.name 		=3D "LOG",
 	.target 	=3D ip6t_log_target,=20
 	.targetsize	=3D sizeof(struct ip6t_log_info),
=2D	.checkentry	=3D ip6t_log_checkentry,=20
+	.init		=3D ip6t_log_init,
 	.me 		=3D THIS_MODULE,
 };
=20
@@ -480,7 +482,7 @@ static struct nf_logger ip6t_logger =3D {
 	.me		=3D THIS_MODULE,
 };
=20
=2Dstatic int __init ip6t_log_init(void)
+static int __init ip6t_log_module_init(void)
 {
 	if (ip6t_register_target(&ip6t_log_reg))
 		return -EINVAL;
@@ -494,11 +496,11 @@ static int __init ip6t_log_init(void)
 	return 0;
 }
=20
=2Dstatic void __exit ip6t_log_fini(void)
+static void __exit ip6t_log_module_fini(void)
 {
 	nf_log_unregister_logger(&ip6t_logger);
 	ip6t_unregister_target(&ip6t_log_reg);
 }
=20
=2Dmodule_init(ip6t_log_init);
=2Dmodule_exit(ip6t_log_fini);
+module_init(ip6t_log_module_init);
+module_exit(ip6t_log_module_fini);
diff --git a/net/ipv6/netfilter/ip6t_REJECT.c b/net/ipv6/netfilter/ip6t_REJ=
ECT.c
index 311eae8..9c3b209 100644
=2D-- a/net/ipv6/netfilter/ip6t_REJECT.c
+++ b/net/ipv6/netfilter/ip6t_REJECT.c
@@ -176,11 +176,12 @@ send_unreach(struct sk_buff *skb_in, uns
 }
=20
 static unsigned int reject6_target(struct sk_buff **pskb,
=2D			   const struct net_device *in,
=2D			   const struct net_device *out,
=2D			   unsigned int hooknum,
=2D			   const struct xt_target *target,
=2D			   const void *targinfo)
+				   const struct net_device *in,
+				   const struct net_device *out,
+				   unsigned int hooknum,
+				   const struct xt_target *target,
+				   const void *targinfo,
+				   void *data)
 {
 	const struct ip6t_reject_info *reject =3D targinfo;
=20
@@ -219,11 +220,12 @@ static unsigned int reject6_target(struc
 	return NF_DROP;
 }
=20
=2Dstatic int check(const char *tablename,
=2D		 const void *entry,
=2D		 const struct xt_target *target,
=2D		 void *targinfo,
=2D		 unsigned int hook_mask)
+static int init(const char *tablename,
+		const void *entry,
+		const struct xt_target *target,
+		void *targinfo,
+		void *data,
+		unsigned int hook_mask)
 {
  	const struct ip6t_reject_info *rejinfo =3D targinfo;
 	const struct ip6t_entry *e =3D entry;
@@ -249,7 +251,7 @@ static struct ip6t_target ip6t_reject_re
 	.table		=3D "filter",
 	.hooks		=3D (1 << NF_IP6_LOCAL_IN) | (1 << NF_IP6_FORWARD) |
 			  (1 << NF_IP6_LOCAL_OUT),
=2D	.checkentry	=3D check,
+	.init		=3D init,
 	.me		=3D THIS_MODULE
 };
=20
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index d2ffe98..679c430 100644
=2D-- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -394,9 +394,9 @@ int xt_compat_match_to_user(struct xt_en
 EXPORT_SYMBOL_GPL(xt_compat_match_to_user);
 #endif /* CONFIG_COMPAT */
=20
=2Dint xt_check_target(const struct xt_target *target, unsigned short famil=
y,
=2D		    unsigned int size, const char *table, unsigned int hook_mask,
=2D		    unsigned short proto, int inv_proto)
+int xt_init_target(const struct xt_target *target, unsigned short family,
+		   unsigned int size, const char *table, unsigned int hook_mask,
+		   unsigned short proto, int inv_proto)
 {
 	if (XT_ALIGN(target->targetsize) !=3D size) {
 		printk("%s_tables: %s target: invalid size %Zu !=3D %u\n",
@@ -421,7 +421,7 @@ int xt_check_target(const struct xt_targ
 	}
 	return 0;
 }
=2DEXPORT_SYMBOL_GPL(xt_check_target);
+EXPORT_SYMBOL_GPL(xt_init_target);
=20
 #ifdef CONFIG_COMPAT
 int xt_compat_target_offset(struct xt_target *target)
diff --git a/net/netfilter/xt_CLASSIFY.c b/net/netfilter/xt_CLASSIFY.c
index 50de965..62fac2e 100644
=2D-- a/net/netfilter/xt_CLASSIFY.c
+++ b/net/netfilter/xt_CLASSIFY.c
@@ -29,7 +29,8 @@ target(struct sk_buff **pskb,
        const struct net_device *out,
        unsigned int hooknum,
        const struct xt_target *target,
=2D       const void *targinfo)
+       const void *targinfo,
+       void *data)
 {
 	const struct xt_classify_target_info *clinfo =3D targinfo;
=20
diff --git a/net/netfilter/xt_CONNMARK.c b/net/netfilter/xt_CONNMARK.c
index b554823..d869fd8 100644
=2D-- a/net/netfilter/xt_CONNMARK.c
+++ b/net/netfilter/xt_CONNMARK.c
@@ -41,7 +41,8 @@ target(struct sk_buff **pskb,
        const struct net_device *out,
        unsigned int hooknum,
        const struct xt_target *target,
=2D       const void *targinfo)
+       const void *targinfo,
+       void *data)
 {
 	const struct xt_connmark_target_info *markinfo =3D targinfo;
 	u_int32_t diff;
@@ -88,11 +89,12 @@ target(struct sk_buff **pskb,
 }
=20
 static int
=2Dcheckentry(const char *tablename,
=2D	   const void *entry,
=2D	   const struct xt_target *target,
=2D	   void *targinfo,
=2D	   unsigned int hook_mask)
+init(const char *tablename,
+     const void *entry,
+     const struct xt_target *target,
+     void *targinfo,
+     void *data,
+     unsigned int hook_mask)
 {
 	struct xt_connmark_target_info *matchinfo =3D targinfo;
=20
@@ -146,7 +148,7 @@ static struct xt_target xt_connmark_targ
 	{
 		.name		=3D "CONNMARK",
 		.family		=3D AF_INET,
=2D		.checkentry	=3D checkentry,
+		.init		=3D init,
 		.target		=3D target,
 		.targetsize	=3D sizeof(struct xt_connmark_target_info),
 #ifdef CONFIG_COMPAT
@@ -159,7 +161,7 @@ static struct xt_target xt_connmark_targ
 	{
 		.name		=3D "CONNMARK",
 		.family		=3D AF_INET6,
=2D		.checkentry	=3D checkentry,
+		.init		=3D init,
 		.target		=3D target,
 		.targetsize	=3D sizeof(struct xt_connmark_target_info),
 		.me		=3D THIS_MODULE
diff --git a/net/netfilter/xt_CONNSECMARK.c b/net/netfilter/xt_CONNSECMARK.c
index 4673862..f598fdc 100644
=2D-- a/net/netfilter/xt_CONNSECMARK.c
+++ b/net/netfilter/xt_CONNSECMARK.c
@@ -66,7 +66,7 @@ static void secmark_restore(struct sk_bu
 static unsigned int target(struct sk_buff **pskb, const struct net_device =
*in,
 			   const struct net_device *out, unsigned int hooknum,
 			   const struct xt_target *target,
=2D			   const void *targinfo)
+			   const void *targinfo, void *data)
 {
 	struct sk_buff *skb =3D *pskb;
 	const struct xt_connsecmark_target_info *info =3D targinfo;
@@ -87,9 +87,9 @@ static unsigned int target(struct sk_buf
 	return XT_CONTINUE;
 }
=20
=2Dstatic int checkentry(const char *tablename, const void *entry,
=2D		      const struct xt_target *target, void *targinfo,
=2D		      unsigned int hook_mask)
+static int init(const char *tablename, const void *entry,
+		const struct xt_target *target, void *targinfo,
+		void *data, unsigned int hook_mask)
 {
 	struct xt_connsecmark_target_info *info =3D targinfo;
=20
@@ -110,7 +110,7 @@ static struct xt_target xt_connsecmark_t
 	{
 		.name		=3D "CONNSECMARK",
 		.family		=3D AF_INET,
=2D		.checkentry	=3D checkentry,
+		.init		=3D init,
 		.target		=3D target,
 		.targetsize	=3D sizeof(struct xt_connsecmark_target_info),
 		.table		=3D "mangle",
@@ -119,7 +119,7 @@ static struct xt_target xt_connsecmark_t
 	{
 		.name		=3D "CONNSECMARK",
 		.family		=3D AF_INET6,
=2D		.checkentry	=3D checkentry,
+		.init		=3D init,
 		.target		=3D target,
 		.targetsize	=3D sizeof(struct xt_connsecmark_target_info),
 		.table		=3D "mangle",
diff --git a/net/netfilter/xt_DSCP.c b/net/netfilter/xt_DSCP.c
index a7cc75a..8525c9e 100644
=2D-- a/net/netfilter/xt_DSCP.c
+++ b/net/netfilter/xt_DSCP.c
@@ -32,7 +32,8 @@ static unsigned int target(struct sk_buf
 			   const struct net_device *out,
 			   unsigned int hooknum,
 			   const struct xt_target *target,
=2D			   const void *targinfo)
+			   const void *targinfo,
+			   void *data)
 {
 	const struct xt_DSCP_info *dinfo =3D targinfo;
 	u_int8_t dscp =3D ipv4_get_dsfield((*pskb)->nh.iph) >> XT_DSCP_SHIFT;
@@ -53,7 +54,8 @@ static unsigned int target6(struct sk_bu
 			    const struct net_device *out,
 			    unsigned int hooknum,
 			    const struct xt_target *target,
=2D			    const void *targinfo)
+			    const void *targinfo,
+			    void *data)
 {
 	const struct xt_DSCP_info *dinfo =3D targinfo;
 	u_int8_t dscp =3D ipv6_get_dsfield((*pskb)->nh.ipv6h) >> XT_DSCP_SHIFT;
@@ -68,11 +70,12 @@ static unsigned int target6(struct sk_bu
 	return XT_CONTINUE;
 }
=20
=2Dstatic int checkentry(const char *tablename,
=2D		      const void *e_void,
=2D		      const struct xt_target *target,
=2D		      void *targinfo,
=2D		      unsigned int hook_mask)
+static int init(const char *tablename,
+		const void *e_void,
+		const struct xt_target *target,
+		void *targinfo,
+		void *data,
+		unsigned int hook_mask)
 {
 	const u_int8_t dscp =3D ((struct xt_DSCP_info *)targinfo)->dscp;
=20
@@ -87,7 +90,7 @@ static struct xt_target xt_dscp_target[]
 	{
 		.name		=3D "DSCP",
 		.family		=3D AF_INET,
=2D		.checkentry	=3D checkentry,
+		.init		=3D init,
 		.target		=3D target,
 		.targetsize	=3D sizeof(struct xt_DSCP_info),
 		.table		=3D "mangle",
@@ -96,7 +99,7 @@ static struct xt_target xt_dscp_target[]
 	{
 		.name		=3D "DSCP",
 		.family		=3D AF_INET6,
=2D		.checkentry	=3D checkentry,
+		.init		=3D init,
 		.target		=3D target6,
 		.targetsize	=3D sizeof(struct xt_DSCP_info),
 		.table		=3D "mangle",
diff --git a/net/netfilter/xt_MARK.c b/net/netfilter/xt_MARK.c
index 0b48547..c2a7775 100644
=2D-- a/net/netfilter/xt_MARK.c
+++ b/net/netfilter/xt_MARK.c
@@ -27,7 +27,8 @@ target_v0(struct sk_buff **pskb,
 	  const struct net_device *out,
 	  unsigned int hooknum,
 	  const struct xt_target *target,
=2D	  const void *targinfo)
+	  const void *targinfo,
+	  void *data)
 {
 	const struct xt_mark_target_info *markinfo =3D targinfo;
=20
@@ -43,7 +44,8 @@ target_v1(struct sk_buff **pskb,
 	  const struct net_device *out,
 	  unsigned int hooknum,
 	  const struct xt_target *target,
=2D	  const void *targinfo)
+	  const void *targinfo,
+	  void *data)
 {
 	const struct xt_mark_target_info_v1 *markinfo =3D targinfo;
 	int mark =3D 0;
@@ -70,11 +72,12 @@ target_v1(struct sk_buff **pskb,
=20
=20
 static int
=2Dcheckentry_v0(const char *tablename,
=2D	      const void *entry,
=2D	      const struct xt_target *target,
=2D	      void *targinfo,
=2D	      unsigned int hook_mask)
+init_v0(const char *tablename,
+	const void *entry,
+	const struct xt_target *target,
+	void *targinfo,
+	void *data,
+	unsigned int hook_mask)
 {
 	struct xt_mark_target_info *markinfo =3D targinfo;
=20
@@ -86,11 +89,12 @@ checkentry_v0(const char *tablename,
 }
=20
 static int
=2Dcheckentry_v1(const char *tablename,
=2D	      const void *entry,
=2D	      const struct xt_target *target,
=2D	      void *targinfo,
=2D	      unsigned int hook_mask)
+init_v1(const char *tablename,
+	const void *entry,
+	const struct xt_target *target,
+	void *targinfo,
+	void *data,
+	unsigned int hook_mask)
 {
 	struct xt_mark_target_info_v1 *markinfo =3D targinfo;
=20
@@ -142,7 +146,7 @@ static struct xt_target xt_mark_target[]
 		.name		=3D "MARK",
 		.family		=3D AF_INET,
 		.revision	=3D 0,
=2D		.checkentry	=3D checkentry_v0,
+		.init		=3D init_v0,
 		.target		=3D target_v0,
 		.targetsize	=3D sizeof(struct xt_mark_target_info),
 		.table		=3D "mangle",
@@ -152,7 +156,7 @@ static struct xt_target xt_mark_target[]
 		.name		=3D "MARK",
 		.family		=3D AF_INET,
 		.revision	=3D 1,
=2D		.checkentry	=3D checkentry_v1,
+		.init		=3D init_v1,
 		.target		=3D target_v1,
 		.targetsize	=3D sizeof(struct xt_mark_target_info_v1),
 #ifdef CONFIG_COMPAT
@@ -167,7 +171,7 @@ static struct xt_target xt_mark_target[]
 		.name		=3D "MARK",
 		.family		=3D AF_INET6,
 		.revision	=3D 0,
=2D		.checkentry	=3D checkentry_v0,
+		.init		=3D init_v0,
 		.target		=3D target_v0,
 		.targetsize	=3D sizeof(struct xt_mark_target_info),
 		.table		=3D "mangle",
diff --git a/net/netfilter/xt_NFLOG.c b/net/netfilter/xt_NFLOG.c
index 901ed7a..9aafb39 100644
=2D-- a/net/netfilter/xt_NFLOG.c
+++ b/net/netfilter/xt_NFLOG.c
@@ -23,7 +23,7 @@ static unsigned int
 nflog_target(struct sk_buff **pskb,
 	     const struct net_device *in, const struct net_device *out,
 	     unsigned int hooknum, const struct xt_target *target,
=2D	     const void *targinfo)
+	     const void *targinfo, void *data)
 {
 	const struct xt_nflog_info *info =3D targinfo;
 	struct nf_loginfo li;
@@ -39,9 +39,9 @@ nflog_target(struct sk_buff **pskb,
 }
=20
 static int
=2Dnflog_checkentry(const char *tablename, const void *entry,
=2D		 const struct xt_target *target, void *targetinfo,
=2D		 unsigned int hookmask)
+nflog_init(const char *tablename, const void *entry,
+	   const struct xt_target *target, void *targetinfo,
+	   void *data, unsigned int hookmask)
 {
 	struct xt_nflog_info *info =3D targetinfo;
=20
@@ -56,7 +56,7 @@ static struct xt_target xt_nflog_target[
 	{
 		.name		=3D "NFLOG",
 		.family		=3D AF_INET,
=2D		.checkentry	=3D nflog_checkentry,
+		.init		=3D nflog_init,
 		.target		=3D nflog_target,
 		.targetsize	=3D sizeof(struct xt_nflog_info),
 		.me		=3D THIS_MODULE,
@@ -64,7 +64,7 @@ static struct xt_target xt_nflog_target[
 	{
 		.name		=3D "NFLOG",
 		.family		=3D AF_INET6,
=2D		.checkentry	=3D nflog_checkentry,
+		.init		=3D nflog_init,
 		.target		=3D nflog_target,
 		.targetsize	=3D sizeof(struct xt_nflog_info),
 		.me		=3D THIS_MODULE,
diff --git a/net/netfilter/xt_NFQUEUE.c b/net/netfilter/xt_NFQUEUE.c
index 39e1175..efd7d95 100644
=2D-- a/net/netfilter/xt_NFQUEUE.c
+++ b/net/netfilter/xt_NFQUEUE.c
@@ -29,7 +29,8 @@ target(struct sk_buff **pskb,
        const struct net_device *out,
        unsigned int hooknum,
        const struct xt_target *target,
=2D       const void *targinfo)
+       const void *targinfo,
+       void *data)
 {
 	const struct xt_NFQ_info *tinfo =3D targinfo;
=20
diff --git a/net/netfilter/xt_NOTRACK.c b/net/netfilter/xt_NOTRACK.c
index 6d00dca..c6274d7 100644
=2D-- a/net/netfilter/xt_NOTRACK.c
+++ b/net/netfilter/xt_NOTRACK.c
@@ -16,7 +16,8 @@ target(struct sk_buff **pskb,
        const struct net_device *out,
        unsigned int hooknum,
        const struct xt_target *target,
=2D       const void *targinfo)
+       const void *targinfo,
+       void *data)
 {
 	/* Previously seen (loopback)? Ignore. */
 	if ((*pskb)->nfct !=3D NULL)
diff --git a/net/netfilter/xt_SECMARK.c b/net/netfilter/xt_SECMARK.c
index add7521..f7f698b 100644
=2D-- a/net/netfilter/xt_SECMARK.c
+++ b/net/netfilter/xt_SECMARK.c
@@ -31,7 +31,7 @@ static u8 mode;
 static unsigned int target(struct sk_buff **pskb, const struct net_device =
*in,
 			   const struct net_device *out, unsigned int hooknum,
 			   const struct xt_target *target,
=2D			   const void *targinfo)
+			   const void *targinfo, void *data)
 {
 	u32 secmark =3D 0;
 	const struct xt_secmark_target_info *info =3D targinfo;
@@ -83,9 +83,9 @@ static int checkentry_selinux(struct xt_
 	return 1;
 }
=20
=2Dstatic int checkentry(const char *tablename, const void *entry,
=2D		      const struct xt_target *target, void *targinfo,
=2D		      unsigned int hook_mask)
+static int init(const char *tablename, const void *entry,
+		const struct xt_target *target, void *targinfo,
+		void *data, unsigned int hook_mask)
 {
 	struct xt_secmark_target_info *info =3D targinfo;
=20
@@ -115,7 +115,7 @@ static struct xt_target xt_secmark_targe
 	{
 		.name		=3D "SECMARK",
 		.family		=3D AF_INET,
=2D		.checkentry	=3D checkentry,
+		.init		=3D init,
 		.target		=3D target,
 		.targetsize	=3D sizeof(struct xt_secmark_target_info),
 		.table		=3D "mangle",
@@ -124,7 +124,7 @@ static struct xt_target xt_secmark_targe
 	{
 		.name		=3D "SECMARK",
 		.family		=3D AF_INET6,
=2D		.checkentry	=3D checkentry,
+		.init		=3D init,
 		.target		=3D target,
 		.targetsize	=3D sizeof(struct xt_secmark_target_info),
 		.table		=3D "mangle",
=2D-=20
1.4.3.3
