Return-Path: <SRS0=+tY6=XU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3169C432C2
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Sep 2019 20:30:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 804B921D7A
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Sep 2019 20:30:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393103AbfIYUaZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 25 Sep 2019 16:30:25 -0400
Received: from correo.us.es ([193.147.175.20]:44662 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393054AbfIYUaY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 25 Sep 2019 16:30:24 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A43C8C515C
        for <netfilter-devel@vger.kernel.org>; Wed, 25 Sep 2019 22:30:16 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9424CA7D67
        for <netfilter-devel@vger.kernel.org>; Wed, 25 Sep 2019 22:30:16 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 766AFB8009; Wed, 25 Sep 2019 22:30:16 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 65D0AA7DAB;
        Wed, 25 Sep 2019 22:30:14 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 25 Sep 2019 22:30:14 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 305724265A5A;
        Wed, 25 Sep 2019 22:30:14 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 2/5] netfilter: nf_tables_offload: fix always true policy is unset check
Date:   Wed, 25 Sep 2019 22:30:00 +0200
Message-Id: <20190925203003.20112-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190925203003.20112-1-pablo@netfilter.org>
References: <20190925203003.20112-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

New smatch warnings:
net/netfilter/nf_tables_offload.c:316 nft_flow_offload_chain() warn: always true condition '(policy != -1) => (0-255 != (-1))'

Reported-by: kbuild test robot <lkp@intel.com>
Fixes: c9626a2cbdb2 ("netfilter: nf_tables: add hardware offload support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_offload.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index 21bb772cb4b7..e546f759b7a7 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -313,7 +313,7 @@ static int nft_flow_offload_chain(struct nft_chain *chain,
 	policy = ppolicy ? *ppolicy : basechain->policy;
 
 	/* Only default policy to accept is supported for now. */
-	if (cmd == FLOW_BLOCK_BIND && policy != -1 && policy != NF_ACCEPT)
+	if (cmd == FLOW_BLOCK_BIND && policy == NF_DROP)
 		return -EOPNOTSUPP;
 
 	if (dev->netdev_ops->ndo_setup_tc)
-- 
2.11.0

