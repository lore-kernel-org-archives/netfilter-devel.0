From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 08/43] replaces ip6t_entry_* with xt_entry_* in
 matches/targets
Date: Sun, 15 Jul 2007 02:23:02 +0900 (JST)
Message-ID: <200707141723.l6EHN3Ei023223@toshiba.co.jp>
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
 extensions/libip6t_CONNMARK.c    |    8 ++++----
 extensions/libip6t_CONNSECMARK.c |    6 +++---
 extensions/libip6t_HL.c          |    8 ++++----
 extensions/libip6t_LOG.c         |    8 ++++----
 extensions/libip6t_MARK.c        |    8 ++++----
 extensions/libip6t_NFQUEUE.c     |    8 ++++----
 extensions/libip6t_REJECT.c      |    8 ++++----
 extensions/libip6t_SECMARK.c     |    8 ++++----
 extensions/libip6t_TCPMSS.c      |   10 +++++-----
 extensions/libip6t_ah.c          |    8 ++++----
 extensions/libip6t_condition.c   |    6 +++---
 extensions/libip6t_connmark.c    |    8 ++++----
 extensions/libip6t_dst.c         |    8 ++++----
 extensions/libip6t_esp.c         |    8 ++++----
 extensions/libip6t_eui64.c       |    6 +++---
 extensions/libip6t_frag.c        |    8 ++++----
 extensions/libip6t_hbh.c         |    8 ++++----
 extensions/libip6t_hl.c          |    6 +++---
 extensions/libip6t_icmp6.c       |    8 ++++----
 extensions/libip6t_ipv6header.c  |    8 ++++----
 extensions/libip6t_length.c      |    6 +++---
 extensions/libip6t_limit.c       |    8 ++++----
 extensions/libip6t_mac.c         |    6 +++---
 extensions/libip6t_mark.c        |    6 +++---
 extensions/libip6t_mh.c          |    9 ++++-----
 extensions/libip6t_multiport.c   |    8 ++++----
 extensions/libip6t_owner.c       |    6 +++---
 extensions/libip6t_physdev.c     |    8 ++++----
 extensions/libip6t_policy.c      |    8 ++++----
 extensions/libip6t_rt.c          |    8 ++++----
 extensions/libip6t_standard.c    |    6 +++---
 extensions/libip6t_state.c       |    6 +++---
 extensions/libip6t_tcp.c         |    8 ++++----
 extensions/libip6t_udp.c         |    8 ++++----
 34 files changed, 127 insertions(+), 128 deletions(-)

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
 
