From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 09-2/43] Fixed warning on compilation of ip6tables
 matches/targets
Date: Fri, 20 Jul 2007 20:11:16 +0900 (JST)
Message-ID: <200707201111.l6KBBHT1002125@toshiba.co.jp>
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
- ip6t_ip6 * -> void *
- ip6t_entry * -> void *
---
 extensions/libip6t_CONNMARK.c    |    6 +++---
 extensions/libip6t_CONNSECMARK.c |    6 +++---
 extensions/libip6t_HL.c          |    6 +++---
 extensions/libip6t_LOG.c         |    6 +++---
 extensions/libip6t_MARK.c        |    6 +++---
 extensions/libip6t_NFLOG.c       |    6 +++---
 extensions/libip6t_NFQUEUE.c     |    6 +++---
 extensions/libip6t_REJECT.c      |    6 +++---
 extensions/libip6t_SECMARK.c     |    6 +++---
 extensions/libip6t_TCPMSS.c      |    6 +++---
 extensions/libip6t_ah.c          |    6 +++---
 extensions/libip6t_condition.c   |    6 +++---
 extensions/libip6t_connmark.c    |    6 +++---
 extensions/libip6t_dst.c         |    6 +++---
 extensions/libip6t_esp.c         |    6 +++---
 extensions/libip6t_eui64.c       |    6 +++---
 extensions/libip6t_frag.c        |    6 +++---
 extensions/libip6t_hashlimit.c   |    6 +++---
 extensions/libip6t_hbh.c         |    6 +++---
 extensions/libip6t_hl.c          |    6 +++---
 extensions/libip6t_icmp6.c       |    6 +++---
 extensions/libip6t_ipv6header.c  |    6 +++---
 extensions/libip6t_length.c      |    6 +++---
 extensions/libip6t_limit.c       |    6 +++---
 extensions/libip6t_mac.c         |    6 +++---
 extensions/libip6t_mark.c        |    6 +++---
 extensions/libip6t_mh.c          |    6 +++---
 extensions/libip6t_owner.c       |    6 +++---
 extensions/libip6t_physdev.c     |    6 +++---
 extensions/libip6t_policy.c      |    6 +++---
 extensions/libip6t_rt.c          |    6 +++---
 extensions/libip6t_sctp.c        |    6 +++---
 extensions/libip6t_standard.c    |    4 ++--
 extensions/libip6t_state.c       |    6 +++---
 extensions/libip6t_tcp.c         |    6 +++---
 extensions/libip6t_udp.c         |    6 +++---
 36 files changed, 107 insertions(+), 107 deletions(-)

diff --git a/extensions/libip6t_CONNMARK.c b/extensions/libip6t_CONNMARK.c
index 86b8e0f..69d3a5a 100644
--- a/extensions/libip6t_CONNMARK.c
+++ b/extensions/libip6t_CONNMARK.c
@@ -66,7 +66,7 @@ init(struct xt_entry_target *t, unsigned int *nfcache)
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ip6t_entry *entry,
+      const void *entry,
       struct xt_entry_target **target)
 {
 	struct ipt_connmark_target_info *markinfo
@@ -144,7 +144,7 @@ print_mask(const char *text, unsigned long mask)
 
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
@@ -86,7 +86,7 @@ static void print_connsecmark(struct xt_connsecmark_target_info *info)
 	}
 }
 
