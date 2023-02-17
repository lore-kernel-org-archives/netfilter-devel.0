Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49FC2C677F1
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Feb 2023 16:18:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230501AbjBQQSD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 17 Feb 2023 11:18:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231156AbjBQQRz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Feb 2023 11:17:55 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 200E25FC56
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Feb 2023 08:17:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Qp0PKuVPPyWGIstavB6huOZa/Sz0P4Jgat8HAEyMaNk=; b=mub98FoxVx1KQJAVACVZkMd7jD
        scZpJ8+6FEWD7MGjabts13H1ZMUrvUrZk8WG7KYU9VsMheGAFstC8YY3b3dwmfSqfYenvpLtd1vPr
        ZnYXMDTA/wukjlj2hzYQ4sgh8+XhQBSu5Vz9oAfM/JJfMukC17S+MMLFZwwZVtSDRmK7SyH+hewsh
        VUvRxRYH3Ifv1qSx5YBiw5dfTy6CY5+ErCsmjIgz+1EsJJFA0EWr1Qsq0sdMsiuqViSfW3PKtcBx0
        oM5tPKZsi5l4DUhg2Lv8XCwJtjfkpfMQ5EMOS2KZfxKq78O15yqUOWYCj/6AQ8wFQyu9QIqBCsAii
        i2kjcYqg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1pT3Qf-0003WE-H6
        for netfilter-devel@vger.kernel.org; Fri, 17 Feb 2023 17:17:45 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 2/6] extensions: libebt_redirect: Fix for wrong syntax in translation
Date:   Fri, 17 Feb 2023 17:17:11 +0100
Message-Id: <20230217161715.26120-2-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230217161715.26120-1-phil@nwl.cc>
References: <20230217161715.26120-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Meta key comes before 'set' in meta statement.

Fixes: 24ce7465056ae ("ebtables-compat: add redirect match extension")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libebt_redirect.c      | 2 +-
 extensions/libebt_redirect.txlate | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/extensions/libebt_redirect.c b/extensions/libebt_redirect.c
index 389f3ccb53f60..7821935e137aa 100644
--- a/extensions/libebt_redirect.c
+++ b/extensions/libebt_redirect.c
@@ -83,7 +83,7 @@ static int brredir_xlate(struct xt_xlate *xl,
 {
 	const struct ebt_redirect_info *red = (const void*)params->target->data;
 
-	xt_xlate_add(xl, "meta set pkttype host");
+	xt_xlate_add(xl, "meta pkttype set host");
 	if (red->target != EBT_CONTINUE)
 		xt_xlate_add(xl, " %s ", brredir_verdict(red->target));
 	return 1;
diff --git a/extensions/libebt_redirect.txlate b/extensions/libebt_redirect.txlate
index f0dd5deaf6406..d073ec774c4fa 100644
--- a/extensions/libebt_redirect.txlate
+++ b/extensions/libebt_redirect.txlate
@@ -1,8 +1,8 @@
 ebtables-translate -t nat -A PREROUTING -d de:ad:00:00:be:ef -j redirect
-nft 'add rule bridge nat PREROUTING ether daddr de:ad:00:00:be:ef counter meta set pkttype host accept'
+nft 'add rule bridge nat PREROUTING ether daddr de:ad:00:00:be:ef counter meta pkttype set host accept'
 
 ebtables-translate -t nat -A PREROUTING -d de:ad:00:00:be:ef -j redirect --redirect-target RETURN
-nft 'add rule bridge nat PREROUTING ether daddr de:ad:00:00:be:ef counter meta set pkttype host return'
+nft 'add rule bridge nat PREROUTING ether daddr de:ad:00:00:be:ef counter meta pkttype set host return'
 
 ebtables-translate -t nat -A PREROUTING -d de:ad:00:00:be:ef -j redirect --redirect-target CONTINUE
-nft 'add rule bridge nat PREROUTING ether daddr de:ad:00:00:be:ef counter meta set pkttype host'
+nft 'add rule bridge nat PREROUTING ether daddr de:ad:00:00:be:ef counter meta pkttype set host'
-- 
2.38.0

