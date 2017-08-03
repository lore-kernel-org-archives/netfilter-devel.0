From: Taehee Yoo <ap420073@gmail.com>
Subject: [PATCH] netfilter: remove prototype of netfilter_queue_init
Date: Thu,  3 Aug 2017 10:26:20 +0900
Message-ID: <20170803012620.17993-1-ap420073@gmail.com>
Cc: ap420073@gmail.com
To: pablo@netfilter.org, fw@strlen.de, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:38227 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751206AbdHCB03 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Aug 2017 21:26:29 -0400
Received: by mail-pg0-f66.google.com with SMTP id 123so6272927pga.5
        for <netfilter-devel@vger.kernel.org>; Wed, 02 Aug 2017 18:26:29 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The netfilter_queue_init() has been removed.
so we can remove the prototype of that.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 net/netfilter/nf_internals.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/netfilter/nf_internals.h b/net/netfilter/nf_internals.h
index bfa742d..19f00a4 100644
--- a/net/netfilter/nf_internals.h
+++ b/net/netfilter/nf_internals.h
@@ -15,7 +15,6 @@
 int nf_queue(struct sk_buff *skb, struct nf_hook_state *state,
 	     struct nf_hook_entry **entryp, unsigned int verdict);
 unsigned int nf_queue_nf_hook_drop(struct net *net);
-int __init netfilter_queue_init(void);
 
 /* nf_log.c */
 int __init netfilter_log_init(void);
-- 
2.9.3

