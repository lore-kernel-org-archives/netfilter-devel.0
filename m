Return-Path: <SRS0=uBXc=ZO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1081FC432C3
	for <netfilter-devel@archiver.kernel.org>; Fri, 22 Nov 2019 06:21:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D395A2070E
	for <netfilter-devel@archiver.kernel.org>; Fri, 22 Nov 2019 06:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1574403709;
	bh=MBxeDnP2vJ6YQSAW4kvOLr2ixbZPyUPv7eGEKXCsK1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=XfDgxcTpehDS4qbrAP7UCkNFLkR36Vkm5FWxZQ1ZJHWz3rzbBV9Zi/UfOkCKdSp+V
	 eGnCx68gLXFi6CzdqUpc2IEj4TJ+YjymcMtcdJKy6Fh2Q5CoXnVnEmmc6qeVB+YgLu
	 Dtfx4v8FrunyKLTLtuMlygZmb1AIKGQS3xMZZX4I=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728882AbfKVGVo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 22 Nov 2019 01:21:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:57766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728442AbfKVFwN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 22 Nov 2019 00:52:13 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 89E892084B;
        Fri, 22 Nov 2019 05:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401932;
        bh=MBxeDnP2vJ6YQSAW4kvOLr2ixbZPyUPv7eGEKXCsK1E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ejXSKt8lgPc8c3+6bJPLR1zllH7ErlFYereR1p0lfrqdRBG43An9XLdKqZ44JD+tl
         rMoD3uvXsYT95LwPj3RNo40r0WzYFQjqmywq1ZKPb5d1b4Df6deF6H//pTDTiUwS7B
         b64GM4prghzxpsEcIDMXxm+olrEg97zHMkp37C9A=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kangjie Lu <kjlu@umn.edu>, Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 158/219] netfilter: nf_tables: fix a missing check of nla_put_failure
Date:   Fri, 22 Nov 2019 00:48:10 -0500
Message-Id: <20191122054911.1750-151-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122054911.1750-1-sashal@kernel.org>
References: <20191122054911.1750-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Kangjie Lu <kjlu@umn.edu>

[ Upstream commit eb8950861c1bfd3eecc8f6faad213e3bca0dc395 ]

If nla_nest_start() may fail. The fix checks its return value and goes
to nla_put_failure if it fails.

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 24fddf0322790..4c1a88b7ba285 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5735,6 +5735,8 @@ static int nf_tables_fill_flowtable_info(struct sk_buff *skb, struct net *net,
 		goto nla_put_failure;
 
 	nest = nla_nest_start(skb, NFTA_FLOWTABLE_HOOK);
+	if (!nest)
+		goto nla_put_failure;
 	if (nla_put_be32(skb, NFTA_FLOWTABLE_HOOK_NUM, htonl(flowtable->hooknum)) ||
 	    nla_put_be32(skb, NFTA_FLOWTABLE_HOOK_PRIORITY, htonl(flowtable->priority)))
 		goto nla_put_failure;
-- 
2.20.1

