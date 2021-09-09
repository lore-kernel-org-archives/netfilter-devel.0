Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0542DC433EF
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 Sep 2021 12:12:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB1F861132
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 Sep 2021 12:12:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242890AbhIIMNH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 9 Sep 2021 08:13:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:47660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351792AbhIIMKM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Sep 2021 08:10:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B1DA7619EB;
        Thu,  9 Sep 2021 11:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188101;
        bh=ZSD/t6GBczhauPcf8YTa/40vg1sr0JwCZIBauU0hziI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GVSf8xUgXJ0KeZT4rMHMCGdaa0HIC1i7+rtviHV3bvucrdmuEikMH5JrRxFMiLidO
         pU27E8qX8R7qude9jcV5VJsLllHYMhzfPr2smVbmL56Nm4kR9RClCV20LwWmG04J21
         jPWYSh0s4ytfSPoflzq/488EUJT40Bq4QGfJwYMTm/M3a8xAMQs58VyamWkkojPlaN
         qI0aUAlRy+xJAntIWtFHapOutnfuYckX4GdL9PPIUwVYdkMv+WzIMW8EdVqfPCkpcx
         8MTMdFY/u5yVQynEVhOfPjArAo2Uc+f5C66g0ab8/pwYg5LqrgaGVBL2fdt5j+7TNc
         RlbQB7lu8Gu7A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Yajun Deng <yajun.deng@linux.dev>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 082/219] netfilter: nft_compat: use nfnetlink_unicast()
Date:   Thu,  9 Sep 2021 07:44:18 -0400
Message-Id: <20210909114635.143983-82-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114635.143983-1-sashal@kernel.org>
References: <20210909114635.143983-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 241d1af4c11a75d4c17ecc0193a6ab60553efbfc ]

Use nfnetlink_unicast() which already translates EAGAIN to ENOBUFS,
since EAGAIN is reserved to report missing module dependencies to the
nfnetlink core.

e0241ae6ac59 ("netfilter: use nfnetlink_unicast() forgot to update
this spot.

Reported-by: Yajun Deng <yajun.deng@linux.dev>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_compat.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index 5415ab14400d..31e6da30da5f 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -680,14 +680,12 @@ static int nfnl_compat_get_rcu(struct sk_buff *skb,
 		goto out_put;
 	}
 
-	ret = netlink_unicast(info->sk, skb2, NETLINK_CB(skb).portid,
-			      MSG_DONTWAIT);
-	if (ret > 0)
-		ret = 0;
+	ret = nfnetlink_unicast(skb2, info->net, NETLINK_CB(skb).portid);
 out_put:
 	rcu_read_lock();
 	module_put(THIS_MODULE);
-	return ret == -EAGAIN ? -ENOBUFS : ret;
+
+	return ret;
 }
 
 static const struct nla_policy nfnl_compat_policy_get[NFTA_COMPAT_MAX+1] = {
-- 
2.30.2

