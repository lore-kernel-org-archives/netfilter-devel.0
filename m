From: Taehee Yoo <ap420073@gmail.com>
Subject: [PATCH v2] netfilter: nf_nat_snmp_basic: use asn1 decoder library
Date: Tue,  7 Nov 2017 23:58:36 +0900
Message-ID: <20171107145836.29917-1-ap420073@gmail.com>
Cc: ap420073@gmail.com
To: pablo@netfilter.org, fw@strlen.de, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:48980 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933751AbdKGO6v (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Nov 2017 09:58:51 -0500
Received: by mail-pf0-f196.google.com with SMTP id b79so10504340pfk.5
        for <netfilter-devel@vger.kernel.org>; Tue, 07 Nov 2017 06:58:51 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The basic SNMP ALG parse snmp ASN.1 payload
however, since 2012 linux kernel provide ASN.1 decoder library.
If we use ASN.1 decoder in the /lib/asn1_decoder.c, we can remove
about 1000 line of ASN.1 parsing routine.

To use asn1_decoder.c, we should write mib file(nf_nat_snmp_basic.asn1)
then /script/asn1_compiler.c makes *-asn1.c and *-asn1.h file
at the compiletime.(nf_nat_snmp_basic-asn1.c, nf_nat_snmp_basic-asn1.h)
The nf_nat_snmp_basic.asn1 is made by RFC1155, RFC1157, RFC1902, RFC1905,
RFC2578, RFC3416. of course that mib file supports only the basic SNMP ALG.

Previous SNMP ALG mangles only first octet of IPv4 address.
but after this patch, the SNMP ALG mangles whole IPv4 Address.
And SNMPv3 is not supported.

I tested with snmp commands such ans snmpd, snmpwalk, snmptrap.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v2:
 - Add missing nf_nat_snmp_basic.asn1 file

v1:
 - Initial version


 net/ipv4/netfilter/Kconfig                |    1 +
 net/ipv4/netfilter/Makefile               |    4 +-
 net/ipv4/netfilter/nf_nat_snmp_basic.asn1 |  198 +++++
 net/ipv4/netfilter/nf_nat_snmp_basic.c    | 1172 ++---------------------------
 4 files changed, 262 insertions(+), 1113 deletions(-)
 create mode 100644 net/ipv4/netfilter/nf_nat_snmp_basic.asn1

diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index c11eb17..346c474 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -148,6 +148,7 @@ config NF_NAT_SNMP_BASIC
 	depends on NF_CONNTRACK_SNMP
 	depends on NETFILTER_ADVANCED
 	default NF_NAT && NF_CONNTRACK_SNMP
+	select ASN1
 	---help---
 
 	  This module implements an Application Layer Gateway (ALG) for
diff --git a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
index f462fee..16c509c 100644
--- a/net/ipv4/netfilter/Makefile
+++ b/net/ipv4/netfilter/Makefile
@@ -26,8 +26,10 @@ obj-$(CONFIG_NF_REJECT_IPV4) += nf_reject_ipv4.o
 # NAT helpers (nf_conntrack)
 obj-$(CONFIG_NF_NAT_H323) += nf_nat_h323.o
 obj-$(CONFIG_NF_NAT_PPTP) += nf_nat_pptp.o
-obj-$(CONFIG_NF_NAT_SNMP_BASIC) += nf_nat_snmp_basic.o
+nf_nat_snmp_basic-asn1.o := nf_nat_snmp_basic-asn1.c nf_nat_snmp_basic-asn1.h
+obj-$(CONFIG_NF_NAT_SNMP_BASIC) += nf_nat_snmp_basic.o nf_nat_snmp_basic-asn1.o
 obj-$(CONFIG_NF_NAT_MASQUERADE_IPV4) += nf_nat_masquerade_ipv4.o
+clean-files := nf_nat_snmp_basic-asn1.c nf_nat_snmp_basic-asn1.h
 
 # NAT protocols (nf_nat)
 obj-$(CONFIG_NF_NAT_PROTO_GRE) += nf_nat_proto_gre.o
diff --git a/net/ipv4/netfilter/nf_nat_snmp_basic.asn1 b/net/ipv4/netfilter/nf_nat_snmp_basic.asn1
new file mode 100644
index 0000000..1e460fa
--- /dev/null
+++ b/net/ipv4/netfilter/nf_nat_snmp_basic.asn1
@@ -0,0 +1,198 @@
+Message ::=
+	SEQUENCE {
+		version
+			INTEGER ({snmp_version}),
+
+		community
+			OCTET STRING,
+
+		pdu
+			PDUs
+	}
+
+ObjectName ::=
+	OBJECT IDENTIFIER
+
+ObjectSyntax ::=
+	CHOICE {
+		simple
+			SimpleSyntax,
+
+		application-wide
+			ApplicationSyntax
+	}
+
+SimpleSyntax ::=
+	CHOICE {
+		integer-value
+			INTEGER,
+
+		string-value
+			OCTET STRING,
+
+		objectID-value
+			OBJECT IDENTIFIER
+	}
+
+ApplicationSyntax ::=
+	CHOICE {
+		ipAddress-value
+			IpAddress,
+
+		counter-value
+			Counter32,
+
+		timeticks-value
+			TimeTicks,
+
+		arbitrary-value
+			Opaque,
+
+		big-counter-value
+			Counter64,
+
+		unsigned-integer-value
+			Unsigned32
+	}
+
+IpAddress ::=
+	[APPLICATION 0]
+		IMPLICIT OCTET STRING OPTIONAL ({snmp_helper})
+
+Counter32 ::=
+	[APPLICATION 1]
+		IMPLICIT INTEGER OPTIONAL
+
+Unsigned32 ::=
+	[APPLICATION 2]
+		IMPLICIT INTEGER OPTIONAL
+
+TimeTicks ::=
+	[APPLICATION 3]
+		IMPLICIT INTEGER OPTIONAL
+
+Opaque ::=
+	[APPLICATION 4]
+		IMPLICIT OCTET STRING OPTIONAL
+
+Counter64 ::=
+	[APPLICATION 6]
+		IMPLICIT INTEGER OPTIONAL
+
+PDUs ::=
+	CHOICE {
+		get-request
+			GetRequest-PDU,
+
+		get-next-request
+			GetNextRequest-PDU,
+
+		get-bulk-request
+			GetBulkRequest-PDU,
+
+		response
+			Response-PDU,
+
+		trap
+			SNMPv1-Trap-PDU,
+
+		set-request
+			SetRequest-PDU,
+
+		inform-request
+			InformRequest-PDU,
+
+		snmpV2-trap
+			SNMPv2-Trap-PDU,
+
+		report
+			Report-PDU
+	}
+
+GetRequest-PDU ::=
+	[0] IMPLICIT PDU OPTIONAL
+
+GetNextRequest-PDU ::=
+	[1] IMPLICIT PDU OPTIONAL
+
+Response-PDU ::=
+	[2] IMPLICIT PDU OPTIONAL
+
+SetRequest-PDU ::=
+	[3] IMPLICIT PDU OPTIONAL
+
+SNMPv1-Trap-PDU ::=
+	[4] IMPLICIT Trap-PDU OPTIONAL
+
+GetBulkRequest-PDU ::=
+	[5] IMPLICIT PDU OPTIONAL
+
+InformRequest-PDU ::=
+	[6] IMPLICIT PDU OPTIONAL
+
+SNMPv2-Trap-PDU ::=
+	[7] IMPLICIT PDU OPTIONAL
+
+Report-PDU ::=
+	[8] IMPLICIT PDU OPTIONAL
+
+PDU ::=
+	SEQUENCE {
+		request-id
+			INTEGER,
+
+		error-status
+			INTEGER,
+
+		error-index
+			INTEGER,
+
+		variable-bindings
+			VarBindList
+	}
+
+Trap-PDU ::=
+	SEQUENCE {
+		enterprise
+			OBJECT IDENTIFIER,
+
+		agent-addr
+			IpAddress,
+
+		generic-trap
+			INTEGER,
+
+		specific-trap
+			INTEGER,
+
+		time-stamp
+			TimeTicks,
+
+		variable-bindings
+			VarBindList
+	}
+
+VarBind ::=
+	SEQUENCE {
+		name
+			ObjectName,
+
+		CHOICE {
+			value
+				ObjectSyntax,
+
+			unSpecified
+				NULL,
+
+			noSuchObject
+				[0] IMPLICIT NULL,
+
+			noSuchInstance
+				[1] IMPLICIT NULL,
+
+			endOfMibView
+				[2] IMPLICIT NULL
+		}
+}
+
+VarBindList ::= SEQUENCE OF VarBind
diff --git a/net/ipv4/netfilter/nf_nat_snmp_basic.c b/net/ipv4/netfilter/nf_nat_snmp_basic.c
index d5b1e0b..b088197 100644
--- a/net/ipv4/netfilter/nf_nat_snmp_basic.c
+++ b/net/ipv4/netfilter/nf_nat_snmp_basic.c
@@ -44,7 +44,6 @@
 #include <linux/moduleparam.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/slab.h>
 #include <linux/in.h>
 #include <linux/ip.h>
 #include <linux/udp.h>
@@ -54,8 +53,8 @@
 #include <net/netfilter/nf_nat.h>
 #include <net/netfilter/nf_conntrack_expect.h>
 #include <net/netfilter/nf_conntrack_helper.h>
-#include <net/netfilter/nf_nat_helper.h>
 #include <linux/netfilter/nf_conntrack_snmp.h>
+#include "nf_nat_snmp_basic-asn1.h"
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("James Morris <jmorris@intercode.com.au>");
@@ -64,1141 +63,95 @@ MODULE_ALIAS("ip_nat_snmp_basic");
 
 #define SNMP_PORT 161
 #define SNMP_TRAP_PORT 162
-#define NOCT1(n) (*(u8 *)(n))
 
-static int debug;
 static DEFINE_SPINLOCK(snmp_lock);
 
-/*
- * Application layer address mapping mimics the NAT mapping, but
- * only for the first octet in this case (a more flexible system
- * can be implemented if needed).
- */
-struct oct1_map
-{
-	u_int8_t from;
-	u_int8_t to;
-};
-
-
-/*****************************************************************************
- *
- * Basic ASN.1 decoding routines (gxsnmp author Dirk Wisse)
- *
- *****************************************************************************/
-
-/* Class */
-#define ASN1_UNI	0	/* Universal */
-#define ASN1_APL	1	/* Application */
-#define ASN1_CTX	2	/* Context */
-#define ASN1_PRV	3	/* Private */
-
-/* Tag */
-#define ASN1_EOC	0	/* End Of Contents */
-#define ASN1_BOL	1	/* Boolean */
-#define ASN1_INT	2	/* Integer */
-#define ASN1_BTS	3	/* Bit String */
-#define ASN1_OTS	4	/* Octet String */
-#define ASN1_NUL	5	/* Null */
-#define ASN1_OJI	6	/* Object Identifier  */
-#define ASN1_OJD	7	/* Object Description */
-#define ASN1_EXT	8	/* External */
-#define ASN1_SEQ	16	/* Sequence */
-#define ASN1_SET	17	/* Set */
-#define ASN1_NUMSTR	18	/* Numerical String */
-#define ASN1_PRNSTR	19	/* Printable String */
-#define ASN1_TEXSTR	20	/* Teletext String */
-#define ASN1_VIDSTR	21	/* Video String */
-#define ASN1_IA5STR	22	/* IA5 String */
-#define ASN1_UNITIM	23	/* Universal Time */
-#define ASN1_GENTIM	24	/* General Time */
-#define ASN1_GRASTR	25	/* Graphical String */
-#define ASN1_VISSTR	26	/* Visible String */
-#define ASN1_GENSTR	27	/* General String */
-
-/* Primitive / Constructed methods*/
-#define ASN1_PRI	0	/* Primitive */
-#define ASN1_CON	1	/* Constructed */
-
-/*
- * Error codes.
- */
-#define ASN1_ERR_NOERROR		0
-#define ASN1_ERR_DEC_EMPTY		2
-#define ASN1_ERR_DEC_EOC_MISMATCH	3
-#define ASN1_ERR_DEC_LENGTH_MISMATCH	4
-#define ASN1_ERR_DEC_BADVALUE		5
-
-/*
- * ASN.1 context.
- */
-struct asn1_ctx
-{
-	int error;			/* Error condition */
-	unsigned char *pointer;		/* Octet just to be decoded */
-	unsigned char *begin;		/* First octet */
-	unsigned char *end;		/* Octet after last octet */
-};
-
-/*
- * Octet string (not null terminated)
- */
-struct asn1_octstr
+struct snmp_ctx
 {
-	unsigned char *data;
-	unsigned int len;
+	unsigned char *begin;
+	__sum16 *check;
+	__be32 from;
+	__be32 to;
 };
 
-static void asn1_open(struct asn1_ctx *ctx,
-		      unsigned char *buf,
-		      unsigned int len)
-{
-	ctx->begin = buf;
-	ctx->end = buf + len;
-	ctx->pointer = buf;
-	ctx->error = ASN1_ERR_NOERROR;
-}
-
-static unsigned char asn1_octet_decode(struct asn1_ctx *ctx, unsigned char *ch)
-{
-	if (ctx->pointer >= ctx->end) {
-		ctx->error = ASN1_ERR_DEC_EMPTY;
-		return 0;
-	}
-	*ch = *(ctx->pointer)++;
-	return 1;
-}
-
-static unsigned char asn1_tag_decode(struct asn1_ctx *ctx, unsigned int *tag)
-{
-	unsigned char ch;
-
-	*tag = 0;
-
-	do
-	{
-		if (!asn1_octet_decode(ctx, &ch))
-			return 0;
-		*tag <<= 7;
-		*tag |= ch & 0x7F;
-	} while ((ch & 0x80) == 0x80);
-	return 1;
-}
-
-static unsigned char asn1_id_decode(struct asn1_ctx *ctx,
-				    unsigned int *cls,
-				    unsigned int *con,
-				    unsigned int *tag)
-{
-	unsigned char ch;
-
-	if (!asn1_octet_decode(ctx, &ch))
-		return 0;
-
-	*cls = (ch & 0xC0) >> 6;
-	*con = (ch & 0x20) >> 5;
-	*tag = (ch & 0x1F);
-
-	if (*tag == 0x1F) {
-		if (!asn1_tag_decode(ctx, tag))
-			return 0;
-	}
-	return 1;
-}
-
-static unsigned char asn1_length_decode(struct asn1_ctx *ctx,
-					unsigned int *def,
-					unsigned int *len)
-{
-	unsigned char ch, cnt;
-
-	if (!asn1_octet_decode(ctx, &ch))
-		return 0;
-
-	if (ch == 0x80)
-		*def = 0;
-	else {
-		*def = 1;
-
-		if (ch < 0x80)
-			*len = ch;
-		else {
-			cnt = ch & 0x7F;
-			*len = 0;
-
-			while (cnt > 0) {
-				if (!asn1_octet_decode(ctx, &ch))
-					return 0;
-				*len <<= 8;
-				*len |= ch;
-				cnt--;
-			}
-		}
-	}
-
-	/* don't trust len bigger than ctx buffer */
-	if (*len > ctx->end - ctx->pointer)
-		return 0;
-
-	return 1;
-}
-
-static unsigned char asn1_header_decode(struct asn1_ctx *ctx,
-					unsigned char **eoc,
-					unsigned int *cls,
-					unsigned int *con,
-					unsigned int *tag)
-{
-	unsigned int def, len;
-
-	if (!asn1_id_decode(ctx, cls, con, tag))
-		return 0;
-
-	def = len = 0;
-	if (!asn1_length_decode(ctx, &def, &len))
-		return 0;
-
-	/* primitive shall be definite, indefinite shall be constructed */
-	if (*con == ASN1_PRI && !def)
-		return 0;
-
-	if (def)
-		*eoc = ctx->pointer + len;
-	else
-		*eoc = NULL;
-	return 1;
-}
-
-static unsigned char asn1_eoc_decode(struct asn1_ctx *ctx, unsigned char *eoc)
-{
-	unsigned char ch;
-
-	if (eoc == NULL) {
-		if (!asn1_octet_decode(ctx, &ch))
-			return 0;
-
-		if (ch != 0x00) {
-			ctx->error = ASN1_ERR_DEC_EOC_MISMATCH;
-			return 0;
-		}
-
-		if (!asn1_octet_decode(ctx, &ch))
-			return 0;
-
-		if (ch != 0x00) {
-			ctx->error = ASN1_ERR_DEC_EOC_MISMATCH;
-			return 0;
-		}
-		return 1;
-	} else {
-		if (ctx->pointer != eoc) {
-			ctx->error = ASN1_ERR_DEC_LENGTH_MISMATCH;
-			return 0;
-		}
-		return 1;
-	}
-}
-
-static unsigned char asn1_null_decode(struct asn1_ctx *ctx, unsigned char *eoc)
-{
-	ctx->pointer = eoc;
-	return 1;
-}
-
-static unsigned char asn1_long_decode(struct asn1_ctx *ctx,
-				      unsigned char *eoc,
-				      long *integer)
+static void fast_csum(struct snmp_ctx *ctx, unsigned char offset)
 {
-	unsigned char ch;
-	unsigned int  len;
-
-	if (!asn1_octet_decode(ctx, &ch))
-		return 0;
-
-	*integer = (signed char) ch;
-	len = 1;
-
-	while (ctx->pointer < eoc) {
-		if (++len > sizeof (long)) {
-			ctx->error = ASN1_ERR_DEC_BADVALUE;
-			return 0;
-		}
-
-		if (!asn1_octet_decode(ctx, &ch))
-			return 0;
-
-		*integer <<= 8;
-		*integer |= ch;
-	}
-	return 1;
-}
-
-static unsigned char asn1_uint_decode(struct asn1_ctx *ctx,
-				      unsigned char *eoc,
-				      unsigned int *integer)
-{
-	unsigned char ch;
-	unsigned int  len;
-
-	if (!asn1_octet_decode(ctx, &ch))
-		return 0;
-
-	*integer = ch;
-	if (ch == 0) len = 0;
-	else len = 1;
-
-	while (ctx->pointer < eoc) {
-		if (++len > sizeof (unsigned int)) {
-			ctx->error = ASN1_ERR_DEC_BADVALUE;
-			return 0;
-		}
-
-		if (!asn1_octet_decode(ctx, &ch))
-			return 0;
-
-		*integer <<= 8;
-		*integer |= ch;
-	}
-	return 1;
-}
-
-static unsigned char asn1_ulong_decode(struct asn1_ctx *ctx,
-				       unsigned char *eoc,
-				       unsigned long *integer)
-{
-	unsigned char ch;
-	unsigned int  len;
-
-	if (!asn1_octet_decode(ctx, &ch))
-		return 0;
-
-	*integer = ch;
-	if (ch == 0) len = 0;
-	else len = 1;
-
-	while (ctx->pointer < eoc) {
-		if (++len > sizeof (unsigned long)) {
-			ctx->error = ASN1_ERR_DEC_BADVALUE;
-			return 0;
-		}
-
-		if (!asn1_octet_decode(ctx, &ch))
-			return 0;
-
-		*integer <<= 8;
-		*integer |= ch;
-	}
-	return 1;
-}
-
-static unsigned char asn1_octets_decode(struct asn1_ctx *ctx,
-					unsigned char *eoc,
-					unsigned char **octets,
-					unsigned int *len)
-{
-	unsigned char *ptr;
-
-	*len = 0;
-
-	*octets = kmalloc(eoc - ctx->pointer, GFP_ATOMIC);
-	if (*octets == NULL)
-		return 0;
-
-	ptr = *octets;
-	while (ctx->pointer < eoc) {
-		if (!asn1_octet_decode(ctx, ptr++)) {
-			kfree(*octets);
-			*octets = NULL;
-			return 0;
-		}
-		(*len)++;
-	}
-	return 1;
-}
-
-static unsigned char asn1_subid_decode(struct asn1_ctx *ctx,
-				       unsigned long *subid)
-{
-	unsigned char ch;
-
-	*subid = 0;
-
-	do {
-		if (!asn1_octet_decode(ctx, &ch))
-			return 0;
-
-		*subid <<= 7;
-		*subid |= ch & 0x7F;
-	} while ((ch & 0x80) == 0x80);
-	return 1;
-}
-
-static unsigned char asn1_oid_decode(struct asn1_ctx *ctx,
-				     unsigned char *eoc,
-				     unsigned long **oid,
-				     unsigned int *len)
-{
-	unsigned long subid;
-	unsigned long *optr;
-	size_t size;
-
-	size = eoc - ctx->pointer + 1;
-
-	/* first subid actually encodes first two subids */
-	if (size < 2 || size > ULONG_MAX/sizeof(unsigned long))
-		return 0;
-
-	*oid = kmalloc(size * sizeof(unsigned long), GFP_ATOMIC);
-	if (*oid == NULL)
-		return 0;
-
-	optr = *oid;
-
-	if (!asn1_subid_decode(ctx, &subid)) {
-		kfree(*oid);
-		*oid = NULL;
-		return 0;
-	}
-
-	if (subid < 40) {
-		optr[0] = 0;
-		optr[1] = subid;
-	} else if (subid < 80) {
-		optr[0] = 1;
-		optr[1] = subid - 40;
-	} else {
-		optr[0] = 2;
-		optr[1] = subid - 80;
-	}
-
-	*len = 2;
-	optr += 2;
-
-	while (ctx->pointer < eoc) {
-		if (++(*len) > size) {
-			ctx->error = ASN1_ERR_DEC_BADVALUE;
-			kfree(*oid);
-			*oid = NULL;
-			return 0;
-		}
-
-		if (!asn1_subid_decode(ctx, optr++)) {
-			kfree(*oid);
-			*oid = NULL;
-			return 0;
-		}
-	}
-	return 1;
-}
-
-/*****************************************************************************
- *
- * SNMP decoding routines (gxsnmp author Dirk Wisse)
- *
- *****************************************************************************/
-
-/* SNMP Versions */
-#define SNMP_V1				0
-#define SNMP_V2C			1
-#define SNMP_V2				2
-#define SNMP_V3				3
-
-/* Default Sizes */
-#define SNMP_SIZE_COMM			256
-#define SNMP_SIZE_OBJECTID		128
-#define SNMP_SIZE_BUFCHR		256
-#define SNMP_SIZE_BUFINT		128
-#define SNMP_SIZE_SMALLOBJECTID		16
-
-/* Requests */
-#define SNMP_PDU_GET			0
-#define SNMP_PDU_NEXT			1
-#define SNMP_PDU_RESPONSE		2
-#define SNMP_PDU_SET			3
-#define SNMP_PDU_TRAP1			4
-#define SNMP_PDU_BULK			5
-#define SNMP_PDU_INFORM			6
-#define SNMP_PDU_TRAP2			7
-
-/* Errors */
-#define SNMP_NOERROR			0
-#define SNMP_TOOBIG			1
-#define SNMP_NOSUCHNAME			2
-#define SNMP_BADVALUE			3
-#define SNMP_READONLY			4
-#define SNMP_GENERROR			5
-#define SNMP_NOACCESS			6
-#define SNMP_WRONGTYPE			7
-#define SNMP_WRONGLENGTH		8
-#define SNMP_WRONGENCODING		9
-#define SNMP_WRONGVALUE			10
-#define SNMP_NOCREATION			11
-#define SNMP_INCONSISTENTVALUE		12
-#define SNMP_RESOURCEUNAVAILABLE	13
-#define SNMP_COMMITFAILED		14
-#define SNMP_UNDOFAILED			15
-#define SNMP_AUTHORIZATIONERROR		16
-#define SNMP_NOTWRITABLE		17
-#define SNMP_INCONSISTENTNAME		18
-
-/* General SNMP V1 Traps */
-#define SNMP_TRAP_COLDSTART		0
-#define SNMP_TRAP_WARMSTART		1
-#define SNMP_TRAP_LINKDOWN		2
-#define SNMP_TRAP_LINKUP		3
-#define SNMP_TRAP_AUTFAILURE		4
-#define SNMP_TRAP_EQPNEIGHBORLOSS	5
-#define SNMP_TRAP_ENTSPECIFIC		6
-
-/* SNMPv1 Types */
-#define SNMP_NULL                0
-#define SNMP_INTEGER             1    /* l  */
-#define SNMP_OCTETSTR            2    /* c  */
-#define SNMP_DISPLAYSTR          2    /* c  */
-#define SNMP_OBJECTID            3    /* ul */
-#define SNMP_IPADDR              4    /* uc */
-#define SNMP_COUNTER             5    /* ul */
-#define SNMP_GAUGE               6    /* ul */
-#define SNMP_TIMETICKS           7    /* ul */
-#define SNMP_OPAQUE              8    /* c  */
-
-/* Additional SNMPv2 Types */
-#define SNMP_UINTEGER            5    /* ul */
-#define SNMP_BITSTR              9    /* uc */
-#define SNMP_NSAP               10    /* uc */
-#define SNMP_COUNTER64          11    /* ul */
-#define SNMP_NOSUCHOBJECT       12
-#define SNMP_NOSUCHINSTANCE     13
-#define SNMP_ENDOFMIBVIEW       14
-
-union snmp_syntax
-{
-	unsigned char uc[0];	/* 8 bit unsigned */
-	char c[0];		/* 8 bit signed */
-	unsigned long ul[0];	/* 32 bit unsigned */
-	long l[0];		/* 32 bit signed */
-};
-
-struct snmp_object
-{
-	unsigned long *id;
-	unsigned int id_len;
-	unsigned short type;
-	unsigned int syntax_len;
-	union snmp_syntax syntax;
-};
-
-struct snmp_request
-{
-	unsigned long id;
-	unsigned int error_status;
-	unsigned int error_index;
-};
-
-struct snmp_v1_trap
-{
-	unsigned long *id;
-	unsigned int id_len;
-	unsigned long ip_address;	/* pointer  */
-	unsigned int general;
-	unsigned int specific;
-	unsigned long time;
-};
-
-/* SNMP types */
-#define SNMP_IPA    0
-#define SNMP_CNT    1
-#define SNMP_GGE    2
-#define SNMP_TIT    3
-#define SNMP_OPQ    4
-#define SNMP_C64    6
-
-/* SNMP errors */
-#define SERR_NSO    0
-#define SERR_NSI    1
-#define SERR_EOM    2
-
-static inline void mangle_address(unsigned char *begin,
-				  unsigned char *addr,
-				  const struct oct1_map *map,
-				  __sum16 *check);
-struct snmp_cnv
-{
-	unsigned int class;
-	unsigned int tag;
-	int syntax;
-};
-
-static const struct snmp_cnv snmp_conv[] = {
-	{ASN1_UNI, ASN1_NUL, SNMP_NULL},
-	{ASN1_UNI, ASN1_INT, SNMP_INTEGER},
-	{ASN1_UNI, ASN1_OTS, SNMP_OCTETSTR},
-	{ASN1_UNI, ASN1_OTS, SNMP_DISPLAYSTR},
-	{ASN1_UNI, ASN1_OJI, SNMP_OBJECTID},
-	{ASN1_APL, SNMP_IPA, SNMP_IPADDR},
-	{ASN1_APL, SNMP_CNT, SNMP_COUNTER},	/* Counter32 */
-	{ASN1_APL, SNMP_GGE, SNMP_GAUGE},	/* Gauge32 == Unsigned32  */
-	{ASN1_APL, SNMP_TIT, SNMP_TIMETICKS},
-	{ASN1_APL, SNMP_OPQ, SNMP_OPAQUE},
-
-	/* SNMPv2 data types and errors */
-	{ASN1_UNI, ASN1_BTS, SNMP_BITSTR},
-	{ASN1_APL, SNMP_C64, SNMP_COUNTER64},
-	{ASN1_CTX, SERR_NSO, SNMP_NOSUCHOBJECT},
-	{ASN1_CTX, SERR_NSI, SNMP_NOSUCHINSTANCE},
-	{ASN1_CTX, SERR_EOM, SNMP_ENDOFMIBVIEW},
-	{0,       0,       -1}
-};
-
-static unsigned char snmp_tag_cls2syntax(unsigned int tag,
-					 unsigned int cls,
-					 unsigned short *syntax)
-{
-	const struct snmp_cnv *cnv;
-
-	cnv = snmp_conv;
-
-	while (cnv->syntax != -1) {
-		if (cnv->tag == tag && cnv->class == cls) {
-			*syntax = cnv->syntax;
-			return 1;
-		}
-		cnv++;
-	}
-	return 0;
-}
-
-static unsigned char snmp_object_decode(struct asn1_ctx *ctx,
-					struct snmp_object **obj)
-{
-	unsigned int cls, con, tag, len, idlen;
-	unsigned short type;
-	unsigned char *eoc, *end, *p;
-	unsigned long *lp, *id;
-	unsigned long ul;
-	long l;
-
-	*obj = NULL;
-	id = NULL;
-
-	if (!asn1_header_decode(ctx, &eoc, &cls, &con, &tag))
-		return 0;
-
-	if (cls != ASN1_UNI || con != ASN1_CON || tag != ASN1_SEQ)
-		return 0;
-
-	if (!asn1_header_decode(ctx, &end, &cls, &con, &tag))
-		return 0;
-
-	if (cls != ASN1_UNI || con != ASN1_PRI || tag != ASN1_OJI)
-		return 0;
-
-	if (!asn1_oid_decode(ctx, end, &id, &idlen))
-		return 0;
-
-	if (!asn1_header_decode(ctx, &end, &cls, &con, &tag)) {
-		kfree(id);
-		return 0;
-	}
-
-	if (con != ASN1_PRI) {
-		kfree(id);
-		return 0;
-	}
-
-	type = 0;
-	if (!snmp_tag_cls2syntax(tag, cls, &type)) {
-		kfree(id);
-		return 0;
-	}
-
-	l = 0;
-	switch (type) {
-	case SNMP_INTEGER:
-		len = sizeof(long);
-		if (!asn1_long_decode(ctx, end, &l)) {
-			kfree(id);
-			return 0;
-		}
-		*obj = kmalloc(sizeof(struct snmp_object) + len, GFP_ATOMIC);
-		if (*obj == NULL) {
-			kfree(id);
-			return 0;
-		}
-		(*obj)->syntax.l[0] = l;
-		break;
-	case SNMP_OCTETSTR:
-	case SNMP_OPAQUE:
-		if (!asn1_octets_decode(ctx, end, &p, &len)) {
-			kfree(id);
-			return 0;
-		}
-		*obj = kmalloc(sizeof(struct snmp_object) + len, GFP_ATOMIC);
-		if (*obj == NULL) {
-			kfree(p);
-			kfree(id);
-			return 0;
-		}
-		memcpy((*obj)->syntax.c, p, len);
-		kfree(p);
-		break;
-	case SNMP_NULL:
-	case SNMP_NOSUCHOBJECT:
-	case SNMP_NOSUCHINSTANCE:
-	case SNMP_ENDOFMIBVIEW:
-		len = 0;
-		*obj = kmalloc(sizeof(struct snmp_object), GFP_ATOMIC);
-		if (*obj == NULL) {
-			kfree(id);
-			return 0;
-		}
-		if (!asn1_null_decode(ctx, end)) {
-			kfree(id);
-			kfree(*obj);
-			*obj = NULL;
-			return 0;
-		}
-		break;
-	case SNMP_OBJECTID:
-		if (!asn1_oid_decode(ctx, end, &lp, &len)) {
-			kfree(id);
-			return 0;
-		}
-		len *= sizeof(unsigned long);
-		*obj = kmalloc(sizeof(struct snmp_object) + len, GFP_ATOMIC);
-		if (*obj == NULL) {
-			kfree(lp);
-			kfree(id);
-			return 0;
-		}
-		memcpy((*obj)->syntax.ul, lp, len);
-		kfree(lp);
-		break;
-	case SNMP_IPADDR:
-		if (!asn1_octets_decode(ctx, end, &p, &len)) {
-			kfree(id);
-			return 0;
-		}
-		if (len != 4) {
-			kfree(p);
-			kfree(id);
-			return 0;
-		}
-		*obj = kmalloc(sizeof(struct snmp_object) + len, GFP_ATOMIC);
-		if (*obj == NULL) {
-			kfree(p);
-			kfree(id);
-			return 0;
-		}
-		memcpy((*obj)->syntax.uc, p, len);
-		kfree(p);
-		break;
-	case SNMP_COUNTER:
-	case SNMP_GAUGE:
-	case SNMP_TIMETICKS:
-		len = sizeof(unsigned long);
-		if (!asn1_ulong_decode(ctx, end, &ul)) {
-			kfree(id);
-			return 0;
-		}
-		*obj = kmalloc(sizeof(struct snmp_object) + len, GFP_ATOMIC);
-		if (*obj == NULL) {
-			kfree(id);
-			return 0;
-		}
-		(*obj)->syntax.ul[0] = ul;
-		break;
-	default:
-		kfree(id);
-		return 0;
-	}
-
-	(*obj)->syntax_len = len;
-	(*obj)->type = type;
-	(*obj)->id = id;
-	(*obj)->id_len = idlen;
-
-	if (!asn1_eoc_decode(ctx, eoc)) {
-		kfree(id);
-		kfree(*obj);
-		*obj = NULL;
-		return 0;
-	}
-	return 1;
-}
-
-static unsigned char noinline_for_stack
-snmp_request_decode(struct asn1_ctx *ctx, struct snmp_request *request)
-{
-	unsigned int cls, con, tag;
-	unsigned char *end;
-
-	if (!asn1_header_decode(ctx, &end, &cls, &con, &tag))
-		return 0;
-
-	if (cls != ASN1_UNI || con != ASN1_PRI || tag != ASN1_INT)
-		return 0;
-
-	if (!asn1_ulong_decode(ctx, end, &request->id))
-		return 0;
-
-	if (!asn1_header_decode(ctx, &end, &cls, &con, &tag))
-		return 0;
-
-	if (cls != ASN1_UNI || con != ASN1_PRI || tag != ASN1_INT)
-		return 0;
-
-	if (!asn1_uint_decode(ctx, end, &request->error_status))
-		return 0;
-
-	if (!asn1_header_decode(ctx, &end, &cls, &con, &tag))
-		return 0;
-
-	if (cls != ASN1_UNI || con != ASN1_PRI || tag != ASN1_INT)
-		return 0;
-
-	if (!asn1_uint_decode(ctx, end, &request->error_index))
-		return 0;
-
-	return 1;
-}
-
-/*
- * Fast checksum update for possibly oddly-aligned UDP byte, from the
- * code example in the draft.
- */
-static void fast_csum(__sum16 *csum,
-		      const unsigned char *optr,
-		      const unsigned char *nptr,
-		      int offset)
-{
-	unsigned char s[4];
+	unsigned char s[12] = {0,};
+	int size;
 
 	if (offset & 1) {
+		memcpy(&s[1], &ctx->from, 4);
+		memcpy(&s[7], &ctx->to, 4);
 		s[0] = ~0;
-		s[1] = ~*optr;
-		s[2] = 0;
-		s[3] = *nptr;
+		s[1] = ~s[1];
+		s[2] = ~s[2];
+		s[3] = ~s[3];
+		s[4] = ~s[4];
+		s[5] = ~0;
+		size = 12;
 	} else {
-		s[0] = ~*optr;
-		s[1] = ~0;
-		s[2] = *nptr;
-		s[3] = 0;
-	}
-
-	*csum = csum_fold(csum_partial(s, 4, ~csum_unfold(*csum)));
-}
-
-/*
- * Mangle IP address.
- * 	- begin points to the start of the snmp messgae
- *      - addr points to the start of the address
- */
-static inline void mangle_address(unsigned char *begin,
-				  unsigned char *addr,
-				  const struct oct1_map *map,
-				  __sum16 *check)
-{
-	if (map->from == NOCT1(addr)) {
-		u_int32_t old;
-
-		if (debug)
-			memcpy(&old, addr, sizeof(old));
-
-		*addr = map->to;
-
-		/* Update UDP checksum if being used */
-		if (*check) {
-			fast_csum(check,
-				  &map->from, &map->to, addr - begin);
-
-		}
-
-		if (debug)
-			printk(KERN_DEBUG "bsalg: mapped %pI4 to %pI4\n",
-			       &old, addr);
+		memcpy(&s[0], &ctx->from, 4);
+		memcpy(&s[4], &ctx->to, 4);
+		s[0] = ~s[0];
+		s[1] = ~s[1];
+		s[2] = ~s[2];
+		s[3] = ~s[3];
+		size = 8;
 	}
+	*ctx->check = csum_fold(csum_partial(s, size,
+					     ~csum_unfold(*ctx->check)));
 }
 
-static unsigned char noinline_for_stack
-snmp_trap_decode(struct asn1_ctx *ctx, struct snmp_v1_trap *trap,
-		 const struct oct1_map *map,
-		 __sum16 *check)
+int snmp_version(void *context, size_t hdrlen, unsigned char tag,
+		 const void *data, size_t datalen)
 {
-	unsigned int cls, con, tag, len;
-	unsigned char *end;
-
-	if (!asn1_header_decode(ctx, &end, &cls, &con, &tag))
-		return 0;
-
-	if (cls != ASN1_UNI || con != ASN1_PRI || tag != ASN1_OJI)
-		return 0;
-
-	if (!asn1_oid_decode(ctx, end, &trap->id, &trap->id_len))
-		return 0;
-
-	if (!asn1_header_decode(ctx, &end, &cls, &con, &tag))
-		goto err_id_free;
-
-	if (!((cls == ASN1_APL && con == ASN1_PRI && tag == SNMP_IPA) ||
-	      (cls == ASN1_UNI && con == ASN1_PRI && tag == ASN1_OTS)))
-		goto err_id_free;
-
-	if (!asn1_octets_decode(ctx, end, (unsigned char **)&trap->ip_address, &len))
-		goto err_id_free;
-
-	/* IPv4 only */
-	if (len != 4)
-		goto err_addr_free;
-
-	mangle_address(ctx->begin, ctx->pointer - 4, map, check);
-
-	if (!asn1_header_decode(ctx, &end, &cls, &con, &tag))
-		goto err_addr_free;
-
-	if (cls != ASN1_UNI || con != ASN1_PRI || tag != ASN1_INT)
-		goto err_addr_free;
-
-	if (!asn1_uint_decode(ctx, end, &trap->general))
-		goto err_addr_free;
-
-	if (!asn1_header_decode(ctx, &end, &cls, &con, &tag))
-		goto err_addr_free;
-
-	if (cls != ASN1_UNI || con != ASN1_PRI || tag != ASN1_INT)
-		goto err_addr_free;
-
-	if (!asn1_uint_decode(ctx, end, &trap->specific))
-		goto err_addr_free;
-
-	if (!asn1_header_decode(ctx, &end, &cls, &con, &tag))
-		goto err_addr_free;
-
-	if (!((cls == ASN1_APL && con == ASN1_PRI && tag == SNMP_TIT) ||
-	      (cls == ASN1_UNI && con == ASN1_PRI && tag == ASN1_INT)))
-		goto err_addr_free;
-
-	if (!asn1_ulong_decode(ctx, end, &trap->time))
-		goto err_addr_free;
+	if (*(unsigned char *)data > 1)
+		return -ENOTSUPP;
 
 	return 1;
-
-err_addr_free:
-	kfree((unsigned long *)trap->ip_address);
-
-err_id_free:
-	kfree(trap->id);
-
-	return 0;
 }
 
-/*****************************************************************************
- *
- * Misc. routines
- *
- *****************************************************************************/
-
-/*
- * Parse and mangle SNMP message according to mapping.
- * (And this is the fucking 'basic' method).
- */
-static int snmp_parse_mangle(unsigned char *msg,
-			     u_int16_t len,
-			     const struct oct1_map *map,
-			     __sum16 *check)
+int snmp_helper(void *context, size_t hdrlen, unsigned char tag,
+		const void *data, size_t datalen)
 {
-	unsigned char *eoc, *end;
-	unsigned int cls, con, tag, vers, pdutype;
-	struct asn1_ctx ctx;
-	struct asn1_octstr comm;
-	struct snmp_object *obj;
-
-	if (debug > 1)
-		print_hex_dump(KERN_DEBUG, "", DUMP_PREFIX_NONE, 16, 1,
-			       msg, len, 0);
-
-	asn1_open(&ctx, msg, len);
+	struct snmp_ctx *ctx = (struct snmp_ctx *)context;
+	__be32 *pdata = (__be32 *)data;
 
-	/*
-	 * Start of SNMP message.
-	 */
-	if (!asn1_header_decode(&ctx, &eoc, &cls, &con, &tag))
-		return 0;
-	if (cls != ASN1_UNI || con != ASN1_CON || tag != ASN1_SEQ)
-		return 0;
-
-	/*
-	 * Version 1 or 2 handled.
-	 */
-	if (!asn1_header_decode(&ctx, &end, &cls, &con, &tag))
-		return 0;
-	if (cls != ASN1_UNI || con != ASN1_PRI || tag != ASN1_INT)
-		return 0;
-	if (!asn1_uint_decode (&ctx, end, &vers))
-		return 0;
-	if (debug > 1)
-		pr_debug("bsalg: snmp version: %u\n", vers + 1);
-	if (vers > 1)
-		return 1;
+	if (*pdata == ctx->from) {
+		pr_debug("%s: %pI4 to %pI4\n", __func__,
+			 (void *)&ctx->from, (void *)&ctx->to);
 
-	/*
-	 * Community.
-	 */
-	if (!asn1_header_decode (&ctx, &end, &cls, &con, &tag))
-		return 0;
-	if (cls != ASN1_UNI || con != ASN1_PRI || tag != ASN1_OTS)
-		return 0;
-	if (!asn1_octets_decode(&ctx, end, &comm.data, &comm.len))
-		return 0;
-	if (debug > 1) {
-		unsigned int i;
-
-		pr_debug("bsalg: community: ");
-		for (i = 0; i < comm.len; i++)
-			pr_cont("%c", comm.data[i]);
-		pr_cont("\n");
+		if (*ctx->check)
+			fast_csum(ctx, (unsigned char *)data - ctx->begin);
+		*pdata = ctx->to;
 	}
-	kfree(comm.data);
-
-	/*
-	 * PDU type
-	 */
-	if (!asn1_header_decode(&ctx, &eoc, &cls, &con, &pdutype))
-		return 0;
-	if (cls != ASN1_CTX || con != ASN1_CON)
-		return 0;
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
-	if (pdutype != SNMP_PDU_RESPONSE &&
-	    pdutype != SNMP_PDU_TRAP1 && pdutype != SNMP_PDU_TRAP2)
-		return 1;
-
-	/*
-	 * Request header or v1 trap
-	 */
-	if (pdutype == SNMP_PDU_TRAP1) {
-		struct snmp_v1_trap trap;
-		unsigned char ret = snmp_trap_decode(&ctx, &trap, map, check);
-
-		if (ret) {
-			kfree(trap.id);
-			kfree((unsigned long *)trap.ip_address);
-		} else
-			return ret;
-
-	} else {
-		struct snmp_request req;
-
-		if (!snmp_request_decode(&ctx, &req))
-			return 0;
-
-		if (debug > 1)
-			pr_debug("bsalg: request: id=0x%lx error_status=%u "
-			"error_index=%u\n", req.id, req.error_status,
-			req.error_index);
-	}
-
-	/*
-	 * Loop through objects, look for IP addresses to mangle.
-	 */
-	if (!asn1_header_decode(&ctx, &eoc, &cls, &con, &tag))
-		return 0;
-
-	if (cls != ASN1_UNI || con != ASN1_CON || tag != ASN1_SEQ)
-		return 0;
-
-	while (!asn1_eoc_decode(&ctx, eoc)) {
-		unsigned int i;
-
-		if (!snmp_object_decode(&ctx, &obj)) {
-			if (obj) {
-				kfree(obj->id);
-				kfree(obj);
-			}
-			return 0;
-		}
-
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
-		if (obj->type == SNMP_IPADDR)
-			mangle_address(ctx.begin, ctx.pointer - 4, map, check);
-
-		kfree(obj->id);
-		kfree(obj);
-	}
-
-	if (!asn1_eoc_decode(&ctx, eoc))
-		return 0;
-
 	return 1;
 }
 
-/*****************************************************************************
- *
- * NAT routines.
- *
- *****************************************************************************/
-
-/*
- * SNMP translation routine.
- */
-static int snmp_translate(struct nf_conn *ct,
-			  enum ip_conntrack_info ctinfo,
-			  struct sk_buff *skb)
+static int snmp_translate(struct nf_conn *ct, int dir, struct sk_buff *skb)
 {
 	struct iphdr *iph = ip_hdr(skb);
 	struct udphdr *udph = (struct udphdr *)((__be32 *)iph + iph->ihl);
-	u_int16_t udplen = ntohs(udph->len);
-	u_int16_t paylen = udplen - sizeof(struct udphdr);
-	int dir = CTINFO2DIR(ctinfo);
-	struct oct1_map map;
+	u16 datalen = ntohs(udph->len) - sizeof(struct udphdr);
+	unsigned char *data = (unsigned char *)udph + sizeof(struct udphdr);
+	struct snmp_ctx ctx;
+	int ret;
 
-	/*
-	 * Determine mappping for application layer addresses based
-	 * on NAT manipulations for the packet.
-	 */
 	if (dir == IP_CT_DIR_ORIGINAL) {
-		/* SNAT traps */
-		map.from = NOCT1(&ct->tuplehash[dir].tuple.src.u3.ip);
-		map.to = NOCT1(&ct->tuplehash[!dir].tuple.dst.u3.ip);
+		ctx.from = ct->tuplehash[dir].tuple.src.u3.ip;
+		ctx.to = ct->tuplehash[!dir].tuple.dst.u3.ip;
 	} else {
-		/* DNAT replies */
-		map.from = NOCT1(&ct->tuplehash[!dir].tuple.src.u3.ip);
-		map.to = NOCT1(&ct->tuplehash[dir].tuple.dst.u3.ip);
+		ctx.from = ct->tuplehash[!dir].tuple.src.u3.ip;
+		ctx.to = ct->tuplehash[dir].tuple.dst.u3.ip;
 	}
-
-	if (map.from == map.to)
+	if (ctx.from == ctx.to)
 		return NF_ACCEPT;
 
-	if (!snmp_parse_mangle((unsigned char *)udph + sizeof(struct udphdr),
-			       paylen, &map, &udph->check)) {
-		net_warn_ratelimited("bsalg: parser failed\n");
+	ctx.begin = (unsigned char *)udph + sizeof(struct udphdr);
+	ctx.check = &udph->check;
+	ret = asn1_ber_decoder(&nf_nat_snmp_basic_decoder, &ctx, data, datalen);
+	if (ret < 0)
 		return NF_DROP;
-	}
 	return NF_ACCEPT;
 }
 
@@ -1232,14 +185,17 @@ static int help(struct sk_buff *skb, unsigned int protoff,
 	if (ntohs(udph->len) != skb->len - (iph->ihl << 2)) {
 		net_warn_ratelimited("SNMP: dropping malformed packet src=%pI4 dst=%pI4\n",
 				     &iph->saddr, &iph->daddr);
-		 return NF_DROP;
+		nf_ct_helper_log(skb, ct, "too short packet");
+		return NF_DROP;
 	}
 
-	if (!skb_make_writable(skb, skb->len))
+	if (!skb_make_writable(skb, skb->len)) {
+		nf_ct_helper_log(skb, ct, "cannot mangle packet");
 		return NF_DROP;
+	}
 
 	spin_lock_bh(&snmp_lock);
-	ret = snmp_translate(ct, ctinfo, skb);
+	ret = snmp_translate(ct, dir, skb);
 	spin_unlock_bh(&snmp_lock);
 	return ret;
 }
@@ -1259,12 +215,6 @@ static struct nf_conntrack_helper snmp_trap_helper __read_mostly = {
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
@@ -1282,5 +232,3 @@ static void __exit nf_nat_snmp_basic_fini(void)
 
 module_init(nf_nat_snmp_basic_init);
 module_exit(nf_nat_snmp_basic_fini);
-
-module_param(debug, int, 0600);
-- 
2.9.3

