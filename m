Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 751B5C2D0E4
	for <netfilter-devel@archiver.kernel.org>; Sun, 15 Nov 2020 15:12:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E923722240
	for <netfilter-devel@archiver.kernel.org>; Sun, 15 Nov 2020 15:12:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="OBhelLql"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727017AbgKOPLv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 15 Nov 2020 10:11:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726945AbgKOPLv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 15 Nov 2020 10:11:51 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CC4FC0613D1
        for <netfilter-devel@vger.kernel.org>; Sun, 15 Nov 2020 07:11:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject
        :Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=YYENuZqrlL7Ljzj2sAhJgp5C/U0feuZMheOPQS+flVU=; b=OBhelLqlV9RAZTSLx7rNgue8H0
        c0mJWU5wNP0OwSjLsZXoeC4Sq46qBDx7cIMRo7ts555qZg1bGdR3oSOJbJjpV41b4gKF0jUfYwfUI
        SzRxnPOrgC6SRave3ZZDTjI/VFUiT3xiJuw/G9r+VoFpz3+5sr8U5LeuKg3xv3BzHfJIaSjXjycI0
        Wl5Feqe4rkjDmAcrZj7CpFx4obVfHox7CMGg+0vCFstijcZSp9FgZX7Ie7gybiz4bfBVjYa+qlRCk
        AMA2R9GholIlbxvYk9mjkpsa0Ds7CXNFlQvIHf43K4azaeqZShZZvQLKEEXxyzOUcF6DCgBOituUQ
        ePd1suQQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1keJgy-00027h-UF; Sun, 15 Nov 2020 15:11:49 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH] tests: py: update format of registers in bitwise payloads.
Date:   Sun, 15 Nov 2020 15:11:47 +0000
Message-Id: <20201115151147.266877-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

libnftnl has been changed to bring the format of registers in bitwise
dumps in line with those in other types of expression.  Update the
expected output of Python test-cases.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 tests/py/any/ct.t.payload             | 32 +++++++-------
 tests/py/any/meta.t.payload           |  8 ++--
 tests/py/any/rawpayload.t.payload     |  4 +-
 tests/py/bridge/vlan.t.payload        | 60 +++++++++++++--------------
 tests/py/bridge/vlan.t.payload.netdev | 60 +++++++++++++--------------
 tests/py/inet/dccp.t.payload          |  8 ++--
 tests/py/inet/map.t.payload           |  2 +-
 tests/py/inet/map.t.payload.ip        |  2 +-
 tests/py/inet/map.t.payload.netdev    |  2 +-
 tests/py/inet/tcp.t.payload           | 10 ++---
 tests/py/inet/tproxy.t.payload        |  2 +-
 tests/py/ip/ip.t.payload              | 42 +++++++++----------
 tests/py/ip/ip.t.payload.bridge       | 42 +++++++++----------
 tests/py/ip/ip.t.payload.inet         | 42 +++++++++----------
 tests/py/ip/ip.t.payload.netdev       | 42 +++++++++----------
 tests/py/ip/masquerade.t.payload      |  2 +-
 tests/py/ip/redirect.t.payload        |  2 +-
 tests/py/ip6/frag.t.payload.inet      | 24 +++++------
 tests/py/ip6/frag.t.payload.ip6       | 24 +++++------
 tests/py/ip6/ip6.t.payload.inet       | 40 +++++++++---------
 tests/py/ip6/ip6.t.payload.ip6        | 40 +++++++++---------
 tests/py/ip6/map.t.payload            |  2 +-
 tests/py/ip6/masquerade.t.payload.ip6 |  2 +-
 tests/py/ip6/redirect.t.payload.ip6   |  2 +-
 24 files changed, 248 insertions(+), 248 deletions(-)

diff --git a/tests/py/any/ct.t.payload b/tests/py/any/ct.t.payload
index 2f4ba4a7442e..51a825034901 100644
--- a/tests/py/any/ct.t.payload
+++ b/tests/py/any/ct.t.payload
@@ -1,7 +1,7 @@
 # ct state new,established, related, untracked
 ip test-ip4 output
   [ ct load state => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000004e ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000004e ) ^ 0x00000000 ]
   [ cmp neq reg 1 0x00000000 ]
 
 # ct state != related
@@ -28,21 +28,21 @@ ip test-ip4 output
 # ct state invalid drop
 ip test-ip4 output
   [ ct load state => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x00000001 ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000001 ) ^ 0x00000000 ]
   [ cmp neq reg 1 0x00000000 ]
   [ immediate reg 0 drop ]
 
 # ct state established accept
 ip test-ip4 output
   [ ct load state => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x00000002 ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000002 ) ^ 0x00000000 ]
   [ cmp neq reg 1 0x00000000 ]
   [ immediate reg 0 accept ]
 
 # ct state 8
 ip test-ip4 output
   [ ct load state => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x00000008 ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000008 ) ^ 0x00000000 ]
   [ cmp neq reg 1 0x00000000 ]
 
 # ct direction original
@@ -84,7 +84,7 @@ ip test-ip4 output
 # ct status expected
 ip test-ip4 output
   [ ct load status => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x00000001 ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000001 ) ^ 0x00000000 ]
   [ cmp neq reg 1 0x00000000 ]
 
 # ct status != expected
@@ -95,7 +95,7 @@ ip test-ip4 output
 # ct status seen-reply
 ip test-ip4 output
   [ ct load status => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x00000002 ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000002 ) ^ 0x00000000 ]
   [ cmp neq reg 1 0x00000000 ]
 
 # ct status != seen-reply
@@ -127,25 +127,25 @@ ip test-ip4 output
 # ct mark or 0x23 == 0x11
 ip test-ip4 output
   [ ct load mark => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0xffffffdc ) ^ 0x00000023 ]
+  [ bitwise reg 1 = ( reg 1 & 0xffffffdc ) ^ 0x00000023 ]
   [ cmp eq reg 1 0x00000011 ]
 
 # ct mark or 0x3 != 0x1
 ip test-ip4 output
   [ ct load mark => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0xfffffffc ) ^ 0x00000003 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfffffffc ) ^ 0x00000003 ]
   [ cmp neq reg 1 0x00000001 ]
 
 # ct mark and 0x23 == 0x11
 ip test-ip4 output
   [ ct load mark => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x00000023 ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000023 ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000011 ]
 
 # ct mark and 0x3 != 0x1
 ip test-ip4 output
   [ ct load mark => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x00000003 ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000003 ) ^ 0x00000000 ]
   [ cmp neq reg 1 0x00000001 ]
 
 # ct mark xor 0x23 == 0x11
@@ -332,7 +332,7 @@ ip test-ip4 output
 # ct mark set (meta mark | 0x10) << 8
 inet test-inet output
   [ meta load mark => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0xffffffef ) ^ 0x00000010 ]
+  [ bitwise reg 1 = ( reg 1 & 0xffffffef ) ^ 0x00000010 ]
   [ bitwise reg 1 = ( reg 1 << 0x00000008 ) ]
   [ ct set mark with reg 1 ]
 
@@ -378,19 +378,19 @@ ip test-ip4 output
 # ct status expected,seen-reply,assured,confirmed,snat,dnat,dying
 ip test-ip4 output
   [ ct load status => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000023f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000023f ) ^ 0x00000000 ]
   [ cmp neq reg 1 0x00000000 ]
 
 # ct status snat
 ip test-ip4 output
   [ ct load status => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x00000010 ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000010 ) ^ 0x00000000 ]
   [ cmp neq reg 1 0x00000000 ]
 
 # ct status dnat
 ip test-ip4 output
   [ ct load status => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x00000020 ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000020 ) ^ 0x00000000 ]
   [ cmp neq reg 1 0x00000000 ]
 
 # ct event set new
@@ -426,7 +426,7 @@ ip test-ip4 output
 # ct label 127
 ip test-ip4 output
   [ ct load label => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x00000000 0x00000000 0x00000000 0x80000000 ) ^ 0x00000000 0x00000000 0x00000000 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000000 0x00000000 0x00000000 0x80000000 ) ^ 0x00000000 0x00000000 0x00000000 0x00000000 ]
   [ cmp neq reg 1 0x00000000 0x00000000 0x00000000 0x00000000 ]
 
 # ct label set 127
@@ -503,7 +503,7 @@ ip test-ip4 output
 # ct mark set ct mark or 0x00000001
 ip test-ip4 output
   [ ct load mark => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0xfffffffe ) ^ 0x00000001 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfffffffe ) ^ 0x00000001 ]
   [ ct set mark with reg 1 ]
 
 # ct id 12345
