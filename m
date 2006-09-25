From: Massimiliano Hofer <max@nucleus.it>
Subject: [PATCH 1/2][priv_data-condition][part 2/2][matches_and_targets]
Date: Mon, 25 Sep 2006 10:17:33 +0200
Message-ID: <200609251017.34183.max@nucleus.it>
References: <200609250040.49298.max@nucleus.it>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <200609250040.49298.max@nucleus.it>
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

=46rom b24cd99b101357a5829ef22d45e5730bf0f1890d Mon Sep 17 00:00:00 2001
=46rom: Massimiliano Hofer <max@nucleus.it>
Date: Mon, 25 Sep 2006 10:09:07 +0200
Subject: [PATCH] priv_data-matches_and_targets

This patch adds support for instance specific data in matches and
targets.
This patch complements the core update.

Signed-off-by: Massimiliano Hofer <max@nucleus.it>
=2D--
 include/linux/netfilter/x_tables.h   |    4 +-
 net/ipv4/netfilter/arpt_mangle.c     |    8 ++---
 net/ipv4/netfilter/ip_nat_rule.c     |   32 +++++++++++--------
 net/ipv4/netfilter/ip_tables.c       |    6 ++--
 net/ipv4/netfilter/ipt_CLUSTERIP.c   |   19 ++++++-----
 net/ipv4/netfilter/ipt_ECN.c         |   16 +++++----
 net/ipv4/netfilter/ipt_LOG.c         |   24 ++++++++------
 net/ipv4/netfilter/ipt_MASQUERADE.c  |   16 +++++----
 net/ipv4/netfilter/ipt_NETMAP.c      |   16 +++++----
 net/ipv4/netfilter/ipt_REDIRECT.c    |   16 +++++----
 net/ipv4/netfilter/ipt_REJECT.c      |   16 +++++----
 net/ipv4/netfilter/ipt_SAME.c        |   18 ++++++-----
 net/ipv4/netfilter/ipt_TCPMSS.c      |   24 ++++++++------
 net/ipv4/netfilter/ipt_TOS.c         |   16 +++++----
 net/ipv4/netfilter/ipt_TTL.c         |   23 +++++++------
 net/ipv4/netfilter/ipt_ULOG.c        |   24 ++++++++------
 net/ipv4/netfilter/ipt_addrtype.c    |    3 +-
 net/ipv4/netfilter/ipt_ah.c          |   16 +++++----
 net/ipv4/netfilter/ipt_ecn.c         |   11 ++++--
 net/ipv4/netfilter/ipt_hashlimit.c   |   23 ++++++++-----
 net/ipv4/netfilter/ipt_owner.c       |   16 +++++----
 net/ipv4/netfilter/ipt_recent.c      |   22 +++++++------
 net/ipv4/netfilter/ipt_tos.c         |    3 +-
 net/ipv4/netfilter/ipt_ttl.c         |    3 +-
 net/ipv6/netfilter/ip6t_HL.c         |   24 ++++++++------
 net/ipv6/netfilter/ip6t_LOG.c        |   24 ++++++++------
 net/ipv6/netfilter/ip6t_REJECT.c     |   24 ++++++++------
 net/ipv6/netfilter/ip6t_ah.c         |   16 +++++----
 net/ipv6/netfilter/ip6t_eui64.c      |    3 +-
 net/ipv6/netfilter/ip6t_frag.c       |   16 +++++----
 net/ipv6/netfilter/ip6t_hbh.c        |   18 ++++++-----
 net/ipv6/netfilter/ip6t_ipv6header.c |   24 ++++++++------
 net/ipv6/netfilter/ip6t_owner.c      |   16 +++++----
 net/ipv6/netfilter/ip6t_rt.c         |   16 +++++----
 net/netfilter/xt_CLASSIFY.c          |    3 +-
 net/netfilter/xt_CONNMARK.c          |   18 ++++++-----
 net/netfilter/xt_DSCP.c              |   21 +++++++-----
 net/netfilter/xt_MARK.c              |   34 +++++++++++---------
 net/netfilter/xt_NFQUEUE.c           |    3 +-
 net/netfilter/xt_NOTRACK.c           |    3 +-
 net/netfilter/xt_SECMARK.c           |   12 ++++---
 net/netfilter/xt_comment.c           |    3 +-
 net/netfilter/xt_connbytes.c         |   18 ++++++-----
 net/netfilter/xt_connmark.c          |   20 ++++++------
 net/netfilter/xt_conntrack.c         |   22 ++++++++-----
 net/netfilter/xt_dccp.c              |   18 ++++++-----
 net/netfilter/xt_dscp.c              |   21 +++++++-----
 net/netfilter/xt_esp.c               |   18 ++++++-----
 net/netfilter/xt_helper.c            |   23 ++++++++-----
 net/netfilter/xt_length.c            |    6 ++--
 net/netfilter/xt_limit.c             |   22 +++++++------
 net/netfilter/xt_mac.c               |    3 +-
 net/netfilter/xt_mark.c              |   18 ++++++-----
 net/netfilter/xt_multiport.c         |   58 +++++++++++++++++++-----------=
=2D---
 net/netfilter/xt_physdev.c           |   18 ++++++-----
 net/netfilter/xt_pkttype.c           |    3 +-
 net/netfilter/xt_policy.c            |   21 ++++++------
 net/netfilter/xt_quota.c             |   13 ++++----
 net/netfilter/xt_realm.c             |    3 +-
 net/netfilter/xt_sctp.c              |   18 ++++++-----
 net/netfilter/xt_state.c             |   20 ++++++------
 net/netfilter/xt_statistic.c         |   12 ++++---
 net/netfilter/xt_string.c            |   23 ++++++++-----
 net/netfilter/xt_tcpmss.c            |    3 +-
 net/netfilter/xt_tcpudp.c            |   44 ++++++++++++++------------
 65 files changed, 600 insertions(+), 478 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x=
_tables.h
index e855fd2..6c3e689 100644
=2D-- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -404,13 +404,13 @@ extern int xt_compat_match_offset(struct
 extern void xt_compat_match_from_user(struct xt_entry_match *m,
 				      void **dstptr, int *size);
 extern int xt_compat_match_to_user(struct xt_entry_match *m,
=2D				   void * __user *dstptr, int *size);
+				   void __user **dstptr, int *size);
=20
 extern int xt_compat_target_offset(struct xt_target *target);
 extern void xt_compat_target_from_user(struct xt_entry_target *t,
 				       void **dstptr, int *size);
 extern int xt_compat_target_to_user(struct xt_entry_target *t,
=2D				    void * __user *dstptr, int *size);
+				    void __user **dstptr, int *size);
=20
 #endif /* CONFIG_COMPAT */
 #endif /* __KERNEL__ */
diff --git a/net/ipv4/netfilter/arpt_mangle.c b/net/ipv4/netfilter/arpt_man=
gle.c
index d12b1df..ce77517 100644
=2D-- a/net/ipv4/netfilter/arpt_mangle.c
+++ b/net/ipv4/netfilter/arpt_mangle.c
@@ -11,7 +11,7 @@ static unsigned int
 target(struct sk_buff **pskb,
        const struct net_device *in, const struct net_device *out,
        unsigned int hooknum, const struct xt_target *target,
=2D       const void *targinfo)
+       const void *targinfo, void *priv_data)
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
+     void *targinfo, unsigned int hook_mask, void *priv_data)
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
index 7b70383..4753724 100644
=2D-- a/net/ipv4/netfilter/ip_nat_rule.c
+++ b/net/ipv4/netfilter/ip_nat_rule.c
@@ -100,7 +100,8 @@ static unsigned int ipt_snat_target(stru
 				    const struct net_device *out,
 				    unsigned int hooknum,
 				    const struct ipt_target *target,
=2D				    const void *targinfo)
+				    const void *targinfo,
+				    void *priv_data)
 {
 	struct ip_conntrack *ct;
 	enum ip_conntrack_info ctinfo;
@@ -142,7 +143,8 @@ static unsigned int ipt_dnat_target(stru
 				    const struct net_device *out,
 				    unsigned int hooknum,
 				    const struct ipt_target *target,
=2D				    const void *targinfo)
+				    const void *targinfo,
+				    void *priv_data)
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
+			 unsigned int hook_mask,
+			 void *priv_data)
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
+			 unsigned int hook_mask,
+			 void *priv_data)
 {
 	struct ip_nat_multi_range_compat *mr =3D targinfo;
=20
@@ -263,7 +267,7 @@ static struct ipt_target ipt_snat_reg =3D=20
 	.targetsize	=3D sizeof(struct ip_nat_multi_range_compat),
 	.table		=3D "nat",
 	.hooks		=3D 1 << NF_IP_POST_ROUTING,
=2D	.checkentry	=3D ipt_snat_checkentry,
+	.init		=3D ipt_snat_init,
 };
=20
 static struct ipt_target ipt_dnat_reg =3D {
@@ -272,7 +276,7 @@ static struct ipt_target ipt_dnat_reg =3D=20
 	.targetsize	=3D sizeof(struct ip_nat_multi_range_compat),
 	.table		=3D "nat",
 	.hooks		=3D (1 << NF_IP_PRE_ROUTING) | (1 << NF_IP_LOCAL_OUT),
=2D	.checkentry	=3D ipt_dnat_checkentry,
+	.init		=3D ipt_dnat_init,
 };
=20
 int __init ip_nat_rule_init(void)
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index d96f322..88feb21 100644
=2D-- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -1350,15 +1350,15 @@ struct compat_ipt_replace {
 };
