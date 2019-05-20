Return-Path: <SRS0=v9tr=TU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A22AFC04AAF
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 May 2019 14:41:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 79338216FD
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 May 2019 14:41:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389638AbfETOl0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 20 May 2019 10:41:26 -0400
Received: from mail.us.es ([193.147.175.20]:37356 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388978AbfETOlZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 May 2019 10:41:25 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2B6DDC1A67
        for <netfilter-devel@vger.kernel.org>; Mon, 20 May 2019 16:41:23 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1CA7DDA70C
        for <netfilter-devel@vger.kernel.org>; Mon, 20 May 2019 16:41:23 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 1B0F9DA70B; Mon, 20 May 2019 16:41:23 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1B118DA704;
        Mon, 20 May 2019 16:41:21 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 20 May 2019 16:41:21 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id DDFA94265A32;
        Mon, 20 May 2019 16:41:20 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de, phil@nwl.cc
Subject: [PATCH iptables RFC 3/4] nft: don't skip table addition from ERESTART
Date:   Mon, 20 May 2019 16:41:14 +0200
Message-Id: <20190520144115.29732-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190520144115.29732-1-pablo@netfilter.org>
References: <20190520144115.29732-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

I don't find a scenario that trigger this case.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 iptables/nft.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index a03a84c9a6d1..c1a079b734cf 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -2787,15 +2787,6 @@ static void nft_refresh_transaction(struct nft_handle *h)
 			else if (!n->skip && !exists)
 				n->skip = 1;
 			break;
-		case NFT_COMPAT_TABLE_ADD:
-			tablename = nftnl_table_get_str(n->table, NFTNL_TABLE_NAME);
-			if (!tablename)
-				continue;
-
-			exists = nft_table_find(h, tablename);
-			if (n->skip && !exists)
-				n->skip = 0;
-			break;
 		case NFT_COMPAT_CHAIN_USER_ADD:
 			tablename = nftnl_chain_get_str(n->chain, NFTNL_CHAIN_TABLE);
 			if (!tablename)
@@ -2815,6 +2806,7 @@ static void nft_refresh_transaction(struct nft_handle *h)
 				n->skip = 0;
 			}
 			break;
+		case NFT_COMPAT_TABLE_ADD:
 		case NFT_COMPAT_CHAIN_ADD:
 		case NFT_COMPAT_CHAIN_ZERO:
 		case NFT_COMPAT_CHAIN_USER_DEL:
-- 
2.11.0

