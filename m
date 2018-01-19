From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 22/32] netfilter: nf_nat_snmp_basic: remove useless comment
Date: Fri, 19 Jan 2018 20:10:31 +0100
Message-ID: <20180119191041.25804-23-pablo@netfilter.org>
References: <20180119191041.25804-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180119191041.25804-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

Remove comments that do not let us know important information.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/nf_nat_snmp_basic.c | 30 ------------------------------
 1 file changed, 30 deletions(-)

diff --git a/net/ipv4/netfilter/nf_nat_snmp_basic.c b/net/ipv4/netfilter/nf_nat_snmp_basic.c
index d5b1e0b3f687..d6f03fe9f9b4 100644
--- a/net/ipv4/netfilter/nf_nat_snmp_basic.c
+++ b/net/ipv4/netfilter/nf_nat_snmp_basic.c
@@ -81,12 +81,6 @@ struct oct1_map
 };
 
 
-/*****************************************************************************
- *
- * Basic ASN.1 decoding routines (gxsnmp author Dirk Wisse)
- *
- *****************************************************************************/
-
 /* Class */
 #define ASN1_UNI	0	/* Universal */
 #define ASN1_APL	1	/* Application */
@@ -491,12 +485,6 @@ static unsigned char asn1_oid_decode(struct asn1_ctx *ctx,
 	return 1;
 }
 
-/*****************************************************************************
- *
- * SNMP decoding routines (gxsnmp author Dirk Wisse)
- *
- *****************************************************************************/
-
 /* SNMP Versions */
 #define SNMP_V1				0
 #define SNMP_V2C			1
@@ -992,12 +980,6 @@ snmp_trap_decode(struct asn1_ctx *ctx, struct snmp_v1_trap *trap,
 	return 0;
 }
 
-/*****************************************************************************
- *
- * Misc. routines
- *
- *****************************************************************************/
-
 /*
  * Parse and mangle SNMP message according to mapping.
  * (And this is the fucking 'basic' method).
@@ -1157,12 +1139,6 @@ static int snmp_parse_mangle(unsigned char *msg,
 	return 1;
 }
 
-/*****************************************************************************
- *
- * NAT routines.
- *
- *****************************************************************************/
-
 /*
  * SNMP translation routine.
  */
@@ -1259,12 +1235,6 @@ static struct nf_conntrack_helper snmp_trap_helper __read_mostly = {
 	.tuple.dst.protonum	= IPPROTO_UDP,
 };
 
-/*****************************************************************************
- *
- * Module stuff.
- *
- *****************************************************************************/
-
 static int __init nf_nat_snmp_basic_init(void)
 {
 	BUG_ON(nf_nat_snmp_hook != NULL);
-- 
2.11.0
