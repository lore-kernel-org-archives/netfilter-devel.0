Return-Path: <SRS0=/ozj=TY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37320C072B5
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 May 2019 19:13:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E482B2175B
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 May 2019 19:13:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391503AbfEXTNM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 24 May 2019 15:13:12 -0400
Received: from mail.us.es ([193.147.175.20]:55240 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391131AbfEXTNM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 May 2019 15:13:12 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 00E5FF2685
        for <netfilter-devel@vger.kernel.org>; Fri, 24 May 2019 21:13:04 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E06B3DA704
        for <netfilter-devel@vger.kernel.org>; Fri, 24 May 2019 21:13:03 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D5F01DA701; Fri, 24 May 2019 21:13:03 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B7B65DA704;
        Fri, 24 May 2019 21:13:00 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 24 May 2019 21:13:00 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [31.4.219.201])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 71AF04265A32;
        Fri, 24 May 2019 21:13:00 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de
Subject: [PATCH nft] tests: replace single element sets
Date:   Fri, 24 May 2019 21:12:56 +0200
Message-Id: <20190524191256.10384-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add at least two elements to sets.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
Needs to revert two recent commits upstream to apply this.

 tests/py/any/ct.t                                  |   9 +-
 tests/py/any/ct.t.payload                          |  52 +--
 tests/py/any/meta.t                                |  30 +-
 tests/py/any/meta.t.payload                        | 386 +++++++++++----------
 tests/shell/testcases/cache/0001_cache_handling_0  |   4 +-
 .../cache/dumps/0001_cache_handling_0.nft          |   6 +-
 tests/shell/testcases/listing/0011sets_0           |   8 +-
 tests/shell/testcases/netns/0001nft-f_0            |   6 +-
 tests/shell/testcases/netns/0002loosecommands_0    |   4 +-
 tests/shell/testcases/netns/0003many_0             |   6 +-
 tests/shell/testcases/nft-f/0002rollback_rule_0    |   2 +-
 tests/shell/testcases/nft-f/0003rollback_jump_0    |   2 +-
 tests/shell/testcases/nft-f/0004rollback_set_0     |   2 +-
 tests/shell/testcases/nft-f/0005rollback_map_0     |   2 +-
 tests/shell/testcases/nft-f/0006action_object_0    |   4 +-
 tests/shell/testcases/nft-f/0016redefines_1        |   4 +-
 .../testcases/nft-f/dumps/0002rollback_rule_0.nft  |   2 +-
 .../testcases/nft-f/dumps/0003rollback_jump_0.nft  |   2 +-
 .../testcases/nft-f/dumps/0004rollback_set_0.nft   |   2 +-
 .../testcases/nft-f/dumps/0005rollback_map_0.nft   |   2 +-
 tests/shell/testcases/sets/0021nesting_0           |   1 +
 21 files changed, 280 insertions(+), 256 deletions(-)

diff --git a/tests/py/any/ct.t b/tests/py/any/ct.t
index b5c13524408f..81d937d97ac9 100644
--- a/tests/py/any/ct.t
+++ b/tests/py/any/ct.t
@@ -73,17 +73,16 @@ ct expiration 33-45;ok;ct expiration 33s-45s
 ct expiration != 33-45;ok;ct expiration != 33s-45s
 ct expiration {33, 55, 67, 88};ok;ct expiration { 1m7s, 33s, 55s, 1m28s}
 ct expiration != {33, 55, 67, 88};ok;ct expiration != { 1m7s, 33s, 55s, 1m28s}
-ct expiration {33-55};ok;ct expiration { 33s-55s}
-ct expiration != {33-55};ok;ct expiration != { 33s-55s}
+ct expiration {33-55, 66-88};ok;ct expiration { 33s-55s, 1m6s-1m28s}
+ct expiration != {33-55, 66-88};ok;ct expiration != { 33s-55s, 1m6s-1m28s}
 
 ct helper "ftp";ok
 ct helper "12345678901234567";fail
 ct helper "";fail
 
-ct state . ct mark { new . 0x12345678};ok
 ct state . ct mark { new . 0x12345678, new . 0x34127856, established . 0x12785634};ok
-ct direction . ct mark { original . 0x12345678};ok
-ct state . ct mark vmap { new . 0x12345678 : drop};ok
+ct direction . ct mark { original . 0x12345678, reply . 0x87654321};ok
+ct state . ct mark vmap { new . 0x12345678 : drop, established . 0x87654321 : accept};ok
 
 ct original bytes > 100000;ok
 ct reply packets < 100;ok
