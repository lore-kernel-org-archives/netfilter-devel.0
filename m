From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 07/43] replaces ipt_entry_* with xt_entry_* in
 matches/targets
Date: Sun, 15 Jul 2007 02:22:52 +0900 (JST)
Message-ID: <200707141722.l6EHMrWQ023114@toshiba.co.jp>
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
 extensions/libipt_CLASSIFY.c    |    8 ++++----
 extensions/libipt_CLUSTERIP.c   |    8 ++++----
 extensions/libipt_CONNMARK.c    |   10 +++++-----
 extensions/libipt_CONNSECMARK.c |    6 +++---
 extensions/libipt_DNAT.c        |   10 +++++-----
 extensions/libipt_DSCP.c        |    8 ++++----
 extensions/libipt_ECN.c         |    8 ++++----
 extensions/libipt_LOG.c         |    8 ++++----
 extensions/libipt_MARK.c        |   14 +++++++-------
 extensions/libipt_MASQUERADE.c  |    8 ++++----
 extensions/libipt_MIRROR.c      |    4 ++--
 extensions/libipt_NETMAP.c      |    8 ++++----
 extensions/libipt_NFQUEUE.c     |    8 ++++----
 extensions/libipt_NOTRACK.c     |    4 ++--
 extensions/libipt_REDIRECT.c    |    8 ++++----
 extensions/libipt_REJECT.c      |    8 ++++----
 extensions/libipt_SAME.c        |    8 ++++----
 extensions/libipt_SECMARK.c     |    8 ++++----
 extensions/libipt_SET.c         |    8 ++++----
 extensions/libipt_SNAT.c        |   10 +++++-----
 extensions/libipt_TCPMSS.c      |   10 +++++-----
 extensions/libipt_TOS.c         |   10 +++++-----
 extensions/libipt_TTL.c         |    8 ++++----
 extensions/libipt_ULOG.c        |    8 ++++----
 extensions/libipt_addrtype.c    |    6 +++---
 extensions/libipt_ah.c          |    8 ++++----
 extensions/libipt_comment.c     |    6 +++---
 extensions/libipt_condition.c   |    6 +++---
 extensions/libipt_connbytes.c   |    6 +++---
 extensions/libipt_connmark.c    |    8 ++++----
 extensions/libipt_connrate.c    |    6 +++---
 extensions/libipt_conntrack.c   |    8 ++++----
 extensions/libipt_dccp.c        |    8 ++++----
 extensions/libipt_dscp.c        |    6 +++---
 extensions/libipt_ecn.c         |    6 +++---
 extensions/libipt_esp.c         |    8 ++++----
 extensions/libipt_hashlimit.c   |    8 ++++----
 extensions/libipt_helper.c      |    6 +++---
 extensions/libipt_icmp.c        |    8 ++++----
 extensions/libipt_iprange.c     |    6 +++---
 extensions/libipt_length.c      |    6 +++---
 extensions/libipt_limit.c       |    8 ++++----
 extensions/libipt_mac.c         |    6 +++---
 extensions/libipt_mark.c        |    6 +++---
 extensions/libipt_multiport.c   |   14 +++++++-------
 extensions/libipt_owner.c       |    6 +++---
 extensions/libipt_physdev.c     |    8 ++++----
 extensions/libipt_pkttype.c     |    6 +++---
 extensions/libipt_policy.c      |    8 ++++----
 extensions/libipt_quota.c       |    6 +++---
 extensions/libipt_realm.c       |    6 +++---
 extensions/libipt_recent.c      |    8 ++++----
 extensions/libipt_sctp.c        |    8 ++++----
 extensions/libipt_set.c         |    8 ++++----
 extensions/libipt_standard.c    |    6 +++---
 extensions/libipt_state.c       |    6 +++---
 extensions/libipt_statistic.c   |    6 +++---
 extensions/libipt_string.c      |    8 ++++----
 extensions/libipt_tcp.c         |    8 ++++----
 extensions/libipt_tcpmss.c      |    6 +++---
 extensions/libipt_tos.c         |    6 +++---
 extensions/libipt_ttl.c         |    6 +++---
 extensions/libipt_udp.c         |    8 ++++----
 extensions/libipt_unclean.c     |    2 +-
 64 files changed, 237 insertions(+), 237 deletions(-)

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
 
