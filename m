From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 2/3] tests: catch ordering issue w. ether set
Date: Fri,  9 Sep 2016 14:43:15 +0200
Message-ID: <1473424996-26957-3-git-send-email-fw@strlen.de>
References: <1473424996-26957-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:48764 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753033AbcIIMnH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 9 Sep 2016 08:43:07 -0400
In-Reply-To: <1473424996-26957-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Before previous commit, ether set (payload statement) was reversed on
output:

ether daddr set 00:03:2d:2b:74:ec

would be shown as 'ec:74:2b:2d:03:00'.

With ff:ff:ff ... such bug doesn't appear so use something
where it will show up.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/py/bridge/ether.t         | 2 +-
 tests/py/bridge/ether.t.payload | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tests/py/bridge/ether.t b/tests/py/bridge/ether.t
index 4a177ab..5c6766e 100644
--- a/tests/py/bridge/ether.t
+++ b/tests/py/bridge/ether.t
@@ -7,4 +7,4 @@ tcp dport 22 ip daddr 1.2.3.4 ether saddr 00:0f:54:0c:11:04;ok;tcp dport 22 ethe
 tcp dport 22 ether saddr 00:0f:54:0c:11:04 ip daddr 1.2.3.4;ok
 ether saddr 00:0f:54:0c:11:04 ip daddr 1.2.3.4 accept;ok
 
-ether daddr 00:01:02:03:04:05 ether saddr set ff:ff:ff:ff:ff:ff drop;ok
+ether daddr 00:01:02:03:04:05 ether saddr set ff:fe:dc:ba:98:76 drop;ok
diff --git a/tests/py/bridge/ether.t.payload b/tests/py/bridge/ether.t.payload
index c545d65..74956b6 100644
--- a/tests/py/bridge/ether.t.payload
+++ b/tests/py/bridge/ether.t.payload
@@ -42,11 +42,11 @@ bridge test-bridge input
   [ cmp eq reg 1 0x04030201 ]
   [ immediate reg 0 accept ]
 
-# ether daddr 00:01:02:03:04:05 ether saddr set ff:ff:ff:ff:ff:ff drop
+# ether daddr 00:01:02:03:04:05 ether saddr set ff:fe:dc:ba:98:76 drop
 bridge test-bridge input
   [ payload load 6b @ link header + 0 => reg 1 ]
   [ cmp eq reg 1 0x03020100 0x00000504 ]
-  [ immediate reg 1 0xffffffff 0x0000ffff ]
+  [ immediate reg 1 0xbadcfeff 0x00007698 ]
   [ payload write reg 1 => 6b @ link header + 6 csum_type 0 csum_off 0 ]
   [ immediate reg 0 drop ]
 
-- 
2.7.3

