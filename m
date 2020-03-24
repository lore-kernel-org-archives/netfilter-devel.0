Return-Path: <SRS0=lJQT=5J=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7395BC43331
	for <netfilter-devel@archiver.kernel.org>; Tue, 24 Mar 2020 09:59:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 481B720786
	for <netfilter-devel@archiver.kernel.org>; Tue, 24 Mar 2020 09:59:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727129AbgCXJ7Q (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 24 Mar 2020 05:59:16 -0400
Received: from correo.us.es ([193.147.175.20]:58910 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727130AbgCXJ7Q (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 24 Mar 2020 05:59:16 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B5F9DEFC93
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Mar 2020 10:58:38 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A7329DA3A1
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Mar 2020 10:58:38 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 9C9C6DA39F; Tue, 24 Mar 2020 10:58:38 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DB963DA3A3
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Mar 2020 10:58:36 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 24 Mar 2020 10:58:36 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id BEE9542EF42A
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Mar 2020 10:58:36 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf 2/2] netfilter: nft_fwd_netdev: allow to redirect to ifb via ingress
Date:   Tue, 24 Mar 2020 10:59:06 +0100
Message-Id: <20200324095906.89979-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200324095906.89979-1-pablo@netfilter.org>
References: <20200324095906.89979-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Set skb->tc_redirected to 1, otherwise the ifb driver drops the packet.
Set skb->tc_from_ingress to 1 to reinject the packet back to the ingress
path after leaving the ifb egress path.

This patch inconditionally sets on these two skb fields that are
meaningful to the ifb driver. The existing forward action is guaranteed
to run from ingress path.

Fixes: 39e6dea28adc ("netfilter: nf_tables: add forward expression to the netdev family")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_fwd_netdev.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/netfilter/nft_fwd_netdev.c b/net/netfilter/nft_fwd_netdev.c
index ddd28de810b6..74f050ba6bad 100644
--- a/net/netfilter/nft_fwd_netdev.c
+++ b/net/netfilter/nft_fwd_netdev.c
@@ -28,6 +28,10 @@ static void nft_fwd_netdev_eval(const struct nft_expr *expr,
 	struct nft_fwd_netdev *priv = nft_expr_priv(expr);
 	int oif = regs->data[priv->sreg_dev];
 
+	/* These are used by ifb only. */
+	pkt->skb->tc_redirected = 1;
+	pkt->skb->tc_from_ingress = 1;
+
 	nf_fwd_netdev_egress(pkt, oif);
 	regs->verdict.code = NF_STOLEN;
 }
-- 
2.11.0

