Return-Path: <SRS0=F0cc=5M=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55352C43331
	for <netfilter-devel@archiver.kernel.org>; Fri, 27 Mar 2020 16:43:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1FDFA20737
	for <netfilter-devel@archiver.kernel.org>; Fri, 27 Mar 2020 16:43:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727606AbgC0QnM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 27 Mar 2020 12:43:12 -0400
Received: from correo.us.es ([193.147.175.20]:45964 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726540AbgC0QnM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 27 Mar 2020 12:43:12 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id F0187F2588
        for <netfilter-devel@vger.kernel.org>; Fri, 27 Mar 2020 17:43:10 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E3624DA3C4
        for <netfilter-devel@vger.kernel.org>; Fri, 27 Mar 2020 17:43:10 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D90E0DA3C2; Fri, 27 Mar 2020 17:43:10 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0F212DA72F
        for <netfilter-devel@vger.kernel.org>; Fri, 27 Mar 2020 17:43:09 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 27 Mar 2020 17:43:09 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id E878F42EE38E
        for <netfilter-devel@vger.kernel.org>; Fri, 27 Mar 2020 17:43:08 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 1/3] netfilter: nft_set_bitmap: initialize set element extension in lookups
Date:   Fri, 27 Mar 2020 17:43:04 +0100
Message-Id: <20200327164306.19324-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Otherwise, nft_lookup might dereference an uninitialized pointer to the
element extension.

Fixes: 665153ff5752 ("netfilter: nf_tables: add bitmap set type")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_set_bitmap.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nft_set_bitmap.c b/net/netfilter/nft_set_bitmap.c
index 1cb2e67e6e03..6829a497b4cc 100644
--- a/net/netfilter/nft_set_bitmap.c
+++ b/net/netfilter/nft_set_bitmap.c
@@ -81,6 +81,7 @@ static bool nft_bitmap_lookup(const struct net *net, const struct nft_set *set,
 	u32 idx, off;
 
 	nft_bitmap_location(set, key, &idx, &off);
+	*ext = NULL;
 
 	return nft_bitmap_active(priv->bitmap, idx, off, genmask);
 }
-- 
2.11.0

