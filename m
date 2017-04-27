From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: snmp: avoid stack size warning
Date: Thu, 27 Apr 2017 16:39:43 +0200
Message-ID: <20170427143943.5099-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:59782 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1162181AbdD0OjZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Apr 2017 10:39:25 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

net/ipv4/netfilter/nf_nat_snmp_basic.c:1158:1: warning: the frame size
of 1160 bytes is larger than 1024 bytes

Signed-off-by: Florian Westphal <fw@strlen.de>
---

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
2.10.2