diff --git a/tests/py/any/meta.t.payload b/tests/py/any/meta.t.payload
index 2af244a9e246..463365e203ad 100644
--- a/tests/py/any/meta.t.payload
+++ b/tests/py/any/meta.t.payload
@@ -136,13 +136,13 @@ ip test-ip4 input
 # meta mark and 0x03 == 0x01
 ip test-ip4 input
   [ meta load mark => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x00000003 ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000003 ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000001 ]
 
 # meta mark and 0x03 != 0x01
 ip test-ip4 input
   [ meta load mark => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x00000003 ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000003 ) ^ 0x00000000 ]
   [ cmp neq reg 1 0x00000001 ]
 
 # meta mark 0x10
@@ -158,13 +158,13 @@ ip test-ip4 input
 # meta mark or 0x03 == 0x01
 ip test-ip4 input
   [ meta load mark => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0xfffffffc ) ^ 0x00000003 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfffffffc ) ^ 0x00000003 ]
   [ cmp eq reg 1 0x00000001 ]
 
 # meta mark or 0x03 != 0x01
 ip test-ip4 input
   [ meta load mark => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0xfffffffc ) ^ 0x00000003 ]
+  [ bitwise reg 1 = ( reg 1 & 0xfffffffc ) ^ 0x00000003 ]
   [ cmp neq reg 1 0x00000001 ]
 
 # meta mark xor 0x03 == 0x01
diff --git a/tests/py/any/rawpayload.t.payload b/tests/py/any/rawpayload.t.payload
index a2cc663568e0..b3ca919fb6e5 100644
--- a/tests/py/any/rawpayload.t.payload
+++ b/tests/py/any/rawpayload.t.payload
@@ -34,13 +34,13 @@ inet test-inet input
 # @ll,0,1 1
 inet test-inet input
   [ payload load 1b @ link header + 0 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x00000080 ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000080 ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000080 ]
 
 # @ll,0,8 and 0x80 eq 0x80
 inet test-inet input
   [ payload load 1b @ link header + 0 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x00000080 ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000080 ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000080 ]
 
 # @ll,0,128 0xfedcba987654321001234567890abcde
diff --git a/tests/py/bridge/vlan.t.payload b/tests/py/bridge/vlan.t.payload
index bb8925e380c3..2f045d18e564 100644
--- a/tests/py/bridge/vlan.t.payload
+++ b/tests/py/bridge/vlan.t.payload
@@ -3,7 +3,7 @@ bridge test-bridge input
   [ payload load 2b @ link header + 12 => reg 1 ]
   [ cmp eq reg 1 0x00000081 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000ff0f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x0000fe0f ]
 
 # vlan id 0
@@ -11,7 +11,7 @@ bridge test-bridge input
   [ payload load 2b @ link header + 12 => reg 1 ]
   [ cmp eq reg 1 0x00000081 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000ff0f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000000 ]
 
 # vlan id 4094 vlan cfi 0
@@ -19,10 +19,10 @@ bridge test-bridge input
   [ payload load 2b @ link header + 12 => reg 1 ]
   [ cmp eq reg 1 0x00000081 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000ff0f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x0000fe0f ]
   [ payload load 1b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x00000010 ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000010 ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000000 ]
 
 # vlan id 4094 vlan cfi != 1
@@ -30,10 +30,10 @@ bridge test-bridge input
   [ payload load 2b @ link header + 12 => reg 1 ]
   [ cmp eq reg 1 0x00000081 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000ff0f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x0000fe0f ]
   [ payload load 1b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x00000010 ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000010 ) ^ 0x00000000 ]
   [ cmp neq reg 1 0x00000010 ]
 
 # vlan id 4094 vlan cfi 1
@@ -41,10 +41,10 @@ bridge test-bridge input
   [ payload load 2b @ link header + 12 => reg 1 ]
   [ cmp eq reg 1 0x00000081 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000ff0f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x0000fe0f ]
   [ payload load 1b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x00000010 ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000010 ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000010 ]
 
 # ether type vlan vlan id 4094
@@ -52,7 +52,7 @@ bridge test-bridge input
   [ payload load 2b @ link header + 12 => reg 1 ]
   [ cmp eq reg 1 0x00000081 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000ff0f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x0000fe0f ]
 
 # ether type vlan vlan id 0
@@ -60,7 +60,7 @@ bridge test-bridge input
   [ payload load 2b @ link header + 12 => reg 1 ]
   [ cmp eq reg 1 0x00000081 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000ff0f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000000 ]
 
 # ether type vlan vlan id 4094 vlan cfi 0
@@ -68,10 +68,10 @@ bridge test-bridge input
   [ payload load 2b @ link header + 12 => reg 1 ]
   [ cmp eq reg 1 0x00000081 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000ff0f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x0000fe0f ]
   [ payload load 1b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x00000010 ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000010 ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000000 ]
 
 # ether type vlan vlan id 4094 vlan cfi 1
@@ -79,10 +79,10 @@ bridge test-bridge input
   [ payload load 2b @ link header + 12 => reg 1 ]
   [ cmp eq reg 1 0x00000081 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000ff0f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x0000fe0f ]
   [ payload load 1b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x00000010 ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000010 ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000010 ]
 
 # vlan id 4094 tcp dport 22
@@ -90,7 +90,7 @@ bridge test-bridge input
   [ payload load 2b @ link header + 12 => reg 1 ]
   [ cmp eq reg 1 0x00000081 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000ff0f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x0000fe0f ]
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
@@ -102,7 +102,7 @@ bridge test-bridge input
   [ payload load 2b @ link header + 12 => reg 1 ]
   [ cmp eq reg 1 0x00000081 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000ff0f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000100 ]
   [ payload load 2b @ link header + 16 => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
@@ -114,12 +114,12 @@ bridge test-bridge input
   [ payload load 2b @ link header + 12 => reg 1 ]
   [ cmp eq reg 1 0x00000081 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000ff0f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000100 ]
   [ payload load 2b @ link header + 16 => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x00feffff ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00feffff ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x0000000a ]
 
 # vlan id 1 ip saddr 10.0.0.0/23 udp dport 53
@@ -127,12 +127,12 @@ bridge test-bridge input
   [ payload load 2b @ link header + 12 => reg 1 ]
   [ cmp eq reg 1 0x00000081 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000ff0f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000100 ]
   [ payload load 2b @ link header + 16 => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x00feffff ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00feffff ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x0000000a ]
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
@@ -144,12 +144,12 @@ bridge test-bridge input
   [ payload load 2b @ link header + 12 => reg 1 ]
   [ cmp eq reg 1 0x00000081 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000ff0f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000100 ]
   [ payload load 2b @ link header + 16 => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x00feffff ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00feffff ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x0000000a ]
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
@@ -161,13 +161,13 @@ bridge test-bridge input
   [ payload load 2b @ link header + 12 => reg 1 ]
   [ cmp eq reg 1 0x00000081 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000ff0f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x0000fe0f ]
   [ payload load 1b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x00000010 ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000010 ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000010 ]
   [ payload load 1b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x000000e0 ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000000e0 ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x000000e0 ]
 
 # vlan id 4094 vlan cfi 1 vlan pcp 3
@@ -175,13 +175,13 @@ bridge test-bridge input
   [ payload load 2b @ link header + 12 => reg 1 ]
   [ cmp eq reg 1 0x00000081 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000ff0f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x0000fe0f ]
   [ payload load 1b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x00000010 ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000010 ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000010 ]
   [ payload load 1b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x000000e0 ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000000e0 ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000060 ]
 
 # vlan id { 1, 2, 4, 100, 4095 } vlan pcp 1-3
@@ -192,10 +192,10 @@ bridge test-bridge input
   [ payload load 2b @ link header + 12 => reg 1 ]
   [ cmp eq reg 1 0x00000081 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000ff0f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
   [ lookup reg 1 set __set%d ]
   [ payload load 1b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x000000e0 ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000000e0 ) ^ 0x00000000 ]
   [ cmp gte reg 1 0x00000020 ]
   [ cmp lte reg 1 0x00000060 ]
 
diff --git a/tests/py/bridge/vlan.t.payload.netdev b/tests/py/bridge/vlan.t.payload.netdev
index 0a3f90a5dfd2..9d1fe557c7ac 100644
--- a/tests/py/bridge/vlan.t.payload.netdev
+++ b/tests/py/bridge/vlan.t.payload.netdev
@@ -5,7 +5,7 @@ netdev test-netdev ingress
   [ payload load 2b @ link header + 12 => reg 1 ]
   [ cmp eq reg 1 0x00000081 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000ff0f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x0000fe0f ]
 
 # vlan id 0
@@ -15,7 +15,7 @@ netdev test-netdev ingress
   [ payload load 2b @ link header + 12 => reg 1 ]
   [ cmp eq reg 1 0x00000081 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000ff0f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000000 ]
 
 # vlan id 4094 vlan cfi 0
@@ -25,10 +25,10 @@ netdev test-netdev ingress
   [ payload load 2b @ link header + 12 => reg 1 ]
   [ cmp eq reg 1 0x00000081 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000ff0f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x0000fe0f ]
   [ payload load 1b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x00000010 ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000010 ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000000 ]
 
 # vlan id 4094 vlan cfi != 1
@@ -38,10 +38,10 @@ netdev test-netdev ingress
   [ payload load 2b @ link header + 12 => reg 1 ]
   [ cmp eq reg 1 0x00000081 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000ff0f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x0000fe0f ]
   [ payload load 1b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x00000010 ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000010 ) ^ 0x00000000 ]
   [ cmp neq reg 1 0x00000010 ]
 
 # vlan id 4094 vlan cfi 1
