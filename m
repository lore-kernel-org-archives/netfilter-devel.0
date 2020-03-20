Return-Path: <SRS0=s0US=5F=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF9BAC4332B
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Mar 2020 12:49:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 752F220739
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Mar 2020 12:49:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727016AbgCTMtX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 20 Mar 2020 08:49:23 -0400
Received: from correo.us.es ([193.147.175.20]:44270 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726814AbgCTMtW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 Mar 2020 08:49:22 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E4AA4E2C68
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Mar 2020 13:48:46 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D4DCADA736
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Mar 2020 13:48:46 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id CA63EDA38D; Fri, 20 Mar 2020 13:48:46 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8CCE7DA3A1
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Mar 2020 13:48:44 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 20 Mar 2020 13:48:44 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 7989042EE393
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Mar 2020 13:48:44 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] tests: py: update nat expressions payload to include proto flags
Date:   Fri, 20 Mar 2020 13:49:13 +0100
Message-Id: <20200320124913.407477-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Update tests according to 6c84577b0d23 ("evaluate: add range specified
flag setting (missing NF_NAT_RANGE_PROTO_SPECIFIED)")

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/py/inet/dnat.t.payload          |  4 ++--
 tests/py/ip/dnat.t.payload.ip         |  2 +-
 tests/py/ip/masquerade.t.payload      |  4 ++--
 tests/py/ip/redirect.t.payload        | 20 ++++++++++----------
 tests/py/ip6/dnat.t.payload.ip6       |  6 +++---
 tests/py/ip6/masquerade.t.payload.ip6 |  4 ++--
 tests/py/ip6/redirect.t.payload.ip6   | 14 +++++++-------
 tests/py/ip6/snat.t.payload.ip6       |  4 ++--
 8 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/tests/py/inet/dnat.t.payload b/tests/py/inet/dnat.t.payload
index b81caf7bc66d..75cf1b7779b7 100644
--- a/tests/py/inet/dnat.t.payload
+++ b/tests/py/inet/dnat.t.payload
@@ -7,7 +7,7 @@ inet test-inet prerouting
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00005000 ]
   [ immediate reg 1 0x0000901f ]
-  [ redir proto_min reg 1 ]
+  [ redir proto_min reg 1 flags 0x2 ]
 
 # iifname "eth0" tcp dport 443 dnat ip to 192.168.3.2
 inet test-inet prerouting
@@ -30,7 +30,7 @@ inet test-inet prerouting
   [ cmp eq reg 1 0x0000bb01 ]
   [ immediate reg 1 0x0000adde 0x00000000 0x00000000 0xefbe0000 ]
   [ immediate reg 2 0x00005b11 ]
-  [ nat dnat ip6 addr_min reg 1 addr_max reg 0 proto_min reg 2 proto_max reg 0 ]
+  [ nat dnat ip6 addr_min reg 1 addr_max reg 0 proto_min reg 2 proto_max reg 0 flags 0x2 ]
 
 # dnat ip to ct mark map { 0x00000014 : 1.2.3.4}
 __map%d test-inet b size 1
diff --git a/tests/py/ip/dnat.t.payload.ip b/tests/py/ip/dnat.t.payload.ip
index 1b869d0a002e..0acbefb6c2ab 100644
--- a/tests/py/ip/dnat.t.payload.ip
+++ b/tests/py/ip/dnat.t.payload.ip
@@ -70,7 +70,7 @@ ip test-ip4 prerouting
   [ cmp eq reg 1 0x00005100 ]
   [ immediate reg 1 0x0203a8c0 ]
   [ immediate reg 2 0x0000901f ]
-  [ nat dnat ip addr_min reg 1 addr_max reg 0 proto_min reg 2 proto_max reg 0 ]
+  [ nat dnat ip addr_min reg 1 addr_max reg 0 proto_min reg 2 proto_max reg 0 flags 0x2 ]
 
 # dnat to ct mark map { 0x00000014 : 1.2.3.4}
 __map%d test-ip4 b
