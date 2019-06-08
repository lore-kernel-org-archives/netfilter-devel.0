Return-Path: <SRS0=8SyO=UH=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,T_DKIMWL_WL_HIGH,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B32D9C28CC5
	for <netfilter-devel@archiver.kernel.org>; Sat,  8 Jun 2019 11:40:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 89CA9208C0
	for <netfilter-devel@archiver.kernel.org>; Sat,  8 Jun 2019 11:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1559994008;
	bh=h+QUakoU+HdW32HnreeJ/QiRKJe0ncSfFd/UrRS5s2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=fgoJ2fXT1+FTY7Z1NqwP73tYfcA+TJTYy5dtXKy2nx3LNUZEWqUYBSOMm16zAOVag
	 vmfzwGAyMHpS0CFUaEonz53Pe4cCq9XQXT70crI8bmY8chdX3rwugUGP/QbcBXVEaD
	 BFPckOt9bH5bbLra6dvMyKTeVri7yxpOCW+hxMHk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727290AbfFHLkH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 8 Jun 2019 07:40:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:57182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727266AbfFHLkG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 8 Jun 2019 07:40:06 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 37B03214DA;
        Sat,  8 Jun 2019 11:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559994005;
        bh=h+QUakoU+HdW32HnreeJ/QiRKJe0ncSfFd/UrRS5s2I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c/giqCMPnnnt/KKwG2/Eo6nf5fNEjahXmrO08J8YvDYe0V0LqxaXwdAElES9aiFHW
         cvcP+fiy5CMkTHIOrXQ5OA6If+vFa8phiNLc1uAPTeNZ4hjzzTWArx29YCWskjhSZ3
         1e1rq5gXKz1367P2KorBgIESba7kJ3u1qp4TbpiQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jagdish Motwani <jagdish.motwani@sophos.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 11/70] netfilter: nf_queue: fix reinject verdict handling
Date:   Sat,  8 Jun 2019 07:38:50 -0400
Message-Id: <20190608113950.8033-11-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190608113950.8033-1-sashal@kernel.org>
References: <20190608113950.8033-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Jagdish Motwani <jagdish.motwani@sophos.com>

[ Upstream commit 946c0d8e6ed43dae6527e878d0077c1e11015db0 ]

This patch fixes netfilter hook traversal when there are more than 1 hooks
returning NF_QUEUE verdict. When the first queue reinjects the packet,
'nf_reinject' starts traversing hooks with a proper hook_index. However,
if it again receives a NF_QUEUE verdict (by some other netfilter hook), it
queues the packet with a wrong hook_index. So, when the second queue
reinjects the packet, it re-executes hooks in between.

Fixes: 960632ece694 ("netfilter: convert hook list to an array")
Signed-off-by: Jagdish Motwani <jagdish.motwani@sophos.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_queue.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index a36a77bae1d6..5b86574e7b89 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -254,6 +254,7 @@ static unsigned int nf_iterate(struct sk_buff *skb,
 repeat:
 		verdict = nf_hook_entry_hookfn(hook, skb, state);
 		if (verdict != NF_ACCEPT) {
+			*index = i;
 			if (verdict != NF_REPEAT)
 				return verdict;
 			goto repeat;
-- 
2.20.1

