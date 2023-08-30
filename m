Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD8F9C83F16
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Aug 2023 23:59:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241959AbjH3X7p (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 30 Aug 2023 19:59:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245452AbjH3X7o (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Aug 2023 19:59:44 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7E1C5CD7;
        Wed, 30 Aug 2023 16:59:42 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 3/5] netfilter: xt_u32: validate user space input
Date:   Thu, 31 Aug 2023 01:59:33 +0200
Message-Id: <20230830235935.465690-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230830235935.465690-1-pablo@netfilter.org>
References: <20230830235935.465690-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Wander Lairson Costa <wander@redhat.com>

The xt_u32 module doesn't validate the fields in the xt_u32 structure.
An attacker may take advantage of this to trigger an OOB read by setting
the size fields with a value beyond the arrays boundaries.

Add a checkentry function to validate the structure.

This was originally reported by the ZDI project (ZDI-CAN-18408).

Fixes: 1b50b8a371e9 ("[NETFILTER]: Add u32 match")
Cc: stable@vger.kernel.org
Signed-off-by: Wander Lairson Costa <wander@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/xt_u32.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/net/netfilter/xt_u32.c b/net/netfilter/xt_u32.c
index 177b40d08098..117d4615d668 100644
--- a/net/netfilter/xt_u32.c
+++ b/net/netfilter/xt_u32.c
@@ -96,11 +96,32 @@ static bool u32_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	return ret ^ data->invert;
 }
 
+static int u32_mt_checkentry(const struct xt_mtchk_param *par)
+{
+	const struct xt_u32 *data = par->matchinfo;
+	const struct xt_u32_test *ct;
+	unsigned int i;
+
+	if (data->ntests > ARRAY_SIZE(data->tests))
+		return -EINVAL;
+
+	for (i = 0; i < data->ntests; ++i) {
+		ct = &data->tests[i];
+
+		if (ct->nnums > ARRAY_SIZE(ct->location) ||
+		    ct->nvalues > ARRAY_SIZE(ct->value))
+			return -EINVAL;
+	}
+
+	return 0;
+}
+
 static struct xt_match xt_u32_mt_reg __read_mostly = {
 	.name       = "u32",
 	.revision   = 0,
 	.family     = NFPROTO_UNSPEC,
 	.match      = u32_mt,
+	.checkentry = u32_mt_checkentry,
 	.matchsize  = sizeof(struct xt_u32),
 	.me         = THIS_MODULE,
 };
-- 
2.30.2

