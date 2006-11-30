From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 8/12]: replaces ip[6]t_entry_* with xt_entry_* in
 matches/targets
Date: Thu, 30 Nov 2006 18:51:18 +0900 (JST)
Message-ID: <200611300951.kAU9pKnw019914@toshiba.co.jp>
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



---
 extensions/libip6t_CONNMARK.c     |    8 ++++----
 extensions/libip6t_CONNSECMARK.c  |    6 +++---
 extensions/libip6t_HL.c           |    8 ++++----
 extensions/libip6t_LOG.c          |    8 ++++----
 extensions/libip6t_MARK.c         |    8 ++++----
 extensions/libip6t_NFQUEUE.c      |    8 ++++----
 extensions/libip6t_REJECT.c       |    8 ++++----
 extensions/libip6t_ROUTE.c        |    8 ++++----
 extensions/libip6t_SECMARK.c      |    8 ++++----
 extensions/libip6t_TRACE.c        |    4 ++--
 extensions/libip6t_ah.c           |    8 ++++----
 extensions/libip6t_condition.c    |    6 +++---
 extensions/libip6t_connmark.c     |    8 ++++----
 extensions/libip6t_dst.c          |    8 ++++----
 extensions/libip6t_esp.c          |    8 ++++----
 extensions/libip6t_eui64.c        |    6 +++---
 extensions/libip6t_frag.c         |    8 ++++----
 extensions/libip6t_fuzzy.c        |    8 ++++----
 extensions/libip6t_hbh.c          |    8 ++++----
 extensions/libip6t_hl.c           |    6 +++---
 extensions/libip6t_icmp6.c        |    8 ++++----
 extensions/libip6t_ipv6header.c   |    8 ++++----
 extensions/libip6t_length.c       |    6 +++---
 extensions/libip6t_limit.c        |    8 ++++----
 extensions/libip6t_mac.c          |    6 +++---
 extensions/libip6t_mark.c         |    6 +++---
 extensions/libip6t_multiport.c    |    8 ++++----
 extensions/libip6t_nth.c          |    6 +++---
 extensions/libip6t_owner.c        |    6 +++---
 extensions/libip6t_physdev.c      |    8 ++++----
 extensions/libip6t_policy.c       |    8 ++++----
 extensions/libip6t_random.c       |    8 ++++----
 extensions/libip6t_rt.c           |    8 ++++----
 extensions/libip6t_standard.c     |    6 +++---
 extensions/libip6t_state.c        |    6 +++---
 extensions/libip6t_tcp.c          |    8 ++++----
 extensions/libip6t_udp.c          |    8 ++++----
 extensions/libipt_BALANCE.c       |    8 ++++----
 extensions/libipt_CLASSIFY.c      |    8 ++++----
 extensions/libipt_CLUSTERIP.c     |    8 ++++----
 extensions/libipt_CONNMARK.c      |   10 +++++-----
 extensions/libipt_CONNSECMARK.c   |    6 +++---
 extensions/libipt_DNAT.c          |   10 +++++-----
 extensions/libipt_DSCP.c          |    8 ++++----
 extensions/libipt_ECN.c           |    8 ++++----
 extensions/libipt_FTOS.c          |   10 +++++-----
 extensions/libipt_IPMARK.c        |   10 +++++-----
 extensions/libipt_IPV4OPTSSTRIP.c |    6 +++---
 extensions/libipt_LOG.c           |    8 ++++----
 extensions/libipt_MARK.c          |   14 +++++++-------
 extensions/libipt_MASQUERADE.c    |    8 ++++----
 extensions/libipt_MIRROR.c        |    4 ++--
 extensions/libipt_NETLINK.c       |    8 ++++----
 extensions/libipt_NETMAP.c        |    8 ++++----
 extensions/libipt_NFQUEUE.c       |    8 ++++----
 extensions/libipt_NOTRACK.c       |    4 ++--
 extensions/libipt_REDIRECT.c      |    8 ++++----
 extensions/libipt_REJECT.c        |    8 ++++----
 extensions/libipt_ROUTE.c         |    8 ++++----
 extensions/libipt_SAME.c          |    8 ++++----
 extensions/libipt_SECMARK.c       |    8 ++++----
 extensions/libipt_SET.c           |    8 ++++----
 extensions/libipt_SNAT.c          |   10 +++++-----
 extensions/libipt_TARPIT.c        |    6 +++---
 extensions/libipt_TCPLAG.c        |    8 ++++----
 extensions/libipt_TCPMSS.c        |   10 +++++-----
 extensions/libipt_TOS.c           |   10 +++++-----
 extensions/libipt_TRACE.c         |    4 ++--
 extensions/libipt_TTL.c           |    8 ++++----
 extensions/libipt_ULOG.c          |    8 ++++----
 extensions/libipt_XOR.c           |    8 ++++----
 extensions/libipt_account.c       |    8 ++++----
 extensions/libipt_addrtype.c      |    6 +++---
 extensions/libipt_ah.c            |    8 ++++----
 extensions/libipt_childlevel.c    |    6 +++---
 extensions/libipt_comment.c       |    6 +++---
 extensions/libipt_condition.c     |    6 +++---
 extensions/libipt_connbytes.c     |    6 +++---
 extensions/libipt_connlimit.c     |    6 +++---
 extensions/libipt_connmark.c      |    8 ++++----
 extensions/libipt_connrate.c      |    6 +++---
 extensions/libipt_conntrack.c     |    8 ++++----
 extensions/libipt_dccp.c          |    8 ++++----
 extensions/libipt_dscp.c          |    6 +++---
 extensions/libipt_dstlimit.c      |    8 ++++----
 extensions/libipt_ecn.c           |    6 +++---
 extensions/libipt_esp.c           |    8 ++++----
 extensions/libipt_fuzzy.c         |    8 ++++----
 extensions/libipt_hashlimit.c     |    8 ++++----
 extensions/libipt_helper.c        |    6 +++---
 extensions/libipt_icmp.c          |    8 ++++----
 extensions/libipt_iprange.c       |    6 +++---
 extensions/libipt_ipv4options.c   |    6 +++---
 extensions/libipt_length.c        |    6 +++---
 extensions/libipt_limit.c         |    8 ++++----
 extensions/libipt_mac.c           |    6 +++---
 extensions/libipt_mark.c          |    6 +++---
 extensions/libipt_mport.c         |    8 ++++----
 extensions/libipt_multiport.c     |   14 +++++++-------
 extensions/libipt_nth.c           |    6 +++---
 extensions/libipt_osf.c           |    6 +++---
 extensions/libipt_owner.c         |    6 +++---
 extensions/libipt_physdev.c       |    8 ++++----
 extensions/libipt_pkttype.c       |    6 +++---
 extensions/libipt_policy.c        |    8 ++++----
 extensions/libipt_psd.c           |    8 ++++----
 extensions/libipt_quota.c         |    6 +++---
 extensions/libipt_random.c        |    8 ++++----
 extensions/libipt_realm.c         |    6 +++---
 extensions/libipt_recent.c        |    8 ++++----
 extensions/libipt_record_rpc.c    |    6 +++---
 extensions/libipt_rpc.c           |   10 +++++-----
 extensions/libipt_sctp.c          |    8 ++++----
 extensions/libipt_set.c           |    8 ++++----
 extensions/libipt_standard.c      |    6 +++---
 extensions/libipt_state.c         |    6 +++---
 extensions/libipt_statistic.c     |    6 +++---
 extensions/libipt_string.c        |    8 ++++----
 extensions/libipt_tcp.c           |    8 ++++----
 extensions/libipt_tcpmss.c        |    6 +++---
 extensions/libipt_time.c          |    8 ++++----
 extensions/libipt_tos.c           |    6 +++---
 extensions/libipt_ttl.c           |    6 +++---
 extensions/libipt_u32.c           |    6 +++---
 extensions/libipt_udp.c           |    8 ++++----
 extensions/libipt_unclean.c       |    2 +-
 126 files changed, 464 insertions(+), 464 deletions(-)

