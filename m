Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8856C433DB
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Mar 2021 14:43:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3EDF651AF
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Mar 2021 14:43:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbhCHOm3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 Mar 2021 09:42:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231308AbhCHOmY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Mar 2021 09:42:24 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D8F2C06174A
        for <netfilter-devel@vger.kernel.org>; Mon,  8 Mar 2021 06:42:24 -0800 (PST)
Received: from localhost ([::1]:53574 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1lJH5T-0003oU-2K; Mon, 08 Mar 2021 15:42:23 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [libnftnl PATCH] set_elem: Fix printing of verdict map elements
Date:   Mon,  8 Mar 2021 15:42:14 +0100
Message-Id: <20210308144214.13146-1-phil@nwl.cc>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Elements' data was printed as type DATA_VALUE no matter the actual type.
For verdicts, this meant no printing at all (because reg->len is either
zero or garbage).

To fix this, nftnl_set_elem_snprintf_default() needs type info held in
struct nftnl_set. Pass it via parameter to that function, make it
non-static and call it from nftnl_set_snprintf_default() instead of the
generic nftnl_set_elem_snprintf(). This way no changes have to be done
to exported functions, also the output type is already defined when
nftnl_set_snprintf_default() runs so checking type value again is
pointless.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/set_elem.h |  4 ++++
 src/set.c          |  4 ++--
 src/set_elem.c     | 12 ++++++++----
 3 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/include/set_elem.h b/include/set_elem.h
index 9239557469feb..503dcede2c0d2 100644
--- a/include/set_elem.h
+++ b/include/set_elem.h
@@ -20,4 +20,8 @@ struct nftnl_set_elem {
 	} user;
 };
 
+int nftnl_set_elem_snprintf_default(char *buf, size_t size,
+				    const struct nftnl_set_elem *e,
+				    enum nft_data_types dtype);
+
 #endif
diff --git a/src/set.c b/src/set.c
index 8c5025d16206b..a21df1fa50f41 100644
--- a/src/set.c
+++ b/src/set.c
@@ -829,8 +829,8 @@ static int nftnl_set_snprintf_default(char *buf, size_t size,
 		ret = snprintf(buf + offset, remain, "\t");
 		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
-		ret = nftnl_set_elem_snprintf(buf + offset, remain, elem, type,
-					      flags);
+		ret = nftnl_set_elem_snprintf_default(buf + offset, remain,
+						      elem, s->data_type);
 		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 
diff --git a/src/set_elem.c b/src/set_elem.c
index 8f634e756a1b9..ad528e28475a7 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -698,9 +698,12 @@ int nftnl_set_elem_parse_file(struct nftnl_set_elem *e, enum nftnl_parse_type ty
 	return -1;
 }
 
-static int nftnl_set_elem_snprintf_default(char *buf, size_t size,
-					   const struct nftnl_set_elem *e)
+int nftnl_set_elem_snprintf_default(char *buf, size_t size,
+				    const struct nftnl_set_elem *e,
+				    enum nft_data_types dtype)
 {
+	int dregtype = (dtype == NFT_DATA_VERDICT) ? DATA_VERDICT : DATA_VALUE;
+
 	int ret, remain = size, offset = 0, i;
 
 	ret = snprintf(buf, remain, "element ");
@@ -726,7 +729,7 @@ static int nftnl_set_elem_snprintf_default(char *buf, size_t size,
 
 	ret = nftnl_data_reg_snprintf(buf + offset, remain, &e->data,
 				      NFTNL_OUTPUT_DEFAULT,
-				      DATA_F_NOPFX, DATA_VALUE);
+				      DATA_F_NOPFX, dregtype);
 	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	ret = snprintf(buf + offset, remain, "%u [end]", e->set_elem_flags);
@@ -760,7 +763,8 @@ static int nftnl_set_elem_cmd_snprintf(char *buf, size_t size,
 
 	switch(type) {
 	case NFTNL_OUTPUT_DEFAULT:
-		ret = nftnl_set_elem_snprintf_default(buf + offset, remain, e);
+		ret = nftnl_set_elem_snprintf_default(buf + offset, remain, e,
+						      NFT_DATA_VALUE);
 		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 		break;
 	case NFTNL_OUTPUT_XML:
-- 
2.30.1

