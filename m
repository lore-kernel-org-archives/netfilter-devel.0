Return-Path: <SRS0=4pKc=6U=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C567C4724C
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 May 2020 17:33:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D6B9206B8
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 May 2020 17:33:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729344AbgEFRd6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 May 2020 13:33:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728047AbgEFRd5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 May 2020 13:33:57 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98C29C061A0F
        for <netfilter-devel@vger.kernel.org>; Wed,  6 May 2020 10:33:57 -0700 (PDT)
Received: from localhost ([::1]:58708 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1jWNvg-0002jq-FE; Wed, 06 May 2020 19:33:56 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 04/15] nft: Call nft_release_cache() in nft_fini()
Date:   Wed,  6 May 2020 19:33:20 +0200
Message-Id: <20200506173331.9347-5-phil@nwl.cc>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200506173331.9347-1-phil@nwl.cc>
References: <20200506173331.9347-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

In contrast to flush_chain_cache(), this will also clean up cache_req.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index d2796fcd8ad26..6503259eb443e 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -855,7 +855,7 @@ void nft_fini(struct nft_handle *h)
 	list_for_each_entry_safe(cmd, next, &h->cmd_list, head)
 		nft_cmd_free(cmd);
 
-	flush_chain_cache(h, NULL);
+	nft_release_cache(h);
 	mnl_socket_close(h->nl);
 }
 
-- 
2.25.1

