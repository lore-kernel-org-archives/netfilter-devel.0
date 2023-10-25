Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 155DBC25B6B
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Oct 2023 21:26:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbjJYV0K (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 25 Oct 2023 17:26:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbjJYV0I (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 25 Oct 2023 17:26:08 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 99363192;
        Wed, 25 Oct 2023 14:26:06 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, fw@strlen.de
Subject: [PATCH net-next 07/19] netfilter: conntrack: switch connlabels to atomic_t
Date:   Wed, 25 Oct 2023 23:25:43 +0200
Message-Id: <20231025212555.132775-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20231025212555.132775-1-pablo@netfilter.org>
References: <20231025212555.132775-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

The spinlock is back from the day when connabels did not have
a fixed size and reallocation had to be supported.

Remove it.  This change also allows to call the helpers from
softirq or timers without deadlocks.

Also add WARN()s to catch refcounting imbalances.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_labels.h |  2 +-
 include/net/netns/conntrack.h               |  2 +-
 net/netfilter/nf_conntrack_labels.c         | 17 ++++++++---------
 3 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_labels.h b/include/net/netfilter/nf_conntrack_labels.h
index fcb19a4e8f2b..6903f72bcc15 100644
--- a/include/net/netfilter/nf_conntrack_labels.h
+++ b/include/net/netfilter/nf_conntrack_labels.h
@@ -39,7 +39,7 @@ static inline struct nf_conn_labels *nf_ct_labels_ext_add(struct nf_conn *ct)
 #ifdef CONFIG_NF_CONNTRACK_LABELS
 	struct net *net = nf_ct_net(ct);
 
-	if (net->ct.labels_used == 0)
+	if (atomic_read(&net->ct.labels_used) == 0)
 		return NULL;
 
 	return nf_ct_ext_add(ct, NF_CT_EXT_LABELS, GFP_ATOMIC);
diff --git a/include/net/netns/conntrack.h b/include/net/netns/conntrack.h
index 1f463b3957c7..bae914815aa3 100644
--- a/include/net/netns/conntrack.h
+++ b/include/net/netns/conntrack.h
@@ -107,7 +107,7 @@ struct netns_ct {
 	struct nf_ct_event_notifier __rcu *nf_conntrack_event_cb;
 	struct nf_ip_net	nf_ct_proto;
 #if defined(CONFIG_NF_CONNTRACK_LABELS)
-	unsigned int		labels_used;
+	atomic_t		labels_used;
 #endif
 };
 #endif
diff --git a/net/netfilter/nf_conntrack_labels.c b/net/netfilter/nf_conntrack_labels.c
index 6e70e137a0a6..6c46aad23313 100644
--- a/net/netfilter/nf_conntrack_labels.c
+++ b/net/netfilter/nf_conntrack_labels.c
@@ -11,8 +11,6 @@
 #include <net/netfilter/nf_conntrack_ecache.h>
 #include <net/netfilter/nf_conntrack_labels.h>
 
-static DEFINE_SPINLOCK(nf_connlabels_lock);
-
 static int replace_u32(u32 *address, u32 mask, u32 new)
 {
 	u32 old, tmp;
@@ -60,23 +58,24 @@ EXPORT_SYMBOL_GPL(nf_connlabels_replace);
 
 int nf_connlabels_get(struct net *net, unsigned int bits)
 {
+	int v;
+
 	if (BIT_WORD(bits) >= NF_CT_LABELS_MAX_SIZE / sizeof(long))
 		return -ERANGE;
 
-	spin_lock(&nf_connlabels_lock);
-	net->ct.labels_used++;
-	spin_unlock(&nf_connlabels_lock);
-
 	BUILD_BUG_ON(NF_CT_LABELS_MAX_SIZE / sizeof(long) >= U8_MAX);
 
+	v = atomic_inc_return_relaxed(&net->ct.labels_used);
+	WARN_ON_ONCE(v <= 0);
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(nf_connlabels_get);
 
 void nf_connlabels_put(struct net *net)
 {
-	spin_lock(&nf_connlabels_lock);
-	net->ct.labels_used--;
-	spin_unlock(&nf_connlabels_lock);
+	int v = atomic_dec_return_relaxed(&net->ct.labels_used);
+
+	WARN_ON_ONCE(v < 0);
 }
 EXPORT_SYMBOL_GPL(nf_connlabels_put);
-- 
2.30.2

