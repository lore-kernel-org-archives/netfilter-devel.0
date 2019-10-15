Return-Path: <SRS0=TYlN=YI=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A87DDECE588
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Oct 2019 14:17:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7745120650
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Oct 2019 14:17:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732394AbfJOORN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 15 Oct 2019 10:17:13 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:36882 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731553AbfJOORN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Oct 2019 10:17:13 -0400
Received: from localhost ([::1]:49972 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iKNdQ-00037B-2X; Tue, 15 Oct 2019 16:17:12 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [libnftnl PATCH 5/6] obj/ct_timeout: Avoid array overrun in timeout_parse_attr_data()
Date:   Tue, 15 Oct 2019 16:16:57 +0200
Message-Id: <20191015141658.11325-6-phil@nwl.cc>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191015141658.11325-1-phil@nwl.cc>
References: <20191015141658.11325-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Array 'tb' has only 'attr_max' elements, the loop overstepped its
boundary by one. Copy array_size() macro from include/utils.h in
nftables.git to make sure code does the right thing.

Fixes: 0adceeab1597a ("src: add ct timeout support")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/utils.h      | 8 ++++++++
 src/obj/ct_timeout.c | 2 +-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/include/utils.h b/include/utils.h
index 3cc659652fe2e..91fbebb1956fd 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -58,6 +58,14 @@ void __nftnl_assert_attr_exists(uint16_t attr, uint16_t attr_max,
 		ret = remain;				\
 	remain -= ret;					\
 
+
+#define BUILD_BUG_ON_ZERO(e)	(sizeof(char[1 - 2 * !!(e)]) - 1)
+
+#define __must_be_array(a) \
+	BUILD_BUG_ON_ZERO(__builtin_types_compatible_p(typeof(a), typeof(&a[0])))
+
+#define array_size(arr)		(sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
+
 const char *nftnl_family2str(uint32_t family);
 int nftnl_str2family(const char *family);
 
diff --git a/src/obj/ct_timeout.c b/src/obj/ct_timeout.c
index a439432deee18..a09e25ae5d44f 100644
--- a/src/obj/ct_timeout.c
+++ b/src/obj/ct_timeout.c
@@ -134,7 +134,7 @@ timeout_parse_attr_data(struct nftnl_obj *e,
 	if (mnl_attr_parse_nested(nest, parse_timeout_attr_policy_cb, &cnt) < 0)
 		return -1;
 
-	for (i = 1; i <= attr_max; i++) {
+	for (i = 1; i < array_size(tb); i++) {
 		if (tb[i]) {
 			nftnl_timeout_policy_attr_set_u32(e, i-1,
 				ntohl(mnl_attr_get_u32(tb[i])));
-- 
2.23.0

