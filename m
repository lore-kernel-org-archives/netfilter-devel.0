Return-Path: <SRS0=/ozj=TY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D95E4C072B5
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 May 2019 20:26:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA60E20868
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 May 2019 20:26:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404162AbfEXU0m (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 24 May 2019 16:26:42 -0400
Received: from mail.us.es ([193.147.175.20]:37532 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404009AbfEXU0l (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 May 2019 16:26:41 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E55AEF2808
        for <netfilter-devel@vger.kernel.org>; Fri, 24 May 2019 22:26:39 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D9D71DA704
        for <netfilter-devel@vger.kernel.org>; Fri, 24 May 2019 22:26:39 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id CF526DA703; Fri, 24 May 2019 22:26:39 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A3DBBDA701;
        Fri, 24 May 2019 22:26:37 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 24 May 2019 22:26:37 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [31.4.219.201])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 617444265A32;
        Fri, 24 May 2019 22:26:37 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de
Subject: [PATCH nf] netfilter: nf_tables: fix module autoload with inet family
Date:   Fri, 24 May 2019 22:26:34 +0200
Message-Id: <20190524202634.24814-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Use MODULE_ALIAS_NFT_EXPR() to make happy the inet family with nat.

Fixes: 63ce3940f3ab ("netfilter: nft_redir: add inet support")
Fixes: 071657d2c38c ("netfilter: nft_masq: add inet support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_masq.c  | 3 +--
 net/netfilter/nft_redir.c | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nft_masq.c b/net/netfilter/nft_masq.c
index 86fd90085eaf..8c1612d6bc2c 100644
--- a/net/netfilter/nft_masq.c
+++ b/net/netfilter/nft_masq.c
@@ -307,5 +307,4 @@ module_exit(nft_masq_module_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Arturo Borrero Gonzalez <arturo@debian.org>");
-MODULE_ALIAS_NFT_AF_EXPR(AF_INET6, "masq");
-MODULE_ALIAS_NFT_AF_EXPR(AF_INET, "masq");
+MODULE_ALIAS_NFT_EXPR("masq");
diff --git a/net/netfilter/nft_redir.c b/net/netfilter/nft_redir.c
index da74fdc4a684..8787e9f8ed71 100644
--- a/net/netfilter/nft_redir.c
+++ b/net/netfilter/nft_redir.c
@@ -294,5 +294,4 @@ module_exit(nft_redir_module_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Arturo Borrero Gonzalez <arturo@debian.org>");
-MODULE_ALIAS_NFT_AF_EXPR(AF_INET, "redir");
-MODULE_ALIAS_NFT_AF_EXPR(AF_INET6, "redir");
+MODULE_ALIAS_NFT_EXPR("nat");
-- 
2.11.0


