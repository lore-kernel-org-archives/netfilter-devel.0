From: Massimiliano Hofer <max@nucleus.it>
Subject: [PATCH 1/4][data-condition]: instance data support in matches'
	prototypes and structures
Date: Tue, 5 Dec 2006 23:15:02 +0100
Message-ID: <200612052315.03166.max@nucleus.it>
References: <200612052312.28824.max@nucleus.it>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
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

=46rom 5cd5ac8bf04d15de1a3b370eedac4d7d3b7946d3 Mon Sep 17 00:00:00 2001
=46rom: Massimiliano Hofer <max@nucleus.it>
Date: Tue, 5 Dec 2006 22:48:10 +0100
Subject: [PATCH] [NETFILTER]: instance data support in matches' prototypes =
and structures

This patch adds support for instance specific data in matches.
Only prototype and structure changes are included here.
The real code will come in a separate patch.

Signed-off-by: Massimiliano Hofer <max@nucleus.it>
=2D--
 include/linux/netfilter/x_tables.h   |   23 +++++++++-----
 net/ipv4/netfilter/ip_tables.c       |   50 +++++++++++++++++--------------
 net/ipv4/netfilter/ipt_addrtype.c    |    2 +-
 net/ipv4/netfilter/ipt_ah.c          |   14 +++++----
 net/ipv4/netfilter/ipt_ecn.c         |   10 +++---
 net/ipv4/netfilter/ipt_iprange.c     |    1 +
 net/ipv4/netfilter/ipt_owner.c       |   14 +++++----
 net/ipv4/netfilter/ipt_recent.c      |   21 +++++++------
 net/ipv4/netfilter/ipt_tos.c         |    1 +
 net/ipv4/netfilter/ipt_ttl.c         |    2 +-
 net/ipv6/netfilter/ip6_tables.c      |   23 +++++++++-----
 net/ipv6/netfilter/ip6t_ah.c         |   14 +++++----
 net/ipv6/netfilter/ip6t_eui64.c      |    1 +
 net/ipv6/netfilter/ip6t_frag.c       |   14 +++++----
 net/ipv6/netfilter/ip6t_hbh.c        |   16 +++++----
 net/ipv6/netfilter/ip6t_hl.c         |    2 +-
 net/ipv6/netfilter/ip6t_ipv6header.c |   22 +++++++------
 net/ipv6/netfilter/ip6t_owner.c      |   14 +++++----
 net/ipv6/netfilter/ip6t_rt.c         |   14 +++++----
 net/netfilter/x_tables.c             |    8 ++--
 net/netfilter/xt_comment.c           |    1 +
 net/netfilter/xt_connbytes.c         |   16 +++++----
 net/netfilter/xt_connmark.c          |   18 ++++++-----
 net/netfilter/xt_conntrack.c         |   18 +++++++----
 net/netfilter/xt_dccp.c              |   16 +++++----
 net/netfilter/xt_dscp.c              |   17 ++++++----
 net/netfilter/xt_esp.c               |   16 +++++----
 net/netfilter/xt_hashlimit.c         |   18 ++++++-----
 net/netfilter/xt_helper.c            |   19 +++++++-----
 net/netfilter/xt_length.c            |    2 +
 net/netfilter/xt_limit.c             |   20 +++++++-----
 net/netfilter/xt_mac.c               |    1 +
 net/netfilter/xt_mark.c              |   16 +++++----
 net/netfilter/xt_multiport.c         |   54 +++++++++++++++++++-----------=
=2D---
 net/netfilter/xt_physdev.c           |   16 +++++----
 net/netfilter/xt_pkttype.c           |    1 +
 net/netfilter/xt_policy.c            |   19 ++++++-----
 net/netfilter/xt_quota.c             |   12 ++++----
 net/netfilter/xt_realm.c             |    1 +
 net/netfilter/xt_sctp.c              |   16 +++++----
 net/netfilter/xt_state.c             |   18 ++++++-----
 net/netfilter/xt_statistic.c         |   12 ++++----
 net/netfilter/xt_string.c            |   21 +++++++-----
 net/netfilter/xt_tcpmss.c            |    1 +
 net/netfilter/xt_tcpudp.c            |   44 +++++++++++++++------------
 45 files changed, 373 insertions(+), 286 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x=
_tables.h
index 022edfa..73147b4 100644
=2D-- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -20,6 +20,7 @@ struct xt_entry_match
=20
 			/* Used inside the kernel */
 			struct xt_match *match;
+			void *data;
 		} kernel;
=20
 		/* Total length */
@@ -138,20 +139,23 @@ struct xt_match
 		     const struct net_device *out,
 		     const struct xt_match *match,
 		     const void *matchinfo,
+		     void *data,
 		     int offset,
 		     unsigned int protoff,
 		     int *hotdrop);
=20
 	/* Called when user tries to insert an entry of this type. */
 	/* Should return true or false. */
=2D	int (*checkentry)(const char *tablename,
=2D			  const void *ip,
=2D			  const struct xt_match *match,
=2D			  void *matchinfo,
=2D			  unsigned int hook_mask);
+	int (*init)(const char *tablename,
+		    const void *ip,
+		    const struct xt_match *match,
+		    void *matchinfo,
+		    void *data,
+		    unsigned int hook_mask);
=20
 	/* Called when entry of this type deleted. */
=2D	void (*destroy)(const struct xt_match *match, void *matchinfo);
+	void (*destroy)(const struct xt_match *match, void *matchinfo,
+			void *data);
=20
 	/* Called when userspace align differs from kernel space one */
 	void (*compat_from_user)(void *dst, void *src);
@@ -164,6 +168,7 @@ struct xt_match
 	unsigned long data;
=20
 	char *table;
+	unsigned int datasize;
 	unsigned int matchsize;
 	unsigned int compatsize;
 	unsigned int hooks;
