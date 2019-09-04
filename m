Return-Path: <SRS0=dC0K=W7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB7C8C3A5A8
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Sep 2019 16:18:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8AB3D2053B
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Sep 2019 16:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1567613883;
	bh=hg3v9mNCEl88hPyO4T2hxcD97UjdZDKcsaSktvnl8vA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=MVoIos87X6BKFBLHAE1clyGT9zd98rhScsRQ3+wBr2jbka6ImhN9Arvp90S/o2Z/j
	 htQ+4WU6MsxZEDWVvsL3Wow7OU6M8QJtkdws4CDm5W4v4wbjma4cxHKvTY3FzYHPjZ
	 hP3U+wMKu5s8wHoaqzzjhtBP3RYSeprrkNghqCmY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732187AbfIDP67 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 4 Sep 2019 11:58:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:33182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732170AbfIDP66 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Sep 2019 11:58:58 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E2C0A2377B;
        Wed,  4 Sep 2019 15:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567612737;
        bh=hg3v9mNCEl88hPyO4T2hxcD97UjdZDKcsaSktvnl8vA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NL9qhQ2l9gQj1/YdGGGAswMh9omB5qQlUel54FkUkVirZ957Zqog4aXksHjSy3ool
         Mj4bND+3k7aiG5mnwh4OQWS7cmnrRnsr47VdQbodc1+6VEwqtSIqmk5aUIvlMU8S0g
         8cP/xPkO54X87Ii6zLrWh6KQqgHeJfU+0McfPYU0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Todd Seidelmann <tseidelmann@linode.com>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 51/94] netfilter: xt_physdev: Fix spurious error message in physdev_mt_check
Date:   Wed,  4 Sep 2019 11:56:56 -0400
Message-Id: <20190904155739.2816-51-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190904155739.2816-1-sashal@kernel.org>
References: <20190904155739.2816-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Todd Seidelmann <tseidelmann@linode.com>

[ Upstream commit 3cf2f450fff304be9cf4868bf0df17f253bc5b1c ]

Simplify the check in physdev_mt_check() to emit an error message
only when passed an invalid chain (ie, NF_INET_LOCAL_OUT).
This avoids cluttering up the log with errors against valid rules.

For large/heavily modified rulesets, current behavior can quickly
overwhelm the ring buffer, because this function gets called on
every change, regardless of the rule that was changed.

Signed-off-by: Todd Seidelmann <tseidelmann@linode.com>
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/xt_physdev.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/xt_physdev.c b/net/netfilter/xt_physdev.c
index ead7c60222086..b92b22ce8abd3 100644
--- a/net/netfilter/xt_physdev.c
+++ b/net/netfilter/xt_physdev.c
@@ -101,11 +101,9 @@ static int physdev_mt_check(const struct xt_mtchk_param *par)
 	if (info->bitmask & (XT_PHYSDEV_OP_OUT | XT_PHYSDEV_OP_ISOUT) &&
 	    (!(info->bitmask & XT_PHYSDEV_OP_BRIDGED) ||
 	     info->invert & XT_PHYSDEV_OP_BRIDGED) &&
-	    par->hook_mask & ((1 << NF_INET_LOCAL_OUT) |
-	    (1 << NF_INET_FORWARD) | (1 << NF_INET_POST_ROUTING))) {
+	    par->hook_mask & (1 << NF_INET_LOCAL_OUT)) {
 		pr_info_ratelimited("--physdev-out and --physdev-is-out only supported in the FORWARD and POSTROUTING chains with bridged traffic\n");
-		if (par->hook_mask & (1 << NF_INET_LOCAL_OUT))
-			return -EINVAL;
+		return -EINVAL;
 	}
 
 	if (!brnf_probed) {
-- 
2.20.1

