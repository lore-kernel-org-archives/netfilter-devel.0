Return-Path: <SRS0=VHt6=ID=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DB27C433E0
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 Mar 2021 19:38:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E54465074
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 Mar 2021 19:38:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229446AbhCETiD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 5 Mar 2021 14:38:03 -0500
Received: from correo.us.es ([193.147.175.20]:33150 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229642AbhCETh5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 5 Mar 2021 14:37:57 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9A753D28C1
        for <netfilter-devel@vger.kernel.org>; Fri,  5 Mar 2021 20:37:46 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8583BDA730
        for <netfilter-devel@vger.kernel.org>; Fri,  5 Mar 2021 20:37:46 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 7A741DA789; Fri,  5 Mar 2021 20:37:46 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 296F0DA730
        for <netfilter-devel@vger.kernel.org>; Fri,  5 Mar 2021 20:37:44 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 05 Mar 2021 20:37:44 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 1671542DC703
        for <netfilter-devel@vger.kernel.org>; Fri,  5 Mar 2021 20:37:44 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] expression: memleak in verdict_expr_parse_udata()
Date:   Fri,  5 Mar 2021 20:37:31 +0100
Message-Id: <20210305193731.1754-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Remove unnecessary verdict_expr_alloc() invocation.

Fixes: 4ab1e5e60779 ("src: allow use of 'verdict' in typeof definitions")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/expression.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/expression.c b/src/expression.c
index 8c6beef9a5e5..0c5276d1118d 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -260,7 +260,7 @@ static int verdict_expr_build_udata(struct nftnl_udata_buf *udbuf,
 
 static struct expr *verdict_expr_parse_udata(const struct nftnl_udata *attr)
 {
-	struct expr *e = verdict_expr_alloc(&internal_location, 0, NULL);
+	struct expr *e;
 
 	e = symbol_expr_alloc(&internal_location, SYMBOL_VALUE, NULL, "verdict");
 	e->len = NFT_REG_SIZE * BITS_PER_BYTE;
-- 
2.20.1

