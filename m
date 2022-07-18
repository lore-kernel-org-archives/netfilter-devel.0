Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE5A2C43334
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Jul 2022 15:21:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233634AbiGRPVS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 18 Jul 2022 11:21:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235306AbiGRPVS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 Jul 2022 11:21:18 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EC17E25E86
        for <netfilter-devel@vger.kernel.org>; Mon, 18 Jul 2022 08:21:17 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] cache: report an error message if cache initialization fails
Date:   Mon, 18 Jul 2022 17:21:00 +0200
Message-Id: <20220718152100.591117-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

cache initialization failure (which should not ever happen) is not
reported to the user.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/cache.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/src/cache.c b/src/cache.c
index 2e1bcfcece57..da72dc909096 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -1180,7 +1180,11 @@ replay:
 			goto replay;
 		}
 
+		erec_queue(error(&netlink_location, "cache initialization failed: %s",
+				 strerror(errno)),
+			   msgs);
 		nft_cache_release(cache);
+
 		return -1;
 	}
 
-- 
2.30.2

