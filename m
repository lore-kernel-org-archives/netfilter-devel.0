Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12565C4361B
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Dec 2020 10:12:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B521C207CC
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Dec 2020 10:12:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727175AbgLOKMQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 15 Dec 2020 05:12:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727167AbgLOKMI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Dec 2020 05:12:08 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAB07C06179C
        for <netfilter-devel@vger.kernel.org>; Tue, 15 Dec 2020 02:11:27 -0800 (PST)
Received: from localhost ([::1]:38774 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1kp7Ik-0001tO-1C; Tue, 15 Dec 2020 11:11:26 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH] tests: py: Fix for changed concatenated ranges output
Date:   Tue, 15 Dec 2020 11:11:36 +0100
Message-Id: <20201215101136.26010-1-phil@nwl.cc>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Payload didn't change but libnftnl was fixed to print the key_end data
reg of concat-range elements, too.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/py/inet/sets.t.payload.bridge | 2 +-
 tests/py/inet/sets.t.payload.inet   | 2 +-
 tests/py/inet/sets.t.payload.netdev | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tests/py/inet/sets.t.payload.bridge b/tests/py/inet/sets.t.payload.bridge
index 92f5417c0bee4..3dd9d57bc0ce8 100644
--- a/tests/py/inet/sets.t.payload.bridge
+++ b/tests/py/inet/sets.t.payload.bridge
@@ -29,7 +29,7 @@ bridge
 # ip daddr . tcp dport { 10.0.0.0/8 . 10-23, 192.168.1.1-192.168.3.8 . 80-443 } accept
 __set%d test-inet 87
 __set%d test-inet 0
-        element 0000000a 00000a00  : 0 [end]    element 0101a8c0 00005000  : 0 [end]
+        element 0000000a 00000a00  - ffffff0a 00001700  : 0 [end]    element 0101a8c0 00005000  - 0803a8c0 0000bb01  : 0 [end]
 bridge 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
diff --git a/tests/py/inet/sets.t.payload.inet b/tests/py/inet/sets.t.payload.inet
index bd6e1b0fe19d8..53c6b1821af7c 100644
--- a/tests/py/inet/sets.t.payload.inet
+++ b/tests/py/inet/sets.t.payload.inet
@@ -29,7 +29,7 @@ inet
 # ip daddr . tcp dport { 10.0.0.0/8 . 10-23, 192.168.1.1-192.168.3.8 . 80-443 } accept
 __set%d test-inet 87
 __set%d test-inet 0
-        element 0000000a 00000a00  : 0 [end]    element 0101a8c0 00005000  : 0 [end]
+        element 0000000a 00000a00  - ffffff0a 00001700  : 0 [end]    element 0101a8c0 00005000  - 0803a8c0 0000bb01  : 0 [end]
 inet 
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
diff --git a/tests/py/inet/sets.t.payload.netdev b/tests/py/inet/sets.t.payload.netdev
index f3032d8ef4abf..51938c858332a 100644
--- a/tests/py/inet/sets.t.payload.netdev
+++ b/tests/py/inet/sets.t.payload.netdev
@@ -29,7 +29,7 @@ inet
 # ip daddr . tcp dport { 10.0.0.0/8 . 10-23, 192.168.1.1-192.168.3.8 . 80-443 } accept
 __set%d test-netdev 87
 __set%d test-netdev 0
-        element 0000000a 00000a00  : 0 [end]    element 0101a8c0 00005000  : 0 [end]
+        element 0000000a 00000a00  - ffffff0a 00001700  : 0 [end]    element 0101a8c0 00005000  - 0803a8c0 0000bb01  : 0 [end]
 netdev 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
-- 
2.28.0

