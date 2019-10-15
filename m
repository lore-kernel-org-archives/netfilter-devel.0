Return-Path: <SRS0=TYlN=YI=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6D57ECE588
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Oct 2019 14:17:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C543E20650
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Oct 2019 14:17:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732501AbfJOOR3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 15 Oct 2019 10:17:29 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:36900 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731553AbfJOOR3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Oct 2019 10:17:29 -0400
Received: from localhost ([::1]:49990 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iKNdf-000393-V2; Tue, 15 Oct 2019 16:17:28 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [libnftnl PATCH 4/6] set: Don't bypass checks in nftnl_set_set_u{32,64}()
Date:   Tue, 15 Oct 2019 16:16:56 +0200
Message-Id: <20191015141658.11325-5-phil@nwl.cc>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191015141658.11325-1-phil@nwl.cc>
References: <20191015141658.11325-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

By calling nftnl_set_set(), any data size checks are effectively
bypassed. Better call nftnl_set_set_data() directly, passing the real
size for validation.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/set.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/src/set.c b/src/set.c
index e6db7258cc224..b1ffe7e6de975 100644
--- a/src/set.c
+++ b/src/set.c
@@ -195,6 +195,7 @@ int nftnl_set_set_data(struct nftnl_set *s, uint16_t attr, const void *data,
 	return 0;
 }
 
+/* XXX: Deprecate this, it is simply unsafe */
 EXPORT_SYMBOL(nftnl_set_set);
 int nftnl_set_set(struct nftnl_set *s, uint16_t attr, const void *data)
 {
@@ -204,13 +205,13 @@ int nftnl_set_set(struct nftnl_set *s, uint16_t attr, const void *data)
 EXPORT_SYMBOL(nftnl_set_set_u32);
 void nftnl_set_set_u32(struct nftnl_set *s, uint16_t attr, uint32_t val)
 {
-	nftnl_set_set(s, attr, &val);
+	nftnl_set_set_data(s, attr, &val, sizeof(uint32_t));
 }
 
 EXPORT_SYMBOL(nftnl_set_set_u64);
 void nftnl_set_set_u64(struct nftnl_set *s, uint16_t attr, uint64_t val)
 {
-	nftnl_set_set(s, attr, &val);
+	nftnl_set_set_data(s, attr, &val, sizeof(uint64_t));
 }
 
 EXPORT_SYMBOL(nftnl_set_set_str);
-- 
2.23.0

