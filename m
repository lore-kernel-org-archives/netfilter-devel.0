Return-Path: <SRS0=mmf4=EG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CECAC388F7
	for <netfilter-devel@archiver.kernel.org>; Sat, 31 Oct 2020 10:24:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3AF1620885
	for <netfilter-devel@archiver.kernel.org>; Sat, 31 Oct 2020 10:24:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbgJaKYP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 31 Oct 2020 06:24:15 -0400
Received: from correo.us.es ([193.147.175.20]:37012 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726708AbgJaKYP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 31 Oct 2020 06:24:15 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id EC5FECF243
        for <netfilter-devel@vger.kernel.org>; Sat, 31 Oct 2020 11:24:13 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DCEDDDA72F
        for <netfilter-devel@vger.kernel.org>; Sat, 31 Oct 2020 11:24:13 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D2ACFDA704; Sat, 31 Oct 2020 11:24:13 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B78FCDA730
        for <netfilter-devel@vger.kernel.org>; Sat, 31 Oct 2020 11:24:11 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 31 Oct 2020 11:24:11 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id A331242EF42A
        for <netfilter-devel@vger.kernel.org>; Sat, 31 Oct 2020 11:24:11 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next] netfilter: nft_reject_inet: allow to use reject from inet ingress
Date:   Sat, 31 Oct 2020 11:24:08 +0100
Message-Id: <20201031102408.1815-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Enhance validation to support for reject from inet ingress chains.

Note that, reject from inet ingress and netdev ingress differ.

Reject packets from inet ingress are sent through ip_local_out() since
inet reject emulates the IP layer receive path. So the reject packet
follows to classic IP output and postrouting paths.

The reject action from netdev ingress assumes the packet not yet entered
the IP layer, so the reject packet is sent through dev_queue_xmit().
Therefore, reject packets from netdev ingress do not follow the classic
IP output and postrouting paths.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_reject_inet.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_reject_inet.c b/net/netfilter/nft_reject_inet.c
index ffd1aa1f9576..32f3ea398ddf 100644
--- a/net/netfilter/nft_reject_inet.c
+++ b/net/netfilter/nft_reject_inet.c
@@ -58,6 +58,18 @@ static void nft_reject_inet_eval(const struct nft_expr *expr,
 	regs->verdict.code = NF_DROP;
 }
 
+static int nft_reject_inet_validate(const struct nft_ctx *ctx,
+				    const struct nft_expr *expr,
+				    const struct nft_data **data)
+{
+	return nft_chain_validate_hooks(ctx->chain,
+					(1 << NF_INET_LOCAL_IN) |
+					(1 << NF_INET_FORWARD) |
+					(1 << NF_INET_LOCAL_OUT) |
+					(1 << NF_INET_PRE_ROUTING) |
+					(1 << NF_INET_INGRESS));
+}
+
 static struct nft_expr_type nft_reject_inet_type;
 static const struct nft_expr_ops nft_reject_inet_ops = {
 	.type		= &nft_reject_inet_type,
@@ -65,7 +77,7 @@ static const struct nft_expr_ops nft_reject_inet_ops = {
 	.eval		= nft_reject_inet_eval,
 	.init		= nft_reject_init,
 	.dump		= nft_reject_dump,
-	.validate	= nft_reject_validate,
+	.validate	= nft_reject_inet_validate,
 };
 
 static struct nft_expr_type nft_reject_inet_type __read_mostly = {
-- 
2.20.1

