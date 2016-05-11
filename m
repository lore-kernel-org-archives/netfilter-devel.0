From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 07/12] proto: remove priority field definition from IPv6 header
Date: Wed, 11 May 2016 23:05:11 +0200
Message-ID: <1463000716-11885-7-git-send-email-pablo@netfilter.org>
References: <1463000716-11885-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40459 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751580AbcEKVF3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 May 2016 17:05:29 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id B76A31BD5AA
	for <netfilter-devel@vger.kernel.org>; Wed, 11 May 2016 23:05:27 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A6B9DFF2D5
	for <netfilter-devel@vger.kernel.org>; Wed, 11 May 2016 23:05:27 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 1714DFF153
	for <netfilter-devel@vger.kernel.org>; Wed, 11 May 2016 23:05:25 +0200 (CEST)
In-Reply-To: <1463000716-11885-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is actually part of the traffic class field according to RFC2460.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/proto.c        | 1 -
 tests/py/ip6/ip6.t | 8 --------
 2 files changed, 9 deletions(-)

diff --git a/src/proto.c b/src/proto.c
index 9e972a3..fb774b1 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -642,7 +642,6 @@ const struct proto_desc proto_ip6 = {
 	},
 	.templates	= {
 		[IP6HDR_VERSION]	= HDR_BITFIELD("version", &integer_type, 0, 4),
-		[IP6HDR_PRIORITY]	= HDR_BITFIELD("priority", &integer_type, 4, 4),
 		[IP6HDR_FLOWLABEL]	= HDR_BITFIELD("flowlabel", &integer_type, 12, 20),
 		[IP6HDR_LENGTH]		= IP6HDR_FIELD("length",	payload_len),
 		[IP6HDR_NEXTHDR]	= INET_PROTOCOL("nexthdr", struct ipv6hdr, nexthdr),
diff --git a/tests/py/ip6/ip6.t b/tests/py/ip6/ip6.t
index 2a1eee7..8226130 100644
--- a/tests/py/ip6/ip6.t
+++ b/tests/py/ip6/ip6.t
@@ -9,14 +9,6 @@
 # ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
 - ip6 version 6;ok
-- ip6 priority 3;ok
-
-# $ sudo nft add rule ip6 test6 input ip6 priority 33
-# <cmdline>:1:39-40: Error: Value 33 exceeds valid range 0-15
-# $ sudo nft add rule ip6 test6 input ip6 priority 3
-# <cmdline>:1:1-39: Error: Could not process rule: Invalid argument
-# add rule ip6 test6 input ip6 priority 3
-#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
 ip6 flowlabel 22;ok
 ip6 flowlabel != 233;ok
-- 
2.1.4

