From: Taehee Yoo <ap420073@gmail.com>
Subject: [PATCH V5 2/5] netfilter: nf_nat_snmp_basic: remove debug parameter
Date: Mon,  8 Jan 2018 00:09:56 +0900
Message-ID: <20180107150956.26152-1-ap420073@gmail.com>
Cc: ap420073@gmail.com
To: pablo@netfilter.org, fw@strlen.de, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:36153 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753776AbeAGPKE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 7 Jan 2018 10:10:04 -0500
Received: by mail-pg0-f67.google.com with SMTP id j2so2700522pgv.3
        for <netfilter-devel@vger.kernel.org>; Sun, 07 Jan 2018 07:10:04 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

To see debug message of nf_nat_snmp_basic, we should set debug value
when we insert this module. but it is inconvenient and only using of
the dynamic debugging is enough to debug.

This patch just removes debug code. then in the next patch, debugging code
will be added.

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

 net/ipv4/netfilter/nf_nat_snmp_basic.c | 62 ----------------------------------
 1 file changed, 62 deletions(-)

diff --git a/net/ipv4/netfilter/nf_nat_snmp_basic.c b/net/ipv4/netfilter/nf_nat_snmp_basic.c
index d6f03fe9f..e5ec946 100644
--- a/net/ipv4/netfilter/nf_nat_snmp_basic.c
+++ b/net/ipv4/netfilter/nf_nat_snmp_basic.c
@@ -66,7 +66,6 @@ MODULE_ALIAS("ip_nat_snmp_basic");
 #define SNMP_TRAP_PORT 162
 #define NOCT1(n) (*(u8 *)(n))
 
-static int debug;
 static DEFINE_SPINLOCK(snmp_lock);
 
 /*
@@ -888,23 +887,13 @@ static inline void mangle_address(unsigned char *begin,
 				  __sum16 *check)
 {
 	if (map->from == NOCT1(addr)) {
-		u_int32_t old;
-
-		if (debug)
-			memcpy(&old, addr, sizeof(old));
-
 		*addr = map->to;
 
 		/* Update UDP checksum if being used */
 		if (*check) {
 			fast_csum(check,
 				  &map->from, &map->to, addr - begin);
-
 		}
-
-		if (debug)
-			printk(KERN_DEBUG "bsalg: mapped %pI4 to %pI4\n",
-			       &old, addr);
 	}
 }
 
@@ -995,10 +984,6 @@ static int snmp_parse_mangle(unsigned char *msg,
 	struct asn1_octstr comm;
 	struct snmp_object *obj;
 
-	if (debug > 1)
-		print_hex_dump(KERN_DEBUG, "", DUMP_PREFIX_NONE, 16, 1,
-			       msg, len, 0);
-
 	asn1_open(&ctx, msg, len);
 
 	/*
@@ -1018,8 +1003,6 @@ static int snmp_parse_mangle(unsigned char *msg,
 		return 0;
 	if (!asn1_uint_decode (&ctx, end, &vers))
 		return 0;
-	if (debug > 1)
-		pr_debug("bsalg: snmp version: %u\n", vers + 1);
 	if (vers > 1)
 		return 1;
 
@@ -1032,14 +1015,6 @@ static int snmp_parse_mangle(unsigned char *msg,
 		return 0;
 	if (!asn1_octets_decode(&ctx, end, &comm.data, &comm.len))
 		return 0;
-	if (debug > 1) {
-		unsigned int i;
-
-		pr_debug("bsalg: community: ");
-		for (i = 0; i < comm.len; i++)
-			pr_cont("%c", comm.data[i]);
-		pr_cont("\n");
-	}
 	kfree(comm.data);
 
 	/*
@@ -1049,23 +1024,6 @@ static int snmp_parse_mangle(unsigned char *msg,
 		return 0;
 	if (cls != ASN1_CTX || con != ASN1_CON)
 		return 0;
-	if (debug > 1) {
-		static const unsigned char *const pdus[] = {
-			[SNMP_PDU_GET] = "get",
-			[SNMP_PDU_NEXT] = "get-next",
-			[SNMP_PDU_RESPONSE] = "response",
-			[SNMP_PDU_SET] = "set",
-			[SNMP_PDU_TRAP1] = "trapv1",
-			[SNMP_PDU_BULK] = "bulk",
-			[SNMP_PDU_INFORM] = "inform",
-			[SNMP_PDU_TRAP2] = "trapv2"
-		};
-
-		if (pdutype > SNMP_PDU_TRAP2)
-			pr_debug("bsalg: bad pdu type %u\n", pdutype);
-		else
-			pr_debug("bsalg: pdu: %s\n", pdus[pdutype]);
-	}
 	if (pdutype != SNMP_PDU_RESPONSE &&
 	    pdutype != SNMP_PDU_TRAP1 && pdutype != SNMP_PDU_TRAP2)
 		return 1;
@@ -1088,11 +1046,6 @@ static int snmp_parse_mangle(unsigned char *msg,
 
 		if (!snmp_request_decode(&ctx, &req))
 			return 0;
-
-		if (debug > 1)
-			pr_debug("bsalg: request: id=0x%lx error_status=%u "
-			"error_index=%u\n", req.id, req.error_status,
-			req.error_index);
 	}
 
 	/*
@@ -1105,8 +1058,6 @@ static int snmp_parse_mangle(unsigned char *msg,
 		return 0;
 
 	while (!asn1_eoc_decode(&ctx, eoc)) {
-		unsigned int i;
-
 		if (!snmp_object_decode(&ctx, &obj)) {
 			if (obj) {
 				kfree(obj->id);
@@ -1115,17 +1066,6 @@ static int snmp_parse_mangle(unsigned char *msg,
 			return 0;
 		}
 
-		if (debug > 1) {
-			pr_debug("bsalg: object: ");
-			for (i = 0; i < obj->id_len; i++) {
-				if (i > 0)
-					pr_cont(".");
-				pr_cont("%lu", obj->id[i]);
-			}
-			pr_cont(": type=%u\n", obj->type);
-
-		}
-
 		if (obj->type == SNMP_IPADDR)
 			mangle_address(ctx.begin, ctx.pointer - 4, map, check);
 
@@ -1252,5 +1192,3 @@ static void __exit nf_nat_snmp_basic_fini(void)
 
 module_init(nf_nat_snmp_basic_init);
 module_exit(nf_nat_snmp_basic_fini);
-
-module_param(debug, int, 0600);
-- 
2.9.3