-static void print(const struct ip6t_ip6 *ip,
+static void print(const void *ip,
 		  const struct xt_entry_target *target, int numeric)
 {
 	struct xt_connsecmark_target_info *info =
@@ -96,7 +96,7 @@ static void print(const struct ip6t_ip6 *ip,
 	print_connsecmark(info);
 }
 
-static void save(const struct ip6t_ip6 *ip, const struct xt_entry_target *target)
+static void save(const void *ip, const struct xt_entry_target *target)
 {
 	struct xt_connsecmark_target_info *info =
 		(struct xt_connsecmark_target_info*)target->data;
diff --git a/extensions/libip6t_HL.c b/extensions/libip6t_HL.c
index fc6ba34..33bab71 100644
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
@@ -96,7 +96,7 @@ static void final_check(unsigned int flags)
 				"HL: You must specify an action");
 }
 
-static void save(const struct ip6t_ip6 *ip,
+static void save(const void *ip,
 		const struct xt_entry_target *target)
 {
 	const struct ip6t_HL_info *info = 
@@ -117,7 +117,7 @@ static void save(const struct ip6t_ip6 *ip,
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
@@ -206,7 +206,7 @@ static void final_check(unsigned int flags)
 
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
index e5b7c70..0ca4059 100644
--- a/extensions/libip6t_MARK.c
+++ b/extensions/libip6t_MARK.c
@@ -35,7 +35,7 @@ init(struct xt_entry_target *t, unsigned int *nfcache)
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ip6t_entry *entry,
+      const void *entry,
       struct xt_entry_target **target)
 {
 	struct ip6t_mark_target_info *markinfo
@@ -75,7 +75,7 @@ print_mark(unsigned long mark)
 
 /* Prints out the targinfo. */
 static void
-print(const struct ip6t_ip6 *ip,
+print(const void *ip,
       const struct xt_entry_target *target,
       int numeric)
 {
@@ -88,7 +88,7 @@ print(const struct ip6t_ip6 *ip,
 
 /* Saves the union ipt_targinfo in parsable form to stdout. */
 static void
-save(const struct ip6t_ip6 *ip, const struct xt_entry_target *target)
+save(const void *ip, const struct xt_entry_target *target)
 {
 	const struct ip6t_mark_target_info *markinfo =
 		(const struct ip6t_mark_target_info *)target->data;
diff --git a/extensions/libip6t_NFLOG.c b/extensions/libip6t_NFLOG.c
index 2c0cd3d..9f4ebaa 100644
--- a/extensions/libip6t_NFLOG.c
+++ b/extensions/libip6t_NFLOG.c
@@ -40,7 +40,7 @@ static void init(struct ip6t_entry_target *t, unsigned int *nfcache)
 }
 
 static int parse(int c, char **argv, int invert, unsigned int *flags,
-		 const struct ip6t_entry *entry,
+		 const void *entry,
 		 struct xt_entry_target **target)
 {
 	struct xt_nflog_info *info = (struct xt_nflog_info *)(*target)->data;
@@ -126,7 +126,7 @@ static void nflog_print(const struct xt_nflog_info *info, char *prefix)
 		printf("%snflog-threshold %u ", prefix, info->threshold);
 }
 
-static void print(const struct ip6t_ip6 *ip, const struct xt_entry_target *target,
+static void print(const void *ip, const struct xt_entry_target *target,
 		  int numeric)
 {
 	const struct xt_nflog_info *info = (struct xt_nflog_info *)target->data;
@@ -134,7 +134,7 @@ static void print(const struct ip6t_ip6 *ip, const struct xt_entry_target *targe
 	nflog_print(info, "");
 }
 
-static void save(const struct ip6t_ip6 *ip, const struct xt_entry_target *target)
+static void save(const void *ip, const struct xt_entry_target *target)
 {
 	const struct xt_nflog_info *info = (struct xt_nflog_info *)target->data;
 
diff --git a/extensions/libip6t_NFQUEUE.c b/extensions/libip6t_NFQUEUE.c
index e1f17ab..afc3a6e 100644
--- a/extensions/libip6t_NFQUEUE.c
+++ b/extensions/libip6t_NFQUEUE.c
@@ -47,7 +47,7 @@ parse_num(const char *s, struct ipt_NFQ_info *tinfo)
 
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
index 5b3c7bf..ffc9680 100644
--- a/extensions/libip6t_REJECT.c
+++ b/extensions/libip6t_REJECT.c
@@ -85,7 +85,7 @@ init(struct xt_entry_target *t, unsigned int *nfcache)
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ip6t_entry *entry,
+      const void *entry,
       struct xt_entry_target **target)
 {
 	struct ip6t_reject_info *reject = 
@@ -120,7 +120,7 @@ static void final_check(unsigned int flags)
 
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
diff --git a/extensions/libip6t_SECMARK.c b/extensions/libip6t_SECMARK.c
index 88fbf59..16961a3 100644
--- a/extensions/libip6t_SECMARK.c
+++ b/extensions/libip6t_SECMARK.c
@@ -39,7 +39,7 @@ static void init(struct xt_entry_target *t, unsigned int *nfcache)
  * ate an option.
  */
 static int parse(int c, char **argv, int invert, unsigned int *flags,
-                 const struct ip6t_entry *entry, struct xt_entry_target **target)
+                 const void *entry, struct xt_entry_target **target)
 {
 	struct xt_secmark_target_info *info =
 		(struct xt_secmark_target_info*)(*target)->data;
@@ -85,7 +85,7 @@ static void print_secmark(struct xt_secmark_target_info *info)
 	}
 }
 
-static void print(const struct ip6t_ip6 *ip,
+static void print(const void *ip,
 		  const struct xt_entry_target *target, int numeric)
 {
 	struct xt_secmark_target_info *info =
@@ -96,7 +96,7 @@ static void print(const struct ip6t_ip6 *ip,
 }
 
 /* Saves the target info in parsable form to stdout. */
-static void save(const struct ip6t_ip6 *ip, const struct xt_entry_target *target)
+static void save(const void *ip, const struct xt_entry_target *target)
 {
 	struct xt_secmark_target_info *info =
 		(struct xt_secmark_target_info*)target->data;
diff --git a/extensions/libip6t_TCPMSS.c b/extensions/libip6t_TCPMSS.c
index 1f4b32b..f93a5a3 100644
--- a/extensions/libip6t_TCPMSS.c
+++ b/extensions/libip6t_TCPMSS.c
@@ -43,7 +43,7 @@ init(struct xt_entry_target *t, unsigned int *nfcache)
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ip6t_entry *entry,
+      const void *entry,
       struct xt_entry_target **target)
 {
 	struct ip6t_tcpmss_info *mssinfo
@@ -88,7 +88,7 @@ final_check(unsigned int flags)
 
 /* Prints out the targinfo. */
 static void
-print(const struct ip6t_ip6 *ip6,
+print(const void *ip6,
       const struct xt_entry_target *target,
       int numeric)
 {
@@ -102,7 +102,7 @@ print(const struct ip6t_ip6 *ip6,
 
 /* Saves the union ip6t_targinfo in parsable form to stdout. */
 static void
-save(const struct ip6t_ip6 *ip, const struct xt_entry_target *target)
+save(const void *ip, const struct xt_entry_target *target)
 {
 	const struct ip6t_tcpmss_info *mssinfo =
 		(const struct ip6t_tcpmss_info *)target->data;
diff --git a/extensions/libip6t_ah.c b/extensions/libip6t_ah.c
index 5f1013d..2379f21 100644
--- a/extensions/libip6t_ah.c
+++ b/extensions/libip6t_ah.c
@@ -85,7 +85,7 @@ init(struct xt_entry_match *m, unsigned int *nfcache)
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ip6t_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
@@ -157,7 +157,7 @@ print_len(const char *name, u_int32_t len, int invert)
 
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
@@ -56,7 +56,7 @@ init(struct xt_entry_match *m, unsigned int *nfcache)
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
@@ -132,7 +132,7 @@ init(struct xt_entry_match *m, unsigned int *nfcache)
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ip6t_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
@@ -203,7 +203,7 @@ print_options(int optsnr, u_int16_t *optsp)
 
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
@@ -83,7 +83,7 @@ init(struct xt_entry_match *m, unsigned int *nfcache)
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ip6t_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
@@ -129,7 +129,7 @@ print_spis(const char *name, u_int32_t min, u_int32_t max,
 
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
@@ -44,7 +44,7 @@ static void final_check(unsigned int flags)
 
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
@@ -93,7 +93,7 @@ init(struct xt_entry_match *m, unsigned int *nfcache)
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ip6t_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
@@ -180,7 +180,7 @@ print_ids(const char *name, u_int32_t min, u_int32_t max,
 
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
 
diff --git a/extensions/libip6t_hashlimit.c b/extensions/libip6t_hashlimit.c
index 70d2ff3..9f820fc 100644
--- a/extensions/libip6t_hashlimit.c
+++ b/extensions/libip6t_hashlimit.c
@@ -151,7 +151,7 @@ static int parse_mode(struct xt_hashlimit_info *r, char *optarg)
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ip6t_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct ip6t_entry_match **match)
 {
@@ -304,7 +304,7 @@ static void print_mode(const struct xt_hashlimit_info *r, char separator)
 
 /* Prints out the matchinfo. */
 static void
-print(const struct ip6t_ip6 *ip,
+print(const void *ip,
       const struct ip6t_entry_match *match,
       int numeric)
 {
@@ -325,7 +325,7 @@ print(const struct ip6t_ip6 *ip,
 }
 
 /* FIXME: Make minimalist: only print rate if not default --RR */
-static void save(const struct ip6t_ip6 *ip, const struct ip6t_entry_match *match)
+static void save(const void *ip, const struct ip6t_entry_match *match)
 {
 	struct xt_hashlimit_info *r = 
 		(struct xt_hashlimit_info *)match->data;
diff --git a/extensions/libip6t_hbh.c b/extensions/libip6t_hbh.c
index 24a0485..4312399 100644
--- a/extensions/libip6t_hbh.c
+++ b/extensions/libip6t_hbh.c
@@ -131,7 +131,7 @@ init(struct xt_entry_match *m, unsigned int *nfcache)
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ip6t_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
@@ -200,7 +200,7 @@ print_options(int optsnr, u_int16_t *optsp)
 
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
index 4a4d3c5..58b9fcf 100644
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
@@ -89,7 +89,7 @@ static void final_check(unsigned int flags)
 			"`--hl-eq', `--hl-lt', `--hl-gt'");
 }
 
-static void print(const struct ip6t_ip6 *ip, 
+static void print(const void *ip,
 		const struct xt_entry_match *match,
 		int numeric)
 {
@@ -105,7 +105,7 @@ static void print(const struct ip6t_ip6 *ip,
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
@@ -156,7 +156,7 @@ init(struct xt_entry_match *m, unsigned int *nfcache)
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ip6t_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
@@ -221,7 +221,7 @@ static void print_icmpv6type(u_int8_t type,
 
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
@@ -68,7 +68,7 @@ parse_lengths(const char *s, struct ip6t_length_info *info)
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ip6t_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
@@ -117,7 +117,7 @@ print_length(struct ip6t_length_info *info)
 
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
@@ -93,7 +93,7 @@ init(struct xt_entry_match *m, unsigned int *nfcache)
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
@@ -56,7 +56,7 @@ parse_mac(const char *mac, struct ip6t_mac_info *info)
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ip6t_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
@@ -98,7 +98,7 @@ static void final_check(unsigned int flags)
 
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
index bcdaada..9b801a4 100644
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
@@ -77,7 +77,7 @@ final_check(unsigned int flags)
 
 /* Prints out the matchinfo. */
 static void
-print(const struct ip6t_ip6 *ip,
+print(const void *ip,
       const struct xt_entry_match *match,
       int numeric)
 {
@@ -93,7 +93,7 @@ print(const struct ip6t_ip6 *ip,
 
 /* Saves the union ip6t_matchinfo in parsable form to stdout. */
 static void
-save(const struct ip6t_ip6 *ip, const struct xt_entry_match *match)
+save(const void *ip, const struct xt_entry_match *match)
 {
 	struct ip6t_mark_info *info = (struct ip6t_mark_info *)match->data;
 
diff --git a/extensions/libip6t_mh.c b/extensions/libip6t_mh.c
index 7ea8f89..3ae1cd4 100644
--- a/extensions/libip6t_mh.c
+++ b/extensions/libip6t_mh.c
@@ -126,7 +126,7 @@ static void parse_mh_types(const char *mhtype, u_int8_t *types)
 #define MH_TYPES 0x01
 
 static int parse(int c, char **argv, int invert, unsigned int *flags,
-		 const struct ip6t_entry *entry,
+		 const void *entry,
 		 unsigned int *nfcache,
 		 struct xt_entry_match **match)
 {
@@ -195,7 +195,7 @@ static void print_types(u_int8_t min, u_int8_t max, int invert, int numeric)
 	}
 }
 
-static void print(const struct ip6t_ip6 *ip,
+static void print(const void *ip,
 		  const struct xt_entry_match *match,
 		  int numeric)
 {
@@ -210,7 +210,7 @@ static void print(const struct ip6t_ip6 *ip,
 		       mhinfo->invflags & ~IP6T_MH_INV_MASK);
 }
 
-static void save(const struct ip6t_ip6 *ip, const struct xt_entry_match *match)
+static void save(const void *ip, const struct xt_entry_match *match)
 {
 	const struct ip6t_mh *mhinfo = (struct ip6t_mh *)match->data;
 
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
@@ -41,7 +41,7 @@ init(struct xt_entry_match *m, unsigned int *nfcache)
 
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ip6t_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
@@ -121,7 +121,7 @@ static void final_check(unsigned int flags)
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
@@ -427,7 +427,7 @@ static void print_flags(char *prefix, const struct ip6t_policy_info *info)
 		printf("%sstrict ", prefix);
 }
 
-static void print(const struct ip6t_ip6 *ip,
+static void print(const void *ip,
                   const struct xt_entry_match *match,
 		  int numeric)
 {
@@ -445,7 +445,7 @@ static void print(const struct ip6t_ip6 *ip,
 	printf("\n");
 }
 
-static void save(const struct ip6t_ip6 *ip, const struct xt_entry_match *match)
+static void save(const void *ip, const struct xt_entry_match *match)
 {
 	const struct ip6t_policy_info *info = (void *)match->data;
 	unsigned int i;
diff --git a/extensions/libip6t_rt.c b/extensions/libip6t_rt.c
index 246b2da..a36c65a 100644
--- a/extensions/libip6t_rt.c
+++ b/extensions/libip6t_rt.c
@@ -156,7 +156,7 @@ init(struct xt_entry_match *m, unsigned int *nfcache)
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ip6t_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
@@ -277,7 +277,7 @@ print_addresses(int addrnr, struct in6_addr *addrp)
 
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
 
diff --git a/extensions/libip6t_sctp.c b/extensions/libip6t_sctp.c
index aee7072..d2896e1 100644
--- a/extensions/libip6t_sctp.c
+++ b/extensions/libip6t_sctp.c
@@ -263,7 +263,7 @@ parse_sctp_chunks(struct xt_sctp_info *einfo,
 
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ip6t_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct ip6t_entry_match **match)
 {
@@ -458,7 +458,7 @@ out:
 
 /* Prints out the matchinfo. */
 static void
-print(const struct ip6t_ip6 *ip,
+print(const void *ip,
       const struct ip6t_entry_match *match,
       int numeric)
 {
@@ -492,7 +492,7 @@ print(const struct ip6t_ip6 *ip,
 
 /* Saves the union xt_matchinfo in parsable form to stdout. */
 static void
-save(const struct ip6t_ip6 *ip, 
+save(const void *ip,
      const struct ip6t_entry_match *match)
 {
 	const struct xt_sctp_info *einfo =
diff --git a/extensions/libip6t_standard.c b/extensions/libip6t_standard.c
index 211cc8b..0d9f490 100644
--- a/extensions/libip6t_standard.c
+++ b/extensions/libip6t_standard.c
@@ -30,7 +30,7 @@ init(struct xt_entry_target *t, unsigned int *nfcache)
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ip6t_entry *entry,
+      const void *entry,
       struct xt_entry_target **target)
 {
 	return 0;
@@ -43,7 +43,7 @@ static void final_check(unsigned int flags)
 
 /* Saves the targinfo in parsable form to stdout. */
 static void
-save(const struct ip6t_ip6 *ip6, const struct xt_entry_target *target)
+save(const void *ip6, const struct xt_entry_target *target)
 {
 }
 
diff --git a/extensions/libip6t_state.c b/extensions/libip6t_state.c
index 4bfb50b..01647a6 100644
--- a/extensions/libip6t_state.c
+++ b/extensions/libip6t_state.c
@@ -65,7 +65,7 @@ parse_states(const char *arg, struct ipt_state_info *sinfo)
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ip6t_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
@@ -124,7 +124,7 @@ static void print_state(unsigned int statemask)
 
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
index 8e46deb..e0325d6 100644
--- a/extensions/libip6t_tcp.c
+++ b/extensions/libip6t_tcp.c
@@ -147,7 +147,7 @@ init(struct xt_entry_match *m, unsigned int *nfcache)
    ate an option. */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ip6t_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
@@ -317,7 +317,7 @@ print_flags(u_int8_t mask, u_int8_t cmp, int invert, int numeric)
 
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
@@ -69,7 +69,7 @@ init(struct xt_entry_match *m, unsigned int *nfcache)
    ate an option */
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ip6t_entry *entry,
+      const void *entry,
       unsigned int *nfcache,
       struct xt_entry_match **match)
 {
@@ -156,7 +156,7 @@ print_ports(const char *name, u_int16_t min, u_int16_t max,
 
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
 
-- 
1.5.2.2
