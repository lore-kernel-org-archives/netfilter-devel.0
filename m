Return-Path: <SRS0=PuwI=UG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4811DC2BCA1
	for <netfilter-devel@archiver.kernel.org>; Fri,  7 Jun 2019 09:13:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 225D920B7C
	for <netfilter-devel@archiver.kernel.org>; Fri,  7 Jun 2019 09:13:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727102AbfFGJM7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 7 Jun 2019 05:12:59 -0400
Received: from mail.us.es ([193.147.175.20]:36940 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726531AbfFGJM7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 7 Jun 2019 05:12:59 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6147BBAE91
        for <netfilter-devel@vger.kernel.org>; Fri,  7 Jun 2019 11:12:57 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 51738DA711
        for <netfilter-devel@vger.kernel.org>; Fri,  7 Jun 2019 11:12:57 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 4685EDA701; Fri,  7 Jun 2019 11:12:57 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4BFBBDA70B;
        Fri,  7 Jun 2019 11:12:55 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 07 Jun 2019 11:12:55 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 196284265A5B;
        Fri,  7 Jun 2019 11:12:55 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     phil@nwl.cc, fw@strlen.de
Subject: [PATCH nft 2/2,v2] rule: ensure cache consistency
Date:   Fri,  7 Jun 2019 11:12:49 +0200
Message-Id: <20190607091249.12276-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190607091249.12276-1-pablo@netfilter.org>
References: <20190607091249.12276-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Check for generation ID after the cache is populated. In case of
interference, release the inconsistent cache and retry.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: rebase on top of "32-bit long generation ID" patch.

 src/rule.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/src/rule.c b/src/rule.c
index 651454733bed..e570238a40f5 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -251,7 +251,7 @@ int cache_update(struct nft_ctx *nft, enum cmd_ops cmd, struct list_head *msgs)
 		.nft		= nft,
 	};
 	struct nft_cache *cache = &nft->cache;
-	uint32_t genid;
+	uint32_t genid, genid_stop;
 	int ret;
 replay:
 	ctx.seqnum = cache->seqnum++;
@@ -272,6 +272,13 @@ replay:
 		}
 		return -1;
 	}
+
+	genid_stop = mnl_genid_get(&ctx);
+	if (genid != genid_stop) {
+		cache_release(cache);
+		goto replay;
+	}
+
 	cache->genid = genid;
 	cache->cmd = cmd;
 	return 0;
-- 
2.11.0

