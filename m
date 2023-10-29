Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65316C00142
	for <netfilter-devel@archiver.kernel.org>; Sun, 29 Oct 2023 23:04:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231633AbjJ2XE3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 29 Oct 2023 19:04:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232031AbjJ2XEG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 29 Oct 2023 19:04:06 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CAD17EC1;
        Sun, 29 Oct 2023 16:02:21 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4460C433B8;
        Sun, 29 Oct 2023 23:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698620427;
        bh=uEtJBRzg7Zr+VZEfWwug+VgiKu2cYuMf1hhXMXL/dkU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UBZBkz5/KIPIhGQ/5ORueBPI0tAC1TlNlkM78uELWqST9ljN1FxFQgTs/L9nfnlmp
         G3PyacmPup0hoeE2J7Ms7E2sBTWpPCbiIdXRHbFyOKhX8cvmSf1nbsCi68LXbWp+Q7
         BSb4kSSElZDCrt/u/lJongg+L/9tK9xdMrUK8NOxV3FeanAkxIlFuP+OuLV95Qc4GY
         rpWqMiidLavj2vIVnzL4Xca7qs6HtNYuipwmQ1jr/z28s/iqkuQH2PINnULJmxTq0s
         hgU29k3NzpUtZbahOvtJC0couayq86Y8RXUNaMaeYNDFrHnfMPIc04LDIpp60lsG18
         bcvx+r335qFsA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>, kernel test robot <lkp@intel.com>,
        Sasha Levin <sashal@kernel.org>, pablo@netfilter.org,
        kadlec@netfilter.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 07/16] netfilter: nfnetlink_log: silence bogus compiler warning
Date:   Sun, 29 Oct 2023 18:59:53 -0400
Message-ID: <20231029230014.792490-7-sashal@kernel.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231029230014.792490-1-sashal@kernel.org>
References: <20231029230014.792490-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.10.199
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
index f087baa95b07b..80c09070ea9fa 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -683,8 +683,8 @@ nfulnl_log_packet(struct net *net,
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

