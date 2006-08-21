From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 14/18]: x_tables: remove unused size argument to
	check/destroy functions
Date: Tue, 22 Aug 2006 00:52:37 +0200 (MEST)
Message-ID: <20060821225237.10288.31455.sendpatchset@localhost.localdomain>
References: <20060821225217.10288.69738.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060821225217.10288.69738.sendpatchset@localhost.localdomain>
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

[NETFILTER]: x_tables: remove unused size argument to check/destroy functions

The size is verified by x_tables and isn't needed by the modules anymore.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 0945146f9085ef6469e137000fd125df648a137f
tree 16818ec12cba09e961d6fc4ffa13026afbf2e07b
parent 855a763072e92f8b1e4931003cc82a0b3ba1131d
author Patrick McHardy <kaber@trash.net> Sun, 13 Aug 2006 19:46:51 +0200
committer Patrick McHardy <kaber@trash.net> Sun, 13 Aug 2006 19:46:51 +0200

 include/linux/netfilter/x_tables.h   |    8 ++------
 net/ipv4/netfilter/arp_tables.c      |    5 +----
 net/ipv4/netfilter/arpt_mangle.c     |    2 +-
 net/ipv4/netfilter/ip_nat_rule.c     |    2 --
 net/ipv4/netfilter/ip_tables.c       |   14 +++-----------
 net/ipv4/netfilter/ipt_CLUSTERIP.c   |    4 +---
 net/ipv4/netfilter/ipt_ECN.c         |    1 -
 net/ipv4/netfilter/ipt_LOG.c         |    1 -
 net/ipv4/netfilter/ipt_MASQUERADE.c  |    1 -
 net/ipv4/netfilter/ipt_NETMAP.c      |    1 -
 net/ipv4/netfilter/ipt_REDIRECT.c    |    1 -
 net/ipv4/netfilter/ipt_REJECT.c      |    1 -
 net/ipv4/netfilter/ipt_SAME.c        |    4 +---
 net/ipv4/netfilter/ipt_TCPMSS.c      |    1 -
 net/ipv4/netfilter/ipt_TOS.c         |    1 -
 net/ipv4/netfilter/ipt_TTL.c         |    1 -
 net/ipv4/netfilter/ipt_ULOG.c        |    1 -
 net/ipv4/netfilter/ipt_ah.c          |    1 -
 net/ipv4/netfilter/ipt_ecn.c         |    3 +--
 net/ipv4/netfilter/ipt_hashlimit.c   |    4 +---
 net/ipv4/netfilter/ipt_owner.c       |    1 -
 net/ipv4/netfilter/ipt_recent.c      |    5 ++---
 net/ipv6/netfilter/ip6_tables.c      |   10 ++--------
 net/ipv6/netfilter/ip6t_HL.c         |    1 -
 net/ipv6/netfilter/ip6t_LOG.c        |    1 -
 net/ipv6/netfilter/ip6t_REJECT.c     |    1 -
 net/ipv6/netfilter/ip6t_ah.c         |    1 -
 net/ipv6/netfilter/ip6t_dst.c        |    1 -
 net/ipv6/netfilter/ip6t_frag.c       |    1 -
 net/ipv6/netfilter/ip6t_hbh.c        |    1 -
 net/ipv6/netfilter/ip6t_ipv6header.c |    1 -
 net/ipv6/netfilter/ip6t_owner.c      |    1 -
 net/ipv6/netfilter/ip6t_rt.c         |    1 -
 net/netfilter/xt_CONNMARK.c          |    1 -
 net/netfilter/xt_CONNSECMARK.c       |    2 +-
 net/netfilter/xt_DSCP.c              |    1 -
 net/netfilter/xt_MARK.c              |    2 --
 net/netfilter/xt_SECMARK.c           |    2 +-
 net/netfilter/xt_connbytes.c         |    1 -
 net/netfilter/xt_connmark.c          |    3 +--
 net/netfilter/xt_conntrack.c         |    3 +--
 net/netfilter/xt_dccp.c              |    1 -
 net/netfilter/xt_dscp.c              |    1 -
 net/netfilter/xt_esp.c               |    1 -
 net/netfilter/xt_helper.c            |    3 +--
 net/netfilter/xt_limit.c             |    1 -
 net/netfilter/xt_mark.c              |    1 -
 net/netfilter/xt_multiport.c         |    4 ----
 net/netfilter/xt_physdev.c           |    1 -
 net/netfilter/xt_policy.c            |    3 +--
 net/netfilter/xt_quota.c             |    2 +-
 net/netfilter/xt_sctp.c              |    1 -
 net/netfilter/xt_state.c             |    3 +--
 net/netfilter/xt_statistic.c         |    2 +-
 net/netfilter/xt_string.c            |    4 +---
 net/netfilter/xt_tcpudp.c            |    2 --
 net/sched/act_ipt.c                  |    4 +---
 57 files changed, 26 insertions(+), 106 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 9cef0e9..9d97102 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -174,12 +174,10 @@ struct xt_match
 			  const void *ip,
 			  const struct xt_match *match,
 			  void *matchinfo,
-			  unsigned int matchinfosize,
 			  unsigned int hook_mask);
 
 	/* Called when entry of this type deleted. */
-	void (*destroy)(const struct xt_match *match, void *matchinfo,
-			unsigned int matchinfosize);
+	void (*destroy)(const struct xt_match *match, void *matchinfo);
 
 	/* Called when userspace align differs from kernel space one */
 	int (*compat)(void *match, void **dstptr, int *size, int convert);
@@ -221,12 +219,10 @@ struct xt_target
 			  const void *entry,
 			  const struct xt_target *target,
 			  void *targinfo,
-			  unsigned int targinfosize,
 			  unsigned int hook_mask);
 
 	/* Called when entry of this type deleted. */
