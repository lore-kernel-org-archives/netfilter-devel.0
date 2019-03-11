Return-Path: <SRS0=8PdD=RO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 053ADC4360F
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 Mar 2019 22:50:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D0F7C2087C
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 Mar 2019 22:50:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726639AbfCKWux (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 11 Mar 2019 18:50:53 -0400
Received: from mail.us.es ([193.147.175.20]:34590 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726446AbfCKWup (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 11 Mar 2019 18:50:45 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C61D120991B
        for <netfilter-devel@vger.kernel.org>; Mon, 11 Mar 2019 23:50:43 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B30D8DA47A
        for <netfilter-devel@vger.kernel.org>; Mon, 11 Mar 2019 23:50:43 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A5989DA449; Mon, 11 Mar 2019 23:50:43 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 73A8ADA856;
        Mon, 11 Mar 2019 23:50:41 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 11 Mar 2019 23:50:41 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 44D954265A2F;
        Mon, 11 Mar 2019 23:50:41 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 2/5] netfilter: nf_tables: fix set double-free in abort path
Date:   Mon, 11 Mar 2019 23:50:32 +0100
Message-Id: <20190311225035.21250-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190311225035.21250-1-pablo@netfilter.org>
References: <20190311225035.21250-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The abort path can cause a double-free of an anonymous set.
Added-and-to-be-aborted rule looks like this:

udp dport { 137, 138 } drop

The to-be-aborted transaction list looks like this:

newset
newsetelem
newsetelem
rule

This gets walked in reverse order, so first pass disables the rule, the
set elements, then the set.

After synchronize_rcu(), we then destroy those in same order: rule, set
element, set element, newset.

Problem is that the anonymous set has already been bound to the rule, so
the rule (lookup expression destructor) already frees the set, when then
cause use-after-free when trying to delete the elements from this set,
then try to free the set again when handling the newset expression.

Rule releases the bound set in first place from the abort path, this
causes the use-after-free on set element removal when undoing the new
element transactions. To handle this, skip new element transaction if
set is bound from the abort path.

This is still causes the use-after-free on set element removal.  To
handle this, remove transaction from the list when the set is already
bound.

Joint work with Florian Westphal.

Fixes: f6ac85858976 ("netfilter: nf_tables: unbind set in rule from commit path")
Bugzilla: https://bugzilla.netfilter.org/show_bug.cgi?id=1325
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |  6 ++----
 net/netfilter/nf_tables_api.c     | 17 +++++++++++------
 2 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index c331e96a713b..ed0687b0e0f4 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -416,7 +416,8 @@ struct nft_set {
 	unsigned char			*udata;
 	/* runtime data below here */
 	const struct nft_set_ops	*ops ____cacheline_aligned;
-	u16				flags:14,
+	u16				flags:13,
+					bound:1,
 					genmask:2;
 	u8				klen;
 	u8				dlen;
@@ -1344,15 +1345,12 @@ struct nft_trans_rule {
 struct nft_trans_set {
 	struct nft_set			*set;
 	u32				set_id;
-	bool				bound;
 };
 
 #define nft_trans_set(trans)	\
 	(((struct nft_trans_set *)trans->data)->set)
 #define nft_trans_set_id(trans)	\
 	(((struct nft_trans_set *)trans->data)->set_id)
-#define nft_trans_set_bound(trans)	\
-	(((struct nft_trans_set *)trans->data)->bound)
 
 struct nft_trans_chain {
 	bool				update;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index faf6bd10a19f..1333bf97dc26 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -142,7 +142,7 @@ static void nft_set_trans_bind(const struct nft_ctx *ctx, struct nft_set *set)
 	list_for_each_entry_reverse(trans, &net->nft.commit_list, list) {
 		if (trans->msg_type == NFT_MSG_NEWSET &&
 		    nft_trans_set(trans) == set) {
-			nft_trans_set_bound(trans) = true;
+			set->bound = true;
 			break;
 		}
 	}
@@ -6709,8 +6709,7 @@ static void nf_tables_abort_release(struct nft_trans *trans)
 		nf_tables_rule_destroy(&trans->ctx, nft_trans_rule(trans));
 		break;
 	case NFT_MSG_NEWSET:
-		if (!nft_trans_set_bound(trans))
-			nft_set_destroy(nft_trans_set(trans));
+		nft_set_destroy(nft_trans_set(trans));
 		break;
 	case NFT_MSG_NEWSETELEM:
 		nft_set_elem_destroy(nft_trans_elem_set(trans),
@@ -6783,8 +6782,11 @@ static int __nf_tables_abort(struct net *net)
 			break;
 		case NFT_MSG_NEWSET:
 			trans->ctx.table->use--;
-			if (!nft_trans_set_bound(trans))
-				list_del_rcu(&nft_trans_set(trans)->list);
+			if (nft_trans_set(trans)->bound) {
+				nft_trans_destroy(trans);
+				break;
+			}
+			list_del_rcu(&nft_trans_set(trans)->list);
 			break;
 		case NFT_MSG_DELSET:
 			trans->ctx.table->use++;
@@ -6792,8 +6794,11 @@ static int __nf_tables_abort(struct net *net)
 			nft_trans_destroy(trans);
 			break;
 		case NFT_MSG_NEWSETELEM:
+			if (nft_trans_elem_set(trans)->bound) {
+				nft_trans_destroy(trans);
+				break;
+			}
 			te = (struct nft_trans_elem *)trans->data;
-
 			te->set->ops->remove(net, te->set, &te->elem);
 			atomic_dec(&te->set->nelems);
 			break;
-- 
2.11.0

