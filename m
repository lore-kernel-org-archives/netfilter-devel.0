From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 1/2] tests: sets: don't include listing in payload tests
Date: Tue, 18 Aug 2015 07:08:15 +0200
Message-ID: <1439874496-4852-1-git-send-email-pablo@netfilter.org>
Cc: fw@strlen.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56944 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750817AbbHRFCK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Aug 2015 01:02:10 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Since e715f6d1241c ("netlink: don't call netlink_dump_*() from listing
functions with --debug=netlink"), there is no debugging from the listing path.
Thus, we can remove the set line from the test files.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/regression/ip/sets.t.payload.inet  |    2 --
 tests/regression/ip/sets.t.payload.ip    |    2 --
 tests/regression/ip6/sets.t.payload.inet |    1 -
 tests/regression/ip6/sets.t.payload.ip6  |    1 -
 4 files changed, 6 deletions(-)

diff --git a/tests/regression/ip/sets.t.payload.inet b/tests/regression/ip/sets.t.payload.inet
index 9041781..f8e97cc 100644
--- a/tests/regression/ip/sets.t.payload.inet
+++ b/tests/regression/ip/sets.t.payload.inet
@@ -1,5 +1,4 @@
 # ip saddr @set1 drop
-set1 test-inet 0
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
@@ -8,7 +7,6 @@ inet test-inet input
   [ immediate reg 0 drop ]
 
 # ip saddr @set2 drop
-set2 test-inet 0
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
diff --git a/tests/regression/ip/sets.t.payload.ip b/tests/regression/ip/sets.t.payload.ip
index eb3770e..ece63d0 100644
--- a/tests/regression/ip/sets.t.payload.ip
+++ b/tests/regression/ip/sets.t.payload.ip
@@ -1,12 +1,10 @@
 # ip saddr @set1 drop
-set1 test-ip4 0
 ip test-ip4 input
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ lookup reg 1 set set1 ]
   [ immediate reg 0 drop ]
 
 # ip saddr @set2 drop
-set2 test-ip4 0
 ip test-ip4 input
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ lookup reg 1 set set2 ]
diff --git a/tests/regression/ip6/sets.t.payload.inet b/tests/regression/ip6/sets.t.payload.inet
index 11dae48..27be86b 100644
--- a/tests/regression/ip6/sets.t.payload.inet
+++ b/tests/regression/ip6/sets.t.payload.inet
@@ -1,5 +1,4 @@
 # ip6 saddr @set2 drop
-set2 test-inet 0
 inet test-inet input 
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
diff --git a/tests/regression/ip6/sets.t.payload.ip6 b/tests/regression/ip6/sets.t.payload.ip6
index 96b57f7..0e51fd3 100644
--- a/tests/regression/ip6/sets.t.payload.ip6
+++ b/tests/regression/ip6/sets.t.payload.ip6
@@ -1,5 +1,4 @@
 # ip6 saddr @set2 drop
-set2 test-ip6 0
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set set2 ]
-- 
1.7.10.4

