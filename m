From: Ralph Sennhauser <ralph.sennhauser@gmail.com>
Subject: [PATCH xtables-addons] build: support for Linux 4.12
Date: Sun, 14 May 2017 18:16:11 +0200
Message-ID: <20170514161611.8498-1-ralph.sennhauser@gmail.com>
Cc: Ralph Sennhauser <ralph.sennhauser@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35514 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758876AbdENQQd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 14 May 2017 12:16:33 -0400
Received: by mail-wm0-f66.google.com with SMTP id v4so22902994wmb.2
        for <netfilter-devel@vger.kernel.org>; Sun, 14 May 2017 09:16:32 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

As a result of commit cc41c84b7e7f ("netfilter: kill the fake untracked
conntrack objects") the helper nf_ct_is_untracked always returns false
and commit ab8bc7ed864b ("netfilter: remove nf_ct_is_untracked") removes
it all together.

Signed-off-by: Ralph Sennhauser <ralph.sennhauser@gmail.com>
---
 extensions/xt_LOGMARK.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/extensions/xt_LOGMARK.c b/extensions/xt_LOGMARK.c
index ed14604..6c00d1d 100644
--- a/extensions/xt_LOGMARK.c
+++ b/extensions/xt_LOGMARK.c
@@ -87,8 +87,10 @@ logmark_tg(struct sk_buff *skb, const struct xt_action_param *par)
 	printk(" ctdir=%s", dir_names[ctinfo >= IP_CT_IS_REPLY]);
 	if (ct == NULL)
 		printk(" ct=NULL ctmark=NULL ctstate=INVALID ctstatus=NONE");
+#if LINUX_VERSION_CODE < KERNEL_VERSION(4, 12, 0)
 	else if (nf_ct_is_untracked(ct))
 		printk(" ct=UNTRACKED ctmark=NULL ctstate=UNTRACKED ctstatus=NONE");
+#endif
 	else
 		logmark_ct(ct, ctinfo);
 
-- 
2.10.2

