From: Richard Guy Briggs <rgb@redhat.com>
Subject: [PATCH 1/6 RFC] netfilter: normalize x_table function declarations
Date: Thu, 18 May 2017 13:21:47 -0400
Message-ID: <d7a00d229e93586d0aed5950d79e95f3d552dae6.1495124188.git.rgb@redhat.com>
References: <cover.1495124188.git.rgb@redhat.com>
Cc: Richard Guy Briggs <rgb@redhat.com>,
        Florian Westphal <fw@strlen.de>,
        Thomas Woerner <twoerner@redhat.com>,
        Thomas Graf <tgraf@infradead.org>,
        Eric Paris <eparis@redhat.com>, Paul Moore <pmoore@redhat.com>,
        Steve Grubb <sgrubb@redhat.com>
To: Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>, linux-audit@redhat.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34946 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932496AbdERRXS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 18 May 2017 13:23:18 -0400
In-Reply-To: <cover.1495124188.git.rgb@redhat.com>
In-Reply-To: <cover.1495124188.git.rgb@redhat.com>
References: <cover.1495124188.git.rgb@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Git context diffs were being produced with unhelpful declaration types in the
place of function names to help identify the funciton in which changes were
made.

Normalize x_table function declarations so that git context diff function
labels work as expected.

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 net/netfilter/x_tables.c |   43 ++++++++++++++++++-------------------------
 1 files changed, 18 insertions(+), 25 deletions(-)

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 14857af..99c27ed 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -81,8 +81,7 @@ int xt_register_target(struct xt_target *target)
 }
 EXPORT_SYMBOL(xt_register_target);
 
-void
-xt_unregister_target(struct xt_target *target)
+void xt_unregister_target(struct xt_target *target)
 {
 	u_int8_t af = target->family;
 
@@ -92,8 +91,7 @@ int xt_register_target(struct xt_target *target)
 }
 EXPORT_SYMBOL(xt_unregister_target);
 
-int
-xt_register_targets(struct xt_target *target, unsigned int n)
+int xt_register_targets(struct xt_target *target, unsigned int n)
 {
 	unsigned int i;
 	int err = 0;
@@ -112,8 +110,7 @@ int xt_register_target(struct xt_target *target)
 }
 EXPORT_SYMBOL(xt_register_targets);
 
-void
-xt_unregister_targets(struct xt_target *target, unsigned int n)
+void xt_unregister_targets(struct xt_target *target, unsigned int n)
 {
 	while (n-- > 0)
 		xt_unregister_target(&target[n]);
@@ -131,8 +128,7 @@ int xt_register_match(struct xt_match *match)
 }
 EXPORT_SYMBOL(xt_register_match);
 
-void
-xt_unregister_match(struct xt_match *match)
+void xt_unregister_match(struct xt_match *match)
 {
 	u_int8_t af = match->family;
 
@@ -142,8 +138,7 @@ int xt_register_match(struct xt_match *match)
 }
 EXPORT_SYMBOL(xt_unregister_match);
 
-int
-xt_register_matches(struct xt_match *match, unsigned int n)
+int xt_register_matches(struct xt_match *match, unsigned int n)
 {
 	unsigned int i;
 	int err = 0;
@@ -162,8 +157,7 @@ int xt_register_match(struct xt_match *match)
 }
 EXPORT_SYMBOL(xt_register_matches);
 
-void
-xt_unregister_matches(struct xt_match *match, unsigned int n)
+void xt_unregister_matches(struct xt_match *match, unsigned int n)
 {
 	while (n-- > 0)
 		xt_unregister_match(&match[n]);
@@ -205,8 +199,8 @@ struct xt_match *xt_find_match(u8 af, const char *name, u8 revision)
 }
 EXPORT_SYMBOL(xt_find_match);
 
-struct xt_match *
-xt_request_find_match(uint8_t nfproto, const char *name, uint8_t revision)
+struct xt_match *xt_request_find_match(uint8_t nfproto, const char *name,
+				       uint8_t revision)
 {
 	struct xt_match *match;
 
@@ -382,8 +376,8 @@ int xt_find_revision(u8 af, const char *name, u8 revision, int target,
 }
 EXPORT_SYMBOL_GPL(xt_find_revision);
 
-static char *
-textify_hooks(char *buf, size_t size, unsigned int mask, uint8_t nfproto)
+static char *textify_hooks(char *buf, size_t size, unsigned int mask,
+			   uint8_t nfproto)
 {
 	static const char *const inetbr_names[] = {
 		"PREROUTING", "INPUT", "FORWARD",
@@ -1154,11 +1148,10 @@ static int xt_jumpstack_alloc(struct xt_table_info *i)
 	return 0;
 }
 
-struct xt_table_info *
-xt_replace_table(struct xt_table *table,
-	      unsigned int num_counters,
-	      struct xt_table_info *newinfo,
-	      int *error)
+struct xt_table_info *xt_replace_table(struct xt_table *table,
+				       unsigned int num_counters,
+				       struct xt_table_info *newinfo,
+				       int *error)
 {
 	struct xt_table_info *private;
 	int ret;
@@ -1367,7 +1360,7 @@ enum {
 };
 
 static void *xt_mttg_seq_next(struct seq_file *seq, void *v, loff_t *ppos,
-    bool is_target)
+			      bool is_target)
 {
 	static const uint8_t next_class[] = {
 		[MTTG_TRAV_NFP_UNSPEC] = MTTG_TRAV_NFP_SPEC,
@@ -1407,7 +1400,7 @@ enum {
 }
 
 static void *xt_mttg_seq_start(struct seq_file *seq, loff_t *pos,
-    bool is_target)
+			       bool is_target)
 {
 	struct nf_mttg_trav *trav = seq->private;
 	unsigned int j;
@@ -1553,8 +1546,8 @@ static int xt_target_open(struct inode *inode, struct file *file)
  * This function will create the nf_hook_ops that the x_table needs
  * to hand to xt_hook_link_net().
  */
-struct nf_hook_ops *
-xt_hook_ops_alloc(const struct xt_table *table, nf_hookfn *fn)
+struct nf_hook_ops *xt_hook_ops_alloc(const struct xt_table *table,
+				      nf_hookfn *fn)
 {
 	unsigned int hook_mask = table->valid_hooks;
 	uint8_t i, num_hooks = hweight32(hook_mask);
-- 
1.7.1

