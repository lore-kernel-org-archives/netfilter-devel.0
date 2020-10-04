Return-Path: <SRS0=OxIk=DL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C344C4727D
	for <netfilter-devel@archiver.kernel.org>; Sun,  4 Oct 2020 19:50:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DAF872067D
	for <netfilter-devel@archiver.kernel.org>; Sun,  4 Oct 2020 19:50:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbgJDTuU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 4 Oct 2020 15:50:20 -0400
Received: from correo.us.es ([193.147.175.20]:34976 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726583AbgJDTuO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 4 Oct 2020 15:50:14 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id EE5B2EF42D
        for <netfilter-devel@vger.kernel.org>; Sun,  4 Oct 2020 21:50:11 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E197FDA704
        for <netfilter-devel@vger.kernel.org>; Sun,  4 Oct 2020 21:50:11 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E0D41DA78C; Sun,  4 Oct 2020 21:50:11 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id ACB86DA704;
        Sun,  4 Oct 2020 21:50:09 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 04 Oct 2020 21:50:09 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 800D742EF9E2;
        Sun,  4 Oct 2020 21:50:09 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 07/11] netfilter: nf_tables_offload: Remove unused macro FLOW_SETUP_BLOCK
Date:   Sun,  4 Oct 2020 21:49:36 +0200
Message-Id: <20201004194940.7368-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201004194940.7368-1-pablo@netfilter.org>
References: <20201004194940.7368-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

commit 9a32669fecfb ("netfilter: nf_tables_offload: support indr block call")
left behind this.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_offload.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index 9ef37c1b7b3b..7c7e06624dc3 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -323,8 +323,6 @@ static int nft_indr_block_offload_cmd(struct nft_base_chain *basechain,
 	return nft_block_setup(basechain, &bo, cmd);
 }
 
-#define FLOW_SETUP_BLOCK TC_SETUP_BLOCK
-
 static int nft_chain_offload_cmd(struct nft_base_chain *basechain,
 				 struct net_device *dev,
 				 enum flow_block_command cmd)
-- 
2.20.1

