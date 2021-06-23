Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59DD0C4743C
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Jun 2021 11:26:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 309A761076
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Jun 2021 11:26:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230061AbhFWL2u (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 23 Jun 2021 07:28:50 -0400
Received: from mail.netfilter.org ([217.70.188.207]:60522 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230031AbhFWL2t (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 23 Jun 2021 07:28:49 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 542246423C
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Jun 2021 13:25:06 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] libnftables: fix memleak when EOPNOTSUPP
Date:   Wed, 23 Jun 2021 13:26:28 +0200
Message-Id: <20210623112628.1543-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The err->seqnum == batch_seqnum case results in a memleak of mnl_err
objects under some scenarios such as nf_tables kernel support is not
available or user runs the nft executable as non-root.

Fixes: f930cc500318 ("nftables: fix supression of "permission denied" errors")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/libnftables.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/src/libnftables.c b/src/libnftables.c
index e080eb032770..2378f7dd76fb 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -89,6 +89,12 @@ static int nft_netlink(struct nft_ctx *nft,
 			last_seqnum = UINT32_MAX;
 		}
 	}
+	/* nfnetlink uses the first netlink message header in the batch whose
+	 * sequence number is zero to report for EOPNOTSUPP and EPERM errors in
+	 * some scenarios. Now it is safe to release here.
+	 */
+	list_for_each_entry_safe(err, tmp, &err_list, head)
+		mnl_err_list_free(err);
 out:
 	mnl_batch_reset(ctx.batch);
 	return ret;
-- 
2.30.2

