Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A32F8C433F5
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Nov 2021 21:38:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8AA3C61215
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Nov 2021 21:38:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231142AbhKDVlg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 4 Nov 2021 17:41:36 -0400
Received: from mail.netfilter.org ([217.70.188.207]:38490 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232143AbhKDVlf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 4 Nov 2021 17:41:35 -0400
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 85F736083A
        for <netfilter-devel@vger.kernel.org>; Thu,  4 Nov 2021 22:37:00 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnftnl 2/2] set: use NFTNL_SET_ELEM_VERDICT to print verdict
Date:   Thu,  4 Nov 2021 22:38:11 +0100
Message-Id: <20211104213811.366540-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211104213811.366540-1-pablo@netfilter.org>
References: <20211104213811.366540-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch reworks 228e8b174627 ("set_elem: Fix printing of verdict map
elements"), check if NFTNL_SET_ELEM_VERDICT is set then print the set
element verdict.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/set_elem.h |  3 +--
 src/set.c          |  2 +-
 src/set_elem.c     | 13 +++++++------
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/set_elem.h b/include/set_elem.h
index 503dcede2c0d..76280051bb80 100644
--- a/include/set_elem.h
+++ b/include/set_elem.h
@@ -21,7 +21,6 @@ struct nftnl_set_elem {
 };
 
 int nftnl_set_elem_snprintf_default(char *buf, size_t size,
-				    const struct nftnl_set_elem *e,
-				    enum nft_data_types dtype);
+				    const struct nftnl_set_elem *e);
 
 #endif
diff --git a/src/set.c b/src/set.c
index 1c29dd26e88d..c46f8277ff68 100644
--- a/src/set.c
+++ b/src/set.c
@@ -829,7 +829,7 @@ static int nftnl_set_snprintf_default(char *buf, size_t remain,
 		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 		ret = nftnl_set_elem_snprintf_default(buf + offset, remain,
-						      elem, s->data_type);
+						      elem);
 		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 
diff --git a/src/set_elem.c b/src/set_elem.c
index edcc4a271b24..12eadce1f8e0 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -700,11 +700,9 @@ int nftnl_set_elem_parse_file(struct nftnl_set_elem *e, enum nftnl_parse_type ty
 }
 
 int nftnl_set_elem_snprintf_default(char *buf, size_t remain,
-				    const struct nftnl_set_elem *e,
-				    enum nft_data_types dtype)
+				    const struct nftnl_set_elem *e)
 {
-	int dregtype = (dtype == NFT_DATA_VERDICT) ? DATA_VERDICT : DATA_VALUE;
-	int ret, offset = 0, i;
+	int ret, dregtype = DATA_VALUE, offset = 0, i;
 
 	ret = snprintf(buf, remain, "element ");
 	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
@@ -725,6 +723,9 @@ int nftnl_set_elem_snprintf_default(char *buf, size_t remain,
 	ret = snprintf(buf + offset, remain, " : ");
 	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
+	if (e->flags & (1 << NFTNL_SET_ELEM_VERDICT))
+		dregtype = DATA_VERDICT;
+
 	ret = nftnl_data_reg_snprintf(buf + offset, remain, &e->data,
 				      DATA_F_NOPFX, dregtype);
 	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
@@ -761,9 +762,9 @@ static int nftnl_set_elem_cmd_snprintf(char *buf, size_t remain,
 	if (type != NFTNL_OUTPUT_DEFAULT)
 		return -1;
 
-	ret = nftnl_set_elem_snprintf_default(buf + offset, remain, e,
-					      NFT_DATA_VALUE);
+	ret = nftnl_set_elem_snprintf_default(buf + offset, remain, e);
 	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
+
 	return offset;
 }
 
-- 
2.30.2

