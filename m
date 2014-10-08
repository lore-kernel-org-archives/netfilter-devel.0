From: Ana Rey <anarey@gmail.com>
Subject: [PATCH] tests: regression: Delete all reference to wlan0 in test files.
Date: Wed,  8 Oct 2014 14:52:09 +0200
Message-ID: <1412772730-29161-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:56391 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932134AbaJHMwN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Oct 2014 08:52:13 -0400
Received: by mail-wi0-f173.google.com with SMTP id fb4so10507420wid.0
        for <netfilter-devel@vger.kernel.org>; Wed, 08 Oct 2014 05:52:12 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

There are false errors if it uses the automated regression testing
without a wlan0 device in the system.

Deletes references to 'wlan0' in test files and replaces 'wlan0' by 'lo'
or 'eth0' in the test files if it is possible.

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 tests/regression/any/meta.t |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/tests/regression/any/meta.t b/tests/regression/any/meta.t
index 2c2609d..5bc3872 100644
--- a/tests/regression/any/meta.t
+++ b/tests/regression/any/meta.t
@@ -57,15 +57,15 @@ meta mark or 0x03 != 0x01;ok;mark | 0x00000003 != 0x00000001
 meta mark xor 0x03 == 0x01;ok;mark 0x00000002
 meta mark xor 0x03 != 0x01;ok;mark != 0x00000002
 
-meta iif wlan0 accept;ok;iif wlan0 accept
 meta iif eth0 accept;ok;iif eth0 accept
-meta iif != wlan0 accept;ok;iif != wlan0 accept
+meta iif eth0 accept;ok;iif eth0 accept
+meta iif != eth0 accept;ok;iif != eth0 accept
 meta iif != eth0 accept;ok;iif != eth0 accept
 
 meta iifname "eth0";ok;iifname "eth0"
 meta iifname != "eth0";ok;iifname != "eth0"
-meta iifname {"eth0", "wlan0"};ok
-- meta iifname != {"eth0", "wlan0"};ok
+meta iifname {"eth0", "lo"};ok
+- meta iifname != {"eth0", "lo"};ok
 
 meta iiftype {ether, ppp, ipip, ipip6, loopback, sit, ipgre};ok
 - meta iiftype != {ether, ppp, ipip, ipip6, loopback, sit, ipgre};ok
@@ -76,13 +76,13 @@ meta iiftype ppp;ok;iiftype ppp
 
 meta oif lo accept;ok;oif lo accept
 meta oif != lo accept;ok;oif != lo accept
-meta oif {wlan0, eth0, lo} accept;ok
-- meta oif != {wlan0, eth0, lo} accept;ok
+meta oif {eth0, lo} accept;ok
+- meta oif != {eth0, lo} accept;ok
 
 meta oifname "eth0";ok;oifname "eth0"
 meta oifname != "eth0";ok;oifname != "eth0"
-meta oifname { "eth0", "wlan0"};ok
-- meta iifname != {"eth0", "wlan0"};ok
+meta oifname { "eth0", "lo"};ok
+- meta iifname != {"eth0", "lo"};ok
 
 meta oiftype {ether, ppp, ipip, ipip6, loopback, sit, ipgre};ok
 - meta oiftype != {ether, ppp, ipip, ipip6, loopback, sit, ipgre};ok
-- 
1.7.10.4

