Return-Path: <SRS0=2e0L=2R=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11012C2D0DA
	for <netfilter-devel@archiver.kernel.org>; Fri, 27 Dec 2019 17:57:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D9D46206CB
	for <netfilter-devel@archiver.kernel.org>; Fri, 27 Dec 2019 17:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1577469456;
	bh=1TsBAZt0kGZestdFokrITKiGHIC4EGqDGcbQA7U+5uU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=llJStx3whjMahnj2rEuZ+44rzbb2HBfM/VoIchGMpe7vW/CQOYdP3f9Wh/1lrFyF0
	 n0PN3kmxKj1XlwDx5xleHBrZTHsyl2axONgfLrWb8spwnSS0th4fZ/mWToGTnt3OWT
	 6SnRbvN7SCU6fH11QpAeMB3Rjhm0V8ztguqf+ShU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727709AbfL0R5f (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 27 Dec 2019 12:57:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:38188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727570AbfL0Rlo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 27 Dec 2019 12:41:44 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D5BE42173E;
        Fri, 27 Dec 2019 17:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577468503;
        bh=1TsBAZt0kGZestdFokrITKiGHIC4EGqDGcbQA7U+5uU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=upiifxKDpBTsmHJp8+9npyp+geCT99PTIbix1KKUaM/YWe4OlCfqI0hmBvDg2NNm9
         QzAJa3u5j9ru70PTFv+bgSBKefQDldRxEi3CN4VOnKTVWURrFpmjnDrqpZ3bBk9Cob
         2dZm54uo1QDgFU/nNcR+sDP+akIBuA6jwkKPD1qk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 037/187] netfilter: nf_tables_offload: return EOPNOTSUPP if rule specifies no actions
Date:   Fri, 27 Dec 2019 12:38:25 -0500
Message-Id: <20191227174055.4923-37-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227174055.4923-1-sashal@kernel.org>
References: <20191227174055.4923-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 81ec61074bcf68acfcb2820cda3ff9d9984419c7 ]

If the rule only specifies the matching side, return EOPNOTSUPP.
Otherwise, the front-end relies on the drivers to reject this rule.

Fixes: c9626a2cbdb2 ("netfilter: nf_tables: add hardware offload support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_offload.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index 6f7eab502e65..e743f811245f 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -44,6 +44,9 @@ struct nft_flow_rule *nft_flow_rule_create(struct net *net,
 		expr = nft_expr_next(expr);
 	}
 
+	if (num_actions == 0)
+		return ERR_PTR(-EOPNOTSUPP);
+
 	flow = nft_flow_rule_alloc(num_actions);
 	if (!flow)
 		return ERR_PTR(-ENOMEM);
-- 
2.20.1