diff --git a/tests/py/any/ct.t.payload b/tests/py/any/ct.t.payload
index 9338466d5df4..86ac81cd729d 100644
--- a/tests/py/any/ct.t.payload
+++ b/tests/py/any/ct.t.payload
@@ -283,20 +283,20 @@ ip test-ip4 output
   [ ct load expiration => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# ct expiration {33-55}
-__set%d test-ip4 7
+# ct expiration {33-55, 66-88}
+__set%d test-ip4 7 size 5
 __set%d test-ip4 0
-	element 00000000  : 1 [end]	element e8800000  : 0 [end]	element d9d60000  : 1 [end]
-ip test-ip4 output
+	element 00000000  : 1 [end]	element e8800000  : 0 [end]	element d9d60000  : 1 [end]	element d0010100  : 0 [end]	element c1570100  : 1 [end]
+ip test-ip4 output 
   [ ct load expiration => reg 1 ]
   [ byteorder reg 1 = hton(reg 1, 4, 4) ]
   [ lookup reg 1 set __set%d ]
 
-# ct expiration != {33-55}
-__set%d test-ip4 7
+# ct expiration != {33-55, 66-88}
+__set%d test-ip4 7 size 5
 __set%d test-ip4 0
-	element 00000000  : 1 [end]	element e8800000  : 0 [end]	element d9d60000  : 1 [end]
-ip test-ip4 output
+	element 00000000  : 1 [end]	element e8800000  : 0 [end]	element d9d60000  : 1 [end]	element d0010100  : 0 [end]	element c1570100  : 1 [end]
+ip test-ip4 output 
   [ ct load expiration => reg 1 ]
   [ byteorder reg 1 = hton(reg 1, 4, 4) ]
   [ lookup reg 1 set __set%d 0x1 ]
@@ -324,24 +324,6 @@ ip test-ip4 output
   [ ct load mark => reg 9 ]
   [ lookup reg 1 set __set%d ]
 
-# ct direction . ct mark { original . 0x12345678}
-__set%d test 3
-__set%d test 0
-	element 00000000 12345678  : 0 [end]
-ip test-ip4 output
-  [ ct load direction => reg 1 ]
-  [ ct load mark => reg 9 ]
-  [ lookup reg 1 set __set%d ]
-
-# ct state . ct mark vmap { new . 0x12345678 : drop}
-__map%d test-ip4 b
-__map%d test-ip4 0
-	element 00000008 12345678  : 0 [end]
-ip test-ip4 output
-  [ ct load state => reg 1 ]
-  [ ct load mark => reg 9 ]
-  [ lookup reg 1 set __map%d dreg 0 ]
-
 # ct mark set mark
 ip test-ip4 output
   [ meta load mark => reg 1 ]
@@ -493,3 +475,21 @@ ip test-ip4 output
 ip test-ip4 output
   [ notrack ]
 
+# ct direction . ct mark { original . 0x12345678, reply . 0x87654321}
+__set%d test-ip4 3 size 2
+__set%d test-ip4 0
+	element 00000000 12345678  : 0 [end]	element 00000001 87654321  : 0 [end]
+ip test-ip4 output 
+  [ ct load direction => reg 1 ]
+  [ ct load mark => reg 9 ]
+  [ lookup reg 1 set __set%d ]
+
+# ct state . ct mark vmap { new . 0x12345678 : drop, established . 0x87654321 : accept}
+__map%d test-ip4 b size 2
+__map%d test-ip4 0
+	element 00000008 12345678  : 0 [end]	element 00000002 87654321  : 0 [end]
+ip test-ip4 output 
+  [ ct load state => reg 1 ]
+  [ ct load mark => reg 9 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
+
diff --git a/tests/py/any/meta.t b/tests/py/any/meta.t
index d69b8b4eaf0b..4b3c604de110 100644
--- a/tests/py/any/meta.t
+++ b/tests/py/any/meta.t
@@ -17,8 +17,8 @@ meta length { 33, 55, 67, 88};ok
 meta length { 33-55, 67-88};ok
 meta length { 33-55, 56-88, 100-120};ok;meta length { 33-88, 100-120}
 meta length != { 33, 55, 67, 88};ok
-meta length { 33-55};ok
-meta length != { 33-55};ok
+meta length { 33-55, 66-88};ok
+meta length != { 33-55, 66-88};ok
 
 meta protocol { ip, arp, ip6, vlan };ok;meta protocol { ip6, ip, vlan, arp}
 meta protocol != {ip, arp, ip6, vlan};ok
@@ -31,8 +31,8 @@ meta l4proto 33-45;ok
 meta l4proto != 33-45;ok
 meta l4proto { 33, 55, 67, 88};ok;meta l4proto { 33, 55, 67, 88}
 meta l4proto != { 33, 55, 67, 88};ok
-meta l4proto { 33-55};ok
-meta l4proto != { 33-55};ok
+meta l4proto { 33-55, 66-88};ok
+meta l4proto != { 33-55, 66-88};ok
 
 meta priority root;ok
 meta priority none;ok
@@ -81,8 +81,6 @@ meta iiftype ppp;ok
 
 meta oif "lo" accept;ok;oif "lo" accept
 meta oif != "lo" accept;ok;oif != "lo" accept
-meta oif {"lo"} accept;ok;oif {"lo"} accept
-meta oif != {"lo"} accept;ok;oif != {"lo"} accept
 
 meta oifname "dummy0";ok;oifname "dummy0"
 meta oifname != "dummy0";ok;oifname != "dummy0"
@@ -105,8 +103,8 @@ meta skuid gt 3000 accept;ok;meta skuid > 3000 accept
 meta skuid eq 3000 accept;ok;meta skuid 3000 accept
 meta skuid 3001-3005 accept;ok;meta skuid 3001-3005 accept
 meta skuid != 2001-2005 accept;ok;meta skuid != 2001-2005 accept
-meta skuid { 2001-2005} accept;ok;meta skuid { 2001-2005} accept
-meta skuid != { 2001-2005} accept;ok;meta skuid != { 2001-2005} accept
+meta skuid { 2001-2005, 3001-3005} accept;ok;meta skuid { 2001-2005, 3001-3005} accept
+meta skuid != { 2001-2005, 3001-3005} accept;ok;meta skuid != { 2001-2005, 3001-3005} accept
 
 meta skgid {"bin", "root", "daemon"} accept;ok;meta skgid { 0, 1, 2} accept
 meta skgid != {"bin", "root", "daemon"} accept;ok;meta skgid != { 1, 0, 2} accept
@@ -173,22 +171,22 @@ meta iifgroup 0;ok;iifgroup "default"
 meta iifgroup != 0;ok;iifgroup != "default"
 meta iifgroup "default";ok;iifgroup "default"
 meta iifgroup != "default";ok;iifgroup != "default"
-meta iifgroup {"default"};ok;iifgroup {"default"}
-meta iifgroup != {"default"};ok;iifgroup != {"default"}
+meta iifgroup {"default", 11};ok;iifgroup {"default", 11}
+meta iifgroup != {"default", 11};ok;iifgroup != {"default", 11}
 meta iifgroup { 11,33};ok;iifgroup { 11,33}
-meta iifgroup {11-33};ok;iifgroup {11-33}
+meta iifgroup {11-33, 44-55};ok;iifgroup {11-33, 44-55}
 meta iifgroup != { 11,33};ok;iifgroup != { 11,33}
-meta iifgroup != {11-33};ok;iifgroup != {11-33}
+meta iifgroup != {11-33, 44-55};ok;iifgroup != {11-33, 44-55}
 meta oifgroup 0;ok;oifgroup "default"
 meta oifgroup != 0;ok;oifgroup != "default"
 meta oifgroup "default";ok;oifgroup "default"
 meta oifgroup != "default";ok;oifgroup != "default"
-meta oifgroup {"default"};ok;oifgroup {"default"}
-meta oifgroup != {"default"};ok;oifgroup != {"default"}
+meta oifgroup {"default", 11};ok;oifgroup {"default", 11}
+meta oifgroup != {"default", 11};ok;oifgroup != {"default", 11}
 meta oifgroup { 11,33};ok;oifgroup { 11,33}
-meta oifgroup {11-33};ok;oifgroup {11-33}
+meta oifgroup {11-33, 44-55};ok;oifgroup {11-33, 44-55}
 meta oifgroup != { 11,33};ok;oifgroup != { 11,33}
-meta oifgroup != {11-33};ok;oifgroup != {11-33}
+meta oifgroup != {11-33, 44-55};ok;oifgroup != {11-33, 44-55}
 
 meta cgroup 1048577;ok;meta cgroup 1048577
 meta cgroup != 1048577;ok;meta cgroup != 1048577
diff --git a/tests/py/any/meta.t.payload b/tests/py/any/meta.t.payload
index b32770f508e7..1d8426de9632 100644
--- a/tests/py/any/meta.t.payload
+++ b/tests/py/any/meta.t.payload
@@ -34,15 +34,6 @@ ip test-ip4 input
   [ meta load len => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
-# meta length { 33-55}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
-ip test-ip4 input
-  [ meta load len => reg 1 ]
-  [ byteorder reg 1 = hton(reg 1, 4, 4) ]
-  [ lookup reg 1 set __set%d ]
-
 # meta length { 33-55, 67-88}
 __set%d test-ip4 7
 __set%d test-ip4 0
@@ -69,15 +60,6 @@ ip test-ip4 input
   [ meta load len => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# meta length != { 33-55}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
-ip test-ip4 input
-  [ meta load len => reg 1 ]
-  [ byteorder reg 1 = hton(reg 1, 4, 4) ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # meta protocol { ip, arp, ip6, vlan }
 __set%d test-ip4 3
 __set%d test-ip4 0
@@ -143,24 +125,6 @@ ip test-ip4 input
   [ meta load l4proto => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# meta l4proto { 33-55}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
-ip test-ip4 input
-  [ meta load l4proto => reg 1 ]
-  [ byteorder reg 1 = hton(reg 1, 2, 1) ]
-  [ lookup reg 1 set __set%d ]
-
-# meta l4proto != { 33-55}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
-ip test-ip4 input
-  [ meta load l4proto => reg 1 ]
-  [ byteorder reg 1 = hton(reg 1, 2, 1) ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # meta mark 0x4
 ip test-ip4 input
   [ meta load mark => reg 1 ]
@@ -311,24 +275,6 @@ ip test-ip4 input
   [ cmp neq reg 1 0x00000001 ]
   [ immediate reg 0 accept ]
 
-# meta oif {"lo"} accept
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 00000001  : 0 [end]
-ip test-ip4 input
-  [ meta load oif => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-  [ immediate reg 0 accept ]
-
-# meta oif != {"lo"} accept
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 00000001  : 0 [end]
-ip test-ip4 input
-  [ meta load oif => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-  [ immediate reg 0 accept ]
-
 # meta oifname "dummy0"
 ip test-ip4 input
   [ meta load oifname => reg 1 ]
@@ -446,26 +392,6 @@ ip test-ip4 input
   [ range neq reg 1 0xd1070000 0xd5070000 ]
   [ immediate reg 0 accept ]
 
-# meta skuid { 2001-2005} accept
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element d1070000  : 0 [end]	element d6070000  : 1 [end]
-ip test-ip4 input
-  [ meta load skuid => reg 1 ]
-  [ byteorder reg 1 = hton(reg 1, 4, 4) ]
-  [ lookup reg 1 set __set%d ]
-  [ immediate reg 0 accept ]
-
-# meta skuid != { 2001-2005} accept
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element d1070000  : 0 [end]	element d6070000  : 1 [end]
-ip test-ip4 input
-  [ meta load skuid => reg 1 ]
-  [ byteorder reg 1 = hton(reg 1, 4, 4) ]
-  [ lookup reg 1 set __set%d 0x1 ]
-  [ immediate reg 0 accept ]
-
 # meta skgid {"bin", "root", "daemon"} accept
 __set%d test-ip4 3
 __set%d test-ip4 0
@@ -529,26 +455,6 @@ ip test-ip4 input
   [ range neq reg 1 0xd1070000 0xd5070000 ]
   [ immediate reg 0 accept ]
 
-# meta skgid { 2001-2005} accept
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element d1070000  : 0 [end]	element d6070000  : 1 [end]
-ip test-ip4 input
-  [ meta load skgid => reg 1 ]
-  [ byteorder reg 1 = hton(reg 1, 4, 4) ]
-  [ lookup reg 1 set __set%d ]
-  [ immediate reg 0 accept ]
-
-# meta skgid != { 2001-2005} accept
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element d1070000  : 0 [end]	element d6070000  : 1 [end]
-ip test-ip4 input
-  [ meta load skgid => reg 1 ]
-  [ byteorder reg 1 = hton(reg 1, 4, 4) ]
-  [ lookup reg 1 set __set%d 0x1 ]
-  [ immediate reg 0 accept ]
-
 # meta mark set 0xffffffc8 xor 0x16
 ip test-ip4 input
   [ immediate reg 1 0xffffffde ]
@@ -751,32 +657,6 @@ ip test-ip4 input
   [ meta load iifgroup => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
-# meta iifgroup {11-33}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 0b000000  : 0 [end]	element 22000000  : 1 [end]
-ip test-ip4 input
-  [ meta load iifgroup => reg 1 ]
-  [ byteorder reg 1 = hton(reg 1, 4, 4) ]
-  [ lookup reg 1 set __set%d ]
-
-# meta iifgroup != { 11,33}
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 0000000b  : 0 [end]	element 00000021  : 0 [end]
-ip test-ip4 input
-  [ meta load iifgroup => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# meta iifgroup != {11-33}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 0b000000  : 0 [end]	element 22000000  : 1 [end]
-ip test-ip4 input
-  [ meta load iifgroup => reg 1 ]
-  [ byteorder reg 1 = hton(reg 1, 4, 4) ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # meta oifgroup 0
 ip test-ip4 input
   [ meta load oifgroup => reg 1 ]
@@ -797,22 +677,6 @@ ip test-ip4 input
   [ meta load oifgroup => reg 1 ]
   [ cmp neq reg 1 0x00000000 ]
 
-# meta oifgroup {"default"}
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 00000000  : 0 [end]
-ip test-ip4 input
-  [ meta load oifgroup => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# meta oifgroup != {"default"}
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 00000000  : 0 [end]
-ip test-ip4 input
-  [ meta load oifgroup => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # meta oifgroup { 11,33}
 __set%d test-ip4 3
 __set%d test-ip4 0
@@ -821,32 +685,6 @@ ip test-ip4 input
   [ meta load oifgroup => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
-# meta oifgroup {11-33}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 0b000000  : 0 [end]	element 22000000  : 1 [end]
-ip test-ip4 input
-  [ meta load oifgroup => reg 1 ]
-  [ byteorder reg 1 = hton(reg 1, 4, 4) ]
-  [ lookup reg 1 set __set%d ]
-
-# meta oifgroup != { 11,33}
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 0000000b  : 0 [end]	element 00000021  : 0 [end]
-ip test-ip4 input
-  [ meta load oifgroup => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# meta oifgroup != {11-33}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 0b000000  : 0 [end]	element 22000000  : 1 [end]
-ip test-ip4 input
-  [ meta load oifgroup => reg 1 ]
-  [ byteorder reg 1 = hton(reg 1, 4, 4) ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # meta cgroup 1048577
 ip test-ip4 input
   [ meta load cgroup => reg 1 ]
@@ -886,24 +724,6 @@ ip test-ip4 input
   [ byteorder reg 1 = hton(reg 1, 4, 4) ]
   [ range neq reg 1 0x01001000 0x02001000 ]
 
-# meta cgroup {1048577-1048578}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 01001000  : 0 [end]	element 03001000  : 1 [end]
-ip test-ip4 input
-  [ meta load cgroup => reg 1 ]
-  [ byteorder reg 1 = hton(reg 1, 4, 4) ]
-  [ lookup reg 1 set __set%d ]
-
-# meta cgroup != { 1048577-1048578}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 01001000  : 0 [end]	element 03001000  : 1 [end]
-ip test-ip4 input
-  [ meta load cgroup => reg 1 ]
-  [ byteorder reg 1 = hton(reg 1, 4, 4) ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # meta iif . meta oif { "lo" . "lo" }
 __set%d test-ip4 3
 __set%d test-ip4 0
@@ -1021,3 +841,209 @@ ip test-ip4 input
   [ meta load priority => reg 1 ]
   [ cmp eq reg 1 0x87654321 ]
 
+# meta length { 33-55, 66-88}
+__set%d test-ip4 7 size 5
+__set%d test-ip4 0
+	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]	element 42000000  : 0 [end]	element 59000000  : 1 [end]
+ip test-ip4 input 
+  [ meta load len => reg 1 ]
+  [ byteorder reg 1 = hton(reg 1, 4, 4) ]
+  [ lookup reg 1 set __set%d ]
+
+# meta length != { 33-55, 66-88}
+__set%d test-ip4 7 size 5
+__set%d test-ip4 0
+	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]	element 42000000  : 0 [end]	element 59000000  : 1 [end]
+ip test-ip4 input 
+  [ meta load len => reg 1 ]
+  [ byteorder reg 1 = hton(reg 1, 4, 4) ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
+# meta l4proto { 33-55, 66-88}
+__set%d test-ip4 7 size 5
+__set%d test-ip4 0
+	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]	element 00000042  : 0 [end]	element 00000059  : 1 [end]
+ip test-ip4 input 
+  [ meta load l4proto => reg 1 ]
+  [ byteorder reg 1 = hton(reg 1, 2, 1) ]
+  [ lookup reg 1 set __set%d ]
+
+# meta l4proto != { 33-55, 66-88}
+__set%d test-ip4 7 size 5
+__set%d test-ip4 0
+	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]	element 00000042  : 0 [end]	element 00000059  : 1 [end]
+ip test-ip4 input 
+  [ meta load l4proto => reg 1 ]
+  [ byteorder reg 1 = hton(reg 1, 2, 1) ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
+# meta skuid { 2001-2005, 3001-3005} accept
+__set%d test-ip4 7 size 5
+__set%d test-ip4 0
+	element 00000000  : 1 [end]	element d1070000  : 0 [end]	element d6070000  : 1 [end]	element b90b0000  : 0 [end]	element be0b0000  : 1 [end]
+ip test-ip4 input 
+  [ meta load skuid => reg 1 ]
+  [ byteorder reg 1 = hton(reg 1, 4, 4) ]
+  [ lookup reg 1 set __set%d ]
+  [ immediate reg 0 accept ]
+
+# meta iifgroup {"default", 11}
+__set%d test-ip4 3 size 2
+__set%d test-ip4 0
+	element 00000000  : 0 [end]	element 0000000b  : 0 [end]
+ip test-ip4 input 
+  [ meta load iifgroup => reg 1 ]
+  [ lookup reg 1 set __set%d ]
+
+# meta iifgroup != {"default", 11}
+__set%d test-ip4 3 size 2
+__set%d test-ip4 0
+	element 00000000  : 0 [end]	element 0000000b  : 0 [end]
+ip test-ip4 input 
+  [ meta load iifgroup => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
+# meta iifgroup {11-33, 44-55}
+__set%d test-ip4 7 size 5
+__set%d test-ip4 0
+	element 00000000  : 1 [end]	element 0b000000  : 0 [end]	element 22000000  : 1 [end]	element 2c000000  : 0 [end]	element 38000000  : 1 [end]
+ip test-ip4 input 
+  [ meta load iifgroup => reg 1 ]
+  [ byteorder reg 1 = hton(reg 1, 4, 4) ]
+  [ lookup reg 1 set __set%d ]
+
+# meta iifgroup != { 11,33}
+__set%d test-ip4 3 size 2
+__set%d test-ip4 0
+	element 0000000b  : 0 [end]	element 00000021  : 0 [end]
+ip test-ip4 input 
+  [ meta load iifgroup => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
+# meta iifgroup != {11-33, 44-55}
+__set%d test-ip4 7 size 5
+__set%d test-ip4 0
+	element 00000000  : 1 [end]	element 0b000000  : 0 [end]	element 22000000  : 1 [end]	element 2c000000  : 0 [end]	element 38000000  : 1 [end]
+ip test-ip4 input 
+  [ meta load iifgroup => reg 1 ]
+  [ byteorder reg 1 = hton(reg 1, 4, 4) ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
+# meta oifgroup {"default", 11}
+__set%d test-ip4 3 size 2
+__set%d test-ip4 0
+	element 00000000  : 0 [end]	element 0000000b  : 0 [end]
+ip test-ip4 input 
+  [ meta load oifgroup => reg 1 ]
+  [ lookup reg 1 set __set%d ]
+
+# meta oifgroup {11-33, 44-55}
+__set%d test-ip4 7 size 5
+__set%d test-ip4 0
+	element 00000000  : 1 [end]	element 0b000000  : 0 [end]	element 22000000  : 1 [end]	element 2c000000  : 0 [end]	element 38000000  : 1 [end]
+ip test-ip4 input 
+  [ meta load oifgroup => reg 1 ]
+  [ byteorder reg 1 = hton(reg 1, 4, 4) ]
+  [ lookup reg 1 set __set%d ]
+
+# meta oifgroup != { 11,33}
+__set%d test-ip4 3 size 2
+__set%d test-ip4 0
+	element 0000000b  : 0 [end]	element 00000021  : 0 [end]
+ip test-ip4 input 
+  [ meta load oifgroup => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
+# meta oifgroup != {11-33, 44-55}
+__set%d test-ip4 7 size 5
+__set%d test-ip4 0
+	element 00000000  : 1 [end]	element 0b000000  : 0 [end]	element 22000000  : 1 [end]	element 2c000000  : 0 [end]	element 38000000  : 1 [end]
+ip test-ip4 input 
+  [ meta load oifgroup => reg 1 ]
+  [ byteorder reg 1 = hton(reg 1, 4, 4) ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
+# meta skuid != { 2001-2005, 3001-3005} accept
+__set%d test-ip4 7 size 5
+__set%d test-ip4 0
+	element 00000000  : 1 [end]	element d1070000  : 0 [end]	element d6070000  : 1 [end]	element b90b0000  : 0 [end]	element be0b0000  : 1 [end]
+ip test-ip4 input 
+  [ meta load skuid => reg 1 ]
+  [ byteorder reg 1 = hton(reg 1, 4, 4) ]
+  [ lookup reg 1 set __set%d 0x1 ]
+  [ immediate reg 0 accept ]
+
+# meta oifgroup != {"default", 11}
+__set%d test-ip4 3 size 2
+__set%d test-ip4 0
+	element 00000000  : 0 [end]	element 0000000b  : 0 [end]
+ip test-ip4 input 
+  [ meta load oifgroup => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
+# meta iif . meta oif { "lo" . "lo" , "dummy0" . "dummy0" }
+__set%d test-ip4 3 size 2
+__set%d test-ip4 0
+	element 00000001 00000001  : 0 [end]	element 00000005 00000005  : 0 [end]
+ip test-ip4 input 
+  [ meta load iif => reg 1 ]
+  [ meta load oif => reg 9 ]
+  [ lookup reg 1 set __set%d ]
+
+# meta iif . meta oif . meta mark { "lo" . "lo" . 0x0000000a, "dummy0" . "dummy0" . 0x0000000b }
+__set%d test-ip4 3 size 2
+__set%d test-ip4 0
+	element 00000001 00000001 0000000a  : 0 [end]	element 00000005 00000005 0000000b  : 0 [end]
+ip test-ip4 input 
+  [ meta load iif => reg 1 ]
+  [ meta load oif => reg 9 ]
+  [ meta load mark => reg 10 ]
+  [ lookup reg 1 set __set%d ]
+
+# meta iif . meta oif vmap { "lo" . "lo" : drop, "dummy0" . "dummy0" : accept }
+__map%d test-ip4 b size 2
+__map%d test-ip4 0
+	element 00000001 00000001  : 0 [end]	element 00000005 00000005  : 0 [end]
+ip test-ip4 input 
+  [ meta load iif => reg 1 ]
+  [ meta load oif => reg 9 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
+
+# meta skgid { 2001-2005} accept
+__set%d test-ip4 7 size 3
+__set%d test-ip4 0
+	element 00000000  : 1 [end]	element d1070000  : 0 [end]	element d6070000  : 1 [end]
+ip test-ip4 input 
+  [ meta load skgid => reg 1 ]
+  [ byteorder reg 1 = hton(reg 1, 4, 4) ]
+  [ lookup reg 1 set __set%d ]
+  [ immediate reg 0 accept ]
+
+# meta skgid != { 2001-2005} accept
+__set%d test-ip4 7 size 3
+__set%d test-ip4 0
+	element 00000000  : 1 [end]	element d1070000  : 0 [end]	element d6070000  : 1 [end]
+ip test-ip4 input 
+  [ meta load skgid => reg 1 ]
+  [ byteorder reg 1 = hton(reg 1, 4, 4) ]
+  [ lookup reg 1 set __set%d 0x1 ]
+  [ immediate reg 0 accept ]
+
+# meta cgroup {1048577-1048578}
+__set%d test-ip4 7 size 3
+__set%d test-ip4 0
+	element 00000000  : 1 [end]	element 01001000  : 0 [end]	element 03001000  : 1 [end]
+ip test-ip4 input 
+  [ meta load cgroup => reg 1 ]
+  [ byteorder reg 1 = hton(reg 1, 4, 4) ]
+  [ lookup reg 1 set __set%d ]
+
+# meta cgroup != { 1048577-1048578}
+__set%d test-ip4 7 size 3
+__set%d test-ip4 0
+	element 00000000  : 1 [end]	element 01001000  : 0 [end]	element 03001000  : 1 [end]
+ip test-ip4 input 
+  [ meta load cgroup => reg 1 ]
+  [ byteorder reg 1 = hton(reg 1, 4, 4) ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
diff --git a/tests/shell/testcases/cache/0001_cache_handling_0 b/tests/shell/testcases/cache/0001_cache_handling_0
index f3dc9a347972..431aada59234 100755
--- a/tests/shell/testcases/cache/0001_cache_handling_0
+++ b/tests/shell/testcases/cache/0001_cache_handling_0
@@ -4,12 +4,12 @@ RULESET='
 table inet test {
 	set test {
 		type ipv4_addr
-		elements = { 1.1.1.1}
+		elements = { 1.1.1.1, 3.3.3.3}
 	}
 
 	chain test {
 		ip saddr @test counter accept
-		ip daddr { 2.2.2.2} counter accept
+		ip daddr { 2.2.2.2, 4.4.4.4} counter accept
 	}
 }'
 
diff --git a/tests/shell/testcases/cache/dumps/0001_cache_handling_0.nft b/tests/shell/testcases/cache/dumps/0001_cache_handling_0.nft
index f6dd65415838..209986520352 100644
--- a/tests/shell/testcases/cache/dumps/0001_cache_handling_0.nft
+++ b/tests/shell/testcases/cache/dumps/0001_cache_handling_0.nft
@@ -1,12 +1,12 @@
 table inet test {
 	set test {
 		type ipv4_addr
-		elements = { 1.1.1.1 }
+		elements = { 1.1.1.1, 3.3.3.3 }
 	}
 
 	chain test {
-		ip daddr { 2.2.2.2 } counter packets 0 bytes 0 accept
+		ip daddr { 2.2.2.2, 4.4.4.4 } counter packets 0 bytes 0 accept
 		ip saddr @test counter packets 0 bytes 0 accept
-		ip daddr { 2.2.2.2 } counter packets 0 bytes 0 accept
+		ip daddr { 2.2.2.2, 4.4.4.4 } counter packets 0 bytes 0 accept
 	}
 }
diff --git a/tests/shell/testcases/listing/0011sets_0 b/tests/shell/testcases/listing/0011sets_0
index f021962a3881..aac9eac93ff6 100755
--- a/tests/shell/testcases/listing/0011sets_0
+++ b/tests/shell/testcases/listing/0011sets_0
@@ -17,19 +17,19 @@ set -e
 
 $NFT add table ip nat
 $NFT add chain ip nat test
-$NFT add rule ip nat test tcp dport {123}
+$NFT add rule ip nat test tcp dport {123, 321}
 
 $NFT add table ip6 test
 $NFT add chain ip6 test test
-$NFT add rule ip6 test test udp sport {123}
+$NFT add rule ip6 test test udp sport {123, 321}
 
 $NFT add table arp test_arp
 $NFT add chain arp test_arp test
-$NFT add rule arp test_arp test meta mark {123}
+$NFT add rule arp test_arp test meta mark {123, 321}
 
 $NFT add table bridge test_bridge
 $NFT add chain bridge test_bridge test
-$NFT add rule bridge test_bridge test ip daddr {1.1.1.1}
+$NFT add rule bridge test_bridge test ip daddr {1.1.1.1, 2.2.2.2}
 
 $NFT add table inet filter
 $NFT add chain inet filter test
diff --git a/tests/shell/testcases/netns/0001nft-f_0 b/tests/shell/testcases/netns/0001nft-f_0
index 8344808760b7..819422638339 100755
--- a/tests/shell/testcases/netns/0001nft-f_0
+++ b/tests/shell/testcases/netns/0001nft-f_0
@@ -16,7 +16,7 @@ RULESET="table ip t {
 
 	chain c {
 		ct state new
-		udp dport { 12345 }
+		udp dport { 12345, 54321 }
 		ip saddr @s drop
 		jump other
 	}
@@ -32,7 +32,7 @@ table ip6 t {
 
 	chain c {
 		ct state new
-		udp dport { 12345 }
+		udp dport { 12345, 54321 }
 		ip6 saddr @s drop
 		jump other
 	}
@@ -48,7 +48,7 @@ table inet t {
 
 	chain c {
 		ct state new
-		udp dport { 12345 }
+		udp dport { 12345, 54321 }
 		ip6 saddr @s drop
 		jump other
 	}
diff --git a/tests/shell/testcases/netns/0002loosecommands_0 b/tests/shell/testcases/netns/0002loosecommands_0
index e62782804da4..465c2e8646dc 100755
--- a/tests/shell/testcases/netns/0002loosecommands_0
+++ b/tests/shell/testcases/netns/0002loosecommands_0
@@ -32,7 +32,7 @@ netns_exec $NETNS_NAME "$NFT add chain ip t other"
 netns_exec $NETNS_NAME "$NFT add set ip t s { type ipv4_addr; }"
 netns_exec $NETNS_NAME "$NFT add element ip t s {1.1.0.0 }"
 netns_exec $NETNS_NAME "$NFT add rule ip t c ct state new"
-netns_exec $NETNS_NAME "$NFT add rule ip t c udp dport { 12345 }"
+netns_exec $NETNS_NAME "$NFT add rule ip t c udp dport { 12345, 54321 }"
 netns_exec $NETNS_NAME "$NFT add rule ip t c ip saddr @s drop"
 netns_exec $NETNS_NAME "$NFT add rule ip t c jump other"
 
@@ -44,7 +44,7 @@ RULESET="table ip t {
 
 	chain c {
 		ct state new
-		udp dport { 12345 }
+		udp dport { 12345, 54321 }
 		ip saddr @s drop
 		jump other
 	}
diff --git a/tests/shell/testcases/netns/0003many_0 b/tests/shell/testcases/netns/0003many_0
index 61ad37bddadb..a5fcb5d6b2ef 100755
--- a/tests/shell/testcases/netns/0003many_0
+++ b/tests/shell/testcases/netns/0003many_0
@@ -19,7 +19,7 @@ RULESET="table ip t {
 
 	chain c {
 		ct state new
-		udp dport { 12345 }
+		udp dport { 12345, 54321 }
 		ip saddr @s drop
 		jump other
 	}
@@ -35,7 +35,7 @@ table ip6 t {
 
 	chain c {
 		ct state new
-		udp dport { 12345 }
+		udp dport { 12345, 54321 }
 		ip6 saddr @s drop
 		jump other
 	}
@@ -51,7 +51,7 @@ table inet t {
 
 	chain c {
 		ct state new
-		udp dport { 12345 }
+		udp dport { 12345, 54321 }
 		ip6 saddr @s drop
 		jump other
 	}
diff --git a/tests/shell/testcases/nft-f/0002rollback_rule_0 b/tests/shell/testcases/nft-f/0002rollback_rule_0
index da3cdc0bc161..33e1212d94fb 100755
--- a/tests/shell/testcases/nft-f/0002rollback_rule_0
+++ b/tests/shell/testcases/nft-f/0002rollback_rule_0
@@ -11,7 +11,7 @@ GOOD_RULESET="table ip t {
 
 	chain c {
 		ct state new
-		tcp dport { 22222 }
+		tcp dport { 22222, 33333 }
 		ip saddr @t drop
 		jump other
 	}
diff --git a/tests/shell/testcases/nft-f/0003rollback_jump_0 b/tests/shell/testcases/nft-f/0003rollback_jump_0
index 1238f1504c96..294a234eef97 100755
--- a/tests/shell/testcases/nft-f/0003rollback_jump_0
+++ b/tests/shell/testcases/nft-f/0003rollback_jump_0
@@ -11,7 +11,7 @@ GOOD_RULESET="table ip t {
 
 	chain c {
 		ct state new
-		tcp dport { 22222 }
+		tcp dport { 22222, 33333 }
 		ip saddr @t drop
 		jump other
 	}
diff --git a/tests/shell/testcases/nft-f/0004rollback_set_0 b/tests/shell/testcases/nft-f/0004rollback_set_0
index 25fc870c6742..512840efb97b 100755
--- a/tests/shell/testcases/nft-f/0004rollback_set_0
+++ b/tests/shell/testcases/nft-f/0004rollback_set_0
@@ -11,7 +11,7 @@ GOOD_RULESET="table ip t {
 
 	chain c {
 		ct state new
-		tcp dport { 22222 }
+		tcp dport { 22222, 33333 }
 		ip saddr @t drop
 		jump other
 	}
diff --git a/tests/shell/testcases/nft-f/0005rollback_map_0 b/tests/shell/testcases/nft-f/0005rollback_map_0
index 90108e729d59..b1eb3dd37471 100755
--- a/tests/shell/testcases/nft-f/0005rollback_map_0
+++ b/tests/shell/testcases/nft-f/0005rollback_map_0
@@ -11,7 +11,7 @@ GOOD_RULESET="table ip t {
 
 	chain c {
 		ct state new
-		tcp dport { 22222 }
+		tcp dport { 22222, 33333 }
 		ip saddr @t drop
 		jump other
 	}
diff --git a/tests/shell/testcases/nft-f/0006action_object_0 b/tests/shell/testcases/nft-f/0006action_object_0
index b9766f2dbb72..ffa6c9bda973 100755
--- a/tests/shell/testcases/nft-f/0006action_object_0
+++ b/tests/shell/testcases/nft-f/0006action_object_0
@@ -16,11 +16,11 @@ generate1()
 	add set $family t s {type inet_service;}
 	add element $family t s {8080}
 	insert rule $family t c meta l4proto tcp tcp dport @s accept
-	replace rule $family t c handle 2 meta l4proto tcp tcp dport {9090}
+	replace rule $family t c handle 2 meta l4proto tcp tcp dport {9090, 8080}
 	add map $family t m {type inet_service:verdict;}
 	add element $family t m {10080:drop}
 	insert rule $family t c meta l4proto tcp tcp dport vmap @m
-	add rule $family t c meta l4proto udp udp sport vmap {1111:accept}
+	add rule $family t c meta l4proto udp udp sport vmap {1111:accept, 2222:drop}
 	"
 }
 
diff --git a/tests/shell/testcases/nft-f/0016redefines_1 b/tests/shell/testcases/nft-f/0016redefines_1
index d0148d65da54..4c26b3796fbf 100755
--- a/tests/shell/testcases/nft-f/0016redefines_1
+++ b/tests/shell/testcases/nft-f/0016redefines_1
@@ -8,7 +8,7 @@ table ip x {
                 define unused = 4.4.4.4
                 define address = { 1.1.1.1, 2.2.2.2 }
                 ip saddr \$address
-                redefine address = { 3.3.3.3 }
+                redefine address = { 3.3.3.3, 4.4.4.4 }
                 ip saddr \$address
                 undefine unused
         }
@@ -17,7 +17,7 @@ table ip x {
 EXPECTED="table ip x {
 	chain y {
 		ip saddr { 1.1.1.1, 2.2.2.2 }
-		ip saddr { 3.3.3.3 }
+		ip saddr { 3.3.3.3, 4.4.4.4 }
 	}
 }"
 
diff --git a/tests/shell/testcases/nft-f/dumps/0002rollback_rule_0.nft b/tests/shell/testcases/nft-f/dumps/0002rollback_rule_0.nft
index f6f2615852c7..3fad909057d2 100644
--- a/tests/shell/testcases/nft-f/dumps/0002rollback_rule_0.nft
+++ b/tests/shell/testcases/nft-f/dumps/0002rollback_rule_0.nft
@@ -6,7 +6,7 @@ table ip t {
 
 	chain c {
 		ct state new
-		tcp dport { 22222 }
+		tcp dport { 22222, 33333 }
 		ip saddr @t drop
 		jump other
 	}
diff --git a/tests/shell/testcases/nft-f/dumps/0003rollback_jump_0.nft b/tests/shell/testcases/nft-f/dumps/0003rollback_jump_0.nft
index f6f2615852c7..3fad909057d2 100644
--- a/tests/shell/testcases/nft-f/dumps/0003rollback_jump_0.nft
+++ b/tests/shell/testcases/nft-f/dumps/0003rollback_jump_0.nft
@@ -6,7 +6,7 @@ table ip t {
 
 	chain c {
 		ct state new
-		tcp dport { 22222 }
+		tcp dport { 22222, 33333 }
 		ip saddr @t drop
 		jump other
 	}
diff --git a/tests/shell/testcases/nft-f/dumps/0004rollback_set_0.nft b/tests/shell/testcases/nft-f/dumps/0004rollback_set_0.nft
index f6f2615852c7..3fad909057d2 100644
--- a/tests/shell/testcases/nft-f/dumps/0004rollback_set_0.nft
+++ b/tests/shell/testcases/nft-f/dumps/0004rollback_set_0.nft
@@ -6,7 +6,7 @@ table ip t {
 
 	chain c {
 		ct state new
-		tcp dport { 22222 }
+		tcp dport { 22222, 33333 }
 		ip saddr @t drop
 		jump other
 	}
diff --git a/tests/shell/testcases/nft-f/dumps/0005rollback_map_0.nft b/tests/shell/testcases/nft-f/dumps/0005rollback_map_0.nft
index f6f2615852c7..3fad909057d2 100644
--- a/tests/shell/testcases/nft-f/dumps/0005rollback_map_0.nft
+++ b/tests/shell/testcases/nft-f/dumps/0005rollback_map_0.nft
@@ -6,7 +6,7 @@ table ip t {
 
 	chain c {
 		ct state new
-		tcp dport { 22222 }
+		tcp dport { 22222, 33333 }
 		ip saddr @t drop
 		jump other
 	}
diff --git a/tests/shell/testcases/sets/0021nesting_0 b/tests/shell/testcases/sets/0021nesting_0
index c8d8f05792ab..0b90dc7cd306 100755
--- a/tests/shell/testcases/sets/0021nesting_0
+++ b/tests/shell/testcases/sets/0021nesting_0
@@ -5,6 +5,7 @@ set -e
 RULESET='
 define set1 = {
 	2.2.2.0/24,
+	3.3.3.0/24,
 }
 define set2 = {
 	$set1,
-- 
2.11.0


