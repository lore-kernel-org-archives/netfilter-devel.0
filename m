Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B47CBC48BE0
	for <netfilter-devel@archiver.kernel.org>; Fri, 11 Jun 2021 16:41:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 95AF86101B
	for <netfilter-devel@archiver.kernel.org>; Fri, 11 Jun 2021 16:41:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbhFKQnJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 11 Jun 2021 12:43:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbhFKQnJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 11 Jun 2021 12:43:09 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0870AC061574
        for <netfilter-devel@vger.kernel.org>; Fri, 11 Jun 2021 09:41:11 -0700 (PDT)
Received: from localhost ([::1]:41324 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1lrkDV-0005d8-GK; Fri, 11 Jun 2021 18:41:09 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 03/10] evaluate: Mark fall through case in str2hooknum()
Date:   Fri, 11 Jun 2021 18:40:57 +0200
Message-Id: <20210611164104.8121-4-phil@nwl.cc>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210611164104.8121-1-phil@nwl.cc>
References: <20210611164104.8121-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

It is certainly intentional, so just mark it as such.

Fixes: b4775dec9f80b ("src: ingress inet support")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/evaluate.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/evaluate.c b/src/evaluate.c
index 43f1f8a3977b2..ee79f160f8ff3 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -4145,6 +4145,7 @@ static uint32_t str2hooknum(uint32_t family, const char *hook)
 	case NFPROTO_INET:
 		if (!strcmp(hook, "ingress"))
 			return NF_INET_INGRESS;
+		/* fall through */
 	case NFPROTO_IPV4:
 	case NFPROTO_BRIDGE:
 	case NFPROTO_IPV6:
-- 
2.31.1

