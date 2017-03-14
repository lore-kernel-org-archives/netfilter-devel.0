From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 5/9] ct: add conntrack event mask support
Date: Tue, 14 Mar 2017 20:58:12 +0100
Message-ID: <20170314195816.1721-6-fw@strlen.de>
References: <20170314195816.1721-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:42150 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751229AbdCNT6R (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 14 Mar 2017 15:58:17 -0400
In-Reply-To: <20170314195816.1721-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/datatype.h                            |  1 +
 include/linux/netfilter/nf_conntrack_common.h | 80 ++++++---------------------
 include/linux/netfilter/nf_tables.h           |  2 +
 src/ct.c                                      | 30 ++++++++++
 4 files changed, 49 insertions(+), 64 deletions(-)

diff --git a/include/datatype.h b/include/datatype.h
index e614b96e880b..04b7d8808cea 100644
--- a/include/datatype.h
+++ b/include/datatype.h
@@ -83,6 +83,7 @@ enum datatypes {
 	TYPE_ECN,
 	TYPE_FIB_ADDR,
 	TYPE_BOOLEAN,
+	TYPE_CT_EVENTBIT,
 	__TYPE_MAX
 };
 #define TYPE_MAX		(__TYPE_MAX - 1)
diff --git a/include/linux/netfilter/nf_conntrack_common.h b/include/linux/netfilter/nf_conntrack_common.h
index 27a1895218db..768ff251308b 100644
--- a/include/linux/netfilter/nf_conntrack_common.h
+++ b/include/linux/netfilter/nf_conntrack_common.h
@@ -79,73 +79,25 @@ enum ip_conntrack_status {
 	IPS_FIXED_TIMEOUT = (1 << IPS_FIXED_TIMEOUT_BIT),
 };
 
-/* Connection tracking event bits */
-enum ip_conntrack_events
-{
-	/* New conntrack */
-	IPCT_NEW_BIT = 0,
-	IPCT_NEW = (1 << IPCT_NEW_BIT),
-
-	/* Expected connection */
-	IPCT_RELATED_BIT = 1,
-	IPCT_RELATED = (1 << IPCT_RELATED_BIT),
-
-	/* Destroyed conntrack */
-	IPCT_DESTROY_BIT = 2,
-	IPCT_DESTROY = (1 << IPCT_DESTROY_BIT),
-
-	/* Timer has been refreshed */
-	IPCT_REFRESH_BIT = 3,
-	IPCT_REFRESH = (1 << IPCT_REFRESH_BIT),
-
-	/* Status has changed */
-	IPCT_STATUS_BIT = 4,
-	IPCT_STATUS = (1 << IPCT_STATUS_BIT),
-
-	/* Update of protocol info */
-	IPCT_PROTOINFO_BIT = 5,
-	IPCT_PROTOINFO = (1 << IPCT_PROTOINFO_BIT),
-
-	/* Volatile protocol info */
-	IPCT_PROTOINFO_VOLATILE_BIT = 6,
-	IPCT_PROTOINFO_VOLATILE = (1 << IPCT_PROTOINFO_VOLATILE_BIT),
-
-	/* New helper for conntrack */
-	IPCT_HELPER_BIT = 7,
-	IPCT_HELPER = (1 << IPCT_HELPER_BIT),
-
-	/* Update of helper info */
-	IPCT_HELPINFO_BIT = 8,
-	IPCT_HELPINFO = (1 << IPCT_HELPINFO_BIT),
-
-	/* Volatile helper info */
-	IPCT_HELPINFO_VOLATILE_BIT = 9,
-	IPCT_HELPINFO_VOLATILE = (1 << IPCT_HELPINFO_VOLATILE_BIT),
-
-	/* NAT info */
-	IPCT_NATINFO_BIT = 10,
-	IPCT_NATINFO = (1 << IPCT_NATINFO_BIT),
-
-	/* Counter highest bit has been set, unused */
-	IPCT_COUNTER_FILLING_BIT = 11,
-	IPCT_COUNTER_FILLING = (1 << IPCT_COUNTER_FILLING_BIT),
-
-	/* Mark is set */
-	IPCT_MARK_BIT = 12,
-	IPCT_MARK = (1 << IPCT_MARK_BIT),
-
-	/* NAT sequence adjustment */
-	IPCT_NATSEQADJ_BIT = 13,
-	IPCT_NATSEQADJ = (1 << IPCT_NATSEQADJ_BIT),
-
-	/* Secmark is set */
-	IPCT_SECMARK_BIT = 14,
-	IPCT_SECMARK = (1 << IPCT_SECMARK_BIT),
+/* Connection tracking event types */
+enum ip_conntrack_events {
+	IPCT_NEW,		/* new conntrack */
+	IPCT_RELATED,		/* related conntrack */
+	IPCT_DESTROY,		/* destroyed conntrack */
+	IPCT_REPLY,		/* connection has seen two-way traffic */
+	IPCT_ASSURED,		/* connection status has changed to assured */
+	IPCT_PROTOINFO,		/* protocol information has changed */
+	IPCT_HELPER,		/* new helper has been set */
+	IPCT_MARK,		/* new mark has been set */
+	IPCT_SEQADJ,		/* sequence adjustment has changed */
+	IPCT_NATSEQADJ = IPCT_SEQADJ,
+	IPCT_SECMARK,		/* new security mark has been set */
+	IPCT_LABEL,		/* new connlabel has been set */
 };
 
 enum ip_conntrack_expect_events {
-	IPEXP_NEW_BIT = 0,
-	IPEXP_NEW = (1 << IPEXP_NEW_BIT),
+	IPEXP_NEW,		/* new expectation */
+	IPEXP_DESTROY,		/* destroyed expectation */
 };
 
 
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 400f5049a022..9cc39b4458ca 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -901,6 +901,7 @@ enum nft_rt_attributes {
  * @NFT_CT_BYTES: conntrack bytes
  * @NFT_CT_AVGPKT: conntrack average bytes per packet
  * @NFT_CT_ZONE: conntrack zone
+ * @NFT_CT_EVENTMASK: ctnetlink events to be generated for this conntrack
  */
 enum nft_ct_keys {
 	NFT_CT_STATE,
@@ -921,6 +922,7 @@ enum nft_ct_keys {
 	NFT_CT_BYTES,
 	NFT_CT_AVGPKT,
 	NFT_CT_ZONE,
+	NFT_CT_EVENTMASK,
 };
 
 /**
diff --git a/src/ct.c b/src/ct.c
index fd8ca87a21fb..5014265a3427 100644
--- a/src/ct.c
+++ b/src/ct.c
@@ -100,6 +100,34 @@ static const struct datatype ct_status_type = {
 	.sym_tbl	= &ct_status_tbl,
 };
 
+static const struct symbol_table ct_events_tbl = {
+	.base		= BASE_HEXADECIMAL,
+	.symbols	= {
+		SYMBOL("new",		1 << IPCT_NEW),
+		SYMBOL("related",	1 << IPCT_RELATED),
+		SYMBOL("destroy",	1 << IPCT_DESTROY),
+		SYMBOL("reply",		1 << IPCT_REPLY),
+		SYMBOL("assured",	1 << IPCT_ASSURED),
+		SYMBOL("protoinfo",	1 << IPCT_PROTOINFO),
+		SYMBOL("helper",	1 << IPCT_HELPER),
+		SYMBOL("mark",		1 << IPCT_MARK),
+		SYMBOL("seqadj",	1 << IPCT_SEQADJ),
+		SYMBOL("secmark",	1 << IPCT_SECMARK),
+		SYMBOL("label",		1 << IPCT_LABEL),
+		SYMBOL_LIST_END
+	},
+};
+
+static const struct datatype ct_event_type = {
+	.type		= TYPE_CT_EVENTBIT,
+	.name		= "ct_event",
+	.desc		= "conntrack event bits",
+	.byteorder	= BYTEORDER_HOST_ENDIAN,
+	.size		= 4 * BITS_PER_BYTE,
+	.basetype	= &bitmask_type,
+	.sym_tbl	= &ct_events_tbl,
+};
+
 static struct symbol_table *ct_label_tbl;
 
 #define CT_LABEL_BIT_SIZE 128
@@ -236,6 +264,8 @@ static const struct ct_template ct_templates[] = {
 					      BYTEORDER_HOST_ENDIAN, 64),
 	[NFT_CT_ZONE]		= CT_TEMPLATE("zone", &integer_type,
 					      BYTEORDER_HOST_ENDIAN, 16),
+	[NFT_CT_EVENTMASK]	= CT_TEMPLATE("eventmask", &ct_event_type,
+					      BYTEORDER_HOST_ENDIAN, 32),
 };
 
 static void ct_print(enum nft_ct_keys key, int8_t dir)
-- 
2.10.2

