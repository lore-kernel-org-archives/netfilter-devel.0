Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0D67C4167B
	for <netfilter-devel@archiver.kernel.org>; Sun, 29 Oct 2023 23:07:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231131AbjJ2XHi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 29 Oct 2023 19:07:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231918AbjJ2XHJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 29 Oct 2023 19:07:09 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A3A46582;
        Sun, 29 Oct 2023 16:01:07 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F422AC43395;
        Sun, 29 Oct 2023 22:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698620381;
        bh=+N35jTa3j/34Nak3qGch98N7yZ6gFUjg7X20O8fO5kw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PC4A39lNFQzeRcJVYRawMwjpeYazQfru5QCLXSyCJmUtVfiSRn0VQbENpOetLhZz0
         VcL0YY5nLdst7eYtRoxVsn3rsWqNfzZFEe/tk/co7mzSZZmF2G7YyLIe4W4bp65bdc
         IUk1epwFUoRwc/rUf8y5RoY20c2GOJNC5dQimYWNiRETKgOW00Aq+RRE1aWpnJorad
         Xy+LrMlfHSQD1ZU5dMu0Lij4LpDXfHJWnW/XTJ7MXwZnGE1D5innw5DRMFFsoUSAY3
         vu7vuBwOJl9+zlMOCARadA8OETY3ccQbE9C9a9SaIe5Atte18EOYchH05XNiI5Ihgf
         D8gSjrqTJh07w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>, kernel test robot <lkp@intel.com>,
        Sasha Levin <sashal@kernel.org>, pablo@netfilter.org,
        kadlec@netfilter.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 17/28] netfilter: nfnetlink_log: silence bogus compiler warning
Date:   Sun, 29 Oct 2023 18:58:52 -0400
Message-ID: <20231029225916.791798-17-sashal@kernel.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231029225916.791798-1-sashal@kernel.org>
References: <20231029225916.791798-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.15.137
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 2e1d175410972285333193837a4250a74cd472e6 ]

net/netfilter/nfnetlink_log.c:800:18: warning: variable 'ctinfo' is uninitialized

The warning is bogus, the variable is only used if ct is non-NULL and
always initialised in that case.  Init to 0 too to silence this.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202309100514.ndBFebXN-lkp@intel.com/
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nfnetlink_log.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 7f83f9697fc14..09fe6cf358ec7 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -687,8 +687,8 @@ nfulnl_log_packet(struct net *net,
 	unsigned int plen = 0;
 	struct nfnl_log_net *log = nfnl_log_pernet(net);
 	const struct nfnl_ct_hook *nfnl_ct = NULL;
+	enum ip_conntrack_info ctinfo = 0;
 	struct nf_conn *ct = NULL;
-	enum ip_conntrack_info ctinfo;
 
 	if (li_user && li_user->type == NF_LOG_TYPE_ULOG)
 		li = li_user;
-- 
2.42.0