@@ -274,9 +279,9 @@ extern void xt_unregister_match(struct x
 extern int xt_register_matches(struct xt_match *match, unsigned int n);
 extern void xt_unregister_matches(struct xt_match *match, unsigned int n);
=20
=2Dextern int xt_check_match(const struct xt_match *match, unsigned short f=
amily,
=2D			  unsigned int size, const char *table, unsigned int hook,
=2D			  unsigned short proto, int inv_proto);
+extern int xt_init_match(const struct xt_match *match, unsigned short fami=
ly,
+			 unsigned int size, const char *table, unsigned int hook,
+			 unsigned short proto, int inv_proto);
 extern int xt_check_target(const struct xt_target *target, unsigned short =
family,
 			   unsigned int size, const char *table, unsigned int hook,
 			   unsigned short proto, int inv_proto);
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 8a45543..75fae96 100644
=2D-- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -198,7 +198,8 @@ int do_match(struct ipt_entry_match *m,
 {
 	/* Stop iteration if it doesn't match */
 	if (!m->u.kernel.match->match(skb, in, out, m->u.kernel.match, m->data,
=2D				      offset, skb->nh.iph->ihl*4, hotdrop))
+				      m->u.kernel.data, offset,
+				      skb->nh.iph->ihl*4, hotdrop))
 		return 1;
 	else
 		return 0;
@@ -464,7 +465,8 @@ cleanup_match(struct ipt_entry_match *m,
 		return 1;
=20
 	if (m->u.kernel.match->destroy)
=2D		m->u.kernel.match->destroy(m->u.kernel.match, m->data);
+		m->u.kernel.match->destroy(m->u.kernel.match, m->data,
+					   m->u.kernel.data);
 	module_put(m->u.kernel.match->me);
 	return 0;
 }
@@ -491,7 +493,7 @@ standard_check(const struct ipt_entry_ta
 }
=20
 static inline int
=2Dcheck_match(struct ipt_entry_match *m,
+init_match(struct ipt_entry_match *m,
 	    const char *name,
 	    const struct ipt_ip *ip,
 	    unsigned int hookmask,
@@ -509,15 +511,16 @@ check_match(struct ipt_entry_match *m,
 	}
 	m->u.kernel.match =3D match;
=20
=2D	ret =3D xt_check_match(match, AF_INET, m->u.match_size - sizeof(*m),
=2D			     name, hookmask, ip->proto,
=2D			     ip->invflags & IPT_INV_PROTO);
+	ret =3D xt_init_match(match, AF_INET, m->u.match_size - sizeof(*m),
+			    name, hookmask, ip->proto,
+			    ip->invflags & IPT_INV_PROTO);
 	if (ret)
 		goto err;
=20
=2D	if (m->u.kernel.match->checkentry
=2D	    && !m->u.kernel.match->checkentry(name, ip, match, m->data,
=2D					      hookmask)) {
+	m->u.kernel.data =3D NULL;
+	if (m->u.kernel.match->init
+	    && !m->u.kernel.match->init(name, ip, match, m->data,
+					m->u.kernel.data, hookmask)) {
 		duprintf("ip_tables: check failed for `%s'.\n",
 			 m->u.kernel.match->name);
 		ret =3D -EINVAL;
@@ -551,7 +554,7 @@ check_entry(struct ipt_entry *e, const c
 		return -EINVAL;
=20
 	j =3D 0;
=2D	ret =3D IPT_MATCH_ITERATE(e, check_match, name, &e->ip, e->comefrom, &j=
);
+	ret =3D IPT_MATCH_ITERATE(e, init_match, name, &e->ip, e->comefrom, &j);
 	if (ret !=3D 0)
 		goto cleanup_matches;
=20
@@ -1537,12 +1540,13 @@ static inline int compat_copy_match_from
 	match =3D m->u.kernel.match;
 	xt_compat_match_from_user(m, dstptr, size);
=20
=2D	ret =3D xt_check_match(match, AF_INET, dm->u.match_size - sizeof(*dm),
=2D			     name, hookmask, ip->proto,
=2D			     ip->invflags & IPT_INV_PROTO);
=2D	if (!ret && m->u.kernel.match->checkentry
=2D	    && !m->u.kernel.match->checkentry(name, ip, match, dm->data,
=2D					      hookmask)) {
+	ret =3D xt_init_match(match, AF_INET, dm->u.match_size - sizeof(*dm),
+			    name, hookmask, ip->proto,
+			    ip->invflags & IPT_INV_PROTO);
+	m->u.kernel.data =3D NULL;
+	if (!ret && m->u.kernel.match->init
+	    && !m->u.kernel.match->init(name, ip, match, dm->data,
+					m->u.kernel.data, hookmask)) {
 		duprintf("ip_tables: check failed for `%s'.\n",
 			 m->u.kernel.match->name);
 		ret =3D -EINVAL;
@@ -2092,6 +2096,7 @@ icmp_match(const struct sk_buff *skb,
 	   const struct net_device *out,
 	   const struct xt_match *match,
 	   const void *matchinfo,
+	   void *data,
 	   int offset,
 	   unsigned int protoff,
 	   int *hotdrop)
@@ -2122,11 +2127,12 @@ icmp_match(const struct sk_buff *skb,
=20
 /* Called when user tries to insert an entry of this type. */
 static int
=2Dicmp_checkentry(const char *tablename,
=2D	   const void *info,
=2D	   const struct xt_match *match,
=2D	   void *matchinfo,
=2D	   unsigned int hook_mask)
+icmp_init(const char *tablename,
+	  const void *info,
+	  const struct xt_match *match,
+	  void *matchinfo,
+	  void *data,
+	  unsigned int hook_mask)
 {
 	const struct ipt_icmp *icmpinfo =3D matchinfo;
=20
@@ -2175,7 +2181,7 @@ static struct ipt_match icmp_matchstruct
 	.matchsize	=3D sizeof(struct ipt_icmp),
 	.proto		=3D IPPROTO_ICMP,
 	.family		=3D AF_INET,
=2D	.checkentry	=3D icmp_checkentry,
+	.init		=3D icmp_init,
 };
=20
 static int __init ip_tables_init(void)
diff --git a/net/ipv4/netfilter/ipt_addrtype.c b/net/ipv4/netfilter/ipt_add=
rtype.c
index 7b60eb7..de3c961 100644
=2D-- a/net/ipv4/netfilter/ipt_addrtype.c
+++ b/net/ipv4/netfilter/ipt_addrtype.c
@@ -30,7 +30,7 @@ static inline int match_type(__be32 addr
 static int match(const struct sk_buff *skb,
 		 const struct net_device *in, const struct net_device *out,
 		 const struct xt_match *match, const void *matchinfo,
=2D		 int offset, unsigned int protoff, int *hotdrop)
+		 void *data, int offset, unsigned int protoff, int *hotdrop)
 {
 	const struct ipt_addrtype_info *info =3D matchinfo;
 	const struct iphdr *iph =3D skb->nh.iph;
diff --git a/net/ipv4/netfilter/ipt_ah.c b/net/ipv4/netfilter/ipt_ah.c
index 1798f86..0cee597 100644
=2D-- a/net/ipv4/netfilter/ipt_ah.c
+++ b/net/ipv4/netfilter/ipt_ah.c
@@ -41,6 +41,7 @@ match(const struct sk_buff *skb,
       const struct net_device *out,
       const struct xt_match *match,
       const void *matchinfo,
+      void *data,
       int offset,
       unsigned int protoff,
       int *hotdrop)
@@ -70,11 +71,12 @@ match(const struct sk_buff *skb,
=20
 /* Called when user tries to insert an entry of this type. */
 static int
=2Dcheckentry(const char *tablename,
=2D	   const void *ip_void,
=2D	   const struct xt_match *match,
=2D	   void *matchinfo,
=2D	   unsigned int hook_mask)
+init(const char *tablename,
+     const void *ip_void,
+     const struct xt_match *match,
+     void *matchinfo,
+     void *data,
+     unsigned int hook_mask)
 {
 	const struct ipt_ah *ahinfo =3D matchinfo;
=20
@@ -91,7 +93,7 @@ static struct ipt_match ah_match =3D {
 	.match		=3D match,
 	.matchsize	=3D sizeof(struct ipt_ah),
 	.proto		=3D IPPROTO_AH,
=2D	.checkentry	=3D checkentry,
+	.init		=3D init,
 	.me		=3D THIS_MODULE,
 };
=20
diff --git a/net/ipv4/netfilter/ipt_ecn.c b/net/ipv4/netfilter/ipt_ecn.c
index dafbdec..e9e7241 100644
=2D-- a/net/ipv4/netfilter/ipt_ecn.c
+++ b/net/ipv4/netfilter/ipt_ecn.c
@@ -68,7 +68,7 @@ static inline int match_tcp(const struct
 static int match(const struct sk_buff *skb,
 		 const struct net_device *in, const struct net_device *out,
 		 const struct xt_match *match, const void *matchinfo,
=2D		 int offset, unsigned int protoff, int *hotdrop)
+		 void *data, int offset, unsigned int protoff, int *hotdrop)
 {
 	const struct ipt_ecn_info *info =3D matchinfo;
=20
@@ -86,9 +86,9 @@ static int match(const struct sk_buff *s
 	return 1;
 }
=20
=2Dstatic int checkentry(const char *tablename, const void *ip_void,
=2D		      const struct xt_match *match,
=2D		      void *matchinfo, unsigned int hook_mask)
+static int init(const char *tablename, const void *ip_void,
+		const struct xt_match *match,
+		void *matchinfo, void *data, unsigned int hook_mask)
 {
 	const struct ipt_ecn_info *info =3D matchinfo;
 	const struct ipt_ip *ip =3D ip_void;
@@ -113,7 +113,7 @@ static struct ipt_match ecn_match =3D {
 	.name		=3D "ecn",
 	.match		=3D match,
 	.matchsize	=3D sizeof(struct ipt_ecn_info),
=2D	.checkentry	=3D checkentry,
+	.init		=3D init,
 	.me		=3D THIS_MODULE,
 };
=20
diff --git a/net/ipv4/netfilter/ipt_iprange.c b/net/ipv4/netfilter/ipt_ipra=
nge.c
index 5202edd..2b2439b 100644
=2D-- a/net/ipv4/netfilter/ipt_iprange.c
+++ b/net/ipv4/netfilter/ipt_iprange.c
@@ -29,6 +29,7 @@ match(const struct sk_buff *skb,
       const struct net_device *out,
       const struct xt_match *match,
       const void *matchinfo,
+      void *data,
       int offset, unsigned int protoff, int *hotdrop)
 {
 	const struct ipt_iprange_info *info =3D matchinfo;
diff --git a/net/ipv4/netfilter/ipt_owner.c b/net/ipv4/netfilter/ipt_owner.c
index 78c336f..c154360 100644
=2D-- a/net/ipv4/netfilter/ipt_owner.c
+++ b/net/ipv4/netfilter/ipt_owner.c
@@ -27,6 +27,7 @@ match(const struct sk_buff *skb,
       const struct net_device *out,
       const struct xt_match *match,
       const void *matchinfo,
+      void *data,
       int offset,
       unsigned int protoff,
       int *hotdrop)
@@ -52,11 +53,12 @@ match(const struct sk_buff *skb,
 }
=20
 static int
=2Dcheckentry(const char *tablename,
=2D           const void *ip,
=2D	   const struct xt_match *match,
=2D           void *matchinfo,
=2D           unsigned int hook_mask)
+init(const char *tablename,
+     const void *ip,
+     const struct xt_match *match,
+     void *matchinfo,
+     void *data,
+     unsigned int hook_mask)
 {
 	const struct ipt_owner_info *info =3D matchinfo;
=20
@@ -73,7 +75,7 @@ static struct ipt_match owner_match =3D {
 	.match		=3D match,
 	.matchsize	=3D sizeof(struct ipt_owner_info),
 	.hooks		=3D (1 << NF_IP_LOCAL_OUT) | (1 << NF_IP_POST_ROUTING),
=2D	.checkentry	=3D checkentry,
+	.init		=3D init,
 	.me		=3D THIS_MODULE,
 };
=20
diff --git a/net/ipv4/netfilter/ipt_recent.c b/net/ipv4/netfilter/ipt_recen=
t.c
index 126db44..278bdb3 100644
=2D-- a/net/ipv4/netfilter/ipt_recent.c
+++ b/net/ipv4/netfilter/ipt_recent.c
@@ -172,7 +172,7 @@ static int
 ipt_recent_match(const struct sk_buff *skb,
 		 const struct net_device *in, const struct net_device *out,
 		 const struct xt_match *match, const void *matchinfo,
=2D		 int offset, unsigned int protoff, int *hotdrop)
+		 void *data, int offset, unsigned int protoff, int *hotdrop)
 {
 	const struct ipt_recent_info *info =3D matchinfo;
 	struct recent_table *t;
@@ -235,9 +235,9 @@ out:
 }
=20
 static int
=2Dipt_recent_checkentry(const char *tablename, const void *ip,
=2D		      const struct xt_match *match, void *matchinfo,
=2D		      unsigned int hook_mask)
+ipt_recent_init(const char *tablename, const void *ip,
+		const struct xt_match *match, void *matchinfo,
+		void *data, unsigned int hook_mask)
 {
 	const struct ipt_recent_info *info =3D matchinfo;
 	struct recent_table *t;
@@ -293,7 +293,8 @@ out:
 }
=20
 static void
=2Dipt_recent_destroy(const struct xt_match *match, void *matchinfo)
+ipt_recent_destroy(const struct xt_match *match, void *matchinfo,
+		   void *data)
 {
 	const struct ipt_recent_info *info =3D matchinfo;
 	struct recent_table *t;
@@ -466,12 +467,12 @@ static struct ipt_match recent_match =3D {
 	.name		=3D "recent",
 	.match		=3D ipt_recent_match,
 	.matchsize	=3D sizeof(struct ipt_recent_info),
=2D	.checkentry	=3D ipt_recent_checkentry,
+	.init		=3D ipt_recent_init,
 	.destroy	=3D ipt_recent_destroy,
 	.me		=3D THIS_MODULE,
 };
=20
=2Dstatic int __init ipt_recent_init(void)
+static int __init ipt_recent_module_init(void)
 {
 	int err;
=20
@@ -492,7 +493,7 @@ static int __init ipt_recent_init(void)
 	return err;
 }
=20
=2Dstatic void __exit ipt_recent_exit(void)
+static void __exit ipt_recent_module_exit(void)
 {
 	BUG_ON(!list_empty(&tables));
 	ipt_unregister_match(&recent_match);
@@ -501,5 +502,5 @@ static void __exit ipt_recent_exit(void)
 #endif
 }
=20
=2Dmodule_init(ipt_recent_init);
=2Dmodule_exit(ipt_recent_exit);
+module_init(ipt_recent_module_init);
+module_exit(ipt_recent_module_exit);
diff --git a/net/ipv4/netfilter/ipt_tos.c b/net/ipv4/netfilter/ipt_tos.c
index 5549c39..f3433cd 100644
=2D-- a/net/ipv4/netfilter/ipt_tos.c
+++ b/net/ipv4/netfilter/ipt_tos.c
@@ -23,6 +23,7 @@ match(const struct sk_buff *skb,
       const struct net_device *out,
       const struct xt_match *match,
       const void *matchinfo,
+      void *data,
       int offset,
       unsigned int protoff,
       int *hotdrop)
diff --git a/net/ipv4/netfilter/ipt_ttl.c b/net/ipv4/netfilter/ipt_ttl.c
index a5243bd..de69ea6 100644
=2D-- a/net/ipv4/netfilter/ipt_ttl.c
+++ b/net/ipv4/netfilter/ipt_ttl.c
@@ -22,7 +22,7 @@ MODULE_LICENSE("GPL");
 static int match(const struct sk_buff *skb,
 		 const struct net_device *in, const struct net_device *out,
 		 const struct xt_match *match, const void *matchinfo,
=2D		 int offset, unsigned int protoff, int *hotdrop)
+		 void *data, int offset, unsigned int protoff, int *hotdrop)
 {
 	const struct ipt_ttl_info *info =3D matchinfo;
=20
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_table=
s.c
index f63fb86..dc5e1ad 100644
=2D-- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -238,6 +238,7 @@ int do_match(struct ip6t_entry_match *m,
 {
 	/* Stop iteration if it doesn't match */
 	if (!m->u.kernel.match->match(skb, in, out, m->u.kernel.match, m->data,
+				      m->u.kernel.data,
 				      offset, protoff, hotdrop))
 		return 1;
 	else
@@ -503,7 +504,8 @@ cleanup_match(struct ip6t_entry_match *m
 		return 1;
=20
 	if (m->u.kernel.match->destroy)
=2D		m->u.kernel.match->destroy(m->u.kernel.match, m->data);
+		m->u.kernel.match->destroy(m->u.kernel.match, m->data,
+					   m->u.kernel.data);
 	module_put(m->u.kernel.match->me);
 	return 0;
 }
@@ -548,15 +550,16 @@ check_match(struct ip6t_entry_match *m,
 	}
 	m->u.kernel.match =3D match;
=20
=2D	ret =3D xt_check_match(match, AF_INET6, m->u.match_size - sizeof(*m),
=2D			     name, hookmask, ipv6->proto,
=2D			     ipv6->invflags & IP6T_INV_PROTO);
+	ret =3D xt_init_match(match, AF_INET6, m->u.match_size - sizeof(*m),
+			    name, hookmask, ipv6->proto,
+			    ipv6->invflags & IP6T_INV_PROTO);
 	if (ret)
 		goto err;
=20
=2D	if (m->u.kernel.match->checkentry
=2D	    && !m->u.kernel.match->checkentry(name, ipv6, match,  m->data,
=2D					      hookmask)) {
+	m->u.kernel.data=3DNULL;
+	if (m->u.kernel.match->init
+	    && !m->u.kernel.match->init(name, ipv6, match,  m->data,
+					m->u.kernel.data, hookmask)) {
 		duprintf("ip_tables: check failed for `%s'.\n",
 			 m->u.kernel.match->name);
 		ret =3D -EINVAL;
@@ -1318,6 +1321,7 @@ icmp6_match(const struct sk_buff *skb,
 	   const struct net_device *out,
 	   const struct xt_match *match,
 	   const void *matchinfo,
+	   void *data,
 	   int offset,
 	   unsigned int protoff,
 	   int *hotdrop)
@@ -1347,10 +1351,11 @@ icmp6_match(const struct sk_buff *skb,
=20
 /* Called when user tries to insert an entry of this type. */
 static int
=2Dicmp6_checkentry(const char *tablename,
+icmp6_init(const char *tablename,
 	   const void *entry,
 	   const struct xt_match *match,
 	   void *matchinfo,
+	   void *data,
 	   unsigned int hook_mask)
 {
 	const struct ip6t_icmp *icmpinfo =3D matchinfo;
@@ -1387,7 +1392,7 @@ static struct ip6t_match icmp6_matchstru
 	.name		=3D "icmp6",
 	.match		=3D &icmp6_match,
 	.matchsize	=3D sizeof(struct ip6t_icmp),
=2D	.checkentry	=3D icmp6_checkentry,
+	.init		=3D icmp6_init,
 	.proto		=3D IPPROTO_ICMPV6,
 	.family		=3D AF_INET6,
 };
diff --git a/net/ipv6/netfilter/ip6t_ah.c b/net/ipv6/netfilter/ip6t_ah.c
index 4648664..616d250 100644
=2D-- a/net/ipv6/netfilter/ip6t_ah.c
+++ b/net/ipv6/netfilter/ip6t_ah.c
@@ -46,6 +46,7 @@ match(const struct sk_buff *skb,
       const struct net_device *out,
       const struct xt_match *match,
       const void *matchinfo,
+      void *data,
       int offset,
       unsigned int protoff,
       int *hotdrop)
@@ -103,11 +104,12 @@ match(const struct sk_buff *skb,
=20
 /* Called when user tries to insert an entry of this type. */
 static int
=2Dcheckentry(const char *tablename,
=2D          const void *entry,
=2D	  const struct xt_match *match,
=2D          void *matchinfo,
=2D          unsigned int hook_mask)
+init(const char *tablename,
+     const void *entry,
+     const struct xt_match *match,
+     void *matchinfo,
+     void *data,
+     unsigned int hook_mask)
 {
 	const struct ip6t_ah *ahinfo =3D matchinfo;
=20
@@ -122,7 +124,7 @@ static struct ip6t_match ah_match =3D {
 	.name		=3D "ah",
 	.match		=3D match,
 	.matchsize	=3D sizeof(struct ip6t_ah),
=2D	.checkentry	=3D checkentry,
+	.init		=3D init,
 	.me		=3D THIS_MODULE,
 };
=20
diff --git a/net/ipv6/netfilter/ip6t_eui64.c b/net/ipv6/netfilter/ip6t_eui6=
4.c
index 4f6b84c..c4842e3 100644
=2D-- a/net/ipv6/netfilter/ip6t_eui64.c
+++ b/net/ipv6/netfilter/ip6t_eui64.c
@@ -24,6 +24,7 @@ match(const struct sk_buff *skb,
       const struct net_device *out,
       const struct xt_match *match,
       const void *matchinfo,
+      void *data,
       int offset,
       unsigned int protoff,
       int *hotdrop)
diff --git a/net/ipv6/netfilter/ip6t_frag.c b/net/ipv6/netfilter/ip6t_frag.c
index cd22eaa..d272157 100644
=2D-- a/net/ipv6/netfilter/ip6t_frag.c
+++ b/net/ipv6/netfilter/ip6t_frag.c
@@ -45,6 +45,7 @@ match(const struct sk_buff *skb,
       const struct net_device *out,
       const struct xt_match *match,
       const void *matchinfo,
+      void *data,
       int offset,
       unsigned int protoff,
       int *hotdrop)
@@ -120,11 +121,12 @@ match(const struct sk_buff *skb,
=20
 /* Called when user tries to insert an entry of this type. */
 static int
=2Dcheckentry(const char *tablename,
=2D	   const void *ip,
=2D	   const struct xt_match *match,
=2D	   void *matchinfo,
=2D	   unsigned int hook_mask)
+init(const char *tablename,
+     const void *ip,
+     const struct xt_match *match,
+     void *matchinfo,
+     void *data,
+     unsigned int hook_mask)
 {
 	const struct ip6t_frag *fraginfo =3D matchinfo;
=20
@@ -139,7 +141,7 @@ static struct ip6t_match frag_match =3D {
 	.name		=3D "frag",
 	.match		=3D match,
 	.matchsize	=3D sizeof(struct ip6t_frag),
=2D	.checkentry	=3D checkentry,
+	.init		=3D init,
 	.me		=3D THIS_MODULE,
 };
=20
diff --git a/net/ipv6/netfilter/ip6t_hbh.c b/net/ipv6/netfilter/ip6t_hbh.c
index 3f25bab..0402cdc 100644
=2D-- a/net/ipv6/netfilter/ip6t_hbh.c
+++ b/net/ipv6/netfilter/ip6t_hbh.c
@@ -52,6 +52,7 @@ match(const struct sk_buff *skb,
       const struct net_device *out,
       const struct xt_match *match,
       const void *matchinfo,
+      void *data,
       int offset,
       unsigned int protoff,
       int *hotdrop)
@@ -174,11 +175,12 @@ match(const struct sk_buff *skb,
=20
 /* Called when user tries to insert an entry of this type. */
 static int
=2Dcheckentry(const char *tablename,
=2D	   const void *entry,
=2D	   const struct xt_match *match,
=2D	   void *matchinfo,
=2D	   unsigned int hook_mask)
+init(const char *tablename,
+     const void *entry,
+     const struct xt_match *match,
+     void *matchinfo,
+     void *data,
+     unsigned int hook_mask)
 {
 	const struct ip6t_opts *optsinfo =3D matchinfo;
=20
@@ -195,7 +197,7 @@ static struct xt_match opts_match[] =3D {
 		.family		=3D AF_INET6,
 		.match		=3D match,
 		.matchsize	=3D sizeof(struct ip6t_opts),
=2D		.checkentry	=3D checkentry,
+		.init		=3D init,
 		.me		=3D THIS_MODULE,
 		.data		=3D NEXTHDR_HOP,
 	},
@@ -204,7 +206,7 @@ static struct xt_match opts_match[] =3D {
 		.family		=3D AF_INET6,
 		.match		=3D match,
 		.matchsize	=3D sizeof(struct ip6t_opts),
=2D		.checkentry	=3D checkentry,
+		.init		=3D init,
 		.me		=3D THIS_MODULE,
 		.data		=3D NEXTHDR_DEST,
 	},
diff --git a/net/ipv6/netfilter/ip6t_hl.c b/net/ipv6/netfilter/ip6t_hl.c
index 44a729e..e4a0a5f 100644
=2D-- a/net/ipv6/netfilter/ip6t_hl.c
+++ b/net/ipv6/netfilter/ip6t_hl.c
@@ -21,7 +21,7 @@ MODULE_LICENSE("GPL");
 static int match(const struct sk_buff *skb,
 		 const struct net_device *in, const struct net_device *out,
 		 const struct xt_match *match, const void *matchinfo,
=2D		 int offset, unsigned int protoff, int *hotdrop)
+		 void *data, int offset, unsigned int protoff, int *hotdrop)
 {
 	const struct ip6t_hl_info *info =3D matchinfo;
 	const struct ipv6hdr *ip6h =3D skb->nh.ipv6h;
diff --git a/net/ipv6/netfilter/ip6t_ipv6header.c b/net/ipv6/netfilter/ip6t=
_ipv6header.c
index 3093c39..cadf1dc 100644
=2D-- a/net/ipv6/netfilter/ip6t_ipv6header.c
+++ b/net/ipv6/netfilter/ip6t_ipv6header.c
@@ -31,6 +31,7 @@ ipv6header_match(const struct sk_buff *s
 		 const struct net_device *out,
 		 const struct xt_match *match,
 		 const void *matchinfo,
+		 void *data,
 		 int offset,
 		 unsigned int protoff,
 		 int *hotdrop)
@@ -124,11 +125,12 @@ ipv6header_match(const struct sk_buff *s
 }
=20
 static int
=2Dipv6header_checkentry(const char *tablename,
=2D		      const void *ip,
=2D		      const struct xt_match *match,
=2D		      void *matchinfo,
=2D		      unsigned int hook_mask)
+ipv6header_init(const char *tablename,
+		const void *ip,
+		const struct xt_match *match,
+		void *matchinfo,
+		void *data,
+		unsigned int hook_mask)
 {
 	const struct ip6t_ipv6header_info *info =3D matchinfo;
=20
@@ -144,20 +146,20 @@ static struct ip6t_match ip6t_ipv6header
 	.name		=3D "ipv6header",
 	.match		=3D &ipv6header_match,
 	.matchsize	=3D sizeof(struct ip6t_ipv6header_info),
=2D	.checkentry	=3D &ipv6header_checkentry,
+	.init		=3D &ipv6header_init,
 	.destroy	=3D NULL,
 	.me		=3D THIS_MODULE,
 };
=20
=2Dstatic int __init ipv6header_init(void)
+static int __init ipv6header_module_init(void)
 {
 	return ip6t_register_match(&ip6t_ipv6header_match);
 }
=20
=2Dstatic void __exit ipv6header_exit(void)
+static void __exit ipv6header_module_exit(void)
 {
 	ip6t_unregister_match(&ip6t_ipv6header_match);
 }
=20
=2Dmodule_init(ipv6header_init);
=2Dmodule_exit(ipv6header_exit);
+module_init(ipv6header_module_init);
+module_exit(ipv6header_module_exit);
diff --git a/net/ipv6/netfilter/ip6t_owner.c b/net/ipv6/netfilter/ip6t_owne=
r.c
index 4eb9bbc..2e86bfe 100644
=2D-- a/net/ipv6/netfilter/ip6t_owner.c
+++ b/net/ipv6/netfilter/ip6t_owner.c
@@ -28,6 +28,7 @@ match(const struct sk_buff *skb,
       const struct net_device *out,
       const struct xt_match *match,
       const void *matchinfo,
+      void *data,
       int offset,
       unsigned int protoff,
       int *hotdrop)
@@ -53,11 +54,12 @@ match(const struct sk_buff *skb,
 }
=20
 static int
=2Dcheckentry(const char *tablename,
=2D	   const void *ip,
=2D	   const struct xt_match *match,
=2D	   void *matchinfo,
=2D	   unsigned int hook_mask)
+init(const char *tablename,
+     const void *ip,
+     const struct xt_match *match,
+     void *matchinfo,
+     void *data,
+     unsigned int hook_mask)
 {
 	const struct ip6t_owner_info *info =3D matchinfo;
=20
@@ -74,7 +76,7 @@ static struct ip6t_match owner_match =3D {
 	.match		=3D match,
 	.matchsize	=3D sizeof(struct ip6t_owner_info),
 	.hooks		=3D (1 << NF_IP6_LOCAL_OUT) | (1 << NF_IP6_POST_ROUTING),
=2D	.checkentry	=3D checkentry,
+	.init		=3D init,
 	.me		=3D THIS_MODULE,
 };
=20
diff --git a/net/ipv6/netfilter/ip6t_rt.c b/net/ipv6/netfilter/ip6t_rt.c
index 54d7d14..53dc9f0 100644
=2D-- a/net/ipv6/netfilter/ip6t_rt.c
+++ b/net/ipv6/netfilter/ip6t_rt.c
@@ -47,6 +47,7 @@ match(const struct sk_buff *skb,
       const struct net_device *out,
       const struct xt_match *match,
       const void *matchinfo,
+      void *data,
       int offset,
       unsigned int protoff,
       int *hotdrop)
@@ -198,11 +199,12 @@ match(const struct sk_buff *skb,
=20
 /* Called when user tries to insert an entry of this type. */
 static int
=2Dcheckentry(const char *tablename,
=2D	   const void *entry,
=2D	   const struct xt_match *match,
=2D	   void *matchinfo,
=2D	   unsigned int hook_mask)
+init(const char *tablename,
+     const void *entry,
+     const struct xt_match *match,
+     void *matchinfo,
+     void *data,
+     unsigned int hook_mask)
 {
 	const struct ip6t_rt *rtinfo =3D matchinfo;
=20
@@ -225,7 +227,7 @@ static struct ip6t_match rt_match =3D {
 	.name		=3D "rt",
 	.match		=3D match,
 	.matchsize	=3D sizeof(struct ip6t_rt),
=2D	.checkentry	=3D checkentry,
+	.init		=3D init,
 	.me		=3D THIS_MODULE,
 };
=20
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 8996584..d2ffe98 100644
=2D-- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -304,9 +304,9 @@ int xt_find_revision(int af, const char
 }
 EXPORT_SYMBOL_GPL(xt_find_revision);
=20
=2Dint xt_check_match(const struct xt_match *match, unsigned short family,
=2D                   unsigned int size, const char *table, unsigned int ho=
ok_mask,
=2D		   unsigned short proto, int inv_proto)
+int xt_init_match(const struct xt_match *match, unsigned short family,
+                  unsigned int size, const char *table, unsigned int hook_=
mask,
+		  unsigned short proto, int inv_proto)
 {
 	if (XT_ALIGN(match->matchsize) !=3D size) {
 		printk("%s_tables: %s match: invalid size %Zu !=3D %u\n",
@@ -331,7 +331,7 @@ int xt_check_match(const struct xt_match
 	}
 	return 0;
 }
=2DEXPORT_SYMBOL_GPL(xt_check_match);
+EXPORT_SYMBOL_GPL(xt_init_match);
=20
 #ifdef CONFIG_COMPAT
 int xt_compat_match_offset(struct xt_match *match)
diff --git a/net/netfilter/xt_comment.c b/net/netfilter/xt_comment.c
index 7db492d..047f499 100644
=2D-- a/net/netfilter/xt_comment.c
+++ b/net/netfilter/xt_comment.c
@@ -21,6 +21,7 @@ match(const struct sk_buff *skb,
       const struct net_device *out,
       const struct xt_match *match,
       const void *matchinfo,
+      void *data,
       int offset,
       unsigned int protooff,
       int *hotdrop)
diff --git a/net/netfilter/xt_connbytes.c b/net/netfilter/xt_connbytes.c
index dcc497e..759d8f3 100644
=2D-- a/net/netfilter/xt_connbytes.c
+++ b/net/netfilter/xt_connbytes.c
@@ -46,6 +46,7 @@ match(const struct sk_buff *skb,
       const struct net_device *out,
       const struct xt_match *match,
       const void *matchinfo,
+      void *data,
       int offset,
       unsigned int protoff,
       int *hotdrop)
@@ -121,11 +122,12 @@ match(const struct sk_buff *skb,
 		return (what >=3D sinfo->count.from);
 }
=20
=2Dstatic int check(const char *tablename,
=2D		 const void *ip,
=2D		 const struct xt_match *match,
=2D		 void *matchinfo,
=2D		 unsigned int hook_mask)
+static int init(const char *tablename,
+		const void *ip,
+		const struct xt_match *match,
+		void *matchinfo,
+		void *data,
+		unsigned int hook_mask)
 {
 	const struct xt_connbytes_info *sinfo =3D matchinfo;
=20
@@ -146,7 +148,7 @@ static struct xt_match xt_connbytes_matc
 	{
 		.name		=3D "connbytes",
 		.family		=3D AF_INET,
=2D		.checkentry	=3D check,
+		.init		=3D init,
 		.match		=3D match,
 		.matchsize	=3D sizeof(struct xt_connbytes_info),
 		.me		=3D THIS_MODULE
@@ -154,7 +156,7 @@ static struct xt_match xt_connbytes_matc
 	{
 		.name		=3D "connbytes",
 		.family		=3D AF_INET6,
=2D		.checkentry	=3D check,
+		.init		=3D init,
 		.match		=3D match,
 		.matchsize	=3D sizeof(struct xt_connbytes_info),
 		.me		=3D THIS_MODULE
diff --git a/net/netfilter/xt_connmark.c b/net/netfilter/xt_connmark.c
index a8f0305..5cd94a3 100644
=2D-- a/net/netfilter/xt_connmark.c
+++ b/net/netfilter/xt_connmark.c
@@ -37,6 +37,7 @@ match(const struct sk_buff *skb,
       const struct net_device *out,
       const struct xt_match *match,
       const void *matchinfo,
+      void *data,
       int offset,
       unsigned int protoff,
       int *hotdrop)
@@ -51,11 +52,12 @@ match(const struct sk_buff *skb,
 }
=20
 static int
=2Dcheckentry(const char *tablename,
=2D	   const void *ip,
=2D	   const struct xt_match *match,
=2D	   void *matchinfo,
=2D	   unsigned int hook_mask)
+init(const char *tablename,
+     const void *ip,
+     const struct xt_match *match,
+     void *matchinfo,
+     void *data,
+     unsigned int hook_mask)
 {
 	struct xt_connmark_info *cm =3D matchinfo;
=20
@@ -74,7 +76,7 @@ checkentry(const char *tablename,
 }
=20
 static void
=2Ddestroy(const struct xt_match *match, void *matchinfo)
+destroy(const struct xt_match *match, void *matchinfo, void *data)
 {
 #if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
 	nf_ct_l3proto_module_put(match->family);
@@ -116,7 +118,7 @@ static struct xt_match xt_connmark_match
 	{
 		.name		=3D "connmark",
 		.family		=3D AF_INET,
=2D		.checkentry	=3D checkentry,
+		.init		=3D init,
 		.match		=3D match,
 		.destroy	=3D destroy,
 		.matchsize	=3D sizeof(struct xt_connmark_info),
@@ -130,7 +132,7 @@ static struct xt_match xt_connmark_match
 	{
 		.name		=3D "connmark",
 		.family		=3D AF_INET6,
=2D		.checkentry	=3D checkentry,
+		.init		=3D init,
 		.match		=3D match,
 		.destroy	=3D destroy,
 		.matchsize	=3D sizeof(struct xt_connmark_info),
diff --git a/net/netfilter/xt_conntrack.c b/net/netfilter/xt_conntrack.c
index 0ea501a..d06ce02 100644
=2D-- a/net/netfilter/xt_conntrack.c
+++ b/net/netfilter/xt_conntrack.c
@@ -34,6 +34,7 @@ match(const struct sk_buff *skb,
       const struct net_device *out,
       const struct xt_match *match,
       const void *matchinfo,
+      void *data,
       int offset,
       unsigned int protoff,
       int *hotdrop)
@@ -130,6 +131,7 @@ match(const struct sk_buff *skb,
       const struct net_device *out,
       const struct xt_match *match,
       const void *matchinfo,
+      void *data,
       int offset,
       unsigned int protoff,
       int *hotdrop)
@@ -222,11 +224,12 @@ match(const struct sk_buff *skb,
 #endif /* CONFIG_NF_IP_CONNTRACK */
=20
 static int
=2Dcheckentry(const char *tablename,
=2D	   const void *ip,
=2D	   const struct xt_match *match,
=2D	   void *matchinfo,
=2D	   unsigned int hook_mask)
+init(const char *tablename,
+     const void *ip,
+     const struct xt_match *match,
+     void *matchinfo,
+     void *data,
+     unsigned int hook_mask)
 {
 #if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
 	if (nf_ct_l3proto_try_module_get(match->family) < 0) {
@@ -238,7 +241,8 @@ checkentry(const char *tablename,
 	return 1;
 }
=20
=2Dstatic void destroy(const struct xt_match *match, void *matchinfo)
+static void destroy(const struct xt_match *match, void *matchinfo,
+		    void *data)
 {
 #if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
 	nf_ct_l3proto_module_put(match->family);
@@ -248,7 +252,7 @@ static void destroy(const struct xt_matc
 static struct xt_match conntrack_match =3D {
 	.name		=3D "conntrack",
 	.match		=3D match,
=2D	.checkentry	=3D checkentry,
+	.init		=3D init,
 	.destroy	=3D destroy,
 	.matchsize	=3D sizeof(struct xt_conntrack_info),
 	.family		=3D AF_INET,
diff --git a/net/netfilter/xt_dccp.c b/net/netfilter/xt_dccp.c
index 3e6cf43..27e0a2f 100644
=2D-- a/net/netfilter/xt_dccp.c
+++ b/net/netfilter/xt_dccp.c
@@ -97,6 +97,7 @@ match(const struct sk_buff *skb,
       const struct net_device *out,
       const struct xt_match *match,
       const void *matchinfo,
+      void *data,
       int offset,
       unsigned int protoff,
       int *hotdrop)
@@ -127,11 +128,12 @@ match(const struct sk_buff *skb,
 }
=20
 static int
=2Dcheckentry(const char *tablename,
=2D	   const void *inf,
=2D	   const struct xt_match *match,
=2D	   void *matchinfo,
=2D	   unsigned int hook_mask)
+init(const char *tablename,
+    const void *inf,
+    const struct xt_match *match,
+    void *matchinfo,
+    void *data,
+    unsigned int hook_mask)
 {
 	const struct xt_dccp_info *info =3D matchinfo;
=20
@@ -144,7 +146,7 @@ static struct xt_match xt_dccp_match[] =3D
 	{
 		.name 		=3D "dccp",
 		.family		=3D AF_INET,
=2D		.checkentry	=3D checkentry,
+		.init		=3D init,
 		.match		=3D match,
 		.matchsize	=3D sizeof(struct xt_dccp_info),
 		.proto		=3D IPPROTO_DCCP,
@@ -153,7 +155,7 @@ static struct xt_match xt_dccp_match[] =3D
 	{
 		.name 		=3D "dccp",
 		.family		=3D AF_INET6,
=2D		.checkentry	=3D checkentry,
+		.init		=3D init,
 		.match		=3D match,
 		.matchsize	=3D sizeof(struct xt_dccp_info),
 		.proto		=3D IPPROTO_DCCP,
diff --git a/net/netfilter/xt_dscp.c b/net/netfilter/xt_dscp.c
index 26c7f4a..9a43d98 100644
=2D-- a/net/netfilter/xt_dscp.c
+++ b/net/netfilter/xt_dscp.c
@@ -29,6 +29,7 @@ static int match(const struct sk_buff *s
 		 const struct net_device *out,
 		 const struct xt_match *match,
 		 const void *matchinfo,
+		 void *data,
 		 int offset,
 		 unsigned int protoff,
 		 int *hotdrop)
@@ -44,6 +45,7 @@ static int match6(const struct sk_buff *
 		  const struct net_device *out,
 		  const struct xt_match *match,
 		  const void *matchinfo,
+		  void *data,
 		  int offset,
 		  unsigned int protoff,
 		  int *hotdrop)
@@ -54,11 +56,12 @@ static int match6(const struct sk_buff *
 	return (dscp =3D=3D info->dscp) ^ !!info->invert;
 }
=20
=2Dstatic int checkentry(const char *tablename,
=2D		      const void *info,
=2D		      const struct xt_match *match,
=2D		      void *matchinfo,
=2D		      unsigned int hook_mask)
+static int init(const char *tablename,
+		const void *info,
+		const struct xt_match *match,
+		void *matchinfo,
+		void *data,
+		unsigned int hook_mask)
 {
 	const u_int8_t dscp =3D ((struct xt_dscp_info *)matchinfo)->dscp;
=20
@@ -74,7 +77,7 @@ static struct xt_match xt_dscp_match[] =3D
 	{
 		.name		=3D "dscp",
 		.family		=3D AF_INET,
=2D		.checkentry	=3D checkentry,
+		.init		=3D init,
 		.match		=3D match,
 		.matchsize	=3D sizeof(struct xt_dscp_info),
 		.me		=3D THIS_MODULE,
@@ -82,7 +85,7 @@ static struct xt_match xt_dscp_match[] =3D
 	{
 		.name		=3D "dscp",
 		.family		=3D AF_INET6,
=2D		.checkentry	=3D checkentry,
+		.init		=3D init,
 		.match		=3D match6,
 		.matchsize	=3D sizeof(struct xt_dscp_info),
 		.me		=3D THIS_MODULE,
diff --git a/net/netfilter/xt_esp.c b/net/netfilter/xt_esp.c
index 7c95f14..dd3ebc8 100644
=2D-- a/net/netfilter/xt_esp.c
+++ b/net/netfilter/xt_esp.c
@@ -48,6 +48,7 @@ match(const struct sk_buff *skb,
       const struct net_device *out,
       const struct xt_match *match,
       const void *matchinfo,
+      void *data,
       int offset,
       unsigned int protoff,
       int *hotdrop)
@@ -75,11 +76,12 @@ match(const struct sk_buff *skb,
=20
 /* Called when user tries to insert an entry of this type. */
 static int
=2Dcheckentry(const char *tablename,
=2D	   const void *ip_void,
=2D	   const struct xt_match *match,
=2D	   void *matchinfo,
=2D	   unsigned int hook_mask)
+init(const char *tablename,
+     const void *ip_void,
+     const struct xt_match *match,
+     void *matchinfo,
+     void *data,
+     unsigned int hook_mask)
 {
 	const struct xt_esp *espinfo =3D matchinfo;
=20
@@ -95,7 +97,7 @@ static struct xt_match xt_esp_match[] =3D
 	{
 		.name		=3D "esp",
 		.family		=3D AF_INET,
=2D		.checkentry	=3D checkentry,
+		.init		=3D init,
 		.match		=3D match,
 		.matchsize	=3D sizeof(struct xt_esp),
 		.proto		=3D IPPROTO_ESP,
@@ -104,7 +106,7 @@ static struct xt_match xt_esp_match[] =3D
 	{
 		.name		=3D "esp",
 		.family		=3D AF_INET6,
=2D		.checkentry	=3D checkentry,
+		.init		=3D init,
 		.match		=3D match,
 		.matchsize	=3D sizeof(struct xt_esp),
 		.proto		=3D IPPROTO_ESP,
diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index a98de0b..100808e 100644
=2D-- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -439,6 +439,7 @@ hashlimit_match(const struct sk_buff *sk
 		const struct net_device *out,
 		const struct xt_match *match,
 		const void *matchinfo,
+		void *data,
 		int offset,
 		unsigned int protoff,
 		int *hotdrop)
@@ -493,11 +494,12 @@ hotdrop:
 }
=20
 static int
=2Dhashlimit_checkentry(const char *tablename,
=2D		     const void *inf,
=2D		     const struct xt_match *match,
=2D		     void *matchinfo,
=2D		     unsigned int hook_mask)
+hashlimit_init(const char *tablename,
+	       const void *inf,
+	       const struct xt_match *match,
+	       void *matchinfo,
+	       void *data,
+	       unsigned int hook_mask)
 {
 	struct xt_hashlimit_info *r =3D matchinfo;
=20
@@ -541,7 +543,7 @@ hashlimit_checkentry(const char *tablena
 }
=20
 static void
=2Dhashlimit_destroy(const struct xt_match *match, void *matchinfo)
+hashlimit_destroy(const struct xt_match *match, void *matchinfo, void *dat=
a)
 {
 	struct xt_hashlimit_info *r =3D matchinfo;
=20
@@ -583,7 +585,7 @@ static struct xt_match xt_hashlimit[] =3D
 		.compat_from_user =3D compat_from_user,
 		.compat_to_user	=3D compat_to_user,
 #endif
=2D		.checkentry	=3D hashlimit_checkentry,
+		.init		=3D hashlimit_init,
 		.destroy	=3D hashlimit_destroy,
 		.me		=3D THIS_MODULE
 	},
@@ -597,7 +599,7 @@ static struct xt_match xt_hashlimit[] =3D
 		.compat_from_user =3D compat_from_user,
 		.compat_to_user	=3D compat_to_user,
 #endif
=2D		.checkentry	=3D hashlimit_checkentry,
+		.init		=3D hashlimit_init,
 		.destroy	=3D hashlimit_destroy,
 		.me		=3D THIS_MODULE
 	},
diff --git a/net/netfilter/xt_helper.c b/net/netfilter/xt_helper.c
index 5d7818b..de437e5 100644
=2D-- a/net/netfilter/xt_helper.c
+++ b/net/netfilter/xt_helper.c
@@ -44,6 +44,7 @@ match(const struct sk_buff *skb,
       const struct net_device *out,
       const struct xt_match *match,
       const void *matchinfo,
+      void *data,
       int offset,
       unsigned int protoff,
       int *hotdrop)
@@ -92,6 +93,7 @@ match(const struct sk_buff *skb,
       const struct net_device *out,
       const struct xt_match *match,
       const void *matchinfo,
+      void *data,
       int offset,
       unsigned int protoff,
       int *hotdrop)
@@ -135,11 +137,12 @@ out_unlock:
 }
 #endif
=20
=2Dstatic int check(const char *tablename,
=2D		 const void *inf,
=2D		 const struct xt_match *match,
=2D		 void *matchinfo,
=2D		 unsigned int hook_mask)
+static int init(const char *tablename,
+		const void *inf,
+		const struct xt_match *match,
+		void *matchinfo,
+		void *data,
+		unsigned int hook_mask)
 {
 	struct xt_helper_info *info =3D matchinfo;
=20
@@ -155,7 +158,7 @@ static int check(const char *tablename,
 }
=20
 static void
=2Ddestroy(const struct xt_match *match, void *matchinfo)
+destroy(const struct xt_match *match, void *matchinfo, void *data)
 {
 #if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
 	nf_ct_l3proto_module_put(match->family);
@@ -166,7 +169,7 @@ static struct xt_match xt_helper_match[]
 	{
 		.name		=3D "helper",
 		.family		=3D AF_INET,
=2D		.checkentry	=3D check,
+		.init		=3D init,
 		.match		=3D match,
 		.destroy	=3D destroy,
 		.matchsize	=3D sizeof(struct xt_helper_info),
@@ -175,7 +178,7 @@ static struct xt_match xt_helper_match[]
 	{
 		.name		=3D "helper",
 		.family		=3D AF_INET6,
=2D		.checkentry	=3D check,
+		.init		=3D init,
 		.match		=3D match,
 		.destroy	=3D destroy,
 		.matchsize	=3D sizeof(struct xt_helper_info),
diff --git a/net/netfilter/xt_length.c b/net/netfilter/xt_length.c
index 67fd30d..74053bc 100644
=2D-- a/net/netfilter/xt_length.c
+++ b/net/netfilter/xt_length.c
@@ -26,6 +26,7 @@ match(const struct sk_buff *skb,
       const struct net_device *out,
       const struct xt_match *match,
       const void *matchinfo,
+      void *data,
       int offset,
       unsigned int protoff,
       int *hotdrop)
@@ -42,6 +43,7 @@ match6(const struct sk_buff *skb,
        const struct net_device *out,
        const struct xt_match *match,
        const void *matchinfo,
+       void *data,
        int offset,
        unsigned int protoff,
        int *hotdrop)
diff --git a/net/netfilter/xt_limit.c b/net/netfilter/xt_limit.c
index fda7b7d..a073df7 100644
=2D-- a/net/netfilter/xt_limit.c
+++ b/net/netfilter/xt_limit.c
@@ -5,8 +5,8 @@
  *                   Alexey is a fucking genius?
  *                   Rusty Russell (rusty@rustcorp.com.au).  */
=20
=2D/* (C) 1999 J=E9r=F4me de Vivie <devivie@info.enserb.u-bordeaux.fr>
=2D * (C) 1999 Herv=E9 Eychenne <eychenne@info.enserb.u-bordeaux.fr>
+/* (C) 1999 J=EF=BF=BD=EF=BF=BDe de Vivie <devivie@info.enserb.u-bordeaux.=
fr>
+ * (C) 1999 Herv=EF=BF=BDEychenne <eychenne@info.enserb.u-bordeaux.fr>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -70,6 +70,7 @@ ipt_limit_match(const struct sk_buff *sk
 		const struct net_device *out,
 		const struct xt_match *match,
 		const void *matchinfo,
+		void *data,
 		int offset,
 		unsigned int protoff,
 		int *hotdrop)
@@ -106,11 +107,12 @@ user2credits(u_int32_t user)
 }
=20
 static int
=2Dipt_limit_checkentry(const char *tablename,
=2D		     const void *inf,
=2D		     const struct xt_match *match,
=2D		     void *matchinfo,
=2D		     unsigned int hook_mask)
+ipt_limit_init(const char *tablename,
+	       const void *inf,
+	       const struct xt_match *match,
+	       void *matchinfo,
+	       void *data,
+	       unsigned int hook_mask)
 {
 	struct xt_rateinfo *r =3D matchinfo;
=20
@@ -183,7 +185,7 @@ static struct xt_match xt_limit_match[]
 	{
 		.name		=3D "limit",
 		.family		=3D AF_INET,
=2D		.checkentry	=3D ipt_limit_checkentry,
+		.init		=3D ipt_limit_init,
 		.match		=3D ipt_limit_match,
 		.matchsize	=3D sizeof(struct xt_rateinfo),
 #ifdef CONFIG_COMPAT
@@ -196,7 +198,7 @@ static struct xt_match xt_limit_match[]
 	{
 		.name		=3D "limit",
 		.family		=3D AF_INET6,
=2D		.checkentry	=3D ipt_limit_checkentry,
+		.init		=3D ipt_limit_init,
 		.match		=3D ipt_limit_match,
 		.matchsize	=3D sizeof(struct xt_rateinfo),
 		.me		=3D THIS_MODULE,
diff --git a/net/netfilter/xt_mac.c b/net/netfilter/xt_mac.c
index 425fc21..4b5eef2 100644
=2D-- a/net/netfilter/xt_mac.c
+++ b/net/netfilter/xt_mac.c
@@ -29,6 +29,7 @@ match(const struct sk_buff *skb,
       const struct net_device *out,
       const struct xt_match *match,
       const void *matchinfo,
+      void *data,
       int offset,
       unsigned int protoff,
       int *hotdrop)
diff --git a/net/netfilter/xt_mark.c b/net/netfilter/xt_mark.c
index dfa1ee6..733e049 100644
=2D-- a/net/netfilter/xt_mark.c
+++ b/net/netfilter/xt_mark.c
@@ -25,6 +25,7 @@ match(const struct sk_buff *skb,
       const struct net_device *out,
       const struct xt_match *match,
       const void *matchinfo,
+      void *data,
       int offset,
       unsigned int protoff,
       int *hotdrop)
@@ -35,11 +36,12 @@ match(const struct sk_buff *skb,
 }
=20
 static int
=2Dcheckentry(const char *tablename,
=2D           const void *entry,
=2D	   const struct xt_match *match,
=2D           void *matchinfo,
=2D           unsigned int hook_mask)
+init(const char *tablename,
+     const void *entry,
+     const struct xt_match *match,
+     void *matchinfo,
+     void *data,
+     unsigned int hook_mask)
 {
 	const struct xt_mark_info *minfo =3D matchinfo;
=20
@@ -85,7 +87,7 @@ static struct xt_match xt_mark_match[] =3D
 	{
 		.name		=3D "mark",
 		.family		=3D AF_INET,
=2D		.checkentry	=3D checkentry,
+		.init		=3D init,
 		.match		=3D match,
 		.matchsize	=3D sizeof(struct xt_mark_info),
 #ifdef CONFIG_COMPAT
@@ -98,7 +100,7 @@ static struct xt_match xt_mark_match[] =3D
 	{
 		.name		=3D "mark",
 		.family		=3D AF_INET6,
=2D		.checkentry	=3D checkentry,
+		.init		=3D init,
 		.match		=3D match,
 		.matchsize	=3D sizeof(struct xt_mark_info),
 		.me		=3D THIS_MODULE,
diff --git a/net/netfilter/xt_multiport.c b/net/netfilter/xt_multiport.c
index 1602086..2619dfc 100644
=2D-- a/net/netfilter/xt_multiport.c
+++ b/net/netfilter/xt_multiport.c
@@ -100,6 +100,7 @@ match(const struct sk_buff *skb,
       const struct net_device *out,
       const struct xt_match *match,
       const void *matchinfo,
+      void *data,
       int offset,
       unsigned int protoff,
       int *hotdrop)
@@ -131,6 +132,7 @@ match_v1(const struct sk_buff *skb,
 	 const struct net_device *out,
 	 const struct xt_match *match,
 	 const void *matchinfo,
+	 void *data,
 	 int offset,
 	 unsigned int protoff,
 	 int *hotdrop)
@@ -173,11 +175,12 @@ check(u_int16_t proto,
=20
 /* Called when user tries to insert an entry of this type. */
 static int
=2Dcheckentry(const char *tablename,
=2D	   const void *info,
=2D	   const struct xt_match *match,
=2D	   void *matchinfo,
=2D	   unsigned int hook_mask)
+init(const char *tablename,
+     const void *info,
+     const struct xt_match *match,
+     void *matchinfo,
+     void *data,
+     unsigned int hook_mask)
 {
 	const struct ipt_ip *ip =3D info;
 	const struct xt_multiport *multiinfo =3D matchinfo;
@@ -187,11 +190,12 @@ checkentry(const char *tablename,
 }
=20
 static int
=2Dcheckentry_v1(const char *tablename,
=2D	      const void *info,
=2D	      const struct xt_match *match,
=2D	      void *matchinfo,
=2D	      unsigned int hook_mask)
+init_v1(const char *tablename,
+	const void *info,
+	const struct xt_match *match,
+	void *matchinfo,
+	void *data,
+	unsigned int hook_mask)
 {
 	const struct ipt_ip *ip =3D info;
 	const struct xt_multiport_v1 *multiinfo =3D matchinfo;
@@ -201,11 +205,12 @@ checkentry_v1(const char *tablename,
 }
=20
 static int
=2Dcheckentry6(const char *tablename,
=2D	    const void *info,
=2D	    const struct xt_match *match,
=2D	    void *matchinfo,
=2D	    unsigned int hook_mask)
+init6(const char *tablename,
+      const void *info,
+      const struct xt_match *match,
+      void *matchinfo,
+      void *data,
+      unsigned int hook_mask)
 {
 	const struct ip6t_ip6 *ip =3D info;
 	const struct xt_multiport *multiinfo =3D matchinfo;
@@ -215,11 +220,12 @@ checkentry6(const char *tablename,
 }
=20
 static int
=2Dcheckentry6_v1(const char *tablename,
=2D	       const void *info,
=2D	       const struct xt_match *match,
=2D	       void *matchinfo,
=2D	       unsigned int hook_mask)
+init6_v1(const char *tablename,
+	 const void *info,
+	 const struct xt_match *match,
+	 void *matchinfo,
+	 void *data,
+	 unsigned int hook_mask)
 {
 	const struct ip6t_ip6 *ip =3D info;
 	const struct xt_multiport_v1 *multiinfo =3D matchinfo;
@@ -233,7 +239,7 @@ static struct xt_match xt_multiport_matc
 		.name		=3D "multiport",
 		.family		=3D AF_INET,
 		.revision	=3D 0,
=2D		.checkentry	=3D checkentry,
+		.init		=3D init,
 		.match		=3D match,
 		.matchsize	=3D sizeof(struct xt_multiport),
 		.me		=3D THIS_MODULE,
@@ -242,7 +248,7 @@ static struct xt_match xt_multiport_matc
 		.name		=3D "multiport",
 		.family		=3D AF_INET,
 		.revision	=3D 1,
=2D		.checkentry	=3D checkentry_v1,
+		.init		=3D init_v1,
 		.match		=3D match_v1,
 		.matchsize	=3D sizeof(struct xt_multiport_v1),
 		.me		=3D THIS_MODULE,
@@ -251,7 +257,7 @@ static struct xt_match xt_multiport_matc
 		.name		=3D "multiport",
 		.family		=3D AF_INET6,
 		.revision	=3D 0,
=2D		.checkentry	=3D checkentry6,
+		.init		=3D init6,
 		.match		=3D match,
 		.matchsize	=3D sizeof(struct xt_multiport),
 		.me		=3D THIS_MODULE,
@@ -260,7 +266,7 @@ static struct xt_match xt_multiport_matc
 		.name		=3D "multiport",
 		.family		=3D AF_INET6,
 		.revision	=3D 1,
=2D		.checkentry	=3D checkentry6_v1,
+		.init		=3D init6_v1,
 		.match		=3D match_v1,
 		.matchsize	=3D sizeof(struct xt_multiport_v1),
 		.me		=3D THIS_MODULE,
diff --git a/net/netfilter/xt_physdev.c b/net/netfilter/xt_physdev.c
index fd8f954..9fb445c 100644
=2D-- a/net/netfilter/xt_physdev.c
+++ b/net/netfilter/xt_physdev.c
@@ -29,6 +29,7 @@ match(const struct sk_buff *skb,
       const struct net_device *out,
       const struct xt_match *match,
       const void *matchinfo,
+      void *data,
       int offset,
       unsigned int protoff,
       int *hotdrop)
@@ -102,11 +103,12 @@ match_outdev:
 }
=20
 static int
=2Dcheckentry(const char *tablename,
=2D		       const void *ip,
=2D		       const struct xt_match *match,
=2D		       void *matchinfo,
=2D		       unsigned int hook_mask)
+init(const char *tablename,
+     const void *ip,
+     const struct xt_match *match,
+     void *matchinfo,
+     void *data,
+     unsigned int hook_mask)
 {
 	const struct xt_physdev_info *info =3D matchinfo;
=20
@@ -135,7 +137,7 @@ static struct xt_match xt_physdev_match[
 	{
 		.name		=3D "physdev",
 		.family		=3D AF_INET,
=2D		.checkentry	=3D checkentry,
+		.init		=3D init,
 		.match		=3D match,
 		.matchsize	=3D sizeof(struct xt_physdev_info),
 		.me		=3D THIS_MODULE,
@@ -143,7 +145,7 @@ static struct xt_match xt_physdev_match[
 	{
 		.name		=3D "physdev",
 		.family		=3D AF_INET6,
=2D		.checkentry	=3D checkentry,
+		.init		=3D init,
 		.match		=3D match,
 		.matchsize	=3D sizeof(struct xt_physdev_info),
 		.me		=3D THIS_MODULE,
diff --git a/net/netfilter/xt_pkttype.c b/net/netfilter/xt_pkttype.c
index 16e7b08..1445de5 100644
=2D-- a/net/netfilter/xt_pkttype.c
+++ b/net/netfilter/xt_pkttype.c
@@ -26,6 +26,7 @@ static int match(const struct sk_buff *s
       const struct net_device *out,
       const struct xt_match *match,
       const void *matchinfo,
+      void *data,
       int offset,
       unsigned int protoff,
       int *hotdrop)
diff --git a/net/netfilter/xt_policy.c b/net/netfilter/xt_policy.c
index 46bde2b..b7c5020 100644
=2D-- a/net/netfilter/xt_policy.c
+++ b/net/netfilter/xt_policy.c
@@ -113,6 +113,7 @@ static int match(const struct sk_buff *s
                  const struct net_device *out,
                  const struct xt_match *match,
                  const void *matchinfo,
+		 void *data,
                  int offset,
                  unsigned int protoff,
                  int *hotdrop)
@@ -133,9 +134,9 @@ static int match(const struct sk_buff *s
 	return ret;
 }
=20
=2Dstatic int checkentry(const char *tablename, const void *ip_void,
=2D                      const struct xt_match *match,
=2D                      void *matchinfo, unsigned int hook_mask)
+static int init(const char *tablename, const void *ip_void,
+                const struct xt_match *match,
+                void *matchinfo, void *data, unsigned int hook_mask)
 {
 	struct xt_policy_info *info =3D matchinfo;
=20
@@ -168,7 +169,7 @@ static struct xt_match xt_policy_match[]
 	{
 		.name		=3D "policy",
 		.family		=3D AF_INET,
=2D		.checkentry 	=3D checkentry,
+		.init		=3D init,
 		.match		=3D match,
 		.matchsize	=3D sizeof(struct xt_policy_info),
 		.me		=3D THIS_MODULE,
@@ -176,25 +177,25 @@ static struct xt_match xt_policy_match[]
 	{
 		.name		=3D "policy",
 		.family		=3D AF_INET6,
=2D		.checkentry	=3D checkentry,
+		.init		=3D init,
 		.match		=3D match,
 		.matchsize	=3D sizeof(struct xt_policy_info),
 		.me		=3D THIS_MODULE,
 	},
 };
=20
=2Dstatic int __init init(void)
+static int __init xt_policy_init(void)
 {
 	return xt_register_matches(xt_policy_match,
 				   ARRAY_SIZE(xt_policy_match));
 }
=20
=2Dstatic void __exit fini(void)
+static void __exit xt_policy_fini(void)
 {
 	xt_unregister_matches(xt_policy_match, ARRAY_SIZE(xt_policy_match));
 }
=20
=2Dmodule_init(init);
=2Dmodule_exit(fini);
+module_init(xt_policy_init);
+module_exit(xt_policy_fini);
 MODULE_ALIAS("ipt_policy");
 MODULE_ALIAS("ip6t_policy");
diff --git a/net/netfilter/xt_quota.c b/net/netfilter/xt_quota.c
index b75fa2c..a715b83 100644
=2D-- a/net/netfilter/xt_quota.c
+++ b/net/netfilter/xt_quota.c
@@ -20,7 +20,7 @@ static int
 match(const struct sk_buff *skb,
       const struct net_device *in, const struct net_device *out,
       const struct xt_match *match, const void *matchinfo,
=2D      int offset, unsigned int protoff, int *hotdrop)
+      void *data, int offset, unsigned int protoff, int *hotdrop)
 {
 	struct xt_quota_info *q =3D ((struct xt_quota_info *)matchinfo)->master;
 	int ret =3D q->flags & XT_QUOTA_INVERT ? 1 : 0;
@@ -39,9 +39,9 @@ match(const struct sk_buff *skb,
 }
=20
 static int
=2Dcheckentry(const char *tablename, const void *entry,
=2D	   const struct xt_match *match, void *matchinfo,
=2D	   unsigned int hook_mask)
+init(const char *tablename, const void *entry,
+     const struct xt_match *match, void *matchinfo,
+     void *data, unsigned int hook_mask)
 {
 	struct xt_quota_info *q =3D (struct xt_quota_info *)matchinfo;
=20
@@ -56,7 +56,7 @@ static struct xt_match xt_quota_match[]
 	{
 		.name		=3D "quota",
 		.family		=3D AF_INET,
=2D		.checkentry	=3D checkentry,
+		.init		=3D init,
 		.match		=3D match,
 		.matchsize	=3D sizeof(struct xt_quota_info),
 		.me		=3D THIS_MODULE
@@ -64,7 +64,7 @@ static struct xt_match xt_quota_match[]
 	{
 		.name		=3D "quota",
 		.family		=3D AF_INET6,
=2D		.checkentry	=3D checkentry,
+		.init		=3D init,
 		.match		=3D match,
 		.matchsize	=3D sizeof(struct xt_quota_info),
 		.me		=3D THIS_MODULE
diff --git a/net/netfilter/xt_realm.c b/net/netfilter/xt_realm.c
index a80b7d1..32df3d9 100644
=2D-- a/net/netfilter/xt_realm.c
+++ b/net/netfilter/xt_realm.c
@@ -29,6 +29,7 @@ match(const struct sk_buff *skb,
       const struct net_device *out,
       const struct xt_match *match,
       const void *matchinfo,
+      void *data,
       int offset,
       unsigned int protoff,
       int *hotdrop)
diff --git a/net/netfilter/xt_sctp.c b/net/netfilter/xt_sctp.c
index 71bf036..ab57309 100644
=2D-- a/net/netfilter/xt_sctp.c
+++ b/net/netfilter/xt_sctp.c
@@ -125,6 +125,7 @@ match(const struct sk_buff *skb,
       const struct net_device *out,
       const struct xt_match *match,
       const void *matchinfo,
+      void *data,
       int offset,
       unsigned int protoff,
       int *hotdrop)
@@ -159,11 +160,12 @@ match(const struct sk_buff *skb,
 }
=20
 static int
=2Dcheckentry(const char *tablename,
=2D	   const void *inf,
=2D	   const struct xt_match *match,
=2D	   void *matchinfo,
=2D	   unsigned int hook_mask)
+init(const char *tablename,
+     const void *inf,
+     const struct xt_match *match,
+     void *matchinfo,
+     void *data,
+     unsigned int hook_mask)
 {
 	const struct xt_sctp_info *info =3D matchinfo;
=20
@@ -181,7 +183,7 @@ static struct xt_match xt_sctp_match[] =3D
 	{
 		.name		=3D "sctp",
 		.family		=3D AF_INET,
=2D		.checkentry	=3D checkentry,
+		.init		=3D init,
 		.match		=3D match,
 		.matchsize	=3D sizeof(struct xt_sctp_info),
 		.proto		=3D IPPROTO_SCTP,
@@ -190,7 +192,7 @@ static struct xt_match xt_sctp_match[] =3D
 	{
 		.name		=3D "sctp",
 		.family		=3D AF_INET6,
=2D		.checkentry	=3D checkentry,
+		.init		=3D init,
 		.match		=3D match,
 		.matchsize	=3D sizeof(struct xt_sctp_info),
 		.proto		=3D IPPROTO_SCTP,
diff --git a/net/netfilter/xt_state.c b/net/netfilter/xt_state.c
index d9010b1..2269cbf 100644
=2D-- a/net/netfilter/xt_state.c
+++ b/net/netfilter/xt_state.c
@@ -26,6 +26,7 @@ match(const struct sk_buff *skb,
       const struct net_device *out,
       const struct xt_match *match,
       const void *matchinfo,
+      void *data,
       int offset,
       unsigned int protoff,
       int *hotdrop)
@@ -44,11 +45,12 @@ match(const struct sk_buff *skb,
 	return (sinfo->statemask & statebit);
 }
=20
=2Dstatic int check(const char *tablename,
=2D		 const void *inf,
=2D		 const struct xt_match *match,
=2D		 void *matchinfo,
=2D		 unsigned int hook_mask)
+static int init(const char *tablename,
+		const void *inf,
+		const struct xt_match *match,
+		void *matchinfo,
+		void *data,
+		unsigned int hook_mask)
 {
 #if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
 	if (nf_ct_l3proto_try_module_get(match->family) < 0) {
@@ -61,7 +63,7 @@ static int check(const char *tablename,
 }
=20
 static void
=2Ddestroy(const struct xt_match *match, void *matchinfo)
+destroy(const struct xt_match *match, void *matchinfo, void *data)
 {
 #if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
 	nf_ct_l3proto_module_put(match->family);
@@ -72,7 +74,7 @@ static struct xt_match xt_state_match[]
 	{
 		.name		=3D "state",
 		.family		=3D AF_INET,
=2D		.checkentry	=3D check,
+		.init		=3D init,
 		.match		=3D match,
 		.destroy	=3D destroy,
 		.matchsize	=3D sizeof(struct xt_state_info),
@@ -81,7 +83,7 @@ static struct xt_match xt_state_match[]
 	{
 		.name		=3D "state",
 		.family		=3D AF_INET6,
=2D		.checkentry	=3D check,
+		.init		=3D init,
 		.match		=3D match,
 		.destroy	=3D destroy,
 		.matchsize	=3D sizeof(struct xt_state_info),
diff --git a/net/netfilter/xt_statistic.c b/net/netfilter/xt_statistic.c
index 091a9f8..ed3a303 100644
=2D-- a/net/netfilter/xt_statistic.c
+++ b/net/netfilter/xt_statistic.c
@@ -28,7 +28,7 @@ static int
 match(const struct sk_buff *skb,
       const struct net_device *in, const struct net_device *out,
       const struct xt_match *match, const void *matchinfo,
=2D      int offset, unsigned int protoff, int *hotdrop)
+      void *data, int offset, unsigned int protoff, int *hotdrop)
 {
 	struct xt_statistic_info *info =3D (struct xt_statistic_info *)matchinfo;
 	int ret =3D info->flags & XT_STATISTIC_INVERT ? 1 : 0;
@@ -53,9 +53,9 @@ match(const struct sk_buff *skb,
 }
=20
 static int
=2Dcheckentry(const char *tablename, const void *entry,
=2D	   const struct xt_match *match, void *matchinfo,
=2D	   unsigned int hook_mask)
+init(const char *tablename, const void *entry,
+     const struct xt_match *match, void *matchinfo,
+     void *data, unsigned int hook_mask)
 {
 	struct xt_statistic_info *info =3D (struct xt_statistic_info *)matchinfo;
=20
@@ -70,7 +70,7 @@ static struct xt_match xt_statistic_matc
 	{
 		.name		=3D "statistic",
 		.family		=3D AF_INET,
=2D		.checkentry	=3D checkentry,
+		.init		=3D init,
 		.match		=3D match,
 		.matchsize	=3D sizeof(struct xt_statistic_info),
 		.me		=3D THIS_MODULE,
@@ -78,7 +78,7 @@ static struct xt_match xt_statistic_matc
 	{
 		.name		=3D "statistic",
 		.family		=3D AF_INET6,
=2D		.checkentry	=3D checkentry,
+		.init		=3D init,
 		.match		=3D match,
 		.matchsize	=3D sizeof(struct xt_statistic_info),
 		.me		=3D THIS_MODULE,
diff --git a/net/netfilter/xt_string.c b/net/netfilter/xt_string.c
index 4453252..253012e 100644
=2D-- a/net/netfilter/xt_string.c
+++ b/net/netfilter/xt_string.c
@@ -26,6 +26,7 @@ static int match(const struct sk_buff *s
 		 const struct net_device *out,
 		 const struct xt_match *match,
 		 const void *matchinfo,
+		 void *data,
 		 int offset,
 		 unsigned int protoff,
 		 int *hotdrop)
@@ -42,11 +43,12 @@ static int match(const struct sk_buff *s
=20
 #define STRING_TEXT_PRIV(m) ((struct xt_string_info *) m)
=20
=2Dstatic int checkentry(const char *tablename,
=2D		      const void *ip,
=2D		      const struct xt_match *match,
=2D		      void *matchinfo,
=2D		      unsigned int hook_mask)
+static int init(const char *tablename,
+		const void *ip,
+		const struct xt_match *match,
+		void *matchinfo,
+		void *data,
+		unsigned int hook_mask)
 {
 	struct xt_string_info *conf =3D matchinfo;
 	struct ts_config *ts_conf;
@@ -68,7 +70,8 @@ static int checkentry(const char *tablen
 	return 1;
 }
=20
=2Dstatic void destroy(const struct xt_match *match, void *matchinfo)
+static void destroy(const struct xt_match *match, void *matchinfo,
+		    void *data)
 {
 	textsearch_destroy(STRING_TEXT_PRIV(matchinfo)->config);
 }
@@ -77,7 +80,7 @@ static struct xt_match xt_string_match[]
 	{
 		.name 		=3D "string",
 		.family		=3D AF_INET,
=2D		.checkentry	=3D checkentry,
+		.init		=3D init,
 		.match 		=3D match,
 		.destroy 	=3D destroy,
 		.matchsize	=3D sizeof(struct xt_string_info),
@@ -86,8 +89,8 @@ static struct xt_match xt_string_match[]
 	{
 		.name 		=3D "string",
 		.family		=3D AF_INET6,
=2D		.checkentry	=3D checkentry,
=2D		.match 		=3D match,
+		.init		=3D init,
+		.match		=3D match,
 		.destroy 	=3D destroy,
 		.matchsize	=3D sizeof(struct xt_string_info),
 		.me 		=3D THIS_MODULE
diff --git a/net/netfilter/xt_tcpmss.c b/net/netfilter/xt_tcpmss.c
index a3682fe..c5c5e77 100644
=2D-- a/net/netfilter/xt_tcpmss.c
+++ b/net/netfilter/xt_tcpmss.c
@@ -29,6 +29,7 @@ match(const struct sk_buff *skb,
       const struct net_device *out,
       const struct xt_match *match,
       const void *matchinfo,
+      void *data,
       int offset,
       unsigned int protoff,
       int *hotdrop)
diff --git a/net/netfilter/xt_tcpudp.c b/net/netfilter/xt_tcpudp.c
index 46414b5..090ae2f 100644
=2D-- a/net/netfilter/xt_tcpudp.c
+++ b/net/netfilter/xt_tcpudp.c
@@ -76,6 +76,7 @@ tcp_match(const struct sk_buff *skb,
 	  const struct net_device *out,
 	  const struct xt_match *match,
 	  const void *matchinfo,
+	  void *data,
 	  int offset,
 	  unsigned int protoff,
 	  int *hotdrop)
@@ -137,11 +138,12 @@ tcp_match(const struct sk_buff *skb,
=20
 /* Called when user tries to insert an entry of this type. */
 static int
=2Dtcp_checkentry(const char *tablename,
=2D	       const void *info,
=2D	       const struct xt_match *match,
=2D	       void *matchinfo,
=2D	       unsigned int hook_mask)
+xt_tcp_init(const char *tablename,
+	    const void *info,
+	    const struct xt_match *match,
+	    void *matchinfo,
+	    void *data,
+	    unsigned int hook_mask)
 {
 	const struct xt_tcp *tcpinfo =3D matchinfo;
=20
@@ -155,6 +157,7 @@ udp_match(const struct sk_buff *skb,
 	  const struct net_device *out,
 	  const struct xt_match *match,
 	  const void *matchinfo,
+	  void *data,
 	  int offset,
 	  unsigned int protoff,
 	  int *hotdrop)
@@ -185,11 +188,12 @@ udp_match(const struct sk_buff *skb,
=20
 /* Called when user tries to insert an entry of this type. */
 static int
=2Dudp_checkentry(const char *tablename,
=2D	       const void *info,
=2D	       const struct xt_match *match,
=2D	       void *matchinfo,
=2D	       unsigned int hook_mask)
+xt_udp_init(const char *tablename,
+	    const void *info,
+	    const struct xt_match *match,
+	    void *matchinfo,
+	    void *data,
+	    unsigned int hook_mask)
 {
 	const struct xt_tcp *udpinfo =3D matchinfo;
=20
@@ -201,7 +205,7 @@ static struct xt_match xt_tcpudp_match[]
 	{
 		.name		=3D "tcp",
 		.family		=3D AF_INET,
=2D		.checkentry	=3D tcp_checkentry,
+		.init		=3D xt_tcp_init,
 		.match		=3D tcp_match,
 		.matchsize	=3D sizeof(struct xt_tcp),
 		.proto		=3D IPPROTO_TCP,
@@ -210,7 +214,7 @@ static struct xt_match xt_tcpudp_match[]
 	{
 		.name		=3D "tcp",
 		.family		=3D AF_INET6,
=2D		.checkentry	=3D tcp_checkentry,
+		.init		=3D xt_tcp_init,
 		.match		=3D tcp_match,
 		.matchsize	=3D sizeof(struct xt_tcp),
 		.proto		=3D IPPROTO_TCP,
@@ -219,7 +223,7 @@ static struct xt_match xt_tcpudp_match[]
 	{
 		.name		=3D "udp",
 		.family		=3D AF_INET,
=2D		.checkentry	=3D udp_checkentry,
+		.init		=3D xt_udp_init,
 		.match		=3D udp_match,
 		.matchsize	=3D sizeof(struct xt_udp),
 		.proto		=3D IPPROTO_UDP,
@@ -228,7 +232,7 @@ static struct xt_match xt_tcpudp_match[]
 	{
 		.name		=3D "udp",
 		.family		=3D AF_INET6,
=2D		.checkentry	=3D udp_checkentry,
+		.init		=3D xt_udp_init,
 		.match		=3D udp_match,
 		.matchsize	=3D sizeof(struct xt_udp),
 		.proto		=3D IPPROTO_UDP,
@@ -237,7 +241,7 @@ static struct xt_match xt_tcpudp_match[]
 	{
 		.name		=3D "udplite",
 		.family		=3D AF_INET,
=2D		.checkentry	=3D udp_checkentry,
+		.init		=3D xt_udp_init,
 		.match		=3D udp_match,
 		.matchsize	=3D sizeof(struct xt_udp),
 		.proto		=3D IPPROTO_UDPLITE,
@@ -246,7 +250,7 @@ static struct xt_match xt_tcpudp_match[]
 	{
 		.name		=3D "udplite",
 		.family		=3D AF_INET6,
=2D		.checkentry	=3D udp_checkentry,
+		.init		=3D xt_udp_init,
 		.match		=3D udp_match,
 		.matchsize	=3D sizeof(struct xt_udp),
 		.proto		=3D IPPROTO_UDPLITE,
@@ -254,16 +258,16 @@ static struct xt_match xt_tcpudp_match[]
 	},
 };
=20
=2Dstatic int __init xt_tcpudp_init(void)
+static int __init xt_tcpudp_module_init(void)
 {
 	return xt_register_matches(xt_tcpudp_match,
 				   ARRAY_SIZE(xt_tcpudp_match));
 }
=20
=2Dstatic void __exit xt_tcpudp_fini(void)
+static void __exit xt_tcpudp_module_fini(void)
 {
 	xt_unregister_matches(xt_tcpudp_match, ARRAY_SIZE(xt_tcpudp_match));
 }
=20
=2Dmodule_init(xt_tcpudp_init);
=2Dmodule_exit(xt_tcpudp_fini);
+module_init(xt_tcpudp_module_init);
+module_exit(xt_tcpudp_module_fini);
=2D-=20
1.4.3.3