diff --git a/tests/py/ip/masquerade.t.payload b/tests/py/ip/masquerade.t.payload
index 83351526cce7..0ba8d5a8d141 100644
--- a/tests/py/ip/masquerade.t.payload
+++ b/tests/py/ip/masquerade.t.payload
@@ -130,7 +130,7 @@ ip test-ip4 postrouting
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ immediate reg 1 0x00000004 ]
-  [ masq proto_min reg 1 proto_max reg 0 ]
+  [ masq proto_min reg 1 proto_max reg 0 flags 0x2 ]
 
 # ip protocol 6 masquerade to :1024-2048
 ip test-ip4 postrouting
@@ -138,5 +138,5 @@ ip test-ip4 postrouting
   [ cmp eq reg 1 0x00000006 ]
   [ immediate reg 1 0x00000004 ]
   [ immediate reg 2 0x00000008 ]
-  [ masq proto_min reg 1 proto_max reg 2 ]
+  [ masq proto_min reg 1 proto_max reg 2 flags 0x2 ]
 
diff --git a/tests/py/ip/redirect.t.payload b/tests/py/ip/redirect.t.payload
index f208aacb9087..7f8a74b0bd1b 100644
--- a/tests/py/ip/redirect.t.payload
+++ b/tests/py/ip/redirect.t.payload
@@ -93,7 +93,7 @@ ip test-ip4 output
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00001600 ]
   [ immediate reg 1 0x00001600 ]
-  [ redir proto_min reg 1 ]
+  [ redir proto_min reg 1 flags 0x2 ]
 
 # udp dport 1234 redirect to :4321
 ip test-ip4 output
@@ -102,7 +102,7 @@ ip test-ip4 output
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x0000d204 ]
   [ immediate reg 1 0x0000e110 ]
-  [ redir proto_min reg 1 ]
+  [ redir proto_min reg 1 flags 0x2 ]
 
 # ip daddr 172.16.0.1 udp dport 9998 redirect to :6515
 ip test-ip4 output
@@ -113,7 +113,7 @@ ip test-ip4 output
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00000e27 ]
   [ immediate reg 1 0x00007319 ]
-  [ redir proto_min reg 1 ]
+  [ redir proto_min reg 1 flags 0x2 ]
 
 # tcp dport 39128 redirect to :993
 ip test-ip4 output
@@ -122,7 +122,7 @@ ip test-ip4 output
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x0000d898 ]
   [ immediate reg 1 0x0000e103 ]
-  [ redir proto_min reg 1 ]
+  [ redir proto_min reg 1 flags 0x2 ]
 
 # ip protocol tcp redirect to :100-200
 ip test-ip4 output
@@ -130,7 +130,7 @@ ip test-ip4 output
   [ cmp eq reg 1 0x00000006 ]
   [ immediate reg 1 0x00006400 ]
   [ immediate reg 2 0x0000c800 ]
-  [ redir proto_min reg 1 proto_max reg 2 ]
+  [ redir proto_min reg 1 proto_max reg 2 flags 0x2 ]
 
 # tcp dport 9128 redirect to :993 random
 ip test-ip4 output
@@ -139,7 +139,7 @@ ip test-ip4 output
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x0000a823 ]
   [ immediate reg 1 0x0000e103 ]
-  [ redir proto_min reg 1 flags 0x4 ]
+  [ redir proto_min reg 1 flags 0x6 ]
 
 # tcp dport 9128 redirect to :993 fully-random
 ip test-ip4 output
@@ -148,7 +148,7 @@ ip test-ip4 output
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x0000a823 ]
   [ immediate reg 1 0x0000e103 ]
-  [ redir proto_min reg 1 flags 0x10 ]
+  [ redir proto_min reg 1 flags 0x12 ]
 
 # tcp dport 9128 redirect to :123 persistent
 ip test-ip4 output
@@ -157,7 +157,7 @@ ip test-ip4 output
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x0000a823 ]
   [ immediate reg 1 0x00007b00 ]
-  [ redir proto_min reg 1 flags 0x8 ]
+  [ redir proto_min reg 1 flags 0xa ]
 
 # tcp dport 9128 redirect to :123 random,persistent
 ip test-ip4 output
@@ -166,7 +166,7 @@ ip test-ip4 output
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x0000a823 ]
   [ immediate reg 1 0x00007b00 ]
