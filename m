From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 01/17]: x_tables: remove some unnecessary casts
Date: Tue, 30 May 2006 00:34:06 +0200 (MEST)
Message-ID: <20060529223406.24834.76526.sendpatchset@localhost.localdomain>
References: <20060529223404.24834.30808.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060529223404.24834.30808.sendpatchset@localhost.localdomain>
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

[NETFILTER]: x_tables: remove some unnecessary casts

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 36e1d2c1e439bf08da7406cc82b01e18062a437e
tree 5f5847fc5a8483e67ec30d09bb034535a0729db5
parent 8bf89c20914d1323c80602ba60405b2873a6ef60
author Patrick McHardy <kaber@trash.net> Tue, 30 May 2006 00:02:36 +0200
committer Patrick McHardy <kaber@trash.net> Tue, 30 May 2006 00:02:36 +0200

 net/ipv4/netfilter/ipt_hashlimit.c |    2 +-
 net/netfilter/xt_connmark.c        |    2 +-
 net/netfilter/xt_dccp.c            |    3 +--
 net/netfilter/xt_mark.c            |    2 +-
 net/netfilter/xt_sctp.c            |    4 +---
 net/netfilter/xt_string.c          |    2 +-
 6 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_hashlimit.c b/net/ipv4/netfilter/ipt_hashlimit.c
index 7c6836c..b88adc7 100644
--- a/net/ipv4/netfilter/ipt_hashlimit.c
+++ b/net/ipv4/netfilter/ipt_hashlimit.c
@@ -561,7 +561,7 @@ static void
 hashlimit_destroy(const struct xt_match *match, void *matchinfo,
 		  unsigned int matchsize)
 {
-	struct ipt_hashlimit_info *r = (struct ipt_hashlimit_info *) matchinfo;
+	struct ipt_hashlimit_info *r = matchinfo;
 
 	htable_put(r->hinfo);
 }
diff --git a/net/netfilter/xt_connmark.c b/net/netfilter/xt_connmark.c
index dc26a27..56324c8 100644
--- a/net/netfilter/xt_connmark.c
+++ b/net/netfilter/xt_connmark.c
@@ -58,7 +58,7 @@ checkentry(const char *tablename,
 	   unsigned int matchsize,
 	   unsigned int hook_mask)
 {
-	struct xt_connmark_info *cm = (struct xt_connmark_info *)matchinfo;
+	struct xt_connmark_info *cm = matchinfo;
 
 	if (cm->mark > 0xffffffff || cm->mask > 0xffffffff) {
 		printk(KERN_WARNING "connmark: only support 32bit mark\n");
diff --git a/net/netfilter/xt_dccp.c b/net/netfilter/xt_dccp.c
index dfb10b6..2e2f825 100644
--- a/net/netfilter/xt_dccp.c
+++ b/net/netfilter/xt_dccp.c
@@ -101,8 +101,7 @@ match(const struct sk_buff *skb,
       unsigned int protoff,
       int *hotdrop)
 {
-	const struct xt_dccp_info *info = 
-				(const struct xt_dccp_info *)matchinfo;
+	const struct xt_dccp_info *info = matchinfo;
 	struct dccp_hdr _dh, *dh;
 
 	if (offset)
diff --git a/net/netfilter/xt_mark.c b/net/netfilter/xt_mark.c
index 8b385a3..876bc57 100644
--- a/net/netfilter/xt_mark.c
+++ b/net/netfilter/xt_mark.c
@@ -42,7 +42,7 @@ checkentry(const char *tablename,
            unsigned int matchsize,
            unsigned int hook_mask)
 {
-	struct xt_mark_info *minfo = (struct xt_mark_info *) matchinfo;
+	const struct xt_mark_info *minfo = matchinfo;
 
 	if (minfo->mark > 0xffffffff || minfo->mask > 0xffffffff) {
 		printk(KERN_WARNING "mark: only supports 32bit mark\n");
diff --git a/net/netfilter/xt_sctp.c b/net/netfilter/xt_sctp.c
index 34bd872..b5110e5 100644
--- a/net/netfilter/xt_sctp.c
+++ b/net/netfilter/xt_sctp.c
@@ -129,11 +129,9 @@ match(const struct sk_buff *skb,
       unsigned int protoff,
       int *hotdrop)
 {
-	const struct xt_sctp_info *info;
+	const struct xt_sctp_info *info = matchinfo;
 	sctp_sctphdr_t _sh, *sh;
 
-	info = (const struct xt_sctp_info *)matchinfo;
-
 	if (offset) {
 		duprintf("Dropping non-first fragment.. FIXME\n");
 		return 0;
diff --git a/net/netfilter/xt_string.c b/net/netfilter/xt_string.c
index 79d9ea6..0ebb6ac 100644
--- a/net/netfilter/xt_string.c
+++ b/net/netfilter/xt_string.c
@@ -30,8 +30,8 @@ static int match(const struct sk_buff *s
 		 unsigned int protoff,
 		 int *hotdrop)
 {
+	const struct xt_string_info *conf = matchinfo;
 	struct ts_state state;
-	struct xt_string_info *conf = (struct xt_string_info *) matchinfo;
 
 	memset(&state, 0, sizeof(struct ts_state));
 