@@ -51,10 +51,10 @@ netdev test-netdev ingress
   [ payload load 2b @ link header + 12 => reg 1 ]
   [ cmp eq reg 1 0x00000081 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000ff0f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x0000fe0f ]
   [ payload load 1b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x00000010 ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000010 ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000010 ]
 
 # ether type vlan vlan id 4094
@@ -64,7 +64,7 @@ netdev test-netdev ingress
   [ payload load 2b @ link header + 12 => reg 1 ]
   [ cmp eq reg 1 0x00000081 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000ff0f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x0000fe0f ]
 
 # ether type vlan vlan id 0
@@ -74,7 +74,7 @@ netdev test-netdev ingress
   [ payload load 2b @ link header + 12 => reg 1 ]
   [ cmp eq reg 1 0x00000081 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000ff0f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000000 ]
 
 # ether type vlan vlan id 4094 vlan cfi 0
@@ -84,10 +84,10 @@ netdev test-netdev ingress
   [ payload load 2b @ link header + 12 => reg 1 ]
   [ cmp eq reg 1 0x00000081 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000ff0f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x0000fe0f ]
   [ payload load 1b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x00000010 ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000010 ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000000 ]
 
 # ether type vlan vlan id 4094 vlan cfi 1
@@ -97,10 +97,10 @@ netdev test-netdev ingress
   [ payload load 2b @ link header + 12 => reg 1 ]
   [ cmp eq reg 1 0x00000081 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000ff0f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x0000fe0f ]
   [ payload load 1b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x00000010 ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000010 ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000010 ]
 
 # vlan id 4094 tcp dport 22
@@ -110,7 +110,7 @@ netdev test-netdev ingress
   [ payload load 2b @ link header + 12 => reg 1 ]
   [ cmp eq reg 1 0x00000081 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000ff0f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x0000fe0f ]
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
@@ -124,7 +124,7 @@ netdev test-netdev ingress
   [ payload load 2b @ link header + 12 => reg 1 ]
   [ cmp eq reg 1 0x00000081 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000ff0f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000100 ]
   [ payload load 2b @ link header + 16 => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
@@ -138,12 +138,12 @@ netdev test-netdev ingress
   [ payload load 2b @ link header + 12 => reg 1 ]
   [ cmp eq reg 1 0x00000081 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000ff0f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000100 ]
   [ payload load 2b @ link header + 16 => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x00feffff ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00feffff ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x0000000a ]
 
 # vlan id 1 ip saddr 10.0.0.0/23 udp dport 53
@@ -153,12 +153,12 @@ netdev test-netdev ingress
   [ payload load 2b @ link header + 12 => reg 1 ]
   [ cmp eq reg 1 0x00000081 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000ff0f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000100 ]
   [ payload load 2b @ link header + 16 => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x00feffff ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00feffff ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x0000000a ]
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
@@ -172,12 +172,12 @@ netdev test-netdev ingress
   [ payload load 2b @ link header + 12 => reg 1 ]
   [ cmp eq reg 1 0x00000081 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000ff0f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000100 ]
   [ payload load 2b @ link header + 16 => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x00feffff ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00feffff ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x0000000a ]
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
@@ -191,13 +191,13 @@ netdev test-netdev ingress
   [ payload load 2b @ link header + 12 => reg 1 ]
   [ cmp eq reg 1 0x00000081 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000ff0f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x0000fe0f ]
   [ payload load 1b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x00000010 ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000010 ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000010 ]
   [ payload load 1b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x000000e0 ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000000e0 ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x000000e0 ]
 
 # vlan id 4094 vlan cfi 1 vlan pcp 3
@@ -207,13 +207,13 @@ netdev test-netdev ingress
   [ payload load 2b @ link header + 12 => reg 1 ]
   [ cmp eq reg 1 0x00000081 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000ff0f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x0000fe0f ]
   [ payload load 1b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x00000010 ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000010 ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000010 ]
   [ payload load 1b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x000000e0 ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000000e0 ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000060 ]
 
 # vlan id { 1, 2, 4, 100, 4095 } vlan pcp 1-3
@@ -226,10 +226,10 @@ netdev test-netdev ingress
   [ payload load 2b @ link header + 12 => reg 1 ]
   [ cmp eq reg 1 0x00000081 ]
   [ payload load 2b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000ff0f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
   [ lookup reg 1 set __set%d ]
   [ payload load 1b @ link header + 14 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x000000e0 ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000000e0 ) ^ 0x00000000 ]
   [ cmp gte reg 1 0x00000020 ]
   [ cmp lte reg 1 0x00000060 ]
 
diff --git a/tests/py/inet/dccp.t.payload b/tests/py/inet/dccp.t.payload
index b5a48f403259..b830aa4f3e64 100644
--- a/tests/py/inet/dccp.t.payload
+++ b/tests/py/inet/dccp.t.payload
@@ -127,7 +127,7 @@ inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000021 ]
   [ payload load 1b @ transport header + 8 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000001e ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000001e ) ^ 0x00000000 ]
   [ lookup reg 1 set __set%d ]
 
 # dccp type != {request, response, data, ack, dataack, closereq, close, reset, sync, syncack}
@@ -138,7 +138,7 @@ inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000021 ]
   [ payload load 1b @ transport header + 8 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000001e ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000001e ) ^ 0x00000000 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # dccp type request
@@ -146,7 +146,7 @@ inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000021 ]
   [ payload load 1b @ transport header + 8 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000001e ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000001e ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000000 ]
 
 # dccp type != request
@@ -154,6 +154,6 @@ inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000021 ]
   [ payload load 1b @ transport header + 8 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000001e ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000001e ) ^ 0x00000000 ]
   [ cmp neq reg 1 0x00000000 ]
 
diff --git a/tests/py/inet/map.t.payload b/tests/py/inet/map.t.payload
index 16225cbd92c6..50344ada9161 100644
--- a/tests/py/inet/map.t.payload
+++ b/tests/py/inet/map.t.payload
@@ -17,7 +17,7 @@ inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
   [ payload load 1b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000000f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000000f ) ^ 0x00000000 ]
   [ lookup reg 1 set __map%d dreg 1 ]
   [ meta set mark with reg 1 ]
 
diff --git a/tests/py/inet/map.t.payload.ip b/tests/py/inet/map.t.payload.ip
index 595757496d9f..3e4566757339 100644
--- a/tests/py/inet/map.t.payload.ip
+++ b/tests/py/inet/map.t.payload.ip
@@ -13,7 +13,7 @@ __map%d test-ip4 0
 	element 00000005  : 00000017 0 [end]	element 00000004  : 00000001 0 [end]
 ip test-ip4 input 
   [ payload load 1b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000000f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000000f ) ^ 0x00000000 ]
   [ lookup reg 1 set __map%d dreg 1 ]
   [ meta set mark with reg 1 ]
 
diff --git a/tests/py/inet/map.t.payload.netdev b/tests/py/inet/map.t.payload.netdev
index 501fb8eec478..2e60f09d752d 100644
--- a/tests/py/inet/map.t.payload.netdev
+++ b/tests/py/inet/map.t.payload.netdev
@@ -17,7 +17,7 @@ netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 1b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000000f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000000f ) ^ 0x00000000 ]
   [ lookup reg 1 set __map%d dreg 1 ]
   [ meta set mark with reg 1 ]
 
