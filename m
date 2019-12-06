Return-Path: <SRS0=ut36=Z4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70DBDC43603
	for <netfilter-devel@archiver.kernel.org>; Fri,  6 Dec 2019 11:47:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E30721823
	for <netfilter-devel@archiver.kernel.org>; Fri,  6 Dec 2019 11:47:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726317AbfLFLry (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 6 Dec 2019 06:47:54 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:34924 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726134AbfLFLry (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 6 Dec 2019 06:47:54 -0500
Received: from localhost ([::1]:48014 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1idC5Q-0002mZ-CA; Fri, 06 Dec 2019 12:47:52 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 1/6] xtables-restore: Avoid access of uninitialized data
Date:   Fri,  6 Dec 2019 12:47:06 +0100
Message-Id: <20191206114711.6015-2-phil@nwl.cc>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191206114711.6015-1-phil@nwl.cc>
References: <20191206114711.6015-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When flushing, 'buffer' is not written to prior to checking its first
byte's value. Therefore it needs to be initialized upon declaration.

Fixes: 09cb517949e69 ("xtables-restore: Improve performance of --noflush operation")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/xtables-restore.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/iptables/xtables-restore.c b/iptables/xtables-restore.c
index dd907e0b8ddd5..63cc15cee9621 100644
--- a/iptables/xtables-restore.c
+++ b/iptables/xtables-restore.c
@@ -281,7 +281,7 @@ void xtables_restore_parse(struct nft_handle *h,
 			   const struct nft_xt_restore_parse *p)
 {
 	struct nft_xt_restore_state state = {};
-	char preload_buffer[PREBUFSIZ] = {}, buffer[10240], *ptr;
+	char preload_buffer[PREBUFSIZ] = {}, buffer[10240] = {}, *ptr;
 
 	if (!h->noflush) {
 		nft_fake_cache(h);
-- 
2.24.0

