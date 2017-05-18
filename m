From: Richard Guy Briggs <rgb@redhat.com>
Subject: [PATCH 2/6 RFC] netfilter: normalize ebtables function declarations
Date: Thu, 18 May 2017 13:21:48 -0400
Message-ID: <ee2f932ececc1e9b7bbbcce474eac5d8effae757.1495124188.git.rgb@redhat.com>
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
Received: from mx1.redhat.com ([209.132.183.28]:56206 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932280AbdERRXV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 18 May 2017 13:23:21 -0400
In-Reply-To: <cover.1495124188.git.rgb@redhat.com>
In-Reply-To: <cover.1495124188.git.rgb@redhat.com>
References: <cover.1495124188.git.rgb@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Git context diffs were being produced with unhelpful declaration types in the
place of function names to help identify the funciton in which changes were
made.

Normalize ebtables function declarations so that git context diff function
labels work as expected.

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 net/bridge/netfilter/ebtables.c |   92 +++++++++++++++++++-------------------
 1 files changed, 46 insertions(+), 46 deletions(-)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 79b6991..13d7fe2 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -84,9 +84,9 @@ static int ebt_standard_compat_to_user(void __user *dst, const void *src)
 #endif
 };
 
-static inline int
-ebt_do_watcher(const struct ebt_entry_watcher *w, struct sk_buff *skb,
-	       struct xt_action_param *par)
+static inline int ebt_do_watcher(const struct ebt_entry_watcher *w,
+				 struct sk_buff *skb,
+				 struct xt_action_param *par)
 {
 	par->target   = w->u.watcher;
 	par->targinfo = w->data;
@@ -95,17 +95,17 @@ static int ebt_standard_compat_to_user(void __user *dst, const void *src)
 	return 0;
 }
 
-static inline int
-ebt_do_match(struct ebt_entry_match *m, const struct sk_buff *skb,
-	     struct xt_action_param *par)
+static inline int ebt_do_match(struct ebt_entry_match *m,
+			       const struct sk_buff *skb,
+			       struct xt_action_param *par)
 {
 	par->match     = m->u.match;
 	par->matchinfo = m->data;
 	return m->u.match->match(skb, par) ? EBT_MATCH : EBT_NOMATCH;
 }
 
-static inline int
-ebt_dev_check(const char *entry, const struct net_device *device)
+static inline int ebt_dev_check(const char *entry,
+				const struct net_device *device)
 {
 	int i = 0;
 	const char *devname;
@@ -122,9 +122,10 @@ static int ebt_standard_compat_to_user(void __user *dst, const void *src)
 }
 
 /* process standard matches */
-static inline int
-ebt_basic_match(const struct ebt_entry *e, const struct sk_buff *skb,
-		const struct net_device *in, const struct net_device *out)
+static inline int ebt_basic_match(const struct ebt_entry *e,
+				  const struct sk_buff *skb,
+				  const struct net_device *in,
+				  const struct net_device *out)
 {
 	const struct ethhdr *h = eth_hdr(skb);
 	const struct net_bridge_port *p;
@@ -171,8 +172,7 @@ static int ebt_standard_compat_to_user(void __user *dst, const void *src)
 	return 0;
 }
 
-static inline
-struct ebt_entry *ebt_next_entry(const struct ebt_entry *entry)
+static inline struct ebt_entry *ebt_next_entry(const struct ebt_entry *entry)
 {
 	return (void *)entry + entry->next_offset;
 }
@@ -313,9 +313,9 @@ unsigned int ebt_do_table(struct sk_buff *skb,
 }
 
 /* If it succeeds, returns element and locks mutex */