diff --git a/tests/py/inet/tcp.t.payload b/tests/py/inet/tcp.t.payload
index 076e562a623c..3b7a4468ca2c 100644
--- a/tests/py/inet/tcp.t.payload
+++ b/tests/py/inet/tcp.t.payload
@@ -417,7 +417,7 @@ inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 1b @ transport header + 13 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x00000080 ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000080 ) ^ 0x00000000 ]
   [ cmp neq reg 1 0x00000000 ]
 
 # tcp flags != cwr
@@ -439,7 +439,7 @@ inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 1b @ transport header + 13 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x00000003 ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000003 ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000003 ]
 
 # tcp flags & (fin | syn | rst | psh | ack | urg | ecn | cwr) == fin | syn | rst | psh | ack | urg | ecn | cwr
@@ -447,7 +447,7 @@ inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 1b @ transport header + 13 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x000000ff ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000000ff ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x000000ff ]
 
 # tcp window 22222
@@ -677,7 +677,7 @@ inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 1b @ transport header + 12 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x000000f0 ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000000f0 ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000080 ]
 
 # tcp flags & (fin | syn | rst | psh | ack | urg) == { fin, ack, psh | ack, fin | psh | ack }
@@ -688,7 +688,7 @@ ip
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 1b @ transport header + 13 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000003f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000003f ) ^ 0x00000000 ]
   [ lookup reg 1 set __set%d ]
 
 # tcp flags { syn, syn | ack }
diff --git a/tests/py/inet/tproxy.t.payload b/tests/py/inet/tproxy.t.payload
index 82ff928db772..24bf8f6002f8 100644
--- a/tests/py/inet/tproxy.t.payload
+++ b/tests/py/inet/tproxy.t.payload
@@ -54,7 +54,7 @@ inet x y
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x00000000 ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000000 ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000000 ]
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
diff --git a/tests/py/ip/ip.t.payload b/tests/py/ip/ip.t.payload
index 825c0f0b1b6e..161ff0a5802b 100644
--- a/tests/py/ip/ip.t.payload
+++ b/tests/py/ip/ip.t.payload
@@ -1,25 +1,25 @@
 # ip dscp cs1
 ip test-ip4 input
   [ payload load 1b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x000000fc ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000020 ]
 
 # ip dscp != cs1
 ip test-ip4 input
   [ payload load 1b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x000000fc ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
   [ cmp neq reg 1 0x00000020 ]
 
 # ip dscp 0x38
 ip test-ip4 input
   [ payload load 1b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x000000fc ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x000000e0 ]
 
 # ip dscp != 0x20
 ip test-ip4 input
   [ payload load 1b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x000000fc ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
   [ cmp neq reg 1 0x00000080 ]
 
 # ip dscp {cs0, cs1, cs2, cs3, cs4, cs5, cs6, cs7, af11, af12, af13, af21, af22, af23, af31, af32, af33, af41, af42, af43, ef}
@@ -28,7 +28,7 @@ __set%d test-ip4 0
         element 00000020  : 0 [end]     element 00000040  : 0 [end]     element 00000060  : 0 [end]     element 00000080  : 0 [end]    element 000000a0  : 0 [end]      element 000000c0  : 0 [end]     element 000000e0  : 0 [end]     element 00000000  : 0 [end]     element 00000028  : 0 [end]     element 00000030  : 0 [end]     element 00000038  : 0 [end]     element 00000048  : 0 [end]     element 00000050  : 0 [end]     element 00000058  : 0 [end]     element 00000068  : 0 [end]     element 00000070  : 0 [end]     element 00000078  : 0 [end]     element 00000088  : 0 [end]     element 00000090  : 0 [end]     element 00000098  : 0 [end]     element 000000b8  : 0 [end]
 ip test-ip4 input
   [ payload load 1b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x000000fc ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
   [ lookup reg 1 set __set%d ]
 
 # ip dscp != {cs0, cs3}
@@ -37,7 +37,7 @@ __set%d test-ip4 0
         element 00000000  : 0 [end]     element 00000060  : 0 [end]
 ip test-ip4 input
   [ payload load 1b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x000000fc ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # ip dscp vmap { cs1 : continue , cs4 : accept } counter
@@ -46,7 +46,7 @@ __map%d test-ip4 0
 	element 00000020  : 0 [end]	element 00000080  : 0 [end]
 ip test-ip4 input 
   [ payload load 1b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x000000fc ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
   [ lookup reg 1 set __map%d dreg 0 ]
   [ counter pkts 0 bytes 0 ]
 
@@ -487,19 +487,19 @@ ip test-ip4 input
 # ip saddr & 0xff == 1
 ip test-ip4 input
   [ payload load 4b @ network header + 12 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0xff000000 ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0xff000000 ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x01000000 ]
 
 # ip saddr & 0.0.0.255 < 0.0.0.127
 ip test-ip4 input
   [ payload load 4b @ network header + 12 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0xff000000 ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0xff000000 ) ^ 0x00000000 ]
   [ cmp lt reg 1 0x7f000000 ]
 
 # ip saddr & 0xffff0000 == 0xffff0000
 ip test-ip4 input
   [ payload load 4b @ network header + 12 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000ffff ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000ffff ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x0000ffff ]
 
 # ip saddr . ip daddr . ip protocol { 1.1.1.1 . 2.2.2.2 . tcp, 1.1.1.1 . 3.3.3.3 . udp}
@@ -515,22 +515,22 @@ ip test-ip input
 # ip version 4 ip hdrlength 5
 ip test-ip4 input
   [ payload load 1b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x000000f0 ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000000f0 ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000040 ]
   [ payload load 1b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000000f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000000f ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000005 ]
 
 # ip hdrlength 0
 ip test-ip4 input
   [ payload load 1b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000000f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000000f ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000000 ]
 
 # ip hdrlength 15
 ip test-ip4 input
   [ payload load 1b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000000f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000000f ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x0000000f ]
 
 # ip hdrlength vmap { 0-4 : drop, 5 : accept, 6 : continue } counter
@@ -539,7 +539,7 @@ __map%d test-ip4 0
 	element 00000000  : 0 [end]	element 00000005  : 0 [end]	element 00000006  : 0 [end]	element 00000007  : 1 [end]
 ip test-ip4 input 
   [ payload load 1b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000000f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000000f ) ^ 0x00000000 ]
   [ lookup reg 1 set __map%d dreg 0 ]
   [ counter pkts 0 bytes 0 ]
 
@@ -569,7 +569,7 @@ ip test-ip4 input
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000fcff ) ^ 0x00000100 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000fcff ) ^ 0x00000100 ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # iif "lo" ip ecn set ce
@@ -577,7 +577,7 @@ ip test-ip4 input
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000fcff ) ^ 0x00000300 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000fcff ) ^ 0x00000300 ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # iif "lo" ip dscp set af23
@@ -585,7 +585,7 @@ ip test-ip4 input
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x000003ff ) ^ 0x00005800 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000003ff ) ^ 0x00005800 ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # iif "lo" ip dscp set cs0
@@ -593,7 +593,7 @@ ip test-ip4 input
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x000003ff ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000003ff ) ^ 0x00000000 ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # iif "lo" ip ttl set 23
@@ -601,7 +601,7 @@ ip test-ip4 input
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 2b @ network header + 8 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000ff00 ) ^ 0x00000017 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000ff00 ) ^ 0x00000017 ]
   [ payload write reg 1 => 2b @ network header + 8 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # iif "lo" ip protocol set 1
@@ -609,6 +609,6 @@ ip test-ip4 input
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 2b @ network header + 8 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x000000ff ) ^ 0x00000100 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000000ff ) ^ 0x00000100 ]
   [ payload write reg 1 => 2b @ network header + 8 csum_type 1 csum_off 10 csum_flags 0x1 ]
 
diff --git a/tests/py/ip/ip.t.payload.bridge b/tests/py/ip/ip.t.payload.bridge
index e958a5b4b4e9..6ac5e7404336 100644
--- a/tests/py/ip/ip.t.payload.bridge
+++ b/tests/py/ip/ip.t.payload.bridge
@@ -3,7 +3,7 @@ bridge test-bridge input
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 1b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x000000fc ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000020 ]
 
 # ip dscp != cs1
