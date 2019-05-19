Return-Path: <SRS0=6IYx=TT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EB8DC04AB4
	for <netfilter-devel@archiver.kernel.org>; Sun, 19 May 2019 17:48:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 70C2720449
	for <netfilter-devel@archiver.kernel.org>; Sun, 19 May 2019 17:48:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727682AbfESRsd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 19 May 2019 13:48:33 -0400
Received: from mail.us.es ([193.147.175.20]:42146 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727519AbfESRsc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 19 May 2019 13:48:32 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 80607C4148
        for <netfilter-devel@vger.kernel.org>; Sun, 19 May 2019 13:51:27 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 734A3DA708
        for <netfilter-devel@vger.kernel.org>; Sun, 19 May 2019 13:51:27 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 6613ADA705; Sun, 19 May 2019 13:51:27 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 77577DA703;
        Sun, 19 May 2019 13:51:25 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 19 May 2019 13:51:25 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 4402A4265A32;
        Sun, 19 May 2019 13:51:25 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     phil@nwl.cc, fw@strlen.de
Subject: [PATCH iptables 2/4] nft: statify nft_rebuild_cache()
Date:   Sun, 19 May 2019 13:51:19 +0200
Message-Id: <20190519115121.32490-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190519115121.32490-1-pablo@netfilter.org>
References: <20190519115121.32490-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 iptables/nft.c | 2 +-
 iptables/nft.h | 1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index d78c431703ca..c5ddde5f0064 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1542,7 +1542,7 @@ void nft_build_cache(struct nft_handle *h)
 		__nft_build_cache(h);
 }
 
-void nft_rebuild_cache(struct nft_handle *h)
+static void nft_rebuild_cache(struct nft_handle *h)
 {
 	if (!h->have_cache)
 		flush_chain_cache(h, NULL);
diff --git a/iptables/nft.h b/iptables/nft.h
index 4c207a433820..40da8064b742 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -69,7 +69,6 @@ int mnl_talk(struct nft_handle *h, struct nlmsghdr *nlh,
 int nft_init(struct nft_handle *h, const struct builtin_table *t);
 void nft_fini(struct nft_handle *h);
 void nft_build_cache(struct nft_handle *h);
-void nft_rebuild_cache(struct nft_handle *h);
 
 /*
  * Operations with tables.
-- 
2.11.0

