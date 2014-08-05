From: Ana Rey <anarey@gmail.com>
Subject: [nft PATCH] tests: Add tests for pkttype attribute.
Date: Tue,  5 Aug 2014 20:35:01 +0200
Message-ID: <1407263701-4692-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:54666 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755255AbaHESc5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Aug 2014 14:32:57 -0400
Received: by mail-wi0-f175.google.com with SMTP id ho1so7468968wib.14
        for <netfilter-devel@vger.kernel.org>; Tue, 05 Aug 2014 11:32:55 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add some tests to check the pkttype attribute of meta expresion.

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 tests/any/meta.t |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/tests/any/meta.t b/tests/any/meta.t
index 76259d1..7361962 100644
--- a/tests/any/meta.t
+++ b/tests/any/meta.t
@@ -155,3 +155,12 @@ meta skuid 3000;ok;skuid 3000
 meta skgid 3000;ok;skgid 3000
 -meta nftrace 1;ok
 meta rtclassid cosmos;ok;rtclassid cosmos
+
+meta pkttype broadcast;ok;pkttype broadcast
+meta pkttype unicast;ok;pkttype unicast
+meta pkttype multicast;ok;pkttype multicast
+meta pkttype != broadcast;ok;pkttype != broadcast
+meta pkttype != unicast;ok;pkttype != unicast
+meta pkttype != multicast;ok;pkttype != multicast
+meta pkttype broadcastttt;fail
+-meta pkttype { broadcast, multicast} accept;ok
-- 
1.7.10.4