-  [ redir proto_min reg 1 flags 0xc ]
+  [ redir proto_min reg 1 flags 0xe ]
 
 # tcp dport { 1, 2, 3, 4, 5, 6, 7, 8, 101, 202, 303, 1001, 2002, 3003} redirect
 __set%d test-ip4 3
@@ -216,5 +216,5 @@ ip test-ip4 output
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 1 ]
-  [ redir proto_min reg 1 ]
+  [ redir proto_min reg 1 flags 0x2 ]
 
diff --git a/tests/py/ip6/dnat.t.payload.ip6 b/tests/py/ip6/dnat.t.payload.ip6
index 985159e209c6..5906e0f8c97c 100644
--- a/tests/py/ip6/dnat.t.payload.ip6
+++ b/tests/py/ip6/dnat.t.payload.ip6
@@ -9,7 +9,7 @@ ip6 test-ip6 prerouting
   [ immediate reg 2 0x38080120 0x02005f03 0x00000000 0x00000000 ]
   [ immediate reg 3 0x00005000 ]
   [ immediate reg 4 0x00006400 ]
-  [ nat dnat ip6 addr_min reg 1 addr_max reg 2 proto_min reg 3 proto_max reg 4 ]
+  [ nat dnat ip6 addr_min reg 1 addr_max reg 2 proto_min reg 3 proto_max reg 4 flags 0x2 ]
 
 # tcp dport 80-90 dnat to [2001:838:35f:1::]-[2001:838:35f:2::]:100
 ip6 test-ip6 prerouting
@@ -21,7 +21,7 @@ ip6 test-ip6 prerouting
   [ immediate reg 1 0x38080120 0x01005f03 0x00000000 0x00000000 ]
   [ immediate reg 2 0x38080120 0x02005f03 0x00000000 0x00000000 ]
   [ immediate reg 3 0x00006400 ]
-  [ nat dnat ip6 addr_min reg 1 addr_max reg 2 proto_min reg 3 proto_max reg 0 ]
+  [ nat dnat ip6 addr_min reg 1 addr_max reg 2 proto_min reg 3 proto_max reg 0 flags 0x2 ]
 
 # tcp dport 80-90 dnat to [2001:838:35f:1::]:80
 ip6 test-ip6 prerouting
@@ -32,7 +32,7 @@ ip6 test-ip6 prerouting
   [ cmp lte reg 1 0x00005a00 ]
   [ immediate reg 1 0x38080120 0x01005f03 0x00000000 0x00000000 ]
   [ immediate reg 2 0x00005000 ]
-  [ nat dnat ip6 addr_min reg 1 addr_max reg 0 proto_min reg 2 proto_max reg 0 ]
+  [ nat dnat ip6 addr_min reg 1 addr_max reg 0 proto_min reg 2 proto_max reg 0 flags 0x2 ]
 
 # dnat to [2001:838:35f:1::]/64
 ip6 test-ip6 prerouting
diff --git a/tests/py/ip6/masquerade.t.payload.ip6 b/tests/py/ip6/masquerade.t.payload.ip6
index 98657551149e..f9f6f0740172 100644
--- a/tests/py/ip6/masquerade.t.payload.ip6
+++ b/tests/py/ip6/masquerade.t.payload.ip6
@@ -130,7 +130,7 @@ ip6 test-ip6 postrouting
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ immediate reg 1 0x00000004 ]
-  [ masq proto_min reg 1 proto_max reg 0 ]
+  [ masq proto_min reg 1 proto_max reg 0 flags 0x2 ]
 
 # meta l4proto 6 masquerade to :1024-2048
 ip6 test-ip6 postrouting
@@ -138,5 +138,5 @@ ip6 test-ip6 postrouting
   [ cmp eq reg 1 0x00000006 ]
   [ immediate reg 1 0x00000004 ]
   [ immediate reg 2 0x00000008 ]
-  [ masq proto_min reg 1 proto_max reg 2 ]
+  [ masq proto_min reg 1 proto_max reg 2 flags 0x2 ]
 
diff --git a/tests/py/ip6/redirect.t.payload.ip6 b/tests/py/ip6/redirect.t.payload.ip6
index 8f85a57021a8..104b9fd619f5 100644
--- a/tests/py/ip6/redirect.t.payload.ip6
+++ b/tests/py/ip6/redirect.t.payload.ip6
@@ -104,7 +104,7 @@ ip6 test-ip6 output
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x0000d204 ]
   [ immediate reg 1 0x0000d204 ]
