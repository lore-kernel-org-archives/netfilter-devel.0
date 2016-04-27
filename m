From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 3/3 nft] tests/py: add interval tests
Date: Wed, 27 Apr 2016 15:07:15 +0200
Message-ID: <1461762435-12411-3-git-send-email-pablo@netfilter.org>
References: <1461762435-12411-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60978 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752287AbcD0NH3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 Apr 2016 09:07:29 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id A6DC84BA03
	for <netfilter-devel@vger.kernel.org>; Wed, 27 Apr 2016 15:07:27 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 9AB8B64478
	for <netfilter-devel@vger.kernel.org>; Wed, 27 Apr 2016 15:07:27 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 91A3764478
	for <netfilter-devel@vger.kernel.org>; Wed, 27 Apr 2016 15:07:25 +0200 (CEST)
In-Reply-To: <1461762435-12411-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add some initial tests to cover dynamic interval sets.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/py/ip/sets.t  | 12 ++++++++++++
 tests/py/ip6/sets.t | 11 +++++++++++
 2 files changed, 23 insertions(+)

diff --git a/tests/py/ip/sets.t b/tests/py/ip/sets.t
index 2b4e7e1..0e2b193 100644
--- a/tests/py/ip/sets.t
+++ b/tests/py/ip/sets.t
@@ -31,3 +31,15 @@
 ip saddr @set1 drop;ok
 ip saddr @set2 drop;ok
 ip saddr @set33 drop;fail
+
+!set3 type ipv4_addr flags interval;ok
+?set3 192.168.0.0/16;ok
+?set3 172.16.0.0/12;ok
+?set3 10.0.0.0/8;ok
+
+!set4 type ipv4_addr flags interval;ok
+?set4 192.168.1.0/24;ok
+?set4 192.168.0.0/24;ok
+?set4 192.168.2.0/24;ok
+?set4 192.168.1.1;fail
+?set4 192.168.3.0/24;ok
diff --git a/tests/py/ip6/sets.t b/tests/py/ip6/sets.t
index 765b971..ff38925 100644
--- a/tests/py/ip6/sets.t
+++ b/tests/py/ip6/sets.t
@@ -23,3 +23,14 @@
 
 ip6 saddr @set2 drop;ok
 ip6 saddr @set33 drop;fail
+
+!set3 type ipv6_addr flags interval;ok
+?set3 1234:1234:1234:1234::/64;ok
+?set3 1324:1234:1234:1235::/64;ok
+?set3 1324:1234:1234:1233::/64;ok
+?set3 1234:1234:1234:1234:1234:1234:/96;fail
+?set3 1324:1234:1234:1236::/64;ok
+
+!set4 type ipv6_addr flags interval;ok
+?set4 1234:1234:1234:1234::/64 4321:1234:1234:1234::/64;ok
+?set4 4321:1234:1234:1234:1234:1234::/96;fail
-- 
2.1.4

