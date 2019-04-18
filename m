Return-Path: <SRS0=/8pw=SU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 859EBC10F0E
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Apr 2019 17:01:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5D7492171F
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Apr 2019 17:01:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389725AbfDRRBE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 18 Apr 2019 13:01:04 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44686 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388299AbfDRRBD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 18 Apr 2019 13:01:03 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1hHAPA-0004Wa-I8; Thu, 18 Apr 2019 17:00:56 +0000
From:   Colin King <colin.king@canonical.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S . Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] netfilter: connlabels: fix spelling mistake "trackling" -> "tracking"
Date:   Thu, 18 Apr 2019 18:00:56 +0100
Message-Id: <20190418170056.22486-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There is a spelling mistake in the module description. Fix this.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 net/netfilter/xt_connlabel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/xt_connlabel.c b/net/netfilter/xt_connlabel.c
index 4fa4efd24353..893374ac3758 100644
--- a/net/netfilter/xt_connlabel.c
+++ b/net/netfilter/xt_connlabel.c
@@ -15,7 +15,7 @@
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Florian Westphal <fw@strlen.de>");
-MODULE_DESCRIPTION("Xtables: add/match connection trackling labels");
+MODULE_DESCRIPTION("Xtables: add/match connection tracking labels");
 MODULE_ALIAS("ipt_connlabel");
 MODULE_ALIAS("ip6t_connlabel");
 
-- 
2.20.1

