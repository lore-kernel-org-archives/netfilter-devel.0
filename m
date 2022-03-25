Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 244D3C433EF
	for <netfilter-devel@archiver.kernel.org>; Fri, 25 Mar 2022 17:39:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230058AbiCYRlE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 25 Mar 2022 13:41:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230049AbiCYRlE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 25 Mar 2022 13:41:04 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4804D12926D
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Mar 2022 10:39:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ijQt67gp01YJPbklirLcr/P/dRJObkSi+s2WAnuuPJA=; b=GiMuU08XKXiOtP86U5NGdpMoKM
        wcC/JbWr9Z7OhpnVNPFjKGYYHeMt7CIXqtZ36UKB2guvC9/edJ/9ibYULjHNtxAnJH/hMfpNOyx9w
        hcjMaK6Xsme6ttQ0Ey3iCAofh6OBD9NAUT53eUhjA2ub3HS5Arn6i4URoivyA7oDn2CsrvhypPR0x
        ldImuyacrWPS1eclvcq4xmMQjIgJ7+4/nZ9XhlFcQMEIXSgukwP4tM0y/IbKlca2I7ckcuN5TTLWf
        JWWOLl9RpVUzLA7EAvRL8Dq55MjmKUWNnyCNv/UZ394FnDC/nxLr5p9N/o8XVXlrMnLssi7SJbTxm
        /42DdFfA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nXnpU-0004M8-8C; Fri, 25 Mar 2022 18:34:28 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [libnfnetlink PATCH 2/2] libnfnetlink: Check getsockname() return code
Date:   Fri, 25 Mar 2022 18:34:26 +0100
Message-Id: <20220325173426.11493-2-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220325173426.11493-1-phil@nwl.cc>
References: <20220325173426.11493-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The function may return -1 (and set errno). Assume it will leave
addr_len value unchanged, so checking is necessary to not hide the
error.

Fixes: 4248314d40187 ("nfnl: fix compilation warning with gcc-4.7")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/libnfnetlink.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/src/libnfnetlink.c b/src/libnfnetlink.c
index 1cb6a820fee3d..667e5ef8f82a5 100644
--- a/src/libnfnetlink.c
+++ b/src/libnfnetlink.c
@@ -210,7 +210,8 @@ struct nfnl_handle *nfnl_open(void)
 	nfnlh->peer.nl_family = AF_NETLINK;
 
 	addr_len = sizeof(nfnlh->local);
-	getsockname(nfnlh->fd, (struct sockaddr *)&nfnlh->local, &addr_len);
+	if (getsockname(nfnlh->fd, (struct sockaddr *)&nfnlh->local, &addr_len))
+		goto err_close;
 	if (addr_len != sizeof(nfnlh->local)) {
 		errno = EINVAL;
 		goto err_close;
@@ -231,7 +232,8 @@ struct nfnl_handle *nfnl_open(void)
 
 	/* use getsockname to get the netlink pid that the kernel assigned us */
 	addr_len = sizeof(nfnlh->local);
-	getsockname(nfnlh->fd, (struct sockaddr *)&nfnlh->local, &addr_len);
+	if (getsockname(nfnlh->fd, (struct sockaddr *)&nfnlh->local, &addr_len))
+		goto err_close;
 	if (addr_len != sizeof(nfnlh->local)) {
 		errno = EINVAL;
 		goto err_close;
-- 
2.34.1

