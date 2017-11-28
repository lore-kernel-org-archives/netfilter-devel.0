From: Harsha Sharma <harshasharmaiitr@gmail.com>
Subject: [PATCH] tests/py: add test for empty string match
Date: Tue, 28 Nov 2017 16:55:49 +0530
Message-ID: <20171128112549.24734-1-harshasharmaiitr@gmail.com>
Cc: netfilter-devel@vger.kernel.org,
        Harsha Sharma <harshasharmaiitr@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f176.google.com ([209.85.192.176]:36585 "EHLO
        mail-pf0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753097AbdK1L0a (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Nov 2017 06:26:30 -0500
Received: by mail-pf0-f176.google.com with SMTP id i15so3802pfa.3
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Nov 2017 03:26:29 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch add tests for empty string match which fails with error "Empty
string is not allowed".

Signed-off-by: Harsha Sharma <harshasharmaiitr@gmail.com>
---
 tests/py/any/ct.t   | 1 +
 tests/py/any/meta.t | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/tests/py/any/ct.t b/tests/py/any/ct.t
index fb3ae09..9c88140 100644
--- a/tests/py/any/ct.t
+++ b/tests/py/any/ct.t
@@ -75,6 +75,7 @@ ct expiration != {33-55};ok; ct expiration != { 33s-55s}
 
 ct helper "ftp";ok
 ct helper "12345678901234567";fail
+ct helper '""';fail
 
 ct state . ct mark { new . 0x12345678};ok
 ct state . ct mark { new . 0x12345678, new . 0x34127856, established . 0x12785634};ok
diff --git a/tests/py/any/meta.t b/tests/py/any/meta.t
index dd335ab..a38c501 100644
--- a/tests/py/any/meta.t
+++ b/tests/py/any/meta.t
@@ -71,6 +71,7 @@ meta iifname {"dummy0", "lo"};ok
 meta iifname != {"dummy0", "lo"};ok
 meta iifname "dummy*";ok;iifname "dummy*"
 meta iifname "dummy\*";ok;iifname "dummy\*"
+meta iifname '""';fail
 
 meta iiftype {ether, ppp, ipip, ipip6, loopback, sit, ipgre};ok
 meta iiftype != {ether, ppp, ipip, ipip6, loopback, sit, ipgre};ok
@@ -89,6 +90,7 @@ meta oifname != "dummy0";ok;oifname != "dummy0"
 meta oifname { "dummy0", "lo"};ok
 meta oifname "dummy*";ok;oifname "dummy*"
 meta oifname "dummy\*";ok;oifname "dummy\*"
+meta oifname '""';fail
 
 meta oiftype {ether, ppp, ipip, ipip6, loopback, sit, ipgre};ok
 meta oiftype != {ether, ppp, ipip, ipip6, loopback, sit, ipgre};ok
-- 
2.11.0