@@ -11,7 +11,7 @@ bridge test-bridge input
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 1b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x000000fc ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
   [ cmp neq reg 1 0x00000020 ]
 
 # ip dscp 0x38
@@ -19,7 +19,7 @@ bridge test-bridge input
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 1b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x000000fc ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x000000e0 ]
 
 # ip dscp != 0x20
@@ -27,7 +27,7 @@ bridge test-bridge input
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 1b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x000000fc ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
   [ cmp neq reg 1 0x00000080 ]
 
 # ip dscp {cs0, cs1, cs2, cs3, cs4, cs5, cs6, cs7, af11, af12, af13, af21, af22, af23, af31, af32, af33, af41, af42, af43, ef}
@@ -38,7 +38,7 @@ bridge test-bridge input
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 1b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x000000fc ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
   [ lookup reg 1 set __set%d ]
 
 # ip dscp != {cs0, cs3}
@@ -49,7 +49,7 @@ bridge test-bridge input
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 1b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x000000fc ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # ip dscp vmap { cs1 : continue , cs4 : accept } counter
@@ -60,7 +60,7 @@ bridge test-bridge input
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 1b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x000000fc ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
   [ lookup reg 1 set __map%d dreg 0 ]
   [ counter pkts 0 bytes 0 ]
 
@@ -637,7 +637,7 @@ bridge test-bridge input
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0xff000000 ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0xff000000 ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x01000000 ]
 
 # ip saddr & 0.0.0.255 < 0.0.0.127
@@ -645,7 +645,7 @@ bridge test-bridge input
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0xff000000 ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0xff000000 ) ^ 0x00000000 ]
   [ cmp lt reg 1 0x7f000000 ]
 
 # ip saddr & 0xffff0000 == 0xffff0000
@@ -653,7 +653,7 @@ bridge test-bridge input
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000ffff ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000ffff ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x0000ffff ]
 
 # ip version 4 ip hdrlength 5
@@ -661,10 +661,10 @@ bridge test-bridge input
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 1b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x000000f0 ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000000f0 ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000040 ]
   [ payload load 1b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000000f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000000f ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000005 ]
 
 # ip hdrlength 0
@@ -672,7 +672,7 @@ bridge test-bridge input
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 1b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000000f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000000f ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000000 ]
 
 # ip hdrlength 15
@@ -680,7 +680,7 @@ bridge test-bridge input
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 1b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000000f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000000f ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x0000000f ]
 
 # ip hdrlength vmap { 0-4 : drop, 5 : accept, 6 : continue } counter
@@ -691,7 +691,7 @@ bridge test-bridge input
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 1b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000000f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000000f ) ^ 0x00000000 ]
   [ lookup reg 1 set __map%d dreg 0 ]
   [ counter pkts 0 bytes 0 ]
 
@@ -729,7 +729,7 @@ bridge test-bridge input
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000fcff ) ^ 0x00000100 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000fcff ) ^ 0x00000100 ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # iif "lo" ip ecn set ce
@@ -739,7 +739,7 @@ bridge test-bridge input
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000fcff ) ^ 0x00000300 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000fcff ) ^ 0x00000300 ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # iif "lo" ip ttl set 23
@@ -749,7 +749,7 @@ bridge test-bridge input
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 2b @ network header + 8 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000ff00 ) ^ 0x00000017 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000ff00 ) ^ 0x00000017 ]
   [ payload write reg 1 => 2b @ network header + 8 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # iif "lo" ip protocol set 1
@@ -759,7 +759,7 @@ bridge test-bridge input
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 2b @ network header + 8 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x000000ff ) ^ 0x00000100 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000000ff ) ^ 0x00000100 ]
   [ payload write reg 1 => 2b @ network header + 8 csum_type 1 csum_off 10 csum_flags 0x1 ]
 
 # iif "lo" ip dscp set af23
@@ -769,7 +769,7 @@ bridge test-bridge input
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x000003ff ) ^ 0x00005800 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000003ff ) ^ 0x00005800 ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # iif "lo" ip dscp set cs0
@@ -779,6 +779,6 @@ bridge test-bridge input
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x000003ff ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000003ff ) ^ 0x00000000 ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
diff --git a/tests/py/ip/ip.t.payload.inet b/tests/py/ip/ip.t.payload.inet
index 650147391c97..c1d707481e86 100644
--- a/tests/py/ip/ip.t.payload.inet
+++ b/tests/py/ip/ip.t.payload.inet
@@ -3,7 +3,7 @@ inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
   [ payload load 1b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x000000fc ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000020 ]
 
 # ip dscp != cs1
@@ -11,7 +11,7 @@ inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
   [ payload load 1b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x000000fc ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
   [ cmp neq reg 1 0x00000020 ]
 
 # ip dscp 0x38
@@ -19,7 +19,7 @@ inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
   [ payload load 1b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x000000fc ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x000000e0 ]
 
 # ip dscp != 0x20
@@ -27,7 +27,7 @@ inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
   [ payload load 1b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x000000fc ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
   [ cmp neq reg 1 0x00000080 ]
 
 # ip dscp {cs0, cs1, cs2, cs3, cs4, cs5, cs6, cs7, af11, af12, af13, af21, af22, af23, af31, af32, af33, af41, af42, af43, ef}
@@ -38,7 +38,7 @@ inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
   [ payload load 1b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x000000fc ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
   [ lookup reg 1 set __set%d ]
 
 # ip dscp != {cs0, cs3}
@@ -49,7 +49,7 @@ inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
   [ payload load 1b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x000000fc ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # ip dscp vmap { cs1 : continue , cs4 : accept } counter
@@ -60,7 +60,7 @@ inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
   [ payload load 1b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x000000fc ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
   [ lookup reg 1 set __map%d dreg 0 ]
   [ counter pkts 0 bytes 0 ]
 
@@ -637,7 +637,7 @@ inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0xff000000 ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0xff000000 ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x01000000 ]
 
 # ip saddr & 0.0.0.255 < 0.0.0.127
@@ -645,7 +645,7 @@ inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0xff000000 ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0xff000000 ) ^ 0x00000000 ]
   [ cmp lt reg 1 0x7f000000 ]
 
 # ip saddr & 0xffff0000 == 0xffff0000
@@ -653,7 +653,7 @@ inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000ffff ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000ffff ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x0000ffff ]
 
 # ip saddr . ip daddr . ip protocol { 1.1.1.1 . 2.2.2.2 . tcp, 1.1.1.1 . 3.3.3.3 . udp}
@@ -673,10 +673,10 @@ inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
   [ payload load 1b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x000000f0 ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000000f0 ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000040 ]
   [ payload load 1b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000000f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000000f ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000005 ]
 
 # ip hdrlength 0
@@ -684,7 +684,7 @@ inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
   [ payload load 1b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000000f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000000f ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000000 ]
 
 # ip hdrlength 15
@@ -692,7 +692,7 @@ inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
   [ payload load 1b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000000f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000000f ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x0000000f ]
 
 # ip hdrlength vmap { 0-4 : drop, 5 : accept, 6 : continue } counter
@@ -703,7 +703,7 @@ inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
   [ payload load 1b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000000f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000000f ) ^ 0x00000000 ]
   [ lookup reg 1 set __map%d dreg 0 ]
   [ counter pkts 0 bytes 0 ]
 
@@ -741,7 +741,7 @@ inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000fcff ) ^ 0x00000100 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000fcff ) ^ 0x00000100 ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # iif "lo" ip ecn set ce
@@ -751,7 +751,7 @@ inet test-netdev ingress
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000fcff ) ^ 0x00000300 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000fcff ) ^ 0x00000300 ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # iif "lo" ip dscp set af23
@@ -761,7 +761,7 @@ inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x000003ff ) ^ 0x00005800 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000003ff ) ^ 0x00005800 ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # iif "lo" ip dscp set cs0
@@ -771,7 +771,7 @@ inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x000003ff ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000003ff ) ^ 0x00000000 ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # iif "lo" ip ttl set 23
@@ -781,7 +781,7 @@ inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
   [ payload load 2b @ network header + 8 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000ff00 ) ^ 0x00000017 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000ff00 ) ^ 0x00000017 ]
   [ payload write reg 1 => 2b @ network header + 8 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # iif "lo" ip protocol set 1
@@ -791,6 +791,6 @@ inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
   [ payload load 2b @ network header + 8 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x000000ff ) ^ 0x00000100 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000000ff ) ^ 0x00000100 ]
   [ payload write reg 1 => 2b @ network header + 8 csum_type 1 csum_off 10 csum_flags 0x1 ]
 
