Return-Path: <SRS0=Tpyl=XZ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FAADC4360C
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Sep 2019 09:05:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1BE5E2086A
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Sep 2019 09:05:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730345AbfI3JF5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 30 Sep 2019 05:05:57 -0400
Received: from correo.us.es ([193.147.175.20]:54510 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727885AbfI3JF5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 30 Sep 2019 05:05:57 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 008211C41C9
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Sep 2019 11:05:53 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E46F9B7FFB
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Sep 2019 11:05:52 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D9ED2B7FF6; Mon, 30 Sep 2019 11:05:52 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BE0FD4D746
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Sep 2019 11:05:50 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 30 Sep 2019 11:05:50 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id A6AFE41E4800
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Sep 2019 11:05:50 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf] netfilter: nft_connlimit: disable bh on garbage collection
Date:   Mon, 30 Sep 2019 11:05:49 +0200
Message-Id: <20190930090549.24317-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

BH must be disabled when invoking nf_conncount_gc_list() to perform
garbage collection, otherwise deadlock might happen.

  nf_conncount_add+0x1f/0x50 [nf_conncount]
  nft_connlimit_eval+0x4c/0xe0 [nft_connlimit]
  nft_dynset_eval+0xb5/0x100 [nf_tables]
  nft_do_chain+0xea/0x420 [nf_tables]
  ? sch_direct_xmit+0x111/0x360
  ? noqueue_init+0x10/0x10
  ? __qdisc_run+0x84/0x510
  ? tcp_packet+0x655/0x1610 [nf_conntrack]
  ? ip_finish_output2+0x1a7/0x430
  ? tcp_error+0x130/0x150 [nf_conntrack]
  ? nf_conntrack_in+0x1fc/0x4c0 [nf_conntrack]
  nft_do_chain_ipv4+0x66/0x80 [nf_tables]
  nf_hook_slow+0x44/0xc0
  ip_rcv+0xb5/0xd0
  ? ip_rcv_finish_core.isra.19+0x360/0x360
  __netif_receive_skb_one_core+0x52/0x70
  netif_receive_skb_internal+0x34/0xe0
  napi_gro_receive+0xba/0xe0
  e1000_clean_rx_irq+0x1e9/0x420 [e1000e]
  e1000e_poll+0xbe/0x290 [e1000e]
  net_rx_action+0x149/0x3b0
  __do_softirq+0xde/0x2d8
  irq_exit+0xba/0xc0
  do_IRQ+0x85/0xd0
  common_interrupt+0xf/0xf
  </IRQ>
  RIP: 0010:nf_conncount_gc_list+0x3b/0x130 [nf_conncount]

Fixes: 2f971a8f4255 ("netfilter: nf_conncount: move all list iterations under spinlock")
Reported-by: Laura Garcia Liebana <nevola@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_connlimit.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_connlimit.c b/net/netfilter/nft_connlimit.c
index af1497ab9464..69d6173f91e2 100644
--- a/net/netfilter/nft_connlimit.c
+++ b/net/netfilter/nft_connlimit.c
@@ -218,8 +218,13 @@ static void nft_connlimit_destroy_clone(const struct nft_ctx *ctx,
 static bool nft_connlimit_gc(struct net *net, const struct nft_expr *expr)
 {
 	struct nft_connlimit *priv = nft_expr_priv(expr);
+	bool ret;
 
-	return nf_conncount_gc_list(net, &priv->list);
+	local_bh_disable();
+	ret = nf_conncount_gc_list(net, &priv->list);
+	local_bh_enable();
+
+	return ret;
 }
 
 static struct nft_expr_type nft_connlimit_type;
-- 
2.11.0

