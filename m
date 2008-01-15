From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 20/38]: {ip,ip6}_tables: remove some inlines
Date: Tue, 15 Jan 2008 07:19:39 +0100 (MET)
Message-ID: <20080115061934.3184.38608.sendpatchset@localhost.localdomain>
References: <20080115061907.3184.39432.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62214 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455AbYAOGTk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Jan 2008 01:19:40 -0500
In-Reply-To: <20080115061907.3184.39432.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: {ip,ip6}_tables: remove some inlines

This patch removes inlines except those which are used
by packet matching code and thus are performance-critical.

Before:

$ size */*/*/ip*tables*.o
   text    data     bss     dec     hex filename
   6402     500      16    6918    1b06 net/ipv4/netfilter/ip_tables.o
   7130     500      16    7646    1dde net/ipv6/netfilter/ip6_tables.o

After:

$ size */*/*/ip*tables*.o
   text    data     bss     dec     hex filename
   6307     500      16    6823    1aa7 net/ipv4/netfilter/ip_tables.o
   7010     500      16    7526    1d66 net/ipv6/netfilter/ip6_tables.o

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 672b1bb962284718abf7cc88055ca2bb4378c7bc
tree e7f3315a0d24d50219338934f3538172e404cae0
parent 733218e65d16da88f06073a62c017e6f9864ea1a
author Denys Vlasenko <vda.linux@googlemail.com> Mon, 14 Jan 2008 06:51:46 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 15 Jan 2008 06:53:23 +0100

 net/ipv4/netfilter/ip_tables.c  |   47 ++++++++++++++++++++++-----------------
 net/ipv6/netfilter/ip6_tables.c |   42 +++++++++++++++++++----------------
 2 files changed, 50 insertions(+), 39 deletions(-)

diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index f5b66ec..982b7f9 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -75,6 +75,7 @@ do {								\
    Hence the start of any table is given by get_table() below.  */
 
 /* Returns whether matches rule or not. */
+/* Performance critical - called for every packet */
 static inline bool
 ip_packet_match(const struct iphdr *ip,
 		const char *indev,
@@ -153,7 +154,7 @@ ip_packet_match(const struct iphdr *ip,
 	return true;
 }
 
-static inline bool
+static bool
 ip_checkentry(const struct ipt_ip *ip)
 {
 	if (ip->flags & ~IPT_F_MASK) {
@@ -183,8 +184,9 @@ ipt_error(struct sk_buff *skb,
 	return NF_DROP;
 }
 
-static inline
-bool do_match(struct ipt_entry_match *m,
+/* Performance critical - called for every packet */
+static inline bool
+do_match(struct ipt_entry_match *m,
 	      const struct sk_buff *skb,
 	      const struct net_device *in,
 	      const struct net_device *out,
@@ -199,6 +201,7 @@ bool do_match(struct ipt_entry_match *m,
 		return false;
 }
 
+/* Performance critical */
 static inline struct ipt_entry *
 get_entry(void *base, unsigned int offset)
 {
@@ -206,6 +209,7 @@ get_entry(void *base, unsigned int offset)
 }
 
 /* All zeroes == unconditional rule. */
+/* Mildly perf critical (only if packet tracing is on) */
 static inline int
 unconditional(const struct ipt_ip *ip)
 {
@@ -221,7 +225,7 @@ unconditional(const struct ipt_ip *ip)
 
 #if defined(CONFIG_NETFILTER_XT_TARGET_TRACE) || \
     defined(CONFIG_NETFILTER_XT_TARGET_TRACE_MODULE)
-static const char *hooknames[] = {
+static const char *const hooknames[] = {
 	[NF_INET_PRE_ROUTING]		= "PREROUTING",
 	[NF_INET_LOCAL_IN]		= "INPUT",
 	[NF_INET_FORWARD]		= "FORWARD",
@@ -235,7 +239,7 @@ enum nf_ip_trace_comments {
 	NF_IP_TRACE_COMMENT_POLICY,
 };
 
-static const char *comments[] = {
+static const char *const comments[] = {
 	[NF_IP_TRACE_COMMENT_RULE]	= "rule",
 	[NF_IP_TRACE_COMMENT_RETURN]	= "return",
 	[NF_IP_TRACE_COMMENT_POLICY]	= "policy",
@@ -251,6 +255,7 @@ static struct nf_loginfo trace_loginfo = {
 	},
 };
 
+/* Mildly perf critical (only if packet tracing is on) */
 static inline int
 get_chainname_rulenum(struct ipt_entry *s, struct ipt_entry *e,
 		      char *hookname, char **chainname,
@@ -567,7 +572,7 @@ mark_source_chains(struct xt_table_info *newinfo,
 	return 1;
 }
 
-static inline int
+static int
 cleanup_match(struct ipt_entry_match *m, unsigned int *i)
 {
 	if (i && (*i)-- == 0)
@@ -579,7 +584,7 @@ cleanup_match(struct ipt_entry_match *m, unsigned int *i)
 	return 0;
 }
 
-static inline int
+static int
 check_entry(struct ipt_entry *e, const char *name)
 {
 	struct ipt_entry_target *t;
@@ -600,7 +605,8 @@ check_entry(struct ipt_entry *e, const char *name)
 	return 0;
 }
 
-static inline int check_match(struct ipt_entry_match *m, const char *name,
+static int
+check_match(struct ipt_entry_match *m, const char *name,
 			      const struct ipt_ip *ip,
 			      unsigned int hookmask, unsigned int *i)
 {
@@ -623,7 +629,7 @@ static inline int check_match(struct ipt_entry_match *m, const char *name,
 	return ret;
 }
 
-static inline int
+static int
 find_check_match(struct ipt_entry_match *m,
 		 const char *name,
 		 const struct ipt_ip *ip,
@@ -652,7 +658,7 @@ err:
 	return ret;
 }
 
-static inline int check_target(struct ipt_entry *e, const char *name)
+static int check_target(struct ipt_entry *e, const char *name)
 {
 	struct ipt_entry_target *t;
 	struct xt_target *target;
@@ -673,7 +679,7 @@ static inline int check_target(struct ipt_entry *e, const char *name)
 	return ret;
 }
 
-static inline int
+static int
 find_check_entry(struct ipt_entry *e, const char *name, unsigned int size,
 		 unsigned int *i)
 {
@@ -717,7 +723,7 @@ find_check_entry(struct ipt_entry *e, const char *name, unsigned int size,
 	return ret;
 }
 
-static inline int
+static int
 check_entry_size_and_hooks(struct ipt_entry *e,
 			   struct xt_table_info *newinfo,
 			   unsigned char *base,
@@ -760,7 +766,7 @@ check_entry_size_and_hooks(struct ipt_entry *e,
 	return 0;
 }
 
-static inline int
+static int
 cleanup_entry(struct ipt_entry *e, unsigned int *i)
 {
 	struct ipt_entry_target *t;
@@ -916,7 +922,7 @@ get_counters(const struct xt_table_info *t,
 	}
 }
 
-static inline struct xt_counters * alloc_counters(struct xt_table *table)
+static struct xt_counters * alloc_counters(struct xt_table *table)
 {
 	unsigned int countersize;
 	struct xt_counters *counters;
@@ -1304,7 +1310,7 @@ do_replace(void __user *user, unsigned int len)
 
 /* We're lazy, and add to the first CPU; overflow works its fey magic
  * and everything is OK. */
-static inline int
+static int
 add_counter_to_entry(struct ipt_entry *e,
 		     const struct xt_counters addme[],
 		     unsigned int *i)
@@ -1465,7 +1471,7 @@ out:
 	return ret;
 }
 
-static inline int
+static int
 compat_find_calc_match(struct ipt_entry_match *m,
 		       const char *name,
 		       const struct ipt_ip *ip,
@@ -1489,7 +1495,7 @@ compat_find_calc_match(struct ipt_entry_match *m,
 	return 0;
 }
 
-static inline int
+static int
 compat_release_match(struct ipt_entry_match *m, unsigned int *i)
 {
 	if (i && (*i)-- == 0)
@@ -1499,7 +1505,7 @@ compat_release_match(struct ipt_entry_match *m, unsigned int *i)
 	return 0;
 }
 
-static inline int
+static int
 compat_release_entry(struct compat_ipt_entry *e, unsigned int *i)
 {
 	struct ipt_entry_target *t;
@@ -1514,7 +1520,7 @@ compat_release_entry(struct compat_ipt_entry *e, unsigned int *i)
 	return 0;
 }
 
-static inline int
+static int
 check_compat_entry_size_and_hooks(struct compat_ipt_entry *e,
 				  struct xt_table_info *newinfo,
 				  unsigned int *size,
@@ -1637,7 +1643,8 @@ compat_copy_entry_from_user(struct compat_ipt_entry *e, void **dstptr,
 	return ret;
 }
 
-static inline int compat_check_entry(struct ipt_entry *e, const char *name,
+static int
+compat_check_entry(struct ipt_entry *e, const char *name,
 				     unsigned int *i)
 {
 	int j, ret;
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 4ed16d2..dd7860f 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -90,6 +90,7 @@ ip6t_ext_hdr(u8 nexthdr)
 }
 
 /* Returns whether matches rule or not. */
+/* Performance critical - called for every packet */
 static inline bool
 ip6_packet_match(const struct sk_buff *skb,
 		 const char *indev,
@@ -182,7 +183,7 @@ ip6_packet_match(const struct sk_buff *skb,
 }
 
 /* should be ip6 safe */
-static inline bool
+static bool
 ip6_checkentry(const struct ip6t_ip6 *ipv6)
 {
 	if (ipv6->flags & ~IP6T_F_MASK) {
@@ -212,8 +213,9 @@ ip6t_error(struct sk_buff *skb,
 	return NF_DROP;
 }
 
-static inline
-bool do_match(struct ip6t_entry_match *m,
+/* Performance critical - called for every packet */
+static inline bool
+do_match(struct ip6t_entry_match *m,
 	      const struct sk_buff *skb,
 	      const struct net_device *in,
 	      const struct net_device *out,
@@ -236,6 +238,7 @@ get_entry(void *base, unsigned int offset)
 }
 
 /* All zeroes == unconditional rule. */
+/* Mildly perf critical (only if packet tracing is on) */
 static inline int
 unconditional(const struct ip6t_ip6 *ipv6)
 {
@@ -251,7 +254,7 @@ unconditional(const struct ip6t_ip6 *ipv6)
 #if defined(CONFIG_NETFILTER_XT_TARGET_TRACE) || \
     defined(CONFIG_NETFILTER_XT_TARGET_TRACE_MODULE)
 /* This cries for unification! */
-static const char *hooknames[] = {
+static const char *const hooknames[] = {
 	[NF_INET_PRE_ROUTING]		= "PREROUTING",
 	[NF_INET_LOCAL_IN]		= "INPUT",
 	[NF_INET_FORWARD]		= "FORWARD",
@@ -265,7 +268,7 @@ enum nf_ip_trace_comments {
 	NF_IP6_TRACE_COMMENT_POLICY,
 };
 
-static const char *comments[] = {
+static const char *const comments[] = {
 	[NF_IP6_TRACE_COMMENT_RULE]	= "rule",
 	[NF_IP6_TRACE_COMMENT_RETURN]	= "return",
 	[NF_IP6_TRACE_COMMENT_POLICY]	= "policy",
@@ -281,6 +284,7 @@ static struct nf_loginfo trace_loginfo = {
 	},
 };
 
+/* Mildly perf critical (only if packet tracing is on) */
 static inline int
 get_chainname_rulenum(struct ip6t_entry *s, struct ip6t_entry *e,
 		      char *hookname, char **chainname,
@@ -595,7 +599,7 @@ mark_source_chains(struct xt_table_info *newinfo,
 	return 1;
 }
 
-static inline int
+static int
 cleanup_match(struct ip6t_entry_match *m, unsigned int *i)
 {
 	if (i && (*i)-- == 0)
@@ -607,7 +611,7 @@ cleanup_match(struct ip6t_entry_match *m, unsigned int *i)
 	return 0;
 }
 
-static inline int
+static int
 check_entry(struct ip6t_entry *e, const char *name)
 {
 	struct ip6t_entry_target *t;
@@ -628,7 +632,7 @@ check_entry(struct ip6t_entry *e, const char *name)
 	return 0;
 }
 
-static inline int check_match(struct ip6t_entry_match *m, const char *name,
+static int check_match(struct ip6t_entry_match *m, const char *name,
 			      const struct ip6t_ip6 *ipv6,
 			      unsigned int hookmask, unsigned int *i)
 {
@@ -651,7 +655,7 @@ static inline int check_match(struct ip6t_entry_match *m, const char *name,
 	return ret;
 }
 
-static inline int
+static int
 find_check_match(struct ip6t_entry_match *m,
 		 const char *name,
 		 const struct ip6t_ip6 *ipv6,
@@ -680,7 +684,7 @@ err:
 	return ret;
 }
 
-static inline int check_target(struct ip6t_entry *e, const char *name)
+static int check_target(struct ip6t_entry *e, const char *name)
 {
 	struct ip6t_entry_target *t;
 	struct xt_target *target;
@@ -701,7 +705,7 @@ static inline int check_target(struct ip6t_entry *e, const char *name)
 	return ret;
 }
 
-static inline int
+static int
 find_check_entry(struct ip6t_entry *e, const char *name, unsigned int size,
 		 unsigned int *i)
 {
@@ -745,7 +749,7 @@ find_check_entry(struct ip6t_entry *e, const char *name, unsigned int size,
 	return ret;
 }
 
-static inline int
+static int
 check_entry_size_and_hooks(struct ip6t_entry *e,
 			   struct xt_table_info *newinfo,
 			   unsigned char *base,
@@ -788,7 +792,7 @@ check_entry_size_and_hooks(struct ip6t_entry *e,
 	return 0;
 }
 
-static inline int
+static int
 cleanup_entry(struct ip6t_entry *e, unsigned int *i)
 {
 	struct ip6t_entry_target *t;
@@ -944,7 +948,7 @@ get_counters(const struct xt_table_info *t,
 	}
 }
 
-static inline struct xt_counters *alloc_counters(struct xt_table *table)
+static struct xt_counters *alloc_counters(struct xt_table *table)
 {
 	unsigned int countersize;
 	struct xt_counters *counters;
@@ -1494,7 +1498,7 @@ out:
 	return ret;
 }
 
-static inline int
+static int
 compat_find_calc_match(struct ip6t_entry_match *m,
 		       const char *name,
 		       const struct ip6t_ip6 *ipv6,
@@ -1518,7 +1522,7 @@ compat_find_calc_match(struct ip6t_entry_match *m,
 	return 0;
 }
 
-static inline int
+static int
 compat_release_match(struct ip6t_entry_match *m, unsigned int *i)
 {
 	if (i && (*i)-- == 0)
@@ -1528,7 +1532,7 @@ compat_release_match(struct ip6t_entry_match *m, unsigned int *i)
 	return 0;
 }
 
-static inline int
+static int
 compat_release_entry(struct compat_ip6t_entry *e, unsigned int *i)
 {
 	struct ip6t_entry_target *t;
@@ -1543,7 +1547,7 @@ compat_release_entry(struct compat_ip6t_entry *e, unsigned int *i)
 	return 0;
 }
 
-static inline int
+static int
 check_compat_entry_size_and_hooks(struct compat_ip6t_entry *e,
 				  struct xt_table_info *newinfo,
 				  unsigned int *size,
@@ -1666,7 +1670,7 @@ compat_copy_entry_from_user(struct compat_ip6t_entry *e, void **dstptr,
 	return ret;
 }
 
-static inline int compat_check_entry(struct ip6t_entry *e, const char *name,
+static int compat_check_entry(struct ip6t_entry *e, const char *name,
 				     unsigned int *i)
 {
 	int j, ret;