diff --git a/tests/py/ip/ip.t.payload.netdev b/tests/py/ip/ip.t.payload.netdev
index 58ae358bdc47..01044a583f6a 100644
--- a/tests/py/ip/ip.t.payload.netdev
+++ b/tests/py/ip/ip.t.payload.netdev
@@ -536,7 +536,7 @@ netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0xff000000 ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0xff000000 ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x01000000 ]
 
 # ip saddr & 0.0.0.255 < 0.0.0.127
@@ -544,7 +544,7 @@ netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0xff000000 ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0xff000000 ) ^ 0x00000000 ]
   [ cmp lt reg 1 0x7f000000 ]
 
 # ip saddr & 0xffff0000 == 0xffff0000
@@ -552,7 +552,7 @@ netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000ffff ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000ffff ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x0000ffff ]
 
 # ip version 4 ip hdrlength 5
@@ -560,10 +560,10 @@ netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 1b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x000000f0 ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000000f0 ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000040 ]
   [ payload load 1b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000000f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000000f ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000005 ]
 
 # ip hdrlength 0
@@ -571,7 +571,7 @@ netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 1b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000000f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000000f ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000000 ]
 
 # ip hdrlength 15
@@ -579,7 +579,7 @@ netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 1b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000000f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000000f ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x0000000f ]
 
 # ip hdrlength vmap { 0-4 : drop, 5 : accept, 6 : continue } counter
@@ -590,7 +590,7 @@ netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 1b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000000f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000000f ) ^ 0x00000000 ]
   [ lookup reg 1 set __map%d dreg 0 ]
   [ counter pkts 0 bytes 0 ]
 
@@ -746,7 +746,7 @@ netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 1b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x000000fc ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000020 ]
 
 # ip dscp != cs1
@@ -754,7 +754,7 @@ netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 1b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x000000fc ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
   [ cmp neq reg 1 0x00000020 ]
 
 # ip dscp 0x38
@@ -762,7 +762,7 @@ netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 1b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x000000fc ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x000000e0 ]
 
 # ip dscp != 0x20
@@ -770,7 +770,7 @@ netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 1b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x000000fc ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
   [ cmp neq reg 1 0x00000080 ]
 
 # ip dscp {cs0, cs1, cs2, cs3, cs4, cs5, cs6, cs7, af11, af12, af13, af21, af22, af23, af31, af32, af33, af41, af42, af43, ef}
@@ -781,7 +781,7 @@ netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 1b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x000000fc ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
   [ lookup reg 1 set __set%d ]
 
 # ip dscp != {cs0, cs3}
@@ -792,7 +792,7 @@ netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 1b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x000000fc ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # ip dscp vmap { cs1 : continue , cs4 : accept } counter
@@ -803,7 +803,7 @@ netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 1b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x000000fc ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
   [ lookup reg 1 set __map%d dreg 0 ]
   [ counter pkts 0 bytes 0 ]
 
@@ -841,7 +841,7 @@ netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000fcff ) ^ 0x00000100 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000fcff ) ^ 0x00000100 ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # iif "lo" ip ecn set ce
@@ -851,7 +851,7 @@ netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000fcff ) ^ 0x00000300 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000fcff ) ^ 0x00000300 ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # iif "lo" ip dscp set af23
@@ -861,7 +861,7 @@ netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x000003ff ) ^ 0x00005800 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000003ff ) ^ 0x00005800 ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # iif "lo" ip dscp set cs0
@@ -871,7 +871,7 @@ netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x000003ff ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000003ff ) ^ 0x00000000 ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # iif "lo" ip ttl set 23
@@ -881,7 +881,7 @@ netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 2b @ network header + 8 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000ff00 ) ^ 0x00000017 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000ff00 ) ^ 0x00000017 ]
   [ payload write reg 1 => 2b @ network header + 8 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
 # iif "lo" ip protocol set 1
@@ -891,6 +891,6 @@ netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 2b @ network header + 8 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x000000ff ) ^ 0x00000100 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000000ff ) ^ 0x00000100 ]
   [ payload write reg 1 => 2b @ network header + 8 csum_type 1 csum_off 10 csum_flags 0x1 ]
 
diff --git a/tests/py/ip/masquerade.t.payload b/tests/py/ip/masquerade.t.payload
index 0ba8d5a8d141..d5157d7139d4 100644
--- a/tests/py/ip/masquerade.t.payload
+++ b/tests/py/ip/masquerade.t.payload
@@ -117,7 +117,7 @@ ip test-ip4 postrouting
   [ meta load iifname => reg 1 ]
   [ cmp eq reg 1 0x30687465 0x00000000 0x00000000 0x00000000 ]
   [ ct load state => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000000a ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000000a ) ^ 0x00000000 ]
   [ cmp neq reg 1 0x00000000 ]
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
diff --git a/tests/py/ip/redirect.t.payload b/tests/py/ip/redirect.t.payload
index 7f8a74b0bd1b..bdfc6d72d005 100644
--- a/tests/py/ip/redirect.t.payload
+++ b/tests/py/ip/redirect.t.payload
@@ -199,7 +199,7 @@ ip test-ip4 output
   [ meta load iifname => reg 1 ]
   [ cmp eq reg 1 0x30687465 0x00000000 0x00000000 0x00000000 ]
   [ ct load state => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000000a ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000000a ) ^ 0x00000000 ]
   [ cmp neq reg 1 0x00000000 ]
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
diff --git a/tests/py/ip6/frag.t.payload.inet b/tests/py/ip6/frag.t.payload.inet
index ef44f1ae7ef6..917742ffbcf0 100644
--- a/tests/py/ip6/frag.t.payload.inet
+++ b/tests/py/ip6/frag.t.payload.inet
@@ -120,7 +120,7 @@ inet test-inet output
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x0000b000 ]
 
 # frag frag-off != 233
@@ -128,7 +128,7 @@ inet test-inet output
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
   [ cmp neq reg 1 0x00004807 ]
 
 # frag frag-off 33-45
@@ -136,7 +136,7 @@ inet test-inet output
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
   [ cmp gte reg 1 0x00000801 ]
   [ cmp lte reg 1 0x00006801 ]
 
@@ -145,7 +145,7 @@ inet test-inet output
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
   [ range neq reg 1 0x00000801 0x00006801 ]
 
 # frag frag-off { 33, 55, 67, 88}
@@ -156,7 +156,7 @@ inet test-inet output
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
   [ lookup reg 1 set __set%d ]
 
 # frag frag-off != { 33, 55, 67, 88}
@@ -167,7 +167,7 @@ inet test-inet output
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # frag frag-off { 33-55}
@@ -178,7 +178,7 @@ inet test-inet output
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
   [ lookup reg 1 set __set%d ]
 
 # frag frag-off != { 33-55}
@@ -189,7 +189,7 @@ inet test-inet output
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # frag more-fragments 1
@@ -197,7 +197,7 @@ inet test-inet output
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ exthdr load ipv6 1b @ 44 + 3 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x00000001 ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000001 ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000001 ]
 
 # frag id 1
@@ -281,7 +281,7 @@ inet test-inet output
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ exthdr load ipv6 1b @ 44 + 3 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x00000006 ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000006 ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000002 ]
 
 # frag more-fragments 0
@@ -289,7 +289,7 @@ inet test-inet output
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ exthdr load ipv6 1b @ 44 + 3 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x00000001 ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000001 ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000000 ]
 
 # frag more-fragments 1
@@ -297,6 +297,6 @@ inet test-inet output
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ exthdr load ipv6 1b @ 44 + 3 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x00000001 ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000001 ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000001 ]
 
