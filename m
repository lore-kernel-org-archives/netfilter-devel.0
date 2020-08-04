Return-Path: <SRS0=6lPY=BO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0E17C433E3
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 Aug 2020 20:02:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A30E920842
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 Aug 2020 20:02:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726630AbgHDUCp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 4 Aug 2020 16:02:45 -0400
Received: from correo.us.es ([193.147.175.20]:49412 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726472AbgHDUCo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 4 Aug 2020 16:02:44 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C9434DA7F1
        for <netfilter-devel@vger.kernel.org>; Tue,  4 Aug 2020 22:02:42 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B3AB1DA855
        for <netfilter-devel@vger.kernel.org>; Tue,  4 Aug 2020 22:02:42 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A896CDA852; Tue,  4 Aug 2020 22:02:42 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 94991DA73F;
        Tue,  4 Aug 2020 22:02:40 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 04 Aug 2020 22:02:40 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (120.205.137.78.rev.vodafone.pt [78.137.205.120])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id BA97E4265A32;
        Tue,  4 Aug 2020 22:02:39 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 2/5] netfilter: nft_meta: fix iifgroup matching
Date:   Tue,  4 Aug 2020 22:02:05 +0200
Message-Id: <20200804200208.18620-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200804200208.18620-1-pablo@netfilter.org>
References: <20200804200208.18620-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

iifgroup matching erroneously checks the output interface.

Fixes: 8724e819cc9a ("netfilter: nft_meta: move all interface related keys to helper")
Reported-by: Demi M. Obenour <demiobenour@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_meta.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 951b6e87ed5d..7bc6537f3ccb 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -253,7 +253,7 @@ static bool nft_meta_get_eval_ifname(enum nft_meta_keys key, u32 *dest,
 			return false;
 		break;
 	case NFT_META_IIFGROUP:
-		if (!nft_meta_store_ifgroup(dest, nft_out(pkt)))
+		if (!nft_meta_store_ifgroup(dest, nft_in(pkt)))
 			return false;
 		break;
 	case NFT_META_OIFGROUP:
-- 
2.20.1

