From: Ana Rey Botello <anarey@gmail.com>
Subject: [PATCH] tests: regression: any/meta: revisit meta tests
Date: Fri, 20 Feb 2015 12:28:54 +0100
Message-ID: <1424431734-2305-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:56173 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753976AbbBTL2F (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Feb 2015 06:28:05 -0500
Received: by mail-wi0-f179.google.com with SMTP id hi2so2249697wib.0
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Feb 2015 03:28:04 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Ana Rey <anarey@gmail.com>

Add, delete and rewrite some default outputs depending on the case.

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 tests/regression/any/meta.t |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/tests/regression/any/meta.t b/tests/regression/any/meta.t
index f11fd00..4b3d3fa 100644
--- a/tests/regression/any/meta.t
+++ b/tests/regression/any/meta.t
@@ -9,8 +9,8 @@
 meta length 1000;ok
 meta length 22;ok
 meta length != 233;ok
-meta length 33-45;ok
-meta length != 33-45;ok
+meta length 33-45;ok;meta length >= 33 meta length <= 45
+meta length != 33-45;ok;meta length < 33 meta length > 45
 meta length { 33, 55, 67, 88};ok
 - meta length != { 33, 55, 67, 88};ok
 meta length { 33-55};ok
@@ -96,8 +96,8 @@ meta skuid != man;ok;skuid != 6
 meta skuid lt 3000 accept;ok;skuid < 3000 accept
 meta skuid gt 3000 accept;ok;skuid > 3000 accept
 meta skuid eq 3000 accept;ok;skuid 3000 accept
-meta skuid 3001-3005 accept;ok
-meta skuid != 2001-2005 accept;ok
+meta skuid 3001-3005 accept;ok;skuid >= 3001 skuid <= 3005 accept
+meta skuid != 2001-2005 accept;ok;skuid < 2001 skuid > 2005 accept
 meta skuid { 2001-2005} accept;ok
 - meta skuid != { 2001-2005} accept;ok
 
@@ -108,8 +108,8 @@ meta skgid != man;ok;skgid != 12
 meta skgid lt 3000 accept;ok;skgid < 3000 accept
 meta skgid gt 3000 accept;ok;skgid > 3000 accept
 meta skgid eq 3000 accept;ok;skgid 3000 accept
-meta skgid 2001-2005 accept;ok
-meta skgid != 2001-2005 accept;ok
+meta skgid 2001-2005 accept;ok;skgid >= 2001 skgid <= 2005 accept
+meta skgid != 2001-2005 accept;ok;skgid < 2001 skgid > 2005 accept
 meta skgid { 2001-2005} accept;ok
 - meta skgid != { 2001-2005} accept;ok
 
@@ -123,14 +123,14 @@ meta skgid { 2001-2005} accept;ok
 # add rule ip test input meta nftrace 1
 # -^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
-meta mark set 0xffffffc8 xor 0x16;ok;meta mark set 0xffffffde
-meta mark set 0x16 and 0x16;ok;meta mark set 0x00000016
-meta mark set 0xffffffe9 or 0x16;ok;meta mark set 0xffffffff
-meta mark set 0xffffffde and 0x16;ok;meta mark set 0x00000016
-meta mark set 0xf045ffde or 0x10;ok;meta mark set 0xf045ffde
-meta mark set 0xffffffde or 0x16;ok;meta mark set 0xffffffde
-meta mark set 0x32 or 0xfffff;ok;meta mark set 0x000fffff
-meta mark set 0xfffe xor 0x16;ok;meta mark set 0x0000ffe8
+meta mark set 0xffffffc8 xor 0x16;ok;mark set 0xffffffde
+meta mark set 0x16 and 0x16;ok;mark set 0x00000016
+meta mark set 0xffffffe9 or 0x16;ok;mark set 0xffffffff
+meta mark set 0xffffffde and 0x16;ok;mark set 0x00000016
+meta mark set 0xf045ffde or 0x10;ok;mark set 0xf045ffde
+meta mark set 0xffffffde or 0x16;ok;mark set 0xffffffde
+meta mark set 0x32 or 0xfffff;ok;mark set 0x000fffff
+meta mark set 0xfffe xor 0x16;ok;mark set 0x0000ffe8
 
 meta iif lo;ok;iif lo
 meta oif lo;ok;oif lo
-- 
1.7.10.4

