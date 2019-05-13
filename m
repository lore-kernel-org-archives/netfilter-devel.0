Return-Path: <SRS0=R8c+=TN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96E64C04AA7
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 May 2019 17:11:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 71FFB208C2
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 May 2019 17:11:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730862AbfEMRL7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 13 May 2019 13:11:59 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:46034 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726548AbfEMRL7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 May 2019 13:11:59 -0400
Received: from localhost ([::1]:59124 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1hQEUX-0005Tq-HP; Mon, 13 May 2019 19:11:57 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [libnftnl PATCH] include: Remove redundant declaration of nftnl_gen_nlmsg_parse()
Date:   Mon, 13 May 2019 19:11:59 +0200
Message-Id: <20190513171159.18090-1-phil@nwl.cc>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The duplicated declaration was there since the functions initial
introduction as 'nft_gen_nlmsg_parse()'.

Fixes: 2e66fb09d6936 ("src: add ruleset generation class")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/libnftnl/gen.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/libnftnl/gen.h b/include/libnftnl/gen.h
index b55bdedb83597..c56a63ca2508b 100644
--- a/include/libnftnl/gen.h
+++ b/include/libnftnl/gen.h
@@ -42,7 +42,6 @@ int nftnl_gen_snprintf(char *buf, size_t size, const struct nftnl_gen *gen, uint
 int nftnl_gen_fprintf(FILE *fp, const struct nftnl_gen *gen, uint32_t type, uint32_t flags);
 
 #define nftnl_gen_nlmsg_build_hdr	nftnl_nlmsg_build_hdr
-int nftnl_gen_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_gen *gen);
 
 #ifdef __cplusplus
 } /* extern "C" */
-- 
2.21.0

