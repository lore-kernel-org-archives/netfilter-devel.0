Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED2B7C433B4
	for <netfilter-devel@archiver.kernel.org>; Wed, 31 Mar 2021 14:26:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B422B60FEF
	for <netfilter-devel@archiver.kernel.org>; Wed, 31 Mar 2021 14:26:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236056AbhCaO01 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 31 Mar 2021 10:26:27 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55598 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235890AbhCaO0K (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 31 Mar 2021 10:26:10 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1lRbnK-0008UR-IX; Wed, 31 Mar 2021 14:26:06 +0000
From:   Colin King <colin.king@canonical.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] netfilter: nf_log_bridge: Fix missing assignment of ret on a call to nf_log_register
Date:   Wed, 31 Mar 2021 15:26:06 +0100
Message-Id: <20210331142606.1422498-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Currently the call to nf_log_register is returning an error code that
is not being assigned to ret and yet ret is being checked. Fix this by
adding in the missing assignment.

Addresses-Coverity: ("Logically dead code")
Fixes: 8d02e7da87a0 ("netfilter: nf_log_bridge: merge with nf_log_syslog")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 net/netfilter/nf_log_syslog.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_log_syslog.c b/net/netfilter/nf_log_syslog.c
index 025ab9c66d13..2518818ed479 100644
--- a/net/netfilter/nf_log_syslog.c
+++ b/net/netfilter/nf_log_syslog.c
@@ -1042,7 +1042,7 @@ static int __init nf_log_syslog_init(void)
 	if (ret < 0)
 		goto err4;
 
-	nf_log_register(NFPROTO_BRIDGE, &nf_bridge_logger);
+	ret = nf_log_register(NFPROTO_BRIDGE, &nf_bridge_logger);
 	if (ret < 0)
 		goto err5;
 
-- 
2.30.2

