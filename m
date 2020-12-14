Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8690C4361B
	for <netfilter-devel@archiver.kernel.org>; Mon, 14 Dec 2020 18:04:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6BD312246B
	for <netfilter-devel@archiver.kernel.org>; Mon, 14 Dec 2020 18:04:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408767AbgLNSEd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 14 Dec 2020 13:04:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408303AbgLNSDW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 14 Dec 2020 13:03:22 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7933DC061794
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Dec 2020 10:02:42 -0800 (PST)
Received: from localhost ([::1]:36832 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1kosBE-0003f1-Eq; Mon, 14 Dec 2020 19:02:40 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [libnftnl PATCH 2/2] set_elem: Include key_end data reg in print output
Date:   Mon, 14 Dec 2020 19:02:51 +0100
Message-Id: <20201214180251.11408-2-phil@nwl.cc>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201214180251.11408-1-phil@nwl.cc>
References: <20201214180251.11408-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Elements of concatenated range sets hold the upper boundary in an extra
data_reg, print it using dash as a somewhat intuitive separator.

Fixes: 04cc28d8d6923 ("set_elem: Introduce support for NFTNL_SET_ELEM_KEY_END")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/set_elem.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/src/set_elem.c b/src/set_elem.c
index 51bf2c7b853bb..46bb0623a3bb3 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -634,6 +634,16 @@ static int nftnl_set_elem_snprintf_default(char *buf, size_t size,
 				      DATA_F_NOPFX, DATA_VALUE);
 	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
+	if (e->flags & (1 << NFTNL_SET_ELEM_KEY_END)) {
+		ret = snprintf(buf + offset, remain, " - ");
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
+
+		ret = nftnl_data_reg_snprintf(buf + offset, remain, &e->key_end,
+					      NFTNL_OUTPUT_DEFAULT,
+					      DATA_F_NOPFX, DATA_VALUE);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
+	}
+
 	ret = snprintf(buf + offset, remain, " : ");
 	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
-- 
2.28.0

