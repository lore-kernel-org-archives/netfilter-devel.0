Return-Path: <SRS0=r9U9=2U=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 600FBC2D0CE
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Dec 2019 11:22:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3F77B206E4
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Dec 2019 11:22:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727426AbfL3LW0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 30 Dec 2019 06:22:26 -0500
Received: from correo.us.es ([193.147.175.20]:59226 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727444AbfL3LWC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 30 Dec 2019 06:22:02 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id DD3F54DE746
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Dec 2019 12:21:59 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CF8DEDA737
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Dec 2019 12:21:59 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C4FC6DA707; Mon, 30 Dec 2019 12:21:59 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B9E2BDA70E;
        Mon, 30 Dec 2019 12:21:57 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 30 Dec 2019 12:21:57 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [185.124.28.61])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 3E24A41E4800;
        Mon, 30 Dec 2019 12:21:57 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 09/17] netfilter: nft_meta: move time handling to helper
Date:   Mon, 30 Dec 2019 12:21:35 +0100
Message-Id: <20191230112143.121708-10-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191230112143.121708-1-pablo@netfilter.org>
References: <20191230112143.121708-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

reduce size of the (large) meta evaluation function.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_meta.c | 28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 9740b554fdb3..ba74f3ee7264 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -33,8 +33,9 @@
 
 static DEFINE_PER_CPU(struct rnd_state, nft_prandom_state);
 
-static u8 nft_meta_weekday(time64_t secs)
+static u8 nft_meta_weekday(void)
 {
+	time64_t secs = ktime_get_real_seconds();
 	unsigned int dse;
 	u8 wday;
 
@@ -56,6 +57,25 @@ static u32 nft_meta_hour(time64_t secs)
 		+ tm.tm_sec;
 }
 
+static noinline_for_stack void
+nft_meta_get_eval_time(enum nft_meta_keys key,
+		       u32 *dest)
+{
+	switch (key) {
+	case NFT_META_TIME_NS:
+		nft_reg_store64(dest, ktime_get_real_ns());
+		break;
+	case NFT_META_TIME_DAY:
+		nft_reg_store8(dest, nft_meta_weekday());
+		break;
+	case NFT_META_TIME_HOUR:
+		*dest = nft_meta_hour(ktime_get_real_seconds());
+		break;
+	default:
+		break;
+	}
+}
+
 void nft_meta_get_eval(const struct nft_expr *expr,
 		       struct nft_regs *regs,
 		       const struct nft_pktinfo *pkt)
@@ -247,13 +267,9 @@ void nft_meta_get_eval(const struct nft_expr *expr,
 		strncpy((char *)dest, out->rtnl_link_ops->kind, IFNAMSIZ);
 		break;
 	case NFT_META_TIME_NS:
-		nft_reg_store64(dest, ktime_get_real_ns());
-		break;
 	case NFT_META_TIME_DAY:
-		nft_reg_store8(dest, nft_meta_weekday(ktime_get_real_seconds()));
-		break;
 	case NFT_META_TIME_HOUR:
-		*dest = nft_meta_hour(ktime_get_real_seconds());
+		nft_meta_get_eval_time(priv->key, dest);
 		break;
 	default:
 		WARN_ON(1);
-- 
2.11.0