@@ -67,7 +67,7 @@ init(struct ip6t_entry_target *t, unsigned int *nfcache)
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ip6t_entry *entry,
-      struct ip6t_entry_target **target)
+      struct xt_entry_target **target)
 {
 	struct ipt_connmark_target_info *markinfo
 		= (struct ipt_connmark_target_info *)(*target)->data;
@@ -145,7 +145,7 @@ print_mask(const char *text, unsigned long mask)
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
@@ -87,7 +87,7 @@ static void print_connsecmark(struct xt_connsecmark_target_info *info)
 }
 
 static void print(const struct ip6t_ip6 *ip,
-		  const struct ip6t_entry_target *target, int numeric)
+		  const struct xt_entry_target *target, int numeric)
 {
 	struct xt_connsecmark_target_info *info =
 		(struct xt_connsecmark_target_info*)(target)->data;
@@ -96,7 +96,7 @@ static void print(const struct ip6t_ip6 *ip,
 	print_connsecmark(info);
 }
 
-static void save(const struct ip6t_ip6 *ip, const struct ip6t_entry_target *target)
+static void save(const struct ip6t_ip6 *ip, const struct xt_entry_target *target)
 {
 	struct xt_connsecmark_target_info *info =
 		(struct xt_connsecmark_target_info*)target->data;
diff --git a/extensions/libip6t_HL.c b/extensions/libip6t_HL.c
index 2062828..fc6ba34 100644
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
@@ -97,7 +97,7 @@ static void final_check(unsigned int flags)
 }
 
 static void save(const struct ip6t_ip6 *ip,
-		const struct ip6t_entry_target *target)
+		const struct xt_entry_target *target)
 {
 	const struct ip6t_HL_info *info = 
 		(struct ip6t_HL_info *) target->data;
@@ -118,7 +118,7 @@ static void save(const struct ip6t_ip6 *ip,
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
 
@@ -207,7 +207,7 @@ static void final_check(unsigned int flags)
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
index 0b043fb..e5b7c70 100644
--- a/extensions/libip6t_MARK.c
+++ b/extensions/libip6t_MARK.c
@@ -27,7 +27,7 @@ static struct option opts[] = {
 
 /* Initialize the target. */
 static void
-init(struct ip6t_entry_target *t, unsigned int *nfcache)
+init(struct xt_entry_target *t, unsigned int *nfcache)
 {
 }
 
@@ -36,7 +36,7 @@ init(struct ip6t_entry_target *t, unsigned int *nfcache)
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ip6t_entry *entry,
-      struct ip6t_entry_target **target)
+      struct xt_entry_target **target)
 {
 	struct ip6t_mark_target_info *markinfo
 		= (struct ip6t_mark_target_info *)(*target)->data;
@@ -76,7 +76,7 @@ print_mark(unsigned long mark)
 /* Prints out the targinfo. */
 static void
 print(const struct ip6t_ip6 *ip,
-      const struct ip6t_entry_target *target,
+      const struct xt_entry_target *target,
       int numeric)
 {
 	const struct ip6t_mark_target_info *markinfo =
@@ -88,7 +88,7 @@ print(const struct ip6t_ip6 *ip,
 
 /* Saves the union ipt_targinfo in parsable form to stdout. */
 static void
-save(const struct ip6t_ip6 *ip, const struct ip6t_entry_target *target)
+save(const struct ip6t_ip6 *ip, const struct xt_entry_target *target)
 {
 	const struct ip6t_mark_target_info *markinfo =
 		(const struct ip6t_mark_target_info *)target->data;
diff --git a/extensions/libip6t_NFQUEUE.c b/extensions/libip6t_NFQUEUE.c
index e1964af..e1f17ab 100644
--- a/extensions/libip6t_NFQUEUE.c
+++ b/extensions/libip6t_NFQUEUE.c
@@ -14,7 +14,7 @@
 #include <linux/netfilter_ipv6/ip6_tables.h>
 #include <linux/netfilter_ipv4/ipt_NFQUEUE.h>
 
-static void init(struct ip6t_entry_target *t, unsigned int *nfcache) 
+static void init(struct xt_entry_target *t, unsigned int *nfcache)
 {
 }
 
@@ -48,7 +48,7 @@ parse_num(const char *s, struct ipt_NFQ_info *tinfo)
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
 
@@ -86,7 +86,7 @@ init(struct ip6t_entry_target *t, unsigned int *nfcache)
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ip6t_entry *entry,
-      struct ip6t_entry_target **target)
+      struct xt_entry_target **target)
 {
 	struct ip6t_reject_info *reject = 
 		(struct ip6t_reject_info *)(*target)->data;
@@ -121,7 +121,7 @@ static void final_check(unsigned int flags)
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
@@ -39,7 +39,7 @@ static void init(struct ip6t_entry_target *t, unsigned int *nfcache)
  * ate an option.
  */
 static int parse(int c, char **argv, int invert, unsigned int *flags,
-                 const struct ip6t_entry *entry, struct ip6t_entry_target **target)
+                 const struct ip6t_entry *entry, struct xt_entry_target **target)
 {
 	struct xt_secmark_target_info *info =
 		(struct xt_secmark_target_info*)(*target)->data;
@@ -86,7 +86,7 @@ static void print_secmark(struct xt_secmark_target_info *info)
 }
 
 static void print(const struct ip6t_ip6 *ip,
-		  const struct ip6t_entry_target *target, int numeric)
+		  const struct xt_entry_target *target, int numeric)
 {
 	struct xt_secmark_target_info *info =
 		(struct xt_secmark_target_info*)(target)->data;
@@ -96,7 +96,7 @@ static void print(const struct ip6t_ip6 *ip,
 }
 
 /* Saves the target info in parsable form to stdout. */
-static void save(const struct ip6t_ip6 *ip, const struct ip6t_entry_target *target)
+static void save(const struct ip6t_ip6 *ip, const struct xt_entry_target *target)
 {
 	struct xt_secmark_target_info *info =
 		(struct xt_secmark_target_info*)target->data;
diff --git a/extensions/libip6t_TCPMSS.c b/extensions/libip6t_TCPMSS.c
index 7fcccd5..1f4b32b 100644
--- a/extensions/libip6t_TCPMSS.c
+++ b/extensions/libip6t_TCPMSS.c
@@ -12,7 +12,7 @@
 #include <linux/netfilter_ipv6/ip6t_TCPMSS.h>
 
 struct mssinfo {
-	struct ip6t_entry_target t;
+	struct xt_entry_target t;
 	struct ip6t_tcpmss_info mss;
 };
 
@@ -35,7 +35,7 @@ static struct option opts[] = {
 
 /* Initialize the target. */
 static void
-init(struct ip6t_entry_target *t, unsigned int *nfcache)
+init(struct xt_entry_target *t, unsigned int *nfcache)
 {
 }
 
@@ -44,7 +44,7 @@ init(struct ip6t_entry_target *t, unsigned int *nfcache)
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ip6t_entry *entry,
-      struct ip6t_entry_target **target)
+      struct xt_entry_target **target)
 {
 	struct ip6t_tcpmss_info *mssinfo
 		= (struct ip6t_tcpmss_info *)(*target)->data;
@@ -89,7 +89,7 @@ final_check(unsigned int flags)
 /* Prints out the targinfo. */
 static void
 print(const struct ip6t_ip6 *ip6,
-      const struct ip6t_entry_target *target,
+      const struct xt_entry_target *target,
       int numeric)
 {
 	const struct ip6t_tcpmss_info *mssinfo =
@@ -102,7 +102,7 @@ print(const struct ip6t_ip6 *ip6,
 
 /* Saves the union ip6t_targinfo in parsable form to stdout. */
 static void
-save(const struct ip6t_ip6 *ip, const struct ip6t_entry_target *target)
+save(const struct ip6t_ip6 *ip, const struct xt_entry_target *target)
 {
 	const struct ip6t_tcpmss_info *mssinfo =
 		(const struct ip6t_tcpmss_info *)target->data;
diff --git a/extensions/libip6t_ah.c b/extensions/libip6t_ah.c
index 794e02e..5f1013d 100644
--- a/extensions/libip6t_ah.c
+++ b/extensions/libip6t_ah.c
@@ -72,7 +72,7 @@ parse_ah_spis(const char *spistring, u_int32_t *spis)
 
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
 
@@ -158,7 +158,7 @@ print_len(const char *name, u_int32_t len, int invert)
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
@@ -118,7 +118,7 @@ parse_options(const char *optsstr, u_int16_t *opts)
 
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
 
@@ -204,7 +204,7 @@ print_options(int optsnr, u_int16_t *optsp)
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
@@ -70,7 +70,7 @@ parse_esp_spis(const char *spistring, u_int32_t *spis)
 
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
 
@@ -130,7 +130,7 @@ print_spis(const char *name, u_int32_t min, u_int32_t max,
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
@@ -45,14 +45,14 @@ static void final_check(unsigned int flags)
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
@@ -78,7 +78,7 @@ parse_frag_ids(const char *idstring, u_int32_t *ids)
 
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
 
@@ -181,7 +181,7 @@ print_ids(const char *name, u_int32_t min, u_int32_t max,
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
 
diff --git a/extensions/libip6t_hbh.c b/extensions/libip6t_hbh.c
index bdcbf9b..24a0485 100644
--- a/extensions/libip6t_hbh.c
+++ b/extensions/libip6t_hbh.c
@@ -117,7 +117,7 @@ parse_options(const char *optsstr, u_int16_t *opts)
 
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
 
@@ -201,7 +201,7 @@ print_options(int optsnr, u_int16_t *optsp)
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
@@ -90,7 +90,7 @@ static void final_check(unsigned int flags)
 }
 
 static void print(const struct ip6t_ip6 *ip, 
-		const struct ip6t_entry_match *match,
+		const struct xt_entry_match *match,
 		int numeric)
 {
 	static const char *op[] = {
@@ -106,7 +106,7 @@ static void print(const struct ip6t_ip6 *ip,
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
@@ -145,7 +145,7 @@ parse_icmpv6(const char *icmpv6type, u_int8_t *type, u_int8_t code[])
 
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
 
@@ -222,7 +222,7 @@ static void print_icmpv6type(u_int8_t type,
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
 
@@ -118,7 +118,7 @@ print_length(struct ip6t_length_info *info)
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
@@ -74,7 +74,7 @@ int parse_rate(const char *rate, u_int32_t *val)
 
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
 
@@ -99,7 +99,7 @@ static void final_check(unsigned int flags)
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
index 9c7f137..bcdaada 100644
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
 
@@ -78,7 +78,7 @@ final_check(unsigned int flags)
 /* Prints out the matchinfo. */
 static void
 print(const struct ip6t_ip6 *ip,
-      const struct ip6t_entry_match *match,
+      const struct xt_entry_match *match,
       int numeric)
 {
 	struct ip6t_mark_info *info = (struct ip6t_mark_info *)match->data;
@@ -93,7 +93,7 @@ print(const struct ip6t_ip6 *ip,
 
 /* Saves the union ip6t_matchinfo in parsable form to stdout. */
 static void
-save(const struct ip6t_ip6 *ip, const struct ip6t_entry_match *match)
+save(const struct ip6t_ip6 *ip, const struct xt_entry_match *match)
 {
 	struct ip6t_mark_info *info = (struct ip6t_mark_info *)match->data;
 
diff --git a/extensions/libip6t_mh.c b/extensions/libip6t_mh.c
index 2475b4d..7ea8f89 100644
--- a/extensions/libip6t_mh.c
+++ b/extensions/libip6t_mh.c
@@ -67,7 +67,7 @@ IPTABLES_VERSION);
 	print_types_all();
 }
 
-static void init(struct ip6t_entry_match *m, unsigned int *nfcache)
+static void init(struct xt_entry_match *m, unsigned int *nfcache)
 {
 	struct ip6t_mh *mhinfo = (struct ip6t_mh *)m->data;
 
@@ -128,7 +128,7 @@ static void parse_mh_types(const char *mhtype, u_int8_t *types)
 static int parse(int c, char **argv, int invert, unsigned int *flags,
 		 const struct ip6t_entry *entry,
 		 unsigned int *nfcache,
-		 struct ip6t_entry_match **match)
+		 struct xt_entry_match **match)
 {
 	struct ip6t_mh *mhinfo = (struct ip6t_mh *)(*match)->data;
 
@@ -196,7 +196,7 @@ static void print_types(u_int8_t min, u_int8_t max, int invert, int numeric)
 }
 
 static void print(const struct ip6t_ip6 *ip,
-		  const struct ip6t_entry_match *match,
+		  const struct xt_entry_match *match,
 		  int numeric)
 {
 	const struct ip6t_mh *mhinfo = (struct ip6t_mh *)match->data;
@@ -210,8 +210,7 @@ static void print(const struct ip6t_ip6 *ip,
 		       mhinfo->invflags & ~IP6T_MH_INV_MASK);
 }
 
-static void save(const struct ip6t_ip6 *ip,
-		 const struct ip6t_entry_match *match)
+static void save(const struct ip6t_ip6 *ip, const struct xt_entry_match *match)
 {
 	const struct ip6t_mh *mhinfo = (struct ip6t_mh *)match->data;
 
diff --git a/extensions/libip6t_multiport.c b/extensions/libip6t_multiport.c
index 166abce..bb55f23 100644
--- a/extensions/libip6t_multiport.c
+++ b/extensions/libip6t_multiport.c
@@ -130,7 +130,7 @@ parse_multi_ports_v1(const char *portstring,
 
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
@@ -280,7 +280,7 @@ print_port(u_int16_t port, u_int8_t protocol, int numeric)
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
@@ -122,7 +122,7 @@ static void final_check(unsigned int flags)
 
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
@@ -133,7 +133,7 @@ extern void parse_hostnetworkmask(const char *name, struct in6_addr **addrpp,
 
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
@@ -428,7 +428,7 @@ static void print_flags(char *prefix, const struct ip6t_policy_info *info)
 }
 
 static void print(const struct ip6t_ip6 *ip,
-                  const struct ip6t_entry_match *match,
+                  const struct xt_entry_match *match,
 		  int numeric)
 {
 	const struct ip6t_policy_info *info = (void *)match->data;
@@ -445,7 +445,7 @@ static void print(const struct ip6t_ip6 *ip,
 	printf("\n");
 }
 
-static void save(const struct ip6t_ip6 *ip, const struct ip6t_entry_match *match)
+static void save(const struct ip6t_ip6 *ip, const struct xt_entry_match *match)
 {
 	const struct ip6t_policy_info *info = (void *)match->data;
 	unsigned int i;
diff --git a/extensions/libip6t_rt.c b/extensions/libip6t_rt.c
index 251604b..246b2da 100644
--- a/extensions/libip6t_rt.c
+++ b/extensions/libip6t_rt.c
@@ -139,7 +139,7 @@ parse_addresses(const char *addrstr, struct in6_addr *addrp)
 
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
 
@@ -278,7 +278,7 @@ print_addresses(int addrnr, struct in6_addr *addrp)
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
 
@@ -31,7 +31,7 @@ init(struct ip6t_entry_target *t, unsigned int *nfcache)
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ip6t_entry *entry,
-      struct ip6t_entry_target **target)
+      struct xt_entry_target **target)
 {
 	return 0;
 }
@@ -43,7 +43,7 @@ static void final_check(unsigned int flags)
 
 /* Saves the targinfo in parsable form to stdout. */
 static void
-save(const struct ip6t_ip6 *ip6, const struct ip6t_entry_target *target)
+save(const struct ip6t_ip6 *ip6, const struct xt_entry_target *target)
 {
 }
 
diff --git a/extensions/libip6t_state.c b/extensions/libip6t_state.c
index a4477ce..4bfb50b 100644
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
 
@@ -125,7 +125,7 @@ static void print_state(unsigned int statemask)
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
@@ -131,7 +131,7 @@ parse_tcp_option(const char *option, u_int8_t *result)
 
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
 
@@ -318,7 +318,7 @@ print_flags(u_int8_t mask, u_int8_t cmp, int invert, int numeric)
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
@@ -55,7 +55,7 @@ parse_udp_ports(const char *portstring, u_int16_t *ports)
 
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
 
@@ -157,7 +157,7 @@ print_ports(const char *name, u_int16_t min, u_int16_t max,
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
 
-- 
1.5.2.2
