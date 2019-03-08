Return-Path: <SRS0=0Xdd=RL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8D88C43381
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 Mar 2019 23:40:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A8A082081B
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 Mar 2019 23:40:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="VP3INjvu";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="jJNOHrKt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726324AbfCHXkW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 8 Mar 2019 18:40:22 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:43788 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726302AbfCHXkW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 8 Mar 2019 18:40:22 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 79ABF60397; Fri,  8 Mar 2019 23:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1552088421;
        bh=OgozcQg84NRwcGcM5T7QMrbsglBNePr18imyUre7bcU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VP3INjvudfE5z4ln+EfZdviKH8NiNP6o7J2p7RMpj8On6Ma9zZxNsGpxaRnku2EMn
         s4iQrU5+YauO0hU9Dj0ylW+PqbHF4xjki/PbnG5uk1HvQ488TcgOGCwbVCluMimmhJ
         e/5PH/BZzvdRXjRK1o58saN0e58B9zb6anXmo5zk=
Received: from subashab-lnx.qualcomm.com (unknown [129.46.15.92])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: subashab@codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 74DF260265;
        Fri,  8 Mar 2019 23:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1552088420;
        bh=OgozcQg84NRwcGcM5T7QMrbsglBNePr18imyUre7bcU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jJNOHrKtCsv40bONIycZU6wekL6FwO8DGcDjplA1MCXdVnkBWlh3pivEmjrMWmoAI
         5yKHDHK4qjLIt2Jj7HGvF9ljW88pnFhwz5piixU23pTAmV/jz1nLXD6nlbWbL922Kr
         hatqD1oga7w1op8vDWnAMAhROeqciJj7HS25OdU4=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 74DF260265
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=subashab@codeaurora.org
From:   Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
To:     pablo@netfilter.org, netfilter-devel@vger.kernel.org,
        gregkh@linuxfoundation.org
Cc:     Taehee Yoo <ap420073@gmail.com>
Subject: [PATCH 4.19 2/2] netfilter: xt_TEE: add missing code to get interface index in checkentry.
Date:   Fri,  8 Mar 2019 16:38:14 -0700
Message-Id: <1552088294-18087-2-git-send-email-subashab@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1552088294-18087-1-git-send-email-subashab@codeaurora.org>
References: <1552088294-18087-1-git-send-email-subashab@codeaurora.org>
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

commit 18c0ab87364ac5128a152055fdcb1d27e01caf01 upstream.

checkentry(tee_tg_check) should initialize priv->oif from dev if possible.
But only netdevice notifier handler can set that.
Hence priv->oif is always -1 until notifier handler is called.

Fixes: 9e2f6c5d78db ("netfilter: Rework xt_TEE netdevice notifier")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/xt_TEE.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/netfilter/xt_TEE.c b/net/netfilter/xt_TEE.c
index 673ad20..1dae02a 100644
--- a/net/netfilter/xt_TEE.c
+++ b/net/netfilter/xt_TEE.c
@@ -104,6 +104,8 @@ static int tee_tg_check(const struct xt_tgchk_param *par)
 		return -EINVAL;
 
 	if (info->oif[0]) {
+		struct net_device *dev;
+
 		if (info->oif[sizeof(info->oif)-1] != '\0')
 			return -EINVAL;
 
@@ -115,6 +117,11 @@ static int tee_tg_check(const struct xt_tgchk_param *par)
 		priv->oif     = -1;
 		info->priv    = priv;
 
+		dev = dev_get_by_name(par->net, info->oif);
+		if (dev) {
+			priv->oif = dev->ifindex;
+			dev_put(dev);
+		}
 		mutex_lock(&tn->lock);
 		list_add(&priv->list, &tn->priv_list);
 		mutex_unlock(&tn->lock);
-- 
1.9.1

