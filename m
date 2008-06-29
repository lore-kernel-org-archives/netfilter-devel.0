From: Sven Wegener <sven.wegener@stealer.net>
Subject: [PATCH] ipset/iptree: Increase sleep time for test
Date: Sun, 29 Jun 2008 19:39:18 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0806291937430.14884@titan.stealer.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.stealer.net ([88.198.224.204]:44924 "EHLO
	smtp1.stealer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754083AbYF2Rt3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 29 Jun 2008 13:49:29 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Using a timeout of five seconds and sleeping for five seconds calls for race
conditions. Increase the sleep time to six seconds to make sure we give the set
enough time for the timeout to actually trigger.
---
 tests/iptree.t |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- ipset.orig/tests/iptree.t
+++ ipset/tests/iptree.t
@@ -28,8 +28,8 @@
 1 ipset -T test 2.0.0.2
 # Timeout: Test value not added to the set
 1 ipset -T test 192.168.68.70
-# Timeout: Sleep 5s so that entries can time out
-0 sleep 5
+# Timeout: Sleep 6s so that entries can time out
+0 sleep 6
 # Timeout: Test first random value
 1 ipset -T test 2.0.0.1
 # Timeout: Test second random value
