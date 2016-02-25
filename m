From: Florian Westphal <fw@strlen.de>
Subject: [PATCH v4 nf-next 4/4] netfilter: don't call hooks unless needed
Date: Thu, 25 Feb 2016 10:08:38 +0100
Message-ID: <1456391318-11601-5-git-send-email-fw@strlen.de>
References: <1456391318-11601-1-git-send-email-fw@strlen.de>
Cc: ebiederm@xmission.com, Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:37814 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759483AbcBYJN7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Feb 2016 04:13:59 -0500
In-Reply-To: <1456391318-11601-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

With the previous patches in place, a netns nf_hook_list might be empty,
even if e.g. init_net performs filtering.

Thus change nf_hook_thresh to check the hook_list as well before
initializing hook_state and calling nf_hook_slow().

We still make use of static keys; if no netfilter modules are loaded
list is guaranteed to be empty.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 No changes since v3.

 include/linux/netfilter.h | 29 +++++++++++------------------
 1 file changed, 11 insertions(+), 18 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 0ad5567..9230f9a 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -141,22 +141,6 @@ void nf_unregister_sockopt(struct nf_sockopt_ops *reg);
 
 #ifdef HAVE_JUMP_LABEL
 extern struct static_key nf_hooks_needed[NFPROTO_NUMPROTO][NF_MAX_HOOKS];
-
-static inline bool nf_hook_list_active(struct list_head *hook_list,
-				       u_int8_t pf, unsigned int hook)
-{
-	if (__builtin_constant_p(pf) &&
-	    __builtin_constant_p(hook))
-		return static_key_false(&nf_hooks_needed[pf][hook]);
-
-	return !list_empty(hook_list);
-}
-#else
-static inline bool nf_hook_list_active(struct list_head *hook_list,
-				       u_int8_t pf, unsigned int hook)
-{
-	return !list_empty(hook_list);
-}
 #endif
 
 int nf_hook_slow(struct sk_buff *skb, struct nf_hook_state *state);
@@ -177,9 +161,18 @@ static inline int nf_hook_thresh(u_int8_t pf, unsigned int hook,
 				 int (*okfn)(struct net *, struct sock *, struct sk_buff *),
 				 int thresh)
 {
-	struct list_head *hook_list = &net->nf.hooks[pf][hook];
+	struct list_head *hook_list;
+
+#ifdef HAVE_JUMP_LABEL
+	if (__builtin_constant_p(pf) &&
+	    __builtin_constant_p(hook) &&
+	    !static_key_false(&nf_hooks_needed[pf][hook]))
+		return 1;
+#endif
+
+	hook_list = &net->nf.hooks[pf][hook];
 
-	if (nf_hook_list_active(hook_list, pf, hook)) {
+	if (!list_empty(hook_list)) {
 		struct nf_hook_state state;
 
 		nf_hook_state_init(&state, hook_list, hook, thresh,
-- 
2.4.10

