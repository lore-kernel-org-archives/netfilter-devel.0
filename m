Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48377C4707F
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 May 2021 19:54:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 20F536101E
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 May 2021 19:54:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235348AbhE0T4V (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 27 May 2021 15:56:21 -0400
Received: from mail.netfilter.org ([217.70.188.207]:39640 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235288AbhE0T4V (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 May 2021 15:56:21 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id C3C5F64502
        for <netfilter-devel@vger.kernel.org>; Thu, 27 May 2021 21:53:44 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v2] netfilter: nft_ct: skip expectations for confirmed conntrack
Date:   Thu, 27 May 2021 21:54:42 +0200
Message-Id: <20210527195442.2247-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

nft_ct_expect_obj_eval() calls nf_ct_ext_add() for a confirmed
conntrack entry. However, nf_ct_ext_add() can only be called for
!nf_ct_is_confirmed().

[ 1825.349056] WARNING: CPU: 0 PID: 1279 at net/netfilter/nf_conntrack_extend.c:48 nf_ct_xt_add+0x18e/0x1a0 [nf_conntrack]
[ 1825.351391] RIP: 0010:nf_ct_ext_add+0x18e/0x1a0 [nf_conntrack]
[ 1825.351493] Code: 41 5c 41 5d 41 5e 41 5f c3 41 bc 0a 00 00 00 e9 15 ff ff ff ba 09 00 00 00 31 f6 4c 89 ff e8 69 6c 3d e9 eb 96 45 31 ed eb cd <0f> 0b e9 b1 fe ff ff e8 86 79 14 e9 eb bf 0f 1f 40 00 0f 1f 44 00
[ 1825.351721] RSP: 0018:ffffc90002e1f1e8 EFLAGS: 00010202
[ 1825.351790] RAX: 000000000000000e RBX: ffff88814f5783c0 RCX: ffffffffc0e4f887
[ 1825.351881] RDX: dffffc0000000000 RSI: 0000000000000008 RDI: ffff88814f578440
[ 1825.351971] RBP: 0000000000000000 R08: 0000000000000000 R09: ffff88814f578447
[ 1825.352060] R10: ffffed1029eaf088 R11: 0000000000000001 R12: ffff88814f578440
[ 1825.352150] R13: ffff8882053f3a00 R14: 0000000000000000 R15: 0000000000000a20
[ 1825.352240] FS:  00007f992261c900(0000) GS:ffff889faec00000(0000) knlGS:0000000000000000
[ 1825.352343] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1825.352417] CR2: 000056070a4d1158 CR3: 000000015efe0000 CR4: 0000000000350ee0
[ 1825.352508] Call Trace:
[ 1825.352544]  nf_ct_helper_ext_add+0x10/0x60 [nf_conntrack]
[ 1825.352641]  nft_ct_expect_obj_eval+0x1b8/0x1e0 [nft_ct]
[ 1825.352716]  nft_do_chain+0x232/0x850 [nf_tables]

Add the ct helper extension only for unconfirmed conntrack. Skip rule
evaluation if the ct helper extension does not exist. Thus, you can
only create expectations from the first packet.

It should be possible to remove this limitation by adding a new action
to attach a generic ct helper to the first packet. Then, use this ct
helper extension from follow up packets to create the ct expectation.

While at it, add a missing check to skip the template conntrack too
and remove check for IPCT_UNTRACK which is implicit to !ct.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: more simple oneliner fix for this problem.

 net/netfilter/nft_ct.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 0592a9456084..337e22d8b40b 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -1217,7 +1217,7 @@ static void nft_ct_expect_obj_eval(struct nft_object *obj,
 	struct nf_conn *ct;
 
 	ct = nf_ct_get(pkt->skb, &ctinfo);
-	if (!ct || ctinfo == IP_CT_UNTRACKED) {
+	if (!ct || nf_ct_is_confirmed(ct) || nf_ct_is_template(ct)) {
 		regs->verdict.code = NFT_BREAK;
 		return;
 	}
-- 
2.30.2

