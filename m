From: Eric Leblond <eric@regit.org>
Subject: [nft PATCH 2/3] regression: add test on counter related issue
Date: Thu, 26 Feb 2015 00:51:09 +0100
Message-ID: <1424908270-554-3-git-send-email-eric@regit.org>
References: <1424908270-554-1-git-send-email-eric@regit.org>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@regit.org>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:42929 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932138AbbBZATy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Feb 2015 19:19:54 -0500
In-Reply-To: <1424908270-554-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Eric Leblond <eric@regit.org>
---
 tests/regression/ip/ip.t | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tests/regression/ip/ip.t b/tests/regression/ip/ip.t
index a781de5..0d056ab 100644
--- a/tests/regression/ip/ip.t
+++ b/tests/regression/ip/ip.t
@@ -105,3 +105,5 @@ ip saddr != 192.168.1.3-192.168.33.55;ok;ip saddr < 192.168.1.3 ip saddr > 192.1
 ip daddr 192.168.0.1;ok
 ip daddr 192.168.0.1 drop;ok
 ip daddr 192.168.0.2 log;ok
+
+ip protocol 6 counter tcp dport 223 accept;ok;ip protocol 6 counter packets 0 bytes 0 tcp dport 223 accept
-- 
2.1.4

