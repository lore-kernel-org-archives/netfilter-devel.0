Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CA0BC433DB
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Jan 2021 13:29:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5259E207B3
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Jan 2021 13:29:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238350AbhA0N3B (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Jan 2021 08:29:01 -0500
Received: from correo.us.es ([193.147.175.20]:40286 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238387AbhA0N0F (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Jan 2021 08:26:05 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8167F2A2BA5
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Jan 2021 14:24:22 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 74A24DA793
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Jan 2021 14:24:22 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 6A349DA78E; Wed, 27 Jan 2021 14:24:22 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 41D47DA722;
        Wed, 27 Jan 2021 14:24:20 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 27 Jan 2021 14:24:20 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 159F5426CC84;
        Wed, 27 Jan 2021 14:24:20 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 2/3] netfilter: nft_dynset: add timeout extension to template
Date:   Wed, 27 Jan 2021 14:25:11 +0100
Message-Id: <20210127132512.5472-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210127132512.5472-1-pablo@netfilter.org>
References: <20210127132512.5472-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Otherwise, the newly create element shows no timeout when listing the
ruleset. If the set definition does not specify a default timeout, then
the set element only shows the expiration time, but not the timeout.
This is a problem when restoring a stateful ruleset listing since it
skips the timeout policy entirely.

Fixes: 22fe54d5fefc ("netfilter: nf_tables: add support for dynamic set updates")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_dynset.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index 86204740f6c7..218c09e4fddd 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -312,8 +312,10 @@ static int nft_dynset_init(const struct nft_ctx *ctx,
 		nft_dynset_ext_add_expr(priv);
 
 	if (set->flags & NFT_SET_TIMEOUT) {
-		if (timeout || set->timeout)
+		if (timeout || set->timeout) {
+			nft_set_ext_add(&priv->tmpl, NFT_SET_EXT_TIMEOUT);
 			nft_set_ext_add(&priv->tmpl, NFT_SET_EXT_EXPIRATION);
+		}
 	}
 
 	priv->timeout = timeout;
-- 
2.20.1

