From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 10/13]: x_tables: add xt_{match,
	target} arguments to match/target functions
Date: Thu, 16 Feb 2006 22:32:22 +0100 (MET)
Message-ID: <20060216213222.6933.75661.sendpatchset@localhost.localdomain>
References: <20060216213207.6933.99672.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060216213207.6933.99672.sendpatchset@localhost.localdomain>
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

[NETFILTER]: x_tables: add xt_{match,target} arguments to match/target functions

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 58b6f4b041f8400857ac02cc5a5ddd9f442c05c7
tree aa715791023c3f5f8bca4ffa05ee541ce03dedcf
parent fa94db409d568fb96bc1e806ecd24506e2b1f4dd
author Patrick McHardy <kaber@trash.net> Thu, 16 Feb 2006 14:35:19 +0100
committer Patrick McHardy <kaber@trash.net> Thu, 16 Feb 2006 14:35:19 +0100

 net/ipv4/netfilter/arp_tables.c      |    1 +
 net/ipv4/netfilter/arpt_mangle.c     |   11 ++++++-----
 net/ipv4/netfilter/ip_nat_rule.c     |    4 ++++
 net/ipv4/netfilter/ip_tables.c       |    3 +++
 net/ipv4/netfilter/ipt_CLUSTERIP.c   |    7 +++++--
 net/ipv4/netfilter/ipt_DSCP.c        |    2 ++
 net/ipv4/netfilter/ipt_ECN.c         |    2 ++
 net/ipv4/netfilter/ipt_LOG.c         |    2 ++
 net/ipv4/netfilter/ipt_MASQUERADE.c  |    2 ++
 net/ipv4/netfilter/ipt_NETMAP.c      |    2 ++
 net/ipv4/netfilter/ipt_REDIRECT.c    |    2 ++
 net/ipv4/netfilter/ipt_REJECT.c      |    2 ++
 net/ipv4/netfilter/ipt_SAME.c        |    4 +++-
 net/ipv4/netfilter/ipt_TCPMSS.c      |    2 ++
 net/ipv4/netfilter/ipt_TOS.c         |    2 ++
 net/ipv4/netfilter/ipt_TTL.c         |    8 +++++---
 net/ipv4/netfilter/ipt_ULOG.c        |    2 ++
 net/ipv4/netfilter/ipt_addrtype.c    |    5 +++--
 net/ipv4/netfilter/ipt_ah.c          |    2 ++
 net/ipv4/netfilter/ipt_dscp.c        |    5 +++--
 net/ipv4/netfilter/ipt_ecn.c         |    6 ++++--
 net/ipv4/netfilter/ipt_esp.c         |    2 ++
 net/ipv4/netfilter/ipt_hashlimit.c   |    5 ++++-
 net/ipv4/netfilter/ipt_iprange.c     |    1 +
 net/ipv4/netfilter/ipt_multiport.c   |    2 ++
 net/ipv4/netfilter/ipt_owner.c       |    2 ++
 net/ipv4/netfilter/ipt_policy.c      |    2 ++
 net/ipv4/netfilter/ipt_recent.c      |    7 +++++--
 net/ipv4/netfilter/ipt_tos.c         |    1 +
 net/ipv4/netfilter/ipt_ttl.c         |    5 +++--
 net/ipv6/netfilter/ip6_tables.c      |    3 +++
 net/ipv6/netfilter/ip6t_HL.c         |    2 ++
 net/ipv6/netfilter/ip6t_LOG.c        |    2 ++
 net/ipv6/netfilter/ip6t_REJECT.c     |    2 ++
 net/ipv6/netfilter/ip6t_ah.c         |    2 ++
 net/ipv6/netfilter/ip6t_dst.c        |    2 ++
 net/ipv6/netfilter/ip6t_esp.c        |    2 ++
 net/ipv6/netfilter/ip6t_eui64.c      |    1 +
 net/ipv6/netfilter/ip6t_frag.c       |    2 ++
 net/ipv6/netfilter/ip6t_hbh.c        |    2 ++
 net/ipv6/netfilter/ip6t_hl.c         |    8 ++++----
 net/ipv6/netfilter/ip6t_ipv6header.c |    2 ++
 net/ipv6/netfilter/ip6t_multiport.c  |    2 ++
 net/ipv6/netfilter/ip6t_owner.c      |    2 ++
 net/ipv6/netfilter/ip6t_policy.c     |    5 +++--
 net/ipv6/netfilter/ip6t_rt.c         |    2 ++
 net/netfilter/xt_CLASSIFY.c          |    1 +
 net/netfilter/xt_CONNMARK.c          |    2 ++
 net/netfilter/xt_MARK.c              |    4 ++++
 net/netfilter/xt_NFQUEUE.c           |    1 +
 net/netfilter/xt_NOTRACK.c           |    1 +
 net/netfilter/xt_comment.c           |    1 +
 net/netfilter/xt_connbytes.c         |    2 ++
 net/netfilter/xt_connmark.c          |    2 ++
 net/netfilter/xt_conntrack.c         |    2 ++
 net/netfilter/xt_dccp.c              |    2 ++
 net/netfilter/xt_helper.c            |    3 +++
 net/netfilter/xt_length.c            |    2 ++
 net/netfilter/xt_limit.c             |    2 ++
 net/netfilter/xt_mac.c               |    1 +
 net/netfilter/xt_mark.c              |    2 ++
 net/netfilter/xt_physdev.c           |    2 ++
 net/netfilter/xt_pkttype.c           |    1 +
 net/netfilter/xt_realm.c             |    1 +
 net/netfilter/xt_sctp.c              |    2 ++
 net/netfilter/xt_state.c             |    1 +
 net/netfilter/xt_string.c            |    5 ++++-
 net/netfilter/xt_tcpmss.c            |    1 +
 net/netfilter/xt_tcpudp.c            |    4 ++++
 69 files changed, 160 insertions(+), 29 deletions(-)

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 59f74b7..6da92d2 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -208,6 +208,7 @@ static unsigned int arpt_error(struct sk
 			       const struct net_device *in,
 			       const struct net_device *out,
 			       unsigned int hooknum,
+			       const struct xt_target *target,
 			       const void *targinfo,
 			       void *userinfo)
 {
diff --git a/net/ipv4/netfilter/arpt_mangle.c b/net/ipv4/netfilter/arpt_mangle.c
index 4715cf5..0f2a953 100644
--- a/net/ipv4/netfilter/arpt_mangle.c
+++ b/net/ipv4/netfilter/arpt_mangle.c
@@ -8,9 +8,10 @@ MODULE_AUTHOR("Bart De Schuymer <bdschuy
 MODULE_DESCRIPTION("arptables arp payload mangle target");
 
 static unsigned int
-target(struct sk_buff **pskb, const struct net_device *in,
-   const struct net_device *out, unsigned int hooknum, const void *targinfo,
-   void *userinfo)
+target(struct sk_buff **pskb,
+       const struct net_device *in, const struct net_device *out,
+       unsigned int hooknum, const struct xt_target *target,
+       const void *targinfo, void *userinfo)
 {
 	const struct arpt_mangle *mangle = targinfo;
 	struct arphdr *arp;
@@ -65,8 +66,8 @@ target(struct sk_buff **pskb, const stru
 }
 
 static int
-checkentry(const char *tablename, const void *e, void *targinfo,
-   unsigned int targinfosize, unsigned int hook_mask)
+checkentry(const char *tablename, const void *e, const struct xt_target *target,
+           void *targinfo, unsigned int targinfosize, unsigned int hook_mask)
 {
 	const struct arpt_mangle *mangle = targinfo;
 
diff --git a/net/ipv4/netfilter/ip_nat_rule.c b/net/ipv4/netfilter/ip_nat_rule.c
index ef4be3d..efba8c4 100644
--- a/net/ipv4/netfilter/ip_nat_rule.c
+++ b/net/ipv4/netfilter/ip_nat_rule.c
@@ -103,6 +103,7 @@ static unsigned int ipt_snat_target(stru
 				    const struct net_device *in,
 				    const struct net_device *out,
 				    unsigned int hooknum,
+				    const struct ipt_target *target,
 				    const void *targinfo,
 				    void *userinfo)
 {
@@ -145,6 +146,7 @@ static unsigned int ipt_dnat_target(stru
 				    const struct net_device *in,
 				    const struct net_device *out,
 				    unsigned int hooknum,
+				    const struct ipt_target *target,
 				    const void *targinfo,
 				    void *userinfo)
 {
@@ -170,6 +172,7 @@ static unsigned int ipt_dnat_target(stru
 
 static int ipt_snat_checkentry(const char *tablename,
 			       const void *entry,
+			       const struct ipt_target *target,
 			       void *targinfo,
 			       unsigned int targinfosize,
 			       unsigned int hook_mask)
@@ -186,6 +189,7 @@ static int ipt_snat_checkentry(const cha
 
 static int ipt_dnat_checkentry(const char *tablename,
 			       const void *entry,
+			       const struct ipt_target *target,
 			       void *targinfo,
 			       unsigned int targinfosize,
 			       unsigned int hook_mask)
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 2381a4a..cf5b9db 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -179,6 +179,7 @@ ipt_error(struct sk_buff **pskb,
 	  const struct net_device *in,
 	  const struct net_device *out,
 	  unsigned int hooknum,
+	  const struct xt_target *target,
 	  const void *targinfo,
 	  void *userinfo)
 {
@@ -1285,6 +1286,7 @@ static int
 icmp_match(const struct sk_buff *skb,
 	   const struct net_device *in,
 	   const struct net_device *out,
+	   const struct xt_match *match,
 	   const void *matchinfo,
 	   int offset,
 	   unsigned int protoff,
@@ -1318,6 +1320,7 @@ icmp_match(const struct sk_buff *skb,
 static int
 icmp_checkentry(const char *tablename,
 	   const void *info,
+	   const struct xt_match *match,
 	   void *matchinfo,
 	   unsigned int matchsize,
 	   unsigned int hook_mask)
diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index 24f88dd..61e11ed 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -311,6 +311,7 @@ target(struct sk_buff **pskb,
        const struct net_device *in,
        const struct net_device *out,
        unsigned int hooknum,
+       const struct xt_target *target,
        const void *targinfo,
        void *userinfo)
 {
@@ -380,6 +381,7 @@ target(struct sk_buff **pskb,
 static int
 checkentry(const char *tablename,
 	   const void *e_void,
+	   const struct xt_target *target,
            void *targinfo,
            unsigned int targinfosize,
            unsigned int hook_mask)
@@ -458,9 +460,10 @@ checkentry(const char *tablename,
 }
 
 /* drop reference count of cluster config when rule is deleted */
-static void destroy(void *matchinfo, unsigned int matchinfosize)
+static void destroy(const struct xt_target *target, void *targinfo,
+		    unsigned int targinfosize)
 {
-	struct ipt_clusterip_tgt_info *cipinfo = matchinfo;
+	struct ipt_clusterip_tgt_info *cipinfo = targinfo;
 
 	/* if no more entries are referencing the config, remove it
 	 * from the list and destroy the proc entry */
diff --git a/net/ipv4/netfilter/ipt_DSCP.c b/net/ipv4/netfilter/ipt_DSCP.c
index a202467..cfb0b90 100644
--- a/net/ipv4/netfilter/ipt_DSCP.c
+++ b/net/ipv4/netfilter/ipt_DSCP.c
@@ -29,6 +29,7 @@ target(struct sk_buff **pskb,
        const struct net_device *in,
        const struct net_device *out,
        unsigned int hooknum,
+       const struct xt_target *target,
        const void *targinfo,
        void *userinfo)
 {
@@ -58,6 +59,7 @@ target(struct sk_buff **pskb,
 static int
 checkentry(const char *tablename,
 	   const void *e_void,
+	   const struct xt_target *target,
            void *targinfo,
            unsigned int targinfosize,
            unsigned int hook_mask)
diff --git a/net/ipv4/netfilter/ipt_ECN.c b/net/ipv4/netfilter/ipt_ECN.c
index 1bf1a40..b9b80f9 100644
--- a/net/ipv4/netfilter/ipt_ECN.c
+++ b/net/ipv4/netfilter/ipt_ECN.c
@@ -94,6 +94,7 @@ target(struct sk_buff **pskb,
        const struct net_device *in,
        const struct net_device *out,
        unsigned int hooknum,
+       const struct xt_target *target,
        const void *targinfo,
        void *userinfo)
 {
@@ -114,6 +115,7 @@ target(struct sk_buff **pskb,
 static int
 checkentry(const char *tablename,
 	   const void *e_void,
+	   const struct xt_target *target,
            void *targinfo,
            unsigned int targinfosize,
            unsigned int hook_mask)
diff --git a/net/ipv4/netfilter/ipt_LOG.c b/net/ipv4/netfilter/ipt_LOG.c
index 24f1495..ea92f1f 100644
--- a/net/ipv4/netfilter/ipt_LOG.c
+++ b/net/ipv4/netfilter/ipt_LOG.c
@@ -415,6 +415,7 @@ ipt_log_target(struct sk_buff **pskb,
 	       const struct net_device *in,
 	       const struct net_device *out,
 	       unsigned int hooknum,
+	       const struct xt_target *target,
 	       const void *targinfo,
 	       void *userinfo)
 {
@@ -432,6 +433,7 @@ ipt_log_target(struct sk_buff **pskb,
 
 static int ipt_log_checkentry(const char *tablename,
 			      const void *e,
+			      const struct xt_target *target,
 			      void *targinfo,
 			      unsigned int targinfosize,
 			      unsigned int hook_mask)
diff --git a/net/ipv4/netfilter/ipt_MASQUERADE.c b/net/ipv4/netfilter/ipt_MASQUERADE.c
index df5ea08..e0c321c 100644
--- a/net/ipv4/netfilter/ipt_MASQUERADE.c
+++ b/net/ipv4/netfilter/ipt_MASQUERADE.c
@@ -41,6 +41,7 @@ static DEFINE_RWLOCK(masq_lock);
 static int
 masquerade_check(const char *tablename,
 		 const void *e,
+		 const struct xt_target *target,
 		 void *targinfo,
 		 unsigned int targinfosize,
 		 unsigned int hook_mask)
@@ -63,6 +64,7 @@ masquerade_target(struct sk_buff **pskb,
 		  const struct net_device *in,
 		  const struct net_device *out,
 		  unsigned int hooknum,
+		  const struct xt_target *target,
 		  const void *targinfo,
 		  void *userinfo)
 {
diff --git a/net/ipv4/netfilter/ipt_NETMAP.c b/net/ipv4/netfilter/ipt_NETMAP.c
index 836d67e..fba181c 100644
--- a/net/ipv4/netfilter/ipt_NETMAP.c
+++ b/net/ipv4/netfilter/ipt_NETMAP.c
@@ -32,6 +32,7 @@ MODULE_DESCRIPTION("iptables 1:1 NAT map
 static int
 check(const char *tablename,
       const void *e,
+      const struct xt_target *target,
       void *targinfo,
       unsigned int targinfosize,
       unsigned int hook_mask)
@@ -54,6 +55,7 @@ target(struct sk_buff **pskb,
        const struct net_device *in,
        const struct net_device *out,
        unsigned int hooknum,
+       const struct xt_target *target,
        const void *targinfo,
        void *userinfo)
 {
diff --git a/net/ipv4/netfilter/ipt_REDIRECT.c b/net/ipv4/netfilter/ipt_REDIRECT.c
index cc165e0..be3da7c 100644
--- a/net/ipv4/netfilter/ipt_REDIRECT.c
+++ b/net/ipv4/netfilter/ipt_REDIRECT.c
@@ -34,6 +34,7 @@ MODULE_DESCRIPTION("iptables REDIRECT ta
 static int
 redirect_check(const char *tablename,
 	       const void *e,
+	       const struct xt_target *target,
 	       void *targinfo,
 	       unsigned int targinfosize,
 	       unsigned int hook_mask)
@@ -56,6 +57,7 @@ redirect_target(struct sk_buff **pskb,
 		const struct net_device *in,
 		const struct net_device *out,
 		unsigned int hooknum,
+		const struct xt_target *target,
 		const void *targinfo,
 		void *userinfo)
 {
diff --git a/net/ipv4/netfilter/ipt_REJECT.c b/net/ipv4/netfilter/ipt_REJECT.c
index ddd6bd1..26ea6c1 100644
--- a/net/ipv4/netfilter/ipt_REJECT.c
+++ b/net/ipv4/netfilter/ipt_REJECT.c
@@ -236,6 +236,7 @@ static unsigned int reject(struct sk_buf
 			   const struct net_device *in,
 			   const struct net_device *out,
 			   unsigned int hooknum,
+			   const struct xt_target *target,
 			   const void *targinfo,
 			   void *userinfo)
 {
@@ -283,6 +284,7 @@ static unsigned int reject(struct sk_buf
 
 static int check(const char *tablename,
 		 const void *e_void,
+		 const struct xt_target *target,
 		 void *targinfo,
 		 unsigned int targinfosize,
 		 unsigned int hook_mask)
diff --git a/net/ipv4/netfilter/ipt_SAME.c b/net/ipv4/netfilter/ipt_SAME.c
index 8743c3a..7e2ebc9 100644
--- a/net/ipv4/netfilter/ipt_SAME.c
+++ b/net/ipv4/netfilter/ipt_SAME.c
@@ -50,6 +50,7 @@ MODULE_DESCRIPTION("iptables special SNA
 static int
 same_check(const char *tablename,
 	      const void *e,
+	      const struct xt_target *target,
 	      void *targinfo,
 	      unsigned int targinfosize,
 	      unsigned int hook_mask)
@@ -115,7 +116,7 @@ same_check(const char *tablename,
 }
 
 static void 
-same_destroy(void *targinfo,
+same_destroy(const struct xt_target *target, void *targinfo,
 		unsigned int targinfosize)
 {
 	struct ipt_same_info *mr = targinfo;
@@ -131,6 +132,7 @@ same_target(struct sk_buff **pskb,
 		const struct net_device *in,
 		const struct net_device *out,
 		unsigned int hooknum,
+		const struct xt_target *target,
 		const void *targinfo,
 		void *userinfo)
 {
diff --git a/net/ipv4/netfilter/ipt_TCPMSS.c b/net/ipv4/netfilter/ipt_TCPMSS.c
index 4be6e2b..c4fc50e 100644
--- a/net/ipv4/netfilter/ipt_TCPMSS.c
+++ b/net/ipv4/netfilter/ipt_TCPMSS.c
@@ -48,6 +48,7 @@ ipt_tcpmss_target(struct sk_buff **pskb,
 		  const struct net_device *in,
 		  const struct net_device *out,
 		  unsigned int hooknum,
+		  const struct xt_target *target,
 		  const void *targinfo,
 		  void *userinfo)
 {
@@ -211,6 +212,7 @@ static inline int find_syn_match(const s
 static int
 ipt_tcpmss_checkentry(const char *tablename,
 		      const void *e_void,
+		      const struct xt_target *target,
 		      void *targinfo,
 		      unsigned int targinfosize,
 		      unsigned int hook_mask)
diff --git a/net/ipv4/netfilter/ipt_TOS.c b/net/ipv4/netfilter/ipt_TOS.c
index 6568e3e..9aa7817 100644
--- a/net/ipv4/netfilter/ipt_TOS.c
+++ b/net/ipv4/netfilter/ipt_TOS.c
@@ -25,6 +25,7 @@ target(struct sk_buff **pskb,
        const struct net_device *in,
        const struct net_device *out,
        unsigned int hooknum,
+       const struct xt_target *target,
        const void *targinfo,
        void *userinfo)
 {
@@ -53,6 +54,7 @@ target(struct sk_buff **pskb,
 static int
 checkentry(const char *tablename,
 	   const void *e_void,
+	   const struct xt_target *target,
            void *targinfo,
            unsigned int targinfosize,
            unsigned int hook_mask)
diff --git a/net/ipv4/netfilter/ipt_TTL.c b/net/ipv4/netfilter/ipt_TTL.c
index 61d94e0..5009a00 100644
--- a/net/ipv4/netfilter/ipt_TTL.c
+++ b/net/ipv4/netfilter/ipt_TTL.c
@@ -20,9 +20,10 @@ MODULE_DESCRIPTION("IP tables TTL modifi
 MODULE_LICENSE("GPL");
 
 static unsigned int 
-ipt_ttl_target(struct sk_buff **pskb, const struct net_device *in, 
-		const struct net_device *out, unsigned int hooknum, 
-		const void *targinfo, void *userinfo)
+ipt_ttl_target(struct sk_buff **pskb,
+	       const struct net_device *in, const struct net_device *out,
+	       unsigned int hooknum, const struct xt_target *target,
+	       const void *targinfo, void *userinfo)
 {
 	struct iphdr *iph;
 	const struct ipt_TTL_info *info = targinfo;
@@ -67,6 +68,7 @@ ipt_ttl_target(struct sk_buff **pskb, co
 
 static int ipt_ttl_checkentry(const char *tablename,
 		const void *e,
+		const struct xt_target *target,
 		void *targinfo,
 		unsigned int targinfosize,
 		unsigned int hook_mask)
diff --git a/net/ipv4/netfilter/ipt_ULOG.c b/net/ipv4/netfilter/ipt_ULOG.c
index c95e7e9..a82a32e 100644
--- a/net/ipv4/netfilter/ipt_ULOG.c
+++ b/net/ipv4/netfilter/ipt_ULOG.c
@@ -303,6 +303,7 @@ static unsigned int ipt_ulog_target(stru
 				    const struct net_device *in,
 				    const struct net_device *out,
 				    unsigned int hooknum,
+				    const struct xt_target *target,
 				    const void *targinfo, void *userinfo)
 {
 	struct ipt_ulog_info *loginfo = (struct ipt_ulog_info *) targinfo;
@@ -339,6 +340,7 @@ static void ipt_logfn(unsigned int pf,
 
 static int ipt_ulog_checkentry(const char *tablename,
 			       const void *e,
+			       const struct xt_target *target,
 			       void *targinfo,
 			       unsigned int targinfosize,
 			       unsigned int hookmask)
diff --git a/net/ipv4/netfilter/ipt_addrtype.c b/net/ipv4/netfilter/ipt_addrtype.c
index ad5dc46..5fdf85d 100644
--- a/net/ipv4/netfilter/ipt_addrtype.c
+++ b/net/ipv4/netfilter/ipt_addrtype.c
@@ -27,8 +27,9 @@ static inline int match_type(u_int32_t a
 	return !!(mask & (1 << inet_addr_type(addr)));
 }
 
-static int match(const struct sk_buff *skb, const struct net_device *in,
-		 const struct net_device *out, const void *matchinfo,
+static int match(const struct sk_buff *skb,
+		 const struct net_device *in, const struct net_device *out,
+		 const struct xt_match *match, const void *matchinfo,
 		 int offset, unsigned int protoff, int *hotdrop)
 {
 	const struct ipt_addrtype_info *info = matchinfo;
diff --git a/net/ipv4/netfilter/ipt_ah.c b/net/ipv4/netfilter/ipt_ah.c
index a33eeea..35a21fb 100644
--- a/net/ipv4/netfilter/ipt_ah.c
+++ b/net/ipv4/netfilter/ipt_ah.c
@@ -39,6 +39,7 @@ static int
 match(const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
+      const struct xt_match *match,
       const void *matchinfo,
       int offset,
       unsigned int protoff,
@@ -71,6 +72,7 @@ match(const struct sk_buff *skb,
 static int
 checkentry(const char *tablename,
 	   const void *ip_void,
+	   const struct xt_match *match,
 	   void *matchinfo,
 	   unsigned int matchinfosize,
 	   unsigned int hook_mask)
diff --git a/net/ipv4/netfilter/ipt_dscp.c b/net/ipv4/netfilter/ipt_dscp.c
index e7889ba..11963c3 100644
--- a/net/ipv4/netfilter/ipt_dscp.c
+++ b/net/ipv4/netfilter/ipt_dscp.c
@@ -19,8 +19,9 @@ MODULE_AUTHOR("Harald Welte <laforge@net
 MODULE_DESCRIPTION("iptables DSCP matching module");
 MODULE_LICENSE("GPL");
 
-static int match(const struct sk_buff *skb, const struct net_device *in,
-		 const struct net_device *out, const void *matchinfo,
+static int match(const struct sk_buff *skb,
+		 const struct net_device *in, const struct net_device *out,
+		 const struct xt_match *match, const void *matchinfo,
 		 int offset, unsigned int protoff, int *hotdrop)
 {
 	const struct ipt_dscp_info *info = matchinfo;
diff --git a/net/ipv4/netfilter/ipt_ecn.c b/net/ipv4/netfilter/ipt_ecn.c
index 723957f..d7e29f6 100644
--- a/net/ipv4/netfilter/ipt_ecn.c
+++ b/net/ipv4/netfilter/ipt_ecn.c
@@ -65,8 +65,9 @@ static inline int match_tcp(const struct
 	return 1;
 }
 
-static int match(const struct sk_buff *skb, const struct net_device *in,
-		 const struct net_device *out, const void *matchinfo,
+static int match(const struct sk_buff *skb,
+		 const struct net_device *in, const struct net_device *out,
+		 const struct xt_match *match, const void *matchinfo,
 		 int offset, unsigned int protoff, int *hotdrop)
 {
 	const struct ipt_ecn_info *info = matchinfo;
@@ -86,6 +87,7 @@ static int match(const struct sk_buff *s
 }
 
 static int checkentry(const char *tablename, const void *ip_void,
+		      const struct xt_match *match,
 		      void *matchinfo, unsigned int matchsize,
 		      unsigned int hook_mask)
 {
diff --git a/net/ipv4/netfilter/ipt_esp.c b/net/ipv4/netfilter/ipt_esp.c
index 984fa48..af0d5ec 100644
--- a/net/ipv4/netfilter/ipt_esp.c
+++ b/net/ipv4/netfilter/ipt_esp.c
@@ -40,6 +40,7 @@ static int
 match(const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
+      const struct xt_match *match,
       const void *matchinfo,
       int offset,
       unsigned int protoff,
@@ -72,6 +73,7 @@ match(const struct sk_buff *skb,
 static int
 checkentry(const char *tablename,
 	   const void *ip_void,
+	   const struct xt_match *match,
 	   void *matchinfo,
 	   unsigned int matchinfosize,
 	   unsigned int hook_mask)
diff --git a/net/ipv4/netfilter/ipt_hashlimit.c b/net/ipv4/netfilter/ipt_hashlimit.c
index 156d9c2..dc1521c 100644
--- a/net/ipv4/netfilter/ipt_hashlimit.c
+++ b/net/ipv4/netfilter/ipt_hashlimit.c
@@ -427,6 +427,7 @@ static int
 hashlimit_match(const struct sk_buff *skb,
 		const struct net_device *in,
 		const struct net_device *out,
+		const struct xt_match *match,
 		const void *matchinfo,
 		int offset,
 		unsigned int protoff,
@@ -506,6 +507,7 @@ hashlimit_match(const struct sk_buff *sk
 static int
 hashlimit_checkentry(const char *tablename,
 		     const void *inf,
+		     const struct xt_match *match,
 		     void *matchinfo,
 		     unsigned int matchsize,
 		     unsigned int hook_mask)
@@ -555,7 +557,8 @@ hashlimit_checkentry(const char *tablena
 }
 
 static void
-hashlimit_destroy(void *matchinfo, unsigned int matchsize)
+hashlimit_destroy(const struct xt_match *match, void *matchinfo,
+		  unsigned int matchsize)
 {
 	struct ipt_hashlimit_info *r = (struct ipt_hashlimit_info *) matchinfo;
 
diff --git a/net/ipv4/netfilter/ipt_iprange.c b/net/ipv4/netfilter/ipt_iprange.c
index 0885ff5..ae70112 100644
--- a/net/ipv4/netfilter/ipt_iprange.c
+++ b/net/ipv4/netfilter/ipt_iprange.c
@@ -27,6 +27,7 @@ static int
 match(const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
+      const struct xt_match *match,
       const void *matchinfo,
       int offset, unsigned int protoff, int *hotdrop)
 {
diff --git a/net/ipv4/netfilter/ipt_multiport.c b/net/ipv4/netfilter/ipt_multiport.c
index 8f1684c..bd07f7c 100644
--- a/net/ipv4/netfilter/ipt_multiport.c
+++ b/net/ipv4/netfilter/ipt_multiport.c
@@ -95,6 +95,7 @@ static int
 match(const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
+      const struct xt_match *match,
       const void *matchinfo,
       int offset,
       unsigned int protoff,
@@ -127,6 +128,7 @@ static int
 match_v1(const struct sk_buff *skb,
 	 const struct net_device *in,
 	 const struct net_device *out,
+	 const struct xt_match *match,
 	 const void *matchinfo,
 	 int offset,
 	 unsigned int protoff,
diff --git a/net/ipv4/netfilter/ipt_owner.c b/net/ipv4/netfilter/ipt_owner.c
index 18adc1d..3900428 100644
--- a/net/ipv4/netfilter/ipt_owner.c
+++ b/net/ipv4/netfilter/ipt_owner.c
@@ -25,6 +25,7 @@ static int
 match(const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
+      const struct xt_match *match,
       const void *matchinfo,
       int offset,
       unsigned int protoff,
@@ -53,6 +54,7 @@ match(const struct sk_buff *skb,
 static int
 checkentry(const char *tablename,
            const void *ip,
+	   const struct xt_match *match,
            void *matchinfo,
            unsigned int matchsize,
            unsigned int hook_mask)
diff --git a/net/ipv4/netfilter/ipt_policy.c b/net/ipv4/netfilter/ipt_policy.c
index 3fa6607..b73f590 100644
--- a/net/ipv4/netfilter/ipt_policy.c
+++ b/net/ipv4/netfilter/ipt_policy.c
@@ -98,6 +98,7 @@ match_policy_out(const struct sk_buff *s
 static int match(const struct sk_buff *skb,
                  const struct net_device *in,
                  const struct net_device *out,
+		 const struct xt_match *match,
                  const void *matchinfo,
                  int offset,
                  unsigned int protoff,
@@ -120,6 +121,7 @@ static int match(const struct sk_buff *s
 }
 
 static int checkentry(const char *tablename, const void *ip_void,
+		      const struct xt_match *match,
                       void *matchinfo, unsigned int matchsize,
                       unsigned int hook_mask)
 {
diff --git a/net/ipv4/netfilter/ipt_recent.c b/net/ipv4/netfilter/ipt_recent.c
index e2ccd42..06792ea 100644
--- a/net/ipv4/netfilter/ipt_recent.c
+++ b/net/ipv4/netfilter/ipt_recent.c
@@ -102,6 +102,7 @@ static int
 match(const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
+      const struct xt_match *match,
       const void *matchinfo,
       int offset,
       unsigned int protoff,
@@ -318,7 +319,7 @@ static int ip_recent_ctrl(struct file *f
 	skb->nh.iph->daddr = 0;
 	/* Clear ttl since we have no way of knowing it */
 	skb->nh.iph->ttl = 0;
-	match(skb,NULL,NULL,info,0,0,NULL);
+	match(skb,NULL,NULL,NULL,info,0,0,NULL);
 
 	kfree(skb->nh.iph);
 out_free_skb:
@@ -356,6 +357,7 @@ static int
 match(const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
+      const struct xt_match *match,
       const void *matchinfo,
       int offset,
       unsigned int protoff,
@@ -657,6 +659,7 @@ match(const struct sk_buff *skb,
 static int
 checkentry(const char *tablename,
            const void *ip,
+	   const struct xt_match *match,
            void *matchinfo,
            unsigned int matchsize,
            unsigned int hook_mask)
@@ -869,7 +872,7 @@ checkentry(const char *tablename,
  * up its memory.
  */
 static void
-destroy(void *matchinfo, unsigned int matchsize)
+destroy(const struct xt_match *match, void *matchinfo, unsigned int matchsize)
 {
 	const struct ipt_recent_info *info = matchinfo;
 	struct recent_ip_tables *curr_table, *last_table;
diff --git a/net/ipv4/netfilter/ipt_tos.c b/net/ipv4/netfilter/ipt_tos.c
index 4675c78..e404e92 100644
--- a/net/ipv4/netfilter/ipt_tos.c
+++ b/net/ipv4/netfilter/ipt_tos.c
@@ -21,6 +21,7 @@ static int
 match(const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
+      const struct xt_match *match,
       const void *matchinfo,
       int offset,
       unsigned int protoff,
diff --git a/net/ipv4/netfilter/ipt_ttl.c b/net/ipv4/netfilter/ipt_ttl.c
index bb694a0..ae7ce4d 100644
--- a/net/ipv4/netfilter/ipt_ttl.c
+++ b/net/ipv4/netfilter/ipt_ttl.c
@@ -19,8 +19,9 @@ MODULE_AUTHOR("Harald Welte <laforge@net
 MODULE_DESCRIPTION("IP tables TTL matching module");
 MODULE_LICENSE("GPL");
 
-static int match(const struct sk_buff *skb, const struct net_device *in,
-		 const struct net_device *out, const void *matchinfo,
+static int match(const struct sk_buff *skb,
+		 const struct net_device *in, const struct net_device *out,
+		 const struct xt_match *match, const void *matchinfo,
 		 int offset, unsigned int protoff, int *hotdrop)
 {
 	const struct ipt_ttl_info *info = matchinfo;
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 2dc731a..bb04852 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -232,6 +232,7 @@ ip6t_error(struct sk_buff **pskb,
 	  const struct net_device *in,
 	  const struct net_device *out,
 	  unsigned int hooknum,
+	  const struct xt_target *target,
 	  const void *targinfo,
 	  void *userinfo)
 {
@@ -1341,6 +1342,7 @@ static int
 icmp6_match(const struct sk_buff *skb,
 	   const struct net_device *in,
 	   const struct net_device *out,
+	   const struct xt_match *match,
 	   const void *matchinfo,
 	   int offset,
 	   unsigned int protoff,
@@ -1373,6 +1375,7 @@ icmp6_match(const struct sk_buff *skb,
 static int
 icmp6_checkentry(const char *tablename,
 	   const void *entry,
+	   const struct xt_match *match,
 	   void *matchinfo,
 	   unsigned int matchsize,
 	   unsigned int hook_mask)
diff --git a/net/ipv6/netfilter/ip6t_HL.c b/net/ipv6/netfilter/ip6t_HL.c
index ab39ee9..da14c6d 100644
--- a/net/ipv6/netfilter/ip6t_HL.c
+++ b/net/ipv6/netfilter/ip6t_HL.c
@@ -21,6 +21,7 @@ static unsigned int ip6t_hl_target(struc
 				   const struct net_device *in,
 				   const struct net_device *out,
 				   unsigned int hooknum,
+				   const struct xt_target *target,
 				   const void *targinfo, void *userinfo)
 {
 	struct ipv6hdr *ip6h;
@@ -63,6 +64,7 @@ static unsigned int ip6t_hl_target(struc
 
 static int ip6t_hl_checkentry(const char *tablename,
 		const void *entry,
+		const struct xt_target *target,
 		void *targinfo,
 		unsigned int targinfosize,
 		unsigned int hook_mask)
diff --git a/net/ipv6/netfilter/ip6t_LOG.c b/net/ipv6/netfilter/ip6t_LOG.c
index 171c9ba..f4963ad 100644
--- a/net/ipv6/netfilter/ip6t_LOG.c
+++ b/net/ipv6/netfilter/ip6t_LOG.c
@@ -426,6 +426,7 @@ ip6t_log_target(struct sk_buff **pskb,
 		const struct net_device *in,
 		const struct net_device *out,
 		unsigned int hooknum,
+		const struct xt_target *target,
 		const void *targinfo,
 		void *userinfo)
 {
@@ -444,6 +445,7 @@ ip6t_log_target(struct sk_buff **pskb,
 
 static int ip6t_log_checkentry(const char *tablename,
 			       const void *entry,
+			       const struct xt_target *target,
 			       void *targinfo,
 			       unsigned int targinfosize,
 			       unsigned int hook_mask)
diff --git a/net/ipv6/netfilter/ip6t_REJECT.c b/net/ipv6/netfilter/ip6t_REJECT.c
index 8640706..ddfa385 100644
--- a/net/ipv6/netfilter/ip6t_REJECT.c
+++ b/net/ipv6/netfilter/ip6t_REJECT.c
@@ -179,6 +179,7 @@ static unsigned int reject6_target(struc
 			   const struct net_device *in,
 			   const struct net_device *out,
 			   unsigned int hooknum,
+			   const struct xt_target *target,
 			   const void *targinfo,
 			   void *userinfo)
 {
@@ -221,6 +222,7 @@ static unsigned int reject6_target(struc
 
 static int check(const char *tablename,
 		 const void *entry,
+		 const struct xt_target *target,
 		 void *targinfo,
 		 unsigned int targinfosize,
 		 unsigned int hook_mask)
diff --git a/net/ipv6/netfilter/ip6t_ah.c b/net/ipv6/netfilter/ip6t_ah.c
index 28710ed..178f6fb 100644
--- a/net/ipv6/netfilter/ip6t_ah.c
+++ b/net/ipv6/netfilter/ip6t_ah.c
@@ -44,6 +44,7 @@ static int
 match(const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
+      const struct xt_match *match,
       const void *matchinfo,
       int offset,
       unsigned int protoff,
@@ -99,6 +100,7 @@ match(const struct sk_buff *skb,
 static int
 checkentry(const char *tablename,
           const void *entry,
+	  const struct xt_match *match,
           void *matchinfo,
           unsigned int matchinfosize,
           unsigned int hook_mask)
diff --git a/net/ipv6/netfilter/ip6t_dst.c b/net/ipv6/netfilter/ip6t_dst.c
index 2fbde59..e97a702 100644
--- a/net/ipv6/netfilter/ip6t_dst.c
+++ b/net/ipv6/netfilter/ip6t_dst.c
@@ -55,6 +55,7 @@ static int
 match(const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
+      const struct xt_match *match,
       const void *matchinfo,
       int offset,
       unsigned int protoff,
@@ -179,6 +180,7 @@ match(const struct sk_buff *skb,
 static int
 checkentry(const char *tablename,
 	   const void *info,
+	   const struct xt_match *match,
 	   void *matchinfo,
 	   unsigned int matchinfosize,
 	   unsigned int hook_mask)
diff --git a/net/ipv6/netfilter/ip6t_esp.c b/net/ipv6/netfilter/ip6t_esp.c
index ede7223..540b8bf 100644
--- a/net/ipv6/netfilter/ip6t_esp.c
+++ b/net/ipv6/netfilter/ip6t_esp.c
@@ -44,6 +44,7 @@ static int
 match(const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
+      const struct xt_match *match,
       const void *matchinfo,
       int offset,
       unsigned int protoff,
@@ -77,6 +78,7 @@ match(const struct sk_buff *skb,
 static int
 checkentry(const char *tablename,
 	   const void *ip,
+	   const struct xt_match *match,
 	   void *matchinfo,
 	   unsigned int matchinfosize,
 	   unsigned int hook_mask)
diff --git a/net/ipv6/netfilter/ip6t_eui64.c b/net/ipv6/netfilter/ip6t_eui64.c
index bfee5be..d4b0bad 100644
--- a/net/ipv6/netfilter/ip6t_eui64.c
+++ b/net/ipv6/netfilter/ip6t_eui64.c
@@ -22,6 +22,7 @@ static int
 match(const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
+      const struct xt_match *match,
       const void *matchinfo,
       int offset,
       unsigned int protoff,
diff --git a/net/ipv6/netfilter/ip6t_frag.c b/net/ipv6/netfilter/ip6t_frag.c
index 305de9b..4c41e14 100644
--- a/net/ipv6/netfilter/ip6t_frag.c
+++ b/net/ipv6/netfilter/ip6t_frag.c
@@ -43,6 +43,7 @@ static int
 match(const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
+      const struct xt_match *match,
       const void *matchinfo,
       int offset,
       unsigned int protoff,
@@ -116,6 +117,7 @@ match(const struct sk_buff *skb,
 static int
 checkentry(const char *tablename,
 	   const void *ip,
+	   const struct xt_match *match,
 	   void *matchinfo,
 	   unsigned int matchinfosize,
 	   unsigned int hook_mask)
diff --git a/net/ipv6/netfilter/ip6t_hbh.c b/net/ipv6/netfilter/ip6t_hbh.c
index ac8d479..b4a1fdf 100644
--- a/net/ipv6/netfilter/ip6t_hbh.c
+++ b/net/ipv6/netfilter/ip6t_hbh.c
@@ -55,6 +55,7 @@ static int
 match(const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
+      const struct xt_match *match,
       const void *matchinfo,
       int offset,
       unsigned int protoff,
@@ -179,6 +180,7 @@ match(const struct sk_buff *skb,
 static int
 checkentry(const char *tablename,
 	   const void *entry,
+	   const struct xt_match *match,
 	   void *matchinfo,
 	   unsigned int matchinfosize,
 	   unsigned int hook_mask)
diff --git a/net/ipv6/netfilter/ip6t_hl.c b/net/ipv6/netfilter/ip6t_hl.c
index 1eabb65..3740557 100644
--- a/net/ipv6/netfilter/ip6t_hl.c
+++ b/net/ipv6/netfilter/ip6t_hl.c
@@ -18,10 +18,10 @@ MODULE_AUTHOR("Maciej Soltysiak <solt@dn
 MODULE_DESCRIPTION("IP tables Hop Limit matching module");
 MODULE_LICENSE("GPL");
 
-static int match(const struct sk_buff *skb, const struct net_device *in,
-		 const struct net_device *out, const void *matchinfo,
-		 int offset, unsigned int protoff,
-		 int *hotdrop)
+static int match(const struct sk_buff *skb,
+		 const struct net_device *in, const struct net_device *out,
+		 const struct xt_match *match, const void *matchinfo,
+		 int offset, unsigned int protoff, int *hotdrop)
 {
 	const struct ip6t_hl_info *info = matchinfo;
 	const struct ipv6hdr *ip6h = skb->nh.ipv6h;
diff --git a/net/ipv6/netfilter/ip6t_ipv6header.c b/net/ipv6/netfilter/ip6t_ipv6header.c
index 063032a..9375eeb 100644
--- a/net/ipv6/netfilter/ip6t_ipv6header.c
+++ b/net/ipv6/netfilter/ip6t_ipv6header.c
@@ -29,6 +29,7 @@ static int
 ipv6header_match(const struct sk_buff *skb,
 		 const struct net_device *in,
 		 const struct net_device *out,
+		 const struct xt_match *match,
 		 const void *matchinfo,
 		 int offset,
 		 unsigned int protoff,
@@ -125,6 +126,7 @@ ipv6header_match(const struct sk_buff *s
 static int
 ipv6header_checkentry(const char *tablename,
 		      const void *ip,
+		      const struct xt_match *match,
 		      void *matchinfo,
 		      unsigned int matchsize,
 		      unsigned int hook_mask)
diff --git a/net/ipv6/netfilter/ip6t_multiport.c b/net/ipv6/netfilter/ip6t_multiport.c
index b86774d..752b65d 100644
--- a/net/ipv6/netfilter/ip6t_multiport.c
+++ b/net/ipv6/netfilter/ip6t_multiport.c
@@ -51,6 +51,7 @@ static int
 match(const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
+      const struct xt_match *match,
       const void *matchinfo,
       int offset,
       unsigned int protoff,
@@ -85,6 +86,7 @@ match(const struct sk_buff *skb,
 static int
 checkentry(const char *tablename,
 	   const void *info,
+	   const struct xt_match *match,
 	   void *matchinfo,
 	   unsigned int matchsize,
 	   unsigned int hook_mask)
diff --git a/net/ipv6/netfilter/ip6t_owner.c b/net/ipv6/netfilter/ip6t_owner.c
index e26cd6d..e2cee3b 100644
--- a/net/ipv6/netfilter/ip6t_owner.c
+++ b/net/ipv6/netfilter/ip6t_owner.c
@@ -26,6 +26,7 @@ static int
 match(const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
+      const struct xt_match *match,
       const void *matchinfo,
       int offset,
       unsigned int protoff,
@@ -54,6 +55,7 @@ match(const struct sk_buff *skb,
 static int
 checkentry(const char *tablename,
 	   const void *ip,
+	   const struct xt_match *match,
 	   void *matchinfo,
 	   unsigned int matchsize,
 	   unsigned int hook_mask)
diff --git a/net/ipv6/netfilter/ip6t_policy.c b/net/ipv6/netfilter/ip6t_policy.c
index ac8a544..b2f3007 100644
--- a/net/ipv6/netfilter/ip6t_policy.c
+++ b/net/ipv6/netfilter/ip6t_policy.c
@@ -98,6 +98,7 @@ match_policy_out(const struct sk_buff *s
 static int match(const struct sk_buff *skb,
                  const struct net_device *in,
                  const struct net_device *out,
+		 const struct xt_match *match,
                  const void *matchinfo,
 		 int offset,
 		 unsigned int protoff,
@@ -120,8 +121,8 @@ static int match(const struct sk_buff *s
 }
 
 static int checkentry(const char *tablename, const void *ip_void,
-                      void *matchinfo, unsigned int matchsize,
-                      unsigned int hook_mask)
+                      const struct xt_match *match, void *matchinfo,
+		      unsigned int matchsize, unsigned int hook_mask)
 {
 	struct ip6t_policy_info *info = matchinfo;
 
diff --git a/net/ipv6/netfilter/ip6t_rt.c b/net/ipv6/netfilter/ip6t_rt.c
index a381074..4c6b55b 100644
--- a/net/ipv6/netfilter/ip6t_rt.c
+++ b/net/ipv6/netfilter/ip6t_rt.c
@@ -45,6 +45,7 @@ static int
 match(const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
+      const struct xt_match *match,
       const void *matchinfo,
       int offset,
       unsigned int protoff,
@@ -194,6 +195,7 @@ match(const struct sk_buff *skb,
 static int
 checkentry(const char *tablename,
 	   const void *entry,
+	   const struct xt_match *match,
 	   void *matchinfo,
 	   unsigned int matchinfosize,
 	   unsigned int hook_mask)
diff --git a/net/netfilter/xt_CLASSIFY.c b/net/netfilter/xt_CLASSIFY.c
index 6b36e84..3224ed8 100644
--- a/net/netfilter/xt_CLASSIFY.c
+++ b/net/netfilter/xt_CLASSIFY.c
@@ -28,6 +28,7 @@ target(struct sk_buff **pskb,
        const struct net_device *in,
        const struct net_device *out,
        unsigned int hooknum,
+       const struct xt_target *target,
        const void *targinfo,
        void *userinfo)
 {
diff --git a/net/netfilter/xt_CONNMARK.c b/net/netfilter/xt_CONNMARK.c
index b269ba9..df2486a 100644
--- a/net/netfilter/xt_CONNMARK.c
+++ b/net/netfilter/xt_CONNMARK.c
@@ -37,6 +37,7 @@ target(struct sk_buff **pskb,
        const struct net_device *in,
        const struct net_device *out,
        unsigned int hooknum,
+       const struct xt_target *target,
        const void *targinfo,
        void *userinfo)
 {
@@ -74,6 +75,7 @@ target(struct sk_buff **pskb,
 static int
 checkentry(const char *tablename,
 	   const void *entry,
+	   const struct xt_target *target,
 	   void *targinfo,
 	   unsigned int targinfosize,
 	   unsigned int hook_mask)
diff --git a/net/netfilter/xt_MARK.c b/net/netfilter/xt_MARK.c
index 1bc968b..dcb5266 100644
--- a/net/netfilter/xt_MARK.c
+++ b/net/netfilter/xt_MARK.c
@@ -26,6 +26,7 @@ target_v0(struct sk_buff **pskb,
 	  const struct net_device *in,
 	  const struct net_device *out,
 	  unsigned int hooknum,
+	  const struct xt_target *target,
 	  const void *targinfo,
 	  void *userinfo)
 {
@@ -42,6 +43,7 @@ target_v1(struct sk_buff **pskb,
 	  const struct net_device *in,
 	  const struct net_device *out,
 	  unsigned int hooknum,
+	  const struct xt_target *target,
 	  const void *targinfo,
 	  void *userinfo)
 {
@@ -72,6 +74,7 @@ target_v1(struct sk_buff **pskb,
 static int
 checkentry_v0(const char *tablename,
 	      const void *entry,
+	      const struct xt_target *target,
 	      void *targinfo,
 	      unsigned int targinfosize,
 	      unsigned int hook_mask)
@@ -88,6 +91,7 @@ checkentry_v0(const char *tablename,
 static int
 checkentry_v1(const char *tablename,
 	      const void *entry,
+	      const struct xt_target *target,
 	      void *targinfo,
 	      unsigned int targinfosize,
 	      unsigned int hook_mask)
diff --git a/net/netfilter/xt_NFQUEUE.c b/net/netfilter/xt_NFQUEUE.c
index b1da0ad..39a963e 100644
--- a/net/netfilter/xt_NFQUEUE.c
+++ b/net/netfilter/xt_NFQUEUE.c
@@ -28,6 +28,7 @@ target(struct sk_buff **pskb,
        const struct net_device *in,
        const struct net_device *out,
        unsigned int hooknum,
+       const struct xt_target *target,
        const void *targinfo,
        void *userinfo)
 {
diff --git a/net/netfilter/xt_NOTRACK.c b/net/netfilter/xt_NOTRACK.c
index 8bacbe1..b8634e3 100644
--- a/net/netfilter/xt_NOTRACK.c
+++ b/net/netfilter/xt_NOTRACK.c
@@ -15,6 +15,7 @@ target(struct sk_buff **pskb,
        const struct net_device *in,
        const struct net_device *out,
        unsigned int hooknum,
+       const struct xt_target *target,
        const void *targinfo,
        void *userinfo)
 {
diff --git a/net/netfilter/xt_comment.c b/net/netfilter/xt_comment.c
index b3f07aa..03d9d74 100644
--- a/net/netfilter/xt_comment.c
+++ b/net/netfilter/xt_comment.c
@@ -19,6 +19,7 @@ static int
 match(const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
+      const struct xt_match *match,
       const void *matchinfo,
       int offset,
       unsigned int protooff,
diff --git a/net/netfilter/xt_connbytes.c b/net/netfilter/xt_connbytes.c
index d985135..f34ecb9 100644
--- a/net/netfilter/xt_connbytes.c
+++ b/net/netfilter/xt_connbytes.c
@@ -44,6 +44,7 @@ static int
 match(const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
+      const struct xt_match *match,
       const void *matchinfo,
       int offset,
       unsigned int protoff,
@@ -122,6 +123,7 @@ match(const struct sk_buff *skb,
 
 static int check(const char *tablename,
 		 const void *ip,
+		 const struct xt_match *match,
 		 void *matchinfo,
 		 unsigned int matchsize,
 		 unsigned int hook_mask)
diff --git a/net/netfilter/xt_connmark.c b/net/netfilter/xt_connmark.c
index 2bb987f..5182247 100644
--- a/net/netfilter/xt_connmark.c
+++ b/net/netfilter/xt_connmark.c
@@ -35,6 +35,7 @@ static int
 match(const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
+      const struct xt_match *match,
       const void *matchinfo,
       int offset,
       unsigned int protoff,
@@ -52,6 +53,7 @@ match(const struct sk_buff *skb,
 static int
 checkentry(const char *tablename,
 	   const void *ip,
+	   const struct xt_match *match,
 	   void *matchinfo,
 	   unsigned int matchsize,
 	   unsigned int hook_mask)
diff --git a/net/netfilter/xt_conntrack.c b/net/netfilter/xt_conntrack.c
index 45a5a7d..39fc294 100644
--- a/net/netfilter/xt_conntrack.c
+++ b/net/netfilter/xt_conntrack.c
@@ -32,6 +32,7 @@ static int
 match(const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
+      const struct xt_match *match,
       const void *matchinfo,
       int offset,
       unsigned int protoff,
@@ -118,6 +119,7 @@ static int
 match(const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
+      const struct xt_match *match,
       const void *matchinfo,
       int offset,
       unsigned int protoff,
diff --git a/net/netfilter/xt_dccp.c b/net/netfilter/xt_dccp.c
index 06e9ef2..db6b70c 100644
--- a/net/netfilter/xt_dccp.c
+++ b/net/netfilter/xt_dccp.c
@@ -95,6 +95,7 @@ static int
 match(const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
+      const struct xt_match *match,
       const void *matchinfo,
       int offset,
       unsigned int protoff,
@@ -129,6 +130,7 @@ match(const struct sk_buff *skb,
 static int
 checkentry(const char *tablename,
 	   const void *inf,
+	   const struct xt_match *match,
 	   void *matchinfo,
 	   unsigned int matchsize,
 	   unsigned int hook_mask)
diff --git a/net/netfilter/xt_helper.c b/net/netfilter/xt_helper.c
index 70bc00f..79c3d2a 100644
--- a/net/netfilter/xt_helper.c
+++ b/net/netfilter/xt_helper.c
@@ -42,6 +42,7 @@ static int
 match(const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
+      const struct xt_match *match,
       const void *matchinfo,
       int offset,
       unsigned int protoff,
@@ -89,6 +90,7 @@ static int
 match(const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
+      const struct xt_match *match,
       const void *matchinfo,
       int offset,
       unsigned int protoff,
@@ -135,6 +137,7 @@ out_unlock:
 
 static int check(const char *tablename,
 		 const void *inf,
+		 const struct xt_match *match,
 		 void *matchinfo,
 		 unsigned int matchsize,
 		 unsigned int hook_mask)
diff --git a/net/netfilter/xt_length.c b/net/netfilter/xt_length.c
index 11a2812..b9e60f0 100644
--- a/net/netfilter/xt_length.c
+++ b/net/netfilter/xt_length.c
@@ -24,6 +24,7 @@ static int
 match(const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
+      const struct xt_match *match,
       const void *matchinfo,
       int offset,
       unsigned int protoff,
@@ -39,6 +40,7 @@ static int
 match6(const struct sk_buff *skb,
        const struct net_device *in,
        const struct net_device *out,
+       const struct xt_match *match,
        const void *matchinfo,
        int offset,
        unsigned int protoff,
diff --git a/net/netfilter/xt_limit.c b/net/netfilter/xt_limit.c
index dec3f02..3049e6f 100644
--- a/net/netfilter/xt_limit.c
+++ b/net/netfilter/xt_limit.c
@@ -68,6 +68,7 @@ static int
 ipt_limit_match(const struct sk_buff *skb,
 		const struct net_device *in,
 		const struct net_device *out,
+		const struct xt_match *match,
 		const void *matchinfo,
 		int offset,
 		unsigned int protoff,
@@ -107,6 +108,7 @@ user2credits(u_int32_t user)
 static int
 ipt_limit_checkentry(const char *tablename,
 		     const void *inf,
+		     const struct xt_match *match,
 		     void *matchinfo,
 		     unsigned int matchsize,
 		     unsigned int hook_mask)
diff --git a/net/netfilter/xt_mac.c b/net/netfilter/xt_mac.c
index e207726..b4559a4 100644
--- a/net/netfilter/xt_mac.c
+++ b/net/netfilter/xt_mac.c
@@ -27,6 +27,7 @@ static int
 match(const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
+      const struct xt_match *match,
       const void *matchinfo,
       int offset,
       unsigned int protoff,
diff --git a/net/netfilter/xt_mark.c b/net/netfilter/xt_mark.c
index b21b94a..c1a8f0f 100644
--- a/net/netfilter/xt_mark.c
+++ b/net/netfilter/xt_mark.c
@@ -23,6 +23,7 @@ static int
 match(const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
+      const struct xt_match *match,
       const void *matchinfo,
       int offset,
       unsigned int protoff,
@@ -36,6 +37,7 @@ match(const struct sk_buff *skb,
 static int
 checkentry(const char *tablename,
            const void *entry,
+	   const struct xt_match *match,
            void *matchinfo,
            unsigned int matchsize,
            unsigned int hook_mask)
diff --git a/net/netfilter/xt_physdev.c b/net/netfilter/xt_physdev.c
index 5afc417..f788e8e 100644
--- a/net/netfilter/xt_physdev.c
+++ b/net/netfilter/xt_physdev.c
@@ -26,6 +26,7 @@ static int
 match(const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
+      const struct xt_match *match,
       const void *matchinfo,
       int offset,
       unsigned int protoff,
@@ -102,6 +103,7 @@ match_outdev:
 static int
 checkentry(const char *tablename,
 		       const void *ip,
+		       const struct xt_match *match,
 		       void *matchinfo,
 		       unsigned int matchsize,
 		       unsigned int hook_mask)
diff --git a/net/netfilter/xt_pkttype.c b/net/netfilter/xt_pkttype.c
index 872bb2a..f38638d 100644
--- a/net/netfilter/xt_pkttype.c
+++ b/net/netfilter/xt_pkttype.c
@@ -22,6 +22,7 @@ MODULE_ALIAS("ip6t_pkttype");
 static int match(const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
+      const struct xt_match *match,
       const void *matchinfo,
       int offset,
       unsigned int protoff,
diff --git a/net/netfilter/xt_realm.c b/net/netfilter/xt_realm.c
index 249e0a3..57815a0 100644
--- a/net/netfilter/xt_realm.c
+++ b/net/netfilter/xt_realm.c
@@ -27,6 +27,7 @@ static int
 match(const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
+      const struct xt_match *match,
       const void *matchinfo,
       int offset,
       unsigned int protoff,
diff --git a/net/netfilter/xt_sctp.c b/net/netfilter/xt_sctp.c
index f0a25e5..f5d698b 100644
--- a/net/netfilter/xt_sctp.c
+++ b/net/netfilter/xt_sctp.c
@@ -123,6 +123,7 @@ static int
 match(const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
+      const struct xt_match *match,
       const void *matchinfo,
       int offset,
       unsigned int protoff,
@@ -162,6 +163,7 @@ match(const struct sk_buff *skb,
 static int
 checkentry(const char *tablename,
 	   const void *inf,
+	   const struct xt_match *match,
 	   void *matchinfo,
 	   unsigned int matchsize,
 	   unsigned int hook_mask)
diff --git a/net/netfilter/xt_state.c b/net/netfilter/xt_state.c
index 9a7d6df..b8ec00c 100644
--- a/net/netfilter/xt_state.c
+++ b/net/netfilter/xt_state.c
@@ -24,6 +24,7 @@ static int
 match(const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
+      const struct xt_match *match,
       const void *matchinfo,
       int offset,
       unsigned int protoff,
diff --git a/net/netfilter/xt_string.c b/net/netfilter/xt_string.c
index c3efd37..fccbad6 100644
--- a/net/netfilter/xt_string.c
+++ b/net/netfilter/xt_string.c
@@ -24,6 +24,7 @@ MODULE_ALIAS("ip6t_string");
 static int match(const struct sk_buff *skb,
 		 const struct net_device *in,
 		 const struct net_device *out,
+		 const struct xt_match *match,
 		 const void *matchinfo,
 		 int offset,
 		 unsigned int protoff,
@@ -43,6 +44,7 @@ static int match(const struct sk_buff *s
 
 static int checkentry(const char *tablename,
 		      const void *ip,
+		      const struct xt_match *match,
 		      void *matchinfo,
 		      unsigned int matchsize,
 		      unsigned int hook_mask)
@@ -64,7 +66,8 @@ static int checkentry(const char *tablen
 	return 1;
 }
 
-static void destroy(void *matchinfo, unsigned int matchsize)
+static void destroy(const struct xt_match *match, void *matchinfo,
+		    unsigned int matchsize)
 {
 	textsearch_destroy(STRING_TEXT_PRIV(matchinfo)->config);
 }
diff --git a/net/netfilter/xt_tcpmss.c b/net/netfilter/xt_tcpmss.c
index 95d8611..4925fc9 100644
--- a/net/netfilter/xt_tcpmss.c
+++ b/net/netfilter/xt_tcpmss.c
@@ -81,6 +81,7 @@ static int
 match(const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
+      const struct xt_match *match,
       const void *matchinfo,
       int offset,
       unsigned int protoff,
diff --git a/net/netfilter/xt_tcpudp.c b/net/netfilter/xt_tcpudp.c
index 9d01f07..b5cd0dd 100644
--- a/net/netfilter/xt_tcpudp.c
+++ b/net/netfilter/xt_tcpudp.c
@@ -74,6 +74,7 @@ static int
 tcp_match(const struct sk_buff *skb,
 	  const struct net_device *in,
 	  const struct net_device *out,
+	  const struct xt_match *match,
 	  const void *matchinfo,
 	  int offset,
 	  unsigned int protoff,
@@ -138,6 +139,7 @@ tcp_match(const struct sk_buff *skb,
 static int
 tcp_checkentry(const char *tablename,
 	       const void *info,
+	       const struct xt_match *match,
 	       void *matchinfo,
 	       unsigned int matchsize,
 	       unsigned int hook_mask)
@@ -152,6 +154,7 @@ static int
 udp_match(const struct sk_buff *skb,
 	  const struct net_device *in,
 	  const struct net_device *out,
+	  const struct xt_match *match,
 	  const void *matchinfo,
 	  int offset,
 	  unsigned int protoff,
@@ -185,6 +188,7 @@ udp_match(const struct sk_buff *skb,
 static int
 udp_checkentry(const char *tablename,
 	       const void *info,
+	       const struct xt_match *match,
 	       void *matchinfo,
 	       unsigned int matchsize,
 	       unsigned int hook_mask)