-static inline void *
-find_inlist_lock_noload(struct list_head *head, const char *name, int *error,
-			struct mutex *mutex)
+static inline void * find_inlist_lock_noload(struct list_head *head,
+					     const char *name, int *error,
+					     struct mutex *mutex)
 {
 	struct {
 		struct list_head list;
@@ -332,26 +332,26 @@ unsigned int ebt_do_table(struct sk_buff *skb,
 	return NULL;
 }
 
-static void *
-find_inlist_lock(struct list_head *head, const char *name, const char *prefix,
-		 int *error, struct mutex *mutex)
+static void * find_inlist_lock(struct list_head *head, const char *name,
+			       const char *prefix, int *error,
+			       struct mutex *mutex)
 {
 	return try_then_request_module(
 			find_inlist_lock_noload(head, name, error, mutex),
 			"%s%s", prefix, name);
 }
 
-static inline struct ebt_table *
-find_table_lock(struct net *net, const char *name, int *error,
-		struct mutex *mutex)
+static inline struct ebt_table * find_table_lock(struct net *net,
+						 const char *name, int *error,
+						 struct mutex *mutex)
 {
 	return find_inlist_lock(&net->xt.tables[NFPROTO_BRIDGE], name,
 				"ebtable_", error, mutex);
 }
 
-static inline int
-ebt_check_match(struct ebt_entry_match *m, struct xt_mtchk_param *par,
-		unsigned int *cnt)
+static inline int ebt_check_match(struct ebt_entry_match *m,
+				  struct xt_mtchk_param *par,
+				  unsigned int *cnt)
 {
 	const struct ebt_entry *e = par->entryinfo;
 	struct xt_match *match;
@@ -386,9 +386,9 @@ unsigned int ebt_do_table(struct sk_buff *skb,
 	return 0;
 }
 
-static inline int
-ebt_check_watcher(struct ebt_entry_watcher *w, struct xt_tgchk_param *par,
-		  unsigned int *cnt)
+static inline int ebt_check_watcher(struct ebt_entry_watcher *w,
+				    struct xt_tgchk_param *par,
+				    unsigned int *cnt)
 {
 	const struct ebt_entry *e = par->entryinfo;
 	struct xt_target *watcher;
@@ -489,8 +489,7 @@ static int ebt_verify_pointers(const struct ebt_replace *repl,
 /* this one is very careful, as it is the first function
  * to parse the userspace data
  */
-static inline int
-ebt_check_entry_size_and_hooks(const struct ebt_entry *e,
+static inline int ebt_check_entry_size_and_hooks(const struct ebt_entry *e,
 			       const struct ebt_table_info *newinfo,
 			       unsigned int *n, unsigned int *cnt,
 			       unsigned int *totalcnt, unsigned int *udc_cnt)
@@ -558,9 +557,10 @@ struct ebt_cl_stack {
 /* We need these positions to check that the jumps to a different part of the
  * entries is a jump to the beginning of a new chain.
  */
-static inline int
-ebt_get_udc_positions(struct ebt_entry *e, struct ebt_table_info *newinfo,
-		      unsigned int *n, struct ebt_cl_stack *udc)
+static inline int ebt_get_udc_positions(struct ebt_entry *e,
+					struct ebt_table_info *newinfo,
+					unsigned int *n,
+					struct ebt_cl_stack *udc)
 {
 	int i;
 
@@ -584,8 +584,8 @@ struct ebt_cl_stack {
 	return 0;
 }
 
-static inline int
-ebt_cleanup_match(struct ebt_entry_match *m, struct net *net, unsigned int *i)
+static inline int ebt_cleanup_match(struct ebt_entry_match *m,
+				    struct net *net, unsigned int *i)
 {
 	struct xt_mtdtor_param par;
 
@@ -602,8 +602,8 @@ struct ebt_cl_stack {
 	return 0;
 }
 
-static inline int
-ebt_cleanup_watcher(struct ebt_entry_watcher *w, struct net *net, unsigned int *i)
+static inline int ebt_cleanup_watcher(struct ebt_entry_watcher *w,
+				      struct net *net, unsigned int *i)
 {
 	struct xt_tgdtor_param par;
 
@@ -620,8 +620,8 @@ struct ebt_cl_stack {
 	return 0;
 }
 
-static inline int
-ebt_cleanup_entry(struct ebt_entry *e, struct net *net, unsigned int *cnt)
+static inline int ebt_cleanup_entry(struct ebt_entry *e, struct net *net,
+				    unsigned int *cnt)
 {
 	struct xt_tgdtor_param par;
 	struct ebt_entry_target *t;
@@ -645,11 +645,11 @@ struct ebt_cl_stack {
 	return 0;
 }
 
-static inline int
-ebt_check_entry(struct ebt_entry *e, struct net *net,
-		const struct ebt_table_info *newinfo,
-		const char *name, unsigned int *cnt,
-		struct ebt_cl_stack *cl_s, unsigned int udc_cnt)
+static inline int ebt_check_entry(struct ebt_entry *e, struct net *net,
+				  const struct ebt_table_info *newinfo,
+				  const char *name, unsigned int *cnt,
+				  struct ebt_cl_stack *cl_s,
+				  unsigned int udc_cnt)
 {
 	struct ebt_entry_target *t;
 	struct xt_target *target;
@@ -1157,8 +1157,8 @@ static int do_replace(struct net *net, const void __user *user,
 	return ret;
 }
 
-struct ebt_table *
-ebt_register_table(struct net *net, const struct ebt_table *input_table)
+struct ebt_table * ebt_register_table(struct net *net,
+				      const struct ebt_table *input_table)
 {
 	struct ebt_table_info *newinfo;
 	struct ebt_table *t, *table;
-- 
1.7.1

