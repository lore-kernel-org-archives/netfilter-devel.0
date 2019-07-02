Return-Path: <SRS0=Rfup=U7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40A15C06510
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 Jul 2019 18:44:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 252C421721
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 Jul 2019 18:44:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbfGBSow (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 2 Jul 2019 14:44:52 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:44472 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725851AbfGBSow (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 2 Jul 2019 14:44:52 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hiNlq-0006vR-Ba; Tue, 02 Jul 2019 20:44:50 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: nf_queue: remove unused hook entries pointer
Date:   Tue,  2 Jul 2019 20:41:14 +0200
Message-Id: <20190702184114.11670-1-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Its not used anywhere, so remove this.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_queue.h | 3 +--
 net/bridge/br_input.c            | 2 +-
 net/netfilter/core.c             | 2 +-
 net/netfilter/nf_queue.c         | 8 +++-----
 4 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/include/net/netfilter/nf_queue.h b/include/net/netfilter/nf_queue.h
index 7239105d9d2e..3cb6dcf53a4e 100644
--- a/include/net/netfilter/nf_queue.h
+++ b/include/net/netfilter/nf_queue.h
@@ -120,6 +120,5 @@ nfqueue_hash(const struct sk_buff *skb, u16 queue, u16 queues_total, u8 family,
 }
 
 int nf_queue(struct sk_buff *skb, struct nf_hook_state *state,
-	     const struct nf_hook_entries *entries, unsigned int index,
-	     unsigned int verdict);
+	     unsigned int index, unsigned int verdict);
 #endif /* _NF_QUEUE_H */
diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
index 21b74e7a7b2f..512383d5e53f 100644
--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -234,7 +234,7 @@ static int nf_hook_bridge_pre(struct sk_buff *skb, struct sk_buff **pskb)
 			kfree_skb(skb);
 			return RX_HANDLER_CONSUMED;
 		case NF_QUEUE:
-			ret = nf_queue(skb, &state, e, i, verdict);
+			ret = nf_queue(skb, &state, i, verdict);
 			if (ret == 1)
 				continue;
 			return RX_HANDLER_CONSUMED;
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 817a9e5d16e4..5d5bdf450091 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -520,7 +520,7 @@ int nf_hook_slow(struct sk_buff *skb, struct nf_hook_state *state,
 				ret = -EPERM;
 			return ret;
 		case NF_QUEUE:
-			ret = nf_queue(skb, state, e, s, verdict);
+			ret = nf_queue(skb, state, s, verdict);
 			if (ret == 1)
 				continue;
 			return ret;
diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index b5b2be55ca82..c72a5bdd123f 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -156,7 +156,6 @@ static void nf_ip6_saveroute(const struct sk_buff *skb,
 }
 
 static int __nf_queue(struct sk_buff *skb, const struct nf_hook_state *state,
-		      const struct nf_hook_entries *entries,
 		      unsigned int index, unsigned int queuenum)
 {
 	int status = -ENOENT;
@@ -225,12 +224,11 @@ static int __nf_queue(struct sk_buff *skb, const struct nf_hook_state *state,
 
 /* Packets leaving via this function must come back through nf_reinject(). */
 int nf_queue(struct sk_buff *skb, struct nf_hook_state *state,
-	     const struct nf_hook_entries *entries, unsigned int index,
-	     unsigned int verdict)
+	     unsigned int index, unsigned int verdict)
 {
 	int ret;
 
-	ret = __nf_queue(skb, state, entries, index, verdict >> NF_VERDICT_QBITS);
+	ret = __nf_queue(skb, state, index, verdict >> NF_VERDICT_QBITS);
 	if (ret < 0) {
 		if (ret == -ESRCH &&
 		    (verdict & NF_VERDICT_FLAG_QUEUE_BYPASS))
@@ -336,7 +334,7 @@ void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict)
 		local_bh_enable();
 		break;
 	case NF_QUEUE:
-		err = nf_queue(skb, &entry->state, hooks, i, verdict);
+		err = nf_queue(skb, &entry->state, i, verdict);
 		if (err == 1)
 			goto next_hook;
 		break;
-- 
2.21.0

