Return-Path: <SRS0=Eqja=WM=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76E0FC3A59C
	for <netfilter-devel@archiver.kernel.org>; Fri, 16 Aug 2019 14:45:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F6C5206C1
	for <netfilter-devel@archiver.kernel.org>; Fri, 16 Aug 2019 14:45:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727437AbfHPOpQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 16 Aug 2019 10:45:16 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:46192 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727291AbfHPOpP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 16 Aug 2019 10:45:15 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hydTe-0002oy-Fx; Fri, 16 Aug 2019 16:45:14 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nftables 7/8] src: netlink: remove assertion
Date:   Fri, 16 Aug 2019 16:42:40 +0200
Message-Id: <20190816144241.11469-8-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190816144241.11469-1-fw@strlen.de>
References: <20190816144241.11469-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This assert can trigger as follows:

set s {
	type integer,8
	elemets = { 1 }
};
vlan id @s accept

reason is that 'vlan id' will store a 16 bit value into the dreg,
so set should use 'integer,16'.

The kernel won't detect this, as the lookup expression will only
verify that it can load one byte from the given register.

This removes the assertion, in case we hit this condition we can just
return without doing any further actions.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/netlink_delinearize.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index fc2574b1dea9..11c2e2d87c54 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -1796,9 +1796,20 @@ static void binop_adjust_one(const struct expr *binop, struct expr *value,
 {
 	struct expr *left = binop->left;
 
-	assert(value->len >= binop->right->len);
-
 	mpz_rshift_ui(value->value, shift);
+
+	/* This will happen when a set has a key that is
+	 * smaller than the amount of bytes loaded by the
+	 * payload/exthdr expression.
+	 *
+	 * This can't happen with normal nft frontend,
+	 * but it can happen with custom clients or with
+	 * nft sets defined via 'type integer,8' and then
+	 * asking "vlan id @myset".
+	 */
+	if (value->len < binop->right->len)
+		return;
+
 	switch (left->etype) {
 	case EXPR_PAYLOAD:
 	case EXPR_EXTHDR:
-- 
2.21.0

