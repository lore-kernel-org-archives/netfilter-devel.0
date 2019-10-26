Return-Path: <SRS0=4S6R=YT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C342CA9EBE
	for <netfilter-devel@archiver.kernel.org>; Sat, 26 Oct 2019 11:48:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 47214206DD
	for <netfilter-devel@archiver.kernel.org>; Sat, 26 Oct 2019 11:48:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726720AbfJZLsE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 26 Oct 2019 07:48:04 -0400
Received: from correo.us.es ([193.147.175.20]:46414 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726667AbfJZLsD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 26 Oct 2019 07:48:03 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C1F248C3C46
        for <netfilter-devel@vger.kernel.org>; Sat, 26 Oct 2019 13:47:58 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B5008A7E9D
        for <netfilter-devel@vger.kernel.org>; Sat, 26 Oct 2019 13:47:58 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id AAB97A7E9A; Sat, 26 Oct 2019 13:47:58 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9482CA7E62;
        Sat, 26 Oct 2019 13:47:56 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 26 Oct 2019 13:47:56 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 6566642EE393;
        Sat, 26 Oct 2019 13:47:56 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 31/31] netfilter: nf_tables_offload: unbind if multi-device binding fails
Date:   Sat, 26 Oct 2019 13:47:33 +0200
Message-Id: <20191026114733.28111-32-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191026114733.28111-1-pablo@netfilter.org>
References: <20191026114733.28111-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

nft_flow_block_chain() needs to unbind in case of error when performing
the multi-device binding.

Fixes: d54725cd11a5 ("netfilter: nf_tables: support for multiple devices per netdev hook")
Reported-by: wenxu <wenxu@ucloud.cn>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_offload.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index d51728affa1c..4e0625cce647 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -336,7 +336,7 @@ static int nft_flow_block_chain(struct nft_base_chain *basechain,
 {
 	struct net_device *dev;
 	struct nft_hook *hook;
-	int err;
+	int err, i = 0;
 
 	list_for_each_entry(hook, &basechain->hook_list, list) {
 		dev = hook->ops.dev;
@@ -344,11 +344,26 @@ static int nft_flow_block_chain(struct nft_base_chain *basechain,
 			continue;
 
 		err = nft_chain_offload_cmd(basechain, dev, cmd);
-		if (err < 0)
+		if (err < 0 && cmd == FLOW_BLOCK_BIND) {
+			if (!this_dev)
+				goto err_flow_block;
+
 			return err;
+		}
+		i++;
 	}
 
 	return 0;
+
+err_flow_block:
+	list_for_each_entry(hook, &basechain->hook_list, list) {
+		if (i-- <= 0)
+			break;
+
+		dev = hook->ops.dev;
+		nft_chain_offload_cmd(basechain, dev, FLOW_BLOCK_UNBIND);
+	}
+	return err;
 }
 
 static int nft_flow_offload_chain(struct nft_chain *chain, u8 *ppolicy,
-- 
2.11.0