diff --git a/extensions/libip6t_CONNMARK.c b/extensions/libip6t_CONNMARK.c
index 9506f26..86b8e0f 100644
--- a/extensions/libip6t_CONNMARK.c
+++ b/extensions/libip6t_CONNMARK.c
@@ -58,7 +58,7 @@ static struct option opts[] = {
 
 /* Initialize the target. */
 static void
-init(struct ip6t_entry_target *t, unsigned int *nfcache)
+init(struct xt_entry_target *t, unsigned int *nfcache)
 {
 }
 
@@ -67,7 +67,7 @@ init(struct ip6t_entry_target *t, unsign
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ip6t_entry *entry,
-      struct ip6t_entry_target **target)
+      struct xt_entry_target **target)
 {
 	struct ipt_connmark_target_info *markinfo
 		= (struct ipt_connmark_target_info *)(*target)->data;
@@ -145,7 +145,7 @@ print_mask(const char *text, unsigned lo
 /* Prints out the target info. */
 static void
 print(const struct ip6t_ip6 *ip,
-      const struct ip6t_entry_target *target,
+      const struct xt_entry_target *target,
       int numeric)
 {
 	const struct ipt_connmark_target_info *markinfo =
@@ -174,7 +174,7 @@ print(const struct ip6t_ip6 *ip,
 
 /* Saves the target into in parsable form to stdout. */
 static void
-save(const struct ip6t_ip6 *ip, const struct ip6t_entry_target *target)
+save(const struct ip6t_ip6 *ip, const struct xt_entry_target *target)
 {
 	const struct ipt_connmark_target_info *markinfo =
 		(const struct ipt_connmark_target_info *)target->data;
diff --git a/extensions/libip6t_CONNSECMARK.c b/extensions/libip6t_CONNSECMARK.c
index b11ed07..dc6a02f 100644
--- a/extensions/libip6t_CONNSECMARK.c
+++ b/extensions/libip6t_CONNSECMARK.c
@@ -31,7 +31,7 @@ static struct option opts[] = {
 };
 
 static int parse(int c, char **argv, int invert, unsigned int *flags,
-                 const struct ip6t_entry *entry, struct ip6t_entry_target **target)
+                 const struct ip6t_entry *entry, struct xt_entry_target **target)
 {
 	struct xt_connsecmark_target_info *info =
 		(struct xt_connsecmark_target_info*)(*target)->data;
@@ -87,7 +87,7 @@ static void print_connsecmark(struct xt_
 }
 
 static void print(const struct ip6t_ip6 *ip,
-		  const struct ip6t_entry_target *target, int numeric)
+		  const struct xt_entry_target *target, int numeric)
 {
 	struct xt_connsecmark_target_info *info =
 		(struct xt_connsecmark_target_info*)(target)->data;
@@ -96,7 +96,7 @@ static void print(const struct ip6t_ip6
 	print_connsecmark(info);
 }
 
-static void save(const struct ip6t_ip6 *ip, const struct ip6t_entry_target *target)
+static void save(const struct ip6t_ip6 *ip, const struct xt_entry_target *target)
 {
 	struct xt_connsecmark_target_info *info =
 		(struct xt_connsecmark_target_info*)target->data;
diff --git a/extensions/libip6t_HL.c b/extensions/libip6t_HL.c
index 2062828..46da9ad 100644
--- a/extensions/libip6t_HL.c
+++ b/extensions/libip6t_HL.c
@@ -16,7 +16,7 @@
 
 #define IP6T_HL_USED	1
 
-static void init(struct ip6t_entry_target *t, unsigned int *nfcache) 
+static void init(struct xt_entry_target *t, unsigned int *nfcache) 
 {
 }
 
@@ -32,7 +32,7 @@ static void help(void)
 
 static int parse(int c, char **argv, int invert, unsigned int *flags,
 		const struct ip6t_entry *entry,
-		struct ip6t_entry_target **target)
+		struct xt_entry_target **target)
 {
 	struct ip6t_HL_info *info = (struct ip6t_HL_info *) (*target)->data;
 	unsigned int value;
@@ -97,7 +97,7 @@ static void final_check(unsigned int fla
 }
 
 static void save(const struct ip6t_ip6 *ip,
-		const struct ip6t_entry_target *target)
+		const struct xt_entry_target *target)
 {
 	const struct ip6t_HL_info *info = 
 		(struct ip6t_HL_info *) target->data;
@@ -118,7 +118,7 @@ static void save(const struct ip6t_ip6 *
 }
 
 static void print(const struct ip6t_ip6 *ip,
-		const struct ip6t_entry_target *target, int numeric)
+		const struct xt_entry_target *target, int numeric)
 {
 	const struct ip6t_HL_info *info =
 		(struct ip6t_HL_info *) target->data;
diff --git a/extensions/libip6t_LOG.c b/extensions/libip6t_LOG.c
index 5043b44..ad65bd5 100644
--- a/extensions/libip6t_LOG.c
+++ b/extensions/libip6t_LOG.c
@@ -44,7 +44,7 @@ static struct option opts[] = {
 
 /* Initialize the target. */
 static void
-init(struct ip6t_entry_target *t, unsigned int *nfcache)
+init(struct xt_entry_target *t, unsigned int *nfcache)
 {
 	struct ip6t_log_info *loginfo = (struct ip6t_log_info *)t->data;
 
@@ -111,7 +111,7 @@ parse_level(const char *level)
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ip6t_entry *entry,
-      struct ip6t_entry_target **target)
+      struct xt_entry_target **target)
 {
 	struct ip6t_log_info *loginfo = (struct ip6t_log_info *)(*target)->data;
 
@@ -207,7 +207,7 @@ static void final_check(unsigned int fla
 /* Prints out the targinfo. */
 static void
 print(const struct ip6t_ip6 *ip,
-      const struct ip6t_entry_target *target,
+      const struct xt_entry_target *target,
       int numeric)
 {
 	const struct ip6t_log_info *loginfo
@@ -247,7 +247,7 @@ print(const struct ip6t_ip6 *ip,
 
 /* Saves the union ip6t_targinfo in parsable form to stdout. */
 static void
-save(const struct ip6t_ip6 *ip, const struct ip6t_entry_target *target)
+save(const struct ip6t_ip6 *ip, const struct xt_entry_target *target)
 {
 	const struct ip6t_log_info *loginfo
 		= (const struct ip6t_log_info *)target->data;
diff --git a/extensions/libip6t_MARK.c b/extensions/libip6t_MARK.c
index a7f1a9d..8f19e15 100644
--- a/extensions/libip6t_MARK.c
+++ b/extensions/libip6t_MARK.c
@@ -27,7 +27,7 @@ static struct option opts[] = {
 
 /* Initialize the target. */
 static void
-init(struct ip6t_entry_target *t, unsigned int *nfcache)
+init(struct xt_entry_target *t, unsigned int *nfcache)
 {
 }
 
@@ -36,7 +36,7 @@ init(struct ip6t_entry_target *t, unsign
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ip6t_entry *entry,
-      struct ip6t_entry_target **target)
+      struct xt_entry_target **target)
 {
 	struct ip6t_mark_target_info *markinfo
 		= (struct ip6t_mark_target_info *)(*target)->data;
@@ -89,7 +89,7 @@ print_mark(unsigned long mark)
 /* Prints out the targinfo. */
 static void
 print(const struct ip6t_ip6 *ip,
-      const struct ip6t_entry_target *target,
+      const struct xt_entry_target *target,
       int numeric)
 {
 	const struct ip6t_mark_target_info *markinfo =
@@ -101,7 +101,7 @@ print(const struct ip6t_ip6 *ip,
 
 /* Saves the union ipt_targinfo in parsable form to stdout. */
 static void
-save(const struct ip6t_ip6 *ip, const struct ip6t_entry_target *target)
+save(const struct ip6t_ip6 *ip, const struct xt_entry_target *target)
 {
 	const struct ip6t_mark_target_info *markinfo =
 		(const struct ip6t_mark_target_info *)target->data;
diff --git a/extensions/libip6t_NFQUEUE.c b/extensions/libip6t_NFQUEUE.c
index e1964af..4afd8dd 100644
--- a/extensions/libip6t_NFQUEUE.c
+++ b/extensions/libip6t_NFQUEUE.c
@@ -14,7 +14,7 @@
 #include <linux/netfilter_ipv6/ip6_tables.h>
 #include <linux/netfilter_ipv4/ipt_NFQUEUE.h>
 
-static void init(struct ip6t_entry_target *t, unsigned int *nfcache) 
+static void init(struct xt_entry_target *t, unsigned int *nfcache) 
 {
 }
 
@@ -48,7 +48,7 @@ parse_num(const char *s, struct ipt_NFQ_
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ip6t_entry *entry,
-      struct ip6t_entry_target **target)
+      struct xt_entry_target **target)
 {
 	struct ipt_NFQ_info *tinfo
 		= (struct ipt_NFQ_info *)(*target)->data;
@@ -75,7 +75,7 @@ final_check(unsigned int flags)
 /* Prints out the targinfo. */
 static void
 print(const struct ip6t_ip6 *ip,
-      const struct ip6t_entry_target *target,
+      const struct xt_entry_target *target,
       int numeric)
 {
 	const struct ipt_NFQ_info *tinfo =
@@ -85,7 +85,7 @@ print(const struct ip6t_ip6 *ip,
 
 /* Saves the union ip6t_targinfo in parsable form to stdout. */
 static void
-save(const struct ip6t_ip6 *ip, const struct ip6t_entry_target *target)
+save(const struct ip6t_ip6 *ip, const struct xt_entry_target *target)
 {
 	const struct ipt_NFQ_info *tinfo =
 		(const struct ipt_NFQ_info *)target->data;
diff --git a/extensions/libip6t_REJECT.c b/extensions/libip6t_REJECT.c
index 879716b..5b3c7bf 100644
--- a/extensions/libip6t_REJECT.c
+++ b/extensions/libip6t_REJECT.c
@@ -72,7 +72,7 @@ static struct option opts[] = {
 
 /* Allocate and initialize the target. */
 static void
-init(struct ip6t_entry_target *t, unsigned int *nfcache)
+init(struct xt_entry_target *t, unsigned int *nfcache)
 {
 	struct ip6t_reject_info *reject = (struct ip6t_reject_info *)t->data;
 
@@ -86,7 +86,7 @@ init(struct ip6t_entry_target *t, unsign
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ip6t_entry *entry,
-      struct ip6t_entry_target **target)
+      struct xt_entry_target **target)
 {
 	struct ip6t_reject_info *reject = 
 		(struct ip6t_reject_info *)(*target)->data;
@@ -121,7 +121,7 @@ static void final_check(unsigned int fla
 /* Prints out ipt_reject_info. */
 static void
 print(const struct ip6t_ip6 *ip,
-      const struct ip6t_entry_target *target,
+      const struct xt_entry_target *target,
       int numeric)
 {
 	const struct ip6t_reject_info *reject
@@ -137,7 +137,7 @@ print(const struct ip6t_ip6 *ip,
 
 /* Saves ipt_reject in parsable form to stdout. */
 static void save(const struct ip6t_ip6 *ip, 
-		 const struct ip6t_entry_target *target)
+		 const struct xt_entry_target *target)
 {
 	const struct ip6t_reject_info *reject
 		= (const struct ip6t_reject_info *)target->data;
diff --git a/extensions/libip6t_ROUTE.c b/extensions/libip6t_ROUTE.c
index ad83a1d..a6de2cf 100644
--- a/extensions/libip6t_ROUTE.c
+++ b/extensions/libip6t_ROUTE.c
@@ -48,7 +48,7 @@ static struct option opts[] = {
 
 /* Initialize the target. */
 static void
-init(struct ip6t_entry_target *t, unsigned int *nfcache)
+init(struct xt_entry_target *t, unsigned int *nfcache)
 {
 	struct ip6t_route_target_info *route_info = 
 		(struct ip6t_route_target_info*)t->data;
@@ -74,7 +74,7 @@ init(struct ip6t_entry_target *t, unsign
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ip6t_entry *entry,
-      struct ip6t_entry_target **target)
+      struct xt_entry_target **target)
 {
 	struct ip6t_route_target_info *route_info = 
 		(struct ip6t_route_target_info*)(*target)->data;
@@ -167,7 +167,7 @@ final_check(unsigned int flags)
 /* Prints out the targinfo. */
 static void
 print(const struct ip6t_ip6 *ip,
-      const struct ip6t_entry_target *target,
+      const struct xt_entry_target *target,
       int numeric)
 {
 	const struct ip6t_route_target_info *route_info
@@ -196,7 +196,7 @@ print(const struct ip6t_ip6 *ip,
 
 
 static void save(const struct ip6t_ip6 *ip, 
-		 const struct ip6t_entry_target *target)
+		 const struct xt_entry_target *target)
 {
 	const struct ip6t_route_target_info *route_info
 		= (const struct ip6t_route_target_info *)target->data;
diff --git a/extensions/libip6t_SECMARK.c b/extensions/libip6t_SECMARK.c
index 8fbae05..88fbf59 100644
--- a/extensions/libip6t_SECMARK.c
+++ b/extensions/libip6t_SECMARK.c
@@ -31,7 +31,7 @@ static struct option opts[] = {
 };
 
 /* Initialize the target. */
-static void init(struct ip6t_entry_target *t, unsigned int *nfcache)
+static void init(struct xt_entry_target *t, unsigned int *nfcache)
 { }
 
 /*
@@ -39,7 +39,7 @@ static void init(struct ip6t_entry_targe
  * ate an option.
  */
 static int parse(int c, char **argv, int invert, unsigned int *flags,
-                 const struct ip6t_entry *entry, struct ip6t_entry_target **target)
+                 const struct ip6t_entry *entry, struct xt_entry_target **target)
 {
 	struct xt_secmark_target_info *info =
 		(struct xt_secmark_target_info*)(*target)->data;
@@ -86,7 +86,7 @@ static void print_secmark(struct xt_secm
 }
 
 static void print(const struct ip6t_ip6 *ip,
-		  const struct ip6t_entry_target *target, int numeric)
+		  const struct xt_entry_target *target, int numeric)
 {
 	struct xt_secmark_target_info *info =
 		(struct xt_secmark_target_info*)(target)->data;
@@ -96,7 +96,7 @@ static void print(const struct ip6t_ip6
 }
 
 /* Saves the target info in parsable form to stdout. */
-static void save(const struct ip6t_ip6 *ip, const struct ip6t_entry_target *target)
+static void save(const struct ip6t_ip6 *ip, const struct xt_entry_target *target)
 {
 	struct xt_secmark_target_info *info =
 		(struct xt_secmark_target_info*)target->data;
diff --git a/extensions/libip6t_TRACE.c b/extensions/libip6t_TRACE.c
index 00d8591..ccaf992 100644
--- a/extensions/libip6t_TRACE.c
+++ b/extensions/libip6t_TRACE.c
@@ -22,7 +22,7 @@ static struct option opts[] = {
 
 /* Initialize the target. */
 static void
-init(struct ip6t_entry_target *t, unsigned int *nfcache)
+init(struct xt_entry_target *t, unsigned int *nfcache)
 {
 }
 
@@ -31,7 +31,7 @@ init(struct ip6t_entry_target *t, unsign
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ip6t_entry *entry,
-      struct ip6t_entry_target **target)
+      struct xt_entry_target **target)
 {
 	return 0;
 }
diff --git a/extensions/libip6t_ah.c b/extensions/libip6t_ah.c
index 794e02e..5f1013d 100644
--- a/extensions/libip6t_ah.c
+++ b/extensions/libip6t_ah.c
@@ -72,7 +72,7 @@ parse_ah_spis(const char *spistring, u_i
 
 /* Initialize the match. */
 static void
-init(struct ip6t_entry_match *m, unsigned int *nfcache)
+init(struct xt_entry_match *m, unsigned int *nfcache)
 {
 	struct ip6t_ah *ahinfo = (struct ip6t_ah *)m->data;
 
@@ -87,7 +87,7 @@ static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ip6t_entry *entry,
       unsigned int *nfcache,
-      struct ip6t_entry_match **match)
+      struct xt_entry_match **match)
 {
 	struct ip6t_ah *ahinfo = (struct ip6t_ah *)(*match)->data;
 
@@ -158,7 +158,7 @@ print_len(const char *name, u_int32_t le
 /* Prints out the union ip6t_matchinfo. */
 static void
 print(const struct ip6t_ip6 *ip,
-      const struct ip6t_entry_match *match, int numeric)
+      const struct xt_entry_match *match, int numeric)
 {
 	const struct ip6t_ah *ah = (struct ip6t_ah *)match->data;
 
@@ -177,7 +177,7 @@ print(const struct ip6t_ip6 *ip,
 }
 
 /* Saves the union ip6t_matchinfo in parsable form to stdout. */
-static void save(const struct ip6t_ip6 *ip, const struct ip6t_entry_match *match)
+static void save(const struct ip6t_ip6 *ip, const struct xt_entry_match *match)
 {
 	const struct ip6t_ah *ahinfo = (struct ip6t_ah *)match->data;
 
diff --git a/extensions/libip6t_condition.c b/extensions/libip6t_condition.c
index 0e94c39..8cb4ec0 100644
--- a/extensions/libip6t_condition.c
+++ b/extensions/libip6t_condition.c
@@ -27,7 +27,7 @@ static struct option opts[] = {
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ip6t_entry *entry, unsigned int *nfcache,
-      struct ip6t_entry_match **match)
+      struct xt_entry_match **match)
 {
 	struct condition6_info *info =
 	    (struct condition6_info *) (*match)->data;
@@ -65,7 +65,7 @@ final_check(unsigned int flags)
 
 static void
 print(const struct ip6t_ip6 *ip,
-		  const struct ip6t_entry_match *match, int numeric)
+		  const struct xt_entry_match *match, int numeric)
 {
 	const struct condition6_info *info =
 	    (const struct condition6_info *) match->data;
@@ -76,7 +76,7 @@ print(const struct ip6t_ip6 *ip,
 
 static void
 save(const struct ip6t_ip6 *ip,
-		 const struct ip6t_entry_match *match)
+		 const struct xt_entry_match *match)
 {
 	const struct condition6_info *info =
 	    (const struct condition6_info *) match->data;
diff --git a/extensions/libip6t_connmark.c b/extensions/libip6t_connmark.c
index 419da30..9900af4 100644
--- a/extensions/libip6t_connmark.c
+++ b/extensions/libip6t_connmark.c
@@ -46,7 +46,7 @@ static struct option opts[] = {
 
 /* Initialize the match. */
 static void
-init(struct ip6t_entry_match *m, unsigned int *nfcache)
+init(struct xt_entry_match *m, unsigned int *nfcache)
 {
 	/* Can't cache this. */
 	*nfcache |= NFC_UNKNOWN;
@@ -58,7 +58,7 @@ static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ip6t_entry *entry,
       unsigned int *nfcache,
-      struct ip6t_entry_match **match)
+      struct xt_entry_match **match)
 {
 	struct ipt_connmark_info *markinfo = (struct ipt_connmark_info *)(*match)->data;
 
@@ -107,7 +107,7 @@ final_check(unsigned int flags)
 /* Prints out the matchinfo. */
 static void
 print(const struct ip6t_ip6 *ip,
-      const struct ip6t_entry_match *match,
+      const struct xt_entry_match *match,
       int numeric)
 {
 	struct ipt_connmark_info *info = (struct ipt_connmark_info *)match->data;
@@ -120,7 +120,7 @@ print(const struct ip6t_ip6 *ip,
 
 /* Saves the matchinfo in parsable form to stdout. */
 static void
-save(const struct ip6t_ip6 *ip, const struct ip6t_entry_match *match)
+save(const struct ip6t_ip6 *ip, const struct xt_entry_match *match)
 {
 	struct ipt_connmark_info *info = (struct ipt_connmark_info *)match->data;
 
diff --git a/extensions/libip6t_dst.c b/extensions/libip6t_dst.c
index 19ca23c..4b0cd3e 100644
--- a/extensions/libip6t_dst.c
+++ b/extensions/libip6t_dst.c
@@ -118,7 +118,7 @@ parse_options(const char *optsstr, u_int
 
 /* Initialize the match. */
 static void
-init(struct ip6t_entry_match *m, unsigned int *nfcache)
+init(struct xt_entry_match *m, unsigned int *nfcache)
 {
 	struct ip6t_opts *optinfo = (struct ip6t_opts *)m->data;
 
@@ -134,7 +134,7 @@ static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ip6t_entry *entry,
       unsigned int *nfcache,
-      struct ip6t_entry_match **match)
+      struct xt_entry_match **match)
 {
 	struct ip6t_opts *optinfo = (struct ip6t_opts *)(*match)->data;
 
@@ -204,7 +204,7 @@ print_options(int optsnr, u_int16_t *opt
 /* Prints out the union ip6t_matchinfo. */
 static void
 print(const struct ip6t_ip6 *ip,
-      const struct ip6t_entry_match *match, int numeric)
+      const struct xt_entry_match *match, int numeric)
 {
 	const struct ip6t_opts *optinfo = (struct ip6t_opts *)match->data;
 
@@ -228,7 +228,7 @@ print(const struct ip6t_ip6 *ip,
 }
 
 /* Saves the union ip6t_matchinfo in parsable form to stdout. */
-static void save(const struct ip6t_ip6 *ip, const struct ip6t_entry_match *match)
+static void save(const struct ip6t_ip6 *ip, const struct xt_entry_match *match)
 {
 	const struct ip6t_opts *optinfo = (struct ip6t_opts *)match->data;
 
diff --git a/extensions/libip6t_esp.c b/extensions/libip6t_esp.c
index 886e09b..9b031b7 100644
--- a/extensions/libip6t_esp.c
+++ b/extensions/libip6t_esp.c
@@ -70,7 +70,7 @@ parse_esp_spis(const char *spistring, u_
 
 /* Initialize the match. */
 static void
-init(struct ip6t_entry_match *m, unsigned int *nfcache)
+init(struct xt_entry_match *m, unsigned int *nfcache)
 {
 	struct ip6t_esp *espinfo = (struct ip6t_esp *)m->data;
 
@@ -85,7 +85,7 @@ static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ip6t_entry *entry,
       unsigned int *nfcache,
-      struct ip6t_entry_match **match)
+      struct xt_entry_match **match)
 {
 	struct ip6t_esp *espinfo = (struct ip6t_esp *)(*match)->data;
 
@@ -130,7 +130,7 @@ print_spis(const char *name, u_int32_t m
 /* Prints out the union ip6t_matchinfo. */
 static void
 print(const struct ip6t_ip6 *ip,
-      const struct ip6t_entry_match *match, int numeric)
+      const struct xt_entry_match *match, int numeric)
 {
 	const struct ip6t_esp *esp = (struct ip6t_esp *)match->data;
 
@@ -143,7 +143,7 @@ print(const struct ip6t_ip6 *ip,
 }
 
 /* Saves the union ip6t_matchinfo in parsable form to stdout. */
-static void save(const struct ip6t_ip6 *ip, const struct ip6t_entry_match *match)
+static void save(const struct ip6t_ip6 *ip, const struct xt_entry_match *match)
 {
 	const struct ip6t_esp *espinfo = (struct ip6t_esp *)match->data;
 
diff --git a/extensions/libip6t_eui64.c b/extensions/libip6t_eui64.c
index c74b04d..494f17a 100644
--- a/extensions/libip6t_eui64.c
+++ b/extensions/libip6t_eui64.c
@@ -32,7 +32,7 @@ static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ip6t_entry *entry,
       unsigned int *nfcache,
-      struct ip6t_entry_match **match)
+      struct xt_entry_match **match)
 {
 	return 0;
 }
@@ -45,14 +45,14 @@ static void final_check(unsigned int fla
 /* Prints out the matchinfo. */
 static void
 print(const struct ip6t_ip6 *ip,
-      const struct ip6t_entry_match *match,
+      const struct xt_entry_match *match,
       int numeric)
 {
 	printf("eui64 ");
 }
 
 /* Saves the union ip6t_matchinfo in parsable form to stdout. */
-static void save(const struct ip6t_ip6 *ip, const struct ip6t_entry_match *match)
+static void save(const struct ip6t_ip6 *ip, const struct xt_entry_match *match)
 {
 
 }
diff --git a/extensions/libip6t_frag.c b/extensions/libip6t_frag.c
index 51a14fa..44661e9 100644
--- a/extensions/libip6t_frag.c
+++ b/extensions/libip6t_frag.c
@@ -78,7 +78,7 @@ parse_frag_ids(const char *idstring, u_i
 
 /* Initialize the match. */
 static void
-init(struct ip6t_entry_match *m, unsigned int *nfcache)
+init(struct xt_entry_match *m, unsigned int *nfcache)
 {
 	struct ip6t_frag *fraginfo = (struct ip6t_frag *)m->data;
 
@@ -95,7 +95,7 @@ static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ip6t_entry *entry,
       unsigned int *nfcache,
-      struct ip6t_entry_match **match)
+      struct xt_entry_match **match)
 {
 	struct ip6t_frag *fraginfo = (struct ip6t_frag *)(*match)->data;
 
@@ -181,7 +181,7 @@ print_ids(const char *name, u_int32_t mi
 /* Prints out the union ip6t_matchinfo. */
 static void
 print(const struct ip6t_ip6 *ip,
-      const struct ip6t_entry_match *match, int numeric)
+      const struct xt_entry_match *match, int numeric)
 {
 	const struct ip6t_frag *frag = (struct ip6t_frag *)match->data;
 
@@ -213,7 +213,7 @@ print(const struct ip6t_ip6 *ip,
 }
 
 /* Saves the union ip6t_matchinfo in parsable form to stdout. */
-static void save(const struct ip6t_ip6 *ip, const struct ip6t_entry_match *match)
+static void save(const struct ip6t_ip6 *ip, const struct xt_entry_match *match)
 {
 	const struct ip6t_frag *fraginfo = (struct ip6t_frag *)match->data;
 
diff --git a/extensions/libip6t_fuzzy.c b/extensions/libip6t_fuzzy.c
index 749ddc8..ea7817e 100644
--- a/extensions/libip6t_fuzzy.c
+++ b/extensions/libip6t_fuzzy.c
@@ -41,7 +41,7 @@ static struct option opts[] = {
 
 /* Initialize data structures */
 static void
-init(struct ip6t_entry_match *m, unsigned int *nfcache)
+init(struct xt_entry_match *m, unsigned int *nfcache)
 {
 	struct ip6t_fuzzy_info *presentinfo = (struct ip6t_fuzzy_info *)(m)->data;
 	/*
@@ -60,7 +60,7 @@ static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ip6t_entry *entry,
       unsigned int *nfcache,
-      struct ip6t_entry_match **match)
+      struct xt_entry_match **match)
 {
 	struct ip6t_fuzzy_info *fuzzyinfo =
 		(struct ip6t_fuzzy_info *)(*match)->data;
@@ -115,7 +115,7 @@ static void final_check(unsigned int fla
 
 static void
 print(const struct ip6t_ip6 *ipv6,
-      const struct ip6t_entry_match *match,
+      const struct xt_entry_match *match,
       int numeric)
 {
 	const struct ip6t_fuzzy_info *fuzzyinfo
@@ -127,7 +127,7 @@ print(const struct ip6t_ip6 *ipv6,
 
 /* Saves the union ip6t_targinfo in parsable form to stdout. */
 static void
-save(const struct ip6t_ip6 *ipv6, const struct ip6t_entry_match *match)
+save(const struct ip6t_ip6 *ipv6, const struct xt_entry_match *match)
 {
 	const struct ip6t_fuzzy_info *fuzzyinfo
 		= (const struct ip6t_fuzzy_info *)match->data;
diff --git a/extensions/libip6t_hbh.c b/extensions/libip6t_hbh.c
index bdcbf9b..24a0485 100644
--- a/extensions/libip6t_hbh.c
+++ b/extensions/libip6t_hbh.c
@@ -117,7 +117,7 @@ parse_options(const char *optsstr, u_int
 
 /* Initialize the match. */
 static void
-init(struct ip6t_entry_match *m, unsigned int *nfcache)
+init(struct xt_entry_match *m, unsigned int *nfcache)
 {
 	struct ip6t_opts *optinfo = (struct ip6t_opts *)m->data;
 
@@ -133,7 +133,7 @@ static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ip6t_entry *entry,
       unsigned int *nfcache,
-      struct ip6t_entry_match **match)
+      struct xt_entry_match **match)
 {
 	struct ip6t_opts *optinfo = (struct ip6t_opts *)(*match)->data;
 
@@ -201,7 +201,7 @@ print_options(int optsnr, u_int16_t *opt
 /* Prints out the union ip6t_matchinfo. */
 static void
 print(const struct ip6t_ip6 *ip,
-      const struct ip6t_entry_match *match, int numeric)
+      const struct xt_entry_match *match, int numeric)
 {
 	const struct ip6t_opts *optinfo = (struct ip6t_opts *)match->data;
 
@@ -221,7 +221,7 @@ print(const struct ip6t_ip6 *ip,
 }
 
 /* Saves the union ip6t_matchinfo in parsable form to stdout. */
-static void save(const struct ip6t_ip6 *ip, const struct ip6t_entry_match *match)
+static void save(const struct ip6t_ip6 *ip, const struct xt_entry_match *match)
 {
 	const struct ip6t_opts *optinfo = (struct ip6t_opts *)match->data;
 
diff --git a/extensions/libip6t_hl.c b/extensions/libip6t_hl.c
index 208da33..4a4d3c5 100644
--- a/extensions/libip6t_hl.c
+++ b/extensions/libip6t_hl.c
@@ -27,7 +27,7 @@ static void help(void)
 
 static int parse(int c, char **argv, int invert, unsigned int *flags,
 		const struct ip6t_entry *entry, unsigned int *nfcache,
-		struct ip6t_entry_match **match)
+		struct xt_entry_match **match)
 {
 	struct ip6t_hl_info *info = (struct ip6t_hl_info *) (*match)->data;
 	u_int8_t value;
@@ -90,7 +90,7 @@ static void final_check(unsigned int fla
 }
 
 static void print(const struct ip6t_ip6 *ip, 
-		const struct ip6t_entry_match *match,
+		const struct xt_entry_match *match,
 		int numeric)
 {
 	static const char *op[] = {
@@ -106,7 +106,7 @@ static void print(const struct ip6t_ip6
 }
 
 static void save(const struct ip6t_ip6 *ip, 
-		const struct ip6t_entry_match *match)
+		const struct xt_entry_match *match)
 {
 	static const char *op[] = {
 		[IP6T_HL_EQ] = "eq",
diff --git a/extensions/libip6t_icmp6.c b/extensions/libip6t_icmp6.c
index 6940d0e..ac7e799 100644
--- a/extensions/libip6t_icmp6.c
+++ b/extensions/libip6t_icmp6.c
@@ -145,7 +145,7 @@ parse_icmpv6(const char *icmpv6type, u_i
 
 /* Initialize the match. */
 static void
-init(struct ip6t_entry_match *m, unsigned int *nfcache)
+init(struct xt_entry_match *m, unsigned int *nfcache)
 {
 	struct ip6t_icmp *icmpv6info = (struct ip6t_icmp *)m->data;
 
@@ -158,7 +158,7 @@ static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ip6t_entry *entry,
       unsigned int *nfcache,
-      struct ip6t_entry_match **match)
+      struct xt_entry_match **match)
 {
 	struct ip6t_icmp *icmpv6info = (struct ip6t_icmp *)(*match)->data;
 
@@ -222,7 +222,7 @@ static void print_icmpv6type(u_int8_t ty
 /* Prints out the union ipt_matchinfo. */
 static void
 print(const struct ip6t_ip6 *ip,
-      const struct ip6t_entry_match *match,
+      const struct xt_entry_match *match,
       int numeric)
 {
 	const struct ip6t_icmp *icmpv6 = (struct ip6t_icmp *)match->data;
@@ -238,7 +238,7 @@ print(const struct ip6t_ip6 *ip,
 }
 
 /* Saves the match in parsable form to stdout. */
-static void save(const struct ip6t_ip6 *ip, const struct ip6t_entry_match *match)
+static void save(const struct ip6t_ip6 *ip, const struct xt_entry_match *match)
 {
 	const struct ip6t_icmp *icmpv6 = (struct ip6t_icmp *)match->data;
 
diff --git a/extensions/libip6t_ipv6header.c b/extensions/libip6t_ipv6header.c
index a260e6e..d0bc93d 100644
--- a/extensions/libip6t_ipv6header.c
+++ b/extensions/libip6t_ipv6header.c
@@ -155,7 +155,7 @@ static struct option opts[] = {
 };
 
 static void
-init(struct ip6t_entry_match *m, unsigned int *nfcache)
+init(struct xt_entry_match *m, unsigned int *nfcache)
 {
 	struct ip6t_ipv6header_info *info = (struct ip6t_ipv6header_info *)m->data;
 
@@ -187,7 +187,7 @@ static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ip6t_entry *entry,
       unsigned int *nfcache,
-      struct ip6t_entry_match **match)
+      struct xt_entry_match **match)
 {
 	struct ip6t_ipv6header_info *info = (struct ip6t_ipv6header_info *)(*match)->data;
 
@@ -255,7 +255,7 @@ print_header(u_int8_t flags){
 /* Prints out the match */
 static void
 print(const struct ip6t_ip6 *ip,
-      const struct ip6t_entry_match *match,
+      const struct xt_entry_match *match,
       int numeric)
 {
 	const struct ip6t_ipv6header_info *info = (const struct ip6t_ipv6header_info *)match->data;
@@ -280,7 +280,7 @@ print(const struct ip6t_ip6 *ip,
 /* Saves the match */
 static void
 save(const struct ip6t_ip6 *ip,
-     const struct ip6t_entry_match *match)
+     const struct xt_entry_match *match)
 {
 
 	const struct ip6t_ipv6header_info *info = (const struct ip6t_ipv6header_info *)match->data;
diff --git a/extensions/libip6t_length.c b/extensions/libip6t_length.c
index 9f7ba16..4c77fee 100644
--- a/extensions/libip6t_length.c
+++ b/extensions/libip6t_length.c
@@ -70,7 +70,7 @@ static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ip6t_entry *entry,
       unsigned int *nfcache,
-      struct ip6t_entry_match **match)
+      struct xt_entry_match **match)
 {
 	struct ip6t_length_info *info = (struct ip6t_length_info *)(*match)->data;
 
@@ -118,7 +118,7 @@ print_length(struct ip6t_length_info *in
 /* Prints out the matchinfo. */
 static void
 print(const struct ip6t_ip6 *ip,
-      const struct ip6t_entry_match *match,
+      const struct xt_entry_match *match,
       int numeric)
 {
 	printf("length ");
@@ -127,7 +127,7 @@ print(const struct ip6t_ip6 *ip,
 
 /* Saves the union ip6t_matchinfo in parsable form to stdout. */
 static void
-save(const struct ip6t_ip6 *ip, const struct ip6t_entry_match *match)
+save(const struct ip6t_ip6 *ip, const struct xt_entry_match *match)
 {
 	printf("--length ");
 	print_length((struct ip6t_length_info *)match->data);
diff --git a/extensions/libip6t_limit.c b/extensions/libip6t_limit.c
index 6c88ee1..2a5a9b2 100644
--- a/extensions/libip6t_limit.c
+++ b/extensions/libip6t_limit.c
@@ -74,7 +74,7 @@ int parse_rate(const char *rate, u_int32
 
 /* Initialize the match. */
 static void
-init(struct ip6t_entry_match *m, unsigned int *nfcache)
+init(struct xt_entry_match *m, unsigned int *nfcache)
 {
 	struct ip6t_rateinfo *r = (struct ip6t_rateinfo *)m->data;
 
@@ -95,7 +95,7 @@ static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ip6t_entry *entry,
       unsigned int *nfcache,
-      struct ip6t_entry_match **match)
+      struct xt_entry_match **match)
 {
 	struct ip6t_rateinfo *r = (struct ip6t_rateinfo *)(*match)->data;
 	unsigned int num;
@@ -157,7 +157,7 @@ static void print_rate(u_int32_t period)
 /* Prints out the matchinfo. */
 static void
 print(const struct ip6t_ip6 *ip,
-      const struct ip6t_entry_match *match,
+      const struct xt_entry_match *match,
       int numeric)
 {
 	struct ip6t_rateinfo *r = (struct ip6t_rateinfo *)match->data;
@@ -166,7 +166,7 @@ print(const struct ip6t_ip6 *ip,
 }
 
 /* FIXME: Make minimalist: only print rate if not default --RR */
-static void save(const struct ip6t_ip6 *ip, const struct ip6t_entry_match *match)
+static void save(const struct ip6t_ip6 *ip, const struct xt_entry_match *match)
 {
 	struct ip6t_rateinfo *r = (struct ip6t_rateinfo *)match->data;
 
diff --git a/extensions/libip6t_mac.c b/extensions/libip6t_mac.c
index e47f21f..b50b0c9 100644
--- a/extensions/libip6t_mac.c
+++ b/extensions/libip6t_mac.c
@@ -58,7 +58,7 @@ static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ip6t_entry *entry,
       unsigned int *nfcache,
-      struct ip6t_entry_match **match)
+      struct xt_entry_match **match)
 {
 	struct ip6t_mac_info *macinfo = (struct ip6t_mac_info *)(*match)->data;
 
@@ -99,7 +99,7 @@ static void final_check(unsigned int fla
 /* Prints out the matchinfo. */
 static void
 print(const struct ip6t_ip6 *ip,
-      const struct ip6t_entry_match *match,
+      const struct xt_entry_match *match,
       int numeric)
 {
 	printf("MAC ");
@@ -111,7 +111,7 @@ print(const struct ip6t_ip6 *ip,
 }
 
 /* Saves the union ip6t_matchinfo in parsable form to stdout. */
-static void save(const struct ip6t_ip6 *ip, const struct ip6t_entry_match *match)
+static void save(const struct ip6t_ip6 *ip, const struct xt_entry_match *match)
 {
 	if (((struct ip6t_mac_info *)match->data)->invert)
 		printf("! ");
diff --git a/extensions/libip6t_mark.c b/extensions/libip6t_mark.c
index b831cfe..ac0fc70 100644
--- a/extensions/libip6t_mark.c
+++ b/extensions/libip6t_mark.c
@@ -31,7 +31,7 @@ static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ip6t_entry *entry,
       unsigned int *nfcache,
-      struct ip6t_entry_match **match)
+      struct xt_entry_match **match)
 {
 	struct ip6t_mark_info *markinfo = (struct ip6t_mark_info *)(*match)->data;
 
@@ -97,7 +97,7 @@ final_check(unsigned int flags)
 /* Prints out the matchinfo. */
 static void
 print(const struct ip6t_ip6 *ip,
-      const struct ip6t_entry_match *match,
+      const struct xt_entry_match *match,
       int numeric)
 {
 	struct ip6t_mark_info *info = (struct ip6t_mark_info *)match->data;
@@ -112,7 +112,7 @@ print(const struct ip6t_ip6 *ip,
 
 /* Saves the union ip6t_matchinfo in parsable form to stdout. */
 static void
-save(const struct ip6t_ip6 *ip, const struct ip6t_entry_match *match)
+save(const struct ip6t_ip6 *ip, const struct xt_entry_match *match)
 {
 	struct ip6t_mark_info *info = (struct ip6t_mark_info *)match->data;
 
diff --git a/extensions/libip6t_multiport.c b/extensions/libip6t_multiport.c
index 166abce..bb55f23 100644
--- a/extensions/libip6t_multiport.c
+++ b/extensions/libip6t_multiport.c
@@ -130,7 +130,7 @@ parse_multi_ports_v1(const char *portstr
 
 /* Initialize the match. */
 static void
-init(struct ip6t_entry_match *m, unsigned int *nfcache)
+init(struct xt_entry_match *m, unsigned int *nfcache)
 {
 }
 
@@ -155,7 +155,7 @@ static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ip6t_entry *entry,
       unsigned int *nfcache,
-      struct ip6t_entry_match **match)
+      struct xt_entry_match **match)
 {
 	const char *proto;
 	struct ip6t_multiport *multiinfo
@@ -280,7 +280,7 @@ print_port(u_int16_t port, u_int8_t prot
 /* Prints out the matchinfo. */
 static void
 print(const struct ip6t_ip6 *ip,
-      const struct ip6t_entry_match *match,
+      const struct xt_entry_match *match,
       int numeric)
 {
 	const struct ip6t_multiport *multiinfo
@@ -358,7 +358,7 @@ print_v1(const struct ip6t_ip6 *ip,
 }
 
 /* Saves the union ip6t_matchinfo in parsable form to stdout. */
-static void save(const struct ip6t_ip6 *ip, const struct ip6t_entry_match *match)
+static void save(const struct ip6t_ip6 *ip, const struct xt_entry_match *match)
 {
 	const struct ip6t_multiport *multiinfo
 		= (const struct ip6t_multiport *)match->data;
diff --git a/extensions/libip6t_nth.c b/extensions/libip6t_nth.c
index 19b13f7..f0e4197 100644
--- a/extensions/libip6t_nth.c
+++ b/extensions/libip6t_nth.c
@@ -62,7 +62,7 @@ static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ip6t_entry *entry,
       unsigned int *nfcache,
-      struct ip6t_entry_match **match)
+      struct xt_entry_match **match)
 {
 	struct ip6t_nth_info *nthinfo = (struct ip6t_nth_info *)(*match)->data;
 	unsigned int num;
@@ -176,7 +176,7 @@ static void final_check(unsigned int fla
 /* Prints out the targinfo. */
 static void
 print(const struct ip6t_ip6 *ip,
-      const struct ip6t_entry_match *match,
+      const struct xt_entry_match *match,
       int numeric)
 {
 	const struct ip6t_nth_info *nthinfo
@@ -195,7 +195,7 @@ print(const struct ip6t_ip6 *ip,
 
 /* Saves the union ip6t_targinfo in parsable form to stdout. */
 static void
-save(const struct ip6t_ip6 *ip, const struct ip6t_entry_match *match)
+save(const struct ip6t_ip6 *ip, const struct xt_entry_match *match)
 {
 	const struct ip6t_nth_info *nthinfo
 		= (const struct ip6t_nth_info *)match->data;
diff --git a/extensions/libip6t_owner.c b/extensions/libip6t_owner.c
index 99b5c13..adbe840 100644
--- a/extensions/libip6t_owner.c
+++ b/extensions/libip6t_owner.c
@@ -53,7 +53,7 @@ static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ip6t_entry *entry,
       unsigned int *nfcache,
-      struct ip6t_entry_match **match)
+      struct xt_entry_match **match)
 {
 	struct ip6t_owner_info *ownerinfo = (struct ip6t_owner_info *)(*match)->data;
 
@@ -200,7 +200,7 @@ final_check(unsigned int flags)
 /* Prints out the matchinfo. */
 static void
 print(const struct ip6t_ip6 *ip,
-      const struct ip6t_entry_match *match,
+      const struct xt_entry_match *match,
       int numeric)
 {
 	struct ip6t_owner_info *info = (struct ip6t_owner_info *)match->data;
@@ -216,7 +216,7 @@ print(const struct ip6t_ip6 *ip,
 
 /* Saves the union ip6t_matchinfo in parsable form to stdout. */
 static void
-save(const struct ip6t_ip6 *ip, const struct ip6t_entry_match *match)
+save(const struct ip6t_ip6 *ip, const struct xt_entry_match *match)
 {
 	struct ip6t_owner_info *info = (struct ip6t_owner_info *)match->data;
 
diff --git a/extensions/libip6t_physdev.c b/extensions/libip6t_physdev.c
index e7fa22e..d4df642 100644
--- a/extensions/libip6t_physdev.c
+++ b/extensions/libip6t_physdev.c
@@ -35,7 +35,7 @@ static struct option opts[] = {
 };
 
 static void
-init(struct ip6t_entry_match *m, unsigned int *nfcache)
+init(struct xt_entry_match *m, unsigned int *nfcache)
 {
 }
 
@@ -43,7 +43,7 @@ static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ip6t_entry *entry,
       unsigned int *nfcache,
-      struct ip6t_entry_match **match)
+      struct xt_entry_match **match)
 {
 	struct ip6t_physdev_info *info =
 		(struct ip6t_physdev_info*)(*match)->data;
@@ -122,7 +122,7 @@ static void final_check(unsigned int fla
 
 static void
 print(const struct ip6t_ip6 *ip,
-      const struct ip6t_entry_match *match,
+      const struct xt_entry_match *match,
       int numeric)
 {
 	struct ip6t_physdev_info *info =
@@ -148,7 +148,7 @@ print(const struct ip6t_ip6 *ip,
 	printf(" ");
 }
 
-static void save(const struct ip6t_ip6 *ip, const struct ip6t_entry_match *match)
+static void save(const struct ip6t_ip6 *ip, const struct xt_entry_match *match)
 {
 	struct ip6t_physdev_info *info =
 		(struct ip6t_physdev_info*)match->data;
diff --git a/extensions/libip6t_policy.c b/extensions/libip6t_policy.c
index 2f4453e..f5c6487 100644
--- a/extensions/libip6t_policy.c
+++ b/extensions/libip6t_policy.c
@@ -133,7 +133,7 @@ extern void parse_hostnetworkmask(const
 
 /* End duplicated code from ip6tables.c */
 
-static void init(struct ip6t_entry_match *m, unsigned int *nfcache)
+static void init(struct xt_entry_match *m, unsigned int *nfcache)
 {
 	*nfcache |= NFC_UNKNOWN;
 }
@@ -168,7 +168,7 @@ static int parse_mode(char *s)
 static int parse(int c, char **argv, int invert, unsigned int *flags,
                  const struct ip6t_entry *entry,
                  unsigned int *nfcache,
-                 struct ip6t_entry_match **match)
+                 struct xt_entry_match **match)
 {
 	struct ip6t_policy_info *info = (void *)(*match)->data;
 	struct ip6t_policy_elem *e = &info->pol[info->len];
@@ -428,7 +428,7 @@ static void print_flags(char *prefix, co
 }
 
 static void print(const struct ip6t_ip6 *ip,
-                  const struct ip6t_entry_match *match,
+                  const struct xt_entry_match *match,
 		  int numeric)
 {
 	const struct ip6t_policy_info *info = (void *)match->data;
@@ -445,7 +445,7 @@ static void print(const struct ip6t_ip6
 	printf("\n");
 }
 
-static void save(const struct ip6t_ip6 *ip, const struct ip6t_entry_match *match)
+static void save(const struct ip6t_ip6 *ip, const struct xt_entry_match *match)
 {
 	const struct ip6t_policy_info *info = (void *)match->data;
 	unsigned int i;
diff --git a/extensions/libip6t_random.c b/extensions/libip6t_random.c
index d34a230..865093c 100644
--- a/extensions/libip6t_random.c
+++ b/extensions/libip6t_random.c
@@ -49,7 +49,7 @@ static struct option opts[] = {
 
 /* Initialize the target. */
 static void
-init(struct ip6t_entry_match *m, unsigned int *nfcache)
+init(struct xt_entry_match *m, unsigned int *nfcache)
 {
 	struct ip6t_rand_info *randinfo = (struct ip6t_rand_info *)(m)->data;
 
@@ -66,7 +66,7 @@ static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ip6t_entry *entry,
       unsigned int *nfcache,
-      struct ip6t_entry_match **match)
+      struct xt_entry_match **match)
 {
 	struct ip6t_rand_info *randinfo = (struct ip6t_rand_info *)(*match)->data;
 	unsigned int num;
@@ -105,7 +105,7 @@ static void final_check(unsigned int fla
 /* Prints out the targinfo. */
 static void
 print(const struct ip6t_ip6 *ip,
-      const struct ip6t_entry_match *match,
+      const struct xt_entry_match *match,
       int numeric)
 {
 	const struct ip6t_rand_info *randinfo
@@ -119,7 +119,7 @@ print(const struct ip6t_ip6 *ip,
 
 /* Saves the union ip6t_targinfo in parsable form to stdout. */
 static void
-save(const struct ip6t_ip6 *ip, const struct ip6t_entry_match *match)
+save(const struct ip6t_ip6 *ip, const struct xt_entry_match *match)
 {
 	const struct ip6t_rand_info *randinfo
 		= (const struct ip6t_rand_info *)match->data;
diff --git a/extensions/libip6t_rt.c b/extensions/libip6t_rt.c
index 251604b..246b2da 100644
--- a/extensions/libip6t_rt.c
+++ b/extensions/libip6t_rt.c
@@ -139,7 +139,7 @@ parse_addresses(const char *addrstr, str
 
 /* Initialize the match. */
 static void
-init(struct ip6t_entry_match *m, unsigned int *nfcache)
+init(struct xt_entry_match *m, unsigned int *nfcache)
 {
 	struct ip6t_rt *rtinfo = (struct ip6t_rt *)m->data;
 
@@ -158,7 +158,7 @@ static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ip6t_entry *entry,
       unsigned int *nfcache,
-      struct ip6t_entry_match **match)
+      struct xt_entry_match **match)
 {
 	struct ip6t_rt *rtinfo = (struct ip6t_rt *)(*match)->data;
 
@@ -278,7 +278,7 @@ print_addresses(int addrnr, struct in6_a
 /* Prints out the union ip6t_matchinfo. */
 static void
 print(const struct ip6t_ip6 *ip,
-      const struct ip6t_entry_match *match, int numeric)
+      const struct xt_entry_match *match, int numeric)
 {
 	const struct ip6t_rt *rtinfo = (struct ip6t_rt *)match->data;
 
@@ -304,7 +304,7 @@ print(const struct ip6t_ip6 *ip,
 }
 
 /* Saves the union ip6t_matchinfo in parsable form to stdout. */
-static void save(const struct ip6t_ip6 *ip, const struct ip6t_entry_match *match)
+static void save(const struct ip6t_ip6 *ip, const struct xt_entry_match *match)
 {
 	const struct ip6t_rt *rtinfo = (struct ip6t_rt *)match->data;
 
diff --git a/extensions/libip6t_standard.c b/extensions/libip6t_standard.c
index c48882f..211cc8b 100644
--- a/extensions/libip6t_standard.c
+++ b/extensions/libip6t_standard.c
@@ -22,7 +22,7 @@ static struct option opts[] = {
 
 /* Initialize the target. */
 static void
-init(struct ip6t_entry_target *t, unsigned int *nfcache)
+init(struct xt_entry_target *t, unsigned int *nfcache)
 {
 }
 
@@ -31,7 +31,7 @@ init(struct ip6t_entry_target *t, unsign
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ip6t_entry *entry,
-      struct ip6t_entry_target **target)
+      struct xt_entry_target **target)
 {
 	return 0;
 }
@@ -43,7 +43,7 @@ static void final_check(unsigned int fla
 
 /* Saves the targinfo in parsable form to stdout. */
 static void
-save(const struct ip6t_ip6 *ip6, const struct ip6t_entry_target *target)
+save(const struct ip6t_ip6 *ip6, const struct xt_entry_target *target)
 {
 }
 
diff --git a/extensions/libip6t_state.c b/extensions/libip6t_state.c
index 84fd1a4..bb4214c 100644
--- a/extensions/libip6t_state.c
+++ b/extensions/libip6t_state.c
@@ -67,7 +67,7 @@ static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ip6t_entry *entry,
       unsigned int *nfcache,
-      struct ip6t_entry_match **match)
+      struct xt_entry_match **match)
 {
 	struct ipt_state_info *sinfo = (struct ipt_state_info *)(*match)->data;
 
@@ -125,7 +125,7 @@ static void print_state(unsigned int sta
 /* Prints out the matchinfo. */
 static void
 print(const struct ip6t_ip6 *ip,
-      const struct ip6t_entry_match *match,
+      const struct xt_entry_match *match,
       int numeric)
 {
 	struct ipt_state_info *sinfo = (struct ipt_state_info *)match->data;
@@ -135,7 +135,7 @@ print(const struct ip6t_ip6 *ip,
 }
 
 /* Saves the matchinfo in parsable form to stdout. */
-static void save(const struct ip6t_ip6 *ip, const struct ip6t_entry_match *match)
+static void save(const struct ip6t_ip6 *ip, const struct xt_entry_match *match)
 {
 	struct ipt_state_info *sinfo = (struct ipt_state_info *)match->data;
 
diff --git a/extensions/libip6t_tcp.c b/extensions/libip6t_tcp.c
index 734387c..1e7ac36 100644
--- a/extensions/libip6t_tcp.c
+++ b/extensions/libip6t_tcp.c
@@ -131,7 +131,7 @@ parse_tcp_option(const char *option, u_i
 
 /* Initialize the match. */
 static void
-init(struct ip6t_entry_match *m, unsigned int *nfcache)
+init(struct xt_entry_match *m, unsigned int *nfcache)
 {
 	struct ip6t_tcp *tcpinfo = (struct ip6t_tcp *)m->data;
 
@@ -149,7 +149,7 @@ static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ip6t_entry *entry,
       unsigned int *nfcache,
-      struct ip6t_entry_match **match)
+      struct xt_entry_match **match)
 {
 	struct ip6t_tcp *tcpinfo = (struct ip6t_tcp *)(*match)->data;
 
@@ -318,7 +318,7 @@ print_flags(u_int8_t mask, u_int8_t cmp,
 /* Prints out the union ipt_matchinfo. */
 static void
 print(const struct ip6t_ip6 *ip,
-      const struct ip6t_entry_match *match, int numeric)
+      const struct xt_entry_match *match, int numeric)
 {
 	const struct ip6t_tcp *tcp = (struct ip6t_tcp *)match->data;
 
@@ -341,7 +341,7 @@ print(const struct ip6t_ip6 *ip,
 }
 
 /* Saves the union ipt_matchinfo in parsable form to stdout. */
-static void save(const struct ip6t_ip6 *ip, const struct ip6t_entry_match *match)
+static void save(const struct ip6t_ip6 *ip, const struct xt_entry_match *match)
 {
 	const struct ip6t_tcp *tcpinfo = (struct ip6t_tcp *)match->data;
 
diff --git a/extensions/libip6t_udp.c b/extensions/libip6t_udp.c
index cd3c3d4..61d824f 100644
--- a/extensions/libip6t_udp.c
+++ b/extensions/libip6t_udp.c
@@ -55,7 +55,7 @@ parse_udp_ports(const char *portstring,
 
 /* Initialize the match. */
 static void
-init(struct ip6t_entry_match *m, unsigned int *nfcache)
+init(struct xt_entry_match *m, unsigned int *nfcache)
 {
 	struct ip6t_udp *udpinfo = (struct ip6t_udp *)m->data;
 
@@ -71,7 +71,7 @@ static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ip6t_entry *entry,
       unsigned int *nfcache,
-      struct ip6t_entry_match **match)
+      struct xt_entry_match **match)
 {
 	struct ip6t_udp *udpinfo = (struct ip6t_udp *)(*match)->data;
 
@@ -157,7 +157,7 @@ print_ports(const char *name, u_int16_t
 /* Prints out the union ipt_matchinfo. */
 static void
 print(const struct ip6t_ip6 *ip,
-      const struct ip6t_entry_match *match, int numeric)
+      const struct xt_entry_match *match, int numeric)
 {
 	const struct ip6t_udp *udp = (struct ip6t_udp *)match->data;
 
@@ -174,7 +174,7 @@ print(const struct ip6t_ip6 *ip,
 }
 
 /* Saves the union ipt_matchinfo in parsable form to stdout. */
-static void save(const struct ip6t_ip6 *ip, const struct ip6t_entry_match *match)
+static void save(const struct ip6t_ip6 *ip, const struct xt_entry_match *match)
 {
 	const struct ip6t_udp *udpinfo = (struct ip6t_udp *)match->data;
 
diff --git a/extensions/libipt_BALANCE.c b/extensions/libipt_BALANCE.c
index 6d6392f..6c3f88f 100644
--- a/extensions/libipt_BALANCE.c
+++ b/extensions/libipt_BALANCE.c
@@ -28,7 +28,7 @@ static struct option opts[] = {
 
 /* Initialize the target. */
 static void
-init(struct ipt_entry_target *t, unsigned int *nfcache)
+init(struct xt_entry_target *t, unsigned int *nfcache)
 {
 	struct ip_nat_multi_range *mr = (struct ip_nat_multi_range *)t->data;
 
@@ -68,7 +68,7 @@ parse_to(char *arg, struct ip_nat_range
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
-      struct ipt_entry_target **target)
+      struct xt_entry_target **target)
 {
 	struct ip_nat_multi_range *mr
 		= (struct ip_nat_multi_range *)(*target)->data;
@@ -99,7 +99,7 @@ static void final_check(unsigned int fla
 /* Prints out the targinfo. */
 static void
 print(const struct ipt_ip *ip,
-      const struct ipt_entry_target *target,
+      const struct xt_entry_target *target,
       int numeric)
 {
 	struct ip_nat_multi_range *mr
@@ -116,7 +116,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the union ipt_targinfo in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct ipt_entry_target *target)
+save(const struct ipt_ip *ip, const struct xt_entry_target *target)
 {
 	struct ip_nat_multi_range *mr
 		= (struct ip_nat_multi_range *)target->data;
diff --git a/extensions/libipt_CLASSIFY.c b/extensions/libipt_CLASSIFY.c
index 07c9b25..2e4cc15 100644
--- a/extensions/libipt_CLASSIFY.c
+++ b/extensions/libipt_CLASSIFY.c
@@ -28,7 +28,7 @@ static struct option opts[] = {
 
 /* Initialize the target. */
 static void
-init(struct ipt_entry_target *t, unsigned int *nfcache)
+init(struct xt_entry_target *t, unsigned int *nfcache)
 {
 }
 
@@ -48,7 +48,7 @@ int string_to_priority(const char *s, un
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
-      struct ipt_entry_target **target)
+      struct xt_entry_target **target)
 {
 	struct ipt_classify_target_info *clinfo
 		= (struct ipt_classify_target_info *)(*target)->data;
@@ -88,7 +88,7 @@ print_class(unsigned int priority, int n
 /* Prints out the targinfo. */
 static void
 print(const struct ipt_ip *ip,
-      const struct ipt_entry_target *target,
+      const struct xt_entry_target *target,
       int numeric)
 {
 	const struct ipt_classify_target_info *clinfo =
@@ -99,7 +99,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the union ipt_targinfo in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct ipt_entry_target *target)
+save(const struct ipt_ip *ip, const struct xt_entry_target *target)
 {
 	const struct ipt_classify_target_info *clinfo =
 		(const struct ipt_classify_target_info *)target->data;
diff --git a/extensions/libipt_CLUSTERIP.c b/extensions/libipt_CLUSTERIP.c
index 3268ac5..b6df5bd 100644
--- a/extensions/libipt_CLUSTERIP.c
+++ b/extensions/libipt_CLUSTERIP.c
@@ -55,7 +55,7 @@ static struct option opts[] = {
 };
 
 static void
-init(struct ipt_entry_target *t, unsigned int *nfcache)
+init(struct xt_entry_target *t, unsigned int *nfcache)
 {
 }
 
@@ -86,7 +86,7 @@ parse_mac(const char *mac, char *macbuf)
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
-      struct ipt_entry_target **target)
+      struct xt_entry_target **target)
 {
 	struct ipt_clusterip_tgt_info *cipinfo
 		= (struct ipt_clusterip_tgt_info *)(*target)->data;
@@ -208,7 +208,7 @@ static char *mac2str(const u_int8_t mac[
 /* Prints out the targinfo. */
 static void
 print(const struct ipt_ip *ip,
-      const struct ipt_entry_target *target,
+      const struct xt_entry_target *target,
       int numeric)
 {
 	const struct ipt_clusterip_tgt_info *cipinfo =
@@ -229,7 +229,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the union ipt_targinfo in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct ipt_entry_target *target)
+save(const struct ipt_ip *ip, const struct xt_entry_target *target)
 {
 	const struct ipt_clusterip_tgt_info *cipinfo =
 		(const struct ipt_clusterip_tgt_info *)target->data;
diff --git a/extensions/libipt_CONNMARK.c b/extensions/libipt_CONNMARK.c
index 2e17b3f..54f33c9 100644
--- a/extensions/libipt_CONNMARK.c
+++ b/extensions/libipt_CONNMARK.c
@@ -30,7 +30,7 @@
 
 #if 0
 struct markinfo {
-	struct ipt_entry_target t;
+	struct xt_entry_target t;
 	struct ipt_connmark_target_info mark;
 };
 #endif
@@ -58,7 +58,7 @@ static struct option opts[] = {
 
 /* Initialize the target. */
 static void
-init(struct ipt_entry_target *t, unsigned int *nfcache)
+init(struct xt_entry_target *t, unsigned int *nfcache)
 {
 }
 
@@ -67,7 +67,7 @@ init(struct ipt_entry_target *t, unsigne
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
-      struct ipt_entry_target **target)
+      struct xt_entry_target **target)
 {
 	struct ipt_connmark_target_info *markinfo
 		= (struct ipt_connmark_target_info *)(*target)->data;
@@ -145,7 +145,7 @@ print_mask(const char *text, unsigned lo
 /* Prints out the target info. */
 static void
 print(const struct ipt_ip *ip,
-      const struct ipt_entry_target *target,
+      const struct xt_entry_target *target,
       int numeric)
 {
 	const struct ipt_connmark_target_info *markinfo =
@@ -174,7 +174,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the target into in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct ipt_entry_target *target)
+save(const struct ipt_ip *ip, const struct xt_entry_target *target)
 {
 	const struct ipt_connmark_target_info *markinfo =
 		(const struct ipt_connmark_target_info *)target->data;
diff --git a/extensions/libipt_CONNSECMARK.c b/extensions/libipt_CONNSECMARK.c
index 237a41f..e8dd380 100644
--- a/extensions/libipt_CONNSECMARK.c
+++ b/extensions/libipt_CONNSECMARK.c
@@ -31,7 +31,7 @@ static struct option opts[] = {
 };
 
 static int parse(int c, char **argv, int invert, unsigned int *flags,
-                 const struct ipt_entry *entry, struct ipt_entry_target **target)
+                 const struct ipt_entry *entry, struct xt_entry_target **target)
 {
 	struct xt_connsecmark_target_info *info =
 		(struct xt_connsecmark_target_info*)(*target)->data;
@@ -87,7 +87,7 @@ static void print_connsecmark(struct xt_
 }
 
 static void print(const struct ipt_ip *ip,
-		  const struct ipt_entry_target *target, int numeric)
+		  const struct xt_entry_target *target, int numeric)
 {
 	struct xt_connsecmark_target_info *info =
 		(struct xt_connsecmark_target_info*)(target)->data;
@@ -96,7 +96,7 @@ static void print(const struct ipt_ip *i
 	print_connsecmark(info);
 }
 
-static void save(const struct ipt_ip *ip, const struct ipt_entry_target *target)
+static void save(const struct ipt_ip *ip, const struct xt_entry_target *target)
 {
 	struct xt_connsecmark_target_info *info =
 		(struct xt_connsecmark_target_info*)target->data;
diff --git a/extensions/libipt_DNAT.c b/extensions/libipt_DNAT.c
index bdc15eb..3a5740b 100644
--- a/extensions/libipt_DNAT.c
+++ b/extensions/libipt_DNAT.c
@@ -12,7 +12,7 @@
    to. */
 struct ipt_natinfo
 {
-	struct ipt_entry_target t;
+	struct xt_entry_target t;
 	struct ip_nat_multi_range mr;
 };
 
@@ -53,7 +53,7 @@ append_range(struct ipt_natinfo *info, c
 }
 
 /* Ranges expected in network order. */
-static struct ipt_entry_target *
+static struct xt_entry_target *
 parse_to(char *arg, int portok, struct ipt_natinfo *info)
 {
 	struct ip_nat_range range;
@@ -137,7 +137,7 @@ parse_to(char *arg, int portok, struct i
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
-      struct ipt_entry_target **target)
+      struct xt_entry_target **target)
 {
 	struct ipt_natinfo *info = (void *)*target;
 	int portok;
@@ -202,7 +202,7 @@ static void print_range(const struct ip_
 /* Prints out the targinfo. */
 static void
 print(const struct ipt_ip *ip,
-      const struct ipt_entry_target *target,
+      const struct xt_entry_target *target,
       int numeric)
 {
 	struct ipt_natinfo *info = (void *)target;
@@ -217,7 +217,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the union ipt_targinfo in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct ipt_entry_target *target)
+save(const struct ipt_ip *ip, const struct xt_entry_target *target)
 {
 	struct ipt_natinfo *info = (void *)target;
 	unsigned int i = 0;
diff --git a/extensions/libipt_DSCP.c b/extensions/libipt_DSCP.c
index c50d902..d86bbc9 100644
--- a/extensions/libipt_DSCP.c
+++ b/extensions/libipt_DSCP.c
@@ -22,7 +22,7 @@
 #include "libipt_dscp_helper.c"
 
 
-static void init(struct ipt_entry_target *t, unsigned int *nfcache) 
+static void init(struct xt_entry_target *t, unsigned int *nfcache) 
 {
 }
 
@@ -79,7 +79,7 @@ parse_class(const char *s, struct ipt_DS
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
-      struct ipt_entry_target **target)
+      struct xt_entry_target **target)
 {
 	struct ipt_DSCP_info *dinfo
 		= (struct ipt_DSCP_info *)(*target)->data;
@@ -124,7 +124,7 @@ print_dscp(u_int8_t dscp, int numeric)
 /* Prints out the targinfo. */
 static void
 print(const struct ipt_ip *ip,
-      const struct ipt_entry_target *target,
+      const struct xt_entry_target *target,
       int numeric)
 {
 	const struct ipt_DSCP_info *dinfo =
@@ -135,7 +135,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the union ipt_targinfo in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct ipt_entry_target *target)
+save(const struct ipt_ip *ip, const struct xt_entry_target *target)
 {
 	const struct ipt_DSCP_info *dinfo =
 		(const struct ipt_DSCP_info *)target->data;
diff --git a/extensions/libipt_ECN.c b/extensions/libipt_ECN.c
index 7e8d0c4..f3adca1 100644
--- a/extensions/libipt_ECN.c
+++ b/extensions/libipt_ECN.c
@@ -17,7 +17,7 @@
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_ECN.h>
 
-static void init(struct ipt_entry_target *t, unsigned int *nfcache) 
+static void init(struct xt_entry_target *t, unsigned int *nfcache) 
 {
 }
 
@@ -48,7 +48,7 @@ static struct option opts[] = {
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
-      struct ipt_entry_target **target)
+      struct xt_entry_target **target)
 {
 	unsigned int result;
 	struct ipt_ECN_info *einfo
@@ -115,7 +115,7 @@ final_check(unsigned int flags)
 /* Prints out the targinfo. */
 static void
 print(const struct ipt_ip *ip,
-      const struct ipt_entry_target *target,
+      const struct xt_entry_target *target,
       int numeric)
 {
 	const struct ipt_ECN_info *einfo =
@@ -141,7 +141,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the union ipt_targinfo in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct ipt_entry_target *target)
+save(const struct ipt_ip *ip, const struct xt_entry_target *target)
 {
 	const struct ipt_ECN_info *einfo =
 		(const struct ipt_ECN_info *)target->data;
diff --git a/extensions/libipt_FTOS.c b/extensions/libipt_FTOS.c
index 62df4cd..75b5fc9 100644
--- a/extensions/libipt_FTOS.c
+++ b/extensions/libipt_FTOS.c
@@ -17,11 +17,11 @@
 #include <linux/netfilter_ipv4/ipt_FTOS.h>
 
 struct finfo {
- 	struct ipt_entry_target t;
+ 	struct xt_entry_target t;
 	u_int8_t ftos;
 };
 
-static void init(struct ipt_entry_target *t, unsigned int *nfcache) 
+static void init(struct xt_entry_target *t, unsigned int *nfcache) 
 {
 }
 
@@ -55,7 +55,7 @@ parse_ftos(const unsigned char *s, struc
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
-      struct ipt_entry_target **target)
+      struct xt_entry_target **target)
 {
 	struct ipt_FTOS_info *finfo
 		= (struct ipt_FTOS_info *)(*target)->data;
@@ -93,7 +93,7 @@ print_ftos(u_int8_t ftos, int numeric)
 /* Prints out the targinfo. */
 static void
 print(const struct ipt_ip *ip,
-      const struct ipt_entry_target *target,
+      const struct xt_entry_target *target,
       int numeric)
 {
 	const struct ipt_FTOS_info *finfo =
@@ -104,7 +104,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the union ipt_targinfo in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct ipt_entry_target *target)
+save(const struct ipt_ip *ip, const struct xt_entry_target *target)
 {
 	const struct ipt_FTOS_info *finfo =
 		(const struct ipt_FTOS_info *)target->data;
diff --git a/extensions/libipt_IPMARK.c b/extensions/libipt_IPMARK.c
index 3e0942d..0646d60 100644
--- a/extensions/libipt_IPMARK.c
+++ b/extensions/libipt_IPMARK.c
@@ -19,7 +19,7 @@
 #define IPT_OR_MASK_USED     4
 
 struct ipmarkinfo {
-	struct ipt_entry_target t;
+	struct xt_entry_target t;
 	struct ipt_ipmark_target_info ipmark;
 };
 
@@ -45,7 +45,7 @@ static struct option opts[] = {
 
 /* Initialize the target. */
 static void
-init(struct ipt_entry_target *t, unsigned int *nfcache)
+init(struct xt_entry_target *t, unsigned int *nfcache)
 {
 	struct ipt_ipmark_target_info *ipmarkinfo =
 		(struct ipt_ipmark_target_info *)t->data;
@@ -60,7 +60,7 @@ init(struct ipt_entry_target *t, unsigne
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
-      struct ipt_entry_target **target)
+      struct xt_entry_target **target)
 {
 	struct ipt_ipmark_target_info *ipmarkinfo
 		= (struct ipt_ipmark_target_info *)(*target)->data;
@@ -117,7 +117,7 @@ final_check(unsigned int flags)
 /* Prints out the targinfo. */
 static void
 print(const struct ipt_ip *ip,
-      const struct ipt_entry_target *target,
+      const struct xt_entry_target *target,
       int numeric)
 {
 	const struct ipt_ipmark_target_info *ipmarkinfo =
@@ -132,7 +132,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the union ipt_targinfo in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct ipt_entry_target *target)
+save(const struct ipt_ip *ip, const struct xt_entry_target *target)
 {
 	const struct ipt_ipmark_target_info *ipmarkinfo =
 		(const struct ipt_ipmark_target_info *)target->data;
diff --git a/extensions/libipt_IPV4OPTSSTRIP.c b/extensions/libipt_IPV4OPTSSTRIP.c
index d0305e6..3b569bd 100644
--- a/extensions/libipt_IPV4OPTSSTRIP.c
+++ b/extensions/libipt_IPV4OPTSSTRIP.c
@@ -28,7 +28,7 @@ static struct option opts[] = {
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
-      struct ipt_entry_target **target)
+      struct xt_entry_target **target)
 {
 	return 0;
 }
@@ -41,7 +41,7 @@ final_check(unsigned int flags)
 /* Prints out the targinfo. */
 static void
 print(const struct ipt_ip *ip,
-      const struct ipt_entry_target *target,
+      const struct xt_entry_target *target,
       int numeric)
 {
 	/* nothing to print, we don't take option... */
@@ -49,7 +49,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the stuff in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct ipt_entry_target *target)
+save(const struct ipt_ip *ip, const struct xt_entry_target *target)
 {
 	/* nothing to print, we don't take option... */
 }
diff --git a/extensions/libipt_LOG.c b/extensions/libipt_LOG.c
index 96cc701..1141808 100644
--- a/extensions/libipt_LOG.c
+++ b/extensions/libipt_LOG.c
@@ -44,7 +44,7 @@ static struct option opts[] = {
 
 /* Initialize the target. */
 static void
-init(struct ipt_entry_target *t, unsigned int *nfcache)
+init(struct xt_entry_target *t, unsigned int *nfcache)
 {
 	struct ipt_log_info *loginfo = (struct ipt_log_info *)t->data;
 
@@ -111,7 +111,7 @@ parse_level(const char *level)
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
-      struct ipt_entry_target **target)
+      struct xt_entry_target **target)
 {
 	struct ipt_log_info *loginfo = (struct ipt_log_info *)(*target)->data;
 
@@ -207,7 +207,7 @@ static void final_check(unsigned int fla
 /* Prints out the targinfo. */
 static void
 print(const struct ipt_ip *ip,
-      const struct ipt_entry_target *target,
+      const struct xt_entry_target *target,
       int numeric)
 {
 	const struct ipt_log_info *loginfo
@@ -247,7 +247,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the union ipt_targinfo in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct ipt_entry_target *target)
+save(const struct ipt_ip *ip, const struct xt_entry_target *target)
 {
 	const struct ipt_log_info *loginfo
 		= (const struct ipt_log_info *)target->data;
diff --git a/extensions/libipt_MARK.c b/extensions/libipt_MARK.c
index 457f6ad..66ba168 100644
--- a/extensions/libipt_MARK.c
+++ b/extensions/libipt_MARK.c
@@ -31,7 +31,7 @@ static struct option opts[] = {
 
 /* Initialize the target. */
 static void
-init(struct ipt_entry_target *t, unsigned int *nfcache)
+init(struct xt_entry_target *t, unsigned int *nfcache)
 {
 }
 
@@ -40,7 +40,7 @@ init(struct ipt_entry_target *t, unsigne
 static int
 parse_v0(int c, char **argv, int invert, unsigned int *flags,
 	 const struct ipt_entry *entry,
-	 struct ipt_entry_target **target)
+	 struct xt_entry_target **target)
 {
 	struct ipt_mark_target_info *markinfo
 		= (struct ipt_mark_target_info *)(*target)->data;
@@ -87,7 +87,7 @@ final_check(unsigned int flags)
 static int
 parse_v1(int c, char **argv, int invert, unsigned int *flags,
 	 const struct ipt_entry *entry,
-	 struct ipt_entry_target **target)
+	 struct xt_entry_target **target)
 {
 	struct ipt_mark_target_info_v1 *markinfo
 		= (struct ipt_mark_target_info_v1 *)(*target)->data;
@@ -138,7 +138,7 @@ print_mark(unsigned long mark)
 /* Prints out the targinfo. */
 static void
 print_v0(const struct ipt_ip *ip,
-	 const struct ipt_entry_target *target,
+	 const struct xt_entry_target *target,
 	 int numeric)
 {
 	const struct ipt_mark_target_info *markinfo =
@@ -149,7 +149,7 @@ print_v0(const struct ipt_ip *ip,
 
 /* Saves the union ipt_targinfo in parsable form to stdout. */
 static void
-save_v0(const struct ipt_ip *ip, const struct ipt_entry_target *target)
+save_v0(const struct ipt_ip *ip, const struct xt_entry_target *target)
 {
 	const struct ipt_mark_target_info *markinfo =
 		(const struct ipt_mark_target_info *)target->data;
@@ -161,7 +161,7 @@ save_v0(const struct ipt_ip *ip, const s
 /* Prints out the targinfo. */
 static void
 print_v1(const struct ipt_ip *ip,
-	 const struct ipt_entry_target *target,
+	 const struct xt_entry_target *target,
 	 int numeric)
 {
 	const struct ipt_mark_target_info_v1 *markinfo =
@@ -183,7 +183,7 @@ print_v1(const struct ipt_ip *ip,
 
 /* Saves the union ipt_targinfo in parsable form to stdout. */
 static void
-save_v1(const struct ipt_ip *ip, const struct ipt_entry_target *target)
+save_v1(const struct ipt_ip *ip, const struct xt_entry_target *target)
 {
 	const struct ipt_mark_target_info_v1 *markinfo =
 		(const struct ipt_mark_target_info_v1 *)target->data;
diff --git a/extensions/libipt_MASQUERADE.c b/extensions/libipt_MASQUERADE.c
index 7eddcc0..60047fe 100644
--- a/extensions/libipt_MASQUERADE.c
+++ b/extensions/libipt_MASQUERADE.c
@@ -26,7 +26,7 @@ static struct option opts[] = {
 
 /* Initialize the target. */
 static void
-init(struct ipt_entry_target *t, unsigned int *nfcache)
+init(struct xt_entry_target *t, unsigned int *nfcache)
 {
 	struct ip_nat_multi_range *mr = (struct ip_nat_multi_range *)t->data;
 
@@ -74,7 +74,7 @@ parse_ports(const char *arg, struct ip_n
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
-      struct ipt_entry_target **target)
+      struct xt_entry_target **target)
 {
 	int portok;
 	struct ip_nat_multi_range *mr
@@ -113,7 +113,7 @@ static void final_check(unsigned int fla
 /* Prints out the targinfo. */
 static void
 print(const struct ipt_ip *ip,
-      const struct ipt_entry_target *target,
+      const struct xt_entry_target *target,
       int numeric)
 {
 	struct ip_nat_multi_range *mr
@@ -131,7 +131,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the union ipt_targinfo in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct ipt_entry_target *target)
+save(const struct ipt_ip *ip, const struct xt_entry_target *target)
 {
 	struct ip_nat_multi_range *mr
 		= (struct ip_nat_multi_range *)target->data;
diff --git a/extensions/libipt_MIRROR.c b/extensions/libipt_MIRROR.c
index 7e61703..9141bd1 100644
--- a/extensions/libipt_MIRROR.c
+++ b/extensions/libipt_MIRROR.c
@@ -22,7 +22,7 @@ static struct option opts[] = {
 
 /* Initialize the target. */
 static void
-init(struct ipt_entry_target *t, unsigned int *nfcache)
+init(struct xt_entry_target *t, unsigned int *nfcache)
 {
 }
 
@@ -31,7 +31,7 @@ init(struct ipt_entry_target *t, unsigne
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
-      struct ipt_entry_target **target)
+      struct xt_entry_target **target)
 {
 	return 0;
 }
diff --git a/extensions/libipt_NETLINK.c b/extensions/libipt_NETLINK.c
index 403c413..371b90b 100644
--- a/extensions/libipt_NETLINK.c
+++ b/extensions/libipt_NETLINK.c
@@ -26,7 +26,7 @@ static struct option opts[] = {
 	{0}
 };
 
-static void init(struct ipt_entry_target *t, unsigned int *nfcache)
+static void init(struct xt_entry_target *t, unsigned int *nfcache)
 {
 	struct ipt_nldata *nld = (struct ipt_nldata *) t->data;
 	
@@ -37,7 +37,7 @@ static void init(struct ipt_entry_target
 /* Parse command options */
 static int parse(int c, char **argv, int invert, unsigned int *flags,
 		 const struct ipt_entry *entry,
-		 struct ipt_entry_target **target)
+		 struct xt_entry_target **target)
 {
 	struct ipt_nldata *nld=(struct ipt_nldata *)(*target)->data;
 
@@ -102,7 +102,7 @@ static void final_check(unsigned int fla
 
 /* Saves the union ipt_targinfo in parsable form to stdout. */
 static void save(const struct ipt_ip *ip,
-		 const struct ipt_entry_target *target)
+		 const struct xt_entry_target *target)
 {
 	const struct ipt_nldata *nld
 	    = (const struct ipt_nldata *) target->data;
@@ -120,7 +120,7 @@ static void save(const struct ipt_ip *ip
 /* Prints out the targinfo. */
 static void
 print(const struct ipt_ip *ip,
-      const struct ipt_entry_target *target, int numeric)
+      const struct xt_entry_target *target, int numeric)
 {
 	const struct ipt_nldata *nld
 	    = (const struct ipt_nldata *) target->data;
diff --git a/extensions/libipt_NETMAP.c b/extensions/libipt_NETMAP.c
index 8cecb4d..c91ab36 100644
--- a/extensions/libipt_NETMAP.c
+++ b/extensions/libipt_NETMAP.c
@@ -56,7 +56,7 @@ netmask2bits(u_int32_t netmask)
 
 /* Initialize the target. */
 static void
-init(struct ipt_entry_target *t, unsigned int *nfcache)
+init(struct xt_entry_target *t, unsigned int *nfcache)
 {
 	struct ip_nat_multi_range *mr = (struct ip_nat_multi_range *)t->data;
 
@@ -119,7 +119,7 @@ parse_to(char *arg, struct ip_nat_range
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
-      struct ipt_entry_target **target)
+      struct xt_entry_target **target)
 {
 	struct ip_nat_multi_range *mr
 		= (struct ip_nat_multi_range *)(*target)->data;
@@ -150,7 +150,7 @@ static void final_check(unsigned int fla
 /* Prints out the targinfo. */
 static void
 print(const struct ipt_ip *ip,
-      const struct ipt_entry_target *target,
+      const struct xt_entry_target *target,
       int numeric)
 {
 	struct ip_nat_multi_range *mr
@@ -171,7 +171,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the targinfo in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct ipt_entry_target *target)
+save(const struct ipt_ip *ip, const struct xt_entry_target *target)
 {
 	printf("--%s ", opts[0].name);
 	print(ip, target, 0);
diff --git a/extensions/libipt_NFQUEUE.c b/extensions/libipt_NFQUEUE.c
index bc4e82f..fe14905 100644
--- a/extensions/libipt_NFQUEUE.c
+++ b/extensions/libipt_NFQUEUE.c
@@ -14,7 +14,7 @@
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_NFQUEUE.h>
 
-static void init(struct ipt_entry_target *t, unsigned int *nfcache) 
+static void init(struct xt_entry_target *t, unsigned int *nfcache) 
 {
 }
 
@@ -48,7 +48,7 @@ parse_num(const char *s, struct ipt_NFQ_
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
-      struct ipt_entry_target **target)
+      struct xt_entry_target **target)
 {
 	struct ipt_NFQ_info *tinfo
 		= (struct ipt_NFQ_info *)(*target)->data;
@@ -75,7 +75,7 @@ final_check(unsigned int flags)
 /* Prints out the targinfo. */
 static void
 print(const struct ipt_ip *ip,
-      const struct ipt_entry_target *target,
+      const struct xt_entry_target *target,
       int numeric)
 {
 	const struct ipt_NFQ_info *tinfo =
@@ -85,7 +85,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the union ipt_targinfo in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct ipt_entry_target *target)
+save(const struct ipt_ip *ip, const struct xt_entry_target *target)
 {
 	const struct ipt_NFQ_info *tinfo =
 		(const struct ipt_NFQ_info *)target->data;
diff --git a/extensions/libipt_NOTRACK.c b/extensions/libipt_NOTRACK.c
index 39489ae..c0d40f2 100644
--- a/extensions/libipt_NOTRACK.c
+++ b/extensions/libipt_NOTRACK.c
@@ -22,7 +22,7 @@ static struct option opts[] = {
 
 /* Initialize the target. */
 static void
-init(struct ipt_entry_target *t, unsigned int *nfcache)
+init(struct xt_entry_target *t, unsigned int *nfcache)
 {
 }
 
@@ -31,7 +31,7 @@ init(struct ipt_entry_target *t, unsigne
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
-      struct ipt_entry_target **target)
+      struct xt_entry_target **target)
 {
 	return 0;
 }
diff --git a/extensions/libipt_REDIRECT.c b/extensions/libipt_REDIRECT.c
index 13195b0..9805b38 100644
--- a/extensions/libipt_REDIRECT.c
+++ b/extensions/libipt_REDIRECT.c
@@ -26,7 +26,7 @@ static struct option opts[] = {
 
 /* Initialize the target. */
 static void
-init(struct ipt_entry_target *t, unsigned int *nfcache)
+init(struct xt_entry_target *t, unsigned int *nfcache)
 {
 	struct ip_nat_multi_range *mr = (struct ip_nat_multi_range *)t->data;
 
@@ -77,7 +77,7 @@ parse_ports(const char *arg, struct ip_n
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
-      struct ipt_entry_target **target)
+      struct xt_entry_target **target)
 {
 	struct ip_nat_multi_range *mr
 		= (struct ip_nat_multi_range *)(*target)->data;
@@ -116,7 +116,7 @@ static void final_check(unsigned int fla
 /* Prints out the targinfo. */
 static void
 print(const struct ipt_ip *ip,
-      const struct ipt_entry_target *target,
+      const struct xt_entry_target *target,
       int numeric)
 {
 	struct ip_nat_multi_range *mr
@@ -134,7 +134,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the union ipt_targinfo in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct ipt_entry_target *target)
+save(const struct ipt_ip *ip, const struct xt_entry_target *target)
 {
 	struct ip_nat_multi_range *mr
 		= (struct ip_nat_multi_range *)target->data;
diff --git a/extensions/libipt_REJECT.c b/extensions/libipt_REJECT.c
index 70859eb..4f8f06d 100644
--- a/extensions/libipt_REJECT.c
+++ b/extensions/libipt_REJECT.c
@@ -87,7 +87,7 @@ static struct option opts[] = {
 
 /* Allocate and initialize the target. */
 static void
-init(struct ipt_entry_target *t, unsigned int *nfcache)
+init(struct xt_entry_target *t, unsigned int *nfcache)
 {
 	struct ipt_reject_info *reject = (struct ipt_reject_info *)t->data;
 
@@ -101,7 +101,7 @@ init(struct ipt_entry_target *t, unsigne
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
-      struct ipt_entry_target **target)
+      struct xt_entry_target **target)
 {
 	struct ipt_reject_info *reject = (struct ipt_reject_info *)(*target)->data;
 	unsigned int limit = sizeof(reject_table)/sizeof(struct reject_names);
@@ -140,7 +140,7 @@ static void final_check(unsigned int fla
 /* Prints out ipt_reject_info. */
 static void
 print(const struct ipt_ip *ip,
-      const struct ipt_entry_target *target,
+      const struct xt_entry_target *target,
       int numeric)
 {
 	const struct ipt_reject_info *reject
@@ -155,7 +155,7 @@ print(const struct ipt_ip *ip,
 }
 
 /* Saves ipt_reject in parsable form to stdout. */
-static void save(const struct ipt_ip *ip, const struct ipt_entry_target *target)
+static void save(const struct ipt_ip *ip, const struct xt_entry_target *target)
 {
 	const struct ipt_reject_info *reject
 		= (const struct ipt_reject_info *)target->data;
diff --git a/extensions/libipt_ROUTE.c b/extensions/libipt_ROUTE.c
index 360f983..3904121 100644
--- a/extensions/libipt_ROUTE.c
+++ b/extensions/libipt_ROUTE.c
@@ -49,7 +49,7 @@ static struct option opts[] = {
 
 /* Initialize the target. */
 static void
-init(struct ipt_entry_target *t, unsigned int *nfcache)
+init(struct xt_entry_target *t, unsigned int *nfcache)
 {
 	struct ipt_route_target_info *route_info = 
 		(struct ipt_route_target_info*)t->data;
@@ -72,7 +72,7 @@ init(struct ipt_entry_target *t, unsigne
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
-      struct ipt_entry_target **target)
+      struct xt_entry_target **target)
 {
 	struct ipt_route_target_info *route_info = 
 		(struct ipt_route_target_info*)(*target)->data;
@@ -190,7 +190,7 @@ final_check(unsigned int flags)
 /* Prints out the targinfo. */
 static void
 print(const struct ipt_ip *ip,
-      const struct ipt_entry_target *target,
+      const struct xt_entry_target *target,
       int numeric)
 {
 	const struct ipt_route_target_info *route_info
@@ -219,7 +219,7 @@ print(const struct ipt_ip *ip,
 
 
 static void save(const struct ipt_ip *ip, 
-		 const struct ipt_entry_target *target)
+		 const struct xt_entry_target *target)
 {
 	const struct ipt_route_target_info *route_info
 		= (const struct ipt_route_target_info *)target->data;
diff --git a/extensions/libipt_SAME.c b/extensions/libipt_SAME.c
index 4eda223..d084b30 100644
--- a/extensions/libipt_SAME.c
+++ b/extensions/libipt_SAME.c
@@ -34,7 +34,7 @@ static struct option opts[] = {
 
 /* Initialize the target. */
 static void
-init(struct ipt_entry_target *t, unsigned int *nfcache)
+init(struct xt_entry_target *t, unsigned int *nfcache)
 {
 	struct ipt_same_info *mr = (struct ipt_same_info *)t->data;
 
@@ -85,7 +85,7 @@ parse_to(char *arg, struct ip_nat_range
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
-      struct ipt_entry_target **target)
+      struct xt_entry_target **target)
 {
 	struct ipt_same_info *mr
 		= (struct ipt_same_info *)(*target)->data;
@@ -133,7 +133,7 @@ static void final_check(unsigned int fla
 /* Prints out the targinfo. */
 static void
 print(const struct ipt_ip *ip,
-      const struct ipt_entry_target *target,
+      const struct xt_entry_target *target,
       int numeric)
 {
 	int count;
@@ -163,7 +163,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the union ipt_targinfo in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct ipt_entry_target *target)
+save(const struct ipt_ip *ip, const struct xt_entry_target *target)
 {
 	int count;
 	struct ipt_same_info *mr
diff --git a/extensions/libipt_SECMARK.c b/extensions/libipt_SECMARK.c
index 89a2b2a..6dc9160 100644
--- a/extensions/libipt_SECMARK.c
+++ b/extensions/libipt_SECMARK.c
@@ -29,7 +29,7 @@ static struct option opts[] = {
 };
 
 /* Initialize the target. */
-static void init(struct ipt_entry_target *t, unsigned int *nfcache)
+static void init(struct xt_entry_target *t, unsigned int *nfcache)
 { }
 
 /*
@@ -37,7 +37,7 @@ static void init(struct ipt_entry_target
  * ate an option.
  */
 static int parse(int c, char **argv, int invert, unsigned int *flags,
-                 const struct ipt_entry *entry, struct ipt_entry_target **target)
+                 const struct ipt_entry *entry, struct xt_entry_target **target)
 {
 	struct xt_secmark_target_info *info =
 		(struct xt_secmark_target_info*)(*target)->data;
@@ -84,7 +84,7 @@ static void print_secmark(struct xt_secm
 }
 
 static void print(const struct ipt_ip *ip,
-		  const struct ipt_entry_target *target, int numeric)
+		  const struct xt_entry_target *target, int numeric)
 {
 	struct xt_secmark_target_info *info =
 		(struct xt_secmark_target_info*)(target)->data;
@@ -94,7 +94,7 @@ static void print(const struct ipt_ip *i
 }
 
 /* Saves the target info in parsable form to stdout. */
-static void save(const struct ipt_ip *ip, const struct ipt_entry_target *target)
+static void save(const struct ipt_ip *ip, const struct xt_entry_target *target)
 {
 	struct xt_secmark_target_info *info =
 		(struct xt_secmark_target_info*)target->data;
diff --git a/extensions/libipt_SET.c b/extensions/libipt_SET.c
index d11a9f0..598cead 100644
--- a/extensions/libipt_SET.c
+++ b/extensions/libipt_SET.c
@@ -42,7 +42,7 @@ static struct option opts[] = {
 };
 
 /* Initialize the target. */
-static void init(struct ipt_entry_target *target, unsigned int *nfcache)
+static void init(struct xt_entry_target *target, unsigned int *nfcache)
 {
 	struct ipt_set_info_target *info =
 	    (struct ipt_set_info_target *) target->data;
@@ -86,7 +86,7 @@ parse_target(char **argv, int invert, un
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry, struct ipt_entry_target **target)
+      const struct ipt_entry *entry, struct xt_entry_target **target)
 {
 	struct ipt_set_info_target *myinfo =
 	    (struct ipt_set_info_target *) (*target)->data;
@@ -138,7 +138,7 @@ print_target(const char *prefix, const s
 /* Prints out the targinfo. */
 static void
 print(const struct ipt_ip *ip,
-      const struct ipt_entry_target *target, int numeric)
+      const struct xt_entry_target *target, int numeric)
 {
 	struct ipt_set_info_target *info =
 	    (struct ipt_set_info_target *) target->data;
@@ -149,7 +149,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the union ipt_targinfo in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct ipt_entry_target *target)
+save(const struct ipt_ip *ip, const struct xt_entry_target *target)
 {
 	struct ipt_set_info_target *info =
 	    (struct ipt_set_info_target *) target->data;
diff --git a/extensions/libipt_SNAT.c b/extensions/libipt_SNAT.c
index 867c9d0..9e12094 100644
--- a/extensions/libipt_SNAT.c
+++ b/extensions/libipt_SNAT.c
@@ -12,7 +12,7 @@
    to. */
 struct ipt_natinfo
 {
-	struct ipt_entry_target t;
+	struct xt_entry_target t;
 	struct ip_nat_multi_range mr;
 };
 
@@ -53,7 +53,7 @@ append_range(struct ipt_natinfo *info, c
 }
 
 /* Ranges expected in network order. */
-static struct ipt_entry_target *
+static struct xt_entry_target *
 parse_to(char *arg, int portok, struct ipt_natinfo *info)
 {
 	struct ip_nat_range range;
@@ -137,7 +137,7 @@ parse_to(char *arg, int portok, struct i
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
-      struct ipt_entry_target **target)
+      struct xt_entry_target **target)
 {
 	struct ipt_natinfo *info = (void *)*target;
 	int portok;
@@ -202,7 +202,7 @@ static void print_range(const struct ip_
 /* Prints out the targinfo. */
 static void
 print(const struct ipt_ip *ip,
-      const struct ipt_entry_target *target,
+      const struct xt_entry_target *target,
       int numeric)
 {
 	struct ipt_natinfo *info = (void *)target;
@@ -217,7 +217,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the union ipt_targinfo in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct ipt_entry_target *target)
+save(const struct ipt_ip *ip, const struct xt_entry_target *target)
 {
 	struct ipt_natinfo *info = (void *)target;
 	unsigned int i = 0;
diff --git a/extensions/libipt_TARPIT.c b/extensions/libipt_TARPIT.c
index b12cbc2..8805a6a 100644
--- a/extensions/libipt_TARPIT.c
+++ b/extensions/libipt_TARPIT.c
@@ -18,7 +18,7 @@ static struct option opts[] = {
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
-      struct ipt_entry_target **target)
+      struct xt_entry_target **target)
 {
 	return 0;
 }
@@ -29,12 +29,12 @@ static void final_check(unsigned int fla
 
 static void
 print(const struct ipt_ip *ip,
-      const struct ipt_entry_target *target,
+      const struct xt_entry_target *target,
       int numeric)
 {
 }
 
-static void save(const struct ipt_ip *ip, const struct ipt_entry_target *target)
+static void save(const struct ipt_ip *ip, const struct xt_entry_target *target)
 {
 }
 
diff --git a/extensions/libipt_TCPLAG.c b/extensions/libipt_TCPLAG.c
index 3042d73..96e8546 100644
--- a/extensions/libipt_TCPLAG.c
+++ b/extensions/libipt_TCPLAG.c
@@ -71,7 +71,7 @@ static const struct option opts[] =
  * Probably we could fiddle with t->tflags too but there is
  * no great advantage in doing so.
  */
-static void init( struct ipt_entry_target *t, unsigned int *nfcache )
+static void init( struct xt_entry_target *t, unsigned int *nfcache )
 {
 	struct ipt_tcplag *el = (struct ipt_tcplag *)t->data;
 	memset( el, 0, sizeof( struct ipt_tcplag ));
@@ -111,7 +111,7 @@ static void init( struct ipt_entry_targe
  *             (this has already been malloced for us).
  */
 static int parse( int c, char **argv, int invert, unsigned int *flags,
-				  const struct ipt_entry *entry, struct ipt_entry_target **target )
+				  const struct ipt_entry *entry, struct xt_entry_target **target )
 {
 	struct ipt_tcplag *el = (struct ipt_tcplag *)( *target )->data;
 /*
@@ -158,7 +158,7 @@ static void final_check( unsigned int fl
  * but coding of the various libipt_XX.c modules suggests
  * that it is safe to presume target is correctly initialised.
  */
-static void print(const struct ipt_ip *ip, const struct ipt_entry_target *target, int numeric)
+static void print(const struct ipt_ip *ip, const struct xt_entry_target *target, int numeric)
 {
 	const struct ipt_tcplag *el = (const struct ipt_tcplag *)target->data;
 	printf("TCPLAG <%d>", el->level );
@@ -172,7 +172,7 @@ static void print(const struct ipt_ip *i
  * As above but command-line style printout
  * (machine-readable for restoring table)
  */
-static void save( const struct ipt_ip *ip, const struct ipt_entry_target *target )
+static void save( const struct ipt_ip *ip, const struct xt_entry_target *target )
 {
 	const struct ipt_tcplag *el = (const struct ipt_tcplag *)target->data;
 	printf("TCPLAG --log-level=%d", el->level );
diff --git a/extensions/libipt_TCPMSS.c b/extensions/libipt_TCPMSS.c
index c3256f0..f2e18a7 100644
--- a/extensions/libipt_TCPMSS.c
+++ b/extensions/libipt_TCPMSS.c
@@ -12,7 +12,7 @@
 #include <linux/netfilter_ipv4/ipt_TCPMSS.h>
 
 struct mssinfo {
-	struct ipt_entry_target t;
+	struct xt_entry_target t;
 	struct ipt_tcpmss_info mss;
 };
 
@@ -35,7 +35,7 @@ static struct option opts[] = {
 
 /* Initialize the target. */
 static void
-init(struct ipt_entry_target *t, unsigned int *nfcache)
+init(struct xt_entry_target *t, unsigned int *nfcache)
 {
 }
 
@@ -44,7 +44,7 @@ init(struct ipt_entry_target *t, unsigne
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
-      struct ipt_entry_target **target)
+      struct xt_entry_target **target)
 {
 	struct ipt_tcpmss_info *mssinfo
 		= (struct ipt_tcpmss_info *)(*target)->data;
@@ -89,7 +89,7 @@ final_check(unsigned int flags)
 /* Prints out the targinfo. */
 static void
 print(const struct ipt_ip *ip,
-      const struct ipt_entry_target *target,
+      const struct xt_entry_target *target,
       int numeric)
 {
 	const struct ipt_tcpmss_info *mssinfo =
@@ -102,7 +102,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the union ipt_targinfo in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct ipt_entry_target *target)
+save(const struct ipt_ip *ip, const struct xt_entry_target *target)
 {
 	const struct ipt_tcpmss_info *mssinfo =
 		(const struct ipt_tcpmss_info *)target->data;
diff --git a/extensions/libipt_TOS.c b/extensions/libipt_TOS.c
index 999f7b0..2a5185e 100644
--- a/extensions/libipt_TOS.c
+++ b/extensions/libipt_TOS.c
@@ -9,7 +9,7 @@
 #include <linux/netfilter_ipv4/ipt_TOS.h>
 
 struct tosinfo {
-	struct ipt_entry_target t;
+	struct xt_entry_target t;
 	struct ipt_tos_target_info tos;
 };
 
@@ -54,7 +54,7 @@ static struct option opts[] = {
 
 /* Initialize the target. */
 static void
-init(struct ipt_entry_target *t, unsigned int *nfcache)
+init(struct xt_entry_target *t, unsigned int *nfcache)
 {
 }
 
@@ -87,7 +87,7 @@ parse_tos(const char *s, struct ipt_tos_
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
-      struct ipt_entry_target **target)
+      struct xt_entry_target **target)
 {
 	struct ipt_tos_target_info *tosinfo
 		= (struct ipt_tos_target_info *)(*target)->data;
@@ -134,7 +134,7 @@ print_tos(u_int8_t tos, int numeric)
 /* Prints out the targinfo. */
 static void
 print(const struct ipt_ip *ip,
-      const struct ipt_entry_target *target,
+      const struct xt_entry_target *target,
       int numeric)
 {
 	const struct ipt_tos_target_info *tosinfo =
@@ -145,7 +145,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the union ipt_targinfo in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct ipt_entry_target *target)
+save(const struct ipt_ip *ip, const struct xt_entry_target *target)
 {
 	const struct ipt_tos_target_info *tosinfo =
 		(const struct ipt_tos_target_info *)target->data;
diff --git a/extensions/libipt_TRACE.c b/extensions/libipt_TRACE.c
index 7217999..3b2059d 100644
--- a/extensions/libipt_TRACE.c
+++ b/extensions/libipt_TRACE.c
@@ -22,7 +22,7 @@ static struct option opts[] = {
 
 /* Initialize the target. */
 static void
-init(struct ipt_entry_target *t, unsigned int *nfcache)
+init(struct xt_entry_target *t, unsigned int *nfcache)
 {
 }
 
@@ -31,7 +31,7 @@ init(struct ipt_entry_target *t, unsigne
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
-      struct ipt_entry_target **target)
+      struct xt_entry_target **target)
 {
 	return 0;
 }
diff --git a/extensions/libipt_TTL.c b/extensions/libipt_TTL.c
index a2a28bd..f32057e 100644
--- a/extensions/libipt_TTL.c
+++ b/extensions/libipt_TTL.c
@@ -16,7 +16,7 @@
 
 #define IPT_TTL_USED	1
 
-static void init(struct ipt_entry_target *t, unsigned int *nfcache) 
+static void init(struct xt_entry_target *t, unsigned int *nfcache) 
 {
 }
 
@@ -32,7 +32,7 @@ static void help(void)
 
 static int parse(int c, char **argv, int invert, unsigned int *flags,
 		const struct ipt_entry *entry,
-		struct ipt_entry_target **target)
+		struct xt_entry_target **target)
 {
 	struct ipt_TTL_info *info = (struct ipt_TTL_info *) (*target)->data;
 	unsigned int value;
@@ -97,7 +97,7 @@ static void final_check(unsigned int fla
 }
 
 static void save(const struct ipt_ip *ip,
-		const struct ipt_entry_target *target)
+		const struct xt_entry_target *target)
 {
 	const struct ipt_TTL_info *info = 
 		(struct ipt_TTL_info *) target->data;
@@ -118,7 +118,7 @@ static void save(const struct ipt_ip *ip
 }
 
 static void print(const struct ipt_ip *ip,
-		const struct ipt_entry_target *target, int numeric)
+		const struct xt_entry_target *target, int numeric)
 {
 	const struct ipt_TTL_info *info =
 		(struct ipt_TTL_info *) target->data;
diff --git a/extensions/libipt_ULOG.c b/extensions/libipt_ULOG.c
index a73b685..f48d6f6 100644
--- a/extensions/libipt_ULOG.c
+++ b/extensions/libipt_ULOG.c
@@ -53,7 +53,7 @@ static struct option opts[] = {
 };
 
 /* Initialize the target. */
-static void init(struct ipt_entry_target *t, unsigned int *nfcache)
+static void init(struct xt_entry_target *t, unsigned int *nfcache)
 {
 	struct ipt_ulog_info *loginfo = (struct ipt_ulog_info *) t->data;
 
@@ -71,7 +71,7 @@ static void init(struct ipt_entry_target
    ate an option */
 static int parse(int c, char **argv, int invert, unsigned int *flags,
 		 const struct ipt_entry *entry,
-		 struct ipt_entry_target **target)
+		 struct xt_entry_target **target)
 {
 	struct ipt_ulog_info *loginfo =
 	    (struct ipt_ulog_info *) (*target)->data;
@@ -165,7 +165,7 @@ static void final_check(unsigned int fla
 
 /* Saves the union ipt_targinfo in parsable form to stdout. */
 static void save(const struct ipt_ip *ip,
-		 const struct ipt_entry_target *target)
+		 const struct xt_entry_target *target)
 {
 	const struct ipt_ulog_info *loginfo
 	    = (const struct ipt_ulog_info *) target->data;
@@ -195,7 +195,7 @@ static void save(const struct ipt_ip *ip
 /* Prints out the targinfo. */
 static void
 print(const struct ipt_ip *ip,
-      const struct ipt_entry_target *target, int numeric)
+      const struct xt_entry_target *target, int numeric)
 {
 	const struct ipt_ulog_info *loginfo
 	    = (const struct ipt_ulog_info *) target->data;
diff --git a/extensions/libipt_XOR.c b/extensions/libipt_XOR.c
index 2397916..b6d45fd 100644
--- a/extensions/libipt_XOR.c
+++ b/extensions/libipt_XOR.c
@@ -19,7 +19,7 @@
 #define	IPT_KEY_SET		1
 #define IPT_BLOCKSIZE_SET	2
 
-static void init(struct ipt_entry_target *t, unsigned int *nfcache) 
+static void init(struct xt_entry_target *t, unsigned int *nfcache) 
 {
 }
 
@@ -34,7 +34,7 @@ static void help(void)
 
 static int parse(int c, char **argv, int invert, unsigned int *flags,
 		const struct ipt_entry *entry, 
-		struct ipt_entry_target **target)
+		struct xt_entry_target **target)
 {
 	struct ipt_XOR_info *info = (struct ipt_XOR_info *) (*target)->data;
 	
@@ -70,7 +70,7 @@ static void final_check(unsigned int fla
 }
 
 static void save (const struct ipt_ip *ip,
-		const struct ipt_entry_target *target)
+		const struct xt_entry_target *target)
 {
 	const struct ipt_XOR_info *info = (struct ipt_XOR_info *) target->data;
 
@@ -79,7 +79,7 @@ static void save (const struct ipt_ip *i
 }
 
 static void print (const struct ipt_ip *ip,
-	const struct ipt_entry_target *target, int numeric)
+	const struct xt_entry_target *target, int numeric)
 {
 	const struct ipt_XOR_info *info = (struct ipt_XOR_info *) target->data;
 
diff --git a/extensions/libipt_account.c b/extensions/libipt_account.c
index d049a03..46e2f6d 100644
--- a/extensions/libipt_account.c
+++ b/extensions/libipt_account.c
@@ -163,7 +163,7 @@ inline int valid_network_and_netmask(str
 
 
 /* Function initializes match */
-static void init(struct ipt_entry_match *match, 
+static void init(struct xt_entry_match *match, 
 		 unsigned int *nfcache) {
 	
 	struct t_ipt_account_info *info = (struct t_ipt_account_info *)(match)->data;
@@ -181,7 +181,7 @@ static int parse(int c, char **argv,
 		  unsigned int *flags,
                   const struct ipt_entry *entry,
                   unsigned int *nfcache,
-                  struct ipt_entry_match **match) {
+                  struct xt_entry_match **match) {
 	
 	struct t_ipt_account_info *info = (struct t_ipt_account_info *)(*match)->data;
 
@@ -220,7 +220,7 @@ static void final_check(unsigned int fla
 
 /* Function used for printing rule with account match for iptables -L */
 static void print(const struct ipt_ip *ip,
-                  const struct ipt_entry_match *match, 
+                  const struct xt_entry_match *match, 
 		  int numeric) {
 	
 	struct t_ipt_account_info *info = (struct t_ipt_account_info *)match->data;
@@ -239,7 +239,7 @@ static void print(const struct ipt_ip *i
 
 /* Function used for saving rule containing account match */
 static void save(const struct ipt_ip *ip, 
-		 const struct ipt_entry_match *match) {
+		 const struct xt_entry_match *match) {
 
 	struct t_ipt_account_info *info = (struct t_ipt_account_info *)match->data;
 	
diff --git a/extensions/libipt_addrtype.c b/extensions/libipt_addrtype.c
index d8e1929..dbf4be7 100644
--- a/extensions/libipt_addrtype.c
+++ b/extensions/libipt_addrtype.c
@@ -83,7 +83,7 @@ static void parse_types(const char *arg,
 
 static int parse(int c, char **argv, int invert, unsigned int *flags,
 		const struct ipt_entry *entry, unsigned int *nfcache,
-		struct ipt_entry_match **match)
+		struct xt_entry_match **match)
 {
 	struct ipt_addrtype_info *info =
 		(struct ipt_addrtype_info *) (*match)->data;
@@ -138,7 +138,7 @@ static void print_types(u_int16_t mask)
 }
 
 static void print(const struct ipt_ip *ip, 
-		const struct ipt_entry_match *match,
+		const struct xt_entry_match *match,
 		int numeric)
 {
 	const struct ipt_addrtype_info *info = 
@@ -160,7 +160,7 @@ static void print(const struct ipt_ip *i
 }
 
 static void save(const struct ipt_ip *ip, 
-		const struct ipt_entry_match *match)
+		const struct xt_entry_match *match)
 {
 	const struct ipt_addrtype_info *info =
 		(struct ipt_addrtype_info *) match->data;
diff --git a/extensions/libipt_ah.c b/extensions/libipt_ah.c
index 443c9f8..3929bdb 100644
--- a/extensions/libipt_ah.c
+++ b/extensions/libipt_ah.c
@@ -68,7 +68,7 @@ parse_ah_spis(const char *spistring, u_i
 
 /* Initialize the match. */
 static void
-init(struct ipt_entry_match *m, unsigned int *nfcache)
+init(struct xt_entry_match *m, unsigned int *nfcache)
 {
 	struct ipt_ah *ahinfo = (struct ipt_ah *)m->data;
 
@@ -83,7 +83,7 @@ static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
       unsigned int *nfcache,
-      struct ipt_entry_match **match)
+      struct xt_entry_match **match)
 {
 	struct ipt_ah *ahinfo = (struct ipt_ah *)(*match)->data;
 
@@ -135,7 +135,7 @@ print_spis(const char *name, u_int32_t m
 /* Prints out the union ipt_matchinfo. */
 static void
 print(const struct ipt_ip *ip,
-      const struct ipt_entry_match *match, int numeric)
+      const struct xt_entry_match *match, int numeric)
 {
 	const struct ipt_ah *ah = (struct ipt_ah *)match->data;
 
@@ -148,7 +148,7 @@ print(const struct ipt_ip *ip,
 }
 
 /* Saves the union ipt_matchinfo in parsable form to stdout. */
-static void save(const struct ipt_ip *ip, const struct ipt_entry_match *match)
+static void save(const struct ipt_ip *ip, const struct xt_entry_match *match)
 {
 	const struct ipt_ah *ahinfo = (struct ipt_ah *)match->data;
 
diff --git a/extensions/libipt_childlevel.c b/extensions/libipt_childlevel.c
index 1018c9e..4be0df2 100644
--- a/extensions/libipt_childlevel.c
+++ b/extensions/libipt_childlevel.c
@@ -42,7 +42,7 @@ static struct option opts[] = {
 /* Function which parses command options; returns true if it ate an option */
 static int parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry, unsigned int *nfcache,
-      struct ipt_entry_match **match)
+      struct xt_entry_match **match)
 {
 	struct ipt_childlevel_info *childlevelinfo = 
 		(struct ipt_childlevel_info *)(*match)->data;
@@ -79,7 +79,7 @@ static void print_protocol(int n, int in
 
 /* Prints out the matchinfo. */
 static void print(const struct ipt_ip *ip,
-      const struct ipt_entry_match *match,
+      const struct xt_entry_match *match,
       int numeric)
 {
 	printf("CHILDLEVEL ");
@@ -88,7 +88,7 @@ static void print(const struct ipt_ip *i
 		  ((struct ipt_childlevel_info *)match->data)->invert, numeric);
 }
 /* Saves the union ipt_matchinfo in parsable form to stdout. */
-static void save(const struct ipt_ip *ip, const struct ipt_entry_match *match)
+static void save(const struct ipt_ip *ip, const struct xt_entry_match *match)
 {
         const struct ipt_childlevel_info *info =
             (const struct ipt_childlevel_info*) match->data;
diff --git a/extensions/libipt_comment.c b/extensions/libipt_comment.c
index 692acca..1b73c23 100644
--- a/extensions/libipt_comment.c
+++ b/extensions/libipt_comment.c
@@ -47,7 +47,7 @@ static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
       unsigned int *nfcache,
-      struct ipt_entry_match **match)
+      struct xt_entry_match **match)
 {
 	struct ipt_comment_info *commentinfo = (struct ipt_comment_info *)(*match)->data;
 
@@ -80,7 +80,7 @@ final_check(unsigned int flags)
 /* Prints out the matchinfo. */
 static void
 print(const struct ipt_ip *ip,
-      const struct ipt_entry_match *match,
+      const struct xt_entry_match *match,
       int numeric)
 {
 	struct ipt_comment_info *commentinfo = (struct ipt_comment_info *)match->data;
@@ -91,7 +91,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the union ipt_matchinfo in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct ipt_entry_match *match)
+save(const struct ipt_ip *ip, const struct xt_entry_match *match)
 {
 	struct ipt_comment_info *commentinfo = (struct ipt_comment_info *)match->data;
 
diff --git a/extensions/libipt_condition.c b/extensions/libipt_condition.c
index 16558fe..677b5f5 100644
--- a/extensions/libipt_condition.c
+++ b/extensions/libipt_condition.c
@@ -27,7 +27,7 @@ static struct option opts[] = {
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry, unsigned int *nfcache,
-      struct ipt_entry_match **match)
+      struct xt_entry_match **match)
 {
 	struct condition_info *info =
 	    (struct condition_info *) (*match)->data;
@@ -65,7 +65,7 @@ final_check(unsigned int flags)
 
 static void
 print(const struct ipt_ip *ip,
-		  const struct ipt_entry_match *match, int numeric)
+		  const struct xt_entry_match *match, int numeric)
 {
 	const struct condition_info *info =
 	    (const struct condition_info *) match->data;
@@ -76,7 +76,7 @@ print(const struct ipt_ip *ip,
 
 static void
 save(const struct ipt_ip *ip,
-		 const struct ipt_entry_match *match)
+		 const struct xt_entry_match *match)
 {
 	const struct condition_info *info =
 	    (const struct condition_info *) match->data;
diff --git a/extensions/libipt_connbytes.c b/extensions/libipt_connbytes.c
index 42e1ab5..5d62f01 100644
--- a/extensions/libipt_connbytes.c
+++ b/extensions/libipt_connbytes.c
@@ -51,7 +51,7 @@ static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
       unsigned int *nfcache,
-      struct ipt_entry_match **match)
+      struct xt_entry_match **match)
 {
 	struct ipt_connbytes_info *sinfo = (struct ipt_connbytes_info *)(*match)->data;
 	unsigned long i;
@@ -147,7 +147,7 @@ static void print_direction(struct ipt_c
 /* Prints out the matchinfo. */
 static void
 print(const struct ipt_ip *ip,
-      const struct ipt_entry_match *match,
+      const struct xt_entry_match *match,
       int numeric)
 {
 	struct ipt_connbytes_info *sinfo = (struct ipt_connbytes_info *)match->data;
@@ -167,7 +167,7 @@ print(const struct ipt_ip *ip,
 }
 
 /* Saves the matchinfo in parsable form to stdout. */
-static void save(const struct ipt_ip *ip, const struct ipt_entry_match *match)
+static void save(const struct ipt_ip *ip, const struct xt_entry_match *match)
 {
 	struct ipt_connbytes_info *sinfo = (struct ipt_connbytes_info *)match->data;
 
diff --git a/extensions/libipt_connlimit.c b/extensions/libipt_connlimit.c
index 17b4d13..d5d347f 100644
--- a/extensions/libipt_connlimit.c
+++ b/extensions/libipt_connlimit.c
@@ -32,7 +32,7 @@ static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
       unsigned int *nfcache,
-      struct ipt_entry_match **match)
+      struct xt_entry_match **match)
 {
 	struct ipt_connlimit_info *info = (struct ipt_connlimit_info*)(*match)->data;
 	int i;
@@ -95,7 +95,7 @@ count_bits(u_int32_t mask)
 /* Prints out the matchinfo. */
 static void
 print(const struct ipt_ip *ip,
-      const struct ipt_entry_match *match,
+      const struct xt_entry_match *match,
       int numeric)
 {
 	struct ipt_connlimit_info *info = (struct ipt_connlimit_info*)match->data;
@@ -105,7 +105,7 @@ print(const struct ipt_ip *ip,
 }
 
 /* Saves the matchinfo in parsable form to stdout. */
-static void save(const struct ipt_ip *ip, const struct ipt_entry_match *match)
+static void save(const struct ipt_ip *ip, const struct xt_entry_match *match)
 {
 	struct ipt_connlimit_info *info = (struct ipt_connlimit_info*)match->data;
 
diff --git a/extensions/libipt_connmark.c b/extensions/libipt_connmark.c
index bc15f0d..9412d66 100644
--- a/extensions/libipt_connmark.c
+++ b/extensions/libipt_connmark.c
@@ -46,7 +46,7 @@ static struct option opts[] = {
 
 /* Initialize the match. */
 static void
-init(struct ipt_entry_match *m, unsigned int *nfcache)
+init(struct xt_entry_match *m, unsigned int *nfcache)
 {
 	/* Can't cache this. */
 	*nfcache |= NFC_UNKNOWN;
@@ -58,7 +58,7 @@ static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
       unsigned int *nfcache,
-      struct ipt_entry_match **match)
+      struct xt_entry_match **match)
 {
 	struct ipt_connmark_info *markinfo = (struct ipt_connmark_info *)(*match)->data;
 
@@ -107,7 +107,7 @@ final_check(unsigned int flags)
 /* Prints out the matchinfo. */
 static void
 print(const struct ipt_ip *ip,
-      const struct ipt_entry_match *match,
+      const struct xt_entry_match *match,
       int numeric)
 {
 	struct ipt_connmark_info *info = (struct ipt_connmark_info *)match->data;
@@ -120,7 +120,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the matchinfo in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct ipt_entry_match *match)
+save(const struct ipt_ip *ip, const struct xt_entry_match *match)
 {
 	struct ipt_connmark_info *info = (struct ipt_connmark_info *)match->data;
 
diff --git a/extensions/libipt_connrate.c b/extensions/libipt_connrate.c
index 47c5fcb..92bf248 100644
--- a/extensions/libipt_connrate.c
+++ b/extensions/libipt_connrate.c
@@ -78,7 +78,7 @@ static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
       unsigned int *nfcache,
-      struct ipt_entry_match **match)
+      struct xt_entry_match **match)
 {
 	struct ipt_connrate_info *sinfo = (struct ipt_connrate_info *)(*match)->data;
 	u_int32_t tmp;
@@ -139,7 +139,7 @@ print_range(struct ipt_connrate_info *si
 /* Prints out the matchinfo. */
 static void
 print(const struct ipt_ip *ip,
-      const struct ipt_entry_match *match,
+      const struct xt_entry_match *match,
       int numeric)
 {
 	struct ipt_connrate_info *sinfo = (struct ipt_connrate_info *)match->data;
@@ -150,7 +150,7 @@ print(const struct ipt_ip *ip,
 }
 
 /* Saves the matchinfo in parsable form to stdout. */
-static void save(const struct ipt_ip *ip, const struct ipt_entry_match *match)
+static void save(const struct ipt_ip *ip, const struct xt_entry_match *match)
 {
 	struct ipt_connrate_info *sinfo = (struct ipt_connrate_info *)match->data;
 
diff --git a/extensions/libipt_conntrack.c b/extensions/libipt_conntrack.c
index cdb86c4..d32a6ce 100644
--- a/extensions/libipt_conntrack.c
+++ b/extensions/libipt_conntrack.c
@@ -188,7 +188,7 @@ static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
       unsigned int *nfcache,
-      struct ipt_entry_match **match)
+      struct xt_entry_match **match)
 {
 	struct ipt_conntrack_info *sinfo = (struct ipt_conntrack_info *)(*match)->data;
 	char *protocol = NULL;
@@ -431,7 +431,7 @@ print_addr(struct in_addr *addr, struct
 
 /* Saves the matchinfo in parsable form to stdout. */
 static void
-matchinfo_print(const struct ipt_ip *ip, const struct ipt_entry_match *match, int numeric, const char *optpfx)
+matchinfo_print(const struct ipt_ip *ip, const struct xt_entry_match *match, int numeric, const char *optpfx)
 {
 	struct ipt_conntrack_info *sinfo = (struct ipt_conntrack_info *)match->data;
 
@@ -518,14 +518,14 @@ matchinfo_print(const struct ipt_ip *ip,
 /* Prints out the matchinfo. */
 static void
 print(const struct ipt_ip *ip,
-      const struct ipt_entry_match *match,
+      const struct xt_entry_match *match,
       int numeric)
 {
 	matchinfo_print(ip, match, numeric, "");
 }
 
 /* Saves the matchinfo in parsable form to stdout. */
-static void save(const struct ipt_ip *ip, const struct ipt_entry_match *match)
+static void save(const struct ipt_ip *ip, const struct xt_entry_match *match)
 {
 	matchinfo_print(ip, match, 1, "--");
 }
diff --git a/extensions/libipt_dccp.c b/extensions/libipt_dccp.c
index e5782a8..c42f083 100644
--- a/extensions/libipt_dccp.c
+++ b/extensions/libipt_dccp.c
@@ -26,7 +26,7 @@
 
 /* Initialize the match. */
 static void
-init(struct ipt_entry_match *m, 
+init(struct xt_entry_match *m, 
      unsigned int *nfcache)
 {
 	struct ipt_dccp_info *einfo = (struct ipt_dccp_info *)m->data;
@@ -136,7 +136,7 @@ static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
       unsigned int *nfcache,
-      struct ipt_entry_match **match)
+      struct xt_entry_match **match)
 {
 	struct ipt_dccp_info *einfo
 		= (struct ipt_dccp_info *)(*match)->data;
@@ -280,7 +280,7 @@ print_option(u_int8_t option, int invert
 /* Prints out the matchinfo. */
 static void
 print(const struct ipt_ip *ip,
-      const struct ipt_entry_match *match,
+      const struct xt_entry_match *match,
       int numeric)
 {
 	const struct ipt_dccp_info *einfo =
@@ -315,7 +315,7 @@ print(const struct ipt_ip *ip,
 /* Saves the union ipt_matchinfo in parsable form to stdout. */
 static void
 save(const struct ipt_ip *ip, 
-     const struct ipt_entry_match *match)
+     const struct xt_entry_match *match)
 {
 	const struct ipt_dccp_info *einfo =
 		(const struct ipt_dccp_info *)match->data;
diff --git a/extensions/libipt_dscp.c b/extensions/libipt_dscp.c
index bb19bed..68bc0aa 100644
--- a/extensions/libipt_dscp.c
+++ b/extensions/libipt_dscp.c
@@ -77,7 +77,7 @@ static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
       unsigned int *nfcache,
-      struct ipt_entry_match **match)
+      struct xt_entry_match **match)
 {
 	struct ipt_dscp_info *dinfo
 		= (struct ipt_dscp_info *)(*match)->data;
@@ -132,7 +132,7 @@ print_dscp(u_int8_t dscp, int invert, in
 /* Prints out the matchinfo. */
 static void
 print(const struct ipt_ip *ip,
-      const struct ipt_entry_match *match,
+      const struct xt_entry_match *match,
       int numeric)
 {
 	const struct ipt_dscp_info *dinfo =
@@ -143,7 +143,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the union ipt_matchinfo in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct ipt_entry_match *match)
+save(const struct ipt_ip *ip, const struct xt_entry_match *match)
 {
 	const struct ipt_dscp_info *dinfo =
 		(const struct ipt_dscp_info *)match->data;
diff --git a/extensions/libipt_dstlimit.c b/extensions/libipt_dstlimit.c
index 3f3b633..83512a4 100644
--- a/extensions/libipt_dstlimit.c
+++ b/extensions/libipt_dstlimit.c
@@ -97,7 +97,7 @@ int parse_rate(const char *rate, u_int32
 
 /* Initialize the match. */
 static void
-init(struct ipt_entry_match *m, unsigned int *nfcache)
+init(struct xt_entry_match *m, unsigned int *nfcache)
 {
 	struct ipt_dstlimit_info *r = (struct ipt_dstlimit_info *)m->data;
 
@@ -122,7 +122,7 @@ static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
       unsigned int *nfcache,
-      struct ipt_entry_match **match)
+      struct xt_entry_match **match)
 {
 	struct ipt_dstlimit_info *r = 
 			(struct ipt_dstlimit_info *)(*match)->data;
@@ -254,7 +254,7 @@ static void print_rate(u_int32_t period)
 /* Prints out the matchinfo. */
 static void
 print(const struct ipt_ip *ip,
-      const struct ipt_entry_match *match,
+      const struct xt_entry_match *match,
       int numeric)
 {
 	struct ipt_dstlimit_info *r = 
@@ -286,7 +286,7 @@ print(const struct ipt_ip *ip,
 }
 
 /* FIXME: Make minimalist: only print rate if not default --RR */
-static void save(const struct ipt_ip *ip, const struct ipt_entry_match *match)
+static void save(const struct ipt_ip *ip, const struct xt_entry_match *match)
 {
 	struct ipt_dstlimit_info *r = 
 		(struct ipt_dstlimit_info *)match->data;
diff --git a/extensions/libipt_ecn.c b/extensions/libipt_ecn.c
index 97e839d..9d32b0f 100644
--- a/extensions/libipt_ecn.c
+++ b/extensions/libipt_ecn.c
@@ -37,7 +37,7 @@ static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
       unsigned int *nfcache,
-      struct ipt_entry_match **match)
+      struct xt_entry_match **match)
 {
 	unsigned int result;
 	struct ipt_ecn_info *einfo
@@ -98,7 +98,7 @@ final_check(unsigned int flags)
 /* Prints out the matchinfo. */
 static void
 print(const struct ipt_ip *ip,
-      const struct ipt_entry_match *match,
+      const struct xt_entry_match *match,
       int numeric)
 {
 	const struct ipt_ecn_info *einfo =
@@ -127,7 +127,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the union ipt_matchinfo in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct ipt_entry_match *match)
+save(const struct ipt_ip *ip, const struct xt_entry_match *match)
 {
 	const struct ipt_ecn_info *einfo =
 		(const struct ipt_ecn_info *)match->data;
diff --git a/extensions/libipt_esp.c b/extensions/libipt_esp.c
index 21e912b..380af84 100644
--- a/extensions/libipt_esp.c
+++ b/extensions/libipt_esp.c
@@ -71,7 +71,7 @@ parse_esp_spis(const char *spistring, u_
 
 /* Initialize the match. */
 static void
-init(struct ipt_entry_match *m, unsigned int *nfcache)
+init(struct xt_entry_match *m, unsigned int *nfcache)
 {
 	struct ipt_esp *espinfo = (struct ipt_esp *)m->data;
 
@@ -86,7 +86,7 @@ static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
       unsigned int *nfcache,
-      struct ipt_entry_match **match)
+      struct xt_entry_match **match)
 {
 	struct ipt_esp *espinfo = (struct ipt_esp *)(*match)->data;
 
@@ -138,7 +138,7 @@ print_spis(const char *name, u_int32_t m
 /* Prints out the union ipt_matchinfo. */
 static void
 print(const struct ipt_ip *ip,
-      const struct ipt_entry_match *match, int numeric)
+      const struct xt_entry_match *match, int numeric)
 {
 	const struct ipt_esp *esp = (struct ipt_esp *)match->data;
 
@@ -151,7 +151,7 @@ print(const struct ipt_ip *ip,
 }
 
 /* Saves the union ipt_matchinfo in parsable form to stdout. */
-static void save(const struct ipt_ip *ip, const struct ipt_entry_match *match)
+static void save(const struct ipt_ip *ip, const struct xt_entry_match *match)
 {
 	const struct ipt_esp *espinfo = (struct ipt_esp *)match->data;
 
diff --git a/extensions/libipt_fuzzy.c b/extensions/libipt_fuzzy.c
index d574db8..f7f3730 100644
--- a/extensions/libipt_fuzzy.c
+++ b/extensions/libipt_fuzzy.c
@@ -40,7 +40,7 @@ static struct option opts[] = {
 
 /* Initialize data structures */
 static void
-init(struct ipt_entry_match *m, unsigned int *nfcache)
+init(struct xt_entry_match *m, unsigned int *nfcache)
 {
 	struct ipt_fuzzy_info *presentinfo = (struct ipt_fuzzy_info *)(m)->data;
 
@@ -60,7 +60,7 @@ static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
       unsigned int *nfcache,
-      struct ipt_entry_match **match)
+      struct xt_entry_match **match)
 {
 
 struct ipt_fuzzy_info *fuzzyinfo = (struct ipt_fuzzy_info *)(*match)->data;
@@ -115,7 +115,7 @@ static void final_check(unsigned int fla
 
 static void
 print(const struct ipt_ip *ip,
-      const struct ipt_entry_match *match,
+      const struct xt_entry_match *match,
       int numeric)
 {
 	const struct ipt_fuzzy_info *fuzzyinfo
@@ -127,7 +127,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the union ipt_targinfo in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct ipt_entry_match *match)
+save(const struct ipt_ip *ip, const struct xt_entry_match *match)
 {
 	const struct ipt_fuzzy_info *fuzzyinfo
 		= (const struct ipt_fuzzy_info *)match->data;
diff --git a/extensions/libipt_hashlimit.c b/extensions/libipt_hashlimit.c
index 6fb0ecc..527b2e8 100644
--- a/extensions/libipt_hashlimit.c
+++ b/extensions/libipt_hashlimit.c
@@ -96,7 +96,7 @@ int parse_rate(const char *rate, u_int32
 
 /* Initialize the match. */
 static void
-init(struct ipt_entry_match *m, unsigned int *nfcache)
+init(struct xt_entry_match *m, unsigned int *nfcache)
 {
 	struct ipt_hashlimit_info *r = (struct ipt_hashlimit_info *)m->data;
 
@@ -153,7 +153,7 @@ static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
       unsigned int *nfcache,
-      struct ipt_entry_match **match)
+      struct xt_entry_match **match)
 {
 	struct ipt_hashlimit_info *r = 
 			(struct ipt_hashlimit_info *)(*match)->data;
@@ -305,7 +305,7 @@ static void print_mode(const struct ipt_
 /* Prints out the matchinfo. */
 static void
 print(const struct ipt_ip *ip,
-      const struct ipt_entry_match *match,
+      const struct xt_entry_match *match,
       int numeric)
 {
 	struct ipt_hashlimit_info *r = 
@@ -325,7 +325,7 @@ print(const struct ipt_ip *ip,
 }
 
 /* FIXME: Make minimalist: only print rate if not default --RR */
-static void save(const struct ipt_ip *ip, const struct ipt_entry_match *match)
+static void save(const struct ipt_ip *ip, const struct xt_entry_match *match)
 {
 	struct ipt_hashlimit_info *r = 
 		(struct ipt_hashlimit_info *)match->data;
diff --git a/extensions/libipt_helper.c b/extensions/libipt_helper.c
index 7c9f3e3..ee2fbd2 100644
--- a/extensions/libipt_helper.c
+++ b/extensions/libipt_helper.c
@@ -30,7 +30,7 @@ static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
       unsigned int *nfcache,
-      struct ipt_entry_match **match)
+      struct xt_entry_match **match)
 {
 	struct ipt_helper_info *info = (struct ipt_helper_info *)(*match)->data;
 
@@ -65,7 +65,7 @@ final_check(unsigned int flags)
 /* Prints out the info. */
 static void
 print(const struct ipt_ip *ip,
-      const struct ipt_entry_match *match,
+      const struct xt_entry_match *match,
       int numeric)
 {
 	struct ipt_helper_info *info = (struct ipt_helper_info *)match->data;
@@ -75,7 +75,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the union ipt_info in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct ipt_entry_match *match)
+save(const struct ipt_ip *ip, const struct xt_entry_match *match)
 {
 	struct ipt_helper_info *info = (struct ipt_helper_info *)match->data;
 
diff --git a/extensions/libipt_icmp.c b/extensions/libipt_icmp.c
index 8f22d05..4bb1b58 100644
--- a/extensions/libipt_icmp.c
+++ b/extensions/libipt_icmp.c
@@ -169,7 +169,7 @@ parse_icmp(const char *icmptype, u_int8_
 
 /* Initialize the match. */
 static void
-init(struct ipt_entry_match *m, unsigned int *nfcache)
+init(struct xt_entry_match *m, unsigned int *nfcache)
 {
 	struct ipt_icmp *icmpinfo = (struct ipt_icmp *)m->data;
 
@@ -183,7 +183,7 @@ static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
       unsigned int *nfcache,
-      struct ipt_entry_match **match)
+      struct xt_entry_match **match)
 {
 	struct ipt_icmp *icmpinfo = (struct ipt_icmp *)(*match)->data;
 
@@ -247,7 +247,7 @@ static void print_icmptype(u_int8_t type
 /* Prints out the union ipt_matchinfo. */
 static void
 print(const struct ipt_ip *ip,
-      const struct ipt_entry_match *match,
+      const struct xt_entry_match *match,
       int numeric)
 {
 	const struct ipt_icmp *icmp = (struct ipt_icmp *)match->data;
@@ -263,7 +263,7 @@ print(const struct ipt_ip *ip,
 }
 
 /* Saves the match in parsable form to stdout. */
-static void save(const struct ipt_ip *ip, const struct ipt_entry_match *match)
+static void save(const struct ipt_ip *ip, const struct xt_entry_match *match)
 {
 	const struct ipt_icmp *icmp = (struct ipt_icmp *)match->data;
 
diff --git a/extensions/libipt_iprange.c b/extensions/libipt_iprange.c
index e696702..bca2f5b 100644
--- a/extensions/libipt_iprange.c
+++ b/extensions/libipt_iprange.c
@@ -58,7 +58,7 @@ static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
       unsigned int *nfcache,
-      struct ipt_entry_match **match)
+      struct xt_entry_match **match)
 {
 	struct ipt_iprange_info *info = (struct ipt_iprange_info *)(*match)->data;
 
@@ -123,7 +123,7 @@ print_iprange(const struct ipt_iprange *
 /* Prints out the info. */
 static void
 print(const struct ipt_ip *ip,
-      const struct ipt_entry_match *match,
+      const struct xt_entry_match *match,
       int numeric)
 {
 	struct ipt_iprange_info *info = (struct ipt_iprange_info *)match->data;
@@ -144,7 +144,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the union ipt_info in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct ipt_entry_match *match)
+save(const struct ipt_ip *ip, const struct xt_entry_match *match)
 {
 	struct ipt_iprange_info *info = (struct ipt_iprange_info *)match->data;
 
diff --git a/extensions/libipt_ipv4options.c b/extensions/libipt_ipv4options.c
index 3d3b236..6ddce27 100644
--- a/extensions/libipt_ipv4options.c
+++ b/extensions/libipt_ipv4options.c
@@ -41,7 +41,7 @@ static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
       unsigned int *nfcache,
-      struct ipt_entry_match **match)
+      struct xt_entry_match **match)
 {
 	struct ipt_ipv4options_info *info = (struct ipt_ipv4options_info *)(*match)->data;
 
@@ -227,7 +227,7 @@ final_check(unsigned int flags)
 /* Prints out the matchinfo. */
 static void
 print(const struct ipt_ip *ip,
-      const struct ipt_entry_match *match,
+      const struct xt_entry_match *match,
       int numeric)
 {
 	struct ipt_ipv4options_info *info = ((struct ipt_ipv4options_info *)match->data);
@@ -261,7 +261,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the data in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct ipt_entry_match *match)
+save(const struct ipt_ip *ip, const struct xt_entry_match *match)
 {
 	struct ipt_ipv4options_info *info = ((struct ipt_ipv4options_info *)match->data);
 
diff --git a/extensions/libipt_length.c b/extensions/libipt_length.c
index cfac1c5..49d91b8 100644
--- a/extensions/libipt_length.c
+++ b/extensions/libipt_length.c
@@ -68,7 +68,7 @@ static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
       unsigned int *nfcache,
-      struct ipt_entry_match **match)
+      struct xt_entry_match **match)
 {
 	struct ipt_length_info *info = (struct ipt_length_info *)(*match)->data;
 
@@ -116,7 +116,7 @@ print_length(struct ipt_length_info *inf
 /* Prints out the matchinfo. */
 static void
 print(const struct ipt_ip *ip,
-      const struct ipt_entry_match *match,
+      const struct xt_entry_match *match,
       int numeric)
 {
 	printf("length ");
@@ -125,7 +125,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the union ipt_matchinfo in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct ipt_entry_match *match)
+save(const struct ipt_ip *ip, const struct xt_entry_match *match)
 {
 	printf("--length ");
 	print_length((struct ipt_length_info *)match->data);
diff --git a/extensions/libipt_limit.c b/extensions/libipt_limit.c
index 7f0337a..214e6f6 100644
--- a/extensions/libipt_limit.c
+++ b/extensions/libipt_limit.c
@@ -74,7 +74,7 @@ int parse_rate(const char *rate, u_int32
 
 /* Initialize the match. */
 static void
-init(struct ipt_entry_match *m, unsigned int *nfcache)
+init(struct xt_entry_match *m, unsigned int *nfcache)
 {
 	struct ipt_rateinfo *r = (struct ipt_rateinfo *)m->data;
 
@@ -95,7 +95,7 @@ static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
       unsigned int *nfcache,
-      struct ipt_entry_match **match)
+      struct xt_entry_match **match)
 {
 	struct ipt_rateinfo *r = (struct ipt_rateinfo *)(*match)->data;
 	unsigned int num;
@@ -157,7 +157,7 @@ static void print_rate(u_int32_t period)
 /* Prints out the matchinfo. */
 static void
 print(const struct ipt_ip *ip,
-      const struct ipt_entry_match *match,
+      const struct xt_entry_match *match,
       int numeric)
 {
 	struct ipt_rateinfo *r = (struct ipt_rateinfo *)match->data;
@@ -166,7 +166,7 @@ print(const struct ipt_ip *ip,
 }
 
 /* FIXME: Make minimalist: only print rate if not default --RR */
-static void save(const struct ipt_ip *ip, const struct ipt_entry_match *match)
+static void save(const struct ipt_ip *ip, const struct xt_entry_match *match)
 {
 	struct ipt_rateinfo *r = (struct ipt_rateinfo *)match->data;
 
diff --git a/extensions/libipt_mac.c b/extensions/libipt_mac.c
index bac8512..a9f6194 100644
--- a/extensions/libipt_mac.c
+++ b/extensions/libipt_mac.c
@@ -58,7 +58,7 @@ static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
       unsigned int *nfcache,
-      struct ipt_entry_match **match)
+      struct xt_entry_match **match)
 {
 	struct ipt_mac_info *macinfo = (struct ipt_mac_info *)(*match)->data;
 
@@ -99,7 +99,7 @@ static void final_check(unsigned int fla
 /* Prints out the matchinfo. */
 static void
 print(const struct ipt_ip *ip,
-      const struct ipt_entry_match *match,
+      const struct xt_entry_match *match,
       int numeric)
 {
 	printf("MAC ");
@@ -111,7 +111,7 @@ print(const struct ipt_ip *ip,
 }
 
 /* Saves the union ipt_matchinfo in parsable form to stdout. */
-static void save(const struct ipt_ip *ip, const struct ipt_entry_match *match)
+static void save(const struct ipt_ip *ip, const struct xt_entry_match *match)
 {
 	if (((struct ipt_mac_info *)match->data)->invert)
 		printf("! ");
diff --git a/extensions/libipt_mark.c b/extensions/libipt_mark.c
index 1922768..b2b038f 100644
--- a/extensions/libipt_mark.c
+++ b/extensions/libipt_mark.c
@@ -31,7 +31,7 @@ static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
       unsigned int *nfcache,
-      struct ipt_entry_match **match)
+      struct xt_entry_match **match)
 {
 	struct ipt_mark_info *markinfo = (struct ipt_mark_info *)(*match)->data;
 
@@ -97,7 +97,7 @@ final_check(unsigned int flags)
 /* Prints out the matchinfo. */
 static void
 print(const struct ipt_ip *ip,
-      const struct ipt_entry_match *match,
+      const struct xt_entry_match *match,
       int numeric)
 {
 	struct ipt_mark_info *info = (struct ipt_mark_info *)match->data;
@@ -112,7 +112,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the union ipt_matchinfo in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct ipt_entry_match *match)
+save(const struct ipt_ip *ip, const struct xt_entry_match *match)
 {
 	struct ipt_mark_info *info = (struct ipt_mark_info *)match->data;
 
diff --git a/extensions/libipt_mport.c b/extensions/libipt_mport.c
index 624de13..5816a84 100644
--- a/extensions/libipt_mport.c
+++ b/extensions/libipt_mport.c
@@ -79,7 +79,7 @@ parse_multi_ports(const char *portstring
 
 /* Initialize the match. */
 static void
-init(struct ipt_entry_match *m, unsigned int *nfcache)
+init(struct xt_entry_match *m, unsigned int *nfcache)
 {
 }
 
@@ -104,7 +104,7 @@ static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
       unsigned int *nfcache,
-      struct ipt_entry_match **match)
+      struct xt_entry_match **match)
 {
 	const char *proto;
 	struct ipt_mport *minfo
@@ -181,7 +181,7 @@ print_port(u_int16_t port, u_int8_t prot
 /* Prints out the matchinfo. */
 static void
 print(const struct ipt_ip *ip,
-      const struct ipt_entry_match *match,
+      const struct xt_entry_match *match,
       int numeric)
 {
 	const struct ipt_mport *minfo
@@ -227,7 +227,7 @@ print(const struct ipt_ip *ip,
 }
 
 /* Saves the union ipt_matchinfo in parsable form to stdout. */
-static void save(const struct ipt_ip *ip, const struct ipt_entry_match *match)
+static void save(const struct ipt_ip *ip, const struct xt_entry_match *match)
 {
 	const struct ipt_mport *minfo
 		= (const struct ipt_mport *)match->data;
diff --git a/extensions/libipt_multiport.c b/extensions/libipt_multiport.c
index 2a10abd..384eda8 100644
--- a/extensions/libipt_multiport.c
+++ b/extensions/libipt_multiport.c
@@ -130,7 +130,7 @@ parse_multi_ports_v1(const char *portstr
 
 /* Initialize the match. */
 static void
-init(struct ipt_entry_match *m, unsigned int *nfcache)
+init(struct xt_entry_match *m, unsigned int *nfcache)
 {
 }
 
@@ -159,7 +159,7 @@ static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
       unsigned int *nfcache,
-      struct ipt_entry_match **match)
+      struct xt_entry_match **match)
 {
 	const char *proto;
 	struct ipt_multiport *multiinfo
@@ -209,7 +209,7 @@ static int
 parse_v1(int c, char **argv, int invert, unsigned int *flags,
 	 const struct ipt_entry *entry,
 	 unsigned int *nfcache,
-	 struct ipt_entry_match **match)
+	 struct xt_entry_match **match)
 {
 	const char *proto;
 	struct ipt_multiport_v1 *multiinfo
@@ -284,7 +284,7 @@ print_port(u_int16_t port, u_int8_t prot
 /* Prints out the matchinfo. */
 static void
 print(const struct ipt_ip *ip,
-      const struct ipt_entry_match *match,
+      const struct xt_entry_match *match,
       int numeric)
 {
 	const struct ipt_multiport *multiinfo
@@ -320,7 +320,7 @@ print(const struct ipt_ip *ip,
 
 static void
 print_v1(const struct ipt_ip *ip,
-	 const struct ipt_entry_match *match,
+	 const struct xt_entry_match *match,
 	 int numeric)
 {
 	const struct ipt_multiport_v1 *multiinfo
@@ -362,7 +362,7 @@ print_v1(const struct ipt_ip *ip,
 }
 
 /* Saves the union ipt_matchinfo in parsable form to stdout. */
-static void save(const struct ipt_ip *ip, const struct ipt_entry_match *match)
+static void save(const struct ipt_ip *ip, const struct xt_entry_match *match)
 {
 	const struct ipt_multiport *multiinfo
 		= (const struct ipt_multiport *)match->data;
@@ -390,7 +390,7 @@ static void save(const struct ipt_ip *ip
 }
 
 static void save_v1(const struct ipt_ip *ip, 
-		    const struct ipt_entry_match *match)
+		    const struct xt_entry_match *match)
 {
 	const struct ipt_multiport_v1 *multiinfo
 		= (const struct ipt_multiport_v1 *)match->data;
diff --git a/extensions/libipt_nth.c b/extensions/libipt_nth.c
index 6f483b9..9d37a4d 100644
--- a/extensions/libipt_nth.c
+++ b/extensions/libipt_nth.c
@@ -62,7 +62,7 @@ static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
       unsigned int *nfcache,
-      struct ipt_entry_match **match)
+      struct xt_entry_match **match)
 {
 	struct ipt_nth_info *nthinfo = (struct ipt_nth_info *)(*match)->data;
 	unsigned int num;
@@ -176,7 +176,7 @@ static void final_check(unsigned int fla
 /* Prints out the targinfo. */
 static void
 print(const struct ipt_ip *ip,
-      const struct ipt_entry_match *match,
+      const struct xt_entry_match *match,
       int numeric)
 {
 	const struct ipt_nth_info *nthinfo
@@ -195,7 +195,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the union ipt_targinfo in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct ipt_entry_match *match)
+save(const struct ipt_ip *ip, const struct xt_entry_match *match)
 {
 	const struct ipt_nth_info *nthinfo
 		= (const struct ipt_nth_info *)match->data;
diff --git a/extensions/libipt_osf.c b/extensions/libipt_osf.c
index a2edb85..92c3f7f 100644
--- a/extensions/libipt_osf.c
+++ b/extensions/libipt_osf.c
@@ -68,7 +68,7 @@ static void parse_string(const unsigned
 static int parse(int c, char **argv, int invert, unsigned int *flags,
       			const struct ipt_entry *entry,
       			unsigned int *nfcache,
-      			struct ipt_entry_match **match)
+      			struct xt_entry_match **match)
 {
 	struct ipt_osf_info *info = (struct ipt_osf_info *)(*match)->data;
 	
@@ -122,14 +122,14 @@ static void final_check(unsigned int fla
 		exit_error(PARAMETER_PROBLEM, "OS fingerprint match: You must specify `--genre'");
 }
 
-static void print(const struct ipt_ip *ip, const struct ipt_entry_match *match, int numeric)
+static void print(const struct ipt_ip *ip, const struct xt_entry_match *match, int numeric)
 {
 	const struct ipt_osf_info *info = (const struct ipt_osf_info*) match->data;
 
 	printf("OS fingerprint match %s%s ", (info->invert) ? "!" : "", info->genre);
 }
 
-static void save(const struct ipt_ip *ip, const struct ipt_entry_match *match)
+static void save(const struct ipt_ip *ip, const struct xt_entry_match *match)
 {
 	const struct ipt_osf_info *info = (const struct ipt_osf_info*) match->data;
 
diff --git a/extensions/libipt_owner.c b/extensions/libipt_owner.c
index cf13cb9..87531d6 100644
--- a/extensions/libipt_owner.c
+++ b/extensions/libipt_owner.c
@@ -55,7 +55,7 @@ static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
       unsigned int *nfcache,
-      struct ipt_entry_match **match)
+      struct xt_entry_match **match)
 {
 	struct ipt_owner_info *ownerinfo = (struct ipt_owner_info *)(*match)->data;
 
@@ -201,7 +201,7 @@ final_check(unsigned int flags)
 /* Prints out the matchinfo. */
 static void
 print(const struct ipt_ip *ip,
-      const struct ipt_entry_match *match,
+      const struct xt_entry_match *match,
       int numeric)
 {
 	struct ipt_owner_info *info = (struct ipt_owner_info *)match->data;
@@ -217,7 +217,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the union ipt_matchinfo in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct ipt_entry_match *match)
+save(const struct ipt_ip *ip, const struct xt_entry_match *match)
 {
 	struct ipt_owner_info *info = (struct ipt_owner_info *)match->data;
 
diff --git a/extensions/libipt_physdev.c b/extensions/libipt_physdev.c
index 28ee827..0bf3ea8 100644
--- a/extensions/libipt_physdev.c
+++ b/extensions/libipt_physdev.c
@@ -35,7 +35,7 @@ static struct option opts[] = {
 };
 
 static void
-init(struct ipt_entry_match *m, unsigned int *nfcache)
+init(struct xt_entry_match *m, unsigned int *nfcache)
 {
 }
 
@@ -43,7 +43,7 @@ static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
       unsigned int *nfcache,
-      struct ipt_entry_match **match)
+      struct xt_entry_match **match)
 {
 	struct ipt_physdev_info *info =
 		(struct ipt_physdev_info*)(*match)->data;
@@ -122,7 +122,7 @@ static void final_check(unsigned int fla
 
 static void
 print(const struct ipt_ip *ip,
-      const struct ipt_entry_match *match,
+      const struct xt_entry_match *match,
       int numeric)
 {
 	struct ipt_physdev_info *info =
@@ -148,7 +148,7 @@ print(const struct ipt_ip *ip,
 	printf(" ");
 }
 
-static void save(const struct ipt_ip *ip, const struct ipt_entry_match *match)
+static void save(const struct ipt_ip *ip, const struct xt_entry_match *match)
 {
 	struct ipt_physdev_info *info =
 		(struct ipt_physdev_info*)match->data;
diff --git a/extensions/libipt_pkttype.c b/extensions/libipt_pkttype.c
index ea6439e..9f09419 100644
--- a/extensions/libipt_pkttype.c
+++ b/extensions/libipt_pkttype.c
@@ -88,7 +88,7 @@ static void parse_pkttype(const char *pk
 static int parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
       unsigned int *nfcache,
-      struct ipt_entry_match **match)
+      struct xt_entry_match **match)
 {
 	struct ipt_pkttype_info *info = (struct ipt_pkttype_info *)(*match)->data;
 	
@@ -131,7 +131,7 @@ static void print_pkttype(struct ipt_pkt
 	printf("%d ", info->pkttype);	/* in case we didn't find an entry in named-packtes */
 }
 
-static void print(const struct ipt_ip *ip, const struct ipt_entry_match *match, int numeric)
+static void print(const struct ipt_ip *ip, const struct xt_entry_match *match, int numeric)
 {
 	struct ipt_pkttype_info *info = (struct ipt_pkttype_info *)match->data;
 	
@@ -139,7 +139,7 @@ static void print(const struct ipt_ip *i
 	print_pkttype(info);
 }
 
-static void save(const struct ipt_ip *ip, const struct ipt_entry_match *match)
+static void save(const struct ipt_ip *ip, const struct xt_entry_match *match)
 {
 	struct ipt_pkttype_info *info = (struct ipt_pkttype_info *)match->data;
 	
diff --git a/extensions/libipt_policy.c b/extensions/libipt_policy.c
index 681995a..06393fe 100644
--- a/extensions/libipt_policy.c
+++ b/extensions/libipt_policy.c
@@ -93,7 +93,7 @@ static struct option opts[] =
 	{ }
 };
 
-static void init(struct ipt_entry_match *m, unsigned int *nfcache)
+static void init(struct xt_entry_match *m, unsigned int *nfcache)
 {
 	*nfcache |= NFC_UNKNOWN;
 }
@@ -128,7 +128,7 @@ static int parse_mode(char *s)
 static int parse(int c, char **argv, int invert, unsigned int *flags,
                  const struct ipt_entry *entry,
                  unsigned int *nfcache,
-                 struct ipt_entry_match **match)
+                 struct xt_entry_match **match)
 {
 	struct ipt_policy_info *info = (void *)(*match)->data;
 	struct ipt_policy_elem *e = &info->pol[info->len];
@@ -388,7 +388,7 @@ static void print_flags(char *prefix, co
 }
 
 static void print(const struct ipt_ip *ip,
-                  const struct ipt_entry_match *match,
+                  const struct xt_entry_match *match,
 		  int numeric)
 {
 	const struct ipt_policy_info *info = (void *)match->data;
@@ -403,7 +403,7 @@ static void print(const struct ipt_ip *i
 	}
 }
 
-static void save(const struct ipt_ip *ip, const struct ipt_entry_match *match)
+static void save(const struct ipt_ip *ip, const struct xt_entry_match *match)
 {
 	const struct ipt_policy_info *info = (void *)match->data;
 	unsigned int i;
diff --git a/extensions/libipt_psd.c b/extensions/libipt_psd.c
index 3d0034a..6663901 100644
--- a/extensions/libipt_psd.c
+++ b/extensions/libipt_psd.c
@@ -48,7 +48,7 @@ static struct option opts[] = {
 
 /* Initialize the target. */
 static void
-init(struct ipt_entry_match *m, unsigned int *nfcache)
+init(struct xt_entry_match *m, unsigned int *nfcache)
 {
 	struct ipt_psd_info *psdinfo = (struct ipt_psd_info *)m->data;
 
@@ -77,7 +77,7 @@ static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
       unsigned int *nfcache,
-      struct ipt_entry_match **match)
+      struct xt_entry_match **match)
 {
 	struct ipt_psd_info *psdinfo = (struct ipt_psd_info *)(*match)->data;
 	unsigned int num;
@@ -147,7 +147,7 @@ static void final_check(unsigned int fla
 /* Prints out the targinfo. */
 static void
 print(const struct ipt_ip *ip,
-      const struct ipt_entry_match *match,
+      const struct xt_entry_match *match,
       int numeric)
 {
 	const struct ipt_psd_info *psdinfo
@@ -162,7 +162,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the union ipt_targinfo in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct ipt_entry_match *match)
+save(const struct ipt_ip *ip, const struct xt_entry_match *match)
 {
 	const struct ipt_psd_info *psdinfo
 		= (const struct ipt_psd_info *)match->data;
diff --git a/extensions/libipt_quota.c b/extensions/libipt_quota.c
index 8380754..eb26e66 100644
--- a/extensions/libipt_quota.c
+++ b/extensions/libipt_quota.c
@@ -27,7 +27,7 @@ help(void)
 
 /* print matchinfo */
 static void
-print(const struct ipt_ip *ip, const struct ipt_entry_match *match, int numeric)
+print(const struct ipt_ip *ip, const struct xt_entry_match *match, int numeric)
 {
         struct xt_quota_info *q = (struct xt_quota_info *) match->data;
         printf("quota: %llu bytes", (unsigned long long) q->quota);
@@ -35,7 +35,7 @@ print(const struct ipt_ip *ip, const str
 
 /* save matchinfo */
 static void
-save(const struct ipt_ip *ip, const struct ipt_entry_match *match)
+save(const struct ipt_ip *ip, const struct xt_entry_match *match)
 {
         struct xt_quota_info *q = (struct xt_quota_info *) match->data;
         printf("--quota %llu ", (unsigned long long) q->quota);
@@ -61,7 +61,7 @@ parse_quota(const char *s, u_int64_t * q
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
-      unsigned int *nfcache, struct ipt_entry_match **match)
+      unsigned int *nfcache, struct xt_entry_match **match)
 {
         struct xt_quota_info *info = (struct xt_quota_info *) (*match)->data;
 
diff --git a/extensions/libipt_random.c b/extensions/libipt_random.c
index d28ab8c..1251732 100644
--- a/extensions/libipt_random.c
+++ b/extensions/libipt_random.c
@@ -48,7 +48,7 @@ static struct option opts[] = {
 
 /* Initialize the target. */
 static void
-init(struct ipt_entry_match *m, unsigned int *nfcache)
+init(struct xt_entry_match *m, unsigned int *nfcache)
 {
 	struct ipt_rand_info *randinfo = (struct ipt_rand_info *)(m)->data;
 
@@ -65,7 +65,7 @@ static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
       unsigned int *nfcache,
-      struct ipt_entry_match **match)
+      struct xt_entry_match **match)
 {
 	struct ipt_rand_info *randinfo = (struct ipt_rand_info *)(*match)->data;
 	unsigned int num;
@@ -104,7 +104,7 @@ static void final_check(unsigned int fla
 /* Prints out the targinfo. */
 static void
 print(const struct ipt_ip *ip,
-      const struct ipt_entry_match *match,
+      const struct xt_entry_match *match,
       int numeric)
 {
 	const struct ipt_rand_info *randinfo
@@ -118,7 +118,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the union ipt_targinfo in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct ipt_entry_match *match)
+save(const struct ipt_ip *ip, const struct xt_entry_match *match)
 {
 	const struct ipt_rand_info *randinfo
 		= (const struct ipt_rand_info *)match->data;
diff --git a/extensions/libipt_realm.c b/extensions/libipt_realm.c
index 1564677..5be8982 100644
--- a/extensions/libipt_realm.c
+++ b/extensions/libipt_realm.c
@@ -158,7 +158,7 @@ static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
       unsigned int *nfcache,
-      struct ipt_entry_match **match)
+      struct xt_entry_match **match)
 {
 	struct ipt_realm_info *realminfo = (struct ipt_realm_info *)(*match)->data;
 	int id;
@@ -216,7 +216,7 @@ print_realm(unsigned long id, unsigned l
 /* Prints out the matchinfo. */
 static void
 print(const struct ipt_ip *ip,
-      const struct ipt_entry_match *match,
+      const struct xt_entry_match *match,
       int numeric)
 {
 	struct ipt_realm_info *ri = (struct ipt_realm_info *) match->data;
@@ -231,7 +231,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the union ipt_matchinfo in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct ipt_entry_match *match)
+save(const struct ipt_ip *ip, const struct xt_entry_match *match)
 {
 	struct ipt_realm_info *ri = (struct ipt_realm_info *) match->data;
 
diff --git a/extensions/libipt_recent.c b/extensions/libipt_recent.c
index 0b0ed2d..16b4b0b 100644
--- a/extensions/libipt_recent.c
+++ b/extensions/libipt_recent.c
@@ -68,7 +68,7 @@ IPTABLES_VERSION);
   
 /* Initialize the match. */
 static void
-init(struct ipt_entry_match *match, unsigned int *nfcache)
+init(struct xt_entry_match *match, unsigned int *nfcache)
 {
 	struct ipt_recent_info *info = (struct ipt_recent_info *)(match)->data;
 
@@ -86,7 +86,7 @@ static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
       unsigned int *nfcache,
-      struct ipt_entry_match **match)
+      struct xt_entry_match **match)
 {
 	struct ipt_recent_info *info = (struct ipt_recent_info *)(*match)->data;
 	switch (c) {
@@ -176,7 +176,7 @@ final_check(unsigned int flags)
 /* Prints out the matchinfo. */
 static void
 print(const struct ipt_ip *ip,
-      const struct ipt_entry_match *match,
+      const struct xt_entry_match *match,
       int numeric)
 {
 	struct ipt_recent_info *info = (struct ipt_recent_info *)match->data;
@@ -199,7 +199,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the union ipt_matchinfo in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct ipt_entry_match *match)
+save(const struct ipt_ip *ip, const struct xt_entry_match *match)
 {
 	struct ipt_recent_info *info = (struct ipt_recent_info *)match->data;
 
diff --git a/extensions/libipt_record_rpc.c b/extensions/libipt_record_rpc.c
index 571d286..eb758c5 100644
--- a/extensions/libipt_record_rpc.c
+++ b/extensions/libipt_record_rpc.c
@@ -22,7 +22,7 @@ static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
       unsigned int *nfcache,
-      struct ipt_entry_match **match)
+      struct xt_entry_match **match)
 {
 	return 0;
 }
@@ -35,12 +35,12 @@ static void final_check(unsigned int fla
 /* Prints out the union ipt_matchinfo. */
 static void
 print(const struct ipt_ip *ip,
-      const struct ipt_entry_match *match,
+      const struct xt_entry_match *match,
       int numeric)
 {
 }
 
-static void save(const struct ipt_ip *ip, const struct ipt_entry_match *match)
+static void save(const struct ipt_ip *ip, const struct xt_entry_match *match)
 {
 }
 
diff --git a/extensions/libipt_rpc.c b/extensions/libipt_rpc.c
index dbfb396..84317a0 100644
--- a/extensions/libipt_rpc.c
+++ b/extensions/libipt_rpc.c
@@ -175,7 +175,7 @@ static struct option opts[] = {
 };
 
 
-static void init(struct ipt_entry_match *match, unsigned int *nfcache)
+static void init(struct xt_entry_match *match, unsigned int *nfcache)
 {
 	struct ipt_rpc_info *rpcinfo = ((struct ipt_rpc_info *)match->data);
 
@@ -188,7 +188,7 @@ static void init(struct ipt_entry_match
 }
 
 
-static void parse_rpcs_string(char *string, struct ipt_entry_match **match)
+static void parse_rpcs_string(char *string, struct xt_entry_match **match)
 {
 	char err1[64] = "%s invalid --rpcs option-set: `%s' (at character %i)";
 	char err2[64] = "%s unable to resolve rpc name entry: `%s'";
@@ -261,7 +261,7 @@ static void parse_rpcs_string(char *stri
 static int parse(int c, char **argv, int invert, unsigned int *flags,
 		const struct ipt_entry *entry,
 		unsigned int *nfcache,
-		struct ipt_entry_match **match)
+		struct xt_entry_match **match)
 {
 	struct ipt_rpc_info *rpcinfo = (struct ipt_rpc_info *)(*match)->data;
 
@@ -310,7 +310,7 @@ static void final_check(unsigned int fla
 
 
 static void print(const struct ipt_ip *ip,
-		const struct ipt_entry_match *match,
+		const struct xt_entry_match *match,
 		int numeric)
 {
 	struct ipt_rpc_info *rpcinfo = ((struct ipt_rpc_info *)match->data);
@@ -333,7 +333,7 @@ static void print(const struct ipt_ip *i
 }
 
 
-static void save(const struct ipt_ip *ip, const struct ipt_entry_match *match)
+static void save(const struct ipt_ip *ip, const struct xt_entry_match *match)
 {
 	struct ipt_rpc_info *rpcinfo = ((struct ipt_rpc_info *)match->data);
 
diff --git a/extensions/libipt_sctp.c b/extensions/libipt_sctp.c
index 0354d19..7d64501 100644
--- a/extensions/libipt_sctp.c
+++ b/extensions/libipt_sctp.c
@@ -43,7 +43,7 @@ print_chunk(u_int32_t chunknum, int nume
 
 /* Initialize the match. */
 static void
-init(struct ipt_entry_match *m, 
+init(struct xt_entry_match *m, 
      unsigned int *nfcache)
 {
 	int i;
@@ -265,7 +265,7 @@ static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
       unsigned int *nfcache,
-      struct ipt_entry_match **match)
+      struct xt_entry_match **match)
 {
 	struct ipt_sctp_info *einfo
 		= (struct ipt_sctp_info *)(*match)->data;
@@ -459,7 +459,7 @@ out:
 /* Prints out the matchinfo. */
 static void
 print(const struct ipt_ip *ip,
-      const struct ipt_entry_match *match,
+      const struct xt_entry_match *match,
       int numeric)
 {
 	const struct ipt_sctp_info *einfo =
@@ -493,7 +493,7 @@ print(const struct ipt_ip *ip,
 /* Saves the union ipt_matchinfo in parsable form to stdout. */
 static void
 save(const struct ipt_ip *ip, 
-     const struct ipt_entry_match *match)
+     const struct xt_entry_match *match)
 {
 	const struct ipt_sctp_info *einfo =
 		(const struct ipt_sctp_info *)match->data;
diff --git a/extensions/libipt_set.c b/extensions/libipt_set.c
index eb127dd..39dd72e 100644
--- a/extensions/libipt_set.c
+++ b/extensions/libipt_set.c
@@ -39,7 +39,7 @@ static struct option opts[] = {
 };
 
 /* Initialize the match. */
-static void init(struct ipt_entry_match *match, unsigned int *nfcache)
+static void init(struct xt_entry_match *match, unsigned int *nfcache)
 {
 	struct ipt_set_info_match *info = 
 		(struct ipt_set_info_match *) match->data;
@@ -53,7 +53,7 @@ static void init(struct ipt_entry_match
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
-      unsigned int *nfcache, struct ipt_entry_match **match)
+      unsigned int *nfcache, struct xt_entry_match **match)
 {
 	struct ipt_set_info_match *myinfo = 
 		(struct ipt_set_info_match *) (*match)->data;
@@ -128,7 +128,7 @@ print_match(const char *prefix, const st
 /* Prints out the matchinfo. */
 static void
 print(const struct ipt_ip *ip,
-      const struct ipt_entry_match *match, int numeric)
+      const struct xt_entry_match *match, int numeric)
 {
 	struct ipt_set_info_match *info = 
 		(struct ipt_set_info_match *) match->data;
@@ -138,7 +138,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the matchinfo in parsable form to stdout. */
 static void save(const struct ipt_ip *ip,
-		 const struct ipt_entry_match *match)
+		 const struct xt_entry_match *match)
 {
 	struct ipt_set_info_match *info = 
 		(struct ipt_set_info_match *) match->data;
diff --git a/extensions/libipt_standard.c b/extensions/libipt_standard.c
index 4c5a3f5..a3acdae 100644
--- a/extensions/libipt_standard.c
+++ b/extensions/libipt_standard.c
@@ -22,7 +22,7 @@ static struct option opts[] = {
 
 /* Initialize the target. */
 static void
-init(struct ipt_entry_target *t, unsigned int *nfcache)
+init(struct xt_entry_target *t, unsigned int *nfcache)
 {
 }
 
@@ -31,7 +31,7 @@ init(struct ipt_entry_target *t, unsigne
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
-      struct ipt_entry_target **target)
+      struct xt_entry_target **target)
 {
 	return 0;
 }
@@ -43,7 +43,7 @@ static void final_check(unsigned int fla
 
 /* Saves the targinfo in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct ipt_entry_target *target)
+save(const struct ipt_ip *ip, const struct xt_entry_target *target)
 {
 }
 
diff --git a/extensions/libipt_state.c b/extensions/libipt_state.c
index acafe9a..a0d9c3f 100644
--- a/extensions/libipt_state.c
+++ b/extensions/libipt_state.c
@@ -67,7 +67,7 @@ static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
       unsigned int *nfcache,
-      struct ipt_entry_match **match)
+      struct xt_entry_match **match)
 {
 	struct ipt_state_info *sinfo = (struct ipt_state_info *)(*match)->data;
 
@@ -125,7 +125,7 @@ static void print_state(unsigned int sta
 /* Prints out the matchinfo. */
 static void
 print(const struct ipt_ip *ip,
-      const struct ipt_entry_match *match,
+      const struct xt_entry_match *match,
       int numeric)
 {
 	struct ipt_state_info *sinfo = (struct ipt_state_info *)match->data;
@@ -135,7 +135,7 @@ print(const struct ipt_ip *ip,
 }
 
 /* Saves the matchinfo in parsable form to stdout. */
-static void save(const struct ipt_ip *ip, const struct ipt_entry_match *match)
+static void save(const struct ipt_ip *ip, const struct xt_entry_match *match)
 {
 	struct ipt_state_info *sinfo = (struct ipt_state_info *)match->data;
 
diff --git a/extensions/libipt_statistic.c b/extensions/libipt_statistic.c
index 4ed1813..2b3a038 100644
--- a/extensions/libipt_statistic.c
+++ b/extensions/libipt_statistic.c
@@ -37,7 +37,7 @@ static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
       unsigned int *nfcache,
-      struct ipt_entry_match **match)
+      struct xt_entry_match **match)
 {
 	double prob;
 
@@ -138,7 +138,7 @@ static void print_match(const struct xt_
 
 static void
 print(const struct ipt_ip *ip,
-      const struct ipt_entry_match *match,
+      const struct xt_entry_match *match,
       int numeric)
 {
 	struct xt_statistic_info *info = (struct xt_statistic_info *)match->data;
@@ -149,7 +149,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the union ipt_matchinfo in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct ipt_entry_match *match)
+save(const struct ipt_ip *ip, const struct xt_entry_match *match)
 {
 	struct xt_statistic_info *info = (struct xt_statistic_info *)match->data;
 
diff --git a/extensions/libipt_string.c b/extensions/libipt_string.c
index 5492cfc..b5c24c8 100644
--- a/extensions/libipt_string.c
+++ b/extensions/libipt_string.c
@@ -54,7 +54,7 @@ static struct option opts[] = {
 };
 
 static void
-init(struct ipt_entry_match *m, unsigned int *nfcache)
+init(struct xt_entry_match *m, unsigned int *nfcache)
 {
 	struct ipt_string_info *i = (struct ipt_string_info *) m->data;
 
@@ -172,7 +172,7 @@ static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
       unsigned int *nfcache,
-      struct ipt_entry_match **match)
+      struct xt_entry_match **match)
 {
 	struct ipt_string_info *stringinfo = (struct ipt_string_info *)(*match)->data;
 
@@ -290,7 +290,7 @@ print_string(const char *str, const unsi
 /* Prints out the matchinfo. */
 static void
 print(const struct ipt_ip *ip,
-      const struct ipt_entry_match *match,
+      const struct xt_entry_match *match,
       int numeric)
 {
 	const struct ipt_string_info *info =
@@ -313,7 +313,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the union ipt_matchinfo in parseable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct ipt_entry_match *match)
+save(const struct ipt_ip *ip, const struct xt_entry_match *match)
 {
 	const struct ipt_string_info *info =
 	    (const struct ipt_string_info*) match->data;
diff --git a/extensions/libipt_tcp.c b/extensions/libipt_tcp.c
index c712b92..a2334ce 100644
--- a/extensions/libipt_tcp.c
+++ b/extensions/libipt_tcp.c
@@ -131,7 +131,7 @@ parse_tcp_option(const char *option, u_i
 
 /* Initialize the match. */
 static void
-init(struct ipt_entry_match *m, unsigned int *nfcache)
+init(struct xt_entry_match *m, unsigned int *nfcache)
 {
 	struct ipt_tcp *tcpinfo = (struct ipt_tcp *)m->data;
 
@@ -149,7 +149,7 @@ static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
       unsigned int *nfcache,
-      struct ipt_entry_match **match)
+      struct xt_entry_match **match)
 {
 	struct ipt_tcp *tcpinfo = (struct ipt_tcp *)(*match)->data;
 
@@ -318,7 +318,7 @@ print_flags(u_int8_t mask, u_int8_t cmp,
 /* Prints out the union ipt_matchinfo. */
 static void
 print(const struct ipt_ip *ip,
-      const struct ipt_entry_match *match, int numeric)
+      const struct xt_entry_match *match, int numeric)
 {
 	const struct ipt_tcp *tcp = (struct ipt_tcp *)match->data;
 
@@ -341,7 +341,7 @@ print(const struct ipt_ip *ip,
 }
 
 /* Saves the union ipt_matchinfo in parsable form to stdout. */
-static void save(const struct ipt_ip *ip, const struct ipt_entry_match *match)
+static void save(const struct ipt_ip *ip, const struct xt_entry_match *match)
 {
 	const struct ipt_tcp *tcpinfo = (struct ipt_tcp *)match->data;
 
diff --git a/extensions/libipt_tcpmss.c b/extensions/libipt_tcpmss.c
index 9a399bb..198f7fd 100644
--- a/extensions/libipt_tcpmss.c
+++ b/extensions/libipt_tcpmss.c
@@ -62,7 +62,7 @@ static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
       unsigned int *nfcache,
-      struct ipt_entry_match **match)
+      struct xt_entry_match **match)
 {
 	struct ipt_tcpmss_match_info *mssinfo =
 		(struct ipt_tcpmss_match_info *)(*match)->data;
@@ -109,7 +109,7 @@ final_check(unsigned int flags)
 /* Prints out the matchinfo. */
 static void
 print(const struct ipt_ip *ip,
-      const struct ipt_entry_match *match,
+      const struct xt_entry_match *match,
       int numeric)
 {
 	const struct ipt_tcpmss_match_info *mssinfo =
@@ -122,7 +122,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the union ipt_matchinfo in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct ipt_entry_match *match)
+save(const struct ipt_ip *ip, const struct xt_entry_match *match)
 {
 	const struct ipt_tcpmss_match_info *mssinfo =
 		(const struct ipt_tcpmss_match_info *)match->data;
diff --git a/extensions/libipt_time.c b/extensions/libipt_time.c
index dcf2dc6..81913ca 100644
--- a/extensions/libipt_time.c
+++ b/extensions/libipt_time.c
@@ -53,7 +53,7 @@ static struct option opts[] = {
 
 /* Initialize the match. */
 static void
-init(struct ipt_entry_match *m, unsigned int *nfcache)
+init(struct xt_entry_match *m, unsigned int *nfcache)
 {
 	struct ipt_time_info *info = (struct ipt_time_info *)m->data;
 	globaldays = 0;
@@ -336,7 +336,7 @@ static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
       unsigned int *nfcache,
-      struct ipt_entry_match **match)
+      struct xt_entry_match **match)
 {
 	struct ipt_time_info *timeinfo = (struct ipt_time_info *)(*match)->data;
 	int hours, minutes;
@@ -468,7 +468,7 @@ print_date(time_t date, char *command)
 /* Prints out the matchinfo. */
 static void
 print(const struct ipt_ip *ip,
-      const struct ipt_entry_match *match,
+      const struct xt_entry_match *match,
       int numeric)
 {
 	struct ipt_time_info *time = ((struct ipt_time_info *)match->data);
@@ -500,7 +500,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the data in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct ipt_entry_match *match)
+save(const struct ipt_ip *ip, const struct xt_entry_match *match)
 {
 	struct ipt_time_info *time = ((struct ipt_time_info *)match->data);
 	int hour_start, hour_stop, minute_start, minute_stop;
diff --git a/extensions/libipt_tos.c b/extensions/libipt_tos.c
index f8b5cb4..7fdc9f7 100644
--- a/extensions/libipt_tos.c
+++ b/extensions/libipt_tos.c
@@ -78,7 +78,7 @@ static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
       unsigned int *nfcache,
-      struct ipt_entry_match **match)
+      struct xt_entry_match **match)
 {
 	struct ipt_tos_info *tosinfo = (struct ipt_tos_info *)(*match)->data;
 
@@ -129,7 +129,7 @@ final_check(unsigned int flags)
 /* Prints out the matchinfo. */
 static void
 print(const struct ipt_ip *ip,
-      const struct ipt_entry_match *match,
+      const struct xt_entry_match *match,
       int numeric)
 {
 	const struct ipt_tos_info *info = (const struct ipt_tos_info *)match->data;
@@ -142,7 +142,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the union ipt_matchinfo in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct ipt_entry_match *match)
+save(const struct ipt_ip *ip, const struct xt_entry_match *match)
 {
 	const struct ipt_tos_info *info = (const struct ipt_tos_info *)match->data;
     
diff --git a/extensions/libipt_ttl.c b/extensions/libipt_ttl.c
index 89ea084..7021095 100644
--- a/extensions/libipt_ttl.c
+++ b/extensions/libipt_ttl.c
@@ -26,7 +26,7 @@ static void help(void)
 
 static int parse(int c, char **argv, int invert, unsigned int *flags,
 		const struct ipt_entry *entry, unsigned int *nfcache,
-		struct ipt_entry_match **match)
+		struct xt_entry_match **match)
 {
 	struct ipt_ttl_info *info = (struct ipt_ttl_info *) (*match)->data;
 	unsigned int value;
@@ -93,7 +93,7 @@ static void final_check(unsigned int fla
 }
 
 static void print(const struct ipt_ip *ip, 
-		const struct ipt_entry_match *match,
+		const struct xt_entry_match *match,
 		int numeric)
 {
 	const struct ipt_ttl_info *info = 
@@ -118,7 +118,7 @@ static void print(const struct ipt_ip *i
 }
 
 static void save(const struct ipt_ip *ip, 
-		const struct ipt_entry_match *match)
+		const struct xt_entry_match *match)
 {
 	const struct ipt_ttl_info *info =
 		(struct ipt_ttl_info *) match->data;
diff --git a/extensions/libipt_u32.c b/extensions/libipt_u32.c
index 7504510..8042799 100644
--- a/extensions/libipt_u32.c
+++ b/extensions/libipt_u32.c
@@ -94,7 +94,7 @@ static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
       unsigned int *nfcache,
-      struct ipt_entry_match **match)
+      struct xt_entry_match **match)
 {
 	struct ipt_u32 *data = (struct ipt_u32 *)(*match)->data;
 	char *arg = argv[optind-1]; /* the argument string */
@@ -229,7 +229,7 @@ final_check(unsigned int flags)
 /* Prints out the matchinfo. */
 static void
 print(const struct ipt_ip *ip,
-      const struct ipt_entry_match *match,
+      const struct xt_entry_match *match,
       int numeric)
 {
 	printf("u32 ");
@@ -237,7 +237,7 @@ print(const struct ipt_ip *ip,
 }
 
 /* Saves the union ipt_matchinfo in parsable form to stdout. */
-static void save(const struct ipt_ip *ip, const struct ipt_entry_match *match)
+static void save(const struct ipt_ip *ip, const struct xt_entry_match *match)
 {
 	printf("--u32 ");
 	print_u32((struct ipt_u32 *)match->data);
diff --git a/extensions/libipt_udp.c b/extensions/libipt_udp.c
index 7f461d8..0d7cb97 100644
--- a/extensions/libipt_udp.c
+++ b/extensions/libipt_udp.c
@@ -55,7 +55,7 @@ parse_udp_ports(const char *portstring,
 
 /* Initialize the match. */
 static void
-init(struct ipt_entry_match *m, unsigned int *nfcache)
+init(struct xt_entry_match *m, unsigned int *nfcache)
 {
 	struct ipt_udp *udpinfo = (struct ipt_udp *)m->data;
 
@@ -71,7 +71,7 @@ static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
       unsigned int *nfcache,
-      struct ipt_entry_match **match)
+      struct xt_entry_match **match)
 {
 	struct ipt_udp *udpinfo = (struct ipt_udp *)(*match)->data;
 
@@ -157,7 +157,7 @@ print_ports(const char *name, u_int16_t
 /* Prints out the union ipt_matchinfo. */
 static void
 print(const struct ipt_ip *ip,
-      const struct ipt_entry_match *match, int numeric)
+      const struct xt_entry_match *match, int numeric)
 {
 	const struct ipt_udp *udp = (struct ipt_udp *)match->data;
 
@@ -174,7 +174,7 @@ print(const struct ipt_ip *ip,
 }
 
 /* Saves the union ipt_matchinfo in parsable form to stdout. */
-static void save(const struct ipt_ip *ip, const struct ipt_entry_match *match)
+static void save(const struct ipt_ip *ip, const struct xt_entry_match *match)
 {
 	const struct ipt_udp *udpinfo = (struct ipt_udp *)match->data;
 
diff --git a/extensions/libipt_unclean.c b/extensions/libipt_unclean.c
index 7b9b3e4..101744c 100644
--- a/extensions/libipt_unclean.c
+++ b/extensions/libipt_unclean.c
@@ -23,7 +23,7 @@ static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
       unsigned int *nfcache,
-      struct ipt_entry_match **match)
+      struct xt_entry_match **match)
 {
 	return 0;
 }
-- 
1.4.4
