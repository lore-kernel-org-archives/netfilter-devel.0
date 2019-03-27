Return-Path: <SRS0=34lc=R6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 034A6C43381
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Mar 2019 19:33:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C8DB42075C
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Mar 2019 19:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553715195;
	bh=Pnka2KWCFbN+CL3GfPF+gtjWz7b5RKVBpofK6u/R8E8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=IWICMJ5rz0adAq9GOe0vSHgBAvfF/do0ehtmsCehBXwl/6O5/OASvqj9QPavyQxgh
	 yZPp2uOetqsjcSqFlyQ7mOTaw/+qKnj3/Jw8TKLt6TS+CCErQLCExYktaNFXUuw99P
	 E2ssWaQCJoCo7u9naMwkabpqMalqEptvE5BpvFcE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732146AbfC0TdI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Mar 2019 15:33:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:42498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730874AbfC0SCe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Mar 2019 14:02:34 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7784F217D7;
        Wed, 27 Mar 2019 18:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553709753;
        bh=Pnka2KWCFbN+CL3GfPF+gtjWz7b5RKVBpofK6u/R8E8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qlmzwNQUvj+sQ8OwTMIoNF7VOenjAZPXYXJFscCDeTe9BylS00ZWUxQZWAKAjm7Wq
         ALcGsfk3DwbT5Q0bvGGtYbXNpe8uCRSu8IjmlMHua5wqIo+3lrA3j86VivwBuBT21Q
         rovPoVt0GUKd05HglLtsUi8JsHigZfKJdWbzSZHE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.0 020/262] netfilter: nf_tables: fix set double-free in abort path
Date:   Wed, 27 Mar 2019 13:57:55 -0400
Message-Id: <20190327180158.10245-20-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190327180158.10245-1-sashal@kernel.org>
References: <20190327180158.10245-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 40ba1d9b4d19796afc9b7ece872f5f3e8f5e2c13 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_tables.h |  6 ++----
 net/netfilter/nf_tables_api.c     | 17 +++++++++++------
 2 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index b4984bbbe157..3d58acf94dd2 100644
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
@@ -1329,15 +1330,12 @@ struct nft_trans_rule {
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
index 4893f248dfdc..e1724f9d8b9d 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -127,7 +127,7 @@ static void nft_set_trans_bind(const struct nft_ctx *ctx, struct nft_set *set)
 	list_for_each_entry_reverse(trans, &net->nft.commit_list, list) {
 		if (trans->msg_type == NFT_MSG_NEWSET &&
 		    nft_trans_set(trans) == set) {
-			nft_trans_set_bound(trans) = true;
+			set->bound = true;
 			break;
 		}
 	}
@@ -6617,8 +6617,7 @@ static void nf_tables_abort_release(struct nft_trans *trans)
 		nf_tables_rule_destroy(&trans->ctx, nft_trans_rule(trans));
 		break;
 	case NFT_MSG_NEWSET:
-		if (!nft_trans_set_bound(trans))
-			nft_set_destroy(nft_trans_set(trans));
+		nft_set_destroy(nft_trans_set(trans));
 		break;
 	case NFT_MSG_NEWSETELEM:
 		nft_set_elem_destroy(nft_trans_elem_set(trans),
@@ -6691,8 +6690,11 @@ static int __nf_tables_abort(struct net *net)
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
@@ -6700,8 +6702,11 @@ static int __nf_tables_abort(struct net *net)
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
2.19.1

