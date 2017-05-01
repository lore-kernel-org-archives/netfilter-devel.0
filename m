From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 52/53] netfilter: snmp: avoid stack size warning
Date: Mon,  1 May 2017 12:47:19 +0200
Message-ID: <1493635640-24325-53-git-send-email-pablo@netfilter.org>
References: <1493635640-24325-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49772 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S378990AbdEAKtG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 1 May 2017 06:49:06 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 46E05210596
        for <netfilter-devel@vger.kernel.org>; Mon,  1 May 2017 12:48:11 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3996CFF14D
        for <netfilter-devel@vger.kernel.org>; Mon,  1 May 2017 12:48:11 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1DF4EFF2C1
        for <netfilter-devel@vger.kernel.org>; Mon,  1 May 2017 12:48:09 +0200 (CEST)
In-Reply-To: <1493635640-24325-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Florian Westphal <fw@strlen.de>

net/ipv4/netfilter/nf_nat_snmp_basic.c:1158:1: warning: the frame size
of 1160 bytes is larger than 1024 bytes

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/nf_nat_snmp_basic.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/netfilter/nf_nat_snmp_basic.c b/net/ipv4/netfilter/nf_nat_snmp_basic.c
index da04b9c33ef3..d5b1e0b3f687 100644
--- a/net/ipv4/netfilter/nf_nat_snmp_basic.c
+++ b/net/ipv4/netfilter/nf_nat_snmp_basic.c
@@ -827,8 +827,8 @@ static unsigned char snmp_object_decode(struct asn1_ctx *ctx,
 	return 1;
 }
 
-static unsigned char snmp_request_decode(struct asn1_ctx *ctx,
-					 struct snmp_request *request)
+static unsigned char noinline_for_stack
+snmp_request_decode(struct asn1_ctx *ctx, struct snmp_request *request)
 {
 	unsigned int cls, con, tag;
 	unsigned char *end;
@@ -920,10 +920,10 @@ static inline void mangle_address(unsigned char *begin,
 	}
 }
 
-static unsigned char snmp_trap_decode(struct asn1_ctx *ctx,
-				      struct snmp_v1_trap *trap,
-				      const struct oct1_map *map,
-				      __sum16 *check)
+static unsigned char noinline_for_stack
+snmp_trap_decode(struct asn1_ctx *ctx, struct snmp_v1_trap *trap,
+		 const struct oct1_map *map,
+		 __sum16 *check)
 {
 	unsigned int cls, con, tag, len;
 	unsigned char *end;
-- 
2.1.4