diff --git a/tests/py/ip6/frag.t.payload.ip6 b/tests/py/ip6/frag.t.payload.ip6
index 940fb9f0a778..2405fff81389 100644
--- a/tests/py/ip6/frag.t.payload.ip6
+++ b/tests/py/ip6/frag.t.payload.ip6
@@ -90,26 +90,26 @@ ip6 test-ip6 output
 # frag frag-off 22
 ip6 test-ip6 output
   [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x0000b000 ]
 
 # frag frag-off != 233
 ip6 test-ip6 output
   [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
   [ cmp neq reg 1 0x00004807 ]
 
 # frag frag-off 33-45
 ip6 test-ip6 output
   [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
   [ cmp gte reg 1 0x00000801 ]
   [ cmp lte reg 1 0x00006801 ]
 
 # frag frag-off != 33-45
 ip6 test-ip6 output
   [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
   [ range neq reg 1 0x00000801 0x00006801 ]
 
 # frag frag-off { 33, 55, 67, 88}
@@ -118,7 +118,7 @@ __set%d test-ip6 0
 	element 00000801  : 0 [end]	element 0000b801  : 0 [end]	element 00001802  : 0 [end]	element 0000c002  : 0 [end]
 ip6 test-ip6 output
   [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
   [ lookup reg 1 set __set%d ]
 
 # frag frag-off != { 33, 55, 67, 88}
@@ -127,7 +127,7 @@ __set%d test-ip6 0
 	element 00000801  : 0 [end]	element 0000b801  : 0 [end]	element 00001802  : 0 [end]	element 0000c002  : 0 [end]
 ip6 test-ip6 output
   [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # frag frag-off { 33-55}
@@ -136,7 +136,7 @@ __set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00000801  : 0 [end]	element 0000b901  : 1 [end]
 ip6 test-ip6 output 
   [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
   [ lookup reg 1 set __set%d ]
 
 # frag frag-off != { 33-55}
@@ -145,13 +145,13 @@ __set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00000801  : 0 [end]	element 0000b901  : 1 [end]
 ip6 test-ip6 output 
   [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # frag more-fragments 1
 ip6 test-ip6 output
   [ exthdr load ipv6 1b @ 44 + 3 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x00000001 ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000001 ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000001 ]
 
 # frag id 1
@@ -215,18 +215,18 @@ ip6 test-ip6 output
 # frag reserved2 1
 ip6 test-ip6 output
   [ exthdr load ipv6 1b @ 44 + 3 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x00000006 ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000006 ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000002 ]
 
 # frag more-fragments 0
 ip6 test-ip6 output
   [ exthdr load ipv6 1b @ 44 + 3 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x00000001 ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000001 ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000000 ]
 
 # frag more-fragments 1
 ip6 test-ip6 output
   [ exthdr load ipv6 1b @ 44 + 3 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x00000001 ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000001 ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000001 ]
 
diff --git a/tests/py/ip6/ip6.t.payload.inet b/tests/py/ip6/ip6.t.payload.inet
index ffc9b9f5b560..8912aadf116c 100644
--- a/tests/py/ip6/ip6.t.payload.inet
+++ b/tests/py/ip6/ip6.t.payload.inet
@@ -3,7 +3,7 @@ inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000c00f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000c00f ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000002 ]
 
 # ip6 dscp != cs1
@@ -11,7 +11,7 @@ inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000c00f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000c00f ) ^ 0x00000000 ]
   [ cmp neq reg 1 0x00000002 ]
 
 # ip6 dscp 0x38
@@ -19,7 +19,7 @@ inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000c00f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000c00f ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x0000000e ]
 
 # ip6 dscp != 0x20
@@ -27,7 +27,7 @@ inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000c00f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000c00f ) ^ 0x00000000 ]
   [ cmp neq reg 1 0x00000008 ]
 
 # ip6 dscp {cs0, cs1, cs2, cs3, cs4, cs5, cs6, cs7, af11, af12, af13, af21, af22, af23, af31, af32, af33, af41, af42, af43, ef}
@@ -38,7 +38,7 @@ inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000c00f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000c00f ) ^ 0x00000000 ]
   [ lookup reg 1 set __set%d ]
 
 # ip6 dscp vmap { 0x04 : accept, 0x3f : continue } counter
@@ -49,7 +49,7 @@ ip6 test-ip6 input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000c00f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000c00f ) ^ 0x00000000 ]
   [ lookup reg 1 set __map%d dreg 0 ]
   [ counter pkts 0 bytes 0 ]
 
@@ -58,7 +58,7 @@ inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ payload load 3b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x00ffff0f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00ffff0f ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00160000 ]
 
 # ip6 flowlabel != 233
@@ -66,7 +66,7 @@ inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ payload load 3b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x00ffff0f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00ffff0f ) ^ 0x00000000 ]
   [ cmp neq reg 1 0x00e90000 ]
 
 # ip6 flowlabel { 33, 55, 67, 88}
@@ -77,7 +77,7 @@ inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ payload load 3b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x00ffff0f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00ffff0f ) ^ 0x00000000 ]
   [ lookup reg 1 set __set%d ]
 
 # ip6 flowlabel != { 33, 55, 67, 88}
@@ -88,7 +88,7 @@ inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ payload load 3b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x00ffff0f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00ffff0f ) ^ 0x00000000 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # ip6 flowlabel { 33-55}
@@ -99,7 +99,7 @@ inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ payload load 3b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x00ffff0f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00ffff0f ) ^ 0x00000000 ]
   [ lookup reg 1 set __set%d ]
 
 # ip6 flowlabel != { 33-55}
@@ -110,7 +110,7 @@ inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ payload load 3b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x00ffff0f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00ffff0f ) ^ 0x00000000 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # ip6 flowlabel vmap { 0 : accept, 2 : continue } 
@@ -121,7 +121,7 @@ inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ payload load 3b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x00ffff0f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00ffff0f ) ^ 0x00000000 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 length 22
@@ -658,7 +658,7 @@ inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x00003ff0 ) ^ 0x00000009 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00003ff0 ) ^ 0x00000009 ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 0 csum_off 0 csum_flags 0x0 ]
 
 # iif "lo" ip6 dscp set 63
@@ -668,7 +668,7 @@ inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x00003ff0 ) ^ 0x0000c00f ]
+  [ bitwise reg 1 = ( reg 1 & 0x00003ff0 ) ^ 0x0000c00f ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 0 csum_off 0 csum_flags 0x0 ]
 
 # iif "lo" ip6 ecn set ect0
@@ -678,7 +678,7 @@ inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ payload load 1b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x000000cf ) ^ 0x00000020 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000000cf ) ^ 0x00000020 ]
   [ payload write reg 1 => 1b @ network header + 1 csum_type 0 csum_off 0 csum_flags 0x0 ]
 
 # iif "lo" ip6 ecn set ce
@@ -688,7 +688,7 @@ inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ payload load 1b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x000000cf ) ^ 0x00000030 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000000cf ) ^ 0x00000030 ]
   [ payload write reg 1 => 1b @ network header + 1 csum_type 0 csum_off 0 csum_flags 0x0 ]
 
 # iif "lo" ip6 flowlabel set 0
@@ -698,7 +698,7 @@ inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ payload load 3b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x000000f0 ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000000f0 ) ^ 0x00000000 ]
   [ payload write reg 1 => 3b @ network header + 1 csum_type 0 csum_off 0 csum_flags 0x0 ]
 
 # iif "lo" ip6 flowlabel set 12345
@@ -708,7 +708,7 @@ inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ payload load 3b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x000000f0 ) ^ 0x00393000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000000f0 ) ^ 0x00393000 ]
   [ payload write reg 1 => 3b @ network header + 1 csum_type 0 csum_off 0 csum_flags 0x0 ]
 
 # iif "lo" ip6 flowlabel set 0xfffff
@@ -718,6 +718,6 @@ inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ payload load 3b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x000000f0 ) ^ 0x00ffff0f ]
+  [ bitwise reg 1 = ( reg 1 & 0x000000f0 ) ^ 0x00ffff0f ]
   [ payload write reg 1 => 3b @ network header + 1 csum_type 0 csum_off 0 csum_flags 0x0 ]
 
diff --git a/tests/py/ip6/ip6.t.payload.ip6 b/tests/py/ip6/ip6.t.payload.ip6
index 18b8bcbe601a..287d58ac00bf 100644
--- a/tests/py/ip6/ip6.t.payload.ip6
+++ b/tests/py/ip6/ip6.t.payload.ip6
@@ -1,25 +1,25 @@
 # ip6 dscp cs1
 ip6 test-ip6 input
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000c00f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000c00f ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000002 ]
 
 # ip6 dscp != cs1
 ip6 test-ip6 input
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000c00f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000c00f ) ^ 0x00000000 ]
   [ cmp neq reg 1 0x00000002 ]
 
 # ip6 dscp 0x38
 ip6 test-ip6 input
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000c00f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000c00f ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x0000000e ]
 
 # ip6 dscp != 0x20
 ip6 test-ip6 input
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000c00f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000c00f ) ^ 0x00000000 ]
   [ cmp neq reg 1 0x00000008 ]
 
 # ip6 dscp {cs0, cs1, cs2, cs3, cs4, cs5, cs6, cs7, af11, af12, af13, af21, af22, af23, af31, af32, af33, af41, af42, af43, ef}
