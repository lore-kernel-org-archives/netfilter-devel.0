Return-Path: <SRS0=cwGx=Q6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D174CC43381
	for <netfilter-devel@archiver.kernel.org>; Sat, 23 Feb 2019 21:20:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9FE4420651
	for <netfilter-devel@archiver.kernel.org>; Sat, 23 Feb 2019 21:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550956854;
	bh=KSgoCEIKm+j+9AbqJbGlGsZu2oo7yoy5EwTt30ypGUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=RfnlOnq6ML9aSVYOK0oymQp4bpc1LN1nLnAL2+aq1dG06bY3An3u9yGug/iLdSPgK
	 yArZdoIfs3IaJAELN7YO1UBPskoSt7UEsemsG/AZy7QiWhPPDnegXAkreYlU1GPopO
	 QkOp4Li+CGWQ5rrnfr5SBJ59FtejKZOYAufGnO8w=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729519AbfBWVUx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 23 Feb 2019 16:20:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:44766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729447AbfBWVJN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 23 Feb 2019 16:09:13 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 525B020855;
        Sat, 23 Feb 2019 21:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550956152;
        bh=KSgoCEIKm+j+9AbqJbGlGsZu2oo7yoy5EwTt30ypGUs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YOrihw1PdWHLNzm8RrzGTw3SukVfBU7H95YUj60wd9lZhKXNEt6MsplW2c+8DixcB
         9JwT6vJX0iMKDCJEhdIjuiNpINgameOQHrCRVuduI50xZX8dQchauT+7o48o0b5R07
         pCz6uA0OldbFd1ERhB0Wl9tBWx/qO7FuuP6Jf3yE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 21/45] netfilter: ebtables: compat: un-break 32bit setsockopt when no rules are present
Date:   Sat, 23 Feb 2019 16:08:11 -0500
Message-Id: <20190223210835.201708-21-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190223210835.201708-1-sashal@kernel.org>
References: <20190223210835.201708-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 2035f3ff8eaa29cfb5c8e2160b0f6e85eeb21a95 ]

Unlike ip(6)tables ebtables only counts user-defined chains.

The effect is that a 32bit ebtables binary on a 64bit kernel can do
'ebtables -N FOO' only after adding at least one rule, else the request
fails with -EINVAL.

This is a similar fix as done in
3f1e53abff84 ("netfilter: ebtables: don't attempt to allocate 0-sized compat array").

Fixes: 7d7d7e02111e9 ("netfilter: compat: reject huge allocation requests")
Reported-by: Francesco Ruggeri <fruggeri@arista.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/netfilter/ebtables.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 22e4c15a1fc30..53392ac58b38f 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -2292,9 +2292,12 @@ static int compat_do_replace(struct net *net, void __user *user,
 
 	xt_compat_lock(NFPROTO_BRIDGE);
 
-	ret = xt_compat_init_offsets(NFPROTO_BRIDGE, tmp.nentries);
-	if (ret < 0)
-		goto out_unlock;
+	if (tmp.nentries) {
+		ret = xt_compat_init_offsets(NFPROTO_BRIDGE, tmp.nentries);
+		if (ret < 0)
+			goto out_unlock;
+	}
+
 	ret = compat_copy_entries(entries_tmp, tmp.entries_size, &state);
 	if (ret < 0)
 		goto out_unlock;
-- 
2.19.1

