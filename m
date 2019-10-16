Return-Path: <SRS0=cZSN=YJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1BE7ECE599
	for <netfilter-devel@archiver.kernel.org>; Wed, 16 Oct 2019 22:58:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 973BB207FF
	for <netfilter-devel@archiver.kernel.org>; Wed, 16 Oct 2019 22:58:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391366AbfJPW63 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 16 Oct 2019 18:58:29 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:40176 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726965AbfJPW63 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 16 Oct 2019 18:58:29 -0400
Received: from localhost ([::1]:53266 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iKsFP-0005av-2Q; Thu, 17 Oct 2019 00:58:27 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [libnftnl PATCH] obj/ct_timeout: Fix NFTA_CT_TIMEOUT_DATA parser
Date:   Thu, 17 Oct 2019 00:58:18 +0200
Message-Id: <20191016225818.23842-1-phil@nwl.cc>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is a necessary follow-up on commit 00b144bc9d093 ("obj/ct_timeout:
Avoid array overrun in timeout_parse_attr_data()") which fixed array out
of bounds access but missed the logic behind it:

The nested attribute type values are incremented by one when being
transferred between kernel and userspace, the zero type value is
reserved for "unspecified".

Kernel uses CTA_TIMEOUT_* symbols for that, libnftnl simply mangles the
type values in nftnl_obj_ct_timeout_build().

Return path was broken as it overstepped its nlattr array but apart from
that worked: Type values were decremented by one in
timeout_parse_attr_data().

This patch moves the type value mangling into
parse_timeout_attr_policy_cb() (which still overstepped nlattr array).
Consequently, when copying values from nlattr array into ct timeout
object in timeout_parse_attr_data(), loop is adjusted to start at index
0 and the type value decrement is dropped there.

Fixes: 0adceeab1597a ("src: add ct timeout support")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/obj/ct_timeout.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/src/obj/ct_timeout.c b/src/obj/ct_timeout.c
index a09e25ae5d44f..2662cac69438d 100644
--- a/src/obj/ct_timeout.c
+++ b/src/obj/ct_timeout.c
@@ -108,10 +108,10 @@ parse_timeout_attr_policy_cb(const struct nlattr *attr, void *data)
 	if (mnl_attr_type_valid(attr, data_cb->nlattr_max) < 0)
 		return MNL_CB_OK;
 
-	if (type <= data_cb->nlattr_max) {
+	if (type > 0 && type <= data_cb->nlattr_max) {
 		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
 			abi_breakage();
-		tb[type] = attr;
+		tb[type - 1] = attr;
 	}
 	return MNL_CB_OK;
 }
@@ -134,9 +134,9 @@ timeout_parse_attr_data(struct nftnl_obj *e,
 	if (mnl_attr_parse_nested(nest, parse_timeout_attr_policy_cb, &cnt) < 0)
 		return -1;
 
-	for (i = 1; i < array_size(tb); i++) {
+	for (i = 0; i < array_size(tb); i++) {
 		if (tb[i]) {
-			nftnl_timeout_policy_attr_set_u32(e, i-1,
+			nftnl_timeout_policy_attr_set_u32(e, i,
 				ntohl(mnl_attr_get_u32(tb[i])));
 		}
 	}
-- 
2.23.0

