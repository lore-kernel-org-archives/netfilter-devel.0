From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 09-1/43] Fixed warning on compilation of iptables
 matches/targets
Date: Fri, 20 Jul 2007 20:11:05 +0900 (JST)
Message-ID: <200707201111.l6KBB6fA002051@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: kaber@trash.net, netfilter-devel@lists.netfilter.org
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
- ipt_ip * -> void *
- ipt_entry * -> void *

This patch doesn't change multiport, DNAT, SNAT, MASQUERADE, REDIRECT
because these need more changes (casting void * variable with intended type)
---
 extensions/libipt_CLASSIFY.c    |    6 +++---
 extensions/libipt_CLUSTERIP.c   |    6 +++---
 extensions/libipt_CONNMARK.c    |    6 +++---
 extensions/libipt_CONNSECMARK.c |    6 +++---
 extensions/libipt_DSCP.c        |    6 +++---
 extensions/libipt_ECN.c         |    6 +++---
 extensions/libipt_LOG.c         |    6 +++---
 extensions/libipt_MARK.c        |   12 ++++++------
 extensions/libipt_MIRROR.c      |    2 +-
 extensions/libipt_NETMAP.c      |    6 +++---
 extensions/libipt_NFLOG.c       |    6 +++---
 extensions/libipt_NFQUEUE.c     |    6 +++---
 extensions/libipt_NOTRACK.c     |    2 +-
 extensions/libipt_REJECT.c      |    6 +++---
 extensions/libipt_SAME.c        |    6 +++---
 extensions/libipt_SECMARK.c     |    6 +++---
 extensions/libipt_SET.c         |    6 +++---
 extensions/libipt_TCPMSS.c      |    6 +++---
 extensions/libipt_TOS.c         |    6 +++---
 extensions/libipt_TTL.c         |    6 +++---
 extensions/libipt_ULOG.c        |    6 +++---
 extensions/libipt_addrtype.c    |    6 +++---
 extensions/libipt_ah.c          |    6 +++---
 extensions/libipt_comment.c     |    6 +++---
 extensions/libipt_condition.c   |    6 +++---
 extensions/libipt_connbytes.c   |    6 +++---
 extensions/libipt_connmark.c    |    6 +++---
 extensions/libipt_connrate.c    |    6 +++---
 extensions/libipt_conntrack.c   |    8 ++++----
 extensions/libipt_dccp.c        |    6 +++---
 extensions/libipt_dscp.c        |    6 +++---
 extensions/libipt_ecn.c         |    6 +++---
 extensions/libipt_esp.c         |    6 +++---
 extensions/libipt_hashlimit.c   |    6 +++---
 extensions/libipt_helper.c      |    6 +++---
 extensions/libipt_icmp.c        |    6 +++---
 extensions/libipt_iprange.c     |    6 +++---
 extensions/libipt_length.c      |    6 +++---
 extensions/libipt_limit.c       |    6 +++---
 extensions/libipt_mac.c         |    6 +++---
 extensions/libipt_mark.c        |    6 +++---
 extensions/libipt_owner.c       |    6 +++---
 extensions/libipt_physdev.c     |    6 +++---
 extensions/libipt_pkttype.c     |    6 +++---
 extensions/libipt_policy.c      |    6 +++---
 extensions/libipt_quota.c       |    6 +++---
 extensions/libipt_realm.c       |    6 +++---
 extensions/libipt_recent.c      |    6 +++---
 extensions/libipt_sctp.c        |    6 +++---
 extensions/libipt_set.c         |    6 +++---
 extensions/libipt_standard.c    |    4 ++--
 extensions/libipt_state.c       |    6 +++---
 extensions/libipt_statistic.c   |    6 +++---
 extensions/libipt_string.c      |    6 +++---
 extensions/libipt_tcp.c         |    6 +++---
 extensions/libipt_tcpmss.c      |    6 +++---
 extensions/libipt_tos.c         |    6 +++---
 extensions/libipt_ttl.c         |    6 +++---
 extensions/libipt_udp.c         |    6 +++---
 extensions/libipt_unclean.c     |    2 +-
 60 files changed, 177 insertions(+), 177 deletions(-)

