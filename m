Return-Path: <SRS0=lJQT=5J=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4745FC4332B
	for <netfilter-devel@archiver.kernel.org>; Tue, 24 Mar 2020 09:59:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 217D12070A
	for <netfilter-devel@archiver.kernel.org>; Tue, 24 Mar 2020 09:59:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727137AbgCXJ7P (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 24 Mar 2020 05:59:15 -0400
Received: from correo.us.es ([193.147.175.20]:58898 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727129AbgCXJ7P (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 24 Mar 2020 05:59:15 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C3DD3EFC83
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Mar 2020 10:58:37 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B59F2DA39F
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Mar 2020 10:58:37 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id AB325DA38F; Tue, 24 Mar 2020 10:58:37 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D168EDA3AC
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Mar 2020 10:58:35 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 24 Mar 2020 10:58:35 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id BCCBC42EF42A
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Mar 2020 10:58:35 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf 1/2] netfilter: nft_fwd_netdev: validate family and chain type
Date:   Tue, 24 Mar 2020 10:59:05 +0100
Message-Id: <20200324095906.89979-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Make sure the forward action is only used from ingress.

Fixes: 39e6dea28adc ("netfilter: nf_tables: add forward expression to the netdev family")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_fwd_netdev.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/netfilter/nft_fwd_netdev.c b/net/netfilter/nft_fwd_netdev.c
index aba11c2333f3..ddd28de810b6 100644
--- a/net/netfilter/nft_fwd_netdev.c
+++ b/net/netfilter/nft_fwd_netdev.c
@@ -190,6 +190,13 @@ static int nft_fwd_neigh_dump(struct sk_buff *skb, const struct nft_expr *expr)
 	return -1;
 }
 
+static int nft_fwd_validate(const struct nft_ctx *ctx,
+			    const struct nft_expr *expr,
+			    const struct nft_data **data)
+{
+	return nft_chain_validate_hooks(ctx->chain, (1 << NF_NETDEV_INGRESS));
+}
+
 static struct nft_expr_type nft_fwd_netdev_type;
 static const struct nft_expr_ops nft_fwd_neigh_netdev_ops = {
 	.type		= &nft_fwd_netdev_type,
@@ -197,6 +204,7 @@ static const struct nft_expr_ops nft_fwd_neigh_netdev_ops = {
 	.eval		= nft_fwd_neigh_eval,
 	.init		= nft_fwd_neigh_init,
 	.dump		= nft_fwd_neigh_dump,
+	.validate	= nft_fwd_validate,
 };
 
 static const struct nft_expr_ops nft_fwd_netdev_ops = {
@@ -205,6 +213,7 @@ static const struct nft_expr_ops nft_fwd_netdev_ops = {
 	.eval		= nft_fwd_netdev_eval,
 	.init		= nft_fwd_netdev_init,
 	.dump		= nft_fwd_netdev_dump,
+	.validate	= nft_fwd_validate,
 	.offload	= nft_fwd_netdev_offload,
 };
 
-- 
2.11.0