-  [ redir proto_min reg 1 ]
+  [ redir proto_min reg 1 flags 0x2 ]
 
 # ip6 daddr fe00::cafe udp dport 9998 redirect to :6515
 ip6 test-ip6 output
@@ -115,7 +115,7 @@ ip6 test-ip6 output
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00000e27 ]
   [ immediate reg 1 0x00007319 ]
-  [ redir proto_min reg 1 ]
+  [ redir proto_min reg 1 flags 0x2 ]
 
 # ip6 nexthdr tcp redirect to :100-200
 ip6 test-ip6 output
@@ -123,7 +123,7 @@ ip6 test-ip6 output
   [ cmp eq reg 1 0x00000006 ]
   [ immediate reg 1 0x00006400 ]
   [ immediate reg 2 0x0000c800 ]
-  [ redir proto_min reg 1 proto_max reg 2 ]
+  [ redir proto_min reg 1 proto_max reg 2 flags 0x2 ]
 
 # tcp dport 39128 redirect to :993
 ip6 test-ip6 output
@@ -132,7 +132,7 @@ ip6 test-ip6 output
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x0000d898 ]
   [ immediate reg 1 0x0000e103 ]
-  [ redir proto_min reg 1 ]
+  [ redir proto_min reg 1 flags 0x2 ]
 
 # tcp dport 9128 redirect to :993 random
 ip6 test-ip6 output
@@ -141,7 +141,7 @@ ip6 test-ip6 output
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x0000a823 ]
   [ immediate reg 1 0x0000e103 ]
-  [ redir proto_min reg 1 flags 0x4 ]
+  [ redir proto_min reg 1 flags 0x6 ]
 
 # tcp dport 9128 redirect to :993 fully-random,persistent
 ip6 test-ip6 output
@@ -150,7 +150,7 @@ ip6 test-ip6 output
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x0000a823 ]
   [ immediate reg 1 0x0000e103 ]
-  [ redir proto_min reg 1 flags 0x18 ]
+  [ redir proto_min reg 1 flags 0x1a ]
 
 # tcp dport { 1, 2, 3, 4, 5, 6, 7, 8, 101, 202, 303, 1001, 2002, 3003} redirect
 __set%d test-ip6 3
@@ -200,5 +200,5 @@ ip6 test-ip6 output
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 1 ]
-  [ redir proto_min reg 1 ]
+  [ redir proto_min reg 1 flags 0x2 ]
 
diff --git a/tests/py/ip6/snat.t.payload.ip6 b/tests/py/ip6/snat.t.payload.ip6
index 537e6682aa38..e7fd8ff8ca40 100644
--- a/tests/py/ip6/snat.t.payload.ip6
+++ b/tests/py/ip6/snat.t.payload.ip6
@@ -9,7 +9,7 @@ ip6 test-ip6 postrouting
   [ immediate reg 2 0x38080120 0x02005f03 0x00000000 0x00000000 ]
   [ immediate reg 3 0x00005000 ]
   [ immediate reg 4 0x00006400 ]
-  [ nat snat ip6 addr_min reg 1 addr_max reg 2 proto_min reg 3 proto_max reg 4 ]
+  [ nat snat ip6 addr_min reg 1 addr_max reg 2 proto_min reg 3 proto_max reg 4 flags 0x2 ]
 
 # tcp dport 80-90 snat to [2001:838:35f:1::]-[2001:838:35f:2::]:100
 ip6 test-ip6 postrouting
@@ -21,5 +21,5 @@ ip6 test-ip6 postrouting
   [ immediate reg 1 0x38080120 0x01005f03 0x00000000 0x00000000 ]
   [ immediate reg 2 0x38080120 0x02005f03 0x00000000 0x00000000 ]
   [ immediate reg 3 0x00006400 ]
-  [ nat snat ip6 addr_min reg 1 addr_max reg 2 proto_min reg 3 proto_max reg 0 ]
+  [ nat snat ip6 addr_min reg 1 addr_max reg 2 proto_min reg 3 proto_max reg 0 flags 0x2 ]
 
-- 
2.11.0

