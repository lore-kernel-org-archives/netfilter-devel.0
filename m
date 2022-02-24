Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D98A0C433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 24 Feb 2022 19:46:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232230AbiBXTql (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 24 Feb 2022 14:46:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230043AbiBXTql (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Feb 2022 14:46:41 -0500
Received: from smtp.gentoo.org (smtp.gentoo.org [IPv6:2001:470:ea4a:1:5054:ff:fec7:86e4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60789227581
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Feb 2022 11:46:10 -0800 (PST)
From:   Sam James <sam@gentoo.org>
To:     netfilter-devel@vger.kernel.org
Cc:     Sam James <sam@gentoo.org>
Subject: [PATCH 1/2] libnftables.map: export new nft_ctx_{get,set}_optimize API
Date:   Thu, 24 Feb 2022 19:45:42 +0000
Message-Id: <20220224194543.59581-1-sam@gentoo.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Without this, we're not explicitly saying this is part of the public
API.

This new API was added in 1.0.2 and is used by e.g. the main
nft binary. Noticed when fixing the version-script option
(separate patch) which picked up this problem when .map
was missing symbols (related to when symbol visibility
options get set).

Signed-off-by: Sam James <sam@gentoo.org>
---
 src/libnftables.map | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/src/libnftables.map b/src/libnftables.map
index a511dd78..f8cf05dc 100644
--- a/src/libnftables.map
+++ b/src/libnftables.map
@@ -32,4 +32,6 @@ LIBNFTABLES_2 {
 LIBNFTABLES_3 {
   nft_set_optimize;
   nft_get_optimize;
+  nft_ctx_set_optimize;
+  nft_ctx_get_optimize;
 } LIBNFTABLES_2;
-- 
2.35.1

