From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] proto: use parameter-problem for icmpv6 type
Date: Mon,  1 Feb 2016 14:51:02 +0100
Message-ID: <1454334662-4351-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, fw@strlen.de, benoit.knecht@fsfe.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53983 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932244AbcBANvN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Feb 2016 08:51:13 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 3E0826C21
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Feb 2016 14:51:10 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 2ECD0DA80B
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Feb 2016 14:51:10 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id D12C5DA811
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Feb 2016 14:51:07 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

To keep it consistent with icmpv4 naming.

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=911
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/proto.c                       | 2 +-
 tests/py/ip6/icmpv6.t             | 1 +
 tests/py/ip6/icmpv6.t.payload.ip6 | 8 ++++++++
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/src/proto.c b/src/proto.c
index 0cd9fdb..0ed98ed 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -542,7 +542,7 @@ static const struct symbol_table icmp6_type_tbl = {
 		SYMBOL("destination-unreachable",	ICMP6_DST_UNREACH),
 		SYMBOL("packet-too-big",		ICMP6_PACKET_TOO_BIG),
 		SYMBOL("time-exceeded",			ICMP6_TIME_EXCEEDED),
-		SYMBOL("param-problem",			ICMP6_PARAM_PROB),
+		SYMBOL("parameter-problem",		ICMP6_PARAM_PROB),
 		SYMBOL("echo-request",			ICMP6_ECHO_REQUEST),
 		SYMBOL("echo-reply",			ICMP6_ECHO_REPLY),
 		SYMBOL("mld-listener-query",		MLD_LISTENER_QUERY),
diff --git a/tests/py/ip6/icmpv6.t b/tests/py/ip6/icmpv6.t
index af40bf7..6892273 100644
--- a/tests/py/ip6/icmpv6.t
+++ b/tests/py/ip6/icmpv6.t
@@ -17,6 +17,7 @@ icmpv6 type nd-router-advert accept;ok
 icmpv6 type nd-neighbor-solicit accept;ok
 icmpv6 type nd-neighbor-advert accept;ok
 icmpv6 type nd-redirect accept;ok
+icmpv6 type parameter-problem accept;ok
 icmpv6 type router-renumbering accept;ok
 icmpv6 type {destination-unreachable, time-exceeded, nd-router-solicit} accept;ok
 icmpv6 type {router-renumbering, mld-listener-reduction, time-exceeded, nd-router-solicit} accept;ok
diff --git a/tests/py/ip6/icmpv6.t.payload.ip6 b/tests/py/ip6/icmpv6.t.payload.ip6
index 55af9d8..d13b799 100644
--- a/tests/py/ip6/icmpv6.t.payload.ip6
+++ b/tests/py/ip6/icmpv6.t.payload.ip6
@@ -102,6 +102,14 @@ ip6 test-ip6 input
   [ cmp eq reg 1 0x00000089 ]
   [ immediate reg 0 accept ]
 
+# icmpv6 type parameter-problem accept
+ip6 test-ip6 input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x0000003a ]
+  [ payload load 1b @ transport header + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000004 ]
+  [ immediate reg 0 accept ]
+
 # icmpv6 type router-renumbering accept
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
-- 
2.1.4

