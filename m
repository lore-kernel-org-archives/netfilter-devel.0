From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 9/12]: fixed warning on compilation
Date: Thu, 30 Nov 2006 18:51:46 +0900 (JST)
Message-ID: <200611300951.kAU9pmTA007921@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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


changed the type of arguments as follows
- ip[6]t_ip[6] * -> void *
- ip[6]t_entry * -> void *

This patch doesn't change multiport, DNAT, SNAT, MASQUERADE, REDIRECT
because these need more changes (casting void * variable with intended type)
---
 extensions/libip6t_CONNMARK.c     |    6 +++---
 extensions/libip6t_CONNSECMARK.c  |    6 +++---
 extensions/libip6t_HL.c           |    6 +++---
 extensions/libip6t_LOG.c          |    6 +++---
 extensions/libip6t_MARK.c         |    6 +++---
 extensions/libip6t_NFQUEUE.c      |    6 +++---
 extensions/libip6t_REJECT.c       |    6 +++---
 extensions/libip6t_ROUTE.c        |    6 +++---
 extensions/libip6t_SECMARK.c      |    6 +++---
 extensions/libip6t_TRACE.c        |    2 +-
 extensions/libip6t_ah.c           |    6 +++---
 extensions/libip6t_condition.c    |    6 +++---
 extensions/libip6t_connmark.c     |    6 +++---
 extensions/libip6t_dst.c          |    6 +++---
 extensions/libip6t_esp.c          |    6 +++---
 extensions/libip6t_eui64.c        |    6 +++---
 extensions/libip6t_frag.c         |    6 +++---
 extensions/libip6t_fuzzy.c        |    6 +++---
 extensions/libip6t_hbh.c          |    6 +++---
 extensions/libip6t_hl.c           |    6 +++---
 extensions/libip6t_icmp6.c        |    6 +++---
 extensions/libip6t_ipv6header.c   |    6 +++---
 extensions/libip6t_length.c       |    6 +++---
 extensions/libip6t_limit.c        |    6 +++---
 extensions/libip6t_mac.c          |    6 +++---
 extensions/libip6t_mark.c         |    6 +++---
 extensions/libip6t_nth.c          |    6 +++---
 extensions/libip6t_owner.c        |    6 +++---
 extensions/libip6t_physdev.c      |    6 +++---
 extensions/libip6t_policy.c       |    6 +++---
 extensions/libip6t_random.c       |    6 +++---
 extensions/libip6t_rt.c           |    6 +++---
 extensions/libip6t_standard.c     |    4 ++--
 extensions/libip6t_state.c        |    6 +++---
 extensions/libip6t_tcp.c          |    6 +++---
 extensions/libip6t_udp.c          |    6 +++---
 extensions/libipt_BALANCE.c       |    6 +++---
 extensions/libipt_CLASSIFY.c      |    6 +++---
 extensions/libipt_CLUSTERIP.c     |    6 +++---
 extensions/libipt_CONNMARK.c      |    6 +++---
 extensions/libipt_CONNSECMARK.c   |    6 +++---
 extensions/libipt_DSCP.c          |    6 +++---
 extensions/libipt_ECN.c           |    6 +++---
 extensions/libipt_FTOS.c          |    6 +++---
 extensions/libipt_IPMARK.c        |    6 +++---
 extensions/libipt_IPV4OPTSSTRIP.c |    6 +++---
 extensions/libipt_LOG.c           |    6 +++---
 extensions/libipt_MARK.c          |   12 ++++++------
 extensions/libipt_MIRROR.c        |    2 +-
 extensions/libipt_NETLINK.c       |    6 +++---
 extensions/libipt_NETMAP.c        |    6 +++---
 extensions/libipt_NFQUEUE.c       |    6 +++---
 extensions/libipt_NOTRACK.c       |    2 +-
 extensions/libipt_REJECT.c        |    6 +++---
 extensions/libipt_ROUTE.c         |    6 +++---
 extensions/libipt_SAME.c          |    6 +++---
 extensions/libipt_SECMARK.c       |    6 +++---
 extensions/libipt_SET.c           |    6 +++---
 extensions/libipt_TARPIT.c        |    6 +++---
 extensions/libipt_TCPLAG.c        |    6 +++---
 extensions/libipt_TCPMSS.c        |    6 +++---
 extensions/libipt_TOS.c           |    6 +++---
 extensions/libipt_TRACE.c         |    2 +-
 extensions/libipt_TTL.c           |    6 +++---
 extensions/libipt_ULOG.c          |    6 +++---
 extensions/libipt_XOR.c           |    6 +++---
 extensions/libipt_account.c       |    6 +++---
 extensions/libipt_addrtype.c      |    6 +++---
 extensions/libipt_ah.c            |    6 +++---
 extensions/libipt_childlevel.c    |    6 +++---
 extensions/libipt_comment.c       |    6 +++---
 extensions/libipt_condition.c     |    6 +++---
 extensions/libipt_connbytes.c     |    6 +++---
 extensions/libipt_connlimit.c     |    6 +++---
 extensions/libipt_connmark.c      |    6 +++---
 extensions/libipt_connrate.c      |    6 +++---
 extensions/libipt_conntrack.c     |    8 ++++----
 extensions/libipt_dccp.c          |    6 +++---
 extensions/libipt_dscp.c          |    6 +++---
 extensions/libipt_dstlimit.c      |    6 +++---
 extensions/libipt_ecn.c           |    6 +++---
 extensions/libipt_esp.c           |    6 +++---
 extensions/libipt_fuzzy.c         |    6 +++---
 extensions/libipt_hashlimit.c     |    6 +++---
 extensions/libipt_helper.c        |    6 +++---
 extensions/libipt_icmp.c          |    6 +++---
 extensions/libipt_iprange.c       |    6 +++---
 extensions/libipt_ipv4options.c   |    6 +++---
 extensions/libipt_length.c        |    6 +++---
 extensions/libipt_limit.c         |    6 +++---
 extensions/libipt_mac.c           |    6 +++---
 extensions/libipt_mark.c          |    6 +++---
 extensions/libipt_mport.c         |    8 ++++----
 extensions/libipt_nth.c           |    6 +++---
 extensions/libipt_osf.c           |    6 +++---
 extensions/libipt_owner.c         |    6 +++---
 extensions/libipt_physdev.c       |    6 +++---
 extensions/libipt_pkttype.c       |    6 +++---
 extensions/libipt_policy.c        |    6 +++---
 extensions/libipt_psd.c           |    6 +++---
 extensions/libipt_quota.c         |    6 +++---
 extensions/libipt_random.c        |    6 +++---
 extensions/libipt_realm.c         |    6 +++---
 extensions/libipt_recent.c        |    6 +++---
 extensions/libipt_record_rpc.c    |    6 +++---
 extensions/libipt_rpc.c           |    6 +++---
 extensions/libipt_sctp.c          |    6 +++---
 extensions/libipt_set.c           |    6 +++---
 extensions/libipt_standard.c      |    4 ++--
 extensions/libipt_state.c         |    6 +++---
 extensions/libipt_statistic.c     |    6 +++---
 extensions/libipt_string.c        |    6 +++---
 extensions/libipt_tcp.c           |    6 +++---
 extensions/libipt_tcpmss.c        |    6 +++---
 extensions/libipt_time.c          |    6 +++---
 extensions/libipt_tos.c           |    6 +++---
 extensions/libipt_ttl.c           |    6 +++---
 extensions/libipt_u32.c           |    6 +++---
 extensions/libipt_udp.c           |    6 +++---
 extensions/libipt_unclean.c       |    2 +-
 120 files changed, 353 insertions(+), 353 deletions(-)

