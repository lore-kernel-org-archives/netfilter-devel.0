Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 188A0CD8C9C
	for <netfilter-devel@archiver.kernel.org>; Tue, 10 Oct 2023 14:54:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233082AbjJJOyU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 10 Oct 2023 10:54:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232586AbjJJOyT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 10 Oct 2023 10:54:19 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC388B7;
        Tue, 10 Oct 2023 07:54:16 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qqE7g-0001Pt-2c; Tue, 10 Oct 2023 16:54:12 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        <netfilter-devel@vger.kernel.org>
Subject: [PATCH net-next 6/8] netfilter: conntrack: simplify nf_conntrack_alter_reply
Date:   Tue, 10 Oct 2023 16:53:36 +0200
Message-ID: <20231010145343.12551-7-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231010145343.12551-1-fw@strlen.de>
References: <20231010145343.12551-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

nf_conntrack_alter_reply doesn't do helper reassignment anymore.
Remove the comments that make this claim.

Furthermore, remove dead code from the function and place ot
in nf_conntrack.h.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_conntrack.h | 14 ++++++++++----
 net/netfilter/nf_conntrack_core.c    | 18 ------------------
 net/netfilter/nf_conntrack_helper.c  |  7 +------
 3 files changed, 11 insertions(+), 28 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 4085765c3370..cba3ccf03fcc 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -160,10 +160,6 @@ static inline struct net *nf_ct_net(const struct nf_conn *ct)
 	return read_pnet(&ct->ct_net);
 }
 
-/* Alter reply tuple (maybe alter helper). */
-void nf_conntrack_alter_reply(struct nf_conn *ct,
-			      const struct nf_conntrack_tuple *newreply);
-
 /* Is this tuple taken? (ignoring any belonging to the given
    conntrack). */
 int nf_conntrack_tuple_taken(const struct nf_conntrack_tuple *tuple,
@@ -284,6 +280,16 @@ static inline bool nf_is_loopback_packet(const struct sk_buff *skb)
 	return skb->dev && skb->skb_iif && skb->dev->flags & IFF_LOOPBACK;
 }
 
+static inline void nf_conntrack_alter_reply(struct nf_conn *ct,
+					    const struct nf_conntrack_tuple *newreply)
+{
+	/* Must be unconfirmed, so not in hash table yet */
+	if (WARN_ON(nf_ct_is_confirmed(ct)))
+		return;
+
+	ct->tuplehash[IP_CT_DIR_REPLY].tuple = *newreply;
+}
+
 #define nfct_time_stamp ((u32)(jiffies))
 
 /* jiffies until ct expires, 0 if already expired */
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 9f6f2e643575..124136b5a79a 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -2042,24 +2042,6 @@ nf_conntrack_in(struct sk_buff *skb, const struct nf_hook_state *state)
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_in);
 
-/* Alter reply tuple (maybe alter helper).  This is for NAT, and is
-   implicitly racy: see __nf_conntrack_confirm */
-void nf_conntrack_alter_reply(struct nf_conn *ct,
-			      const struct nf_conntrack_tuple *newreply)
-{
-	struct nf_conn_help *help = nfct_help(ct);
-
-	/* Should be unconfirmed, so not in hash table yet */
-	WARN_ON(nf_ct_is_confirmed(ct));
-
-	nf_ct_dump_tuple(newreply);
-
-	ct->tuplehash[IP_CT_DIR_REPLY].tuple = *newreply;
-	if (ct->master || (help && !hlist_empty(&help->expectations)))
-		return;
-}
-EXPORT_SYMBOL_GPL(nf_conntrack_alter_reply);
-
 /* Refresh conntrack for this many jiffies and do accounting if do_acct is 1 */
 void __nf_ct_refresh_acct(struct nf_conn *ct,
 			  enum ip_conntrack_info ctinfo,
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index f22691f83853..4ed5878cb25b 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -194,12 +194,7 @@ int __nf_ct_try_assign_helper(struct nf_conn *ct, struct nf_conn *tmpl,
 	struct nf_conntrack_helper *helper = NULL;
 	struct nf_conn_help *help;
 
-	/* We already got a helper explicitly attached. The function
-	 * nf_conntrack_alter_reply - in case NAT is in use - asks for looking
-	 * the helper up again. Since now the user is in full control of
-	 * making consistent helper configurations, skip this automatic
-	 * re-lookup, otherwise we'll lose the helper.
-	 */
+	/* We already got a helper explicitly attached (e.g. nft_ct) */
 	if (test_bit(IPS_HELPER_BIT, &ct->status))
 		return 0;
 
-- 
2.41.0