@@ -28,7 +28,7 @@ __set%d test-ip6 0
         element 00000002  : 0 [end]     element 00000004  : 0 [end]     element 00000006  : 0 [end]     element 00000008  : 0 [end]    element 0000000a  : 0 [end]      element 0000000c  : 0 [end]     element 0000000e  : 0 [end]     element 00000000  : 0 [end]     element 00008002  : 0 [end]     element 00000003  : 0 [end]     element 00008003  : 0 [end]     element 00008004  : 0 [end]     element 00000005  : 0 [end]     element 00008005  : 0 [end]     element 00008006  : 0 [end]     element 00000007  : 0 [end]     element 00008007  : 0 [end]     element 00008008  : 0 [end]     element 00000009  : 0 [end]     element 00008009  : 0 [end]     element 0000800b  : 0 [end]
 ip6 test-ip6 input
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000c00f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000c00f ) ^ 0x00000000 ]
   [ lookup reg 1 set __set%d ]
 
 # ip6 dscp vmap { 0x04 : accept, 0x3f : continue } counter
@@ -37,20 +37,20 @@ __map%d test-ip6 0
 	element 00000001  : 0 [end]	element 0000c00f  : 0 [end]
 ip6 test-ip6 input
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000c00f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000c00f ) ^ 0x00000000 ]
   [ lookup reg 1 set __map%d dreg 0 ]
   [ counter pkts 0 bytes 0 ]
 
 # ip6 flowlabel 22
 ip6 test-ip6 input
   [ payload load 3b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x00ffff0f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00ffff0f ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00160000 ]
 
 # ip6 flowlabel != 233
 ip6 test-ip6 input
   [ payload load 3b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x00ffff0f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00ffff0f ) ^ 0x00000000 ]
   [ cmp neq reg 1 0x00e90000 ]
 
 # ip6 flowlabel { 33, 55, 67, 88}
@@ -59,7 +59,7 @@ __set%d test-ip6 0
 	element 00210000  : 0 [end]	element 00370000  : 0 [end]	element 00430000  : 0 [end]	element 00580000  : 0 [end]
 ip6 test-ip6 input
   [ payload load 3b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x00ffff0f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00ffff0f ) ^ 0x00000000 ]
   [ lookup reg 1 set __set%d ]
 
 # ip6 flowlabel != { 33, 55, 67, 88}
@@ -68,7 +68,7 @@ __set%d test-ip6 0
 	element 00210000  : 0 [end]	element 00370000  : 0 [end]	element 00430000  : 0 [end]	element 00580000  : 0 [end]
 ip6 test-ip6 input
   [ payload load 3b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x00ffff0f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00ffff0f ) ^ 0x00000000 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # ip6 flowlabel { 33-55}
@@ -77,7 +77,7 @@ __set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00210000  : 0 [end]	element 00380000  : 1 [end]
 ip6 test-ip6 input
   [ payload load 3b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x00ffff0f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00ffff0f ) ^ 0x00000000 ]
   [ lookup reg 1 set __set%d ]
 
 # ip6 flowlabel != { 33-55}
@@ -86,7 +86,7 @@ __set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00210000  : 0 [end]	element 00380000  : 1 [end]
 ip6 test-ip6 input
   [ payload load 3b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x00ffff0f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00ffff0f ) ^ 0x00000000 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
 # ip6 flowlabel vmap { 0 : accept, 2 : continue } 
@@ -95,7 +95,7 @@ __map%d test-ip6 0
 	element 00000000  : 0 [end]	element 00020000  : 0 [end]
 ip6 test-ip6 input 
   [ payload load 3b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x00ffff0f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00ffff0f ) ^ 0x00000000 ]
   [ lookup reg 1 set __map%d dreg 0 ]
 
 # ip6 length 22
@@ -494,7 +494,7 @@ ip6 test-ip6 input
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x00003ff0 ) ^ 0x00000009 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00003ff0 ) ^ 0x00000009 ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 0 csum_off 0 csum_flags 0x0 ]
 
 # iif "lo" ip6 dscp set 63
@@ -502,7 +502,7 @@ ip6 test-ip6 input
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x00003ff0 ) ^ 0x0000c00f ]
+  [ bitwise reg 1 = ( reg 1 & 0x00003ff0 ) ^ 0x0000c00f ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 0 csum_off 0 csum_flags 0x0 ]
 
 # iif "lo" ip6 ecn set ect0
@@ -510,7 +510,7 @@ ip6 test-ip6 input
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 1b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x000000cf ) ^ 0x00000020 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000000cf ) ^ 0x00000020 ]
   [ payload write reg 1 => 1b @ network header + 1 csum_type 0 csum_off 0 csum_flags 0x0 ]
 
 # iif "lo" ip6 ecn set ce
@@ -518,7 +518,7 @@ ip6 test-ip6 input
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 1b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x000000cf ) ^ 0x00000030 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000000cf ) ^ 0x00000030 ]
   [ payload write reg 1 => 1b @ network header + 1 csum_type 0 csum_off 0 csum_flags 0x0 ]
 
 # iif "lo" ip6 flowlabel set 0
@@ -526,7 +526,7 @@ ip6 test-ip6 input
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 3b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x000000f0 ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000000f0 ) ^ 0x00000000 ]
   [ payload write reg 1 => 3b @ network header + 1 csum_type 0 csum_off 0 csum_flags 0x0 ]
 
 # iif "lo" ip6 flowlabel set 12345
@@ -534,7 +534,7 @@ ip6 test-ip6 input
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 3b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x000000f0 ) ^ 0x00393000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000000f0 ) ^ 0x00393000 ]
   [ payload write reg 1 => 3b @ network header + 1 csum_type 0 csum_off 0 csum_flags 0x0 ]
 
 # iif "lo" ip6 flowlabel set 0xfffff
@@ -542,6 +542,6 @@ ip6 test-ip6 input
   [ meta load iif => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 3b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x000000f0 ) ^ 0x00ffff0f ]
+  [ bitwise reg 1 = ( reg 1 & 0x000000f0 ) ^ 0x00ffff0f ]
   [ payload write reg 1 => 3b @ network header + 1 csum_type 0 csum_off 0 csum_flags 0x0 ]
 
diff --git a/tests/py/ip6/map.t.payload b/tests/py/ip6/map.t.payload
index 9b393a60f275..8e900c18c5e3 100644
--- a/tests/py/ip6/map.t.payload
+++ b/tests/py/ip6/map.t.payload
@@ -4,7 +4,7 @@ __map%d test-ip6 0
 	element 00000000 00000000 00000000 02000000  : 0000002a 0 [end]	element 00000000 00000000 00000000 ffff0000  : 00000017 0 [end]
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x00000000 0x00000000 0x00000000 0xffff0000 ) ^ 0x00000000 0x00000000 0x00000000 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000000 0x00000000 0x00000000 0xffff0000 ) ^ 0x00000000 0x00000000 0x00000000 0x00000000 ]
   [ lookup reg 1 set __map%d dreg 1 ]
   [ meta set mark with reg 1 ]
 
diff --git a/tests/py/ip6/masquerade.t.payload.ip6 b/tests/py/ip6/masquerade.t.payload.ip6
index f9f6f0740172..06b79d8ecd67 100644
--- a/tests/py/ip6/masquerade.t.payload.ip6
+++ b/tests/py/ip6/masquerade.t.payload.ip6
@@ -117,7 +117,7 @@ ip6 test-ip6 postrouting
   [ meta load iifname => reg 1 ]
   [ cmp eq reg 1 0x30687465 0x00000000 0x00000000 0x00000000 ]
   [ ct load state => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000000a ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000000a ) ^ 0x00000000 ]
   [ cmp neq reg 1 0x00000000 ]
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
diff --git a/tests/py/ip6/redirect.t.payload.ip6 b/tests/py/ip6/redirect.t.payload.ip6
index 104b9fd619f5..20405cea54ef 100644
--- a/tests/py/ip6/redirect.t.payload.ip6
+++ b/tests/py/ip6/redirect.t.payload.ip6
@@ -183,7 +183,7 @@ ip6 test-ip6 output
   [ meta load iifname => reg 1 ]
   [ cmp eq reg 1 0x30687465 0x00000000 0x00000000 0x00000000 ]
   [ ct load state => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0x0000000a ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000000a ) ^ 0x00000000 ]
   [ cmp neq reg 1 0x00000000 ]
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
-- 
2.29.2

