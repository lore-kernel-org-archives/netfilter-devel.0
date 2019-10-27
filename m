Return-Path: <SRS0=YvWH=YU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D68B1CA9EAF
	for <netfilter-devel@archiver.kernel.org>; Sun, 27 Oct 2019 12:02:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B3A0F2070B
	for <netfilter-devel@archiver.kernel.org>; Sun, 27 Oct 2019 12:02:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbfJ0MCl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 27 Oct 2019 08:02:41 -0400
Received: from correo.us.es ([193.147.175.20]:60114 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726713AbfJ0MCl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 27 Oct 2019 08:02:41 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9E1847FC3B
        for <netfilter-devel@vger.kernel.org>; Sun, 27 Oct 2019 13:02:36 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 91E2CB8004
        for <netfilter-devel@vger.kernel.org>; Sun, 27 Oct 2019 13:02:36 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 87501B7FFB; Sun, 27 Oct 2019 13:02:36 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9C452CE17F;
        Sun, 27 Oct 2019 13:02:34 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 27 Oct 2019 13:02:34 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 6B32A42EE395;
        Sun, 27 Oct 2019 13:02:34 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 1/5] netfilter: nf_flow_table: set timeout before insertion into hashes
Date:   Sun, 27 Oct 2019 13:02:17 +0100
Message-Id: <20191027120221.2884-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191027120221.2884-1-pablo@netfilter.org>
References: <20191027120221.2884-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Other garbage collector might remove an entry not fully set up yet.

[570953.958293] RIP: 0010:memcmp+0x9/0x50
[...]
[570953.958567]  flow_offload_hash_cmp+0x1e/0x30 [nf_flow_table]
[570953.958585]  flow_offload_lookup+0x8c/0x110 [nf_flow_table]
[570953.958606]  nf_flow_offload_ip_hook+0x135/0xb30 [nf_flow_table]
[570953.958624]  nf_flow_offload_inet_hook+0x35/0x37 [nf_flow_table_inet]
[570953.958646]  nf_hook_slow+0x3c/0xb0
[570953.958664]  __netif_receive_skb_core+0x90f/0xb10
[570953.958678]  ? ip_rcv_finish+0x82/0xa0
[570953.958692]  __netif_receive_skb_one_core+0x3b/0x80
[570953.958711]  __netif_receive_skb+0x18/0x60
[570953.958727]  netif_receive_skb_internal+0x45/0xf0
[570953.958741]  napi_gro_receive+0xcd/0xf0
[570953.958764]  ixgbe_clean_rx_irq+0x432/0xe00 [ixgbe]
[570953.958782]  ixgbe_poll+0x27b/0x700 [ixgbe]
[570953.958796]  net_rx_action+0x284/0x3c0
[570953.958817]  __do_softirq+0xcc/0x27c
[570953.959464]  irq_exit+0xe8/0x100
[570953.960097]  do_IRQ+0x59/0xe0
[570953.960734]  common_interrupt+0xf/0xf

Fixes: 43c8f131184f ("netfilter: nf_flow_table: fix missing error check for rhashtable_insert_fast")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 132f5228b431..128245efe84a 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -202,6 +202,8 @@ int flow_offload_add(struct nf_flowtable *flow_table, struct flow_offload *flow)
 {
 	int err;
 
+	flow->timeout = (u32)jiffies + NF_FLOW_TIMEOUT;
+
 	err = rhashtable_insert_fast(&flow_table->rhashtable,
 				     &flow->tuplehash[0].node,
 				     nf_flow_offload_rhash_params);
@@ -218,7 +220,6 @@ int flow_offload_add(struct nf_flowtable *flow_table, struct flow_offload *flow)
 		return err;
 	}
 
-	flow->timeout = (u32)jiffies + NF_FLOW_TIMEOUT;
 	return 0;
 }
 EXPORT_SYMBOL_GPL(flow_offload_add);
-- 
2.11.0

