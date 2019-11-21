Return-Path: <SRS0=7szD=ZN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10402C432C0
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Nov 2019 11:16:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF30420872
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Nov 2019 11:16:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726784AbfKULQS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 21 Nov 2019 06:16:18 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:40948 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726165AbfKULQS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Nov 2019 06:16:18 -0500
Received: from localhost ([::1]:54038 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iXkRd-0001Dl-1Q; Thu, 21 Nov 2019 12:16:17 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [arptables PATCH 3/3] libarptc: Simplify alloc_handle by using calloc()
Date:   Thu, 21 Nov 2019 12:15:59 +0100
Message-Id: <20191121111559.27066-4-phil@nwl.cc>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191121111559.27066-1-phil@nwl.cc>
References: <20191121111559.27066-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

No need to explicitly set fields to zero when using calloc().

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 libarptc/libarptc_incl.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/libarptc/libarptc_incl.c b/libarptc/libarptc_incl.c
index ca23da6474990..c4d5de3f39a15 100644
--- a/libarptc/libarptc_incl.c
+++ b/libarptc/libarptc_incl.c
@@ -191,21 +191,16 @@ alloc_handle(const char *tablename, unsigned int size, unsigned int num_rules)
 		+ size
 		+ num_rules * sizeof(struct counter_map);
 
-	if ((h = malloc(len)) == NULL) {
+	if ((h = calloc(1, len)) == NULL) {
 		errno = ENOMEM;
 		return NULL;
 	}
 
-	h->changed = 0;
-	h->cache_num_chains = 0;
-	h->cache_chain_heads = NULL;
 	h->counter_map = (void *)h
 		+ sizeof(STRUCT_TC_HANDLE)
 		+ size;
-	strncpy(h->info.name, tablename, sizeof(h->info.name));
-	h->info.name[sizeof(h->info.name)-1] = '\0';
-	strncpy(h->entries.name, tablename, sizeof(h->entries.name));
-	h->entries.name[sizeof(h->entries.name)-1] = '\0';
+	strncpy(h->info.name, tablename, sizeof(h->info.name) - 1);
+	strncpy(h->entries.name, tablename, sizeof(h->entries.name) - 1);
 
 	return h;
 }
-- 
2.24.0

