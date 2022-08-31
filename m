Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11166ECAAD4
	for <netfilter-devel@archiver.kernel.org>; Wed, 31 Aug 2022 14:59:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbiHaO7g (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 31 Aug 2022 10:59:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230355AbiHaO7f (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 31 Aug 2022 10:59:35 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E4D05D5983
        for <netfilter-devel@vger.kernel.org>; Wed, 31 Aug 2022 07:59:27 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] tests/py: missing userdata in netlink payload
Date:   Wed, 31 Aug 2022 16:59:22 +0200
Message-Id: <20220831145922.3052-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Since libnftnl's 212479ad2c92 ("rule, set_elem: fix printing of user
data"), userdata is missing in netlink payload printing via --debug.
Update tests/py/ip6/srh.t.payload to silence warning.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/py/ip6/srh.t.payload | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tests/py/ip6/srh.t.payload b/tests/py/ip6/srh.t.payload
index b6247456eb72..364940a95ee6 100644
--- a/tests/py/ip6/srh.t.payload
+++ b/tests/py/ip6/srh.t.payload
@@ -11,7 +11,7 @@ ip6 test-ip6 input
 # srh last-entry { 0, 4-127, 255 }
 __set%d test-ip6 7 size 5
 __set%d test-ip6 0
-	element 00000000  : 0 [end]	element 00000001  : 1 [end]	element 00000004  : 0 [end]	element 00000080  : 1 [end]	element 000000ff  : 0 [end]  userdata = {
+	element 00000000  : 0 [end]	element 00000001  : 1 [end]	element 00000004  : 0 [end]	element 00000080  : 1 [end]	element 000000ff  : 0 [end]  userdata = { \x01\x04\x01\x00\x00\x00 }
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 43 + 4 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -29,7 +29,7 @@ ip6 test-ip6 input
 # srh flags { 0, 4-127, 255 }
 __set%d test-ip6 7 size 5
 __set%d test-ip6 0
-	element 00000000  : 0 [end]	element 00000001  : 1 [end]	element 00000004  : 0 [end]	element 00000080  : 1 [end]	element 000000ff  : 0 [end]  userdata = {
+	element 00000000  : 0 [end]	element 00000001  : 1 [end]	element 00000004  : 0 [end]	element 00000080  : 1 [end]	element 000000ff  : 0 [end]  userdata = { \x01\x04\x01\x00\x00\x00 }
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 43 + 5 => reg 1 ]
   [ lookup reg 1 set __set%d ]
@@ -47,7 +47,7 @@ ip6 test-ip6 input
 # srh tag { 0, 4-127, 0xffff }
 __set%d test-ip6 7 size 5
 __set%d test-ip6 0
-	element 00000000  : 0 [end]	element 00000100  : 1 [end]	element 00000400  : 0 [end]	element 00008000  : 1 [end]	element 0000ffff  : 0 [end]  userdata = {
+	element 00000000  : 0 [end]	element 00000100  : 1 [end]	element 00000400  : 0 [end]	element 00008000  : 1 [end]	element 0000ffff  : 0 [end]  userdata = { \x01\x04\x01\x00\x00\x00 }
 ip6 test-ip6 input
   [ exthdr load ipv6 2b @ 43 + 6 => reg 1 ]
   [ lookup reg 1 set __set%d ]
-- 
2.30.2

