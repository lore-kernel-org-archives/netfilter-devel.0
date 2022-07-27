Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5FC9C04A68
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Jul 2022 11:20:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231883AbiG0LUR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Jul 2022 07:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiG0LUP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Jul 2022 07:20:15 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE1FD63FB
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Jul 2022 04:20:14 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1oGf5J-0003bI-FE; Wed, 27 Jul 2022 13:20:13 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 1/7] netlink_delinearize: allow postprocessing on concatenated elements
Date:   Wed, 27 Jul 2022 13:19:57 +0200
Message-Id: <20220727112003.26022-2-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220727112003.26022-1-fw@strlen.de>
References: <20220727112003.26022-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Currently there is no case where the individual expressions inside a
mapped concatenation need to be munged.

However, to support proper delinearization for an input like
'rule netdev nt nc set update ether saddr . vlan id timeout 5s @macset'

we need to allow this.

Right now, this gets listed as:

update @macset { @ll,48,48 . @ll,112,16 & 0xfff timeout 5s }

because the ethernet protocol is replaced by vlan beforehand,
so we fail to map @ll,48,48 to a vlan protocol.

Likewise, we can't map the vlan info either because we cannot
cope with the 'and' operation properly, nor is it removed.

Prepare for this by deleting and re-adding so that we do not
corrupt the linked list.

After this, the list can be safely changed and a followup patch
can start to delete/reallocate expressions.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/netlink_delinearize.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 3bdd98d47eb0..3835b3e522b9 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -2539,16 +2539,21 @@ static void expr_postprocess(struct rule_pp_ctx *ctx, struct expr **exprp)
 		unsigned int type = expr->dtype->type, ntype = 0;
 		int off = expr->dtype->subtypes;
 		const struct datatype *dtype;
+		LIST_HEAD(tmp);
+		struct expr *n;
 
-		list_for_each_entry(i, &expr->expressions, list) {
+		list_for_each_entry_safe(i, n, &expr->expressions, list) {
 			if (type) {
 				dtype = concat_subtype_lookup(type, --off);
 				expr_set_type(i, dtype, dtype->byteorder);
 			}
+			list_del(&i->list);
 			expr_postprocess(ctx, &i);
+			list_add_tail(&i->list, &tmp);
 
 			ntype = concat_subtype_add(ntype, i->dtype->type);
 		}
+		list_splice(&tmp, &expr->expressions);
 		datatype_set(expr, concat_type_alloc(ntype));
 		break;
 	}
-- 
2.35.1

