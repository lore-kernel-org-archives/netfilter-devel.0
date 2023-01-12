Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63DA9C54EBE
	for <netfilter-devel@archiver.kernel.org>; Thu, 12 Jan 2023 18:05:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240269AbjALSFL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 12 Jan 2023 13:05:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240284AbjALSDo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 12 Jan 2023 13:03:44 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E9F65D888
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Jan 2023 09:28:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=d1B7x4fd6ZyWgtkmLaz3aNsG5muonZEelwCC4MgvQNM=; b=SLXtEflZ3amlFkwGyYxtDm12Kd
        lLqcNQ60rbfamGB+ocGhVD1SWm9ksijcjhCAs3CXNVdVdozHffDfJS0QOPYDJpYWG1rmKoKFQUCtd
        1FcfqjUrDcApgUsxqCkFLuXg6OkiMt7GXT4/8GU3R/M2M8F/xNAZplR/1pgwtUq4FbtjOY+YI8VqQ
        2wGtTlXoHEYaBgvD4PKeRdfaKUPtX1B5eZ7zGa05MafBIXDEf3YlRr1XZkzjXFBi2wqWgAjv2ny0W
        ge8j62E/qSlduwe2u4NEH1i0tNn993VKJcxJjqHch+X+eZn15A+z1rUVUiuHaxjvyofk27ygViK1p
        iD2Wsu+w==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1pG1Na-0000DJ-Q7; Thu, 12 Jan 2023 18:28:42 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 5/5] mnl: dump_nf_hooks() leaks memory in error path
Date:   Thu, 12 Jan 2023 18:28:23 +0100
Message-Id: <20230112172823.7298-6-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230112172823.7298-1-phil@nwl.cc>
References: <20230112172823.7298-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Have to free the basehook object before returning to caller.

Fixes: 4694f7230195b ("src: add support for base hook dumping")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/mnl.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/src/mnl.c b/src/mnl.c
index 62b0b59c2da8a..46d86f0fd9502 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -2217,16 +2217,23 @@ static int dump_nf_hooks(const struct nlmsghdr *nlh, void *_data)
 		struct nlattr *nested[NFNLA_HOOK_INFO_MAX + 1] = {};
 		uint32_t type;
 
-		if (mnl_attr_parse_nested(tb[NFNLA_HOOK_CHAIN_INFO], dump_nf_chain_info_cb, nested) < 0)
+		if (mnl_attr_parse_nested(tb[NFNLA_HOOK_CHAIN_INFO],
+					  dump_nf_chain_info_cb, nested) < 0) {
+			basehook_free(hook);
 			return -1;
+		}
 
 		type = ntohl(mnl_attr_get_u32(nested[NFNLA_HOOK_INFO_TYPE]));
 		if (type == NFNL_HOOK_TYPE_NFTABLES) {
 			struct nlattr *info[NFNLA_CHAIN_MAX + 1] = {};
 			const char *tablename, *chainname;
 
-			if (mnl_attr_parse_nested(nested[NFNLA_HOOK_INFO_DESC], dump_nf_attr_chain_cb, info) < 0)
+			if (mnl_attr_parse_nested(nested[NFNLA_HOOK_INFO_DESC],
+						  dump_nf_attr_chain_cb,
+						  info) < 0) {
+				basehook_free(hook);
 				return -1;
+			}
 
 			tablename = mnl_attr_get_str(info[NFNLA_CHAIN_TABLE]);
 			chainname = mnl_attr_get_str(info[NFNLA_CHAIN_NAME]);
-- 
2.38.0

