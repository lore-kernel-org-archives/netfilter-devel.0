Return-Path: <SRS0=0Xdd=RL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B497C43381
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 Mar 2019 00:34:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 68F3E20840
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 Mar 2019 00:34:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726237AbfCHAeV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 7 Mar 2019 19:34:21 -0500
Received: from mail.us.es ([193.147.175.20]:49272 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726241AbfCHAeU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 7 Mar 2019 19:34:20 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 620261B6947
        for <netfilter-devel@vger.kernel.org>; Fri,  8 Mar 2019 01:34:18 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 44ACCDA797
        for <netfilter-devel@vger.kernel.org>; Fri,  8 Mar 2019 01:34:18 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 3A072DA856; Fri,  8 Mar 2019 01:34:18 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C1CA2DA844;
        Fri,  8 Mar 2019 01:34:15 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 08 Mar 2019 01:34:15 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id A095F4265A2F;
        Fri,  8 Mar 2019 01:34:15 +0100 (CET)
Date:   Fri, 8 Mar 2019 01:34:15 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, kfm@plushkava.net
Subject: Re: [PATCH nf] netfilter: nf_tables: fix set double-free in abort
 path
Message-ID: <20190308003415.i5kkbpferkhae3rm@salvia>
References: <20190307193041.28798-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="cnud7ed37oniawto"
Content-Disposition: inline
In-Reply-To: <20190307193041.28798-1-fw@strlen.de>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--cnud7ed37oniawto
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Florian,

Thanks for sending a patch for this.

On Thu, Mar 07, 2019 at 08:30:41PM +0100, Florian Westphal wrote:
> The abort path can cause a double-free of an (anon) set.
> 
> Added-and-to-be-aborted rule looks like this:
> 
> udp dport { 137, 138 } drop
> 
> The to-be-aborted transaction list looks like this:
> newset
> newsetelem
> newsetelem
> rule
> 
> This gets walked in reverse order, so first pass disables
> the rule, the set elements, then the set.
> 
> After synchronize_rcu(), we then destroy those in same order:
> rule, set element, set element, newset.
> 
> Problem is that the (anon) set has already been bound to the rule,
> so the rule (lookup expression destructor) already frees the set,
> when then cause use-after-free when trying to delete the elements
> from this set, then try to free the set again when handling the
> newset expression.
> 
> To resolve this, check in first phase if the newset is bound already.
> If so, remove the newset transaction from the list, rule destructor
> will handle cleanup.
> 
> This is still causes the use-after-free on set element removal.
> To handle this, move all affected set elements to a extra list
> and process it first.
>
> This forces strict 'destroy elements, then set' ordering.

So the problem is only the use-after-free from the NEWSETELEM abort
path, right?

Probably we can fix this problem with this patch too? Idea is to keep
this 'bound' internal flag, in that case, this turns the NEWSET and
NEWSETELEM abort path into noop.

--cnud7ed37oniawto
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-netfilter-nf_tables-skip-new-element-transaction-abo.patch"

From 4972e70f1bec0bd22f2cc5a937797dc438aa8298 Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Fri, 8 Mar 2019 00:58:53 +0100
Subject: [PATCH] netfilter: nf_tables: skip new element transaction abort path
 if set is bound

Rule releases the bound set in first place from the abort path, this
causes the use-after-free on set element removal when undoing the new
element transactions. To handle this, skip new element transaction if
set is bound from the abort path.

Fixes: f6ac85858976 ("netfilter: nf_tables: unbind set in rule from commit path")
Bugzilla: https://bugzilla.netfilter.org/show_bug.cgi?id=1325
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
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
index 4893f248dfdc..74130ad10d1b 100644
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
@@ -6617,10 +6617,13 @@ static void nf_tables_abort_release(struct nft_trans *trans)
 		nf_tables_rule_destroy(&trans->ctx, nft_trans_rule(trans));
 		break;
 	case NFT_MSG_NEWSET:
-		if (!nft_trans_set_bound(trans))
-			nft_set_destroy(nft_trans_set(trans));
+		if (nft_trans_set(trans)->bound)
+			break;
+		nft_set_destroy(nft_trans_set(trans));
 		break;
 	case NFT_MSG_NEWSETELEM:
+		if (nft_trans_elem_set(trans)->bound)
+			break;
 		nft_set_elem_destroy(nft_trans_elem_set(trans),
 				     nft_trans_elem(trans).priv, true);
 		break;
@@ -6691,8 +6694,9 @@ static int __nf_tables_abort(struct net *net)
 			break;
 		case NFT_MSG_NEWSET:
 			trans->ctx.table->use--;
-			if (!nft_trans_set_bound(trans))
-				list_del_rcu(&nft_trans_set(trans)->list);
+			if (nft_trans_set(trans)->bound)
+				break;
+			list_del_rcu(&nft_trans_set(trans)->list);
 			break;
 		case NFT_MSG_DELSET:
 			trans->ctx.table->use++;
@@ -6700,8 +6704,9 @@ static int __nf_tables_abort(struct net *net)
 			nft_trans_destroy(trans);
 			break;
 		case NFT_MSG_NEWSETELEM:
+			if (nft_trans_elem_set(trans)->bound)
+				break;
 			te = (struct nft_trans_elem *)trans->data;
-
 			te->set->ops->remove(net, te->set, &te->elem);
 			atomic_dec(&te->set->nelems);
 			break;
-- 
2.11.0


--cnud7ed37oniawto--
