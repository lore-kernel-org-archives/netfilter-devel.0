Return-Path: <SRS0=ah1+=RK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BD23C43381
	for <netfilter-devel@archiver.kernel.org>; Thu,  7 Mar 2019 11:27:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EAC2E2081B
	for <netfilter-devel@archiver.kernel.org>; Thu,  7 Mar 2019 11:27:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726150AbfCGL1o (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 7 Mar 2019 06:27:44 -0500
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:56824 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726057AbfCGL1o (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 7 Mar 2019 06:27:44 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1h1rBe-0005Y3-EA; Thu, 07 Mar 2019 12:27:42 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH libnftnl] src: libnftnl: export genid functions again
Date:   Thu,  7 Mar 2019 12:15:40 +0100
Message-Id: <20190307111540.19907-1-fw@strlen.de>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Can't use them currently: they are exported only under their old names.

Fixes: 44d11498479a08 ("src: get rid of _attr_ infix in new nftnl_ definitions")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/libnftnl.map | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/src/libnftnl.map b/src/libnftnl.map
index 192eef81db2b..3c6f8631c1e6 100644
--- a/src/libnftnl.map
+++ b/src/libnftnl.map
@@ -214,14 +214,14 @@ global:
 
   nftnl_gen_alloc;
   nftnl_gen_free;
-  nftnl_gen_attr_is_set;
-  nftnl_gen_attr_unset;
-  nftnl_gen_attr_set_data;
-  nftnl_gen_attr_set;
-  nftnl_gen_attr_set_u32;
-  nftnl_gen_attr_get_data;
-  nftnl_gen_attr_get;
-  nftnl_gen_attr_get_u32;
+  nftnl_gen_is_set;
+  nftnl_gen_unset;
+  nftnl_gen_set_data;
+  nftnl_gen_set;
+  nftnl_gen_set_u32;
+  nftnl_gen_get_data;
+  nftnl_gen_get;
+  nftnl_gen_get_u32;
   nftnl_gen_nlmsg_parse;
   nftnl_gen_snprintf;
   nftnl_gen_fprintf;
-- 
2.19.2

