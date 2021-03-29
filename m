Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2BAFC4345E
	for <netfilter-devel@archiver.kernel.org>; Mon, 29 Mar 2021 22:23:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F091619CB
	for <netfilter-devel@archiver.kernel.org>; Mon, 29 Mar 2021 22:23:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232548AbhC2WXe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 29 Mar 2021 18:23:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:46676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232206AbhC2WWn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 29 Mar 2021 18:22:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6DD556198A;
        Mon, 29 Mar 2021 22:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617056563;
        bh=WeCqoMtzzNqkQFb+joPv1F5Ej/xZckEs/fHa+sqHqqI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RAtyZ2vuua8xAg5cSCcY/MxizkNpng+yPoBd8cgtvMnqd3TSKp2JqiGN9NVoDOQmp
         dhzUp7xQ3sW0T7w/AdC4APO89U+aad+rPdhjr533aQ2SviIn4YTUlH8JNGFITCbYBo
         16Gd4LalW+vzPsmoTP5inqyzpPdVo7C4u7GF4OJx2O+R4WjB7EjXlJQDB9azEa3Jze
         2+JzLT6+hfpqZ4O2UkW6Sxv+xuHEIlPm0aVT7NMFT4bzDz1dvlRDoCjK0PlLCXMO+f
         HyTYj0o+aTki96s1+mg0f6BaZ1LfZMHheqon0fBQOspceeMcE/6gie42+I7Fw7vnzC
         LnIkQ5qx/YqxA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 17/33] netfilter: nftables: skip hook overlap logic if flowtable is stale
Date:   Mon, 29 Mar 2021 18:22:05 -0400
Message-Id: <20210329222222.2382987-17-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210329222222.2382987-1-sashal@kernel.org>
References: <20210329222222.2382987-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 86fe2c19eec4728fd9a42ba18f3b47f0d5f9fd7c ]

If the flowtable has been previously removed in this batch, skip the
hook overlap checks. This fixes spurious EEXIST errors when removing and
adding the flowtable in the same batch.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 8739ef135156..8b474559f1be 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6573,6 +6573,9 @@ static int nft_register_flowtable_net_hooks(struct net *net,
 
 	list_for_each_entry(hook, hook_list, list) {
 		list_for_each_entry(ft, &table->flowtables, list) {
+			if (!nft_is_active_next(net, ft))
+				continue;
+
 			list_for_each_entry(hook2, &ft->hook_list, list) {
 				if (hook->ops.dev == hook2->ops.dev &&
 				    hook->ops.pf == hook2->ops.pf) {
-- 
2.30.1

