From: Taehee Yoo <ap420073@gmail.com>
Subject: [PATCH V5 1/5] netfilter: nf_nat_snmp_basic: remove useless comment
Date: Mon,  8 Jan 2018 00:09:37 +0900
Message-ID: <20180107150937.26083-1-ap420073@gmail.com>
Cc: ap420073@gmail.com
To: pablo@netfilter.org, fw@strlen.de, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:34035 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753193AbeAGPJq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 7 Jan 2018 10:09:46 -0500
Received: by mail-pf0-f193.google.com with SMTP id a90so4235566pfk.1
        for <netfilter-devel@vger.kernel.org>; Sun, 07 Jan 2018 07:09:46 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Remove comments that do not let us know important information.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

V5 :
 - fix sparse error

V4 :
 - rename nf_nat_snmp_basic.c to nf_nat_snmp_basic_main.c
 to fix compile error

V3 :
 - be separated by previous patch.

V2 :
 - Add missing nf_nat_snmp_basic.asn1 file

V1 :
 - Initial patch

 net/ipv4/netfilter/nf_nat_snmp_basic.c | 30 ------------------------------
 1 file changed, 30 deletions(-)

diff --git a/net/ipv4/netfilter/nf_nat_snmp_basic.c b/net/ipv4/netfilter/nf_nat_snmp_basic.c
index d5b1e0b..d6f03fe9f 100644
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
2.9.3

