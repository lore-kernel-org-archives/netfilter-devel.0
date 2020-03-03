Return-Path: <SRS0=D+Hy=4U=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E332C3F2CD
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Mar 2020 05:08:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 50B9E20717
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Mar 2020 05:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1583212130;
	bh=9F7aK5GlY+bFUZvd25qhfbo8WZmzw55Hr+t0rWIjmpc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=VPbHUfqtEP5C5jBh2YkWzBlKJpXgUYRPJW2ewSQKgpyBjv32394sOwnWs0AiD73Wt
	 oa2Mp77zpTtLQCQHupBit1L/xxFIKv7Yflb0UH4f54OVgWucORm4HYlS83VMt19AuI
	 MFXl9fAO8x90kGdBIV/ifqKpq31X+ncIy+cyigKM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727101AbgCCFIt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 3 Mar 2020 00:08:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:40398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725818AbgCCFIp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 3 Mar 2020 00:08:45 -0500
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D42521739;
        Tue,  3 Mar 2020 05:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583212124;
        bh=9F7aK5GlY+bFUZvd25qhfbo8WZmzw55Hr+t0rWIjmpc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1L0RcrYI+UjkX8d2UfjGGByfqnqMoufbbqQxh+z+p18ueVKCH5//PSAtIPB00HNtp
         0LqoikyIZeFEr1xSS7PaysGFrFqOVzyCfNk4JHboB8KbkNnzTS9nJf+f4z2yNgr8yU
         oLD1IIxlsNO33pDhdm5962B7udZuXwJk4I6ykXP8=
From:   Jakub Kicinski <kuba@kernel.org>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, fw@strlen.de,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH netfilter 1/3] netfilter: add missing attribute validation for cthelper
Date:   Mon,  2 Mar 2020 21:08:31 -0800
Message-Id: <20200303050833.4089193-2-kuba@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200303050833.4089193-1-kuba@kernel.org>
References: <20200303050833.4089193-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add missing attribute validation for cthelper
to the netlink policy.

Fixes: 12f7a505331e ("netfilter: add user-space connection tracking helper infrastructure")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/netfilter/nfnetlink_cthelper.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nfnetlink_cthelper.c b/net/netfilter/nfnetlink_cthelper.c
index de3a9596b7f1..a5f294aa8e4c 100644
--- a/net/netfilter/nfnetlink_cthelper.c
+++ b/net/netfilter/nfnetlink_cthelper.c
@@ -742,6 +742,8 @@ static const struct nla_policy nfnl_cthelper_policy[NFCTH_MAX+1] = {
 	[NFCTH_NAME] = { .type = NLA_NUL_STRING,
 			 .len = NF_CT_HELPER_NAME_LEN-1 },
 	[NFCTH_QUEUE_NUM] = { .type = NLA_U32, },
+	[NFCTH_PRIV_DATA_LEN] = { .type = NLA_U32, },
+	[NFCTH_STATUS] = { .type = NLA_U32, },
 };
 
 static const struct nfnl_callback nfnl_cthelper_cb[NFNL_MSG_CTHELPER_MAX] = {
-- 
2.24.1

