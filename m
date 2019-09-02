Return-Path: <SRS0=j12K=W5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6419AC3A59E
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Sep 2019 23:32:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 38B3F22CF7
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Sep 2019 23:32:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="ofWwPTRn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727888AbfIBXcf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Sep 2019 19:32:35 -0400
Received: from kadath.azazel.net ([81.187.231.250]:44116 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726623AbfIBXce (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Sep 2019 19:32:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ZbZaMQnoNxxHgm9dHsr8ESnx4TWpMqblRb8xgiEABtE=; b=ofWwPTRnsviauIN1Iew/8JglaH
        8LCyx3UM/QsShn/Wa4H4UF+JIAGz1QLfMMLrf3528NKwQd9kr3Gm0dOJEuSGoCzgAzPyv5Z4Yphiu
        Y6rPtfX1mj6tShVZnMx0njkz4o5S/huBRcK2S9pRPfTb2IL5Q81fStEUcilfTOJ3BA1QlbbxpSixl
        0otQbnD1O3gJsicOMx6bSSELkcClvrnXk2FF3exAlNMxWveJlS8td4C0y88MYYs/B7S3oaIr05U3Z
        2KY9aXa9KyqaIEKDf3jXvdIQ9jQmsSx0xa/f8GFQxvN93evJ8Tku95u53lqo/TNk9KBdaeab05uMB
        ZMNNFBxw==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1i4vPQ-0004la-1w; Tue, 03 Sep 2019 00:06:52 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next v2 10/30] netfilter: include the right header in nf_conntrack_zones.h.
Date:   Tue,  3 Sep 2019 00:06:30 +0100
Message-Id: <20190902230650.14621-11-jeremy@azazel.net>
X-Mailer: git-send-email 2.23.0.rc1
In-Reply-To: <20190902230650.14621-1-jeremy@azazel.net>
References: <20190902230650.14621-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

nf_conntrack_zones.h includes nf_conntrack_extend.h, but it doesn't
actually use anything from it.  It does, however, require stuff from
nf_conntrack.h which it includes transitively.  Include nf_conntrack.h
directly instead.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 include/net/netfilter/nf_conntrack_zones.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/net/netfilter/nf_conntrack_zones.h b/include/net/netfilter/nf_conntrack_zones.h
index 52950baa3ab5..33b91d19cb7d 100644
--- a/include/net/netfilter/nf_conntrack_zones.h
+++ b/include/net/netfilter/nf_conntrack_zones.h
@@ -5,7 +5,8 @@
 #include <linux/netfilter/nf_conntrack_zones_common.h>
 
 #if IS_ENABLED(CONFIG_NF_CONNTRACK)
-#include <net/netfilter/nf_conntrack_extend.h>
+
+#include <net/netfilter/nf_conntrack.h>
 
 static inline const struct nf_conntrack_zone *
 nf_ct_zone(const struct nf_conn *ct)
-- 
2.23.0.rc1

