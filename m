Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3B46C47080
	for <netfilter-devel@archiver.kernel.org>; Tue,  1 Jun 2021 22:06:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CFDB061396
	for <netfilter-devel@archiver.kernel.org>; Tue,  1 Jun 2021 22:06:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234985AbhFAWI1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 1 Jun 2021 18:08:27 -0400
Received: from mail.netfilter.org ([217.70.188.207]:39566 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234950AbhFAWIV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 1 Jun 2021 18:08:21 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id A2AFF64175;
        Wed,  2 Jun 2021 00:05:32 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 10/16] netfilter: reduce size of nf_hook_state on 32bit platforms
Date:   Wed,  2 Jun 2021 00:06:23 +0200
Message-Id: <20210601220629.18307-11-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210601220629.18307-1-pablo@netfilter.org>
References: <20210601220629.18307-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Reduce size from 28 to 24 bytes on 32bit platforms.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index f0f3a8354c3c..f161569fbe2f 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -65,8 +65,8 @@ struct nf_hook_ops;
 struct sock;
 
 struct nf_hook_state {
-	unsigned int hook;
-	u_int8_t pf;
+	u8 hook;
+	u8 pf;
 	struct net_device *in;
 	struct net_device *out;
 	struct sock *sk;
-- 
2.30.2

