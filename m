From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nft] src: support ct l3proto/protocol without direction syntax
Date: Thu, 22 Sep 2016 22:34:52 +0800
Message-ID: <1474554892-50927-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-18.163.com ([220.181.12.18]:60378 "EHLO m12-18.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751263AbcIVOf2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 22 Sep 2016 10:35:28 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

Acctually, ct l3proto and ct protocol are unrelated to direction, so
it's unnecessary that we must specify dir if we want to use them.

Now add support that we can match ct l3proto/protocol without direction:
  # nft add rule filter input ct l3proto ipv4
  # nft add rule filter output ct protocol 17

Note: existing syntax is still preserved, so "ct reply l3proto ipv6"
is still fine.

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 src/parser_bison.y       | 2 ++
 tests/py/ip/ct.t         | 8 ++++----
 tests/py/ip/ct.t.payload | 8 ++++----
 3 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index aac10dc..36dbc8d 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -2513,6 +2513,8 @@ ct_key			:	STATE		{ $$ = NFT_CT_STATE; }
 			|	EXPIRATION	{ $$ = NFT_CT_EXPIRATION; }
 			|	HELPER		{ $$ = NFT_CT_HELPER; }
 			|	LABEL		{ $$ = NFT_CT_LABELS; }
+			|	L3PROTOCOL	{ $$ = NFT_CT_L3PROTOCOL; }
+			|	PROTOCOL	{ $$ = NFT_CT_PROTOCOL; }
 			|	ct_key_counters
 			;
 ct_key_dir		:	SADDR		{ $$ = NFT_CT_SRC; }
diff --git a/tests/py/ip/ct.t b/tests/py/ip/ct.t
index 65f5d92..d0f16c5 100644
--- a/tests/py/ip/ct.t
+++ b/tests/py/ip/ct.t
@@ -13,11 +13,11 @@ ct reply saddr 192.168.1.0/24;ok
 ct original daddr 192.168.1.0/24;ok
 ct reply daddr 192.168.1.0/24;ok
 
-ct original l3proto ipv4;ok
-ct reply l3proto foobar;fail
+ct l3proto ipv4;ok
+ct l3proto foobar;fail
 
-ct original protocol 6 ct original proto-dst 22;ok
-ct original protocol 17 ct reply proto-src 53;ok
+ct protocol 6 ct original proto-dst 22;ok
+ct original protocol 17 ct reply proto-src 53;ok;ct protocol 17 ct reply proto-src 53
 
 # wrong address family
 ct reply daddr dead::beef;fail
diff --git a/tests/py/ip/ct.t.payload b/tests/py/ip/ct.t.payload
index 0449b07..56633a2 100644
--- a/tests/py/ip/ct.t.payload
+++ b/tests/py/ip/ct.t.payload
@@ -42,14 +42,14 @@ ip test-ip4 output
   [ bitwise reg 1 = (reg=1 & 0x00ffffff ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x0001a8c0 ]
 
-# ct original l3proto ipv4
+# ct l3proto ipv4
 ip test-ip4 output
-  [ ct load l3protocol => reg 1 , dir original ]
+  [ ct load l3protocol => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
 
-# ct original protocol 6 ct original proto-dst 22
+# ct protocol 6 ct original proto-dst 22
 ip test-ip4 output
-  [ ct load protocol => reg 1 , dir original ]
+  [ ct load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ ct load proto_dst => reg 1 , dir original ]
   [ cmp eq reg 1 0x00001600 ]
-- 
2.5.5