=20
 static inline int compat_copy_match_to_user(struct ipt_entry_match *m,
=2D		void * __user *dstptr, compat_uint_t *size)
+		void __user **dstptr, compat_uint_t *size)
 {
 	return xt_compat_match_to_user(m, dstptr, size);
 }
=20
 static int compat_copy_entry_to_user(struct ipt_entry *e,
=2D		void * __user *dstptr, compat_uint_t *size)
+		void __user **dstptr, compat_uint_t *size)
 {
=2D	struct ipt_entry_target __user *t;
+	struct ipt_entry_target *t;
 	struct compat_ipt_entry __user *ce;
 	u_int16_t target_offset, next_offset;
 	compat_uint_t origsize;
diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CL=
USTERIP.c
index 4158966..cf06bef 100644
=2D-- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -302,7 +302,8 @@ target(struct sk_buff **pskb,
        const struct net_device *out,
        unsigned int hooknum,
        const struct xt_target *target,
=2D       const void *targinfo)
+       const void *targinfo,
+       void *priv_data)
 {
 	const struct ipt_clusterip_tgt_info *cipinfo =3D targinfo;
 	enum ip_conntrack_info ctinfo;
@@ -368,11 +369,12 @@ #endif
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
+     unsigned int hook_mask,
+     void *priv_data)
 {
 	struct ipt_clusterip_tgt_info *cipinfo =3D targinfo;
 	const struct ipt_entry *e =3D e_void;
@@ -448,7 +450,8 @@ checkentry(const char *tablename,
 }
=20
 /* drop reference count of cluster config when rule is deleted */
=2Dstatic void destroy(const struct xt_target *target, void *targinfo)
+static void destroy(const struct xt_target *target, void *targinfo,
+		    void *priv_data)
 {
 	struct ipt_clusterip_tgt_info *cipinfo =3D targinfo;
=20
@@ -463,7 +466,7 @@ static struct ipt_target clusterip_tgt =3D
 	.name		=3D "CLUSTERIP",
 	.target		=3D target,
 	.targetsize	=3D sizeof(struct ipt_clusterip_tgt_info),
=2D	.checkentry	=3D checkentry,
+	.init		=3D init,
 	.destroy	=3D destroy,
 	.me		=3D THIS_MODULE
 };
diff --git a/net/ipv4/netfilter/ipt_ECN.c b/net/ipv4/netfilter/ipt_ECN.c
index 23f9c7e..6a59955 100644
=2D-- a/net/ipv4/netfilter/ipt_ECN.c
+++ b/net/ipv4/netfilter/ipt_ECN.c
@@ -85,7 +85,8 @@ target(struct sk_buff **pskb,
        const struct net_device *out,
        unsigned int hooknum,
        const struct xt_target *target,
=2D       const void *targinfo)
+       const void *targinfo,
+       void *priv_data)
 {
 	const struct ipt_ECN_info *einfo =3D targinfo;
=20
@@ -102,11 +103,12 @@ target(struct sk_buff **pskb,
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
+     unsigned int hook_mask,
+     void *priv_data)
 {
 	const struct ipt_ECN_info *einfo =3D (struct ipt_ECN_info *)targinfo;
 	const struct ipt_entry *e =3D e_void;
@@ -135,7 +137,7 @@ static struct ipt_target ipt_ecn_reg =3D {
 	.target		=3D target,
 	.targetsize	=3D sizeof(struct ipt_ECN_info),
 	.table		=3D "mangle",
=2D	.checkentry	=3D checkentry,
+	.init		=3D init,
 	.me		=3D THIS_MODULE,
 };
=20
diff --git a/net/ipv4/netfilter/ipt_LOG.c b/net/ipv4/netfilter/ipt_LOG.c
index 7dc820d..4e9c05e 100644
=2D-- a/net/ipv4/netfilter/ipt_LOG.c
+++ b/net/ipv4/netfilter/ipt_LOG.c
@@ -416,7 +416,8 @@ ipt_log_target(struct sk_buff **pskb,
 	       const struct net_device *out,
 	       unsigned int hooknum,
 	       const struct xt_target *target,
=2D	       const void *targinfo)
+	       const void *targinfo,
+	       void *priv_data)
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
+			unsigned int hook_mask,
+			void *priv_data)
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
index bc65168..0926e92 100644
=2D-- a/net/ipv4/netfilter/ipt_MASQUERADE.c
+++ b/net/ipv4/netfilter/ipt_MASQUERADE.c
@@ -38,11 +38,12 @@ static DEFINE_RWLOCK(masq_lock);
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
+		unsigned int hook_mask,
+		void *priv_data)
 {
 	const struct ip_nat_multi_range_compat *mr =3D targinfo;
=20
@@ -63,7 +64,8 @@ masquerade_target(struct sk_buff **pskb,
 		  const struct net_device *out,
 		  unsigned int hooknum,
 		  const struct xt_target *target,
=2D		  const void *targinfo)
+		  const void *targinfo,
+		  void *priv_data)
 {
 	struct ip_conntrack *ct;
 	enum ip_conntrack_info ctinfo;
@@ -168,7 +170,7 @@ static struct ipt_target masquerade =3D {
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
index beb2914..596be72 100644
=2D-- a/net/ipv4/netfilter/ipt_NETMAP.c
+++ b/net/ipv4/netfilter/ipt_NETMAP.c
@@ -29,11 +29,12 @@ #define DEBUGP(format, args...)
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
+     unsigned int hook_mask,
+     void *priv_data)
 {
 	const struct ip_nat_multi_range_compat *mr =3D targinfo;
=20
@@ -54,7 +55,8 @@ target(struct sk_buff **pskb,
        const struct net_device *out,
        unsigned int hooknum,
        const struct xt_target *target,
=2D       const void *targinfo)
+       const void *targinfo,
+       void *priv_data)
 {
 	struct ip_conntrack *ct;
 	enum ip_conntrack_info ctinfo;
@@ -91,7 +93,7 @@ static struct ipt_target target_module =3D
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
index f03d436..c342d0d 100644
=2D-- a/net/ipv4/netfilter/ipt_REDIRECT.c
+++ b/net/ipv4/netfilter/ipt_REDIRECT.c
@@ -32,11 +32,12 @@ #endif
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
+	      unsigned int hook_mask,
+	      void *priv_data)
 {
 	const struct ip_nat_multi_range_compat *mr =3D targinfo;
=20
@@ -57,7 +58,8 @@ redirect_target(struct sk_buff **pskb,
 		const struct net_device *out,
 		unsigned int hooknum,
 		const struct xt_target *target,
=2D		const void *targinfo)
+		const void *targinfo,
+		void *priv_data)
 {
 	struct ip_conntrack *ct;
 	enum ip_conntrack_info ctinfo;
@@ -106,7 +108,7 @@ static struct ipt_target redirect_reg =3D=20
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
index b81821e..c7c6973 100644
=2D-- a/net/ipv4/netfilter/ipt_REJECT.c
+++ b/net/ipv4/netfilter/ipt_REJECT.c
@@ -228,7 +228,8 @@ static unsigned int reject(struct sk_buf
 			   const struct net_device *out,
 			   unsigned int hooknum,
 			   const struct xt_target *target,
=2D			   const void *targinfo)
+			   const void *targinfo,
+			   void *priv_data)
 {
 	const struct ipt_reject_info *reject =3D targinfo;
=20
@@ -272,11 +273,12 @@ static unsigned int reject(struct sk_buf
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
+		unsigned int hook_mask,
+		void *priv_data)
 {
  	const struct ipt_reject_info *rejinfo =3D targinfo;
 	const struct ipt_entry *e =3D e_void;
@@ -302,7 +304,7 @@ static struct ipt_target ipt_reject_reg=20
 	.table		=3D "filter",
 	.hooks		=3D (1 << NF_IP_LOCAL_IN) | (1 << NF_IP_FORWARD) |
 			  (1 << NF_IP_LOCAL_OUT),
=2D	.checkentry	=3D check,
+	.init		=3D init,
 	.me		=3D THIS_MODULE,
 };
=20
diff --git a/net/ipv4/netfilter/ipt_SAME.c b/net/ipv4/netfilter/ipt_SAME.c
index efbcb11..819d1ac 100644
=2D-- a/net/ipv4/netfilter/ipt_SAME.c
+++ b/net/ipv4/netfilter/ipt_SAME.c
@@ -48,11 +48,12 @@ #define DEBUGP(format, args...)
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
+	  unsigned int hook_mask,
+	  void *priv_data)
 {
 	unsigned int count, countess, rangeip, index =3D 0;
 	struct ipt_same_info *mr =3D targinfo;
@@ -115,7 +116,7 @@ same_check(const char *tablename,
 }
=20
 static void=20
=2Dsame_destroy(const struct xt_target *target, void *targinfo)
+same_destroy(const struct xt_target *target, void *targinfo, void *priv_da=
ta)
 {
 	struct ipt_same_info *mr =3D targinfo;
=20
@@ -131,7 +132,8 @@ same_target(struct sk_buff **pskb,
 		const struct net_device *out,
 		unsigned int hooknum,
 		const struct xt_target *target,
=2D		const void *targinfo)
+		const void *targinfo,
+		void *priv_data)
 {
 	struct ip_conntrack *ct;
 	enum ip_conntrack_info ctinfo;
@@ -181,7 +183,7 @@ static struct ipt_target same_reg =3D {=20
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
index 4246c43..f726a8b 100644
=2D-- a/net/ipv4/netfilter/ipt_TCPMSS.c
+++ b/net/ipv4/netfilter/ipt_TCPMSS.c
@@ -37,7 +37,8 @@ ipt_tcpmss_target(struct sk_buff **pskb,
 		  const struct net_device *out,
 		  unsigned int hooknum,
 		  const struct xt_target *target,
=2D		  const void *targinfo)
+		  const void *targinfo,
+		  void *priv_data)
 {
 	const struct ipt_tcpmss_info *tcpmssinfo =3D targinfo;
 	struct tcphdr *tcph;
@@ -167,11 +168,12 @@ static inline int find_syn_match(const s
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
+		unsigned int hook_mask,
+		void *priv_data)
 {
 	const struct ipt_tcpmss_info *tcpmssinfo =3D targinfo;
 	const struct ipt_entry *e =3D e_void;
@@ -196,19 +198,19 @@ static struct ipt_target ipt_tcpmss_reg=20
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
index 471a4c4..0fe2aae 100644
=2D-- a/net/ipv4/netfilter/ipt_TOS.c
+++ b/net/ipv4/netfilter/ipt_TOS.c
@@ -26,7 +26,8 @@ target(struct sk_buff **pskb,
        const struct net_device *out,
        unsigned int hooknum,
        const struct xt_target *target,
=2D       const void *targinfo)
+       const void *targinfo,
+       void *priv_data)
 {
 	const struct ipt_tos_target_info *tosinfo =3D targinfo;
 	struct iphdr *iph =3D (*pskb)->nh.iph;
@@ -45,11 +46,12 @@ target(struct sk_buff **pskb,
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
+     unsigned int hook_mask,
+     void *priv_data)
 {
 	const u_int8_t tos =3D ((struct ipt_tos_target_info *)targinfo)->tos;
=20
@@ -69,7 +71,7 @@ static struct ipt_target ipt_tos_reg =3D {
 	.target		=3D target,
 	.targetsize	=3D sizeof(struct ipt_tos_target_info),
 	.table		=3D "mangle",
=2D	.checkentry	=3D checkentry,
+	.init		=3D init,
 	.me		=3D THIS_MODULE,
 };
=20
diff --git a/net/ipv4/netfilter/ipt_TTL.c b/net/ipv4/netfilter/ipt_TTL.c
index 96e79cc..d5200c2 100644
=2D-- a/net/ipv4/netfilter/ipt_TTL.c
+++ b/net/ipv4/netfilter/ipt_TTL.c
@@ -23,7 +23,7 @@ static unsigned int=20
 ipt_ttl_target(struct sk_buff **pskb,
 	       const struct net_device *in, const struct net_device *out,
 	       unsigned int hooknum, const struct xt_target *target,
=2D	       const void *targinfo)
+	       const void *targinfo, void *priv_data)
 {
 	struct iphdr *iph;
 	const struct ipt_TTL_info *info =3D targinfo;
@@ -63,11 +63,12 @@ ipt_ttl_target(struct sk_buff **pskb,
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
+			unsigned int hook_mask,
+			void *priv_data)
 {
 	struct ipt_TTL_info *info =3D targinfo;
=20
@@ -86,19 +87,19 @@ static struct ipt_target ipt_TTL =3D {=20
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
index 2b104ea..0bff5aa 100644
=2D-- a/net/ipv4/netfilter/ipt_ULOG.c
+++ b/net/ipv4/netfilter/ipt_ULOG.c
@@ -308,7 +308,8 @@ static unsigned int ipt_ulog_target(stru
 				    const struct net_device *out,
 				    unsigned int hooknum,
 				    const struct xt_target *target,
=2D				    const void *targinfo)
+				    const void *targinfo,
+				    void *priv_data)
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
+			 unsigned int hookmask,
+			 void *priv_data)
 {
 	struct ipt_ulog_info *loginfo =3D (struct ipt_ulog_info *) targinfo;
=20
@@ -367,7 +369,7 @@ static struct ipt_target ipt_ulog_reg =3D=20
 	.name		=3D "ULOG",
 	.target		=3D ipt_ulog_target,
 	.targetsize	=3D sizeof(struct ipt_ulog_info),
=2D	.checkentry	=3D ipt_ulog_checkentry,
+	.init	=3D ipt_ulog_init,
 	.me		=3D THIS_MODULE,
 };
=20
@@ -377,7 +379,7 @@ static struct nf_logger ipt_ulog_logger=20
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
diff --git a/net/ipv4/netfilter/ipt_addrtype.c b/net/ipv4/netfilter/ipt_add=
rtype.c
index 893dae2..ec2b279 100644
=2D-- a/net/ipv4/netfilter/ipt_addrtype.c
+++ b/net/ipv4/netfilter/ipt_addrtype.c
@@ -30,7 +30,8 @@ static inline int match_type(u_int32_t a
 static int match(const struct sk_buff *skb,
 		 const struct net_device *in, const struct net_device *out,
 		 const struct xt_match *match, const void *matchinfo,
=2D		 int offset, unsigned int protoff, int *hotdrop)
+		 int offset, unsigned int protoff, int *hotdrop,
+		 void *priv_data)
 {
 	const struct ipt_addrtype_info *info =3D matchinfo;
 	const struct iphdr *iph =3D skb->nh.iph;
diff --git a/net/ipv4/netfilter/ipt_ah.c b/net/ipv4/netfilter/ipt_ah.c
index 1798f86..8d446d6 100644
=2D-- a/net/ipv4/netfilter/ipt_ah.c
+++ b/net/ipv4/netfilter/ipt_ah.c
@@ -43,7 +43,8 @@ match(const struct sk_buff *skb,
       const void *matchinfo,
       int offset,
       unsigned int protoff,
=2D      int *hotdrop)
+      int *hotdrop,
+      void *priv_data)
 {
 	struct ip_auth_hdr _ahdr, *ah;
 	const struct ipt_ah *ahinfo =3D matchinfo;
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
+     unsigned int hook_mask,
+     void *priv_data)
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
index dafbdec..d6ec37a 100644
=2D-- a/net/ipv4/netfilter/ipt_ecn.c
+++ b/net/ipv4/netfilter/ipt_ecn.c
@@ -68,7 +68,8 @@ static inline int match_tcp(const struct
 static int match(const struct sk_buff *skb,
 		 const struct net_device *in, const struct net_device *out,
 		 const struct xt_match *match, const void *matchinfo,
=2D		 int offset, unsigned int protoff, int *hotdrop)
+		 int offset, unsigned int protoff, int *hotdrop,
+		 void *priv_data)
 {
 	const struct ipt_ecn_info *info =3D matchinfo;
=20
@@ -86,9 +87,9 @@ static int match(const struct sk_buff *s
 	return 1;
 }
=20
=2Dstatic int checkentry(const char *tablename, const void *ip_void,
=2D		      const struct xt_match *match,
=2D		      void *matchinfo, unsigned int hook_mask)
+static int init(const char *tablename, const void *ip_void,
+		const struct xt_match *match,
+		void *matchinfo, unsigned int hook_mask, void *priv_data)
 {
 	const struct ipt_ecn_info *info =3D matchinfo;
 	const struct ipt_ip *ip =3D ip_void;
@@ -113,7 +114,7 @@ static struct ipt_match ecn_match =3D {
 	.name		=3D "ecn",
 	.match		=3D match,
 	.matchsize	=3D sizeof(struct ipt_ecn_info),
=2D	.checkentry	=3D checkentry,
+	.init		=3D init,
 	.me		=3D THIS_MODULE,
 };
=20
diff --git a/net/ipv4/netfilter/ipt_hashlimit.c b/net/ipv4/netfilter/ipt_ha=
shlimit.c
index 4f73a61..12acead 100644
=2D-- a/net/ipv4/netfilter/ipt_hashlimit.c
+++ b/net/ipv4/netfilter/ipt_hashlimit.c
@@ -8,8 +8,8 @@
  * Development of this code was funded by Astaro AG, http://www.astaro.com/
  *
  * based on ipt_limit.c by:
=2D * J=E9r=F4me de Vivie	<devivie@info.enserb.u-bordeaux.fr>
=2D * Herv=E9 Eychenne	<eychenne@info.enserb.u-bordeaux.fr>
+ * J=EF=BF=BD=EF=BF=BDe de Vivie	<devivie@info.enserb.u-bordeaux.fr>
+ * Herv=EF=BF=BDEychenne	<eychenne@info.enserb.u-bordeaux.fr>
  * Rusty Russell	<rusty@rustcorp.com.au>
  *
  * The general idea is to create a hash table for every dstip and have a
@@ -389,7 +389,8 @@ hashlimit_match(const struct sk_buff *sk
 		const void *matchinfo,
 		int offset,
 		unsigned int protoff,
=2D		int *hotdrop)
+		int *hotdrop,
+		void *priv_data)
 {
 	struct ipt_hashlimit_info *r =3D=20
 		((struct ipt_hashlimit_info *)matchinfo)->u.master;
@@ -474,11 +475,12 @@ hashlimit_match(const struct sk_buff *sk
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
+	       unsigned int hook_mask,
+	       void *priv_data)
 {
 	struct ipt_hashlimit_info *r =3D matchinfo;
=20
@@ -528,7 +530,8 @@ hashlimit_checkentry(const char *tablena
 }
=20
 static void
=2Dhashlimit_destroy(const struct xt_match *match, void *matchinfo)
+hashlimit_destroy(const struct xt_match *match, void *matchinfo,
+		  void *priv_data)
 {
 	struct ipt_hashlimit_info *r =3D matchinfo;
=20
@@ -568,7 +571,7 @@ #ifdef CONFIG_COMPAT
 	.compat_from_user =3D compat_from_user,
 	.compat_to_user	=3D compat_to_user,
 #endif
=2D	.checkentry	=3D hashlimit_checkentry,
+	.init		=3D hashlimit_init,
 	.destroy	=3D hashlimit_destroy,
 	.me		=3D THIS_MODULE
 };
diff --git a/net/ipv4/netfilter/ipt_owner.c b/net/ipv4/netfilter/ipt_owner.c
index 78c336f..478451e 100644
=2D-- a/net/ipv4/netfilter/ipt_owner.c
+++ b/net/ipv4/netfilter/ipt_owner.c
@@ -29,7 +29,8 @@ match(const struct sk_buff *skb,
       const void *matchinfo,
       int offset,
       unsigned int protoff,
=2D      int *hotdrop)
+      int *hotdrop,
+      void *priv_data)
 {
 	const struct ipt_owner_info *info =3D matchinfo;
=20
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
+     unsigned int hook_mask,
+     void *priv_data)
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
index 32ae8d7..a54e0fe 100644
=2D-- a/net/ipv4/netfilter/ipt_recent.c
+++ b/net/ipv4/netfilter/ipt_recent.c
@@ -173,7 +173,8 @@ static int
 ipt_recent_match(const struct sk_buff *skb,
 		 const struct net_device *in, const struct net_device *out,
 		 const struct xt_match *match, const void *matchinfo,
=2D		 int offset, unsigned int protoff, int *hotdrop)
+		 int offset, unsigned int protoff, int *hotdrop,
+		 void *priv_data)
 {
 	const struct ipt_recent_info *info =3D matchinfo;
 	struct recent_table *t;
@@ -236,9 +237,9 @@ out:
 }
=20
 static int
=2Dipt_recent_checkentry(const char *tablename, const void *ip,
=2D		      const struct xt_match *match, void *matchinfo,
=2D		      unsigned int hook_mask)
+ipt_recent_init(const char *tablename, const void *ip,
+		const struct xt_match *match, void *matchinfo,
+		unsigned int hook_mask, void *priv_data)
 {
 	const struct ipt_recent_info *info =3D matchinfo;
 	struct recent_table *t;
@@ -294,7 +295,8 @@ out:
 }
=20
 static void
=2Dipt_recent_destroy(const struct xt_match *match, void *matchinfo)
+ipt_recent_destroy(const struct xt_match *match, void *matchinfo,
+		   void *priv_data)
 {
 	const struct ipt_recent_info *info =3D matchinfo;
 	struct recent_table *t;
@@ -467,12 +469,12 @@ static struct ipt_match recent_match =3D {
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
@@ -493,7 +495,7 @@ #endif
 	return err;
 }
=20
=2Dstatic void __exit ipt_recent_exit(void)
+static void __exit ipt_recent_module_exit(void)
 {
 	BUG_ON(!list_empty(&tables));
 	ipt_unregister_match(&recent_match);
@@ -502,5 +504,5 @@ #ifdef CONFIG_PROC_FS
 #endif
 }
=20
=2Dmodule_init(ipt_recent_init);
=2Dmodule_exit(ipt_recent_exit);
+module_init(ipt_recent_module_init);
+module_exit(ipt_recent_module_exit);
diff --git a/net/ipv4/netfilter/ipt_tos.c b/net/ipv4/netfilter/ipt_tos.c
index 5549c39..c47e50f 100644
=2D-- a/net/ipv4/netfilter/ipt_tos.c
+++ b/net/ipv4/netfilter/ipt_tos.c
@@ -25,7 +25,8 @@ match(const struct sk_buff *skb,
       const void *matchinfo,
       int offset,
       unsigned int protoff,
=2D      int *hotdrop)
+      int *hotdrop,
+      void *priv_data)
 {
 	const struct ipt_tos_info *info =3D matchinfo;
=20
diff --git a/net/ipv4/netfilter/ipt_ttl.c b/net/ipv4/netfilter/ipt_ttl.c
index a5243bd..d02a87b 100644
=2D-- a/net/ipv4/netfilter/ipt_ttl.c
+++ b/net/ipv4/netfilter/ipt_ttl.c
@@ -22,7 +22,8 @@ MODULE_LICENSE("GPL");
 static int match(const struct sk_buff *skb,
 		 const struct net_device *in, const struct net_device *out,
 		 const struct xt_match *match, const void *matchinfo,
=2D		 int offset, unsigned int protoff, int *hotdrop)
+		 int offset, unsigned int protoff, int *hotdrop,
+		 void *priv_data)
 {
 	const struct ipt_ttl_info *info =3D matchinfo;
=20
diff --git a/net/ipv6/netfilter/ip6t_HL.c b/net/ipv6/netfilter/ip6t_HL.c
index 435750f..878ac35 100644
=2D-- a/net/ipv6/netfilter/ip6t_HL.c
+++ b/net/ipv6/netfilter/ip6t_HL.c
@@ -22,7 +22,8 @@ static unsigned int ip6t_hl_target(struc
 				   const struct net_device *out,
 				   unsigned int hooknum,
 				   const struct xt_target *target,
=2D				   const void *targinfo)
+				   const void *targinfo,
+				   void *priv_data)
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
+			unsigned int hook_mask,
+			void *priv_data)
 {
 	struct ip6t_HL_info *info =3D targinfo;
=20
@@ -84,19 +86,19 @@ static struct ip6t_target ip6t_HL =3D {=20
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
index 0cf537d..7f42293 100644
=2D-- a/net/ipv6/netfilter/ip6t_LOG.c
+++ b/net/ipv6/netfilter/ip6t_LOG.c
@@ -427,7 +427,8 @@ ip6t_log_target(struct sk_buff **pskb,
 		const struct net_device *out,
 		unsigned int hooknum,
 		const struct xt_target *target,
=2D		const void *targinfo)
+		const void *targinfo,
+		void *priv_data)
 {
 	const struct ip6t_log_info *loginfo =3D targinfo;
 	struct nf_loginfo li;
@@ -447,11 +448,12 @@ ip6t_log_target(struct sk_buff **pskb,
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
+			 unsigned int hook_mask,
+			 void *priv_data)
 {
 	const struct ip6t_log_info *loginfo =3D targinfo;
=20
@@ -471,7 +473,7 @@ static struct ip6t_target ip6t_log_reg =3D
 	.name 		=3D "LOG",
 	.target 	=3D ip6t_log_target,=20
 	.targetsize	=3D sizeof(struct ip6t_log_info),
=2D	.checkentry	=3D ip6t_log_checkentry,=20
+	.init		=3D ip6t_log_init,
 	.me 		=3D THIS_MODULE,
 };
=20
@@ -481,7 +483,7 @@ static struct nf_logger ip6t_logger =3D {
 	.me		=3D THIS_MODULE,
 };
=20
=2Dstatic int __init ip6t_log_init(void)
+static int __init ip6t_log_module_init(void)
 {
 	if (ip6t_register_target(&ip6t_log_reg))
 		return -EINVAL;
@@ -495,11 +497,11 @@ static int __init ip6t_log_init(void)
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
index 311eae8..4ea5a3d 100644
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
+				   void *priv_data)
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
+		unsigned int hook_mask,
+		void *priv_data)
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
diff --git a/net/ipv6/netfilter/ip6t_ah.c b/net/ipv6/netfilter/ip6t_ah.c
index ec1b160..9f10fc4 100644
=2D-- a/net/ipv6/netfilter/ip6t_ah.c
+++ b/net/ipv6/netfilter/ip6t_ah.c
@@ -48,7 +48,8 @@ match(const struct sk_buff *skb,
       const void *matchinfo,
       int offset,
       unsigned int protoff,
=2D      int *hotdrop)
+      int *hotdrop,
+      void *priv_data)
 {
 	struct ip_auth_hdr *ah, _ah;
 	const struct ip6t_ah *ahinfo =3D matchinfo;
@@ -98,11 +99,12 @@ match(const struct sk_buff *skb,
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
+     unsigned int hook_mask,
+     void *priv_data)
 {
 	const struct ip6t_ah *ahinfo =3D matchinfo;
=20
@@ -117,7 +119,7 @@ static struct ip6t_match ah_match =3D {
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
index 4f6b84c..3d72a98 100644
=2D-- a/net/ipv6/netfilter/ip6t_eui64.c
+++ b/net/ipv6/netfilter/ip6t_eui64.c
@@ -26,7 +26,8 @@ match(const struct sk_buff *skb,
       const void *matchinfo,
       int offset,
       unsigned int protoff,
=2D      int *hotdrop)
+      int *hotdrop,
+      void *priv_data)
 {
 	unsigned char eui64[8];
 	int i =3D 0;
diff --git a/net/ipv6/netfilter/ip6t_frag.c b/net/ipv6/netfilter/ip6t_frag.c
index 78d9c8b..be9aa65 100644
=2D-- a/net/ipv6/netfilter/ip6t_frag.c
+++ b/net/ipv6/netfilter/ip6t_frag.c
@@ -47,7 +47,8 @@ match(const struct sk_buff *skb,
       const void *matchinfo,
       int offset,
       unsigned int protoff,
=2D      int *hotdrop)
+      int *hotdrop,
+      void *priv_data)
 {
 	struct frag_hdr _frag, *fh;
 	const struct ip6t_frag *fraginfo =3D matchinfo;
@@ -115,11 +116,12 @@ match(const struct sk_buff *skb,
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
+     unsigned int hook_mask,
+     void *priv_data)
 {
 	const struct ip6t_frag *fraginfo =3D matchinfo;
=20
@@ -134,7 +136,7 @@ static struct ip6t_match frag_match =3D {
 	.name		=3D "frag",
 	.match		=3D match,
 	.matchsize	=3D sizeof(struct ip6t_frag),
=2D	.checkentry	=3D checkentry,
+	.init		=3D init,
 	.me		=3D THIS_MODULE,
 };
=20
diff --git a/net/ipv6/netfilter/ip6t_hbh.c b/net/ipv6/netfilter/ip6t_hbh.c
index d32a205..59fa6e2 100644
=2D-- a/net/ipv6/netfilter/ip6t_hbh.c
+++ b/net/ipv6/netfilter/ip6t_hbh.c
@@ -54,7 +54,8 @@ match(const struct sk_buff *skb,
       const void *matchinfo,
       int offset,
       unsigned int protoff,
=2D      int *hotdrop)
+      int *hotdrop,
+      void *priv_data)
 {
 	struct ipv6_opt_hdr _optsh, *oh;
 	const struct ip6t_opts *optinfo =3D matchinfo;
@@ -169,11 +170,12 @@ match(const struct sk_buff *skb,
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
+     unsigned int hook_mask,
+     void *priv_data)
 {
 	const struct ip6t_opts *optsinfo =3D matchinfo;
=20
@@ -190,7 +192,7 @@ static struct xt_match opts_match[] =3D {
 		.family		=3D AF_INET6,
 		.match		=3D match,
 		.matchsize	=3D sizeof(struct ip6t_opts),
=2D		.checkentry	=3D checkentry,
+		.init		=3D init,
 		.me		=3D THIS_MODULE,
 		.data		=3D NEXTHDR_HOP,
 	},
@@ -199,7 +201,7 @@ static struct xt_match opts_match[] =3D {
 		.family		=3D AF_INET6,
 		.match		=3D match,
 		.matchsize	=3D sizeof(struct ip6t_opts),
=2D		.checkentry	=3D checkentry,
+		.init		=3D init,
 		.me		=3D THIS_MODULE,
 		.data		=3D NEXTHDR_DEST,
 	},
diff --git a/net/ipv6/netfilter/ip6t_ipv6header.c b/net/ipv6/netfilter/ip6t=
_ipv6header.c
index 3093c39..0e224ac 100644
=2D-- a/net/ipv6/netfilter/ip6t_ipv6header.c
+++ b/net/ipv6/netfilter/ip6t_ipv6header.c
@@ -33,7 +33,8 @@ ipv6header_match(const struct sk_buff *s
 		 const void *matchinfo,
 		 int offset,
 		 unsigned int protoff,
=2D		 int *hotdrop)
+		 int *hotdrop,
+		 void *priv_data)
 {
 	const struct ip6t_ipv6header_info *info =3D matchinfo;
 	unsigned int temp;
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
+		unsigned int hook_mask,
+		void *priv_data)
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
index 4eb9bbc..97ad7e7 100644
=2D-- a/net/ipv6/netfilter/ip6t_owner.c
+++ b/net/ipv6/netfilter/ip6t_owner.c
@@ -30,7 +30,8 @@ match(const struct sk_buff *skb,
       const void *matchinfo,
       int offset,
       unsigned int protoff,
=2D      int *hotdrop)
+      int *hotdrop,
+      void *priv_data)
 {
 	const struct ip6t_owner_info *info =3D matchinfo;
=20
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
+     unsigned int hook_mask,
+     void *priv_data)
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
index bcb2e16..572ac50 100644
=2D-- a/net/ipv6/netfilter/ip6t_rt.c
+++ b/net/ipv6/netfilter/ip6t_rt.c
@@ -49,7 +49,8 @@ match(const struct sk_buff *skb,
       const void *matchinfo,
       int offset,
       unsigned int protoff,
=2D      int *hotdrop)
+      int *hotdrop,
+      void *priv_data)
 {
 	struct ipv6_rt_hdr _route, *rh;
 	const struct ip6t_rt *rtinfo =3D matchinfo;
@@ -193,11 +194,12 @@ match(const struct sk_buff *skb,
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
+     unsigned int hook_mask,
+     void *priv_data)
 {
 	const struct ip6t_rt *rtinfo =3D matchinfo;
=20
@@ -220,7 +222,7 @@ static struct ip6t_match rt_match =3D {
 	.name		=3D "rt",
 	.match		=3D match,
 	.matchsize	=3D sizeof(struct ip6t_rt),
=2D	.checkentry	=3D checkentry,
+	.init		=3D init,
 	.me		=3D THIS_MODULE,
 };
=20
diff --git a/net/netfilter/xt_CLASSIFY.c b/net/netfilter/xt_CLASSIFY.c
index 50de965..501a5a8 100644
=2D-- a/net/netfilter/xt_CLASSIFY.c
+++ b/net/netfilter/xt_CLASSIFY.c
@@ -29,7 +29,8 @@ target(struct sk_buff **pskb,
        const struct net_device *out,
        unsigned int hooknum,
        const struct xt_target *target,
=2D       const void *targinfo)
+       const void *targinfo,
+       void *priv_data)
 {
 	const struct xt_classify_target_info *clinfo =3D targinfo;
=20
diff --git a/net/netfilter/xt_CONNMARK.c b/net/netfilter/xt_CONNMARK.c
index c01524f..7a73bd0 100644
=2D-- a/net/netfilter/xt_CONNMARK.c
+++ b/net/netfilter/xt_CONNMARK.c
@@ -38,7 +38,8 @@ target(struct sk_buff **pskb,
        const struct net_device *out,
        unsigned int hooknum,
        const struct xt_target *target,
=2D       const void *targinfo)
+       const void *targinfo,
+       void *priv_data)
 {
 	const struct xt_connmark_target_info *markinfo =3D targinfo;
 	u_int32_t diff;
@@ -85,11 +86,12 @@ #endif
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
+     unsigned int hook_mask,
+     void *priv_data)
 {
 	struct xt_connmark_target_info *matchinfo =3D targinfo;
=20
@@ -143,7 +145,7 @@ static struct xt_target xt_connmark_targ
 	{
 		.name		=3D "CONNMARK",
 		.family		=3D AF_INET,
=2D		.checkentry	=3D checkentry,
+		.init		=3D init,
 		.target		=3D target,
 		.targetsize	=3D sizeof(struct xt_connmark_target_info),
 #ifdef CONFIG_COMPAT
@@ -156,7 +158,7 @@ #endif
 	{
 		.name		=3D "CONNMARK",
 		.family		=3D AF_INET6,
=2D		.checkentry	=3D checkentry,
+		.init		=3D init,
 		.target		=3D target,
 		.targetsize	=3D sizeof(struct xt_connmark_target_info),
 		.me		=3D THIS_MODULE
diff --git a/net/netfilter/xt_DSCP.c b/net/netfilter/xt_DSCP.c
index a7cc75a..c15ef6f 100644
=2D-- a/net/netfilter/xt_DSCP.c
+++ b/net/netfilter/xt_DSCP.c
@@ -32,7 +32,8 @@ static unsigned int target(struct sk_buf
 			   const struct net_device *out,
 			   unsigned int hooknum,
 			   const struct xt_target *target,
=2D			   const void *targinfo)
+			   const void *targinfo,
+			   void *priv_data)
 {
 	const struct xt_DSCP_info *dinfo =3D targinfo;
 	u_int8_t dscp =3D ipv4_get_dsfield((*pskb)->nh.iph) >> XT_DSCP_SHIFT;
@@ -53,7 +54,8 @@ static unsigned int target6(struct sk_bu
 			    const struct net_device *out,
 			    unsigned int hooknum,
 			    const struct xt_target *target,
=2D			    const void *targinfo)
+			    const void *targinfo,
+			    void *priv_data)
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
+		unsigned int hook_mask,
+		void *priv_data)
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
index c6e860a..962814a 100644
=2D-- a/net/netfilter/xt_MARK.c
+++ b/net/netfilter/xt_MARK.c
@@ -27,7 +27,8 @@ target_v0(struct sk_buff **pskb,
 	  const struct net_device *out,
 	  unsigned int hooknum,
 	  const struct xt_target *target,
=2D	  const void *targinfo)
+	  const void *targinfo,
+	  void *priv_data)
 {
 	const struct xt_mark_target_info *markinfo =3D targinfo;
=20
@@ -43,7 +44,8 @@ target_v1(struct sk_buff **pskb,
 	  const struct net_device *out,
 	  unsigned int hooknum,
 	  const struct xt_target *target,
=2D	  const void *targinfo)
+	  const void *targinfo,
+	  void *priv_data)
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
+	unsigned int hook_mask,
+	void *priv_data)
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
+	unsigned int hook_mask,
+	void *priv_data)
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
@@ -167,7 +171,7 @@ #endif
 		.name		=3D "MARK",
 		.family		=3D AF_INET6,
 		.revision	=3D 0,
=2D		.checkentry	=3D checkentry_v0,
+		.init		=3D init_v0,
 		.target		=3D target_v0,
 		.targetsize	=3D sizeof(struct xt_mark_target_info),
 		.table		=3D "mangle",
diff --git a/net/netfilter/xt_NFQUEUE.c b/net/netfilter/xt_NFQUEUE.c
index db9b896..e797fac 100644
=2D-- a/net/netfilter/xt_NFQUEUE.c
+++ b/net/netfilter/xt_NFQUEUE.c
@@ -29,7 +29,8 @@ target(struct sk_buff **pskb,
        const struct net_device *out,
        unsigned int hooknum,
        const struct xt_target *target,
=2D       const void *targinfo)
+       const void *targinfo,
+       void *priv_data)
 {
 	const struct xt_NFQ_info *tinfo =3D targinfo;
=20
diff --git a/net/netfilter/xt_NOTRACK.c b/net/netfilter/xt_NOTRACK.c
index 6d00dca..deaf86c 100644
=2D-- a/net/netfilter/xt_NOTRACK.c
+++ b/net/netfilter/xt_NOTRACK.c
@@ -16,7 +16,8 @@ target(struct sk_buff **pskb,
        const struct net_device *out,
        unsigned int hooknum,
        const struct xt_target *target,
=2D       const void *targinfo)
+       const void *targinfo,
+       void *priv_data)
 {
 	/* Previously seen (loopback)? Ignore. */
 	if ((*pskb)->nfct !=3D NULL)
diff --git a/net/netfilter/xt_SECMARK.c b/net/netfilter/xt_SECMARK.c
index add7521..b6cf8e6 100644
=2D-- a/net/netfilter/xt_SECMARK.c
+++ b/net/netfilter/xt_SECMARK.c
@@ -31,7 +31,7 @@ static u8 mode;
 static unsigned int target(struct sk_buff **pskb, const struct net_device =
*in,
 			   const struct net_device *out, unsigned int hooknum,
 			   const struct xt_target *target,
=2D			   const void *targinfo)
+			   const void *targinfo, void *priv_data)
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
+		unsigned int hook_mask, void *priv_data)
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
diff --git a/net/netfilter/xt_comment.c b/net/netfilter/xt_comment.c
index 7db492d..67e7023 100644
=2D-- a/net/netfilter/xt_comment.c
+++ b/net/netfilter/xt_comment.c
@@ -23,7 +23,8 @@ match(const struct sk_buff *skb,
       const void *matchinfo,
       int offset,
       unsigned int protooff,
=2D      int *hotdrop)
+      int *hotdrop,
+      void *priv_data)
 {
 	/* We always match */
 	return 1;
diff --git a/net/netfilter/xt_connbytes.c b/net/netfilter/xt_connbytes.c
index dcc497e..db4f236 100644
=2D-- a/net/netfilter/xt_connbytes.c
+++ b/net/netfilter/xt_connbytes.c
@@ -48,7 +48,8 @@ match(const struct sk_buff *skb,
       const void *matchinfo,
       int offset,
       unsigned int protoff,
=2D      int *hotdrop)
+      int *hotdrop,
+      void *priv_data)
 {
 	const struct xt_connbytes_info *sinfo =3D matchinfo;
 	u_int64_t what =3D 0;	/* initialize to make gcc happy */
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
+		unsigned int hook_mask,
+		void *priv_data)
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
index 92a5726..b4cce05 100644
=2D-- a/net/netfilter/xt_connmark.c
+++ b/net/netfilter/xt_connmark.c
@@ -39,7 +39,8 @@ match(const struct sk_buff *skb,
       const void *matchinfo,
       int offset,
       unsigned int protoff,
=2D      int *hotdrop)
+      int *hotdrop,
+      void *priv_data)
 {
 	const struct xt_connmark_info *info =3D matchinfo;
 	u_int32_t ctinfo;
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
+     unsigned int hook_mask,
+     void *priv_data)
 {
 	struct xt_connmark_info *cm =3D matchinfo;
=20
@@ -74,7 +76,7 @@ #endif
 }
=20
 static void
=2Ddestroy(const struct xt_match *match, void *matchinfo)
+destroy(const struct xt_match *match, void *matchinfo, void *priv_data)
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
@@ -130,7 +132,7 @@ #endif
 	{
 		.name		=3D "connmark",
 		.family		=3D AF_INET6,
=2D		.checkentry	=3D checkentry,
+		.init		=3D init,
 		.match		=3D match,
 		.destroy	=3D destroy,
 		.matchsize	=3D sizeof(struct xt_connmark_info),
diff --git a/net/netfilter/xt_conntrack.c b/net/netfilter/xt_conntrack.c
index 0ea501a..72941f9 100644
=2D-- a/net/netfilter/xt_conntrack.c
+++ b/net/netfilter/xt_conntrack.c
@@ -36,7 +36,8 @@ match(const struct sk_buff *skb,
       const void *matchinfo,
       int offset,
       unsigned int protoff,
=2D      int *hotdrop)
+      int *hotdrop,
+      void *priv_data)
 {
 	const struct xt_conntrack_info *sinfo =3D matchinfo;
 	struct ip_conntrack *ct;
@@ -132,7 +133,8 @@ match(const struct sk_buff *skb,
       const void *matchinfo,
       int offset,
       unsigned int protoff,
=2D      int *hotdrop)
+      int *hotdrop,
+      void *priv_data)
 {
 	const struct xt_conntrack_info *sinfo =3D matchinfo;
 	struct nf_conn *ct;
@@ -222,11 +224,12 @@ #define FWINV(bool,invflg) ((bool) ^ !!(
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
+     unsigned int hook_mask,
+     void *priv_data)
 {
 #if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
 	if (nf_ct_l3proto_try_module_get(match->family) < 0) {
@@ -238,7 +241,8 @@ #endif
 	return 1;
 }
=20
=2Dstatic void destroy(const struct xt_match *match, void *matchinfo)
+static void destroy(const struct xt_match *match, void *matchinfo,
+		    void *priv_data)
 {
 #if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
 	nf_ct_l3proto_module_put(match->family);
@@ -248,7 +252,7 @@ #endif
 static struct xt_match conntrack_match =3D {
 	.name		=3D "conntrack",
 	.match		=3D match,
=2D	.checkentry	=3D checkentry,
+	.init		=3D init,
 	.destroy	=3D destroy,
 	.matchsize	=3D sizeof(struct xt_conntrack_info),
 	.family		=3D AF_INET,
diff --git a/net/netfilter/xt_dccp.c b/net/netfilter/xt_dccp.c
index 3e6cf43..c77fd93 100644
=2D-- a/net/netfilter/xt_dccp.c
+++ b/net/netfilter/xt_dccp.c
@@ -99,7 +99,8 @@ match(const struct sk_buff *skb,
       const void *matchinfo,
       int offset,
       unsigned int protoff,
=2D      int *hotdrop)
+      int *hotdrop,
+      void *priv_data)
 {
 	const struct xt_dccp_info *info =3D matchinfo;
 	struct dccp_hdr _dh, *dh;
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
+    unsigned int hook_mask,
+    void *priv_data)
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
index 26c7f4a..b7935bf 100644
=2D-- a/net/netfilter/xt_dscp.c
+++ b/net/netfilter/xt_dscp.c
@@ -31,7 +31,8 @@ static int match(const struct sk_buff *s
 		 const void *matchinfo,
 		 int offset,
 		 unsigned int protoff,
=2D		 int *hotdrop)
+		 int *hotdrop,
+		 void *priv_data)
 {
 	const struct xt_dscp_info *info =3D matchinfo;
 	u_int8_t dscp =3D ipv4_get_dsfield(skb->nh.iph) >> XT_DSCP_SHIFT;
@@ -46,7 +47,8 @@ static int match6(const struct sk_buff *
 		  const void *matchinfo,
 		  int offset,
 		  unsigned int protoff,
=2D		  int *hotdrop)
+		  int *hotdrop,
+		  void *priv_data)
 {
 	const struct xt_dscp_info *info =3D matchinfo;
 	u_int8_t dscp =3D ipv6_get_dsfield(skb->nh.ipv6h) >> XT_DSCP_SHIFT;
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
+		unsigned int hook_mask,
+		void *priv_data)
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
index 7c95f14..43f7771 100644
=2D-- a/net/netfilter/xt_esp.c
+++ b/net/netfilter/xt_esp.c
@@ -50,7 +50,8 @@ match(const struct sk_buff *skb,
       const void *matchinfo,
       int offset,
       unsigned int protoff,
=2D      int *hotdrop)
+      int *hotdrop,
+      void *priv_data)
 {
 	struct ip_esp_hdr _esp, *eh;
 	const struct xt_esp *espinfo =3D matchinfo;
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
+     unsigned int hook_mask,
+     void *priv_data)
 {
 	const struct xt_esp *espinfo =3D matchinfo;
=20
@@ -95,7 +97,7 @@ static struct xt_match xt_esp_match[] =3D=20
 	{
 		.name		=3D "esp",
 		.family		=3D AF_INET,
=2D		.checkentry	=3D checkentry,
+		.init		=3D init,
 		.match		=3D match,
 		.matchsize	=3D sizeof(struct xt_esp),
 		.proto		=3D IPPROTO_ESP,
@@ -104,7 +106,7 @@ static struct xt_match xt_esp_match[] =3D=20
 	{
 		.name		=3D "esp",
 		.family		=3D AF_INET6,
=2D		.checkentry	=3D checkentry,
+		.init		=3D init,
 		.match		=3D match,
 		.matchsize	=3D sizeof(struct xt_esp),
 		.proto		=3D IPPROTO_ESP,
diff --git a/net/netfilter/xt_helper.c b/net/netfilter/xt_helper.c
index 5d7818b..f4f5af3 100644
=2D-- a/net/netfilter/xt_helper.c
+++ b/net/netfilter/xt_helper.c
@@ -46,7 +46,8 @@ match(const struct sk_buff *skb,
       const void *matchinfo,
       int offset,
       unsigned int protoff,
=2D      int *hotdrop)
+      int *hotdrop,
+      void *priv_data)
 {
 	const struct xt_helper_info *info =3D matchinfo;
 	struct ip_conntrack *ct;
@@ -94,7 +95,8 @@ match(const struct sk_buff *skb,
       const void *matchinfo,
       int offset,
       unsigned int protoff,
=2D      int *hotdrop)
+      int *hotdrop,
+      void *priv_data)
 {
 	const struct xt_helper_info *info =3D matchinfo;
 	struct nf_conn *ct;
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
+		unsigned int hook_mask,
+		void *priv_data)
 {
 	struct xt_helper_info *info =3D matchinfo;
=20
@@ -155,7 +158,7 @@ #endif
 }
=20
 static void
=2Ddestroy(const struct xt_match *match, void *matchinfo)
+destroy(const struct xt_match *match, void *matchinfo, void *priv_data)
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
index 67fd30d..3f41f45 100644
=2D-- a/net/netfilter/xt_length.c
+++ b/net/netfilter/xt_length.c
@@ -28,7 +28,8 @@ match(const struct sk_buff *skb,
       const void *matchinfo,
       int offset,
       unsigned int protoff,
=2D      int *hotdrop)
+      int *hotdrop,
+      void *priv_data)
 {
 	const struct xt_length_info *info =3D matchinfo;
 	u_int16_t pktlen =3D ntohs(skb->nh.iph->tot_len);
@@ -44,7 +45,8 @@ match6(const struct sk_buff *skb,
        const void *matchinfo,
        int offset,
        unsigned int protoff,
=2D       int *hotdrop)
+       int *hotdrop,
+       void *priv_data)
 {
 	const struct xt_length_info *info =3D matchinfo;
 	u_int16_t pktlen =3D ntohs(skb->nh.ipv6h->payload_len) + sizeof(struct ip=
v6hdr);
diff --git a/net/netfilter/xt_limit.c b/net/netfilter/xt_limit.c
index fda7b7d..3b544c9 100644
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
@@ -72,7 +72,8 @@ ipt_limit_match(const struct sk_buff *sk
 		const void *matchinfo,
 		int offset,
 		unsigned int protoff,
=2D		int *hotdrop)
+		int *hotdrop,
+		void *priv_data)
 {
 	struct xt_rateinfo *r =3D ((struct xt_rateinfo *)matchinfo)->master;
 	unsigned long now =3D jiffies;
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
+	       unsigned int hook_mask,
+	       void *priv_data)
 {
 	struct xt_rateinfo *r =3D matchinfo;
=20
@@ -183,7 +185,7 @@ static struct xt_match xt_limit_match[]=20
 	{
 		.name		=3D "limit",
 		.family		=3D AF_INET,
=2D		.checkentry	=3D ipt_limit_checkentry,
+		.init		=3D ipt_limit_init,
 		.match		=3D ipt_limit_match,
 		.matchsize	=3D sizeof(struct xt_rateinfo),
 #ifdef CONFIG_COMPAT
@@ -196,7 +198,7 @@ #endif
 	{
 		.name		=3D "limit",
 		.family		=3D AF_INET6,
=2D		.checkentry	=3D ipt_limit_checkentry,
+		.init		=3D ipt_limit_init,
 		.match		=3D ipt_limit_match,
 		.matchsize	=3D sizeof(struct xt_rateinfo),
 		.me		=3D THIS_MODULE,
diff --git a/net/netfilter/xt_mac.c b/net/netfilter/xt_mac.c
index 425fc21..fadff66 100644
=2D-- a/net/netfilter/xt_mac.c
+++ b/net/netfilter/xt_mac.c
@@ -31,7 +31,8 @@ match(const struct sk_buff *skb,
       const void *matchinfo,
       int offset,
       unsigned int protoff,
=2D      int *hotdrop)
+      int *hotdrop,
+      void *priv_data)
 {
     const struct xt_mac_info *info =3D matchinfo;
=20
diff --git a/net/netfilter/xt_mark.c b/net/netfilter/xt_mark.c
index 934dddf..a70c12c 100644
=2D-- a/net/netfilter/xt_mark.c
+++ b/net/netfilter/xt_mark.c
@@ -27,7 +27,8 @@ match(const struct sk_buff *skb,
       const void *matchinfo,
       int offset,
       unsigned int protoff,
=2D      int *hotdrop)
+      int *hotdrop,
+      void *priv_data)
 {
 	const struct xt_mark_info *info =3D matchinfo;
=20
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
+     unsigned int hook_mask,
+     void *priv_data)
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
@@ -98,7 +100,7 @@ #endif
 	{
 		.name		=3D "mark",
 		.family		=3D AF_INET6,
=2D		.checkentry	=3D checkentry,
+		.init		=3D init,
 		.match		=3D match,
 		.matchsize	=3D sizeof(struct xt_mark_info),
 		.me		=3D THIS_MODULE,
diff --git a/net/netfilter/xt_multiport.c b/net/netfilter/xt_multiport.c
index d3aefd3..aedd1e0 100644
=2D-- a/net/netfilter/xt_multiport.c
+++ b/net/netfilter/xt_multiport.c
@@ -102,7 +102,8 @@ match(const struct sk_buff *skb,
       const void *matchinfo,
       int offset,
       unsigned int protoff,
=2D      int *hotdrop)
+      int *hotdrop,
+      void *priv_data)
 {
 	u16 _ports[2], *pptr;
 	const struct xt_multiport *multiinfo =3D matchinfo;
@@ -133,7 +134,8 @@ match_v1(const struct sk_buff *skb,
 	 const void *matchinfo,
 	 int offset,
 	 unsigned int protoff,
=2D	 int *hotdrop)
+	 int *hotdrop,
+	 void *priv_data)
 {
 	u16 _ports[2], *pptr;
 	const struct xt_multiport_v1 *multiinfo =3D matchinfo;
@@ -172,11 +174,12 @@ check(u_int16_t proto,
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
+     unsigned int hook_mask,
+     void *priv_data)
 {
 	const struct ipt_ip *ip =3D info;
 	const struct xt_multiport *multiinfo =3D matchinfo;
@@ -186,11 +189,12 @@ checkentry(const char *tablename,
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
+	unsigned int hook_mask,
+	void *priv_data)
 {
 	const struct ipt_ip *ip =3D info;
 	const struct xt_multiport_v1 *multiinfo =3D matchinfo;
@@ -200,11 +204,12 @@ checkentry_v1(const char *tablename,
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
+      unsigned int hook_mask,
+      void *priv_data)
 {
 	const struct ip6t_ip6 *ip =3D info;
 	const struct xt_multiport *multiinfo =3D matchinfo;
@@ -214,11 +219,12 @@ checkentry6(const char *tablename,
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
+	 unsigned int hook_mask,
+	 void *priv_data)
 {
 	const struct ip6t_ip6 *ip =3D info;
 	const struct xt_multiport_v1 *multiinfo =3D matchinfo;
@@ -232,7 +238,7 @@ static struct xt_match xt_multiport_matc
 		.name		=3D "multiport",
 		.family		=3D AF_INET,
 		.revision	=3D 0,
=2D		.checkentry	=3D checkentry,
+		.init		=3D init,
 		.match		=3D match,
 		.matchsize	=3D sizeof(struct xt_multiport),
 		.me		=3D THIS_MODULE,
@@ -241,7 +247,7 @@ static struct xt_match xt_multiport_matc
 		.name		=3D "multiport",
 		.family		=3D AF_INET,
 		.revision	=3D 1,
=2D		.checkentry	=3D checkentry_v1,
+		.init		=3D init_v1,
 		.match		=3D match_v1,
 		.matchsize	=3D sizeof(struct xt_multiport_v1),
 		.me		=3D THIS_MODULE,
@@ -250,7 +256,7 @@ static struct xt_match xt_multiport_matc
 		.name		=3D "multiport",
 		.family		=3D AF_INET6,
 		.revision	=3D 0,
=2D		.checkentry	=3D checkentry6,
+		.init		=3D init6,
 		.match		=3D match,
 		.matchsize	=3D sizeof(struct xt_multiport),
 		.me		=3D THIS_MODULE,
@@ -259,7 +265,7 @@ static struct xt_match xt_multiport_matc
 		.name		=3D "multiport",
 		.family		=3D AF_INET6,
 		.revision	=3D 1,
=2D		.checkentry	=3D checkentry6_v1,
+		.init		=3D init6_v1,
 		.match		=3D match_v1,
 		.matchsize	=3D sizeof(struct xt_multiport_v1),
 		.me		=3D THIS_MODULE,
diff --git a/net/netfilter/xt_physdev.c b/net/netfilter/xt_physdev.c
index fd8f954..7893938 100644
=2D-- a/net/netfilter/xt_physdev.c
+++ b/net/netfilter/xt_physdev.c
@@ -31,7 +31,8 @@ match(const struct sk_buff *skb,
       const void *matchinfo,
       int offset,
       unsigned int protoff,
=2D      int *hotdrop)
+      int *hotdrop,
+      void *priv_data)
 {
 	int i;
 	static const char nulldevname[IFNAMSIZ];
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
+     unsigned int hook_mask,
+     void *priv_data)
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
index 16e7b08..efe454c 100644
=2D-- a/net/netfilter/xt_pkttype.c
+++ b/net/netfilter/xt_pkttype.c
@@ -28,7 +28,8 @@ static int match(const struct sk_buff *s
       const void *matchinfo,
       int offset,
       unsigned int protoff,
=2D      int *hotdrop)
+      int *hotdrop,
+      void *priv_data)
 {
 	u_int8_t type;
 	const struct xt_pkttype_info *info =3D matchinfo;
diff --git a/net/netfilter/xt_policy.c b/net/netfilter/xt_policy.c
index 46bde2b..1540879 100644
=2D-- a/net/netfilter/xt_policy.c
+++ b/net/netfilter/xt_policy.c
@@ -115,7 +115,8 @@ static int match(const struct sk_buff *s
                  const void *matchinfo,
                  int offset,
                  unsigned int protoff,
=2D                 int *hotdrop)
+                 int *hotdrop,
+                 void *priv_data)
 {
 	const struct xt_policy_info *info =3D matchinfo;
 	int ret;
@@ -133,9 +134,9 @@ static int match(const struct sk_buff *s
 	return ret;
 }
=20
=2Dstatic int checkentry(const char *tablename, const void *ip_void,
=2D                      const struct xt_match *match,
=2D                      void *matchinfo, unsigned int hook_mask)
+static int init(const char *tablename, const void *ip_void,
+                const struct xt_match *match,
+                void *matchinfo, unsigned int hook_mask, void *priv_data)
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
index b75fa2c..32702d2 100644
=2D-- a/net/netfilter/xt_quota.c
+++ b/net/netfilter/xt_quota.c
@@ -20,7 +20,8 @@ static int
 match(const struct sk_buff *skb,
       const struct net_device *in, const struct net_device *out,
       const struct xt_match *match, const void *matchinfo,
=2D      int offset, unsigned int protoff, int *hotdrop)
+      int offset, unsigned int protoff, int *hotdrop,
+      void *priv_data)
 {
 	struct xt_quota_info *q =3D ((struct xt_quota_info *)matchinfo)->master;
 	int ret =3D q->flags & XT_QUOTA_INVERT ? 1 : 0;
@@ -39,9 +40,9 @@ match(const struct sk_buff *skb,
 }
=20
 static int
=2Dcheckentry(const char *tablename, const void *entry,
=2D	   const struct xt_match *match, void *matchinfo,
=2D	   unsigned int hook_mask)
+init(const char *tablename, const void *entry,
+     const struct xt_match *match, void *matchinfo,
+     unsigned int hook_mask, void *priv_data)
 {
 	struct xt_quota_info *q =3D (struct xt_quota_info *)matchinfo;
=20
@@ -56,7 +57,7 @@ static struct xt_match xt_quota_match[]=20
 	{
 		.name		=3D "quota",
 		.family		=3D AF_INET,
=2D		.checkentry	=3D checkentry,
+		.init		=3D init,
 		.match		=3D match,
 		.matchsize	=3D sizeof(struct xt_quota_info),
 		.me		=3D THIS_MODULE
@@ -64,7 +65,7 @@ static struct xt_match xt_quota_match[]=20
 	{
 		.name		=3D "quota",
 		.family		=3D AF_INET6,
=2D		.checkentry	=3D checkentry,
+		.init		=3D init,
 		.match		=3D match,
 		.matchsize	=3D sizeof(struct xt_quota_info),
 		.me		=3D THIS_MODULE
diff --git a/net/netfilter/xt_realm.c b/net/netfilter/xt_realm.c
index a80b7d1..53d8b17 100644
=2D-- a/net/netfilter/xt_realm.c
+++ b/net/netfilter/xt_realm.c
@@ -31,7 +31,8 @@ match(const struct sk_buff *skb,
       const void *matchinfo,
       int offset,
       unsigned int protoff,
=2D      int *hotdrop)
+      int *hotdrop,
+      void *priv_data)
 {
 	const struct xt_realm_info *info =3D matchinfo;
 	struct dst_entry *dst =3D skb->dst;
diff --git a/net/netfilter/xt_sctp.c b/net/netfilter/xt_sctp.c
index 7956aca..5b599d8 100644
=2D-- a/net/netfilter/xt_sctp.c
+++ b/net/netfilter/xt_sctp.c
@@ -127,7 +127,8 @@ match(const struct sk_buff *skb,
       const void *matchinfo,
       int offset,
       unsigned int protoff,
=2D      int *hotdrop)
+      int *hotdrop,
+      void *priv_data)
 {
 	const struct xt_sctp_info *info =3D matchinfo;
 	sctp_sctphdr_t _sh, *sh;
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
+     unsigned int hook_mask,
+     void *priv_data)
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
index d9010b1..1532d33 100644
=2D-- a/net/netfilter/xt_state.c
+++ b/net/netfilter/xt_state.c
@@ -28,7 +28,8 @@ match(const struct sk_buff *skb,
       const void *matchinfo,
       int offset,
       unsigned int protoff,
=2D      int *hotdrop)
+      int *hotdrop,
+      void *priv_data)
 {
 	const struct xt_state_info *sinfo =3D matchinfo;
 	enum ip_conntrack_info ctinfo;
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
+		unsigned int hook_mask,
+		void *priv_data)
 {
 #if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
 	if (nf_ct_l3proto_try_module_get(match->family) < 0) {
@@ -61,7 +63,7 @@ #endif
 }
=20
 static void
=2Ddestroy(const struct xt_match *match, void *matchinfo)
+destroy(const struct xt_match *match, void *matchinfo, void *priv_data)
 {
 #if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
 	nf_ct_l3proto_module_put(match->family);
@@ -72,7 +74,7 @@ static struct xt_match xt_state_match[]=20
 	{
 		.name		=3D "state",
 		.family		=3D AF_INET,
=2D		.checkentry	=3D check,
+		.init		=3D init,
 		.match		=3D match,
 		.destroy	=3D destroy,
 		.matchsize	=3D sizeof(struct xt_state_info),
@@ -81,7 +83,7 @@ static struct xt_match xt_state_match[]=20
 	{
 		.name		=3D "state",
 		.family		=3D AF_INET6,
=2D		.checkentry	=3D check,
+		.init		=3D init,
 		.match		=3D match,
 		.destroy	=3D destroy,
 		.matchsize	=3D sizeof(struct xt_state_info),
diff --git a/net/netfilter/xt_statistic.c b/net/netfilter/xt_statistic.c
index 091a9f8..6fbc1dd 100644
=2D-- a/net/netfilter/xt_statistic.c
+++ b/net/netfilter/xt_statistic.c
@@ -28,7 +28,7 @@ static int
 match(const struct sk_buff *skb,
       const struct net_device *in, const struct net_device *out,
       const struct xt_match *match, const void *matchinfo,
=2D      int offset, unsigned int protoff, int *hotdrop)
+      int offset, unsigned int protoff, int *hotdrop, void *priv_data)
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
+     unsigned int hook_mask, void *priv_data)
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
index 4453252..be01c47 100644
=2D-- a/net/netfilter/xt_string.c
+++ b/net/netfilter/xt_string.c
@@ -28,7 +28,8 @@ static int match(const struct sk_buff *s
 		 const void *matchinfo,
 		 int offset,
 		 unsigned int protoff,
=2D		 int *hotdrop)
+		 int *hotdrop,
+		 void *priv_data)
 {
 	const struct xt_string_info *conf =3D matchinfo;
 	struct ts_state state;
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
+		unsigned int hook_mask,
+		void *priv_data)
 {
 	struct xt_string_info *conf =3D matchinfo;
 	struct ts_config *ts_conf;
@@ -68,7 +70,8 @@ static int checkentry(const char *tablen
 	return 1;
 }
=20
=2Dstatic void destroy(const struct xt_match *match, void *matchinfo)
+static void destroy(const struct xt_match *match, void *matchinfo,
+		    void *priv_data)
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
index a3682fe..e512f70 100644
=2D-- a/net/netfilter/xt_tcpmss.c
+++ b/net/netfilter/xt_tcpmss.c
@@ -31,7 +31,8 @@ match(const struct sk_buff *skb,
       const void *matchinfo,
       int offset,
       unsigned int protoff,
=2D      int *hotdrop)
+      int *hotdrop,
+      void *priv_data)
 {
 	const struct xt_tcpmss_match_info *info =3D matchinfo;
 	struct tcphdr _tcph, *th;
diff --git a/net/netfilter/xt_tcpudp.c b/net/netfilter/xt_tcpudp.c
index e76a68e..516d0d6 100644
=2D-- a/net/netfilter/xt_tcpudp.c
+++ b/net/netfilter/xt_tcpudp.c
@@ -78,7 +78,8 @@ tcp_match(const struct sk_buff *skb,
 	  const void *matchinfo,
 	  int offset,
 	  unsigned int protoff,
=2D	  int *hotdrop)
+	  int *hotdrop,
+	  void *priv_data)
 {
 	struct tcphdr _tcph, *th;
 	const struct xt_tcp *tcpinfo =3D matchinfo;
@@ -137,11 +138,12 @@ #define FWINVTCP(bool,invflg) ((bool) ^=20
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
+	    unsigned int hook_mask,
+	    void *priv_data)
 {
 	const struct xt_tcp *tcpinfo =3D matchinfo;
=20
@@ -157,7 +159,8 @@ udp_match(const struct sk_buff *skb,
 	  const void *matchinfo,
 	  int offset,
 	  unsigned int protoff,
=2D	  int *hotdrop)
+	  int *hotdrop,
+	  void *priv_data)
 {
 	struct udphdr _udph, *uh;
 	const struct xt_udp *udpinfo =3D matchinfo;
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
+	    unsigned int hook_mask,
+	    void *priv_data)
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
@@ -236,16 +240,16 @@ static struct xt_match xt_tcpudp_match[]
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
1.4.2