-	void (*destroy)(const struct xt_target *target, void *targinfo,
-			unsigned int targinfosize);
+	void (*destroy)(const struct xt_target *target, void *targinfo);
 
 	/* Called when userspace align differs from kernel space one */
 	int (*compat)(void *target, void **dstptr, int *size, int convert);
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index c38c6c4..3f2e2fe 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -490,8 +490,6 @@ static inline int check_entry(struct arp
 		}
 	} else if (t->u.kernel.target->checkentry
 		   && !t->u.kernel.target->checkentry(name, e, target, t->data,
-						      t->u.target_size
-						      - sizeof(*t),
 						      e->comefrom)) {
 		duprintf("arp_tables: check failed for `%s'.\n",
 			 t->u.kernel.target->name);
@@ -558,8 +556,7 @@ static inline int cleanup_entry(struct a
 
 	t = arpt_get_target(e);
 	if (t->u.kernel.target->destroy)
-		t->u.kernel.target->destroy(t->u.kernel.target, t->data,
-					    t->u.target_size - sizeof(*t));
+		t->u.kernel.target->destroy(t->u.kernel.target, t->data);
 	module_put(t->u.kernel.target->me);
 	return 0;
 }
diff --git a/net/ipv4/netfilter/arpt_mangle.c b/net/ipv4/netfilter/arpt_mangle.c
index 05fb242..d12b1df 100644
--- a/net/ipv4/netfilter/arpt_mangle.c
+++ b/net/ipv4/netfilter/arpt_mangle.c
@@ -67,7 +67,7 @@ target(struct sk_buff **pskb,
 
 static int
 checkentry(const char *tablename, const void *e, const struct xt_target *target,
-           void *targinfo, unsigned int targinfosize, unsigned int hook_mask)
+           void *targinfo, unsigned int hook_mask)
 {
 	const struct arpt_mangle *mangle = targinfo;
 
diff --git a/net/ipv4/netfilter/ip_nat_rule.c b/net/ipv4/netfilter/ip_nat_rule.c
index 1aa0e4f..e59f5a8 100644
--- a/net/ipv4/netfilter/ip_nat_rule.c
+++ b/net/ipv4/netfilter/ip_nat_rule.c
@@ -172,7 +172,6 @@ static int ipt_snat_checkentry(const cha
 			       const void *entry,
 			       const struct ipt_target *target,
 			       void *targinfo,
-			       unsigned int targinfosize,
 			       unsigned int hook_mask)
 {
 	struct ip_nat_multi_range_compat *mr = targinfo;
@@ -189,7 +188,6 @@ static int ipt_dnat_checkentry(const cha
 			       const void *entry,
 			       const struct ipt_target *target,
 			       void *targinfo,
-			       unsigned int targinfosize,
 			       unsigned int hook_mask)
 {
 	struct ip_nat_multi_range_compat *mr = targinfo;
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index bdf9196..dd50ed6 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -463,8 +463,7 @@ cleanup_match(struct ipt_entry_match *m,
 		return 1;
 
 	if (m->u.kernel.match->destroy)
-		m->u.kernel.match->destroy(m->u.kernel.match, m->data,
-					   m->u.match_size - sizeof(*m));
+		m->u.kernel.match->destroy(m->u.kernel.match, m->data);
 	module_put(m->u.kernel.match->me);
 	return 0;
 }
@@ -517,7 +516,6 @@ check_match(struct ipt_entry_match *m,
 
 	if (m->u.kernel.match->checkentry
 	    && !m->u.kernel.match->checkentry(name, ip, match, m->data,
-					      m->u.match_size - sizeof(*m),
 					      hookmask)) {
 		duprintf("ip_tables: check failed for `%s'.\n",
 			 m->u.kernel.match->name);
@@ -578,8 +576,6 @@ check_entry(struct ipt_entry *e, const c
 		}
 	} else if (t->u.kernel.target->checkentry
 		   && !t->u.kernel.target->checkentry(name, e, target, t->data,
-						      t->u.target_size
-						      - sizeof(*t),
 						      e->comefrom)) {
 		duprintf("ip_tables: check failed for `%s'.\n",
 			 t->u.kernel.target->name);
@@ -651,8 +647,7 @@ cleanup_entry(struct ipt_entry *e, unsig
 	IPT_MATCH_ITERATE(e, cleanup_match, NULL);
 	t = ipt_get_target(e);
 	if (t->u.kernel.target->destroy)
-		t->u.kernel.target->destroy(t->u.kernel.target, t->data,
-					    t->u.target_size - sizeof(*t));
+		t->u.kernel.target->destroy(t->u.kernel.target, t->data);
 	module_put(t->u.kernel.target->me);
 	return 0;
 }
@@ -1598,7 +1593,6 @@ static inline int compat_copy_match_from
 
 	if (m->u.kernel.match->checkentry
 	    && !m->u.kernel.match->checkentry(name, ip, match, dm->data,
-					      dm->u.match_size - sizeof(*dm),
 					      hookmask)) {
 		duprintf("ip_tables: check failed for `%s'.\n",
 			 m->u.kernel.match->name);
@@ -1657,8 +1651,7 @@ static int compat_copy_entry_from_user(s
 			goto out;
 	} else if (t->u.kernel.target->checkentry
 		   && !t->u.kernel.target->checkentry(name, de, target,
-				t->data, t->u.target_size - sizeof(*t),
-				de->comefrom)) {
+						      t->data, de->comefrom)) {
 		duprintf("ip_tables: compat: check failed for `%s'.\n",
 			 t->u.kernel.target->name);
 		goto out;
@@ -2181,7 +2174,6 @@ icmp_checkentry(const char *tablename,
 	   const void *info,
 	   const struct xt_match *match,
 	   void *matchinfo,
-	   unsigned int matchsize,
 	   unsigned int hook_mask)
 {
 	const struct ipt_icmp *icmpinfo = matchinfo;
diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index a08383c..4158966 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -372,7 +372,6 @@ checkentry(const char *tablename,
 	   const void *e_void,
 	   const struct xt_target *target,
            void *targinfo,
-           unsigned int targinfosize,
            unsigned int hook_mask)
 {
 	struct ipt_clusterip_tgt_info *cipinfo = targinfo;
@@ -449,8 +448,7 @@ checkentry(const char *tablename,
 }
 
 /* drop reference count of cluster config when rule is deleted */
-static void destroy(const struct xt_target *target, void *targinfo,
-		    unsigned int targinfosize)
+static void destroy(const struct xt_target *target, void *targinfo)
 {
 	struct ipt_clusterip_tgt_info *cipinfo = targinfo;
 
diff --git a/net/ipv4/netfilter/ipt_ECN.c b/net/ipv4/netfilter/ipt_ECN.c
index 1c3da4a..23f9c7e 100644
--- a/net/ipv4/netfilter/ipt_ECN.c
+++ b/net/ipv4/netfilter/ipt_ECN.c
@@ -106,7 +106,6 @@ checkentry(const char *tablename,
 	   const void *e_void,
 	   const struct xt_target *target,
            void *targinfo,
-           unsigned int targinfosize,
            unsigned int hook_mask)
 {
 	const struct ipt_ECN_info *einfo = (struct ipt_ECN_info *)targinfo;
diff --git a/net/ipv4/netfilter/ipt_LOG.c b/net/ipv4/netfilter/ipt_LOG.c
index a8d356c..7dc820d 100644
--- a/net/ipv4/netfilter/ipt_LOG.c
+++ b/net/ipv4/netfilter/ipt_LOG.c
@@ -439,7 +439,6 @@ static int ipt_log_checkentry(const char
 			      const void *e,
 			      const struct xt_target *target,
 			      void *targinfo,
-			      unsigned int targinfosize,
 			      unsigned int hook_mask)
 {
 	const struct ipt_log_info *loginfo = targinfo;
diff --git a/net/ipv4/netfilter/ipt_MASQUERADE.c b/net/ipv4/netfilter/ipt_MASQUERADE.c
index 9659793..bc65168 100644
--- a/net/ipv4/netfilter/ipt_MASQUERADE.c
+++ b/net/ipv4/netfilter/ipt_MASQUERADE.c
@@ -42,7 +42,6 @@ masquerade_check(const char *tablename,
 		 const void *e,
 		 const struct xt_target *target,
 		 void *targinfo,
-		 unsigned int targinfosize,
 		 unsigned int hook_mask)
 {
 	const struct ip_nat_multi_range_compat *mr = targinfo;
diff --git a/net/ipv4/netfilter/ipt_NETMAP.c b/net/ipv4/netfilter/ipt_NETMAP.c
index fd5e74a..beb2914 100644
--- a/net/ipv4/netfilter/ipt_NETMAP.c
+++ b/net/ipv4/netfilter/ipt_NETMAP.c
@@ -33,7 +33,6 @@ check(const char *tablename,
       const void *e,
       const struct xt_target *target,
       void *targinfo,
-      unsigned int targinfosize,
       unsigned int hook_mask)
 {
 	const struct ip_nat_multi_range_compat *mr = targinfo;
diff --git a/net/ipv4/netfilter/ipt_REDIRECT.c b/net/ipv4/netfilter/ipt_REDIRECT.c
index 839fe99..f03d436 100644
--- a/net/ipv4/netfilter/ipt_REDIRECT.c
+++ b/net/ipv4/netfilter/ipt_REDIRECT.c
@@ -36,7 +36,6 @@ redirect_check(const char *tablename,
 	       const void *e,
 	       const struct xt_target *target,
 	       void *targinfo,
-	       unsigned int targinfosize,
 	       unsigned int hook_mask)
 {
 	const struct ip_nat_multi_range_compat *mr = targinfo;
diff --git a/net/ipv4/netfilter/ipt_REJECT.c b/net/ipv4/netfilter/ipt_REJECT.c
index 1dfd8e5..b81821e 100644
--- a/net/ipv4/netfilter/ipt_REJECT.c
+++ b/net/ipv4/netfilter/ipt_REJECT.c
@@ -276,7 +276,6 @@ static int check(const char *tablename,
 		 const void *e_void,
 		 const struct xt_target *target,
 		 void *targinfo,
-		 unsigned int targinfosize,
 		 unsigned int hook_mask)
 {
  	const struct ipt_reject_info *rejinfo = targinfo;
diff --git a/net/ipv4/netfilter/ipt_SAME.c b/net/ipv4/netfilter/ipt_SAME.c
index cf80174..efbcb11 100644
--- a/net/ipv4/netfilter/ipt_SAME.c
+++ b/net/ipv4/netfilter/ipt_SAME.c
@@ -52,7 +52,6 @@ same_check(const char *tablename,
 	      const void *e,
 	      const struct xt_target *target,
 	      void *targinfo,
-	      unsigned int targinfosize,
 	      unsigned int hook_mask)
 {
 	unsigned int count, countess, rangeip, index = 0;
@@ -116,8 +115,7 @@ same_check(const char *tablename,
 }
 
 static void 
-same_destroy(const struct xt_target *target, void *targinfo,
-		unsigned int targinfosize)
+same_destroy(const struct xt_target *target, void *targinfo)
 {
 	struct ipt_same_info *mr = targinfo;
 
diff --git a/net/ipv4/netfilter/ipt_TCPMSS.c b/net/ipv4/netfilter/ipt_TCPMSS.c
index 6d668dc..ac8a35e 100644
--- a/net/ipv4/netfilter/ipt_TCPMSS.c
+++ b/net/ipv4/netfilter/ipt_TCPMSS.c
@@ -207,7 +207,6 @@ ipt_tcpmss_checkentry(const char *tablen
 		      const void *e_void,
 		      const struct xt_target *target,
 		      void *targinfo,
-		      unsigned int targinfosize,
 		      unsigned int hook_mask)
 {
 	const struct ipt_tcpmss_info *tcpmssinfo = targinfo;
diff --git a/net/ipv4/netfilter/ipt_TOS.c b/net/ipv4/netfilter/ipt_TOS.c
index 043df01..471a4c4 100644
--- a/net/ipv4/netfilter/ipt_TOS.c
+++ b/net/ipv4/netfilter/ipt_TOS.c
@@ -49,7 +49,6 @@ checkentry(const char *tablename,
 	   const void *e_void,
 	   const struct xt_target *target,
            void *targinfo,
-           unsigned int targinfosize,
            unsigned int hook_mask)
 {
 	const u_int8_t tos = ((struct ipt_tos_target_info *)targinfo)->tos;
diff --git a/net/ipv4/netfilter/ipt_TTL.c b/net/ipv4/netfilter/ipt_TTL.c
index 1640071..214d9d9 100644
--- a/net/ipv4/netfilter/ipt_TTL.c
+++ b/net/ipv4/netfilter/ipt_TTL.c
@@ -67,7 +67,6 @@ static int ipt_ttl_checkentry(const char
 		const void *e,
 		const struct xt_target *target,
 		void *targinfo,
-		unsigned int targinfosize,
 		unsigned int hook_mask)
 {
 	struct ipt_TTL_info *info = targinfo;
diff --git a/net/ipv4/netfilter/ipt_ULOG.c b/net/ipv4/netfilter/ipt_ULOG.c
index 062b456..9b01c17 100644
--- a/net/ipv4/netfilter/ipt_ULOG.c
+++ b/net/ipv4/netfilter/ipt_ULOG.c
@@ -341,7 +341,6 @@ static int ipt_ulog_checkentry(const cha
 			       const void *e,
 			       const struct xt_target *target,
 			       void *targinfo,
-			       unsigned int targinfosize,
 			       unsigned int hookmask)
 {
 	struct ipt_ulog_info *loginfo = (struct ipt_ulog_info *) targinfo;
diff --git a/net/ipv4/netfilter/ipt_ah.c b/net/ipv4/netfilter/ipt_ah.c
index 2927135..1798f86 100644
--- a/net/ipv4/netfilter/ipt_ah.c
+++ b/net/ipv4/netfilter/ipt_ah.c
@@ -74,7 +74,6 @@ checkentry(const char *tablename,
 	   const void *ip_void,
 	   const struct xt_match *match,
 	   void *matchinfo,
-	   unsigned int matchinfosize,
 	   unsigned int hook_mask)
 {
 	const struct ipt_ah *ahinfo = matchinfo;
diff --git a/net/ipv4/netfilter/ipt_ecn.c b/net/ipv4/netfilter/ipt_ecn.c
index b282504..dafbdec 100644
--- a/net/ipv4/netfilter/ipt_ecn.c
+++ b/net/ipv4/netfilter/ipt_ecn.c
@@ -88,8 +88,7 @@ static int match(const struct sk_buff *s
 
 static int checkentry(const char *tablename, const void *ip_void,
 		      const struct xt_match *match,
-		      void *matchinfo, unsigned int matchsize,
-		      unsigned int hook_mask)
+		      void *matchinfo, unsigned int hook_mask)
 {
 	const struct ipt_ecn_info *info = matchinfo;
 	const struct ipt_ip *ip = ip_void;
diff --git a/net/ipv4/netfilter/ipt_hashlimit.c b/net/ipv4/netfilter/ipt_hashlimit.c
index 3bd2368..b5b74b0 100644
--- a/net/ipv4/netfilter/ipt_hashlimit.c
+++ b/net/ipv4/netfilter/ipt_hashlimit.c
@@ -478,7 +478,6 @@ hashlimit_checkentry(const char *tablena
 		     const void *inf,
 		     const struct xt_match *match,
 		     void *matchinfo,
-		     unsigned int matchsize,
 		     unsigned int hook_mask)
 {
 	struct ipt_hashlimit_info *r = matchinfo;
@@ -529,8 +528,7 @@ hashlimit_checkentry(const char *tablena
 }
 
 static void
-hashlimit_destroy(const struct xt_match *match, void *matchinfo,
-		  unsigned int matchsize)
+hashlimit_destroy(const struct xt_match *match, void *matchinfo)
 {
 	struct ipt_hashlimit_info *r = matchinfo;
 
diff --git a/net/ipv4/netfilter/ipt_owner.c b/net/ipv4/netfilter/ipt_owner.c
index 5ac6ac0..78c336f 100644
--- a/net/ipv4/netfilter/ipt_owner.c
+++ b/net/ipv4/netfilter/ipt_owner.c
@@ -56,7 +56,6 @@ checkentry(const char *tablename,
            const void *ip,
 	   const struct xt_match *match,
            void *matchinfo,
-           unsigned int matchsize,
            unsigned int hook_mask)
 {
 	const struct ipt_owner_info *info = matchinfo;
diff --git a/net/ipv4/netfilter/ipt_recent.c b/net/ipv4/netfilter/ipt_recent.c
index 682c094..32ae8d7 100644
--- a/net/ipv4/netfilter/ipt_recent.c
+++ b/net/ipv4/netfilter/ipt_recent.c
@@ -238,7 +238,7 @@ out:
 static int
 ipt_recent_checkentry(const char *tablename, const void *ip,
 		      const struct xt_match *match, void *matchinfo,
-		      unsigned int matchsize, unsigned int hook_mask)
+		      unsigned int hook_mask)
 {
 	const struct ipt_recent_info *info = matchinfo;
 	struct recent_table *t;
@@ -294,8 +294,7 @@ out:
 }
 
 static void
-ipt_recent_destroy(const struct xt_match *match, void *matchinfo,
-		   unsigned int matchsize)
+ipt_recent_destroy(const struct xt_match *match, void *matchinfo)
 {
 	const struct ipt_recent_info *info = matchinfo;
 	struct recent_table *t;
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 1978b6c..e63a3ac 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -504,8 +504,7 @@ cleanup_match(struct ip6t_entry_match *m
 		return 1;
 
 	if (m->u.kernel.match->destroy)
-		m->u.kernel.match->destroy(m->u.kernel.match, m->data,
-					   m->u.match_size - sizeof(*m));
+		m->u.kernel.match->destroy(m->u.kernel.match, m->data);
 	module_put(m->u.kernel.match->me);
 	return 0;
 }
@@ -558,7 +557,6 @@ check_match(struct ip6t_entry_match *m,
 
 	if (m->u.kernel.match->checkentry
 	    && !m->u.kernel.match->checkentry(name, ipv6, match,  m->data,
-					      m->u.match_size - sizeof(*m),
 					      hookmask)) {
 		duprintf("ip_tables: check failed for `%s'.\n",
 			 m->u.kernel.match->name);
@@ -619,8 +617,6 @@ check_entry(struct ip6t_entry *e, const 
 		}
 	} else if (t->u.kernel.target->checkentry
 		   && !t->u.kernel.target->checkentry(name, e, target, t->data,
-						      t->u.target_size
-						      - sizeof(*t),
 						      e->comefrom)) {
 		duprintf("ip_tables: check failed for `%s'.\n",
 			 t->u.kernel.target->name);
@@ -692,8 +688,7 @@ cleanup_entry(struct ip6t_entry *e, unsi
 	IP6T_MATCH_ITERATE(e, cleanup_match, NULL);
 	t = ip6t_get_target(e);
 	if (t->u.kernel.target->destroy)
-		t->u.kernel.target->destroy(t->u.kernel.target, t->data,
-					    t->u.target_size - sizeof(*t));
+		t->u.kernel.target->destroy(t->u.kernel.target, t->data);
 	module_put(t->u.kernel.target->me);
 	return 0;
 }
@@ -1349,7 +1344,6 @@ icmp6_checkentry(const char *tablename,
 	   const void *entry,
 	   const struct xt_match *match,
 	   void *matchinfo,
-	   unsigned int matchsize,
 	   unsigned int hook_mask)
 {
 	const struct ip6t_icmp *icmpinfo = matchinfo;
diff --git a/net/ipv6/netfilter/ip6t_HL.c b/net/ipv6/netfilter/ip6t_HL.c
index c85d124..e54ea92 100644
--- a/net/ipv6/netfilter/ip6t_HL.c
+++ b/net/ipv6/netfilter/ip6t_HL.c
@@ -66,7 +66,6 @@ static int ip6t_hl_checkentry(const char
 		const void *entry,
 		const struct xt_target *target,
 		void *targinfo,
-		unsigned int targinfosize,
 		unsigned int hook_mask)
 {
 	struct ip6t_HL_info *info = targinfo;
diff --git a/net/ipv6/netfilter/ip6t_LOG.c b/net/ipv6/netfilter/ip6t_LOG.c
index acb9173..0cf537d 100644
--- a/net/ipv6/netfilter/ip6t_LOG.c
+++ b/net/ipv6/netfilter/ip6t_LOG.c
@@ -451,7 +451,6 @@ static int ip6t_log_checkentry(const cha
 			       const void *entry,
 			       const struct xt_target *target,
 			       void *targinfo,
-			       unsigned int targinfosize,
 			       unsigned int hook_mask)
 {
 	const struct ip6t_log_info *loginfo = targinfo;
diff --git a/net/ipv6/netfilter/ip6t_REJECT.c b/net/ipv6/netfilter/ip6t_REJECT.c
index 343acd3..311eae8 100644
--- a/net/ipv6/netfilter/ip6t_REJECT.c
+++ b/net/ipv6/netfilter/ip6t_REJECT.c
@@ -223,7 +223,6 @@ static int check(const char *tablename,
 		 const void *entry,
 		 const struct xt_target *target,
 		 void *targinfo,
-		 unsigned int targinfosize,
 		 unsigned int hook_mask)
 {
  	const struct ip6t_reject_info *rejinfo = targinfo;
diff --git a/net/ipv6/netfilter/ip6t_ah.c b/net/ipv6/netfilter/ip6t_ah.c
index 2f7bb20..ec1b160 100644
--- a/net/ipv6/netfilter/ip6t_ah.c
+++ b/net/ipv6/netfilter/ip6t_ah.c
@@ -102,7 +102,6 @@ checkentry(const char *tablename,
           const void *entry,
 	  const struct xt_match *match,
           void *matchinfo,
-          unsigned int matchinfosize,
           unsigned int hook_mask)
 {
 	const struct ip6t_ah *ahinfo = matchinfo;
diff --git a/net/ipv6/netfilter/ip6t_dst.c b/net/ipv6/netfilter/ip6t_dst.c
index 9422413..223c335 100644
--- a/net/ipv6/netfilter/ip6t_dst.c
+++ b/net/ipv6/netfilter/ip6t_dst.c
@@ -182,7 +182,6 @@ checkentry(const char *tablename,
 	   const void *info,
 	   const struct xt_match *match,
 	   void *matchinfo,
-	   unsigned int matchinfosize,
 	   unsigned int hook_mask)
 {
 	const struct ip6t_opts *optsinfo = matchinfo;
diff --git a/net/ipv6/netfilter/ip6t_frag.c b/net/ipv6/netfilter/ip6t_frag.c
index 06768c8..78d9c8b 100644
--- a/net/ipv6/netfilter/ip6t_frag.c
+++ b/net/ipv6/netfilter/ip6t_frag.c
@@ -119,7 +119,6 @@ checkentry(const char *tablename,
 	   const void *ip,
 	   const struct xt_match *match,
 	   void *matchinfo,
-	   unsigned int matchinfosize,
 	   unsigned int hook_mask)
 {
 	const struct ip6t_frag *fraginfo = matchinfo;
diff --git a/net/ipv6/netfilter/ip6t_hbh.c b/net/ipv6/netfilter/ip6t_hbh.c
index 374f1be..72defc8 100644
--- a/net/ipv6/netfilter/ip6t_hbh.c
+++ b/net/ipv6/netfilter/ip6t_hbh.c
@@ -182,7 +182,6 @@ checkentry(const char *tablename,
 	   const void *entry,
 	   const struct xt_match *match,
 	   void *matchinfo,
-	   unsigned int matchinfosize,
 	   unsigned int hook_mask)
 {
 	const struct ip6t_opts *optsinfo = matchinfo;
diff --git a/net/ipv6/netfilter/ip6t_ipv6header.c b/net/ipv6/netfilter/ip6t_ipv6header.c
index 9375eeb..3093c39 100644
--- a/net/ipv6/netfilter/ip6t_ipv6header.c
+++ b/net/ipv6/netfilter/ip6t_ipv6header.c
@@ -128,7 +128,6 @@ ipv6header_checkentry(const char *tablen
 		      const void *ip,
 		      const struct xt_match *match,
 		      void *matchinfo,
-		      unsigned int matchsize,
 		      unsigned int hook_mask)
 {
 	const struct ip6t_ipv6header_info *info = matchinfo;
diff --git a/net/ipv6/netfilter/ip6t_owner.c b/net/ipv6/netfilter/ip6t_owner.c
index 5d04799..4eb9bbc 100644
--- a/net/ipv6/netfilter/ip6t_owner.c
+++ b/net/ipv6/netfilter/ip6t_owner.c
@@ -57,7 +57,6 @@ checkentry(const char *tablename,
 	   const void *ip,
 	   const struct xt_match *match,
 	   void *matchinfo,
-	   unsigned int matchsize,
 	   unsigned int hook_mask)
 {
 	const struct ip6t_owner_info *info = matchinfo;
diff --git a/net/ipv6/netfilter/ip6t_rt.c b/net/ipv6/netfilter/ip6t_rt.c
index fbb0184..bcb2e16 100644
--- a/net/ipv6/netfilter/ip6t_rt.c
+++ b/net/ipv6/netfilter/ip6t_rt.c
@@ -197,7 +197,6 @@ checkentry(const char *tablename,
 	   const void *entry,
 	   const struct xt_match *match,
 	   void *matchinfo,
-	   unsigned int matchinfosize,
 	   unsigned int hook_mask)
 {
 	const struct ip6t_rt *rtinfo = matchinfo;
diff --git a/net/netfilter/xt_CONNMARK.c b/net/netfilter/xt_CONNMARK.c
index c2125f6..0e4249d 100644
--- a/net/netfilter/xt_CONNMARK.c
+++ b/net/netfilter/xt_CONNMARK.c
@@ -89,7 +89,6 @@ checkentry(const char *tablename,
 	   const void *entry,
 	   const struct xt_target *target,
 	   void *targinfo,
-	   unsigned int targinfosize,
 	   unsigned int hook_mask)
 {
 	struct xt_connmark_target_info *matchinfo = targinfo;
diff --git a/net/netfilter/xt_CONNSECMARK.c b/net/netfilter/xt_CONNSECMARK.c
index 4b9cc65..4b0e14b 100644
--- a/net/netfilter/xt_CONNSECMARK.c
+++ b/net/netfilter/xt_CONNSECMARK.c
@@ -89,7 +89,7 @@ static unsigned int target(struct sk_buf
 
 static int checkentry(const char *tablename, const void *entry,
 		      const struct xt_target *target, void *targinfo,
-		      unsigned int targinfosize, unsigned int hook_mask)
+		      unsigned int hook_mask)
 {
 	struct xt_connsecmark_target_info *info = targinfo;
 
diff --git a/net/netfilter/xt_DSCP.c b/net/netfilter/xt_DSCP.c
index 9d23c95..a7cc75a 100644
--- a/net/netfilter/xt_DSCP.c
+++ b/net/netfilter/xt_DSCP.c
@@ -72,7 +72,6 @@ static int checkentry(const char *tablen
 		      const void *e_void,
 		      const struct xt_target *target,
 		      void *targinfo,
-		      unsigned int targinfosize,
 		      unsigned int hook_mask)
 {
 	const u_int8_t dscp = ((struct xt_DSCP_info *)targinfo)->dscp;
diff --git a/net/netfilter/xt_MARK.c b/net/netfilter/xt_MARK.c
index 95a171c..782f8d8 100644
--- a/net/netfilter/xt_MARK.c
+++ b/net/netfilter/xt_MARK.c
@@ -74,7 +74,6 @@ checkentry_v0(const char *tablename,
 	      const void *entry,
 	      const struct xt_target *target,
 	      void *targinfo,
-	      unsigned int targinfosize,
 	      unsigned int hook_mask)
 {
 	struct xt_mark_target_info *markinfo = targinfo;
@@ -91,7 +90,6 @@ checkentry_v1(const char *tablename,
 	      const void *entry,
 	      const struct xt_target *target,
 	      void *targinfo,
-	      unsigned int targinfosize,
 	      unsigned int hook_mask)
 {
 	struct xt_mark_target_info_v1 *markinfo = targinfo;
diff --git a/net/netfilter/xt_SECMARK.c b/net/netfilter/xt_SECMARK.c
index 8a04dcf..451b67c 100644
--- a/net/netfilter/xt_SECMARK.c
+++ b/net/netfilter/xt_SECMARK.c
@@ -85,7 +85,7 @@ static int checkentry_selinux(struct xt_
 
 static int checkentry(const char *tablename, const void *entry,
 		      const struct xt_target *target, void *targinfo,
-		      unsigned int targinfosize, unsigned int hook_mask)
+		      unsigned int hook_mask)
 {
 	struct xt_secmark_target_info *info = targinfo;
 
diff --git a/net/netfilter/xt_connbytes.c b/net/netfilter/xt_connbytes.c
index d725e8b..dcc497e 100644
--- a/net/netfilter/xt_connbytes.c
+++ b/net/netfilter/xt_connbytes.c
@@ -125,7 +125,6 @@ static int check(const char *tablename,
 		 const void *ip,
 		 const struct xt_match *match,
 		 void *matchinfo,
-		 unsigned int matchsize,
 		 unsigned int hook_mask)
 {
 	const struct xt_connbytes_info *sinfo = matchinfo;
diff --git a/net/netfilter/xt_connmark.c b/net/netfilter/xt_connmark.c
index a97b2d4..c9104d0 100644
--- a/net/netfilter/xt_connmark.c
+++ b/net/netfilter/xt_connmark.c
@@ -55,7 +55,6 @@ checkentry(const char *tablename,
 	   const void *ip,
 	   const struct xt_match *match,
 	   void *matchinfo,
-	   unsigned int matchsize,
 	   unsigned int hook_mask)
 {
 	struct xt_connmark_info *cm = matchinfo;
@@ -75,7 +74,7 @@ #endif
 }
 
 static void
-destroy(const struct xt_match *match, void *matchinfo, unsigned int matchsize)
+destroy(const struct xt_match *match, void *matchinfo)
 {
 #if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
 	nf_ct_l3proto_module_put(match->family);
diff --git a/net/netfilter/xt_conntrack.c b/net/netfilter/xt_conntrack.c
index 1540885..39c57e9 100644
--- a/net/netfilter/xt_conntrack.c
+++ b/net/netfilter/xt_conntrack.c
@@ -208,7 +208,6 @@ checkentry(const char *tablename,
 	   const void *ip,
 	   const struct xt_match *match,
 	   void *matchinfo,
-	   unsigned int matchsize,
 	   unsigned int hook_mask)
 {
 #if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
@@ -222,7 +221,7 @@ #endif
 }
 
 static void
-destroy(const struct xt_match *match, void *matchinfo, unsigned int matchsize)
+destroy(const struct xt_match *match, void *matchinfo)
 {
 #if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
 	nf_ct_l3proto_module_put(match->family);
diff --git a/net/netfilter/xt_dccp.c b/net/netfilter/xt_dccp.c
index 42d4e96..02e8536 100644
--- a/net/netfilter/xt_dccp.c
+++ b/net/netfilter/xt_dccp.c
@@ -131,7 +131,6 @@ checkentry(const char *tablename,
 	   const void *inf,
 	   const struct xt_match *match,
 	   void *matchinfo,
-	   unsigned int matchsize,
 	   unsigned int hook_mask)
 {
 	const struct xt_dccp_info *info = matchinfo;
diff --git a/net/netfilter/xt_dscp.c b/net/netfilter/xt_dscp.c
index d84075c..26c7f4a 100644
--- a/net/netfilter/xt_dscp.c
+++ b/net/netfilter/xt_dscp.c
@@ -58,7 +58,6 @@ static int checkentry(const char *tablen
 		      const void *info,
 		      const struct xt_match *match,
 		      void *matchinfo,
-		      unsigned int matchsize,
 		      unsigned int hook_mask)
 {
 	const u_int8_t dscp = ((struct xt_dscp_info *)matchinfo)->dscp;
diff --git a/net/netfilter/xt_esp.c b/net/netfilter/xt_esp.c
index 7b19bc9..7c95f14 100644
--- a/net/netfilter/xt_esp.c
+++ b/net/netfilter/xt_esp.c
@@ -79,7 +79,6 @@ checkentry(const char *tablename,
 	   const void *ip_void,
 	   const struct xt_match *match,
 	   void *matchinfo,
-	   unsigned int matchinfosize,
 	   unsigned int hook_mask)
 {
 	const struct xt_esp *espinfo = matchinfo;
diff --git a/net/netfilter/xt_helper.c b/net/netfilter/xt_helper.c
index db453a7..5d7818b 100644
--- a/net/netfilter/xt_helper.c
+++ b/net/netfilter/xt_helper.c
@@ -139,7 +139,6 @@ static int check(const char *tablename,
 		 const void *inf,
 		 const struct xt_match *match,
 		 void *matchinfo,
-		 unsigned int matchsize,
 		 unsigned int hook_mask)
 {
 	struct xt_helper_info *info = matchinfo;
@@ -156,7 +155,7 @@ #endif
 }
 
 static void
-destroy(const struct xt_match *match, void *matchinfo, unsigned int matchsize)
+destroy(const struct xt_match *match, void *matchinfo)
 {
 #if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
 	nf_ct_l3proto_module_put(match->family);
diff --git a/net/netfilter/xt_limit.c b/net/netfilter/xt_limit.c
index e8d5e7a..b9c9ff3 100644
--- a/net/netfilter/xt_limit.c
+++ b/net/netfilter/xt_limit.c
@@ -110,7 +110,6 @@ ipt_limit_checkentry(const char *tablena
 		     const void *inf,
 		     const struct xt_match *match,
 		     void *matchinfo,
-		     unsigned int matchsize,
 		     unsigned int hook_mask)
 {
 	struct xt_rateinfo *r = matchinfo;
diff --git a/net/netfilter/xt_mark.c b/net/netfilter/xt_mark.c
index 39f9b07..e8059cd 100644
--- a/net/netfilter/xt_mark.c
+++ b/net/netfilter/xt_mark.c
@@ -39,7 +39,6 @@ checkentry(const char *tablename,
            const void *entry,
 	   const struct xt_match *match,
            void *matchinfo,
-           unsigned int matchsize,
            unsigned int hook_mask)
 {
 	const struct xt_mark_info *minfo = matchinfo;
diff --git a/net/netfilter/xt_multiport.c b/net/netfilter/xt_multiport.c
index e74f9bb..d3aefd3 100644
--- a/net/netfilter/xt_multiport.c
+++ b/net/netfilter/xt_multiport.c
@@ -176,7 +176,6 @@ checkentry(const char *tablename,
 	   const void *info,
 	   const struct xt_match *match,
 	   void *matchinfo,
-	   unsigned int matchsize,
 	   unsigned int hook_mask)
 {
 	const struct ipt_ip *ip = info;
@@ -191,7 +190,6 @@ checkentry_v1(const char *tablename,
 	      const void *info,
 	      const struct xt_match *match,
 	      void *matchinfo,
-	      unsigned int matchsize,
 	      unsigned int hook_mask)
 {
 	const struct ipt_ip *ip = info;
@@ -206,7 +204,6 @@ checkentry6(const char *tablename,
 	    const void *info,
 	    const struct xt_match *match,
 	    void *matchinfo,
-	    unsigned int matchsize,
 	    unsigned int hook_mask)
 {
 	const struct ip6t_ip6 *ip = info;
@@ -221,7 +218,6 @@ checkentry6_v1(const char *tablename,
 	       const void *info,
 	       const struct xt_match *match,
 	       void *matchinfo,
-	       unsigned int matchsize,
 	       unsigned int hook_mask)
 {
 	const struct ip6t_ip6 *ip = info;
diff --git a/net/netfilter/xt_physdev.c b/net/netfilter/xt_physdev.c
index b1ff69a..987c913 100644
--- a/net/netfilter/xt_physdev.c
+++ b/net/netfilter/xt_physdev.c
@@ -105,7 +105,6 @@ checkentry(const char *tablename,
 		       const void *ip,
 		       const struct xt_match *match,
 		       void *matchinfo,
-		       unsigned int matchsize,
 		       unsigned int hook_mask)
 {
 	const struct xt_physdev_info *info = matchinfo;
diff --git a/net/netfilter/xt_policy.c b/net/netfilter/xt_policy.c
index f5639c4..e9d8137 100644
--- a/net/netfilter/xt_policy.c
+++ b/net/netfilter/xt_policy.c
@@ -135,8 +135,7 @@ static int match(const struct sk_buff *s
 
 static int checkentry(const char *tablename, const void *ip_void,
                       const struct xt_match *match,
-                      void *matchinfo, unsigned int matchsize,
-                      unsigned int hook_mask)
+                      void *matchinfo, unsigned int hook_mask)
 {
 	struct xt_policy_info *info = matchinfo;
 
diff --git a/net/netfilter/xt_quota.c b/net/netfilter/xt_quota.c
index cc264cc..2e4ef7e 100644
--- a/net/netfilter/xt_quota.c
+++ b/net/netfilter/xt_quota.c
@@ -39,7 +39,7 @@ match(const struct sk_buff *skb,
 static int
 checkentry(const char *tablename, const void *entry,
 	   const struct xt_match *match, void *matchinfo,
-	   unsigned int matchsize, unsigned int hook_mask)
+	   unsigned int hook_mask)
 {
 	struct xt_quota_info *q = (struct xt_quota_info *)matchinfo;
 
diff --git a/net/netfilter/xt_sctp.c b/net/netfilter/xt_sctp.c
index 5628621..7956aca 100644
--- a/net/netfilter/xt_sctp.c
+++ b/net/netfilter/xt_sctp.c
@@ -163,7 +163,6 @@ checkentry(const char *tablename,
 	   const void *inf,
 	   const struct xt_match *match,
 	   void *matchinfo,
-	   unsigned int matchsize,
 	   unsigned int hook_mask)
 {
 	const struct xt_sctp_info *info = matchinfo;
diff --git a/net/netfilter/xt_state.c b/net/netfilter/xt_state.c
index 5f9492e..d9010b1 100644
--- a/net/netfilter/xt_state.c
+++ b/net/netfilter/xt_state.c
@@ -48,7 +48,6 @@ static int check(const char *tablename,
 		 const void *inf,
 		 const struct xt_match *match,
 		 void *matchinfo,
-		 unsigned int matchsize,
 		 unsigned int hook_mask)
 {
 #if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
@@ -62,7 +61,7 @@ #endif
 }
 
 static void
-destroy(const struct xt_match *match, void *matchinfo, unsigned int matchsize)
+destroy(const struct xt_match *match, void *matchinfo)
 {
 #if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
 	nf_ct_l3proto_module_put(match->family);
diff --git a/net/netfilter/xt_statistic.c b/net/netfilter/xt_statistic.c
index 5181630..091a9f8 100644
--- a/net/netfilter/xt_statistic.c
+++ b/net/netfilter/xt_statistic.c
@@ -55,7 +55,7 @@ match(const struct sk_buff *skb,
 static int
 checkentry(const char *tablename, const void *entry,
 	   const struct xt_match *match, void *matchinfo,
-	   unsigned int matchsize, unsigned int hook_mask)
+	   unsigned int hook_mask)
 {
 	struct xt_statistic_info *info = (struct xt_statistic_info *)matchinfo;
 
diff --git a/net/netfilter/xt_string.c b/net/netfilter/xt_string.c
index 1a1c1d1..4453252 100644
--- a/net/netfilter/xt_string.c
+++ b/net/netfilter/xt_string.c
@@ -46,7 +46,6 @@ static int checkentry(const char *tablen
 		      const void *ip,
 		      const struct xt_match *match,
 		      void *matchinfo,
-		      unsigned int matchsize,
 		      unsigned int hook_mask)
 {
 	struct xt_string_info *conf = matchinfo;
@@ -69,8 +68,7 @@ static int checkentry(const char *tablen
 	return 1;
 }
 
-static void destroy(const struct xt_match *match, void *matchinfo,
-		    unsigned int matchsize)
+static void destroy(const struct xt_match *match, void *matchinfo)
 {
 	textsearch_destroy(STRING_TEXT_PRIV(matchinfo)->config);
 }
diff --git a/net/netfilter/xt_tcpudp.c b/net/netfilter/xt_tcpudp.c
index 54aab05..e76a68e 100644
--- a/net/netfilter/xt_tcpudp.c
+++ b/net/netfilter/xt_tcpudp.c
@@ -141,7 +141,6 @@ tcp_checkentry(const char *tablename,
 	       const void *info,
 	       const struct xt_match *match,
 	       void *matchinfo,
-	       unsigned int matchsize,
 	       unsigned int hook_mask)
 {
 	const struct xt_tcp *tcpinfo = matchinfo;
@@ -190,7 +189,6 @@ udp_checkentry(const char *tablename,
 	       const void *info,
 	       const struct xt_match *match,
 	       void *matchinfo,
-	       unsigned int matchsize,
 	       unsigned int hook_mask)
 {
 	const struct xt_tcp *udpinfo = matchinfo;
diff --git a/net/sched/act_ipt.c b/net/sched/act_ipt.c
index 1a5f49e..5f194ca 100644
--- a/net/sched/act_ipt.c
+++ b/net/sched/act_ipt.c
@@ -76,7 +76,6 @@ ipt_init_target(struct ipt_entry_target 
 	if (t->u.kernel.target->checkentry
 	    && !t->u.kernel.target->checkentry(table, NULL,
 		    			       t->u.kernel.target, t->data,
-					       t->u.target_size - sizeof(*t),
 					       hook)) {
 		DPRINTK("ipt_init_target: check failed for `%s'.\n",
 			t->u.kernel.target->name);
@@ -91,8 +90,7 @@ static void
 ipt_destroy_target(struct ipt_entry_target *t)
 {
 	if (t->u.kernel.target->destroy)
-		t->u.kernel.target->destroy(t->u.kernel.target, t->data,
-		                            t->u.target_size - sizeof(*t));
+		t->u.kernel.target->destroy(t->u.kernel.target, t->data);
         module_put(t->u.kernel.target->me);
 }
 
