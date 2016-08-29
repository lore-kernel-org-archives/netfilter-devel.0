From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 1/8] tests: py: adapt this to new add element command semantics
Date: Mon, 29 Aug 2016 20:21:12 +0200
Message-ID: <1472494879-16442-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48856 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752958AbcH2SVb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 29 Aug 2016 14:21:31 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 861FF1324E2
        for <netfilter-devel@vger.kernel.org>; Mon, 29 Aug 2016 20:21:26 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7694A100A6A
        for <netfilter-devel@vger.kernel.org>; Mon, 29 Aug 2016 20:21:26 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5F4BCDA7E1
        for <netfilter-devel@vger.kernel.org>; Mon, 29 Aug 2016 20:21:24 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Since fd33d96 ("src: create element command"), add element doesn't
fail anymore if the element exists, you have to use create instead in
case you want to check if the element already exists.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/py/ip/sets.t  | 6 +++---
 tests/py/ip6/sets.t | 4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/tests/py/ip/sets.t b/tests/py/ip/sets.t
index 0e2b193..ee17d99 100644
--- a/tests/py/ip/sets.t
+++ b/tests/py/ip/sets.t
@@ -13,9 +13,9 @@
 !set1 type ipv4_addr;ok
 ?set1 192.168.3.4;ok
 
-?set1 192.168.3.4;fail
+?set1 192.168.3.4;ok
+?set1 192.168.3.5 192.168.3.6;ok
 ?set1 192.168.3.5 192.168.3.6;ok
-?set1 192.168.3.5 192.168.3.6;fail
 ?set1 192.168.3.8 192.168.3.9;ok
 ?set1 192.168.3.10 192.168.3.11;ok
 ?set1 1234:1234:1234:1234:1234:1234:1234:1234;fail
@@ -24,7 +24,7 @@
 !set2 type ipv4_addr;ok
 ?set2 192.168.3.4;ok
 ?set2 192.168.3.5 192.168.3.6;ok
-?set2 192.168.3.5 192.168.3.6;fail
+?set2 192.168.3.5 192.168.3.6;ok
 ?set2 192.168.3.8 192.168.3.9;ok
 ?set2 192.168.3.10 192.168.3.11;ok
 
diff --git a/tests/py/ip6/sets.t b/tests/py/ip6/sets.t
index ff38925..ea20834 100644
--- a/tests/py/ip6/sets.t
+++ b/tests/py/ip6/sets.t
@@ -13,12 +13,12 @@
 ?set2 192.168.3.4;fail
 !set2 type ipv6_addr;ok
 ?set2 1234:1234::1234:1234:1234:1234:1234;ok
-?set2 1234:1234::1234:1234:1234:1234:1234;fail
+?set2 1234:1234::1234:1234:1234:1234:1234;ok
 ?set2 1234::1234:1234:1234;ok
 ?set2 1234:1234:1234:1234:1234::1234:1234 1234:1234::123;ok
 ?set2 192.168.3.8 192.168.3.9;fail
 ?set2 1234:1234::1234:1234:1234:1234;ok
-?set2 1234:1234::1234:1234:1234:1234;fail
+?set2 1234:1234::1234:1234:1234:1234;ok
 ?set2 1234:1234:1234::1234;ok
 
 ip6 saddr @set2 drop;ok
-- 
2.1.4

