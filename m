Return-Path: <SRS0=RE83=6O=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A324CC4724C
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Apr 2020 15:14:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8489020661
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Apr 2020 15:14:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726455AbgD3POT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 30 Apr 2020 11:14:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726396AbgD3POT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 30 Apr 2020 11:14:19 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F02E8C035494
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Apr 2020 08:14:18 -0700 (PDT)
Received: from localhost ([::1]:43926 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1jUAtF-0008AH-Cv; Thu, 30 Apr 2020 17:14:17 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 1/4] segtree: Fix missing expires value in prefixes
Date:   Thu, 30 Apr 2020 17:14:05 +0200
Message-Id: <20200430151408.32283-2-phil@nwl.cc>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200430151408.32283-1-phil@nwl.cc>
References: <20200430151408.32283-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This probable copy'n'paste bug prevented 'expiration' field from being
populated when turning a range into a prefix in
interval_map_decompose(). Consequently, interval sets with timeout did
print expiry value for ranges (such as 10.0.0.1-10.0.0.5) but not
prefixes (10.0.0.0/8, for instance).

Fixes: bb0e6d8a2851b ("segtree: incorrect handling of comments and timeouts with mapping")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/segtree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/segtree.c b/src/segtree.c
index a9d6ecc89d7c1..002ee41a16db0 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -1099,7 +1099,7 @@ void interval_map_decompose(struct expr *set)
 					prefix->comment = xstrdup(low->comment);
 				if (low->timeout)
 					prefix->timeout = low->timeout;
-				if (low->left->expiration)
+				if (low->expiration)
 					prefix->expiration = low->expiration;
 			}
 
-- 
2.25.1

