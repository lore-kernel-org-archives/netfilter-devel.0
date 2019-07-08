Return-Path: <SRS0=pcH3=VF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 108A4C606AC
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Jul 2019 10:32:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E45FC20656
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Jul 2019 10:32:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729436AbfGHKcu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 Jul 2019 06:32:50 -0400
Received: from mail.us.es ([193.147.175.20]:34286 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728976AbfGHKct (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Jul 2019 06:32:49 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 14688BAE8F
        for <netfilter-devel@vger.kernel.org>; Mon,  8 Jul 2019 12:32:47 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0530D909A2
        for <netfilter-devel@vger.kernel.org>; Mon,  8 Jul 2019 12:32:47 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id EE5494FA28; Mon,  8 Jul 2019 12:32:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AAA386DA6D;
        Mon,  8 Jul 2019 12:32:44 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 08 Jul 2019 12:32:44 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 7A0C54265A31;
        Mon,  8 Jul 2019 12:32:44 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 03/15] netfilter: nf_queue: remove unused hook entries pointer
Date:   Mon,  8 Jul 2019 12:32:25 +0200
Message-Id: <20190708103237.28061-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190708103237.28061-1-pablo@netfilter.org>
References: <20190708103237.28061-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Its not used anywhere, so remove this.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
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
2.11.0