diff --git a/extensions/libip6t_CONNMARK.c b/extensions/libip6t_CONNMARK.c
index 86b8e0f..69d3a5a 100644
--- a/extensions/libip6t_CONNMARK.c
+++ b/extensions/libip6t_CONNMARK.c
@@ -66,7 +66,7 @@ init(struct xt_entry_target *t, unsigned
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ip6t_entry *entry,
+      const void *entry,
       struct xt_entry_target **target)
 {
 	struct ipt_connmark_target_info *markinfo
@@ -144,7 +144,7 @@ print_mask(const char *text, unsigned lo
 
 /* Prints out the target info. */
 static void
-print(const struct ip6t_ip6 *ip,
+print(const void *ip,
       const struct xt_entry_target *target,
       int numeric)
 {
@@ -174,7 +174,7 @@ print(const struct ip6t_ip6 *ip,
 
 /* Saves the target into in parsable form to stdout. */
 static void
-save(const struct ip6t_ip6 *ip, const struct xt_entry_target *target)
+save(const void *ip, const struct xt_entry_target *target)
 {
 	const struct ipt_connmark_target_info *markinfo =
 		(const struct ipt_connmark_target_info *)target->data;
diff --git a/extensions/libip6t_CONNSECMARK.c b/extensions/libip6t_CONNSECMARK.c
index dc6a02f..805492c 100644
--- a/extensions/libip6t_CONNSECMARK.c
+++ b/extensions/libip6t_CONNSECMARK.c
@@ -31,7 +31,7 @@ static struct option opts[] = {
 };
 
 static int parse(int c, char **argv, int invert, unsigned int *flags,
-                 const struct ip6t_entry *entry, struct xt_entry_target **target)
+                 const void *entry, struct xt_entry_target **target)
 {
 	struct xt_connsecmark_target_info *info =
 		(struct xt_connsecmark_target_info*)(*target)->data;
@@ -86,7 +86,7 @@ static void print_connsecmark(struct xt_
 	}
 }
 
-static void print(const struct ip6t_ip6 *ip,
+static void print(const void *ip,
 		  const struct xt_entry_target *target, int numeric)
 {
 	struct xt_connsecmark_target_info *info =
@@ -96,7 +96,7 @@ static void print(const struct ip6t_ip6
 	print_connsecmark(info);
 }
 
-static void save(const struct ip6t_ip6 *ip, const struct xt_entry_target *target)
+static void save(const void *ip, const struct xt_entry_target *target)
 {
 	struct xt_connsecmark_target_info *info =
 		(struct xt_connsecmark_target_info*)target->data;
diff --git a/extensions/libip6t_HL.c b/extensions/libip6t_HL.c
index 46da9ad..7930ee7 100644
--- a/extensions/libip6t_HL.c
+++ b/extensions/libip6t_HL.c
@@ -31,7 +31,7 @@ static void help(void)
 }
 
 static int parse(int c, char **argv, int invert, unsigned int *flags,
-		const struct ip6t_entry *entry,
+		const void *entry,
 		struct xt_entry_target **target)
 {
 	struct ip6t_HL_info *info = (struct ip6t_HL_info *) (*target)->data;
@@ -96,7 +96,7 @@ static void final_check(unsigned int fla
 				"HL: You must specify an action");
 }
 
-static void save(const struct ip6t_ip6 *ip,
+static void save(const void *ip,
 		const struct xt_entry_target *target)
 {
 	const struct ip6t_HL_info *info = 
@@ -117,7 +117,7 @@ static void save(const struct ip6t_ip6 *
 	printf("%u ", info->hop_limit);
 }
 
-static void print(const struct ip6t_ip6 *ip,
+static void print(const void *ip,
 		const struct xt_entry_target *target, int numeric)
 {
 	const struct ip6t_HL_info *info =
diff --git a/extensions/libip6t_LOG.c b/extensions/libip6t_LOG.c
index ad65bd5..7fdbc0c 100644
--- a/extensions/libip6t_LOG.c
+++ b/extensions/libip6t_LOG.c
@@ -110,7 +110,7 @@ parse_level(const char *level)
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ip6t_entry *entry,
+      const void *entry,
       struct xt_entry_target **target)
 {
 	struct ip6t_log_info *loginfo = (struct ip6t_log_info *)(*target)->data;
@@ -206,7 +206,7 @@ static void final_check(unsigned int fla
 
 /* Prints out the targinfo. */
 static void
-print(const struct ip6t_ip6 *ip,
+print(const void *ip,
       const struct xt_entry_target *target,
       int numeric)
 {
@@ -247,7 +247,7 @@ print(const struct ip6t_ip6 *ip,
 
 /* Saves the union ip6t_targinfo in parsable form to stdout. */
 static void
-save(const struct ip6t_ip6 *ip, const struct xt_entry_target *target)
+save(const void *ip, const struct xt_entry_target *target)
 {
 	const struct ip6t_log_info *loginfo
 		= (const struct ip6t_log_info *)target->data;
diff --git a/extensions/libip6t_MARK.c b/extensions/libip6t_MARK.c
index 8f19e15..6380200 100644
--- a/extensions/libip6t_MARK.c
+++ b/extensions/libip6t_MARK.c
@@ -35,7 +35,7 @@ init(struct xt_entry_target *t, unsigned
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ip6t_entry *entry,
+      const void *entry,
       struct xt_entry_target **target)
 {
 	struct ip6t_mark_target_info *markinfo
@@ -88,7 +88,7 @@ print_mark(unsigned long mark)
 
 /* Prints out the targinfo. */
 static void
-print(const struct ip6t_ip6 *ip,
+print(const void *ip,
       const struct xt_entry_target *target,
       int numeric)
 {
@@ -101,7 +101,7 @@ print(const struct ip6t_ip6 *ip,
 
 /* Saves the union ipt_targinfo in parsable form to stdout. */
 static void
-save(const struct ip6t_ip6 *ip, const struct xt_entry_target *target)
+save(const void *ip, const struct xt_entry_target *target)
 {
 	const struct ip6t_mark_target_info *markinfo =
 		(const struct ip6t_mark_target_info *)target->data;
diff --git a/extensions/libip6t_NFQUEUE.c b/extensions/libip6t_NFQUEUE.c
index 4afd8dd..00ea19d 100644
--- a/extensions/libip6t_NFQUEUE.c
+++ b/extensions/libip6t_NFQUEUE.c
@@ -47,7 +47,7 @@ parse_num(const char *s, struct ipt_NFQ_
 
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ip6t_entry *entry,
+      const void *entry,
       struct xt_entry_target **target)
 {
 	struct ipt_NFQ_info *tinfo
@@ -74,7 +74,7 @@ final_check(unsigned int flags)
 
 /* Prints out the targinfo. */
 static void
-print(const struct ip6t_ip6 *ip,
+print(const void *ip,
       const struct xt_entry_target *target,
       int numeric)
 {
@@ -85,7 +85,7 @@ print(const struct ip6t_ip6 *ip,
 
 /* Saves the union ip6t_targinfo in parsable form to stdout. */
 static void
-save(const struct ip6t_ip6 *ip, const struct xt_entry_target *target)
+save(const void *ip, const struct xt_entry_target *target)
 {
 	const struct ipt_NFQ_info *tinfo =
 		(const struct ipt_NFQ_info *)target->data;
diff --git a/extensions/libip6t_REJECT.c b/extensions/libip6t_REJECT.c
index 5b3c7bf..304e8e1 100644
--- a/extensions/libip6t_REJECT.c
+++ b/extensions/libip6t_REJECT.c
@@ -85,7 +85,7 @@ init(struct xt_entry_target *t, unsigned
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ip6t_entry *entry,
+      const void *entry,
       struct xt_entry_target **target)
 {
 	struct ip6t_reject_info *reject = 
@@ -120,7 +120,7 @@ static void final_check(unsigned int fla
 
 /* Prints out ipt_reject_info. */
 static void
-print(const struct ip6t_ip6 *ip,
+print(const void *ip,
       const struct xt_entry_target *target,
       int numeric)
 {
@@ -136,7 +136,7 @@ print(const struct ip6t_ip6 *ip,
 }
 
 /* Saves ipt_reject in parsable form to stdout. */
-static void save(const struct ip6t_ip6 *ip, 
+static void save(const void *ip, 
 		 const struct xt_entry_target *target)
 {
 	const struct ip6t_reject_info *reject
diff --git a/extensions/libip6t_ROUTE.c b/extensions/libip6t_ROUTE.c
index a6de2cf..a72f538 100644
--- a/extensions/libip6t_ROUTE.c
+++ b/extensions/libip6t_ROUTE.c
@@ -73,7 +73,7 @@ init(struct xt_entry_target *t, unsigned
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ip6t_entry *entry,
+      const void *entry,
       struct xt_entry_target **target)
 {
 	struct ip6t_route_target_info *route_info = 
@@ -166,7 +166,7 @@ final_check(unsigned int flags)
 
 /* Prints out the targinfo. */
 static void
-print(const struct ip6t_ip6 *ip,
+print(const void *ip,
       const struct xt_entry_target *target,
       int numeric)
 {
@@ -195,7 +195,7 @@ print(const struct ip6t_ip6 *ip,
 }
 
 
-static void save(const struct ip6t_ip6 *ip, 
+static void save(const void *ip, 
 		 const struct xt_entry_target *target)
 {
 	const struct ip6t_route_target_info *route_info
diff --git a/extensions/libip6t_SECMARK.c b/extensions/libip6t_SECMARK.c
index 88fbf59..16961a3 100644
--- a/extensions/libip6t_SECMARK.c
+++ b/extensions/libip6t_SECMARK.c
@@ -39,7 +39,7 @@ static void init(struct xt_entry_target
  * ate an option.
  */
 static int parse(int c, char **argv, int invert, unsigned int *flags,
-                 const struct ip6t_entry *entry, struct xt_entry_target **target)
+                 const void *entry, struct xt_entry_target **target)
 {
 	struct xt_secmark_target_info *info =
 		(struct xt_secmark_target_info*)(*target)->data;
@@ -85,7 +85,7 @@ static void print_secmark(struct xt_secm
 	}
 }
 
-static void print(const struct ip6t_ip6 *ip,
+static void print(const void *ip,
 		  const struct xt_entry_target *target, int numeric)
 {
 	struct xt_secmark_target_info *info =
@@ -96,7 +96,7 @@ static void print(const struct ip6t_ip6
 }
 
 /* Saves the target info in parsable form to stdout. */
-static void save(const struct ip6t_ip6 *ip, const struct xt_entry_target *target)
+static void save(const void *ip, const struct xt_entry_target *target)
 {
 	struct xt_secmark_target_info *info =
 		(struct xt_secmark_target_info*)target->data;
diff --git a/extensions/libip6t_TRACE.c b/extensions/libip6t_TRACE.c
index ccaf992..2330240 100644
--- a/extensions/libip6t_TRACE.c
+++ b/extensions/libip6t_TRACE.c
@@ -30,7 +30,7 @@ init(struct xt_entry_target *t, unsigned
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ip6t_entry *entry,
+      const void *entry,
       struct xt_entry_target **target)
 {
 	return 0;
diff --git a/extensions/libip6t_ah.c b/extensions/libip6t_ah.c
index 5f1013d..2379f21 100644
--- a/extensions/libip6t_ah.c
+++ b/extensions/libip6t_ah.c
@@ -85,7 +85,7 @@ init(struct xt_entry_match *m, unsigned
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ip6t_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
@@ -157,7 +157,7 @@ print_len(const char *name, u_int32_t le
 
 /* Prints out the union ip6t_matchinfo. */
 static void
-print(const struct ip6t_ip6 *ip,
+print(const void *ip,
       const struct xt_entry_match *match, int numeric)
 {
 	const struct ip6t_ah *ah = (struct ip6t_ah *)match->data;
@@ -177,7 +177,7 @@ print(const struct ip6t_ip6 *ip,
 }
 
 /* Saves the union ip6t_matchinfo in parsable form to stdout. */
-static void save(const struct ip6t_ip6 *ip, const struct xt_entry_match *match)
+static void save(const void *ip, const struct xt_entry_match *match)
 {
 	const struct ip6t_ah *ahinfo = (struct ip6t_ah *)match->data;
 
diff --git a/extensions/libip6t_condition.c b/extensions/libip6t_condition.c
index 8cb4ec0..633eef1 100644
--- a/extensions/libip6t_condition.c
+++ b/extensions/libip6t_condition.c
@@ -26,7 +26,7 @@ static struct option opts[] = {
 
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ip6t_entry *entry, unsigned int *nfcache,
+      const void *entry, unsigned int *nfcache,
       struct xt_entry_match **match)
 {
 	struct condition6_info *info =
@@ -64,7 +64,7 @@ final_check(unsigned int flags)
 
 
 static void
-print(const struct ip6t_ip6 *ip,
+print(const void *ip,
 		  const struct xt_entry_match *match, int numeric)
 {
 	const struct condition6_info *info =
@@ -75,7 +75,7 @@ print(const struct ip6t_ip6 *ip,
 
 
 static void
-save(const struct ip6t_ip6 *ip,
+save(const void *ip,
 		 const struct xt_entry_match *match)
 {
 	const struct condition6_info *info =
diff --git a/extensions/libip6t_connmark.c b/extensions/libip6t_connmark.c
index 9900af4..0a67c3a 100644
--- a/extensions/libip6t_connmark.c
+++ b/extensions/libip6t_connmark.c
@@ -56,7 +56,7 @@ init(struct xt_entry_match *m, unsigned
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ip6t_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
@@ -106,7 +106,7 @@ final_check(unsigned int flags)
 
 /* Prints out the matchinfo. */
 static void
-print(const struct ip6t_ip6 *ip,
+print(const void *ip,
       const struct xt_entry_match *match,
       int numeric)
 {
@@ -120,7 +120,7 @@ print(const struct ip6t_ip6 *ip,
 
 /* Saves the matchinfo in parsable form to stdout. */
 static void
-save(const struct ip6t_ip6 *ip, const struct xt_entry_match *match)
+save(const void *ip, const struct xt_entry_match *match)
 {
 	struct ipt_connmark_info *info = (struct ipt_connmark_info *)match->data;
 
diff --git a/extensions/libip6t_dst.c b/extensions/libip6t_dst.c
index 4b0cd3e..8c9455b 100644
--- a/extensions/libip6t_dst.c
+++ b/extensions/libip6t_dst.c
@@ -132,7 +132,7 @@ init(struct xt_entry_match *m, unsigned
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ip6t_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
@@ -203,7 +203,7 @@ print_options(int optsnr, u_int16_t *opt
 
 /* Prints out the union ip6t_matchinfo. */
 static void
-print(const struct ip6t_ip6 *ip,
+print(const void *ip,
       const struct xt_entry_match *match, int numeric)
 {
 	const struct ip6t_opts *optinfo = (struct ip6t_opts *)match->data;
@@ -228,7 +228,7 @@ print(const struct ip6t_ip6 *ip,
 }
 
 /* Saves the union ip6t_matchinfo in parsable form to stdout. */
-static void save(const struct ip6t_ip6 *ip, const struct xt_entry_match *match)
+static void save(const void *ip, const struct xt_entry_match *match)
 {
 	const struct ip6t_opts *optinfo = (struct ip6t_opts *)match->data;
 
diff --git a/extensions/libip6t_esp.c b/extensions/libip6t_esp.c
index 9b031b7..04cc546 100644
--- a/extensions/libip6t_esp.c
+++ b/extensions/libip6t_esp.c
@@ -83,7 +83,7 @@ init(struct xt_entry_match *m, unsigned
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ip6t_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
@@ -129,7 +129,7 @@ print_spis(const char *name, u_int32_t m
 
 /* Prints out the union ip6t_matchinfo. */
 static void
-print(const struct ip6t_ip6 *ip,
+print(const void *ip,
       const struct xt_entry_match *match, int numeric)
 {
 	const struct ip6t_esp *esp = (struct ip6t_esp *)match->data;
@@ -143,7 +143,7 @@ print(const struct ip6t_ip6 *ip,
 }
 
 /* Saves the union ip6t_matchinfo in parsable form to stdout. */
-static void save(const struct ip6t_ip6 *ip, const struct xt_entry_match *match)
+static void save(const void *ip, const struct xt_entry_match *match)
 {
 	const struct ip6t_esp *espinfo = (struct ip6t_esp *)match->data;
 
diff --git a/extensions/libip6t_eui64.c b/extensions/libip6t_eui64.c
index 494f17a..0d22df7 100644
--- a/extensions/libip6t_eui64.c
+++ b/extensions/libip6t_eui64.c
@@ -30,7 +30,7 @@ static struct option opts[] = {
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ip6t_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
@@ -44,7 +44,7 @@ static void final_check(unsigned int fla
 
 /* Prints out the matchinfo. */
 static void
-print(const struct ip6t_ip6 *ip,
+print(const void *ip,
       const struct xt_entry_match *match,
       int numeric)
 {
@@ -52,7 +52,7 @@ print(const struct ip6t_ip6 *ip,
 }
 
 /* Saves the union ip6t_matchinfo in parsable form to stdout. */
-static void save(const struct ip6t_ip6 *ip, const struct xt_entry_match *match)
+static void save(const void *ip, const struct xt_entry_match *match)
 {
 
 }
diff --git a/extensions/libip6t_frag.c b/extensions/libip6t_frag.c
index 44661e9..fcdee1b 100644
--- a/extensions/libip6t_frag.c
+++ b/extensions/libip6t_frag.c
@@ -93,7 +93,7 @@ init(struct xt_entry_match *m, unsigned
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ip6t_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
@@ -180,7 +180,7 @@ print_ids(const char *name, u_int32_t mi
 
 /* Prints out the union ip6t_matchinfo. */
 static void
-print(const struct ip6t_ip6 *ip,
+print(const void *ip,
       const struct xt_entry_match *match, int numeric)
 {
 	const struct ip6t_frag *frag = (struct ip6t_frag *)match->data;
@@ -213,7 +213,7 @@ print(const struct ip6t_ip6 *ip,
 }
 
 /* Saves the union ip6t_matchinfo in parsable form to stdout. */
-static void save(const struct ip6t_ip6 *ip, const struct xt_entry_match *match)
+static void save(const void *ip, const struct xt_entry_match *match)
 {
 	const struct ip6t_frag *fraginfo = (struct ip6t_frag *)match->data;
 
diff --git a/extensions/libip6t_fuzzy.c b/extensions/libip6t_fuzzy.c
index ea7817e..2680603 100644
--- a/extensions/libip6t_fuzzy.c
+++ b/extensions/libip6t_fuzzy.c
@@ -58,7 +58,7 @@ init(struct xt_entry_match *m, unsigned
 
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ip6t_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
@@ -114,7 +114,7 @@ static void final_check(unsigned int fla
 }
 
 static void
-print(const struct ip6t_ip6 *ipv6,
+print(const void *ipv6,
       const struct xt_entry_match *match,
       int numeric)
 {
@@ -127,7 +127,7 @@ print(const struct ip6t_ip6 *ipv6,
 
 /* Saves the union ip6t_targinfo in parsable form to stdout. */
 static void
-save(const struct ip6t_ip6 *ipv6, const struct xt_entry_match *match)
+save(const void *ipv6, const struct xt_entry_match *match)
 {
 	const struct ip6t_fuzzy_info *fuzzyinfo
 		= (const struct ip6t_fuzzy_info *)match->data;
diff --git a/extensions/libip6t_hbh.c b/extensions/libip6t_hbh.c
index 24a0485..4312399 100644
--- a/extensions/libip6t_hbh.c
+++ b/extensions/libip6t_hbh.c
@@ -131,7 +131,7 @@ init(struct xt_entry_match *m, unsigned
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ip6t_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
@@ -200,7 +200,7 @@ print_options(int optsnr, u_int16_t *opt
 
 /* Prints out the union ip6t_matchinfo. */
 static void
-print(const struct ip6t_ip6 *ip,
+print(const void *ip,
       const struct xt_entry_match *match, int numeric)
 {
 	const struct ip6t_opts *optinfo = (struct ip6t_opts *)match->data;
@@ -221,7 +221,7 @@ print(const struct ip6t_ip6 *ip,
 }
 
 /* Saves the union ip6t_matchinfo in parsable form to stdout. */
-static void save(const struct ip6t_ip6 *ip, const struct xt_entry_match *match)
+static void save(const void *ip, const struct xt_entry_match *match)
 {
 	const struct ip6t_opts *optinfo = (struct ip6t_opts *)match->data;
 
diff --git a/extensions/libip6t_hl.c b/extensions/libip6t_hl.c
index 4a4d3c5..44e0805 100644
--- a/extensions/libip6t_hl.c
+++ b/extensions/libip6t_hl.c
@@ -26,7 +26,7 @@ static void help(void)
 }
 
 static int parse(int c, char **argv, int invert, unsigned int *flags,
-		const struct ip6t_entry *entry, unsigned int *nfcache,
+		const void *entry, unsigned int *nfcache,
 		struct xt_entry_match **match)
 {
 	struct ip6t_hl_info *info = (struct ip6t_hl_info *) (*match)->data;
@@ -89,7 +89,7 @@ static void final_check(unsigned int fla
 			"`--hl-eq', `--hl-lt', `--hl-gt'");
 }
 
-static void print(const struct ip6t_ip6 *ip, 
+static void print(const void *ip, 
 		const struct xt_entry_match *match,
 		int numeric)
 {
@@ -105,7 +105,7 @@ static void print(const struct ip6t_ip6
 	printf("HL match HL %s %u ", op[info->mode], info->hop_limit);
 }
 
-static void save(const struct ip6t_ip6 *ip, 
+static void save(const void *ip, 
 		const struct xt_entry_match *match)
 {
 	static const char *op[] = {
diff --git a/extensions/libip6t_icmp6.c b/extensions/libip6t_icmp6.c
index ac7e799..bc150c2 100644
--- a/extensions/libip6t_icmp6.c
+++ b/extensions/libip6t_icmp6.c
@@ -156,7 +156,7 @@ init(struct xt_entry_match *m, unsigned
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ip6t_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
@@ -221,7 +221,7 @@ static void print_icmpv6type(u_int8_t ty
 
 /* Prints out the union ipt_matchinfo. */
 static void
-print(const struct ip6t_ip6 *ip,
+print(const void *ip,
       const struct xt_entry_match *match,
       int numeric)
 {
@@ -238,7 +238,7 @@ print(const struct ip6t_ip6 *ip,
 }
 
 /* Saves the match in parsable form to stdout. */
-static void save(const struct ip6t_ip6 *ip, const struct xt_entry_match *match)
+static void save(const void *ip, const struct xt_entry_match *match)
 {
 	const struct ip6t_icmp *icmpv6 = (struct ip6t_icmp *)match->data;
 
diff --git a/extensions/libip6t_ipv6header.c b/extensions/libip6t_ipv6header.c
index d0bc93d..858e029 100644
--- a/extensions/libip6t_ipv6header.c
+++ b/extensions/libip6t_ipv6header.c
@@ -185,7 +185,7 @@ parse_header(const char *flags) {
 /* Parses command options; returns 0 if it ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ip6t_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
@@ -254,7 +254,7 @@ print_header(u_int8_t flags){
 
 /* Prints out the match */
 static void
-print(const struct ip6t_ip6 *ip,
+print(const void *ip,
       const struct xt_entry_match *match,
       int numeric)
 {
@@ -279,7 +279,7 @@ print(const struct ip6t_ip6 *ip,
 
 /* Saves the match */
 static void
-save(const struct ip6t_ip6 *ip,
+save(const void *ip,
      const struct xt_entry_match *match)
 {
 
diff --git a/extensions/libip6t_length.c b/extensions/libip6t_length.c
index 4c77fee..d89f028 100644
--- a/extensions/libip6t_length.c
+++ b/extensions/libip6t_length.c
@@ -68,7 +68,7 @@ parse_lengths(const char *s, struct ip6t
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ip6t_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
@@ -117,7 +117,7 @@ print_length(struct ip6t_length_info *in
 
 /* Prints out the matchinfo. */
 static void
-print(const struct ip6t_ip6 *ip,
+print(const void *ip,
       const struct xt_entry_match *match,
       int numeric)
 {
@@ -127,7 +127,7 @@ print(const struct ip6t_ip6 *ip,
 
 /* Saves the union ip6t_matchinfo in parsable form to stdout. */
 static void
-save(const struct ip6t_ip6 *ip, const struct xt_entry_match *match)
+save(const void *ip, const struct xt_entry_match *match)
 {
 	printf("--length ");
 	print_length((struct ip6t_length_info *)match->data);
diff --git a/extensions/libip6t_limit.c b/extensions/libip6t_limit.c
index 2a5a9b2..c1f7014 100644
--- a/extensions/libip6t_limit.c
+++ b/extensions/libip6t_limit.c
@@ -93,7 +93,7 @@ init(struct xt_entry_match *m, unsigned
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ip6t_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
@@ -156,7 +156,7 @@ static void print_rate(u_int32_t period)
 
 /* Prints out the matchinfo. */
 static void
-print(const struct ip6t_ip6 *ip,
+print(const void *ip,
       const struct xt_entry_match *match,
       int numeric)
 {
@@ -166,7 +166,7 @@ print(const struct ip6t_ip6 *ip,
 }
 
 /* FIXME: Make minimalist: only print rate if not default --RR */
-static void save(const struct ip6t_ip6 *ip, const struct xt_entry_match *match)
+static void save(const void *ip, const struct xt_entry_match *match)
 {
 	struct ip6t_rateinfo *r = (struct ip6t_rateinfo *)match->data;
 
diff --git a/extensions/libip6t_mac.c b/extensions/libip6t_mac.c
index b50b0c9..77a6390 100644
--- a/extensions/libip6t_mac.c
+++ b/extensions/libip6t_mac.c
@@ -56,7 +56,7 @@ parse_mac(const char *mac, struct ip6t_m
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ip6t_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
@@ -98,7 +98,7 @@ static void final_check(unsigned int fla
 
 /* Prints out the matchinfo. */
 static void
-print(const struct ip6t_ip6 *ip,
+print(const void *ip,
       const struct xt_entry_match *match,
       int numeric)
 {
@@ -111,7 +111,7 @@ print(const struct ip6t_ip6 *ip,
 }
 
 /* Saves the union ip6t_matchinfo in parsable form to stdout. */
-static void save(const struct ip6t_ip6 *ip, const struct xt_entry_match *match)
+static void save(const void *ip, const struct xt_entry_match *match)
 {
 	if (((struct ip6t_mac_info *)match->data)->invert)
 		printf("! ");
diff --git a/extensions/libip6t_mark.c b/extensions/libip6t_mark.c
index ac0fc70..257a558 100644
--- a/extensions/libip6t_mark.c
+++ b/extensions/libip6t_mark.c
@@ -29,7 +29,7 @@ static struct option opts[] = {
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ip6t_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
@@ -96,7 +96,7 @@ final_check(unsigned int flags)
 
 /* Prints out the matchinfo. */
 static void
-print(const struct ip6t_ip6 *ip,
+print(const void *ip,
       const struct xt_entry_match *match,
       int numeric)
 {
@@ -112,7 +112,7 @@ print(const struct ip6t_ip6 *ip,
 
 /* Saves the union ip6t_matchinfo in parsable form to stdout. */
 static void
-save(const struct ip6t_ip6 *ip, const struct xt_entry_match *match)
+save(const void *ip, const struct xt_entry_match *match)
 {
 	struct ip6t_mark_info *info = (struct ip6t_mark_info *)match->data;
 
diff --git a/extensions/libip6t_nth.c b/extensions/libip6t_nth.c
index f0e4197..04d4230 100644
--- a/extensions/libip6t_nth.c
+++ b/extensions/libip6t_nth.c
@@ -60,7 +60,7 @@ static struct option opts[] = {
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ip6t_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
@@ -175,7 +175,7 @@ static void final_check(unsigned int fla
 
 /* Prints out the targinfo. */
 static void
-print(const struct ip6t_ip6 *ip,
+print(const void *ip,
       const struct xt_entry_match *match,
       int numeric)
 {
@@ -195,7 +195,7 @@ print(const struct ip6t_ip6 *ip,
 
 /* Saves the union ip6t_targinfo in parsable form to stdout. */
 static void
-save(const struct ip6t_ip6 *ip, const struct xt_entry_match *match)
+save(const void *ip, const struct xt_entry_match *match)
 {
 	const struct ip6t_nth_info *nthinfo
 		= (const struct ip6t_nth_info *)match->data;
diff --git a/extensions/libip6t_owner.c b/extensions/libip6t_owner.c
index adbe840..ff671ab 100644
--- a/extensions/libip6t_owner.c
+++ b/extensions/libip6t_owner.c
@@ -51,7 +51,7 @@ static struct option opts[] = {
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ip6t_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
@@ -199,7 +199,7 @@ final_check(unsigned int flags)
 
 /* Prints out the matchinfo. */
 static void
-print(const struct ip6t_ip6 *ip,
+print(const void *ip,
       const struct xt_entry_match *match,
       int numeric)
 {
@@ -216,7 +216,7 @@ print(const struct ip6t_ip6 *ip,
 
 /* Saves the union ip6t_matchinfo in parsable form to stdout. */
 static void
-save(const struct ip6t_ip6 *ip, const struct xt_entry_match *match)
+save(const void *ip, const struct xt_entry_match *match)
 {
 	struct ip6t_owner_info *info = (struct ip6t_owner_info *)match->data;
 
diff --git a/extensions/libip6t_physdev.c b/extensions/libip6t_physdev.c
index d4df642..d2a37f6 100644
--- a/extensions/libip6t_physdev.c
+++ b/extensions/libip6t_physdev.c
@@ -41,7 +41,7 @@ init(struct xt_entry_match *m, unsigned
 
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ip6t_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
@@ -121,7 +121,7 @@ static void final_check(unsigned int fla
 }
 
 static void
-print(const struct ip6t_ip6 *ip,
+print(const void *ip,
       const struct xt_entry_match *match,
       int numeric)
 {
@@ -148,7 +148,7 @@ print(const struct ip6t_ip6 *ip,
 	printf(" ");
 }
 
-static void save(const struct ip6t_ip6 *ip, const struct xt_entry_match *match)
+static void save(const void *ip, const struct xt_entry_match *match)
 {
 	struct ip6t_physdev_info *info =
 		(struct ip6t_physdev_info*)match->data;
diff --git a/extensions/libip6t_policy.c b/extensions/libip6t_policy.c
index f5c6487..b7062c6 100644
--- a/extensions/libip6t_policy.c
+++ b/extensions/libip6t_policy.c
@@ -166,7 +166,7 @@ static int parse_mode(char *s)
 }
 
 static int parse(int c, char **argv, int invert, unsigned int *flags,
-                 const struct ip6t_entry *entry,
+                 const void *entry,
                  unsigned int *nfcache,
                  struct xt_entry_match **match)
 {
@@ -427,7 +427,7 @@ static void print_flags(char *prefix, co
 		printf("%sstrict ", prefix);
 }
 
-static void print(const struct ip6t_ip6 *ip,
+static void print(const void *ip,
                   const struct xt_entry_match *match,
 		  int numeric)
 {
@@ -445,7 +445,7 @@ static void print(const struct ip6t_ip6
 	printf("\n");
 }
 
-static void save(const struct ip6t_ip6 *ip, const struct xt_entry_match *match)
+static void save(const void *ip, const struct xt_entry_match *match)
 {
 	const struct ip6t_policy_info *info = (void *)match->data;
 	unsigned int i;
diff --git a/extensions/libip6t_random.c b/extensions/libip6t_random.c
index 865093c..05543b7 100644
--- a/extensions/libip6t_random.c
+++ b/extensions/libip6t_random.c
@@ -64,7 +64,7 @@ init(struct xt_entry_match *m, unsigned
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ip6t_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
@@ -104,7 +104,7 @@ static void final_check(unsigned int fla
 
 /* Prints out the targinfo. */
 static void
-print(const struct ip6t_ip6 *ip,
+print(const void *ip,
       const struct xt_entry_match *match,
       int numeric)
 {
@@ -119,7 +119,7 @@ print(const struct ip6t_ip6 *ip,
 
 /* Saves the union ip6t_targinfo in parsable form to stdout. */
 static void
-save(const struct ip6t_ip6 *ip, const struct xt_entry_match *match)
+save(const void *ip, const struct xt_entry_match *match)
 {
 	const struct ip6t_rand_info *randinfo
 		= (const struct ip6t_rand_info *)match->data;
diff --git a/extensions/libip6t_rt.c b/extensions/libip6t_rt.c
index 246b2da..a36c65a 100644
--- a/extensions/libip6t_rt.c
+++ b/extensions/libip6t_rt.c
@@ -156,7 +156,7 @@ init(struct xt_entry_match *m, unsigned
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ip6t_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
@@ -277,7 +277,7 @@ print_addresses(int addrnr, struct in6_a
 
 /* Prints out the union ip6t_matchinfo. */
 static void
-print(const struct ip6t_ip6 *ip,
+print(const void *ip,
       const struct xt_entry_match *match, int numeric)
 {
 	const struct ip6t_rt *rtinfo = (struct ip6t_rt *)match->data;
@@ -304,7 +304,7 @@ print(const struct ip6t_ip6 *ip,
 }
 
 /* Saves the union ip6t_matchinfo in parsable form to stdout. */
-static void save(const struct ip6t_ip6 *ip, const struct xt_entry_match *match)
+static void save(const void *ip, const struct xt_entry_match *match)
 {
 	const struct ip6t_rt *rtinfo = (struct ip6t_rt *)match->data;
 
diff --git a/extensions/libip6t_standard.c b/extensions/libip6t_standard.c
index 211cc8b..0d9f490 100644
--- a/extensions/libip6t_standard.c
+++ b/extensions/libip6t_standard.c
@@ -30,7 +30,7 @@ init(struct xt_entry_target *t, unsigned
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ip6t_entry *entry,
+      const void *entry,
       struct xt_entry_target **target)
 {
 	return 0;
@@ -43,7 +43,7 @@ static void final_check(unsigned int fla
 
 /* Saves the targinfo in parsable form to stdout. */
 static void
-save(const struct ip6t_ip6 *ip6, const struct xt_entry_target *target)
+save(const void *ip6, const struct xt_entry_target *target)
 {
 }
 
diff --git a/extensions/libip6t_state.c b/extensions/libip6t_state.c
index bb4214c..0f44086 100644
--- a/extensions/libip6t_state.c
+++ b/extensions/libip6t_state.c
@@ -65,7 +65,7 @@ parse_states(const char *arg, struct ipt
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ip6t_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
@@ -124,7 +124,7 @@ static void print_state(unsigned int sta
 
 /* Prints out the matchinfo. */
 static void
-print(const struct ip6t_ip6 *ip,
+print(const void *ip,
       const struct xt_entry_match *match,
       int numeric)
 {
@@ -135,7 +135,7 @@ print(const struct ip6t_ip6 *ip,
 }
 
 /* Saves the matchinfo in parsable form to stdout. */
-static void save(const struct ip6t_ip6 *ip, const struct xt_entry_match *match)
+static void save(const void *ip, const struct xt_entry_match *match)
 {
 	struct ipt_state_info *sinfo = (struct ipt_state_info *)match->data;
 
diff --git a/extensions/libip6t_tcp.c b/extensions/libip6t_tcp.c
index 1e7ac36..15f240e 100644
--- a/extensions/libip6t_tcp.c
+++ b/extensions/libip6t_tcp.c
@@ -147,7 +147,7 @@ init(struct xt_entry_match *m, unsigned
    ate an option. */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ip6t_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
@@ -317,7 +317,7 @@ print_flags(u_int8_t mask, u_int8_t cmp,
 
 /* Prints out the union ipt_matchinfo. */
 static void
-print(const struct ip6t_ip6 *ip,
+print(const void *ip,
       const struct xt_entry_match *match, int numeric)
 {
 	const struct ip6t_tcp *tcp = (struct ip6t_tcp *)match->data;
@@ -341,7 +341,7 @@ print(const struct ip6t_ip6 *ip,
 }
 
 /* Saves the union ipt_matchinfo in parsable form to stdout. */
-static void save(const struct ip6t_ip6 *ip, const struct xt_entry_match *match)
+static void save(const void *ip, const struct xt_entry_match *match)
 {
 	const struct ip6t_tcp *tcpinfo = (struct ip6t_tcp *)match->data;
 
diff --git a/extensions/libip6t_udp.c b/extensions/libip6t_udp.c
index 61d824f..3355de2 100644
--- a/extensions/libip6t_udp.c
+++ b/extensions/libip6t_udp.c
@@ -69,7 +69,7 @@ init(struct xt_entry_match *m, unsigned
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ip6t_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
@@ -156,7 +156,7 @@ print_ports(const char *name, u_int16_t
 
 /* Prints out the union ipt_matchinfo. */
 static void
-print(const struct ip6t_ip6 *ip,
+print(const void *ip,
       const struct xt_entry_match *match, int numeric)
 {
 	const struct ip6t_udp *udp = (struct ip6t_udp *)match->data;
@@ -174,7 +174,7 @@ print(const struct ip6t_ip6 *ip,
 }
 
 /* Saves the union ipt_matchinfo in parsable form to stdout. */
-static void save(const struct ip6t_ip6 *ip, const struct xt_entry_match *match)
+static void save(const void *ip, const struct xt_entry_match *match)
 {
 	const struct ip6t_udp *udpinfo = (struct ip6t_udp *)match->data;
 
diff --git a/extensions/libipt_BALANCE.c b/extensions/libipt_BALANCE.c
index 6c3f88f..51ae653 100644
--- a/extensions/libipt_BALANCE.c
+++ b/extensions/libipt_BALANCE.c
@@ -67,7 +67,7 @@ parse_to(char *arg, struct ip_nat_range
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *entry,
       struct xt_entry_target **target)
 {
 	struct ip_nat_multi_range *mr
@@ -98,7 +98,7 @@ static void final_check(unsigned int fla
 
 /* Prints out the targinfo. */
 static void
-print(const struct ipt_ip *ip,
+print(const void *ip,
       const struct xt_entry_target *target,
       int numeric)
 {
@@ -116,7 +116,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the union ipt_targinfo in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct xt_entry_target *target)
+save(const void *ip, const struct xt_entry_target *target)
 {
 	struct ip_nat_multi_range *mr
 		= (struct ip_nat_multi_range *)target->data;
diff --git a/extensions/libipt_CLASSIFY.c b/extensions/libipt_CLASSIFY.c
index 2e4cc15..16e47ac 100644
--- a/extensions/libipt_CLASSIFY.c
+++ b/extensions/libipt_CLASSIFY.c
@@ -47,7 +47,7 @@ int string_to_priority(const char *s, un
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *entry,
       struct xt_entry_target **target)
 {
 	struct ipt_classify_target_info *clinfo
@@ -87,7 +87,7 @@ print_class(unsigned int priority, int n
 
 /* Prints out the targinfo. */
 static void
-print(const struct ipt_ip *ip,
+print(const void *ip,
       const struct xt_entry_target *target,
       int numeric)
 {
@@ -99,7 +99,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the union ipt_targinfo in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct xt_entry_target *target)
+save(const void *ip, const struct xt_entry_target *target)
 {
 	const struct ipt_classify_target_info *clinfo =
 		(const struct ipt_classify_target_info *)target->data;
diff --git a/extensions/libipt_CLUSTERIP.c b/extensions/libipt_CLUSTERIP.c
index b6df5bd..036a98e 100644
--- a/extensions/libipt_CLUSTERIP.c
+++ b/extensions/libipt_CLUSTERIP.c
@@ -85,7 +85,7 @@ parse_mac(const char *mac, char *macbuf)
 
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *entry,
       struct xt_entry_target **target)
 {
 	struct ipt_clusterip_tgt_info *cipinfo
@@ -207,7 +207,7 @@ static char *mac2str(const u_int8_t mac[
 
 /* Prints out the targinfo. */
 static void
-print(const struct ipt_ip *ip,
+print(const void *ip,
       const struct xt_entry_target *target,
       int numeric)
 {
@@ -229,7 +229,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the union ipt_targinfo in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct xt_entry_target *target)
+save(const void *ip, const struct xt_entry_target *target)
 {
 	const struct ipt_clusterip_tgt_info *cipinfo =
 		(const struct ipt_clusterip_tgt_info *)target->data;
diff --git a/extensions/libipt_CONNMARK.c b/extensions/libipt_CONNMARK.c
index 54f33c9..fbf0d4d 100644
--- a/extensions/libipt_CONNMARK.c
+++ b/extensions/libipt_CONNMARK.c
@@ -66,7 +66,7 @@ init(struct xt_entry_target *t, unsigned
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *entry,
       struct xt_entry_target **target)
 {
 	struct ipt_connmark_target_info *markinfo
@@ -144,7 +144,7 @@ print_mask(const char *text, unsigned lo
 
 /* Prints out the target info. */
 static void
-print(const struct ipt_ip *ip,
+print(const void *ip,
       const struct xt_entry_target *target,
       int numeric)
 {
@@ -174,7 +174,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the target into in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct xt_entry_target *target)
+save(const void *ip, const struct xt_entry_target *target)
 {
 	const struct ipt_connmark_target_info *markinfo =
 		(const struct ipt_connmark_target_info *)target->data;
diff --git a/extensions/libipt_CONNSECMARK.c b/extensions/libipt_CONNSECMARK.c
index e8dd380..bb6fb28 100644
--- a/extensions/libipt_CONNSECMARK.c
+++ b/extensions/libipt_CONNSECMARK.c
@@ -31,7 +31,7 @@ static struct option opts[] = {
 };
 
 static int parse(int c, char **argv, int invert, unsigned int *flags,
-                 const struct ipt_entry *entry, struct xt_entry_target **target)
+                 const void *entry, struct xt_entry_target **target)
 {
 	struct xt_connsecmark_target_info *info =
 		(struct xt_connsecmark_target_info*)(*target)->data;
@@ -86,7 +86,7 @@ static void print_connsecmark(struct xt_
 	}
 }
 
-static void print(const struct ipt_ip *ip,
+static void print(const void *ip,
 		  const struct xt_entry_target *target, int numeric)
 {
 	struct xt_connsecmark_target_info *info =
@@ -96,7 +96,7 @@ static void print(const struct ipt_ip *i
 	print_connsecmark(info);
 }
 
-static void save(const struct ipt_ip *ip, const struct xt_entry_target *target)
+static void save(const void *ip, const struct xt_entry_target *target)
 {
 	struct xt_connsecmark_target_info *info =
 		(struct xt_connsecmark_target_info*)target->data;
diff --git a/extensions/libipt_DSCP.c b/extensions/libipt_DSCP.c
index d86bbc9..ee49a66 100644
--- a/extensions/libipt_DSCP.c
+++ b/extensions/libipt_DSCP.c
@@ -78,7 +78,7 @@ parse_class(const char *s, struct ipt_DS
 
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *entry,
       struct xt_entry_target **target)
 {
 	struct ipt_DSCP_info *dinfo
@@ -123,7 +123,7 @@ print_dscp(u_int8_t dscp, int numeric)
 
 /* Prints out the targinfo. */
 static void
-print(const struct ipt_ip *ip,
+print(const void *ip,
       const struct xt_entry_target *target,
       int numeric)
 {
@@ -135,7 +135,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the union ipt_targinfo in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct xt_entry_target *target)
+save(const void *ip, const struct xt_entry_target *target)
 {
 	const struct ipt_DSCP_info *dinfo =
 		(const struct ipt_DSCP_info *)target->data;
diff --git a/extensions/libipt_ECN.c b/extensions/libipt_ECN.c
index f3adca1..580d76a 100644
--- a/extensions/libipt_ECN.c
+++ b/extensions/libipt_ECN.c
@@ -47,7 +47,7 @@ static struct option opts[] = {
 
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *entry,
       struct xt_entry_target **target)
 {
 	unsigned int result;
@@ -114,7 +114,7 @@ final_check(unsigned int flags)
 
 /* Prints out the targinfo. */
 static void
-print(const struct ipt_ip *ip,
+print(const void *ip,
       const struct xt_entry_target *target,
       int numeric)
 {
@@ -141,7 +141,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the union ipt_targinfo in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct xt_entry_target *target)
+save(const void *ip, const struct xt_entry_target *target)
 {
 	const struct ipt_ECN_info *einfo =
 		(const struct ipt_ECN_info *)target->data;
diff --git a/extensions/libipt_FTOS.c b/extensions/libipt_FTOS.c
index 75b5fc9..c140347 100644
--- a/extensions/libipt_FTOS.c
+++ b/extensions/libipt_FTOS.c
@@ -54,7 +54,7 @@ parse_ftos(const unsigned char *s, struc
 
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *entry,
       struct xt_entry_target **target)
 {
 	struct ipt_FTOS_info *finfo
@@ -92,7 +92,7 @@ print_ftos(u_int8_t ftos, int numeric)
 
 /* Prints out the targinfo. */
 static void
-print(const struct ipt_ip *ip,
+print(const void *ip,
       const struct xt_entry_target *target,
       int numeric)
 {
@@ -104,7 +104,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the union ipt_targinfo in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct xt_entry_target *target)
+save(const void *ip, const struct xt_entry_target *target)
 {
 	const struct ipt_FTOS_info *finfo =
 		(const struct ipt_FTOS_info *)target->data;
diff --git a/extensions/libipt_IPMARK.c b/extensions/libipt_IPMARK.c
index 0646d60..239b05b 100644
--- a/extensions/libipt_IPMARK.c
+++ b/extensions/libipt_IPMARK.c
@@ -59,7 +59,7 @@ init(struct xt_entry_target *t, unsigned
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *entry,
       struct xt_entry_target **target)
 {
 	struct ipt_ipmark_target_info *ipmarkinfo
@@ -116,7 +116,7 @@ final_check(unsigned int flags)
 
 /* Prints out the targinfo. */
 static void
-print(const struct ipt_ip *ip,
+print(const void *ip,
       const struct xt_entry_target *target,
       int numeric)
 {
@@ -132,7 +132,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the union ipt_targinfo in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct xt_entry_target *target)
+save(const void *ip, const struct xt_entry_target *target)
 {
 	const struct ipt_ipmark_target_info *ipmarkinfo =
 		(const struct ipt_ipmark_target_info *)target->data;
diff --git a/extensions/libipt_IPV4OPTSSTRIP.c b/extensions/libipt_IPV4OPTSSTRIP.c
index 3b569bd..07f27d0 100644
--- a/extensions/libipt_IPV4OPTSSTRIP.c
+++ b/extensions/libipt_IPV4OPTSSTRIP.c
@@ -27,7 +27,7 @@ static struct option opts[] = {
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *entry,
       struct xt_entry_target **target)
 {
 	return 0;
@@ -40,7 +40,7 @@ final_check(unsigned int flags)
 
 /* Prints out the targinfo. */
 static void
-print(const struct ipt_ip *ip,
+print(const void *ip,
       const struct xt_entry_target *target,
       int numeric)
 {
@@ -49,7 +49,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the stuff in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct xt_entry_target *target)
+save(const void *ip, const struct xt_entry_target *target)
 {
 	/* nothing to print, we don't take option... */
 }
diff --git a/extensions/libipt_LOG.c b/extensions/libipt_LOG.c
index 1141808..dca1edf 100644
--- a/extensions/libipt_LOG.c
+++ b/extensions/libipt_LOG.c
@@ -110,7 +110,7 @@ parse_level(const char *level)
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *entry,
       struct xt_entry_target **target)
 {
 	struct ipt_log_info *loginfo = (struct ipt_log_info *)(*target)->data;
@@ -206,7 +206,7 @@ static void final_check(unsigned int fla
 
 /* Prints out the targinfo. */
 static void
-print(const struct ipt_ip *ip,
+print(const void *ip,
       const struct xt_entry_target *target,
       int numeric)
 {
@@ -247,7 +247,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the union ipt_targinfo in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct xt_entry_target *target)
+save(const void *ip, const struct xt_entry_target *target)
 {
 	const struct ipt_log_info *loginfo
 		= (const struct ipt_log_info *)target->data;
diff --git a/extensions/libipt_MARK.c b/extensions/libipt_MARK.c
index 66ba168..65105c8 100644
--- a/extensions/libipt_MARK.c
+++ b/extensions/libipt_MARK.c
@@ -39,7 +39,7 @@ init(struct xt_entry_target *t, unsigned
    ate an option */
 static int
 parse_v0(int c, char **argv, int invert, unsigned int *flags,
-	 const struct ipt_entry *entry,
+	 const void *entry,
 	 struct xt_entry_target **target)
 {
 	struct ipt_mark_target_info *markinfo
@@ -86,7 +86,7 @@ final_check(unsigned int flags)
    ate an option */
 static int
 parse_v1(int c, char **argv, int invert, unsigned int *flags,
-	 const struct ipt_entry *entry,
+	 const void *entry,
 	 struct xt_entry_target **target)
 {
 	struct ipt_mark_target_info_v1 *markinfo
@@ -137,7 +137,7 @@ print_mark(unsigned long mark)
 
 /* Prints out the targinfo. */
 static void
-print_v0(const struct ipt_ip *ip,
+print_v0(const void *ip,
 	 const struct xt_entry_target *target,
 	 int numeric)
 {
@@ -149,7 +149,7 @@ print_v0(const struct ipt_ip *ip,
 
 /* Saves the union ipt_targinfo in parsable form to stdout. */
 static void
-save_v0(const struct ipt_ip *ip, const struct xt_entry_target *target)
+save_v0(const void *ip, const struct xt_entry_target *target)
 {
 	const struct ipt_mark_target_info *markinfo =
 		(const struct ipt_mark_target_info *)target->data;
@@ -160,7 +160,7 @@ save_v0(const struct ipt_ip *ip, const s
 
 /* Prints out the targinfo. */
 static void
-print_v1(const struct ipt_ip *ip,
+print_v1(const void *ip,
 	 const struct xt_entry_target *target,
 	 int numeric)
 {
@@ -183,7 +183,7 @@ print_v1(const struct ipt_ip *ip,
 
 /* Saves the union ipt_targinfo in parsable form to stdout. */
 static void
-save_v1(const struct ipt_ip *ip, const struct xt_entry_target *target)
+save_v1(const void *ip, const struct xt_entry_target *target)
 {
 	const struct ipt_mark_target_info_v1 *markinfo =
 		(const struct ipt_mark_target_info_v1 *)target->data;
diff --git a/extensions/libipt_MIRROR.c b/extensions/libipt_MIRROR.c
index 9141bd1..c02807b 100644
--- a/extensions/libipt_MIRROR.c
+++ b/extensions/libipt_MIRROR.c
@@ -30,7 +30,7 @@ init(struct xt_entry_target *t, unsigned
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *entry,
       struct xt_entry_target **target)
 {
 	return 0;
diff --git a/extensions/libipt_NETLINK.c b/extensions/libipt_NETLINK.c
index 371b90b..565146c 100644
--- a/extensions/libipt_NETLINK.c
+++ b/extensions/libipt_NETLINK.c
@@ -36,7 +36,7 @@ static void init(struct xt_entry_target
 
 /* Parse command options */
 static int parse(int c, char **argv, int invert, unsigned int *flags,
-		 const struct ipt_entry *entry,
+		 const void *entry,
 		 struct xt_entry_target **target)
 {
 	struct ipt_nldata *nld=(struct ipt_nldata *)(*target)->data;
@@ -101,7 +101,7 @@ static void final_check(unsigned int fla
 }
 
 /* Saves the union ipt_targinfo in parsable form to stdout. */
-static void save(const struct ipt_ip *ip,
+static void save(const void *ip,
 		 const struct xt_entry_target *target)
 {
 	const struct ipt_nldata *nld
@@ -119,7 +119,7 @@ static void save(const struct ipt_ip *ip
 
 /* Prints out the targinfo. */
 static void
-print(const struct ipt_ip *ip,
+print(const void *ip,
       const struct xt_entry_target *target, int numeric)
 {
 	const struct ipt_nldata *nld
diff --git a/extensions/libipt_NETMAP.c b/extensions/libipt_NETMAP.c
index c91ab36..808ddec 100644
--- a/extensions/libipt_NETMAP.c
+++ b/extensions/libipt_NETMAP.c
@@ -118,7 +118,7 @@ parse_to(char *arg, struct ip_nat_range
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *entry,
       struct xt_entry_target **target)
 {
 	struct ip_nat_multi_range *mr
@@ -149,7 +149,7 @@ static void final_check(unsigned int fla
 
 /* Prints out the targinfo. */
 static void
-print(const struct ipt_ip *ip,
+print(const void *ip,
       const struct xt_entry_target *target,
       int numeric)
 {
@@ -171,7 +171,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the targinfo in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct xt_entry_target *target)
+save(const void *ip, const struct xt_entry_target *target)
 {
 	printf("--%s ", opts[0].name);
 	print(ip, target, 0);
diff --git a/extensions/libipt_NFQUEUE.c b/extensions/libipt_NFQUEUE.c
index fe14905..9719ae8 100644
--- a/extensions/libipt_NFQUEUE.c
+++ b/extensions/libipt_NFQUEUE.c
@@ -47,7 +47,7 @@ parse_num(const char *s, struct ipt_NFQ_
 
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *entry,
       struct xt_entry_target **target)
 {
 	struct ipt_NFQ_info *tinfo
@@ -74,7 +74,7 @@ final_check(unsigned int flags)
 
 /* Prints out the targinfo. */
 static void
-print(const struct ipt_ip *ip,
+print(const void *ip,
       const struct xt_entry_target *target,
       int numeric)
 {
@@ -85,7 +85,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the union ipt_targinfo in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct xt_entry_target *target)
+save(const void *ip, const struct xt_entry_target *target)
 {
 	const struct ipt_NFQ_info *tinfo =
 		(const struct ipt_NFQ_info *)target->data;
diff --git a/extensions/libipt_NOTRACK.c b/extensions/libipt_NOTRACK.c
index c0d40f2..7aec15c 100644
--- a/extensions/libipt_NOTRACK.c
+++ b/extensions/libipt_NOTRACK.c
@@ -30,7 +30,7 @@ init(struct xt_entry_target *t, unsigned
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *entry,
       struct xt_entry_target **target)
 {
 	return 0;
diff --git a/extensions/libipt_REJECT.c b/extensions/libipt_REJECT.c
index 4f8f06d..d41603f 100644
--- a/extensions/libipt_REJECT.c
+++ b/extensions/libipt_REJECT.c
@@ -100,7 +100,7 @@ init(struct xt_entry_target *t, unsigned
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *entry,
       struct xt_entry_target **target)
 {
 	struct ipt_reject_info *reject = (struct ipt_reject_info *)(*target)->data;
@@ -139,7 +139,7 @@ static void final_check(unsigned int fla
 
 /* Prints out ipt_reject_info. */
 static void
-print(const struct ipt_ip *ip,
+print(const void *ip,
       const struct xt_entry_target *target,
       int numeric)
 {
@@ -155,7 +155,7 @@ print(const struct ipt_ip *ip,
 }
 
 /* Saves ipt_reject in parsable form to stdout. */
-static void save(const struct ipt_ip *ip, const struct xt_entry_target *target)
+static void save(const void *ip, const struct xt_entry_target *target)
 {
 	const struct ipt_reject_info *reject
 		= (const struct ipt_reject_info *)target->data;
diff --git a/extensions/libipt_ROUTE.c b/extensions/libipt_ROUTE.c
index 3904121..604d5ff 100644
--- a/extensions/libipt_ROUTE.c
+++ b/extensions/libipt_ROUTE.c
@@ -71,7 +71,7 @@ init(struct xt_entry_target *t, unsigned
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *entry,
       struct xt_entry_target **target)
 {
 	struct ipt_route_target_info *route_info = 
@@ -189,7 +189,7 @@ final_check(unsigned int flags)
 
 /* Prints out the targinfo. */
 static void
-print(const struct ipt_ip *ip,
+print(const void *ip,
       const struct xt_entry_target *target,
       int numeric)
 {
@@ -218,7 +218,7 @@ print(const struct ipt_ip *ip,
 }
 
 
-static void save(const struct ipt_ip *ip, 
+static void save(const void *ip, 
 		 const struct xt_entry_target *target)
 {
 	const struct ipt_route_target_info *route_info
diff --git a/extensions/libipt_SAME.c b/extensions/libipt_SAME.c
index d084b30..fa16398 100644
--- a/extensions/libipt_SAME.c
+++ b/extensions/libipt_SAME.c
@@ -84,7 +84,7 @@ parse_to(char *arg, struct ip_nat_range
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *entry,
       struct xt_entry_target **target)
 {
 	struct ipt_same_info *mr
@@ -132,7 +132,7 @@ static void final_check(unsigned int fla
 
 /* Prints out the targinfo. */
 static void
-print(const struct ipt_ip *ip,
+print(const void *ip,
       const struct xt_entry_target *target,
       int numeric)
 {
@@ -163,7 +163,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the union ipt_targinfo in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct xt_entry_target *target)
+save(const void *ip, const struct xt_entry_target *target)
 {
 	int count;
 	struct ipt_same_info *mr
diff --git a/extensions/libipt_SECMARK.c b/extensions/libipt_SECMARK.c
index 6dc9160..d8b0aa3 100644
--- a/extensions/libipt_SECMARK.c
+++ b/extensions/libipt_SECMARK.c
@@ -37,7 +37,7 @@ static void init(struct xt_entry_target
  * ate an option.
  */
 static int parse(int c, char **argv, int invert, unsigned int *flags,
-                 const struct ipt_entry *entry, struct xt_entry_target **target)
+                 const void *entry, struct xt_entry_target **target)
 {
 	struct xt_secmark_target_info *info =
 		(struct xt_secmark_target_info*)(*target)->data;
@@ -83,7 +83,7 @@ static void print_secmark(struct xt_secm
 	}
 }
 
-static void print(const struct ipt_ip *ip,
+static void print(const void *ip,
 		  const struct xt_entry_target *target, int numeric)
 {
 	struct xt_secmark_target_info *info =
@@ -94,7 +94,7 @@ static void print(const struct ipt_ip *i
 }
 
 /* Saves the target info in parsable form to stdout. */
-static void save(const struct ipt_ip *ip, const struct xt_entry_target *target)
+static void save(const void *ip, const struct xt_entry_target *target)
 {
 	struct xt_secmark_target_info *info =
 		(struct xt_secmark_target_info*)target->data;
diff --git a/extensions/libipt_SET.c b/extensions/libipt_SET.c
index 598cead..d874b8f 100644
--- a/extensions/libipt_SET.c
+++ b/extensions/libipt_SET.c
@@ -86,7 +86,7 @@ parse_target(char **argv, int invert, un
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry, struct xt_entry_target **target)
+      const void *entry, struct xt_entry_target **target)
 {
 	struct ipt_set_info_target *myinfo =
 	    (struct ipt_set_info_target *) (*target)->data;
@@ -137,7 +137,7 @@ print_target(const char *prefix, const s
 
 /* Prints out the targinfo. */
 static void
-print(const struct ipt_ip *ip,
+print(const void *ip,
       const struct xt_entry_target *target, int numeric)
 {
 	struct ipt_set_info_target *info =
@@ -149,7 +149,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the union ipt_targinfo in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct xt_entry_target *target)
+save(const void *ip, const struct xt_entry_target *target)
 {
 	struct ipt_set_info_target *info =
 	    (struct ipt_set_info_target *) target->data;
diff --git a/extensions/libipt_TARPIT.c b/extensions/libipt_TARPIT.c
index 8805a6a..65ab5c7 100644
--- a/extensions/libipt_TARPIT.c
+++ b/extensions/libipt_TARPIT.c
@@ -17,7 +17,7 @@ static struct option opts[] = {
 
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *entry,
       struct xt_entry_target **target)
 {
 	return 0;
@@ -28,13 +28,13 @@ static void final_check(unsigned int fla
 }
 
 static void
-print(const struct ipt_ip *ip,
+print(const void *ip,
       const struct xt_entry_target *target,
       int numeric)
 {
 }
 
-static void save(const struct ipt_ip *ip, const struct xt_entry_target *target)
+static void save(const void *ip, const struct xt_entry_target *target)
 {
 }
 
diff --git a/extensions/libipt_TCPLAG.c b/extensions/libipt_TCPLAG.c
index 96e8546..ad0d55f 100644
--- a/extensions/libipt_TCPLAG.c
+++ b/extensions/libipt_TCPLAG.c
@@ -111,7 +111,7 @@ static void init( struct xt_entry_target
  *             (this has already been malloced for us).
  */
 static int parse( int c, char **argv, int invert, unsigned int *flags,
-				  const struct ipt_entry *entry, struct xt_entry_target **target )
+				  const void *entry, struct xt_entry_target **target )
 {
 	struct ipt_tcplag *el = (struct ipt_tcplag *)( *target )->data;
 /*
@@ -158,7 +158,7 @@ static void final_check( unsigned int fl
  * but coding of the various libipt_XX.c modules suggests
  * that it is safe to presume target is correctly initialised.
  */
-static void print(const struct ipt_ip *ip, const struct xt_entry_target *target, int numeric)
+static void print(const void *ip, const struct xt_entry_target *target, int numeric)
 {
 	const struct ipt_tcplag *el = (const struct ipt_tcplag *)target->data;
 	printf("TCPLAG <%d>", el->level );
@@ -172,7 +172,7 @@ static void print(const struct ipt_ip *i
  * As above but command-line style printout
  * (machine-readable for restoring table)
  */
-static void save( const struct ipt_ip *ip, const struct xt_entry_target *target )
+static void save( const void *ip, const struct xt_entry_target *target )
 {
 	const struct ipt_tcplag *el = (const struct ipt_tcplag *)target->data;
 	printf("TCPLAG --log-level=%d", el->level );
diff --git a/extensions/libipt_TCPMSS.c b/extensions/libipt_TCPMSS.c
index f2e18a7..3f1855b 100644
--- a/extensions/libipt_TCPMSS.c
+++ b/extensions/libipt_TCPMSS.c
@@ -43,7 +43,7 @@ init(struct xt_entry_target *t, unsigned
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *entry,
       struct xt_entry_target **target)
 {
 	struct ipt_tcpmss_info *mssinfo
@@ -88,7 +88,7 @@ final_check(unsigned int flags)
 
 /* Prints out the targinfo. */
 static void
-print(const struct ipt_ip *ip,
+print(const void *ip,
       const struct xt_entry_target *target,
       int numeric)
 {
@@ -102,7 +102,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the union ipt_targinfo in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct xt_entry_target *target)
+save(const void *ip, const struct xt_entry_target *target)
 {
 	const struct ipt_tcpmss_info *mssinfo =
 		(const struct ipt_tcpmss_info *)target->data;
diff --git a/extensions/libipt_TOS.c b/extensions/libipt_TOS.c
index 2a5185e..1143c0c 100644
--- a/extensions/libipt_TOS.c
+++ b/extensions/libipt_TOS.c
@@ -86,7 +86,7 @@ parse_tos(const char *s, struct ipt_tos_
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *entry,
       struct xt_entry_target **target)
 {
 	struct ipt_tos_target_info *tosinfo
@@ -133,7 +133,7 @@ print_tos(u_int8_t tos, int numeric)
 
 /* Prints out the targinfo. */
 static void
-print(const struct ipt_ip *ip,
+print(const void *ip,
       const struct xt_entry_target *target,
       int numeric)
 {
@@ -145,7 +145,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the union ipt_targinfo in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct xt_entry_target *target)
+save(const void *ip, const struct xt_entry_target *target)
 {
 	const struct ipt_tos_target_info *tosinfo =
 		(const struct ipt_tos_target_info *)target->data;
diff --git a/extensions/libipt_TRACE.c b/extensions/libipt_TRACE.c
index 3b2059d..8958d62 100644
--- a/extensions/libipt_TRACE.c
+++ b/extensions/libipt_TRACE.c
@@ -30,7 +30,7 @@ init(struct xt_entry_target *t, unsigned
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *entry,
       struct xt_entry_target **target)
 {
 	return 0;
diff --git a/extensions/libipt_TTL.c b/extensions/libipt_TTL.c
index f32057e..1244494 100644
--- a/extensions/libipt_TTL.c
+++ b/extensions/libipt_TTL.c
@@ -31,7 +31,7 @@ static void help(void)
 }
 
 static int parse(int c, char **argv, int invert, unsigned int *flags,
-		const struct ipt_entry *entry,
+		const void *entry,
 		struct xt_entry_target **target)
 {
 	struct ipt_TTL_info *info = (struct ipt_TTL_info *) (*target)->data;
@@ -96,7 +96,7 @@ static void final_check(unsigned int fla
 				"TTL: You must specify an action");
 }
 
-static void save(const struct ipt_ip *ip,
+static void save(const void *ip,
 		const struct xt_entry_target *target)
 {
 	const struct ipt_TTL_info *info = 
@@ -117,7 +117,7 @@ static void save(const struct ipt_ip *ip
 	printf("%u ", info->ttl);
 }
 
-static void print(const struct ipt_ip *ip,
+static void print(const void *ip,
 		const struct xt_entry_target *target, int numeric)
 {
 	const struct ipt_TTL_info *info =
diff --git a/extensions/libipt_ULOG.c b/extensions/libipt_ULOG.c
index f48d6f6..a5b8197 100644
--- a/extensions/libipt_ULOG.c
+++ b/extensions/libipt_ULOG.c
@@ -70,7 +70,7 @@ static void init(struct xt_entry_target
 /* Function which parses command options; returns true if it
    ate an option */
 static int parse(int c, char **argv, int invert, unsigned int *flags,
-		 const struct ipt_entry *entry,
+		 const void *entry,
 		 struct xt_entry_target **target)
 {
 	struct ipt_ulog_info *loginfo =
@@ -164,7 +164,7 @@ static void final_check(unsigned int fla
 }
 
 /* Saves the union ipt_targinfo in parsable form to stdout. */
-static void save(const struct ipt_ip *ip,
+static void save(const void *ip,
 		 const struct xt_entry_target *target)
 {
 	const struct ipt_ulog_info *loginfo
@@ -194,7 +194,7 @@ static void save(const struct ipt_ip *ip
 
 /* Prints out the targinfo. */
 static void
-print(const struct ipt_ip *ip,
+print(const void *ip,
       const struct xt_entry_target *target, int numeric)
 {
 	const struct ipt_ulog_info *loginfo
diff --git a/extensions/libipt_XOR.c b/extensions/libipt_XOR.c
index b6d45fd..7b7d23d 100644
--- a/extensions/libipt_XOR.c
+++ b/extensions/libipt_XOR.c
@@ -33,7 +33,7 @@ static void help(void)
 }
 
 static int parse(int c, char **argv, int invert, unsigned int *flags,
-		const struct ipt_entry *entry, 
+		const void *entry, 
 		struct xt_entry_target **target)
 {
 	struct ipt_XOR_info *info = (struct ipt_XOR_info *) (*target)->data;
@@ -69,7 +69,7 @@ static void final_check(unsigned int fla
 		exit_error(PARAMETER_PROBLEM, "XOR: You must specify a block-size");
 }
 
-static void save (const struct ipt_ip *ip,
+static void save (const void *ip,
 		const struct xt_entry_target *target)
 {
 	const struct ipt_XOR_info *info = (struct ipt_XOR_info *) target->data;
@@ -78,7 +78,7 @@ static void save (const struct ipt_ip *i
 	printf("--block-size %u ", info->block_size);
 }
 
-static void print (const struct ipt_ip *ip,
+static void print (const void *ip,
 	const struct xt_entry_target *target, int numeric)
 {
 	const struct ipt_XOR_info *info = (struct ipt_XOR_info *) target->data;
diff --git a/extensions/libipt_account.c b/extensions/libipt_account.c
index 46e2f6d..eb4b173 100644
--- a/extensions/libipt_account.c
+++ b/extensions/libipt_account.c
@@ -179,7 +179,7 @@ static void init(struct xt_entry_match *
 static int parse(int c, char **argv, 
 		  int invert, 
 		  unsigned int *flags,
-                  const struct ipt_entry *entry,
+                  const void *entry,
                   unsigned int *nfcache,
                   struct xt_entry_match **match) {
 	
@@ -219,7 +219,7 @@ static void final_check(unsigned int fla
 }
 
 /* Function used for printing rule with account match for iptables -L */
-static void print(const struct ipt_ip *ip,
+static void print(const void *ip,
                   const struct xt_entry_match *match, 
 		  int numeric) {
 	
@@ -238,7 +238,7 @@ static void print(const struct ipt_ip *i
 }
 
 /* Function used for saving rule containing account match */
-static void save(const struct ipt_ip *ip, 
+static void save(const void *ip, 
 		 const struct xt_entry_match *match) {
 
 	struct t_ipt_account_info *info = (struct t_ipt_account_info *)match->data;
diff --git a/extensions/libipt_addrtype.c b/extensions/libipt_addrtype.c
index dbf4be7..a048e5e 100644
--- a/extensions/libipt_addrtype.c
+++ b/extensions/libipt_addrtype.c
@@ -82,7 +82,7 @@ static void parse_types(const char *arg,
 #define IPT_ADDRTYPE_OPT_DSTTYPE	0x2
 
 static int parse(int c, char **argv, int invert, unsigned int *flags,
-		const struct ipt_entry *entry, unsigned int *nfcache,
+		const void *entry, unsigned int *nfcache,
 		struct xt_entry_match **match)
 {
 	struct ipt_addrtype_info *info =
@@ -137,7 +137,7 @@ static void print_types(u_int16_t mask)
 	printf(" ");
 }
 
-static void print(const struct ipt_ip *ip, 
+static void print(const void *ip, 
 		const struct xt_entry_match *match,
 		int numeric)
 {
@@ -159,7 +159,7 @@ static void print(const struct ipt_ip *i
 	}
 }
 
-static void save(const struct ipt_ip *ip, 
+static void save(const void *ip, 
 		const struct xt_entry_match *match)
 {
 	const struct ipt_addrtype_info *info =
diff --git a/extensions/libipt_ah.c b/extensions/libipt_ah.c
index 3929bdb..ec01f82 100644
--- a/extensions/libipt_ah.c
+++ b/extensions/libipt_ah.c
@@ -81,7 +81,7 @@ init(struct xt_entry_match *m, unsigned
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
@@ -134,7 +134,7 @@ print_spis(const char *name, u_int32_t m
 
 /* Prints out the union ipt_matchinfo. */
 static void
-print(const struct ipt_ip *ip,
+print(const void *ip,
       const struct xt_entry_match *match, int numeric)
 {
 	const struct ipt_ah *ah = (struct ipt_ah *)match->data;
@@ -148,7 +148,7 @@ print(const struct ipt_ip *ip,
 }
 
 /* Saves the union ipt_matchinfo in parsable form to stdout. */
-static void save(const struct ipt_ip *ip, const struct xt_entry_match *match)
+static void save(const void *ip, const struct xt_entry_match *match)
 {
 	const struct ipt_ah *ahinfo = (struct ipt_ah *)match->data;
 
diff --git a/extensions/libipt_childlevel.c b/extensions/libipt_childlevel.c
index 4be0df2..1d2b649 100644
--- a/extensions/libipt_childlevel.c
+++ b/extensions/libipt_childlevel.c
@@ -41,7 +41,7 @@ static struct option opts[] = {
 
 /* Function which parses command options; returns true if it ate an option */
 static int parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry, unsigned int *nfcache,
+      const void *entry, unsigned int *nfcache,
       struct xt_entry_match **match)
 {
 	struct ipt_childlevel_info *childlevelinfo = 
@@ -78,7 +78,7 @@ static void print_protocol(int n, int in
 }
 
 /* Prints out the matchinfo. */
-static void print(const struct ipt_ip *ip,
+static void print(const void *ip,
       const struct xt_entry_match *match,
       int numeric)
 {
@@ -88,7 +88,7 @@ static void print(const struct ipt_ip *i
 		  ((struct ipt_childlevel_info *)match->data)->invert, numeric);
 }
 /* Saves the union ipt_matchinfo in parsable form to stdout. */
-static void save(const struct ipt_ip *ip, const struct xt_entry_match *match)
+static void save(const void *ip, const struct xt_entry_match *match)
 {
         const struct ipt_childlevel_info *info =
             (const struct ipt_childlevel_info*) match->data;
diff --git a/extensions/libipt_comment.c b/extensions/libipt_comment.c
index 1b73c23..ba0e92f 100644
--- a/extensions/libipt_comment.c
+++ b/extensions/libipt_comment.c
@@ -45,7 +45,7 @@ parse_comment(const char *s, struct ipt_
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
@@ -79,7 +79,7 @@ final_check(unsigned int flags)
 
 /* Prints out the matchinfo. */
 static void
-print(const struct ipt_ip *ip,
+print(const void *ip,
       const struct xt_entry_match *match,
       int numeric)
 {
@@ -91,7 +91,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the union ipt_matchinfo in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct xt_entry_match *match)
+save(const void *ip, const struct xt_entry_match *match)
 {
 	struct ipt_comment_info *commentinfo = (struct ipt_comment_info *)match->data;
 
diff --git a/extensions/libipt_condition.c b/extensions/libipt_condition.c
index 677b5f5..0876cd6 100644
--- a/extensions/libipt_condition.c
+++ b/extensions/libipt_condition.c
@@ -26,7 +26,7 @@ static struct option opts[] = {
 
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry, unsigned int *nfcache,
+      const void *entry, unsigned int *nfcache,
       struct xt_entry_match **match)
 {
 	struct condition_info *info =
@@ -64,7 +64,7 @@ final_check(unsigned int flags)
 
 
 static void
-print(const struct ipt_ip *ip,
+print(const void *ip,
 		  const struct xt_entry_match *match, int numeric)
 {
 	const struct condition_info *info =
@@ -75,7 +75,7 @@ print(const struct ipt_ip *ip,
 
 
 static void
-save(const struct ipt_ip *ip,
+save(const void *ip,
 		 const struct xt_entry_match *match)
 {
 	const struct condition_info *info =
diff --git a/extensions/libipt_connbytes.c b/extensions/libipt_connbytes.c
index 5d62f01..f6c2672 100644
--- a/extensions/libipt_connbytes.c
+++ b/extensions/libipt_connbytes.c
@@ -49,7 +49,7 @@ parse_range(const char *arg, struct ipt_
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
@@ -146,7 +146,7 @@ static void print_direction(struct ipt_c
 
 /* Prints out the matchinfo. */
 static void
-print(const struct ipt_ip *ip,
+print(const void *ip,
       const struct xt_entry_match *match,
       int numeric)
 {
@@ -167,7 +167,7 @@ print(const struct ipt_ip *ip,
 }
 
 /* Saves the matchinfo in parsable form to stdout. */
-static void save(const struct ipt_ip *ip, const struct xt_entry_match *match)
+static void save(const void *ip, const struct xt_entry_match *match)
 {
 	struct ipt_connbytes_info *sinfo = (struct ipt_connbytes_info *)match->data;
 
diff --git a/extensions/libipt_connlimit.c b/extensions/libipt_connlimit.c
index d5d347f..6310eff 100644
--- a/extensions/libipt_connlimit.c
+++ b/extensions/libipt_connlimit.c
@@ -30,7 +30,7 @@ static struct option opts[] = {
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
@@ -94,7 +94,7 @@ count_bits(u_int32_t mask)
 
 /* Prints out the matchinfo. */
 static void
-print(const struct ipt_ip *ip,
+print(const void *ip,
       const struct xt_entry_match *match,
       int numeric)
 {
@@ -105,7 +105,7 @@ print(const struct ipt_ip *ip,
 }
 
 /* Saves the matchinfo in parsable form to stdout. */
-static void save(const struct ipt_ip *ip, const struct xt_entry_match *match)
+static void save(const void *ip, const struct xt_entry_match *match)
 {
 	struct ipt_connlimit_info *info = (struct ipt_connlimit_info*)match->data;
 
diff --git a/extensions/libipt_connmark.c b/extensions/libipt_connmark.c
index 9412d66..86248d9 100644
--- a/extensions/libipt_connmark.c
+++ b/extensions/libipt_connmark.c
@@ -56,7 +56,7 @@ init(struct xt_entry_match *m, unsigned
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
@@ -106,7 +106,7 @@ final_check(unsigned int flags)
 
 /* Prints out the matchinfo. */
 static void
-print(const struct ipt_ip *ip,
+print(const void *ip,
       const struct xt_entry_match *match,
       int numeric)
 {
@@ -120,7 +120,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the matchinfo in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct xt_entry_match *match)
+save(const void *ip, const struct xt_entry_match *match)
 {
 	struct ipt_connmark_info *info = (struct ipt_connmark_info *)match->data;
 
diff --git a/extensions/libipt_connrate.c b/extensions/libipt_connrate.c
index 92bf248..e45b54c 100644
--- a/extensions/libipt_connrate.c
+++ b/extensions/libipt_connrate.c
@@ -76,7 +76,7 @@ parse_range(const char *arg, struct ipt_
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
@@ -138,7 +138,7 @@ print_range(struct ipt_connrate_info *si
 
 /* Prints out the matchinfo. */
 static void
-print(const struct ipt_ip *ip,
+print(const void *ip,
       const struct xt_entry_match *match,
       int numeric)
 {
@@ -150,7 +150,7 @@ print(const struct ipt_ip *ip,
 }
 
 /* Saves the matchinfo in parsable form to stdout. */
-static void save(const struct ipt_ip *ip, const struct xt_entry_match *match)
+static void save(const void *ip, const struct xt_entry_match *match)
 {
 	struct ipt_connrate_info *sinfo = (struct ipt_connrate_info *)match->data;
 
diff --git a/extensions/libipt_conntrack.c b/extensions/libipt_conntrack.c
index d32a6ce..2270739 100644
--- a/extensions/libipt_conntrack.c
+++ b/extensions/libipt_conntrack.c
@@ -186,7 +186,7 @@ parse_expires(const char *s, struct ipt_
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
@@ -431,7 +431,7 @@ print_addr(struct in_addr *addr, struct
 
 /* Saves the matchinfo in parsable form to stdout. */
 static void
-matchinfo_print(const struct ipt_ip *ip, const struct xt_entry_match *match, int numeric, const char *optpfx)
+matchinfo_print(const void *ip, const struct xt_entry_match *match, int numeric, const char *optpfx)
 {
 	struct ipt_conntrack_info *sinfo = (struct ipt_conntrack_info *)match->data;
 
@@ -517,7 +517,7 @@ matchinfo_print(const struct ipt_ip *ip,
 
 /* Prints out the matchinfo. */
 static void
-print(const struct ipt_ip *ip,
+print(const void *ip,
       const struct xt_entry_match *match,
       int numeric)
 {
@@ -525,7 +525,7 @@ print(const struct ipt_ip *ip,
 }
 
 /* Saves the matchinfo in parsable form to stdout. */
-static void save(const struct ipt_ip *ip, const struct xt_entry_match *match)
+static void save(const void *ip, const struct xt_entry_match *match)
 {
 	matchinfo_print(ip, match, 1, "--");
 }
diff --git a/extensions/libipt_dccp.c b/extensions/libipt_dccp.c
index c42f083..8e06712 100644
--- a/extensions/libipt_dccp.c
+++ b/extensions/libipt_dccp.c
@@ -134,7 +134,7 @@ static u_int8_t parse_dccp_option(char *
 
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
@@ -279,7 +279,7 @@ print_option(u_int8_t option, int invert
 
 /* Prints out the matchinfo. */
 static void
-print(const struct ipt_ip *ip,
+print(const void *ip,
       const struct xt_entry_match *match,
       int numeric)
 {
@@ -314,7 +314,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the union ipt_matchinfo in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, 
+save(const void *ip, 
      const struct xt_entry_match *match)
 {
 	const struct ipt_dccp_info *einfo =
diff --git a/extensions/libipt_dscp.c b/extensions/libipt_dscp.c
index 68bc0aa..6a8cac8 100644
--- a/extensions/libipt_dscp.c
+++ b/extensions/libipt_dscp.c
@@ -75,7 +75,7 @@ parse_class(const char *s, struct ipt_ds
 
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
@@ -131,7 +131,7 @@ print_dscp(u_int8_t dscp, int invert, in
 
 /* Prints out the matchinfo. */
 static void
-print(const struct ipt_ip *ip,
+print(const void *ip,
       const struct xt_entry_match *match,
       int numeric)
 {
@@ -143,7 +143,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the union ipt_matchinfo in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct xt_entry_match *match)
+save(const void *ip, const struct xt_entry_match *match)
 {
 	const struct ipt_dscp_info *dinfo =
 		(const struct ipt_dscp_info *)match->data;
diff --git a/extensions/libipt_dstlimit.c b/extensions/libipt_dstlimit.c
index 83512a4..a5a1e28 100644
--- a/extensions/libipt_dstlimit.c
+++ b/extensions/libipt_dstlimit.c
@@ -120,7 +120,7 @@ init(struct xt_entry_match *m, unsigned
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
@@ -253,7 +253,7 @@ static void print_rate(u_int32_t period)
 
 /* Prints out the matchinfo. */
 static void
-print(const struct ipt_ip *ip,
+print(const void *ip,
       const struct xt_entry_match *match,
       int numeric)
 {
@@ -286,7 +286,7 @@ print(const struct ipt_ip *ip,
 }
 
 /* FIXME: Make minimalist: only print rate if not default --RR */
-static void save(const struct ipt_ip *ip, const struct xt_entry_match *match)
+static void save(const void *ip, const struct xt_entry_match *match)
 {
 	struct ipt_dstlimit_info *r = 
 		(struct ipt_dstlimit_info *)match->data;
diff --git a/extensions/libipt_ecn.c b/extensions/libipt_ecn.c
index 9d32b0f..8a5a7d3 100644
--- a/extensions/libipt_ecn.c
+++ b/extensions/libipt_ecn.c
@@ -35,7 +35,7 @@ static struct option opts[] = {
 
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
@@ -97,7 +97,7 @@ final_check(unsigned int flags)
 
 /* Prints out the matchinfo. */
 static void
-print(const struct ipt_ip *ip,
+print(const void *ip,
       const struct xt_entry_match *match,
       int numeric)
 {
@@ -127,7 +127,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the union ipt_matchinfo in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct xt_entry_match *match)
+save(const void *ip, const struct xt_entry_match *match)
 {
 	const struct ipt_ecn_info *einfo =
 		(const struct ipt_ecn_info *)match->data;
diff --git a/extensions/libipt_esp.c b/extensions/libipt_esp.c
index 380af84..b675f5b 100644
--- a/extensions/libipt_esp.c
+++ b/extensions/libipt_esp.c
@@ -84,7 +84,7 @@ init(struct xt_entry_match *m, unsigned
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
@@ -137,7 +137,7 @@ print_spis(const char *name, u_int32_t m
 
 /* Prints out the union ipt_matchinfo. */
 static void
-print(const struct ipt_ip *ip,
+print(const void *ip,
       const struct xt_entry_match *match, int numeric)
 {
 	const struct ipt_esp *esp = (struct ipt_esp *)match->data;
@@ -151,7 +151,7 @@ print(const struct ipt_ip *ip,
 }
 
 /* Saves the union ipt_matchinfo in parsable form to stdout. */
-static void save(const struct ipt_ip *ip, const struct xt_entry_match *match)
+static void save(const void *ip, const struct xt_entry_match *match)
 {
 	const struct ipt_esp *espinfo = (struct ipt_esp *)match->data;
 
diff --git a/extensions/libipt_fuzzy.c b/extensions/libipt_fuzzy.c
index f7f3730..6a59924 100644
--- a/extensions/libipt_fuzzy.c
+++ b/extensions/libipt_fuzzy.c
@@ -58,7 +58,7 @@ init(struct xt_entry_match *m, unsigned
 
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
@@ -114,7 +114,7 @@ static void final_check(unsigned int fla
 }
 
 static void
-print(const struct ipt_ip *ip,
+print(const void *ip,
       const struct xt_entry_match *match,
       int numeric)
 {
@@ -127,7 +127,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the union ipt_targinfo in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct xt_entry_match *match)
+save(const void *ip, const struct xt_entry_match *match)
 {
 	const struct ipt_fuzzy_info *fuzzyinfo
 		= (const struct ipt_fuzzy_info *)match->data;
diff --git a/extensions/libipt_hashlimit.c b/extensions/libipt_hashlimit.c
index 527b2e8..552d3bf 100644
--- a/extensions/libipt_hashlimit.c
+++ b/extensions/libipt_hashlimit.c
@@ -151,7 +151,7 @@ static int parse_mode(struct ipt_hashlim
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
@@ -304,7 +304,7 @@ static void print_mode(const struct ipt_
 
 /* Prints out the matchinfo. */
 static void
-print(const struct ipt_ip *ip,
+print(const void *ip,
       const struct xt_entry_match *match,
       int numeric)
 {
@@ -325,7 +325,7 @@ print(const struct ipt_ip *ip,
 }
 
 /* FIXME: Make minimalist: only print rate if not default --RR */
-static void save(const struct ipt_ip *ip, const struct xt_entry_match *match)
+static void save(const void *ip, const struct xt_entry_match *match)
 {
 	struct ipt_hashlimit_info *r = 
 		(struct ipt_hashlimit_info *)match->data;
diff --git a/extensions/libipt_helper.c b/extensions/libipt_helper.c
index ee2fbd2..3c1c739 100644
--- a/extensions/libipt_helper.c
+++ b/extensions/libipt_helper.c
@@ -28,7 +28,7 @@ static struct option opts[] = {
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
@@ -64,7 +64,7 @@ final_check(unsigned int flags)
 
 /* Prints out the info. */
 static void
-print(const struct ipt_ip *ip,
+print(const void *ip,
       const struct xt_entry_match *match,
       int numeric)
 {
@@ -75,7 +75,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the union ipt_info in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct xt_entry_match *match)
+save(const void *ip, const struct xt_entry_match *match)
 {
 	struct ipt_helper_info *info = (struct ipt_helper_info *)match->data;
 
diff --git a/extensions/libipt_icmp.c b/extensions/libipt_icmp.c
index 4bb1b58..68476fe 100644
--- a/extensions/libipt_icmp.c
+++ b/extensions/libipt_icmp.c
@@ -181,7 +181,7 @@ init(struct xt_entry_match *m, unsigned
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
@@ -246,7 +246,7 @@ static void print_icmptype(u_int8_t type
 
 /* Prints out the union ipt_matchinfo. */
 static void
-print(const struct ipt_ip *ip,
+print(const void *ip,
       const struct xt_entry_match *match,
       int numeric)
 {
@@ -263,7 +263,7 @@ print(const struct ipt_ip *ip,
 }
 
 /* Saves the match in parsable form to stdout. */
-static void save(const struct ipt_ip *ip, const struct xt_entry_match *match)
+static void save(const void *ip, const struct xt_entry_match *match)
 {
 	const struct ipt_icmp *icmp = (struct ipt_icmp *)match->data;
 
diff --git a/extensions/libipt_iprange.c b/extensions/libipt_iprange.c
index bca2f5b..78096e1 100644
--- a/extensions/libipt_iprange.c
+++ b/extensions/libipt_iprange.c
@@ -56,7 +56,7 @@ parse_iprange(char *arg, struct ipt_ipra
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
@@ -122,7 +122,7 @@ print_iprange(const struct ipt_iprange *
 
 /* Prints out the info. */
 static void
-print(const struct ipt_ip *ip,
+print(const void *ip,
       const struct xt_entry_match *match,
       int numeric)
 {
@@ -144,7 +144,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the union ipt_info in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct xt_entry_match *match)
+save(const void *ip, const struct xt_entry_match *match)
 {
 	struct ipt_iprange_info *info = (struct ipt_iprange_info *)match->data;
 
diff --git a/extensions/libipt_ipv4options.c b/extensions/libipt_ipv4options.c
index 6ddce27..1c665f2 100644
--- a/extensions/libipt_ipv4options.c
+++ b/extensions/libipt_ipv4options.c
@@ -39,7 +39,7 @@ static struct option opts[] = {
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
@@ -226,7 +226,7 @@ final_check(unsigned int flags)
 
 /* Prints out the matchinfo. */
 static void
-print(const struct ipt_ip *ip,
+print(const void *ip,
       const struct xt_entry_match *match,
       int numeric)
 {
@@ -261,7 +261,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the data in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct xt_entry_match *match)
+save(const void *ip, const struct xt_entry_match *match)
 {
 	struct ipt_ipv4options_info *info = ((struct ipt_ipv4options_info *)match->data);
 
diff --git a/extensions/libipt_length.c b/extensions/libipt_length.c
index 49d91b8..f542a35 100644
--- a/extensions/libipt_length.c
+++ b/extensions/libipt_length.c
@@ -66,7 +66,7 @@ parse_lengths(const char *s, struct ipt_
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
@@ -115,7 +115,7 @@ print_length(struct ipt_length_info *inf
 
 /* Prints out the matchinfo. */
 static void
-print(const struct ipt_ip *ip,
+print(const void *ip,
       const struct xt_entry_match *match,
       int numeric)
 {
@@ -125,7 +125,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the union ipt_matchinfo in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct xt_entry_match *match)
+save(const void *ip, const struct xt_entry_match *match)
 {
 	printf("--length ");
 	print_length((struct ipt_length_info *)match->data);
diff --git a/extensions/libipt_limit.c b/extensions/libipt_limit.c
index 214e6f6..92d47ae 100644
--- a/extensions/libipt_limit.c
+++ b/extensions/libipt_limit.c
@@ -93,7 +93,7 @@ init(struct xt_entry_match *m, unsigned
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
@@ -156,7 +156,7 @@ static void print_rate(u_int32_t period)
 
 /* Prints out the matchinfo. */
 static void
-print(const struct ipt_ip *ip,
+print(const void *ip,
       const struct xt_entry_match *match,
       int numeric)
 {
@@ -166,7 +166,7 @@ print(const struct ipt_ip *ip,
 }
 
 /* FIXME: Make minimalist: only print rate if not default --RR */
-static void save(const struct ipt_ip *ip, const struct xt_entry_match *match)
+static void save(const void *ip, const struct xt_entry_match *match)
 {
 	struct ipt_rateinfo *r = (struct ipt_rateinfo *)match->data;
 
diff --git a/extensions/libipt_mac.c b/extensions/libipt_mac.c
index a9f6194..13fa69a 100644
--- a/extensions/libipt_mac.c
+++ b/extensions/libipt_mac.c
@@ -56,7 +56,7 @@ parse_mac(const char *mac, struct ipt_ma
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
@@ -98,7 +98,7 @@ static void final_check(unsigned int fla
 
 /* Prints out the matchinfo. */
 static void
-print(const struct ipt_ip *ip,
+print(const void *ip,
       const struct xt_entry_match *match,
       int numeric)
 {
@@ -111,7 +111,7 @@ print(const struct ipt_ip *ip,
 }
 
 /* Saves the union ipt_matchinfo in parsable form to stdout. */
-static void save(const struct ipt_ip *ip, const struct xt_entry_match *match)
+static void save(const void *ip, const struct xt_entry_match *match)
 {
 	if (((struct ipt_mac_info *)match->data)->invert)
 		printf("! ");
diff --git a/extensions/libipt_mark.c b/extensions/libipt_mark.c
index b2b038f..65a9871 100644
--- a/extensions/libipt_mark.c
+++ b/extensions/libipt_mark.c
@@ -29,7 +29,7 @@ static struct option opts[] = {
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
@@ -96,7 +96,7 @@ final_check(unsigned int flags)
 
 /* Prints out the matchinfo. */
 static void
-print(const struct ipt_ip *ip,
+print(const void *ip,
       const struct xt_entry_match *match,
       int numeric)
 {
@@ -112,7 +112,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the union ipt_matchinfo in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct xt_entry_match *match)
+save(const void *ip, const struct xt_entry_match *match)
 {
 	struct ipt_mark_info *info = (struct ipt_mark_info *)match->data;
 
diff --git a/extensions/libipt_mport.c b/extensions/libipt_mport.c
index 5816a84..f584416 100644
--- a/extensions/libipt_mport.c
+++ b/extensions/libipt_mport.c
@@ -84,7 +84,7 @@ init(struct xt_entry_match *m, unsigned
 }
 
 static const char *
-check_proto(const struct ipt_entry *entry)
+check_proto(const void *entry)
 {
 	if (entry->ip.proto == IPPROTO_TCP)
 		return "tcp";
@@ -102,7 +102,7 @@ check_proto(const struct ipt_entry *entr
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
@@ -180,7 +180,7 @@ print_port(u_int16_t port, u_int8_t prot
 
 /* Prints out the matchinfo. */
 static void
-print(const struct ipt_ip *ip,
+print(const void *ip,
       const struct xt_entry_match *match,
       int numeric)
 {
@@ -227,7 +227,7 @@ print(const struct ipt_ip *ip,
 }
 
 /* Saves the union ipt_matchinfo in parsable form to stdout. */
-static void save(const struct ipt_ip *ip, const struct xt_entry_match *match)
+static void save(const void *ip, const struct xt_entry_match *match)
 {
 	const struct ipt_mport *minfo
 		= (const struct ipt_mport *)match->data;
diff --git a/extensions/libipt_nth.c b/extensions/libipt_nth.c
index 9d37a4d..0ac2cce 100644
--- a/extensions/libipt_nth.c
+++ b/extensions/libipt_nth.c
@@ -60,7 +60,7 @@ static struct option opts[] = {
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
@@ -175,7 +175,7 @@ static void final_check(unsigned int fla
 
 /* Prints out the targinfo. */
 static void
-print(const struct ipt_ip *ip,
+print(const void *ip,
       const struct xt_entry_match *match,
       int numeric)
 {
@@ -195,7 +195,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the union ipt_targinfo in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct xt_entry_match *match)
+save(const void *ip, const struct xt_entry_match *match)
 {
 	const struct ipt_nth_info *nthinfo
 		= (const struct ipt_nth_info *)match->data;
diff --git a/extensions/libipt_osf.c b/extensions/libipt_osf.c
index 92c3f7f..dde8450 100644
--- a/extensions/libipt_osf.c
+++ b/extensions/libipt_osf.c
@@ -66,7 +66,7 @@ static void parse_string(const unsigned
 }
 
 static int parse(int c, char **argv, int invert, unsigned int *flags,
-      			const struct ipt_entry *entry,
+      			const void *entry,
       			unsigned int *nfcache,
       			struct xt_entry_match **match)
 {
@@ -122,14 +122,14 @@ static void final_check(unsigned int fla
 		exit_error(PARAMETER_PROBLEM, "OS fingerprint match: You must specify `--genre'");
 }
 
-static void print(const struct ipt_ip *ip, const struct xt_entry_match *match, int numeric)
+static void print(const void *ip, const struct xt_entry_match *match, int numeric)
 {
 	const struct ipt_osf_info *info = (const struct ipt_osf_info*) match->data;
 
 	printf("OS fingerprint match %s%s ", (info->invert) ? "!" : "", info->genre);
 }
 
-static void save(const struct ipt_ip *ip, const struct xt_entry_match *match)
+static void save(const void *ip, const struct xt_entry_match *match)
 {
 	const struct ipt_osf_info *info = (const struct ipt_osf_info*) match->data;
 
diff --git a/extensions/libipt_owner.c b/extensions/libipt_owner.c
index 87531d6..b65a15c 100644
--- a/extensions/libipt_owner.c
+++ b/extensions/libipt_owner.c
@@ -53,7 +53,7 @@ static struct option opts[] = {
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
@@ -200,7 +200,7 @@ final_check(unsigned int flags)
 
 /* Prints out the matchinfo. */
 static void
-print(const struct ipt_ip *ip,
+print(const void *ip,
       const struct xt_entry_match *match,
       int numeric)
 {
@@ -217,7 +217,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the union ipt_matchinfo in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct xt_entry_match *match)
+save(const void *ip, const struct xt_entry_match *match)
 {
 	struct ipt_owner_info *info = (struct ipt_owner_info *)match->data;
 
diff --git a/extensions/libipt_physdev.c b/extensions/libipt_physdev.c
index 0bf3ea8..d80fb0c 100644
--- a/extensions/libipt_physdev.c
+++ b/extensions/libipt_physdev.c
@@ -41,7 +41,7 @@ init(struct xt_entry_match *m, unsigned
 
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
@@ -121,7 +121,7 @@ static void final_check(unsigned int fla
 }
 
 static void
-print(const struct ipt_ip *ip,
+print(const void *ip,
       const struct xt_entry_match *match,
       int numeric)
 {
@@ -148,7 +148,7 @@ print(const struct ipt_ip *ip,
 	printf(" ");
 }
 
-static void save(const struct ipt_ip *ip, const struct xt_entry_match *match)
+static void save(const void *ip, const struct xt_entry_match *match)
 {
 	struct ipt_physdev_info *info =
 		(struct ipt_physdev_info*)match->data;
diff --git a/extensions/libipt_pkttype.c b/extensions/libipt_pkttype.c
index 9f09419..568aaab 100644
--- a/extensions/libipt_pkttype.c
+++ b/extensions/libipt_pkttype.c
@@ -86,7 +86,7 @@ static void parse_pkttype(const char *pk
 }
 
 static int parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
@@ -131,7 +131,7 @@ static void print_pkttype(struct ipt_pkt
 	printf("%d ", info->pkttype);	/* in case we didn't find an entry in named-packtes */
 }
 
-static void print(const struct ipt_ip *ip, const struct xt_entry_match *match, int numeric)
+static void print(const void *ip, const struct xt_entry_match *match, int numeric)
 {
 	struct ipt_pkttype_info *info = (struct ipt_pkttype_info *)match->data;
 	
@@ -139,7 +139,7 @@ static void print(const struct ipt_ip *i
 	print_pkttype(info);
 }
 
-static void save(const struct ipt_ip *ip, const struct xt_entry_match *match)
+static void save(const void *ip, const struct xt_entry_match *match)
 {
 	struct ipt_pkttype_info *info = (struct ipt_pkttype_info *)match->data;
 	
diff --git a/extensions/libipt_policy.c b/extensions/libipt_policy.c
index 06393fe..978edb0 100644
--- a/extensions/libipt_policy.c
+++ b/extensions/libipt_policy.c
@@ -126,7 +126,7 @@ static int parse_mode(char *s)
 }
 
 static int parse(int c, char **argv, int invert, unsigned int *flags,
-                 const struct ipt_entry *entry,
+                 const void *entry,
                  unsigned int *nfcache,
                  struct xt_entry_match **match)
 {
@@ -387,7 +387,7 @@ static void print_flags(char *prefix, co
 		printf("%sstrict ", prefix);
 }
 
-static void print(const struct ipt_ip *ip,
+static void print(const void *ip,
                   const struct xt_entry_match *match,
 		  int numeric)
 {
@@ -403,7 +403,7 @@ static void print(const struct ipt_ip *i
 	}
 }
 
-static void save(const struct ipt_ip *ip, const struct xt_entry_match *match)
+static void save(const void *ip, const struct xt_entry_match *match)
 {
 	const struct ipt_policy_info *info = (void *)match->data;
 	unsigned int i;
diff --git a/extensions/libipt_psd.c b/extensions/libipt_psd.c
index 6663901..727d33e 100644
--- a/extensions/libipt_psd.c
+++ b/extensions/libipt_psd.c
@@ -75,7 +75,7 @@ typedef struct _code {
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
@@ -146,7 +146,7 @@ static void final_check(unsigned int fla
 
 /* Prints out the targinfo. */
 static void
-print(const struct ipt_ip *ip,
+print(const void *ip,
       const struct xt_entry_match *match,
       int numeric)
 {
@@ -162,7 +162,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the union ipt_targinfo in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct xt_entry_match *match)
+save(const void *ip, const struct xt_entry_match *match)
 {
 	const struct ipt_psd_info *psdinfo
 		= (const struct ipt_psd_info *)match->data;
diff --git a/extensions/libipt_quota.c b/extensions/libipt_quota.c
index eb26e66..89e5168 100644
--- a/extensions/libipt_quota.c
+++ b/extensions/libipt_quota.c
@@ -27,7 +27,7 @@ help(void)
 
 /* print matchinfo */
 static void
-print(const struct ipt_ip *ip, const struct xt_entry_match *match, int numeric)
+print(const void *ip, const struct xt_entry_match *match, int numeric)
 {
         struct xt_quota_info *q = (struct xt_quota_info *) match->data;
         printf("quota: %llu bytes", (unsigned long long) q->quota);
@@ -35,7 +35,7 @@ print(const struct ipt_ip *ip, const str
 
 /* save matchinfo */
 static void
-save(const struct ipt_ip *ip, const struct xt_entry_match *match)
+save(const void *ip, const struct xt_entry_match *match)
 {
         struct xt_quota_info *q = (struct xt_quota_info *) match->data;
         printf("--quota %llu ", (unsigned long long) q->quota);
@@ -60,7 +60,7 @@ parse_quota(const char *s, u_int64_t * q
 /* parse all options, returning true if we found any for us */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *entry,
       unsigned int *nfcache, struct xt_entry_match **match)
 {
         struct xt_quota_info *info = (struct xt_quota_info *) (*match)->data;
diff --git a/extensions/libipt_random.c b/extensions/libipt_random.c
index 1251732..ee513a1 100644
--- a/extensions/libipt_random.c
+++ b/extensions/libipt_random.c
@@ -63,7 +63,7 @@ init(struct xt_entry_match *m, unsigned
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
@@ -103,7 +103,7 @@ static void final_check(unsigned int fla
 
 /* Prints out the targinfo. */
 static void
-print(const struct ipt_ip *ip,
+print(const void *ip,
       const struct xt_entry_match *match,
       int numeric)
 {
@@ -118,7 +118,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the union ipt_targinfo in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct xt_entry_match *match)
+save(const void *ip, const struct xt_entry_match *match)
 {
 	const struct ipt_rand_info *randinfo
 		= (const struct ipt_rand_info *)match->data;
diff --git a/extensions/libipt_realm.c b/extensions/libipt_realm.c
index 5be8982..445bcc8 100644
--- a/extensions/libipt_realm.c
+++ b/extensions/libipt_realm.c
@@ -156,7 +156,7 @@ const char* realm_id2name(int id)
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
@@ -215,7 +215,7 @@ print_realm(unsigned long id, unsigned l
 
 /* Prints out the matchinfo. */
 static void
-print(const struct ipt_ip *ip,
+print(const void *ip,
       const struct xt_entry_match *match,
       int numeric)
 {
@@ -231,7 +231,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the union ipt_matchinfo in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct xt_entry_match *match)
+save(const void *ip, const struct xt_entry_match *match)
 {
 	struct ipt_realm_info *ri = (struct ipt_realm_info *) match->data;
 
diff --git a/extensions/libipt_recent.c b/extensions/libipt_recent.c
index 16b4b0b..2c38ad3 100644
--- a/extensions/libipt_recent.c
+++ b/extensions/libipt_recent.c
@@ -84,7 +84,7 @@ init(struct xt_entry_match *match, unsig
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
@@ -175,7 +175,7 @@ final_check(unsigned int flags)
 
 /* Prints out the matchinfo. */
 static void
-print(const struct ipt_ip *ip,
+print(const void *ip,
       const struct xt_entry_match *match,
       int numeric)
 {
@@ -199,7 +199,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the union ipt_matchinfo in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct xt_entry_match *match)
+save(const void *ip, const struct xt_entry_match *match)
 {
 	struct ipt_recent_info *info = (struct ipt_recent_info *)match->data;
 
diff --git a/extensions/libipt_record_rpc.c b/extensions/libipt_record_rpc.c
index eb758c5..605d035 100644
--- a/extensions/libipt_record_rpc.c
+++ b/extensions/libipt_record_rpc.c
@@ -20,7 +20,7 @@ static struct option opts[] = {
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
@@ -34,13 +34,13 @@ static void final_check(unsigned int fla
 
 /* Prints out the union ipt_matchinfo. */
 static void
-print(const struct ipt_ip *ip,
+print(const void *ip,
       const struct xt_entry_match *match,
       int numeric)
 {
 }
 
-static void save(const struct ipt_ip *ip, const struct xt_entry_match *match)
+static void save(const void *ip, const struct xt_entry_match *match)
 {
 }
 
diff --git a/extensions/libipt_rpc.c b/extensions/libipt_rpc.c
index 84317a0..c99e6e7 100644
--- a/extensions/libipt_rpc.c
+++ b/extensions/libipt_rpc.c
@@ -259,7 +259,7 @@ static void parse_rpcs_string(char *stri
 
 
 static int parse(int c, char **argv, int invert, unsigned int *flags,
-		const struct ipt_entry *entry,
+		const void *entry,
 		unsigned int *nfcache,
 		struct xt_entry_match **match)
 {
@@ -309,7 +309,7 @@ static void final_check(unsigned int fla
 }
 
 
-static void print(const struct ipt_ip *ip,
+static void print(const void *ip,
 		const struct xt_entry_match *match,
 		int numeric)
 {
@@ -333,7 +333,7 @@ static void print(const struct ipt_ip *i
 }
 
 
-static void save(const struct ipt_ip *ip, const struct xt_entry_match *match)
+static void save(const void *ip, const struct xt_entry_match *match)
 {
 	struct ipt_rpc_info *rpcinfo = ((struct ipt_rpc_info *)match->data);
 
diff --git a/extensions/libipt_sctp.c b/extensions/libipt_sctp.c
index 7d64501..f88df7f 100644
--- a/extensions/libipt_sctp.c
+++ b/extensions/libipt_sctp.c
@@ -263,7 +263,7 @@ parse_sctp_chunks(struct ipt_sctp_info *
 
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
@@ -458,7 +458,7 @@ out:
 
 /* Prints out the matchinfo. */
 static void
-print(const struct ipt_ip *ip,
+print(const void *ip,
       const struct xt_entry_match *match,
       int numeric)
 {
@@ -492,7 +492,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the union ipt_matchinfo in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, 
+save(const void *ip, 
      const struct xt_entry_match *match)
 {
 	const struct ipt_sctp_info *einfo =
diff --git a/extensions/libipt_set.c b/extensions/libipt_set.c
index 39dd72e..7fdf216 100644
--- a/extensions/libipt_set.c
+++ b/extensions/libipt_set.c
@@ -52,7 +52,7 @@ static void init(struct xt_entry_match *
 /* Function which parses command options; returns true if it ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *entry,
       unsigned int *nfcache, struct xt_entry_match **match)
 {
 	struct ipt_set_info_match *myinfo = 
@@ -127,7 +127,7 @@ print_match(const char *prefix, const st
 
 /* Prints out the matchinfo. */
 static void
-print(const struct ipt_ip *ip,
+print(const void *ip,
       const struct xt_entry_match *match, int numeric)
 {
 	struct ipt_set_info_match *info = 
@@ -137,7 +137,7 @@ print(const struct ipt_ip *ip,
 }
 
 /* Saves the matchinfo in parsable form to stdout. */
-static void save(const struct ipt_ip *ip,
+static void save(const void *ip,
 		 const struct xt_entry_match *match)
 {
 	struct ipt_set_info_match *info = 
diff --git a/extensions/libipt_standard.c b/extensions/libipt_standard.c
index a3acdae..2b96697 100644
--- a/extensions/libipt_standard.c
+++ b/extensions/libipt_standard.c
@@ -30,7 +30,7 @@ init(struct xt_entry_target *t, unsigned
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *entry,
       struct xt_entry_target **target)
 {
 	return 0;
@@ -43,7 +43,7 @@ static void final_check(unsigned int fla
 
 /* Saves the targinfo in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct xt_entry_target *target)
+save(const void *ip, const struct xt_entry_target *target)
 {
 }
 
diff --git a/extensions/libipt_state.c b/extensions/libipt_state.c
index a0d9c3f..459ccfd 100644
--- a/extensions/libipt_state.c
+++ b/extensions/libipt_state.c
@@ -65,7 +65,7 @@ parse_states(const char *arg, struct ipt
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
@@ -124,7 +124,7 @@ static void print_state(unsigned int sta
 
 /* Prints out the matchinfo. */
 static void
-print(const struct ipt_ip *ip,
+print(const void *ip,
       const struct xt_entry_match *match,
       int numeric)
 {
@@ -135,7 +135,7 @@ print(const struct ipt_ip *ip,
 }
 
 /* Saves the matchinfo in parsable form to stdout. */
-static void save(const struct ipt_ip *ip, const struct xt_entry_match *match)
+static void save(const void *ip, const struct xt_entry_match *match)
 {
 	struct ipt_state_info *sinfo = (struct ipt_state_info *)match->data;
 
diff --git a/extensions/libipt_statistic.c b/extensions/libipt_statistic.c
index 2b3a038..756153e 100644
--- a/extensions/libipt_statistic.c
+++ b/extensions/libipt_statistic.c
@@ -35,7 +35,7 @@ static struct xt_statistic_info *info;
 
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
@@ -137,7 +137,7 @@ static void print_match(const struct xt_
 }
 
 static void
-print(const struct ipt_ip *ip,
+print(const void *ip,
       const struct xt_entry_match *match,
       int numeric)
 {
@@ -149,7 +149,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the union ipt_matchinfo in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct xt_entry_match *match)
+save(const void *ip, const struct xt_entry_match *match)
 {
 	struct xt_statistic_info *info = (struct xt_statistic_info *)match->data;
 
diff --git a/extensions/libipt_string.c b/extensions/libipt_string.c
index b5c24c8..9b98baa 100644
--- a/extensions/libipt_string.c
+++ b/extensions/libipt_string.c
@@ -170,7 +170,7 @@ parse_hex_string(const char *s, struct i
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
@@ -289,7 +289,7 @@ print_string(const char *str, const unsi
 
 /* Prints out the matchinfo. */
 static void
-print(const struct ipt_ip *ip,
+print(const void *ip,
       const struct xt_entry_match *match,
       int numeric)
 {
@@ -313,7 +313,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the union ipt_matchinfo in parseable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct xt_entry_match *match)
+save(const void *ip, const struct xt_entry_match *match)
 {
 	const struct ipt_string_info *info =
 	    (const struct ipt_string_info*) match->data;
diff --git a/extensions/libipt_tcp.c b/extensions/libipt_tcp.c
index a2334ce..287b00f 100644
--- a/extensions/libipt_tcp.c
+++ b/extensions/libipt_tcp.c
@@ -147,7 +147,7 @@ init(struct xt_entry_match *m, unsigned
    ate an option. */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
@@ -317,7 +317,7 @@ print_flags(u_int8_t mask, u_int8_t cmp,
 
 /* Prints out the union ipt_matchinfo. */
 static void
-print(const struct ipt_ip *ip,
+print(const void *ip,
       const struct xt_entry_match *match, int numeric)
 {
 	const struct ipt_tcp *tcp = (struct ipt_tcp *)match->data;
@@ -341,7 +341,7 @@ print(const struct ipt_ip *ip,
 }
 
 /* Saves the union ipt_matchinfo in parsable form to stdout. */
-static void save(const struct ipt_ip *ip, const struct xt_entry_match *match)
+static void save(const void *ip, const struct xt_entry_match *match)
 {
 	const struct ipt_tcp *tcpinfo = (struct ipt_tcp *)match->data;
 
diff --git a/extensions/libipt_tcpmss.c b/extensions/libipt_tcpmss.c
index 198f7fd..e17c020 100644
--- a/extensions/libipt_tcpmss.c
+++ b/extensions/libipt_tcpmss.c
@@ -60,7 +60,7 @@ parse_tcp_mssvalues(const char *mssvalue
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
@@ -108,7 +108,7 @@ final_check(unsigned int flags)
 
 /* Prints out the matchinfo. */
 static void
-print(const struct ipt_ip *ip,
+print(const void *ip,
       const struct xt_entry_match *match,
       int numeric)
 {
@@ -122,7 +122,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the union ipt_matchinfo in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct xt_entry_match *match)
+save(const void *ip, const struct xt_entry_match *match)
 {
 	const struct ipt_tcpmss_match_info *mssinfo =
 		(const struct ipt_tcpmss_match_info *)match->data;
diff --git a/extensions/libipt_time.c b/extensions/libipt_time.c
index 81913ca..de6eae1 100644
--- a/extensions/libipt_time.c
+++ b/extensions/libipt_time.c
@@ -334,7 +334,7 @@ parse_date_string(const char *str_to_par
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
@@ -467,7 +467,7 @@ print_date(time_t date, char *command)
 
 /* Prints out the matchinfo. */
 static void
-print(const struct ipt_ip *ip,
+print(const void *ip,
       const struct xt_entry_match *match,
       int numeric)
 {
@@ -500,7 +500,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the data in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct xt_entry_match *match)
+save(const void *ip, const struct xt_entry_match *match)
 {
 	struct ipt_time_info *time = ((struct ipt_time_info *)match->data);
 	int hour_start, hour_stop, minute_start, minute_stop;
diff --git a/extensions/libipt_tos.c b/extensions/libipt_tos.c
index 7fdc9f7..6ee1abc 100644
--- a/extensions/libipt_tos.c
+++ b/extensions/libipt_tos.c
@@ -76,7 +76,7 @@ parse_tos(const char *s, struct ipt_tos_
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
@@ -128,7 +128,7 @@ final_check(unsigned int flags)
 
 /* Prints out the matchinfo. */
 static void
-print(const struct ipt_ip *ip,
+print(const void *ip,
       const struct xt_entry_match *match,
       int numeric)
 {
@@ -142,7 +142,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the union ipt_matchinfo in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct xt_entry_match *match)
+save(const void *ip, const struct xt_entry_match *match)
 {
 	const struct ipt_tos_info *info = (const struct ipt_tos_info *)match->data;
     
diff --git a/extensions/libipt_ttl.c b/extensions/libipt_ttl.c
index 7021095..940f3be 100644
--- a/extensions/libipt_ttl.c
+++ b/extensions/libipt_ttl.c
@@ -25,7 +25,7 @@ static void help(void)
 }
 
 static int parse(int c, char **argv, int invert, unsigned int *flags,
-		const struct ipt_entry *entry, unsigned int *nfcache,
+		const void *entry, unsigned int *nfcache,
 		struct xt_entry_match **match)
 {
 	struct ipt_ttl_info *info = (struct ipt_ttl_info *) (*match)->data;
@@ -92,7 +92,7 @@ static void final_check(unsigned int fla
 			"`--ttl-eq', `--ttl-lt', `--ttl-gt");
 }
 
-static void print(const struct ipt_ip *ip, 
+static void print(const void *ip, 
 		const struct xt_entry_match *match,
 		int numeric)
 {
@@ -117,7 +117,7 @@ static void print(const struct ipt_ip *i
 	printf("%u ", info->ttl);
 }
 
-static void save(const struct ipt_ip *ip, 
+static void save(const void *ip, 
 		const struct xt_entry_match *match)
 {
 	const struct ipt_ttl_info *info =
diff --git a/extensions/libipt_u32.c b/extensions/libipt_u32.c
index 8042799..01d426b 100644
--- a/extensions/libipt_u32.c
+++ b/extensions/libipt_u32.c
@@ -92,7 +92,7 @@ u_int32_t parse_number(char **s, int pos
 /* Function which parses command options; returns true if it ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
@@ -228,7 +228,7 @@ final_check(unsigned int flags)
 
 /* Prints out the matchinfo. */
 static void
-print(const struct ipt_ip *ip,
+print(const void *ip,
       const struct xt_entry_match *match,
       int numeric)
 {
@@ -237,7 +237,7 @@ print(const struct ipt_ip *ip,
 }
 
 /* Saves the union ipt_matchinfo in parsable form to stdout. */
-static void save(const struct ipt_ip *ip, const struct xt_entry_match *match)
+static void save(const void *ip, const struct xt_entry_match *match)
 {
 	printf("--u32 ");
 	print_u32((struct ipt_u32 *)match->data);
diff --git a/extensions/libipt_udp.c b/extensions/libipt_udp.c
index 0d7cb97..5e7b4a2 100644
--- a/extensions/libipt_udp.c
+++ b/extensions/libipt_udp.c
@@ -69,7 +69,7 @@ init(struct xt_entry_match *m, unsigned
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
@@ -156,7 +156,7 @@ print_ports(const char *name, u_int16_t
 
 /* Prints out the union ipt_matchinfo. */
 static void
-print(const struct ipt_ip *ip,
+print(const void *ip,
       const struct xt_entry_match *match, int numeric)
 {
 	const struct ipt_udp *udp = (struct ipt_udp *)match->data;
@@ -174,7 +174,7 @@ print(const struct ipt_ip *ip,
 }
 
 /* Saves the union ipt_matchinfo in parsable form to stdout. */
-static void save(const struct ipt_ip *ip, const struct xt_entry_match *match)
+static void save(const void *ip, const struct xt_entry_match *match)
 {
 	const struct ipt_udp *udpinfo = (struct ipt_udp *)match->data;
 
diff --git a/extensions/libipt_unclean.c b/extensions/libipt_unclean.c
index 101744c..2af1442 100644
--- a/extensions/libipt_unclean.c
+++ b/extensions/libipt_unclean.c
@@ -21,7 +21,7 @@ static struct option opts[] = {
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
-- 
1.4.4
