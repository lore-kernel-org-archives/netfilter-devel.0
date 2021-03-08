Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 784EEC433DB
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Mar 2021 14:46:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 43D1F61581
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Mar 2021 14:46:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbhCHOqQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 Mar 2021 09:46:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbhCHOp4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Mar 2021 09:45:56 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A376C06174A
        for <netfilter-devel@vger.kernel.org>; Mon,  8 Mar 2021 06:45:56 -0800 (PST)
Received: from localhost ([::1]:53592 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1lJH8s-0003qr-KN; Mon, 08 Mar 2021 15:45:54 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH] tests/py: Fix for missing JSON equivalent in any/ct.t.json
Date:   Mon,  8 Mar 2021 15:45:46 +0100
Message-Id: <20210308144546.15311-1-phil@nwl.cc>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

JSON equivalent for recently added test of the '!' shortcut was missing.

Fixes: e6c32b2fa0b82 ("src: add negation match on singleton bitmask value")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/py/any/ct.t.json | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/tests/py/any/ct.t.json b/tests/py/any/ct.t.json
index d429ae73ea5cc..6684963b6609c 100644
--- a/tests/py/any/ct.t.json
+++ b/tests/py/any/ct.t.json
@@ -387,6 +387,21 @@
     }
 ]
 
+# ct status ! dnat
+[
+    {
+        "match": {
+            "left": {
+                "ct": {
+                    "key": "status"
+                }
+            },
+            "op": "!",
+            "right": "dnat"
+        }
+    }
+]
+
 # ct mark 0
 [
     {
-- 
2.30.1

