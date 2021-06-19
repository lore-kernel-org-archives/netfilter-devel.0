Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A25FFC48BE8
	for <netfilter-devel@archiver.kernel.org>; Sat, 19 Jun 2021 00:11:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 788C86102A
	for <netfilter-devel@archiver.kernel.org>; Sat, 19 Jun 2021 00:11:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231680AbhFSANM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 18 Jun 2021 20:13:12 -0400
Received: from mail.netfilter.org ([217.70.188.207]:51474 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbhFSANM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 18 Jun 2021 20:13:12 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 6800D6426B
        for <netfilter-devel@vger.kernel.org>; Sat, 19 Jun 2021 02:09:40 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH] netfilter: nf_tables: memleak in hw offload abort path
Date:   Sat, 19 Jun 2021 02:10:57 +0200
Message-Id: <20210619001057.2200-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Release flow from the abort path, this is easy to reproduce since
b72920f6e4a9 ("netfilter: nftables: counter hardware offload support").

unreferenced object 0xffff8881f0fa7700 (size 128):
  comm "nft", pid 1335, jiffies 4294931120 (age 4163.740s)
  hex dump (first 32 bytes):
    08 e4 de 13 82 88 ff ff 98 e4 de 13 82 88 ff ff  ................
    48 e4 de 13 82 88 ff ff 01 00 00 00 00 00 00 00  H...............
  backtrace:
    [<00000000634547e7>] flow_rule_alloc+0x26/0x80
    [<00000000c8426156>] nft_flow_rule_create+0xc9/0x3f0 [nf_tables]
    [<0000000075ff8e46>] nf_tables_newrule+0xc79/0x10a0 [nf_tables]
    [<00000000ba65e40e>] nfnetlink_rcv_batch+0xaac/0xf90 [nfnetlink]
    [<00000000505c614a>] nfnetlink_rcv+0x1bb/0x1f0 [nfnetlink]
    [<00000000eb78e1fe>] netlink_unicast+0x34b/0x480
    [<00000000a8f72c94>] netlink_sendmsg+0x3af/0x690
    [<000000009cb1ddf4>] sock_sendmsg+0x96/0xa0
    [<0000000039d06e44>] ____sys_sendmsg+0x3fe/0x440
    [<00000000137e82ca>] ___sys_sendmsg+0xd8/0x140
    [<000000000c6bf6a6>] __sys_sendmsg+0xb3/0x130
    [<0000000043bd6268>] do_syscall_64+0x40/0xb0
    [<00000000afdebc2d>] entry_SYSCALL_64_after_hwframe+0x44/0xae

Fixes: 63b48c73ff56 ("netfilter: nf_tables_offload: undo updates if transaction fails")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index f20f6ae0e215..aa2c99e99ba6 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8804,11 +8804,16 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 			nft_rule_expr_deactivate(&trans->ctx,
 						 nft_trans_rule(trans),
 						 NFT_TRANS_ABORT);
+			if (trans->ctx.chain->flags & NFT_CHAIN_HW_OFFLOAD)
+				nft_flow_rule_destroy(nft_trans_flow_rule(trans));
 			break;
 		case NFT_MSG_DELRULE:
 			trans->ctx.chain->use++;
 			nft_clear(trans->ctx.net, nft_trans_rule(trans));
 			nft_rule_expr_activate(&trans->ctx, nft_trans_rule(trans));
+			if (trans->ctx.chain->flags & NFT_CHAIN_HW_OFFLOAD)
+				nft_flow_rule_destroy(nft_trans_flow_rule(trans));
+
 			nft_trans_destroy(trans);
 			break;
 		case NFT_MSG_NEWSET:
-- 
2.30.2

