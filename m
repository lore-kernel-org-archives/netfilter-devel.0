Return-Path: <SRS0=YpW3=ZI=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3988CC432C0
	for <netfilter-devel@archiver.kernel.org>; Sat, 16 Nov 2019 21:32:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 070D820730
	for <netfilter-devel@archiver.kernel.org>; Sat, 16 Nov 2019 21:32:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727485AbfKPVc1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 16 Nov 2019 16:32:27 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:58262 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727273AbfKPVc1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 16 Nov 2019 16:32:27 -0500
Received: from localhost ([::1]:43120 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iW5gA-0006Bl-7s; Sat, 16 Nov 2019 22:32:26 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH] tests/py: Set a fixed timezone in nft-test.py
Date:   Sat, 16 Nov 2019 22:32:18 +0100
Message-Id: <20191116213218.14698-1-phil@nwl.cc>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Payload generated for 'meta time' matches depends on host's timezone and
DST setting. To produce constant output, set a fixed timezone in
nft-test.py. Choose UTC-2 since most payloads are correct then, adjust
the remaining two tests.

Fixes: 0518ea3f70d8c ("tests: add meta time test cases")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/py/any/meta.t         | 2 +-
 tests/py/any/meta.t.payload | 2 +-
 tests/py/nft-test.py        | 1 +
 3 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/tests/py/any/meta.t b/tests/py/any/meta.t
index 86e5d258605dc..327f973f1bd5a 100644
--- a/tests/py/any/meta.t
+++ b/tests/py/any/meta.t
@@ -205,7 +205,7 @@ meta random eq 1;ok;meta random 1
 meta random gt 1000000;ok;meta random > 1000000
 
 meta time "1970-05-23 21:07:14" drop;ok
-meta time 12341234 drop;ok;meta time "1970-05-23 21:07:14" drop
+meta time 12341234 drop;ok;meta time "1970-05-23 22:07:14" drop
 meta time "2019-06-21 17:00:00" drop;ok
 meta time "2019-07-01 00:00:00" drop;ok
 meta time "2019-07-01 00:01:00" drop;ok
diff --git a/tests/py/any/meta.t.payload b/tests/py/any/meta.t.payload
index 402caae5cad8c..486d7aa566ea3 100644
--- a/tests/py/any/meta.t.payload
+++ b/tests/py/any/meta.t.payload
@@ -1050,7 +1050,7 @@ ip test-ip4 input
 # meta time "1970-05-23 21:07:14" drop
 ip meta-test input
   [ meta load time => reg 1 ]
-  [ cmp eq reg 1 0x74a8f400 0x002bd849 ]
+  [ cmp eq reg 1 0x43f05400 0x002bd503 ]
   [ immediate reg 0 drop ]
 
 # meta time 12341234 drop
diff --git a/tests/py/nft-test.py b/tests/py/nft-test.py
index ce42b5ddb1cca..6edca3c6a5a2f 100755
--- a/tests/py/nft-test.py
+++ b/tests/py/nft-test.py
@@ -24,6 +24,7 @@ import tempfile
 
 TESTS_PATH = os.path.dirname(os.path.abspath(__file__))
 sys.path.insert(0, os.path.join(TESTS_PATH, '../../py/'))
+os.environ['TZ'] = 'UTC-2'
 
 from nftables import Nftables
 
-- 
2.24.0

