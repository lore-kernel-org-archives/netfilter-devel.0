From: Aaron Conole <aconole@bytheb.org>
Subject: [PATCH RFC netfilter-next 2/3] netfilter: decouple nf_hook_entry and nf_hook_ops
Date: Thu, 27 Oct 2016 14:27:52 -0400
Message-ID: <1477592873-4468-3-git-send-email-aconole@bytheb.org>
References: <1477592873-4468-1-git-send-email-aconole@bytheb.org>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:33947 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S942199AbcJ0S2F (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Oct 2016 14:28:05 -0400
Received: by mail-qt0-f196.google.com with SMTP id p53so37269qtp.1
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Oct 2016 11:28:05 -0700 (PDT)
In-Reply-To: <1477592873-4468-1-git-send-email-aconole@bytheb.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

During nfhook traversal we only need a very small subset of
nf_hook_ops members.

We need:
- next element
- hook function to call
- hook function priv argument

Bridge netfilter also needs 'thresh'; can be obtained via ->orig_ops.

nf_hook_entry struct is now 32 bytes on x86_64.

Followup patch will turn the run-time list into an array that only
stores hook functions plus their priv arguments.

Suggested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Aaron Conole <aconole@bytheb.org>
---
 include/linux/netfilter.h | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index b25386b..cc2d977 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -76,7 +76,8 @@ struct nf_hook_ops {
 
 struct nf_hook_entry {
 	struct nf_hook_entry __rcu	*next;
-	struct nf_hook_ops		ops;
+	nf_hookfn			*hook;
+	void				*priv;
 	const struct nf_hook_ops	*orig_ops;
 };
 
@@ -84,26 +85,27 @@ static inline void
 nf_hook_entry_init(struct nf_hook_entry *entry,	const struct nf_hook_ops *ops)
 {
 	entry->next = NULL;
-	entry->ops = *ops;
+	entry->hook = ops->hook;
+	entry->priv = ops->priv;
 	entry->orig_ops = ops;
 }
 
 static inline int
 nf_hook_entry_priority(const struct nf_hook_entry *entry)
 {
-	return entry->ops.priority;
+	return entry->orig_ops->priority;
 }
 
 static inline nf_hookfn *
 nf_hook_entry_hookfn(const struct nf_hook_entry *entry)
 {
-	return entry->ops.hook;
+	return entry->hook;
 }
 
 static inline void *
 nf_hook_entry_priv(const struct nf_hook_entry *entry)
 {
-	return entry->ops.priv;
+	return entry->priv;
 }
 
 static inline const struct nf_hook_ops *
-- 
2.7.4

