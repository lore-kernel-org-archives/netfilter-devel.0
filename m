Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7C02C2BBD4
	for <netfilter-devel@archiver.kernel.org>; Fri, 18 Dec 2020 12:05:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B45D723A51
	for <netfilter-devel@archiver.kernel.org>; Fri, 18 Dec 2020 12:05:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726564AbgLRMFF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 18 Dec 2020 07:05:05 -0500
Received: from correo.us.es ([193.147.175.20]:51934 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726545AbgLRMFA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 18 Dec 2020 07:05:00 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E7A9DEB470
        for <netfilter-devel@vger.kernel.org>; Fri, 18 Dec 2020 13:03:59 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D9AC8DA844
        for <netfilter-devel@vger.kernel.org>; Fri, 18 Dec 2020 13:03:59 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D6179DA853; Fri, 18 Dec 2020 13:03:59 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id ACC0DDA722;
        Fri, 18 Dec 2020 13:03:57 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 18 Dec 2020 13:03:57 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 7DC0D42DF562;
        Fri, 18 Dec 2020 13:03:57 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 1/4] netfilter: nftables: fix incorrect increment of loop counter
Date:   Fri, 18 Dec 2020 13:04:06 +0100
Message-Id: <20201218120409.3659-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201218120409.3659-1-pablo@netfilter.org>
References: <20201218120409.3659-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The intention of the err_expr cleanup path is to iterate over the
allocated expr_array objects and free them, starting from i - 1 and
working down to the start of the array. Currently the loop counter
is being incremented instead of decremented and also the index i is
being used instead of k, repeatedly destroying the same expr_array
element.  Fix this by decrementing k and using k as the index into
expr_array.

Addresses-Coverity: ("Infinite loop")
Fixes: 8cfd9b0f8515 ("netfilter: nftables: generalize set expressions support")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 8d5aa0ac45f4..4186b1e52d58 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5254,8 +5254,8 @@ static int nft_set_elem_expr_clone(const struct nft_ctx *ctx,
 	return 0;
 
 err_expr:
-	for (k = i - 1; k >= 0; k++)
-		nft_expr_destroy(ctx, expr_array[i]);
+	for (k = i - 1; k >= 0; k--)
+		nft_expr_destroy(ctx, expr_array[k]);
 
 	return -ENOMEM;
 }
-- 
2.20.1

