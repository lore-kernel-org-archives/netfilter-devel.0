Return-Path: <SRS0=qEnH=WK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32D42C32750
	for <netfilter-devel@archiver.kernel.org>; Wed, 14 Aug 2019 02:22:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F22F220842
	for <netfilter-devel@archiver.kernel.org>; Wed, 14 Aug 2019 02:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1565749364;
	bh=234ZHydERtazHOtGzAM7E9t5ZSzd/PLvBnGrxyMvjnU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=LB3jwYaK0A4Q2NkZt7qELqimWXcx35JqyrVtLpYQ+qCTCFqa0MqvzQPwGqVX0B/sM
	 BPb9tUsc0QSZM8BS5WzjFviZu0uglYJAh7NCOLnAm6EJowiPX25d0mh5QD9hSuJD1e
	 9zt4XbMqyBOKTRGWBHJ3OjC2upQupRSAXfcml83U=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729237AbfHNCWg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 13 Aug 2019 22:22:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:49654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727502AbfHNCSo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 13 Aug 2019 22:18:44 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 541BD2085A;
        Wed, 14 Aug 2019 02:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565749123;
        bh=234ZHydERtazHOtGzAM7E9t5ZSzd/PLvBnGrxyMvjnU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WW0YFKgqfMETVoN3mocbbuKs3U1oVtDUaSi28+TOrws4KovulPMHr7L19eVknJ5t7
         gnmi1bMp92yKQrvn8oCChWjLHcEMOoNz9xfXYisHPVvM5AaMklnMtO8DG+gfPZzxE5
         kmyMkkOV4E/CQAwHszRpULSKFXvQx0XbQiBcRAZs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wenwen Wang <wenwen@cs.uga.edu>, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 05/44] netfilter: ebtables: fix a memory leak bug in compat
Date:   Tue, 13 Aug 2019 22:17:54 -0400
Message-Id: <20190814021834.16662-5-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190814021834.16662-1-sashal@kernel.org>
References: <20190814021834.16662-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Wenwen Wang <wenwen@cs.uga.edu>

[ Upstream commit 15a78ba1844a8e052c1226f930133de4cef4e7ad ]

In compat_do_replace(), a temporary buffer is allocated through vmalloc()
to hold entries copied from the user space. The buffer address is firstly
saved to 'newinfo->entries', and later on assigned to 'entries_tmp'. Then
the entries in this temporary buffer is copied to the internal kernel
structure through compat_copy_entries(). If this copy process fails,
compat_do_replace() should be terminated. However, the allocated temporary
buffer is not freed on this path, leading to a memory leak.

To fix the bug, free the buffer before returning from compat_do_replace().

Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/netfilter/ebtables.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index b967bd51bf1f9..48e364b11e067 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -2267,8 +2267,10 @@ static int compat_do_replace(struct net *net, void __user *user,
 	state.buf_kern_len = size64;
 
 	ret = compat_copy_entries(entries_tmp, tmp.entries_size, &state);
-	if (WARN_ON(ret < 0))
+	if (WARN_ON(ret < 0)) {
+		vfree(entries_tmp);
 		goto out_unlock;
+	}
 
 	vfree(entries_tmp);
 	tmp.entries_size = size64;
-- 
2.20.1

