From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 1/2] tests: regression: named sets work
Date: Mon, 22 Dec 2014 13:45:49 +0100
Message-ID: <1419252350-24317-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60354 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754590AbaLVMnZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 22 Dec 2014 07:43:25 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Those tests work already, enable them.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/regression/ip/sets.t |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/tests/regression/ip/sets.t b/tests/regression/ip/sets.t
index a74d308..c199dbd 100644
--- a/tests/regression/ip/sets.t
+++ b/tests/regression/ip/sets.t
@@ -25,7 +25,6 @@
 ?set2 192.168.3.8 192.168.3.9;ok
 ?set2 192.168.3.10 192.168.3.11;ok
 
--ip saddr @set1 drop;ok
--ip saddr @set2 drop;ok
--ip saddr @set33 drop;fail
--ip saddr @set21 drop;fail
+ip saddr @set1 drop;ok
+ip saddr @set2 drop;ok
+ip saddr @set33 drop;fail
-- 
1.7.10.4