@@ -48,7 +48,7 @@ int string_to_priority(const char *s, unsigned int *p)
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
-      struct ipt_entry_target **target)
+      struct xt_entry_target **target)
 {
 	struct ipt_classify_target_info *clinfo
 		= (struct ipt_classify_target_info *)(*target)->data;
@@ -88,7 +88,7 @@ print_class(unsigned int priority, int numeric)
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
@@ -208,7 +208,7 @@ static char *mac2str(const u_int8_t mac[ETH_ALEN])
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
 
@@ -67,7 +67,7 @@ init(struct ipt_entry_target *t, unsigned int *nfcache)
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
-      struct ipt_entry_target **target)
+      struct xt_entry_target **target)
 {
 	struct ipt_connmark_target_info *markinfo
 		= (struct ipt_connmark_target_info *)(*target)->data;
@@ -145,7 +145,7 @@ print_mask(const char *text, unsigned long mask)
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
@@ -87,7 +87,7 @@ static void print_connsecmark(struct xt_connsecmark_target_info *info)
 }
 
 static void print(const struct ipt_ip *ip,
-		  const struct ipt_entry_target *target, int numeric)
+		  const struct xt_entry_target *target, int numeric)
 {
 	struct xt_connsecmark_target_info *info =
 		(struct xt_connsecmark_target_info*)(target)->data;
@@ -96,7 +96,7 @@ static void print(const struct ipt_ip *ip,
 	print_connsecmark(info);
 }
 
-static void save(const struct ipt_ip *ip, const struct ipt_entry_target *target)
+static void save(const struct ipt_ip *ip, const struct xt_entry_target *target)
 {
 	struct xt_connsecmark_target_info *info =
 		(struct xt_connsecmark_target_info*)target->data;
diff --git a/extensions/libipt_DNAT.c b/extensions/libipt_DNAT.c
index b0def31..7dce2d4 100644
--- a/extensions/libipt_DNAT.c
+++ b/extensions/libipt_DNAT.c
@@ -15,7 +15,7 @@
    to. */
 struct ipt_natinfo
 {
-	struct ipt_entry_target t;
+	struct xt_entry_target t;
 	struct ip_nat_multi_range mr;
 };
 
@@ -58,7 +58,7 @@ append_range(struct ipt_natinfo *info, const struct ip_nat_range *range)
 }
 
 /* Ranges expected in network order. */
-static struct ipt_entry_target *
+static struct xt_entry_target *
 parse_to(char *arg, int portok, struct ipt_natinfo *info)
 {
 	struct ip_nat_range range;
@@ -142,7 +142,7 @@ parse_to(char *arg, int portok, struct ipt_natinfo *info)
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
-      struct ipt_entry_target **target)
+      struct xt_entry_target **target)
 {
 	struct ipt_natinfo *info = (void *)*target;
 	int portok;
@@ -216,7 +216,7 @@ static void print_range(const struct ip_nat_range *r)
 /* Prints out the targinfo. */
 static void
 print(const struct ipt_ip *ip,
-      const struct ipt_entry_target *target,
+      const struct xt_entry_target *target,
       int numeric)
 {
 	struct ipt_natinfo *info = (void *)target;
@@ -233,7 +233,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the union ipt_targinfo in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct ipt_entry_target *target)
+save(const struct ipt_ip *ip, const struct xt_entry_target *target)
 {
 	struct ipt_natinfo *info = (void *)target;
 	unsigned int i = 0;
diff --git a/extensions/libipt_DSCP.c b/extensions/libipt_DSCP.c
index c50d902..26f70bd 100644
--- a/extensions/libipt_DSCP.c
+++ b/extensions/libipt_DSCP.c
@@ -22,7 +22,7 @@
 #include "libipt_dscp_helper.c"
 
 
-static void init(struct ipt_entry_target *t, unsigned int *nfcache) 
+static void init(struct xt_entry_target *t, unsigned int *nfcache)
 {
 }
 
@@ -79,7 +79,7 @@ parse_class(const char *s, struct ipt_DSCP_info *dinfo)
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
index 7e8d0c4..9e02204 100644
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
 
@@ -207,7 +207,7 @@ static void final_check(unsigned int flags)
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
index b841352..8157f1e 100644
--- a/extensions/libipt_MARK.c
+++ b/extensions/libipt_MARK.c
@@ -31,7 +31,7 @@ static struct option opts[] = {
 
 /* Initialize the target. */
 static void
-init(struct ipt_entry_target *t, unsigned int *nfcache)
+init(struct xt_entry_target *t, unsigned int *nfcache)
 {
 }
 
@@ -40,7 +40,7 @@ init(struct ipt_entry_target *t, unsigned int *nfcache)
 static int
 parse_v0(int c, char **argv, int invert, unsigned int *flags,
 	 const struct ipt_entry *entry,
-	 struct ipt_entry_target **target)
+	 struct xt_entry_target **target)
 {
 	struct ipt_mark_target_info *markinfo
 		= (struct ipt_mark_target_info *)(*target)->data;
@@ -82,7 +82,7 @@ final_check(unsigned int flags)
 static int
 parse_v1(int c, char **argv, int invert, unsigned int *flags,
 	 const struct ipt_entry *entry,
-	 struct ipt_entry_target **target)
+	 struct xt_entry_target **target)
 {
 	struct ipt_mark_target_info_v1 *markinfo
 		= (struct ipt_mark_target_info_v1 *)(*target)->data;
@@ -121,7 +121,7 @@ print_mark(unsigned long mark)
 /* Prints out the targinfo. */
 static void
 print_v0(const struct ipt_ip *ip,
-	 const struct ipt_entry_target *target,
+	 const struct xt_entry_target *target,
 	 int numeric)
 {
 	const struct ipt_mark_target_info *markinfo =
@@ -132,7 +132,7 @@ print_v0(const struct ipt_ip *ip,
 
 /* Saves the union ipt_targinfo in parsable form to stdout. */
 static void
-save_v0(const struct ipt_ip *ip, const struct ipt_entry_target *target)
+save_v0(const struct ipt_ip *ip, const struct xt_entry_target *target)
 {
 	const struct ipt_mark_target_info *markinfo =
 		(const struct ipt_mark_target_info *)target->data;
@@ -144,7 +144,7 @@ save_v0(const struct ipt_ip *ip, const struct ipt_entry_target *target)
 /* Prints out the targinfo. */
 static void
 print_v1(const struct ipt_ip *ip,
-	 const struct ipt_entry_target *target,
+	 const struct xt_entry_target *target,
 	 int numeric)
 {
 	const struct ipt_mark_target_info_v1 *markinfo =
@@ -166,7 +166,7 @@ print_v1(const struct ipt_ip *ip,
 
 /* Saves the union ipt_targinfo in parsable form to stdout. */
 static void
-save_v1(const struct ipt_ip *ip, const struct ipt_entry_target *target)
+save_v1(const struct ipt_ip *ip, const struct xt_entry_target *target)
 {
 	const struct ipt_mark_target_info_v1 *markinfo =
 		(const struct ipt_mark_target_info_v1 *)target->data;
diff --git a/extensions/libipt_MASQUERADE.c b/extensions/libipt_MASQUERADE.c
index c24bb32..8db6bdd 100644
--- a/extensions/libipt_MASQUERADE.c
+++ b/extensions/libipt_MASQUERADE.c
@@ -31,7 +31,7 @@ static struct option opts[] = {
 
 /* Initialize the target. */
 static void
-init(struct ipt_entry_target *t, unsigned int *nfcache)
+init(struct xt_entry_target *t, unsigned int *nfcache)
 {
 	struct ip_nat_multi_range *mr = (struct ip_nat_multi_range *)t->data;
 
@@ -79,7 +79,7 @@ parse_ports(const char *arg, struct ip_nat_multi_range *mr)
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
-      struct ipt_entry_target **target)
+      struct xt_entry_target **target)
 {
 	int portok;
 	struct ip_nat_multi_range *mr
@@ -122,7 +122,7 @@ static void final_check(unsigned int flags)
 /* Prints out the targinfo. */
 static void
 print(const struct ipt_ip *ip,
-      const struct ipt_entry_target *target,
+      const struct xt_entry_target *target,
       int numeric)
 {
 	struct ip_nat_multi_range *mr
@@ -143,7 +143,7 @@ print(const struct ipt_ip *ip,
 
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
 
@@ -31,7 +31,7 @@ init(struct ipt_entry_target *t, unsigned int *nfcache)
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
-      struct ipt_entry_target **target)
+      struct xt_entry_target **target)
 {
 	return 0;
 }
diff --git a/extensions/libipt_NETMAP.c b/extensions/libipt_NETMAP.c
index 4b4b14d..37af94b 100644
--- a/extensions/libipt_NETMAP.c
+++ b/extensions/libipt_NETMAP.c
@@ -56,7 +56,7 @@ netmask2bits(u_int32_t netmask)
 
 /* Initialize the target. */
 static void
-init(struct ipt_entry_target *t, unsigned int *nfcache)
+init(struct xt_entry_target *t, unsigned int *nfcache)
 {
 	struct ip_nat_multi_range *mr = (struct ip_nat_multi_range *)t->data;
 
@@ -119,7 +119,7 @@ parse_to(char *arg, struct ip_nat_range *range)
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
-      struct ipt_entry_target **target)
+      struct xt_entry_target **target)
 {
 	struct ip_nat_multi_range *mr
 		= (struct ip_nat_multi_range *)(*target)->data;
@@ -150,7 +150,7 @@ static void final_check(unsigned int flags)
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
index bc4e82f..8f89828 100644
--- a/extensions/libipt_NFQUEUE.c
+++ b/extensions/libipt_NFQUEUE.c
@@ -14,7 +14,7 @@
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_NFQUEUE.h>
 
-static void init(struct ipt_entry_target *t, unsigned int *nfcache) 
+static void init(struct xt_entry_target *t, unsigned int *nfcache)
 {
 }
 
@@ -48,7 +48,7 @@ parse_num(const char *s, struct ipt_NFQ_info *tinfo)
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
 
@@ -31,7 +31,7 @@ init(struct ipt_entry_target *t, unsigned int *nfcache)
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
-      struct ipt_entry_target **target)
+      struct xt_entry_target **target)
 {
 	return 0;
 }
diff --git a/extensions/libipt_REDIRECT.c b/extensions/libipt_REDIRECT.c
index 6b38716..3810b99 100644
--- a/extensions/libipt_REDIRECT.c
+++ b/extensions/libipt_REDIRECT.c
@@ -30,7 +30,7 @@ static struct option opts[] = {
 
 /* Initialize the target. */
 static void
-init(struct ipt_entry_target *t, unsigned int *nfcache)
+init(struct xt_entry_target *t, unsigned int *nfcache)
 {
 	struct ip_nat_multi_range *mr = (struct ip_nat_multi_range *)t->data;
 
@@ -81,7 +81,7 @@ parse_ports(const char *arg, struct ip_nat_multi_range *mr)
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
-      struct ipt_entry_target **target)
+      struct xt_entry_target **target)
 {
 	struct ip_nat_multi_range *mr
 		= (struct ip_nat_multi_range *)(*target)->data;
@@ -131,7 +131,7 @@ static void final_check(unsigned int flags)
 /* Prints out the targinfo. */
 static void
 print(const struct ipt_ip *ip,
-      const struct ipt_entry_target *target,
+      const struct xt_entry_target *target,
       int numeric)
 {
 	struct ip_nat_multi_range *mr
@@ -151,7 +151,7 @@ print(const struct ipt_ip *ip,
 
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
 
@@ -101,7 +101,7 @@ init(struct ipt_entry_target *t, unsigned int *nfcache)
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
-      struct ipt_entry_target **target)
+      struct xt_entry_target **target)
 {
 	struct ipt_reject_info *reject = (struct ipt_reject_info *)(*target)->data;
 	unsigned int limit = sizeof(reject_table)/sizeof(struct reject_names);
@@ -140,7 +140,7 @@ static void final_check(unsigned int flags)
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
diff --git a/extensions/libipt_SAME.c b/extensions/libipt_SAME.c
index 7211f60..6e2353c 100644
--- a/extensions/libipt_SAME.c
+++ b/extensions/libipt_SAME.c
@@ -38,7 +38,7 @@ static struct option opts[] = {
 
 /* Initialize the target. */
 static void
-init(struct ipt_entry_target *t, unsigned int *nfcache)
+init(struct xt_entry_target *t, unsigned int *nfcache)
 {
 	struct ipt_same_info *mr = (struct ipt_same_info *)t->data;
 
@@ -90,7 +90,7 @@ parse_to(char *arg, struct ip_nat_range *range)
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
-      struct ipt_entry_target **target)
+      struct xt_entry_target **target)
 {
 	struct ipt_same_info *mr
 		= (struct ipt_same_info *)(*target)->data;
@@ -149,7 +149,7 @@ static void final_check(unsigned int flags)
 /* Prints out the targinfo. */
 static void
 print(const struct ipt_ip *ip,
-      const struct ipt_entry_target *target,
+      const struct xt_entry_target *target,
       int numeric)
 {
 	int count;
@@ -185,7 +185,7 @@ print(const struct ipt_ip *ip,
 
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
@@ -37,7 +37,7 @@ static void init(struct ipt_entry_target *t, unsigned int *nfcache)
  * ate an option.
  */
 static int parse(int c, char **argv, int invert, unsigned int *flags,
-                 const struct ipt_entry *entry, struct ipt_entry_target **target)
+                 const struct ipt_entry *entry, struct xt_entry_target **target)
 {
 	struct xt_secmark_target_info *info =
 		(struct xt_secmark_target_info*)(*target)->data;
@@ -84,7 +84,7 @@ static void print_secmark(struct xt_secmark_target_info *info)
 }
 
 static void print(const struct ipt_ip *ip,
-		  const struct ipt_entry_target *target, int numeric)
+		  const struct xt_entry_target *target, int numeric)
 {
 	struct xt_secmark_target_info *info =
 		(struct xt_secmark_target_info*)(target)->data;
@@ -94,7 +94,7 @@ static void print(const struct ipt_ip *ip,
 }
 
 /* Saves the target info in parsable form to stdout. */
-static void save(const struct ipt_ip *ip, const struct ipt_entry_target *target)
+static void save(const struct ipt_ip *ip, const struct xt_entry_target *target)
 {
 	struct xt_secmark_target_info *info =
 		(struct xt_secmark_target_info*)target->data;
diff --git a/extensions/libipt_SET.c b/extensions/libipt_SET.c
index 1d8ace6..1c11631 100644
--- a/extensions/libipt_SET.c
+++ b/extensions/libipt_SET.c
@@ -41,7 +41,7 @@ static struct option opts[] = {
 };
 
 /* Initialize the target. */
-static void init(struct ipt_entry_target *target, unsigned int *nfcache)
+static void init(struct xt_entry_target *target, unsigned int *nfcache)
 {
 	struct ipt_set_info_target *info =
 	    (struct ipt_set_info_target *) target->data;
@@ -85,7 +85,7 @@ parse_target(char **argv, int invert, unsigned int *flags,
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry, struct ipt_entry_target **target)
+      const struct ipt_entry *entry, struct xt_entry_target **target)
 {
 	struct ipt_set_info_target *myinfo =
 	    (struct ipt_set_info_target *) (*target)->data;
@@ -137,7 +137,7 @@ print_target(const char *prefix, const struct ipt_set_info *info)
 /* Prints out the targinfo. */
 static void
 print(const struct ipt_ip *ip,
-      const struct ipt_entry_target *target, int numeric)
+      const struct xt_entry_target *target, int numeric)
 {
 	struct ipt_set_info_target *info =
 	    (struct ipt_set_info_target *) target->data;
@@ -148,7 +148,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the union ipt_targinfo in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct ipt_entry_target *target)
+save(const struct ipt_ip *ip, const struct xt_entry_target *target)
 {
 	struct ipt_set_info_target *info =
 	    (struct ipt_set_info_target *) target->data;
diff --git a/extensions/libipt_SNAT.c b/extensions/libipt_SNAT.c
index 0a665a0..bdf9429 100644
--- a/extensions/libipt_SNAT.c
+++ b/extensions/libipt_SNAT.c
@@ -15,7 +15,7 @@
    to. */
 struct ipt_natinfo
 {
-	struct ipt_entry_target t;
+	struct xt_entry_target t;
 	struct ip_nat_multi_range mr;
 };
 
@@ -58,7 +58,7 @@ append_range(struct ipt_natinfo *info, const struct ip_nat_range *range)
 }
 
 /* Ranges expected in network order. */
-static struct ipt_entry_target *
+static struct xt_entry_target *
 parse_to(char *arg, int portok, struct ipt_natinfo *info)
 {
 	struct ip_nat_range range;
@@ -142,7 +142,7 @@ parse_to(char *arg, int portok, struct ipt_natinfo *info)
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
-      struct ipt_entry_target **target)
+      struct xt_entry_target **target)
 {
 	struct ipt_natinfo *info = (void *)*target;
 	int portok;
@@ -218,7 +218,7 @@ static void print_range(const struct ip_nat_range *r)
 /* Prints out the targinfo. */
 static void
 print(const struct ipt_ip *ip,
-      const struct ipt_entry_target *target,
+      const struct xt_entry_target *target,
       int numeric)
 {
 	struct ipt_natinfo *info = (void *)target;
@@ -235,7 +235,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the union ipt_targinfo in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct ipt_entry_target *target)
+save(const struct ipt_ip *ip, const struct xt_entry_target *target)
 {
 	struct ipt_natinfo *info = (void *)target;
 	unsigned int i = 0;
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
 
@@ -44,7 +44,7 @@ init(struct ipt_entry_target *t, unsigned int *nfcache)
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
 
@@ -87,7 +87,7 @@ parse_tos(const char *s, struct ipt_tos_target_info *info)
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
diff --git a/extensions/libipt_TTL.c b/extensions/libipt_TTL.c
index a2a28bd..7d47f2a 100644
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
@@ -97,7 +97,7 @@ static void final_check(unsigned int flags)
 }
 
 static void save(const struct ipt_ip *ip,
-		const struct ipt_entry_target *target)
+		const struct xt_entry_target *target)
 {
 	const struct ipt_TTL_info *info = 
 		(struct ipt_TTL_info *) target->data;
@@ -118,7 +118,7 @@ static void save(const struct ipt_ip *ip,
 }
 
 static void print(const struct ipt_ip *ip,
-		const struct ipt_entry_target *target, int numeric)
+		const struct xt_entry_target *target, int numeric)
 {
 	const struct ipt_TTL_info *info =
 		(struct ipt_TTL_info *) target->data;
diff --git a/extensions/libipt_ULOG.c b/extensions/libipt_ULOG.c
index f783f96..91fcfb0 100644
--- a/extensions/libipt_ULOG.c
+++ b/extensions/libipt_ULOG.c
@@ -53,7 +53,7 @@ static struct option opts[] = {
 };
 
 /* Initialize the target. */
-static void init(struct ipt_entry_target *t, unsigned int *nfcache)
+static void init(struct xt_entry_target *t, unsigned int *nfcache)
 {
 	struct ipt_ulog_info *loginfo = (struct ipt_ulog_info *) t->data;
 
@@ -71,7 +71,7 @@ static void init(struct ipt_entry_target *t, unsigned int *nfcache)
    ate an option */
 static int parse(int c, char **argv, int invert, unsigned int *flags,
 		 const struct ipt_entry *entry,
-		 struct ipt_entry_target **target)
+		 struct xt_entry_target **target)
 {
 	struct ipt_ulog_info *loginfo =
 	    (struct ipt_ulog_info *) (*target)->data;
@@ -157,7 +157,7 @@ static void final_check(unsigned int flags)
 
 /* Saves the union ipt_targinfo in parsable form to stdout. */
 static void save(const struct ipt_ip *ip,
-		 const struct ipt_entry_target *target)
+		 const struct xt_entry_target *target)
 {
 	const struct ipt_ulog_info *loginfo
 	    = (const struct ipt_ulog_info *) target->data;
@@ -179,7 +179,7 @@ static void save(const struct ipt_ip *ip,
 /* Prints out the targinfo. */
 static void
 print(const struct ipt_ip *ip,
-      const struct ipt_entry_target *target, int numeric)
+      const struct xt_entry_target *target, int numeric)
 {
 	const struct ipt_ulog_info *loginfo
 	    = (const struct ipt_ulog_info *) target->data;
diff --git a/extensions/libipt_addrtype.c b/extensions/libipt_addrtype.c
index d8e1929..dbf4be7 100644
--- a/extensions/libipt_addrtype.c
+++ b/extensions/libipt_addrtype.c
@@ -83,7 +83,7 @@ static void parse_types(const char *arg, u_int16_t *mask)
 
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
@@ -160,7 +160,7 @@ static void print(const struct ipt_ip *ip,
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
@@ -68,7 +68,7 @@ parse_ah_spis(const char *spistring, u_int32_t *spis)
 
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
 
@@ -135,7 +135,7 @@ print_spis(const char *name, u_int32_t min, u_int32_t max,
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
index f6439c2..c59f9be 100644
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
@@ -147,7 +147,7 @@ static void print_direction(struct ipt_connbytes_info *sinfo)
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
index 5abe3c4..b22f191 100644
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
@@ -139,7 +139,7 @@ print_range(struct ipt_connrate_info *sinfo)
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
index 7914d39..18f97b3 100644
--- a/extensions/libipt_conntrack.c
+++ b/extensions/libipt_conntrack.c
@@ -169,7 +169,7 @@ static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
       unsigned int *nfcache,
-      struct ipt_entry_match **match)
+      struct xt_entry_match **match)
 {
 	struct ipt_conntrack_info *sinfo = (struct ipt_conntrack_info *)(*match)->data;
 	char *protocol = NULL;
@@ -412,7 +412,7 @@ print_addr(struct in_addr *addr, struct in_addr *mask, int inv, int numeric)
 
 /* Saves the matchinfo in parsable form to stdout. */
 static void
-matchinfo_print(const struct ipt_ip *ip, const struct ipt_entry_match *match, int numeric, const char *optpfx)
+matchinfo_print(const struct ipt_ip *ip, const struct xt_entry_match *match, int numeric, const char *optpfx)
 {
 	struct ipt_conntrack_info *sinfo = (struct ipt_conntrack_info *)match->data;
 
@@ -492,14 +492,14 @@ matchinfo_print(const struct ipt_ip *ip, const struct ipt_entry_match *match, in
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
index e5782a8..b86d2a4 100644
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
@@ -280,7 +280,7 @@ print_option(u_int8_t option, int invert, int numeric)
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
@@ -132,7 +132,7 @@ print_dscp(u_int8_t dscp, int invert, int numeric)
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
@@ -71,7 +71,7 @@ parse_esp_spis(const char *spistring, u_int32_t *spis)
 
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
 
@@ -138,7 +138,7 @@ print_spis(const char *name, u_int32_t min, u_int32_t max,
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
 
diff --git a/extensions/libipt_hashlimit.c b/extensions/libipt_hashlimit.c
index 6fb0ecc..527b2e8 100644
--- a/extensions/libipt_hashlimit.c
+++ b/extensions/libipt_hashlimit.c
@@ -96,7 +96,7 @@ int parse_rate(const char *rate, u_int32_t *val)
 
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
@@ -305,7 +305,7 @@ static void print_mode(const struct ipt_hashlimit_info *r, char separator)
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
index a6e642a..d6fd485 100644
--- a/extensions/libipt_icmp.c
+++ b/extensions/libipt_icmp.c
@@ -169,7 +169,7 @@ parse_icmp(const char *icmptype, u_int8_t *type, u_int8_t code[])
 
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
 
@@ -247,7 +247,7 @@ static void print_icmptype(u_int8_t type,
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
 
@@ -123,7 +123,7 @@ print_iprange(const struct ipt_iprange *range)
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
 
@@ -116,7 +116,7 @@ print_length(struct ipt_length_info *info)
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
@@ -74,7 +74,7 @@ int parse_rate(const char *rate, u_int32_t *val)
 
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
 
@@ -99,7 +99,7 @@ static void final_check(unsigned int flags)
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
index 10dfad5..869c758 100644
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
 
@@ -78,7 +78,7 @@ final_check(unsigned int flags)
 /* Prints out the matchinfo. */
 static void
 print(const struct ipt_ip *ip,
-      const struct ipt_entry_match *match,
+      const struct xt_entry_match *match,
       int numeric)
 {
 	struct ipt_mark_info *info = (struct ipt_mark_info *)match->data;
@@ -93,7 +93,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the union ipt_matchinfo in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct ipt_entry_match *match)
+save(const struct ipt_ip *ip, const struct xt_entry_match *match)
 {
 	struct ipt_mark_info *info = (struct ipt_mark_info *)match->data;
 
diff --git a/extensions/libipt_multiport.c b/extensions/libipt_multiport.c
index 58b6a0e..889e439 100644
--- a/extensions/libipt_multiport.c
+++ b/extensions/libipt_multiport.c
@@ -132,7 +132,7 @@ parse_multi_ports_v1(const char *portstring,
 
 /* Initialize the match. */
 static void
-init(struct ipt_entry_match *m, unsigned int *nfcache)
+init(struct xt_entry_match *m, unsigned int *nfcache)
 {
 }
 
@@ -162,7 +162,7 @@ static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
       unsigned int *nfcache,
-      struct ipt_entry_match **match)
+      struct xt_entry_match **match)
 {
 	const char *proto;
 	struct ipt_multiport *multiinfo
@@ -212,7 +212,7 @@ static int
 parse_v1(int c, char **argv, int invert, unsigned int *flags,
 	 const struct ipt_entry *entry,
 	 unsigned int *nfcache,
-	 struct ipt_entry_match **match)
+	 struct xt_entry_match **match)
 {
 	const char *proto;
 	struct ipt_multiport_v1 *multiinfo
@@ -287,7 +287,7 @@ print_port(u_int16_t port, u_int8_t protocol, int numeric)
 /* Prints out the matchinfo. */
 static void
 print(const struct ipt_ip *ip,
-      const struct ipt_entry_match *match,
+      const struct xt_entry_match *match,
       int numeric)
 {
 	const struct ipt_multiport *multiinfo
@@ -323,7 +323,7 @@ print(const struct ipt_ip *ip,
 
 static void
 print_v1(const struct ipt_ip *ip,
-	 const struct ipt_entry_match *match,
+	 const struct xt_entry_match *match,
 	 int numeric)
 {
 	const struct ipt_multiport_v1 *multiinfo
@@ -365,7 +365,7 @@ print_v1(const struct ipt_ip *ip,
 }
 
 /* Saves the union ipt_matchinfo in parsable form to stdout. */
-static void save(const struct ipt_ip *ip, const struct ipt_entry_match *match)
+static void save(const struct ipt_ip *ip, const struct xt_entry_match *match)
 {
 	const struct ipt_multiport *multiinfo
 		= (const struct ipt_multiport *)match->data;
@@ -393,7 +393,7 @@ static void save(const struct ipt_ip *ip, const struct ipt_entry_match *match)
 }
 
 static void save_v1(const struct ipt_ip *ip, 
-		    const struct ipt_entry_match *match)
+		    const struct xt_entry_match *match)
 {
 	const struct ipt_multiport_v1 *multiinfo
 		= (const struct ipt_multiport_v1 *)match->data;
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
@@ -122,7 +122,7 @@ static void final_check(unsigned int flags)
 
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
@@ -88,7 +88,7 @@ static void parse_pkttype(const char *pkttype, struct ipt_pkttype_info *info)
 static int parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
       unsigned int *nfcache,
-      struct ipt_entry_match **match)
+      struct xt_entry_match **match)
 {
 	struct ipt_pkttype_info *info = (struct ipt_pkttype_info *)(*match)->data;
 	
@@ -131,7 +131,7 @@ static void print_pkttype(struct ipt_pkttype_info *info)
 	printf("%d ", info->pkttype);	/* in case we didn't find an entry in named-packtes */
 }
 
-static void print(const struct ipt_ip *ip, const struct ipt_entry_match *match, int numeric)
+static void print(const struct ipt_ip *ip, const struct xt_entry_match *match, int numeric)
 {
 	struct ipt_pkttype_info *info = (struct ipt_pkttype_info *)match->data;
 	
@@ -139,7 +139,7 @@ static void print(const struct ipt_ip *ip, const struct ipt_entry_match *match,
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
@@ -388,7 +388,7 @@ static void print_flags(char *prefix, const struct ipt_policy_info *info)
 }
 
 static void print(const struct ipt_ip *ip,
-                  const struct ipt_entry_match *match,
+                  const struct xt_entry_match *match,
 		  int numeric)
 {
 	const struct ipt_policy_info *info = (void *)match->data;
@@ -403,7 +403,7 @@ static void print(const struct ipt_ip *ip,
 	}
 }
 
-static void save(const struct ipt_ip *ip, const struct ipt_entry_match *match)
+static void save(const struct ipt_ip *ip, const struct xt_entry_match *match)
 {
 	const struct ipt_policy_info *info = (void *)match->data;
 	unsigned int i;
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
@@ -35,7 +35,7 @@ print(const struct ipt_ip *ip, const struct ipt_entry_match *match, int numeric)
 
 /* save matchinfo */
 static void
-save(const struct ipt_ip *ip, const struct ipt_entry_match *match)
+save(const struct ipt_ip *ip, const struct xt_entry_match *match)
 {
         struct xt_quota_info *q = (struct xt_quota_info *) match->data;
         printf("--quota %llu ", (unsigned long long) q->quota);
@@ -61,7 +61,7 @@ parse_quota(const char *s, u_int64_t * quota)
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
-      unsigned int *nfcache, struct ipt_entry_match **match)
+      unsigned int *nfcache, struct xt_entry_match **match)
 {
         struct xt_quota_info *info = (struct xt_quota_info *) (*match)->data;
 
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
@@ -216,7 +216,7 @@ print_realm(unsigned long id, unsigned long mask, int numeric)
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
 
diff --git a/extensions/libipt_sctp.c b/extensions/libipt_sctp.c
index 0354d19..c1aa2ce 100644
--- a/extensions/libipt_sctp.c
+++ b/extensions/libipt_sctp.c
@@ -43,7 +43,7 @@ print_chunk(u_int32_t chunknum, int numeric);
 
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
index cf5d19d..b9f3122 100644
--- a/extensions/libipt_set.c
+++ b/extensions/libipt_set.c
@@ -38,7 +38,7 @@ static struct option opts[] = {
 };
 
 /* Initialize the match. */
-static void init(struct ipt_entry_match *match, unsigned int *nfcache)
+static void init(struct xt_entry_match *match, unsigned int *nfcache)
 {
 	struct ipt_set_info_match *info = 
 		(struct ipt_set_info_match *) match->data;
@@ -52,7 +52,7 @@ static void init(struct ipt_entry_match *match, unsigned int *nfcache)
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
-      unsigned int *nfcache, struct ipt_entry_match **match)
+      unsigned int *nfcache, struct xt_entry_match **match)
 {
 	struct ipt_set_info_match *myinfo = 
 		(struct ipt_set_info_match *) (*match)->data;
@@ -127,7 +127,7 @@ print_match(const char *prefix, const struct ipt_set_info *info)
 /* Prints out the matchinfo. */
 static void
 print(const struct ipt_ip *ip,
-      const struct ipt_entry_match *match, int numeric)
+      const struct xt_entry_match *match, int numeric)
 {
 	struct ipt_set_info_match *info = 
 		(struct ipt_set_info_match *) match->data;
@@ -137,7 +137,7 @@ print(const struct ipt_ip *ip,
 
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
 
@@ -31,7 +31,7 @@ init(struct ipt_entry_target *t, unsigned int *nfcache)
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
-      struct ipt_entry_target **target)
+      struct xt_entry_target **target)
 {
 	return 0;
 }
@@ -43,7 +43,7 @@ static void final_check(unsigned int flags)
 
 /* Saves the targinfo in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct ipt_entry_target *target)
+save(const struct ipt_ip *ip, const struct xt_entry_target *target)
 {
 }
 
diff --git a/extensions/libipt_state.c b/extensions/libipt_state.c
index 6a784ff..f5772db 100644
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
 
@@ -125,7 +125,7 @@ static void print_state(unsigned int statemask)
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
index f8aad2a..41b6483 100644
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
 
@@ -147,7 +147,7 @@ static void print_match(const struct xt_statistic_info *info, char *prefix)
 
 static void
 print(const struct ipt_ip *ip,
-      const struct ipt_entry_match *match,
+      const struct xt_entry_match *match,
       int numeric)
 {
 	struct xt_statistic_info *info = (struct xt_statistic_info *)match->data;
@@ -158,7 +158,7 @@ print(const struct ipt_ip *ip,
 
 /* Saves the union ipt_matchinfo in parsable form to stdout. */
 static void
-save(const struct ipt_ip *ip, const struct ipt_entry_match *match)
+save(const struct ipt_ip *ip, const struct xt_entry_match *match)
 {
 	struct xt_statistic_info *info = (struct xt_statistic_info *)match->data;
 
diff --git a/extensions/libipt_string.c b/extensions/libipt_string.c
index 266b3e5..82a0f7c 100644
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
 
@@ -290,7 +290,7 @@ print_string(const char *str, const unsigned short int len)
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
@@ -131,7 +131,7 @@ parse_tcp_option(const char *option, u_int8_t *result)
 
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
 
@@ -318,7 +318,7 @@ print_flags(u_int8_t mask, u_int8_t cmp, int invert, int numeric)
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
@@ -93,7 +93,7 @@ static void final_check(unsigned int flags)
 }
 
 static void print(const struct ipt_ip *ip, 
-		const struct ipt_entry_match *match,
+		const struct xt_entry_match *match,
 		int numeric)
 {
 	const struct ipt_ttl_info *info = 
@@ -118,7 +118,7 @@ static void print(const struct ipt_ip *ip,
 }
 
 static void save(const struct ipt_ip *ip, 
-		const struct ipt_entry_match *match)
+		const struct xt_entry_match *match)
 {
 	const struct ipt_ttl_info *info =
 		(struct ipt_ttl_info *) match->data;
diff --git a/extensions/libipt_udp.c b/extensions/libipt_udp.c
index 7f461d8..0d7cb97 100644
--- a/extensions/libipt_udp.c
+++ b/extensions/libipt_udp.c
@@ -55,7 +55,7 @@ parse_udp_ports(const char *portstring, u_int16_t *ports)
 
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
 
@@ -157,7 +157,7 @@ print_ports(const char *name, u_int16_t min, u_int16_t max,
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
1.5.2.2
