Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BFE9C4320A
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Aug 2021 09:39:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 20E1061040
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Aug 2021 09:39:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235807AbhH3JkO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 30 Aug 2021 05:40:14 -0400
Received: from mail.netfilter.org ([217.70.188.207]:42620 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236123AbhH3JkB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 30 Aug 2021 05:40:01 -0400
Received: from localhost.localdomain (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id 4517E600A1;
        Mon, 30 Aug 2021 11:38:08 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 7/8] netfilter: x_tables: handle xt_register_template() returning an error value
Date:   Mon, 30 Aug 2021 11:38:51 +0200
Message-Id: <20210830093852.21654-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210830093852.21654-1-pablo@netfilter.org>
References: <20210830093852.21654-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Lukas Bulwahn <lukas.bulwahn@gmail.com>

Commit fdacd57c79b7 ("netfilter: x_tables: never register tables by
default") introduces the function xt_register_template(), and in one case,
a call to that function was missing the error-case handling.

Handle when xt_register_template() returns an error value.

This was identified with the clang-analyzer's Dead-Store analysis.

Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/iptable_mangle.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv4/netfilter/iptable_mangle.c b/net/ipv4/netfilter/iptable_mangle.c
index b52a4c8a14fc..40417a3f930b 100644
--- a/net/ipv4/netfilter/iptable_mangle.c
+++ b/net/ipv4/netfilter/iptable_mangle.c
@@ -112,6 +112,8 @@ static int __init iptable_mangle_init(void)
 {
 	int ret = xt_register_template(&packet_mangler,
 				       iptable_mangle_table_init);
+	if (ret < 0)
+		return ret;
 
 	mangle_ops = xt_hook_ops_alloc(&packet_mangler, iptable_mangle_hook);
 	if (IS_ERR(mangle_ops)) {
-- 
2.20.1