diff --git a/extensions/libipt_CLASSIFY.c b/extensions/libipt_CLASSIFY.c
index 2e4cc15..16e47ac 100644
--- a/extensions/libipt_CLASSIFY.c
+++ b/extensions/libipt_CLASSIFY.c
@@ -47,7 +47,7 @@ int string_to_priority(const char *s, unsigned int *p)
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *entry,
       struct xt_entry_target **target)
 {
 	struct ipt_classify_target_info *clinfo
@@ -87,7 +87,7 @@ print_class(unsigned int priority, int numeric)
 
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
@@ -207,7 +207,7 @@ static char *mac2str(const u_int8_t mac[ETH_ALEN])
 
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
@@ -66,7 +66,7 @@ init(struct xt_entry_target *t, unsigned int *nfcache)
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *entry,
       struct xt_entry_target **target)
 {
 	struct ipt_connmark_target_info *markinfo
@@ -144,7 +144,7 @@ print_mask(const char *text, unsigned long mask)
 
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
@@ -86,7 +86,7 @@ static void print_connsecmark(struct xt_connsecmark_target_info *info)
 	}
 }
 
-static void print(const struct ipt_ip *ip,
+static void print(const void *ip,
 		  const struct xt_entry_target *target, int numeric)
 {
 	struct xt_connsecmark_target_info *info =
@@ -96,7 +96,7 @@ static void print(const struct ipt_ip *ip,
 	print_connsecmark(info);
 }
 
-static void save(const struct ipt_ip *ip, const struct xt_entry_target *target)
+static void save(const void *ip, const struct xt_entry_target *target)
 {
 	struct xt_connsecmark_target_info *info =
 		(struct xt_connsecmark_target_info*)target->data;
diff --git a/extensions/libipt_DSCP.c b/extensions/libipt_DSCP.c
index 26f70bd..8845af2 100644
--- a/extensions/libipt_DSCP.c
+++ b/extensions/libipt_DSCP.c
@@ -78,7 +78,7 @@ parse_class(const char *s, struct ipt_DSCP_info *dinfo)
 
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
index 9e02204..78c6543 100644
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
@@ -206,7 +206,7 @@ static void final_check(unsigned int flags)
 
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
index 8157f1e..62329ab 100644
--- a/extensions/libipt_MARK.c
+++ b/extensions/libipt_MARK.c
@@ -39,7 +39,7 @@ init(struct xt_entry_target *t, unsigned int *nfcache)
    ate an option */
 static int
 parse_v0(int c, char **argv, int invert, unsigned int *flags,
-	 const struct ipt_entry *entry,
+	 const void *entry,
 	 struct xt_entry_target **target)
 {
 	struct ipt_mark_target_info *markinfo
@@ -81,7 +81,7 @@ final_check(unsigned int flags)
    ate an option */
 static int
 parse_v1(int c, char **argv, int invert, unsigned int *flags,
-	 const struct ipt_entry *entry,
+	 const void *entry,
 	 struct xt_entry_target **target)
 {
 	struct ipt_mark_target_info_v1 *markinfo
@@ -120,7 +120,7 @@ print_mark(unsigned long mark)
 
 /* Prints out the targinfo. */
 static void
-print_v0(const struct ipt_ip *ip,
+print_v0(const void *ip,
 	 const struct xt_entry_target *target,
 	 int numeric)
 {
@@ -132,7 +132,7 @@ print_v0(const struct ipt_ip *ip,
 
 /* Saves the union ipt_targinfo in parsable form to stdout. */
 static void
-save_v0(const struct ipt_ip *ip, const struct xt_entry_target *target)
+save_v0(const void *ip, const struct xt_entry_target *target)
 {
 	const struct ipt_mark_target_info *markinfo =
 		(const struct ipt_mark_target_info *)target->data;
@@ -143,7 +143,7 @@ save_v0(const struct ipt_ip *ip, const struct xt_entry_target *target)
 
 /* Prints out the targinfo. */
 static void
-print_v1(const struct ipt_ip *ip,
+print_v1(const void *ip,
 	 const struct xt_entry_target *target,
 	 int numeric)
 {
@@ -166,7 +166,7 @@ print_v1(const struct ipt_ip *ip,
 
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
@@ -30,7 +30,7 @@ init(struct xt_entry_target *t, unsigned int *nfcache)
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *entry,
       struct xt_entry_target **target)
 {
 	return 0;
diff --git a/extensions/libipt_NETMAP.c b/extensions/libipt_NETMAP.c
index 37af94b..d296d31 100644
--- a/extensions/libipt_NETMAP.c
+++ b/extensions/libipt_NETMAP.c
@@ -118,7 +118,7 @@ parse_to(char *arg, struct ip_nat_range *range)
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *entry,
       struct xt_entry_target **target)
 {
 	struct ip_nat_multi_range *mr
@@ -149,7 +149,7 @@ static void final_check(unsigned int flags)
 
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
diff --git a/extensions/libipt_NFLOG.c b/extensions/libipt_NFLOG.c
index ae5c62a..b43a8b8 100644
--- a/extensions/libipt_NFLOG.c
+++ b/extensions/libipt_NFLOG.c
@@ -40,7 +40,7 @@ static void init(struct xt_entry_target *t, unsigned int *nfcache)
 }
 
 static int parse(int c, char **argv, int invert, unsigned int *flags,
-		 const struct ipt_entry *entry,
+		 const void *entry,
 		 struct xt_entry_target **target)
 {
 	struct xt_nflog_info *info = (struct xt_nflog_info *)(*target)->data;
@@ -126,7 +126,7 @@ static void nflog_print(const struct xt_nflog_info *info, char *prefix)
 		printf("%snflog-threshold %u ", prefix, info->threshold);
 }
 
-static void print(const struct ipt_ip *ip, const struct xt_entry_target *target,
+static void print(const void *ip, const struct xt_entry_target *target,
 		  int numeric)
 {
 	const struct xt_nflog_info *info = (struct xt_nflog_info *)target->data;
@@ -134,7 +134,7 @@ static void print(const struct ipt_ip *ip, const struct xt_entry_target *target,
 	nflog_print(info, "");
 }
 
-static void save(const struct ipt_ip *ip, const struct xt_entry_target *target)
+static void save(const void *ip, const struct xt_entry_target *target)
 {
 	const struct xt_nflog_info *info = (struct xt_nflog_info *)target->data;
 
diff --git a/extensions/libipt_NFQUEUE.c b/extensions/libipt_NFQUEUE.c
index 8f89828..5d608fc 100644
--- a/extensions/libipt_NFQUEUE.c
+++ b/extensions/libipt_NFQUEUE.c
@@ -47,7 +47,7 @@ parse_num(const char *s, struct ipt_NFQ_info *tinfo)
 
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
@@ -30,7 +30,7 @@ init(struct xt_entry_target *t, unsigned int *nfcache)
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
@@ -100,7 +100,7 @@ init(struct xt_entry_target *t, unsigned int *nfcache)
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *entry,
       struct xt_entry_target **target)
 {
 	struct ipt_reject_info *reject = (struct ipt_reject_info *)(*target)->data;
@@ -139,7 +139,7 @@ static void final_check(unsigned int flags)
 
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
diff --git a/extensions/libipt_SAME.c b/extensions/libipt_SAME.c
index 6e2353c..83ab7cd 100644
--- a/extensions/libipt_SAME.c
+++ b/extensions/libipt_SAME.c
@@ -89,7 +89,7 @@ parse_to(char *arg, struct ip_nat_range *range)
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *entry,
       struct xt_entry_target **target)
 {
 	struct ipt_same_info *mr
@@ -148,7 +148,7 @@ static void final_check(unsigned int flags)
 
 /* Prints out the targinfo. */
 static void
-print(const struct ipt_ip *ip,
+print(const void *ip,
       const struct xt_entry_target *target,
       int numeric)
 {
@@ -185,7 +185,7 @@ print(const struct ipt_ip *ip,
 
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
@@ -37,7 +37,7 @@ static void init(struct xt_entry_target *t, unsigned int *nfcache)
  * ate an option.
  */
 static int parse(int c, char **argv, int invert, unsigned int *flags,
-                 const struct ipt_entry *entry, struct xt_entry_target **target)
+                 const void *entry, struct xt_entry_target **target)
 {
 	struct xt_secmark_target_info *info =
 		(struct xt_secmark_target_info*)(*target)->data;
@@ -83,7 +83,7 @@ static void print_secmark(struct xt_secmark_target_info *info)
 	}
 }
 
-static void print(const struct ipt_ip *ip,
+static void print(const void *ip,
 		  const struct xt_entry_target *target, int numeric)
 {
 	struct xt_secmark_target_info *info =
@@ -94,7 +94,7 @@ static void print(const struct ipt_ip *ip,
 }
 
 /* Saves the target info in parsable form to stdout. */
-static void save(const struct ipt_ip *ip, const struct xt_entry_target *target)
+static void save(const void *ip, const struct xt_entry_target *target)
 {
 	struct xt_secmark_target_info *info =
 		(struct xt_secmark_target_info*)target->data;
diff --git a/extensions/libipt_SET.c b/extensions/libipt_SET.c
index 1c11631..a095e11 100644
--- a/extensions/libipt_SET.c
+++ b/extensions/libipt_SET.c
@@ -85,7 +85,7 @@ parse_target(char **argv, int invert, unsigned int *flags,
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry, struct xt_entry_target **target)
+      const void *entry, struct xt_entry_target **target)
 {
 	struct ipt_set_info_target *myinfo =
 	    (struct ipt_set_info_target *) (*target)->data;
@@ -136,7 +136,7 @@ print_target(const char *prefix, const struct ipt_set_info *info)
 
 /* Prints out the targinfo. */
 static void
-print(const struct ipt_ip *ip,
+print(const void *ip,
       const struct xt_entry_target *target, int numeric)
 {
 	struct ipt_set_info_target *info =
@@ -148,7 +148,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the union ipt_targinfo in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct xt_entry_target *target)
+save(const void *ip, const struct xt_entry_target *target)
 {
 	struct ipt_set_info_target *info =
 	    (struct ipt_set_info_target *) target->data;
diff --git a/extensions/libipt_TCPMSS.c b/extensions/libipt_TCPMSS.c
index f2e18a7..3f1855b 100644
--- a/extensions/libipt_TCPMSS.c
+++ b/extensions/libipt_TCPMSS.c
@@ -43,7 +43,7 @@ init(struct xt_entry_target *t, unsigned int *nfcache)
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
@@ -86,7 +86,7 @@ parse_tos(const char *s, struct ipt_tos_target_info *info)
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
diff --git a/extensions/libipt_TTL.c b/extensions/libipt_TTL.c
index 7d47f2a..c5e0c8d 100644
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
@@ -96,7 +96,7 @@ static void final_check(unsigned int flags)
 				"TTL: You must specify an action");
 }
 
-static void save(const struct ipt_ip *ip,
+static void save(const void *ip,
 		const struct xt_entry_target *target)
 {
 	const struct ipt_TTL_info *info = 
@@ -117,7 +117,7 @@ static void save(const struct ipt_ip *ip,
 	printf("%u ", info->ttl);
 }
 
-static void print(const struct ipt_ip *ip,
+static void print(const void *ip,
 		const struct xt_entry_target *target, int numeric)
 {
 	const struct ipt_TTL_info *info =
diff --git a/extensions/libipt_ULOG.c b/extensions/libipt_ULOG.c
index 91fcfb0..cf1dd4f 100644
--- a/extensions/libipt_ULOG.c
+++ b/extensions/libipt_ULOG.c
@@ -70,7 +70,7 @@ static void init(struct xt_entry_target *t, unsigned int *nfcache)
 /* Function which parses command options; returns true if it
    ate an option */
 static int parse(int c, char **argv, int invert, unsigned int *flags,
-		 const struct ipt_entry *entry,
+		 const void *entry,
 		 struct xt_entry_target **target)
 {
 	struct ipt_ulog_info *loginfo =
@@ -156,7 +156,7 @@ static void final_check(unsigned int flags)
 }
 
 /* Saves the union ipt_targinfo in parsable form to stdout. */
-static void save(const struct ipt_ip *ip,
+static void save(const void *ip,
 		 const struct xt_entry_target *target)
 {
 	const struct ipt_ulog_info *loginfo
@@ -178,7 +178,7 @@ static void save(const struct ipt_ip *ip,
 
 /* Prints out the targinfo. */
 static void
-print(const struct ipt_ip *ip,
+print(const void *ip,
       const struct xt_entry_target *target, int numeric)
 {
 	const struct ipt_ulog_info *loginfo
diff --git a/extensions/libipt_addrtype.c b/extensions/libipt_addrtype.c
index dbf4be7..144a702 100644
--- a/extensions/libipt_addrtype.c
+++ b/extensions/libipt_addrtype.c
@@ -82,7 +82,7 @@ static void parse_types(const char *arg, u_int16_t *mask)
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
@@ -159,7 +159,7 @@ static void print(const struct ipt_ip *ip,
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
@@ -81,7 +81,7 @@ init(struct xt_entry_match *m, unsigned int *nfcache)
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
@@ -134,7 +134,7 @@ print_spis(const char *name, u_int32_t min, u_int32_t max,
 
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
 
diff --git a/extensions/libipt_comment.c b/extensions/libipt_comment.c
index 1b73c23..ba0e92f 100644
--- a/extensions/libipt_comment.c
+++ b/extensions/libipt_comment.c
@@ -45,7 +45,7 @@ parse_comment(const char *s, struct ipt_comment_info *info)
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
index c59f9be..69b39bd 100644
--- a/extensions/libipt_connbytes.c
+++ b/extensions/libipt_connbytes.c
@@ -49,7 +49,7 @@ parse_range(const char *arg, struct ipt_connbytes_info *si)
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
@@ -146,7 +146,7 @@ static void print_direction(struct ipt_connbytes_info *sinfo)
 
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
 
diff --git a/extensions/libipt_connmark.c b/extensions/libipt_connmark.c
index 9412d66..86248d9 100644
--- a/extensions/libipt_connmark.c
+++ b/extensions/libipt_connmark.c
@@ -56,7 +56,7 @@ init(struct xt_entry_match *m, unsigned int *nfcache)
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
index b22f191..2792050 100644
--- a/extensions/libipt_connrate.c
+++ b/extensions/libipt_connrate.c
@@ -76,7 +76,7 @@ parse_range(const char *arg, struct ipt_connrate_info *si)
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
@@ -138,7 +138,7 @@ print_range(struct ipt_connrate_info *sinfo)
 
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
index 18f97b3..15d4264 100644
--- a/extensions/libipt_conntrack.c
+++ b/extensions/libipt_conntrack.c
@@ -167,7 +167,7 @@ parse_expires(const char *s, struct ipt_conntrack_info *sinfo)
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
@@ -412,7 +412,7 @@ print_addr(struct in_addr *addr, struct in_addr *mask, int inv, int numeric)
 
 /* Saves the matchinfo in parsable form to stdout. */
 static void
-matchinfo_print(const struct ipt_ip *ip, const struct xt_entry_match *match, int numeric, const char *optpfx)
+matchinfo_print(const void *ip, const struct xt_entry_match *match, int numeric, const char *optpfx)
 {
 	struct ipt_conntrack_info *sinfo = (struct ipt_conntrack_info *)match->data;
 
@@ -491,7 +491,7 @@ matchinfo_print(const struct ipt_ip *ip, const struct xt_entry_match *match, int
 
 /* Prints out the matchinfo. */
 static void
-print(const struct ipt_ip *ip,
+print(const void *ip,
       const struct xt_entry_match *match,
       int numeric)
 {
@@ -499,7 +499,7 @@ print(const struct ipt_ip *ip,
 }
 
 /* Saves the matchinfo in parsable form to stdout. */
-static void save(const struct ipt_ip *ip, const struct xt_entry_match *match)
+static void save(const void *ip, const struct xt_entry_match *match)
 {
 	matchinfo_print(ip, match, 1, "--");
 }
diff --git a/extensions/libipt_dccp.c b/extensions/libipt_dccp.c
index b86d2a4..306993a 100644
--- a/extensions/libipt_dccp.c
+++ b/extensions/libipt_dccp.c
@@ -134,7 +134,7 @@ static u_int8_t parse_dccp_option(char *optstring)
 
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
@@ -279,7 +279,7 @@ print_option(u_int8_t option, int invert, int numeric)
 
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
@@ -75,7 +75,7 @@ parse_class(const char *s, struct ipt_dscp_info *dinfo)
 
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
@@ -131,7 +131,7 @@ print_dscp(u_int8_t dscp, int invert, int numeric)
 
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
@@ -84,7 +84,7 @@ init(struct xt_entry_match *m, unsigned int *nfcache)
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
@@ -137,7 +137,7 @@ print_spis(const char *name, u_int32_t min, u_int32_t max,
 
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
 
diff --git a/extensions/libipt_hashlimit.c b/extensions/libipt_hashlimit.c
index 527b2e8..552d3bf 100644
--- a/extensions/libipt_hashlimit.c
+++ b/extensions/libipt_hashlimit.c
@@ -151,7 +151,7 @@ static int parse_mode(struct ipt_hashlimit_info *r, char *optarg)
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
@@ -304,7 +304,7 @@ static void print_mode(const struct ipt_hashlimit_info *r, char separator)
 
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
index d6fd485..4cbccd5 100644
--- a/extensions/libipt_icmp.c
+++ b/extensions/libipt_icmp.c
@@ -181,7 +181,7 @@ init(struct xt_entry_match *m, unsigned int *nfcache)
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
@@ -246,7 +246,7 @@ static void print_icmptype(u_int8_t type,
 
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
@@ -56,7 +56,7 @@ parse_iprange(char *arg, struct ipt_iprange *range)
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
@@ -122,7 +122,7 @@ print_iprange(const struct ipt_iprange *range)
 
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
 
diff --git a/extensions/libipt_length.c b/extensions/libipt_length.c
index 49d91b8..f542a35 100644
--- a/extensions/libipt_length.c
+++ b/extensions/libipt_length.c
@@ -66,7 +66,7 @@ parse_lengths(const char *s, struct ipt_length_info *info)
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
@@ -115,7 +115,7 @@ print_length(struct ipt_length_info *info)
 
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
@@ -93,7 +93,7 @@ init(struct xt_entry_match *m, unsigned int *nfcache)
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
@@ -56,7 +56,7 @@ parse_mac(const char *mac, struct ipt_mac_info *info)
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
@@ -98,7 +98,7 @@ static void final_check(unsigned int flags)
 
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
index 869c758..089a472 100644
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
@@ -77,7 +77,7 @@ final_check(unsigned int flags)
 
 /* Prints out the matchinfo. */
 static void
-print(const struct ipt_ip *ip,
+print(const void *ip,
       const struct xt_entry_match *match,
       int numeric)
 {
@@ -93,7 +93,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the union ipt_matchinfo in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct xt_entry_match *match)
+save(const void *ip, const struct xt_entry_match *match)
 {
 	struct ipt_mark_info *info = (struct ipt_mark_info *)match->data;
 
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
@@ -41,7 +41,7 @@ init(struct xt_entry_match *m, unsigned int *nfcache)
 
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
@@ -121,7 +121,7 @@ static void final_check(unsigned int flags)
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
@@ -86,7 +86,7 @@ static void parse_pkttype(const char *pkttype, struct ipt_pkttype_info *info)
 }
 
 static int parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
@@ -131,7 +131,7 @@ static void print_pkttype(struct ipt_pkttype_info *info)
 	printf("%d ", info->pkttype);	/* in case we didn't find an entry in named-packtes */
 }
 
-static void print(const struct ipt_ip *ip, const struct xt_entry_match *match, int numeric)
+static void print(const void *ip, const struct xt_entry_match *match, int numeric)
 {
 	struct ipt_pkttype_info *info = (struct ipt_pkttype_info *)match->data;
 	
@@ -139,7 +139,7 @@ static void print(const struct ipt_ip *ip, const struct xt_entry_match *match, i
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
@@ -387,7 +387,7 @@ static void print_flags(char *prefix, const struct ipt_policy_info *info)
 		printf("%sstrict ", prefix);
 }
 
-static void print(const struct ipt_ip *ip,
+static void print(const void *ip,
                   const struct xt_entry_match *match,
 		  int numeric)
 {
@@ -403,7 +403,7 @@ static void print(const struct ipt_ip *ip,
 	}
 }
 
-static void save(const struct ipt_ip *ip, const struct xt_entry_match *match)
+static void save(const void *ip, const struct xt_entry_match *match)
 {
 	const struct ipt_policy_info *info = (void *)match->data;
 	unsigned int i;
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
@@ -35,7 +35,7 @@ print(const struct ipt_ip *ip, const struct xt_entry_match *match, int numeric)
 
 /* save matchinfo */
 static void
-save(const struct ipt_ip *ip, const struct xt_entry_match *match)
+save(const void *ip, const struct xt_entry_match *match)
 {
         struct xt_quota_info *q = (struct xt_quota_info *) match->data;
         printf("--quota %llu ", (unsigned long long) q->quota);
@@ -60,7 +60,7 @@ parse_quota(const char *s, u_int64_t * quota)
 /* parse all options, returning true if we found any for us */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *entry,
       unsigned int *nfcache, struct xt_entry_match **match)
 {
         struct xt_quota_info *info = (struct xt_quota_info *) (*match)->data;
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
@@ -215,7 +215,7 @@ print_realm(unsigned long id, unsigned long mask, int numeric)
 
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
@@ -84,7 +84,7 @@ init(struct xt_entry_match *match, unsigned int *nfcache)
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
 
diff --git a/extensions/libipt_sctp.c b/extensions/libipt_sctp.c
index c1aa2ce..89b65fc 100644
--- a/extensions/libipt_sctp.c
+++ b/extensions/libipt_sctp.c
@@ -263,7 +263,7 @@ parse_sctp_chunks(struct ipt_sctp_info *einfo,
 
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
index b9f3122..4bd9bd2 100644
--- a/extensions/libipt_set.c
+++ b/extensions/libipt_set.c
@@ -51,7 +51,7 @@ static void init(struct xt_entry_match *match, unsigned int *nfcache)
 /* Function which parses command options; returns true if it ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *entry,
       unsigned int *nfcache, struct xt_entry_match **match)
 {
 	struct ipt_set_info_match *myinfo = 
@@ -126,7 +126,7 @@ print_match(const char *prefix, const struct ipt_set_info *info)
 
 /* Prints out the matchinfo. */
 static void
-print(const struct ipt_ip *ip,
+print(const void *ip,
       const struct xt_entry_match *match, int numeric)
 {
 	struct ipt_set_info_match *info = 
@@ -136,7 +136,7 @@ print(const struct ipt_ip *ip,
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
@@ -30,7 +30,7 @@ init(struct xt_entry_target *t, unsigned int *nfcache)
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *entry,
       struct xt_entry_target **target)
 {
 	return 0;
@@ -43,7 +43,7 @@ static void final_check(unsigned int flags)
 
 /* Saves the targinfo in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct xt_entry_target *target)
+save(const void *ip, const struct xt_entry_target *target)
 {
 }
 
diff --git a/extensions/libipt_state.c b/extensions/libipt_state.c
index f5772db..fcfee46 100644
--- a/extensions/libipt_state.c
+++ b/extensions/libipt_state.c
@@ -65,7 +65,7 @@ parse_states(const char *arg, struct ipt_state_info *sinfo)
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
@@ -124,7 +124,7 @@ static void print_state(unsigned int statemask)
 
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
index 41b6483..52357ec 100644
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
@@ -146,7 +146,7 @@ static void print_match(const struct xt_statistic_info *info, char *prefix)
 }
 
 static void
-print(const struct ipt_ip *ip,
+print(const void *ip,
       const struct xt_entry_match *match,
       int numeric)
 {
@@ -158,7 +158,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the union ipt_matchinfo in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct xt_entry_match *match)
+save(const void *ip, const struct xt_entry_match *match)
 {
 	struct xt_statistic_info *info = (struct xt_statistic_info *)match->data;
 
diff --git a/extensions/libipt_string.c b/extensions/libipt_string.c
index 82a0f7c..186013a 100644
--- a/extensions/libipt_string.c
+++ b/extensions/libipt_string.c
@@ -170,7 +170,7 @@ parse_hex_string(const char *s, struct ipt_string_info *info)
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
@@ -289,7 +289,7 @@ print_string(const char *str, const unsigned short int len)
 
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
index bfbebc1..d788506 100644
--- a/extensions/libipt_tcp.c
+++ b/extensions/libipt_tcp.c
@@ -147,7 +147,7 @@ init(struct xt_entry_match *m, unsigned int *nfcache)
    ate an option. */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
@@ -317,7 +317,7 @@ print_flags(u_int8_t mask, u_int8_t cmp, int invert, int numeric)
 
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
@@ -60,7 +60,7 @@ parse_tcp_mssvalues(const char *mssvaluestring,
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
diff --git a/extensions/libipt_tos.c b/extensions/libipt_tos.c
index 7fdc9f7..6ee1abc 100644
--- a/extensions/libipt_tos.c
+++ b/extensions/libipt_tos.c
@@ -76,7 +76,7 @@ parse_tos(const char *s, struct ipt_tos_info *info)
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
index 7021095..fb0cd6f 100644
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
@@ -92,7 +92,7 @@ static void final_check(unsigned int flags)
 			"`--ttl-eq', `--ttl-lt', `--ttl-gt");
 }
 
-static void print(const struct ipt_ip *ip, 
+static void print(const void *ip,
 		const struct xt_entry_match *match,
 		int numeric)
 {
@@ -117,7 +117,7 @@ static void print(const struct ipt_ip *ip,
 	printf("%u ", info->ttl);
 }
 
-static void save(const struct ipt_ip *ip, 
+static void save(const void *ip,
 		const struct xt_entry_match *match)
 {
 	const struct ipt_ttl_info *info =
diff --git a/extensions/libipt_udp.c b/extensions/libipt_udp.c
index 0d7cb97..5e7b4a2 100644
--- a/extensions/libipt_udp.c
+++ b/extensions/libipt_udp.c
@@ -69,7 +69,7 @@ init(struct xt_entry_match *m, unsigned int *nfcache)
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
@@ -156,7 +156,7 @@ print_ports(const char *name, u_int16_t min, u_int16_t max,
 
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
1.5.2.2
