Return-Path: <SRS0=SDnU=YX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EC15CA9EC5
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Oct 2019 17:49:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA82B20659
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Oct 2019 17:49:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727538AbfJ3Rt6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 30 Oct 2019 13:49:58 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:45218 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726740AbfJ3Rt6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Oct 2019 13:49:58 -0400
Received: from localhost ([::1]:58308 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iPs6X-00080V-Ca; Wed, 30 Oct 2019 18:49:57 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [libnftnl PATCH 1/2] libnftnl.map: Export nftnl_{obj,flowtable}_set_data()
Date:   Wed, 30 Oct 2019 18:49:47 +0100
Message-Id: <20191030174948.12493-1-phil@nwl.cc>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

In order to deprecate nftnl_{obj,flowtable}_set() functions, these must
to be made available.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/libnftnl.map | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/src/libnftnl.map b/src/libnftnl.map
index 3ddb9468c96c3..e810c4de445f3 100644
--- a/src/libnftnl.map
+++ b/src/libnftnl.map
@@ -354,4 +354,6 @@ LIBNFTNL_12 {
 
 LIBNFTNL_13 {
   nftnl_set_list_lookup_byname;
+  nftnl_obj_set_data;
+  nftnl_flowtable_set_data;
 } LIBNFTNL_12;
-- 
2.23.0

