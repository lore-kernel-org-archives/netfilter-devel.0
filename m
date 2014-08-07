From: Ana Rey <anarey@gmail.com>
Subject: [PATCH] [nft] tests: Add tests for cpu attribute of meta expresion.
Date: Thu,  7 Aug 2014 09:00:58 +0200
Message-ID: <1407394858-26841-4-git-send-email-anarey@gmail.com>
References: <1407394858-26841-1-git-send-email-anarey@gmail.com>
Cc: eric.dumazet@gmail.com, Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:51984 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754057AbaHGG7C (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 Aug 2014 02:59:02 -0400
Received: by mail-we0-f173.google.com with SMTP id q58so3758138wes.18
        for <netfilter-devel@vger.kernel.org>; Wed, 06 Aug 2014 23:59:01 -0700 (PDT)
In-Reply-To: <1407394858-26841-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add some tests to check the cpu attribute of meta expresion.

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 tests/any/meta.t |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tests/any/meta.t b/tests/any/meta.t
index 7361962..7cdf87a 100644
--- a/tests/any/meta.t
+++ b/tests/any/meta.t
@@ -164,3 +164,11 @@ meta pkttype != unicast;ok;pkttype != unicast
 meta pkttype != multicast;ok;pkttype != multicast
 meta pkttype broadcastttt;fail
 -meta pkttype { broadcast, multicast} accept;ok
+
+meta cpu 1;ok;cpu 1
+meta cpu != 1;ok;cpu != 1
+meta cpu 1-3;ok;cpu >= 1 cpu <= 3
+# BUG: there is not matching of packets with this rule.
+meta cpu != 1-2;ok;cpu < 1 cpu > 2
+meta cpu { 2,3};ok;cpu { 2, 3}
+-meta cpu != { 2,3};ok
-- 
1.7.10.4

