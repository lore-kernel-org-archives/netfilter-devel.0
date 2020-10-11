Return-Path: <SRS0=sMKv=DS=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 078B6C433DF
	for <netfilter-devel@archiver.kernel.org>; Sun, 11 Oct 2020 19:23:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F1A221655
	for <netfilter-devel@archiver.kernel.org>; Sun, 11 Oct 2020 19:23:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="C3aYNUrc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726524AbgJKTXq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 11 Oct 2020 15:23:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726332AbgJKTXq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 11 Oct 2020 15:23:46 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16F46C0613D1
        for <netfilter-devel@vger.kernel.org>; Sun, 11 Oct 2020 12:23:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=bA4ZHL5KE+PITldOcgT4dXaAqQg/9QZyeGf0cJs2uxM=; b=C3aYNUrc4ERKtdOws5JlU90bKI
        qMqCRawLAxvLtGFGaHyQMdbi+xlZSOHnUXeBBXZK+Tik9lFo8jiGZRllYqrkZifnTjSgVD/ezlqkh
        YBOO0NcjOCBswQGdBakXcBEGBzwqwS2WSYhHQVH7HC5ENpwcZh70tCcAuYA/udZT7PnI/2WMW/XmQ
        vlfEtWwbB6Nu6WSzyPJfOkfIylsyDHpZ/crvgxJ0E3ZVC6bd23rhcyt3WlmAPY/+bgVUeEn8uHe4J
        Bpl8HGNokxkwIn5YjY/Tlyc+ZGsUACQwSPOHLa9RTuHXJR/bOTag8ezd0VXeVnkfBSd4MA3VK7WJQ
        2N90YNXg==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1kRgwX-00016N-Qy; Sun, 11 Oct 2020 20:23:41 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nft 2/3] tests: py: correct order of set elements in test JSON output.
Date:   Sun, 11 Oct 2020 20:23:23 +0100
Message-Id: <20201011192324.209237-3-jeremy@azazel.net>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201011192324.209237-1-jeremy@azazel.net>
References: <20201011192324.209237-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Fixes: 741a06ac15d2 ("mergesort: find base value expression type via recursion")
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 tests/py/any/ct.t.json.output | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/tests/py/any/ct.t.json.output b/tests/py/any/ct.t.json.output
index aced3817cf49..70ade7e38987 100644
--- a/tests/py/any/ct.t.json.output
+++ b/tests/py/any/ct.t.json.output
@@ -527,14 +527,14 @@
                 "set": [
                     {
                         "concat": [
-                            "established",
-                            309876276
+                            "new",
+                            305419896
                         ]
                     },
                     {
                         "concat": [
-                            "new",
-                            305419896
+                            "established",
+                            309876276
                         ]
                     },
                     {
@@ -611,23 +611,23 @@
                     [
                         {
                             "concat": [
-                                "established",
-                                2271560481
+                                "new",
+                                305419896
                             ]
                         },
                         {
-                            "accept": null
+                            "drop": null
                         }
                     ],
                     [
                         {
                             "concat": [
-                                "new",
-                                305419896
+                                "established",
+                                2271560481
                             ]
                         },
                         {
-                            "drop": null
+                            "accept": null
                         }
                     ]
                 ]
-- 
2.28.0

