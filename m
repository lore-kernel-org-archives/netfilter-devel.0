From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nftables 5/9] src: add host byte order integer type
Date: Fri,  3 Feb 2017 13:35:52 +0100
Message-ID: <20170203123556.17357-6-fw@strlen.de>
References: <20170203123556.17357-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:41972 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752700AbdBCMfz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Feb 2017 07:35:55 -0500
In-Reply-To: <20170203123556.17357-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is needed once we add support to set a zone, as in

ct zone set 42

Using integer_type makes nft use big-endian representation of the zone id
instead of the required host byte order.

When using 'ct zone 1', things will work because the (implicit) relational
operation makes sure that the left and right sides have same byte order.

In the statement case the lack of relop means we either need to convert
ourselves (the ct template contains endianess info), or use a dedicated type
(the latter is the reason why setting a mark will 'just work' since the
 mark type takes care of it).

The dedicated type has the advantage that it also works when maps are used:

ct zone set mark map { 1 : 10, 2 : 20, 3 : 30 }

... which is not easy to do with current map/set code, its endianess
settings rely on dtype->byteorder (i.e., it will always set BIG_ENDIAN
when we'd use integer_type for the zone).

Using evaluation context seems like a nightmare because several
places during eval steps can re-set this information, and propagating
the template info means to pollute generic code with something specific
to ct.

It seems like a future removal of all .byteorder members in the templates
in favor of using appropriate types might be a good idea.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/datatype.h |  2 ++
 src/datatype.c     | 10 ++++++++++
 2 files changed, 12 insertions(+)

diff --git a/include/datatype.h b/include/datatype.h
index 9f127f2954e3..8c1c827253be 100644
--- a/include/datatype.h
+++ b/include/datatype.h
@@ -82,6 +82,7 @@ enum datatypes {
 	TYPE_DSCP,
 	TYPE_ECN,
 	TYPE_FIB_ADDR,
+	TYPE_U32,
 	__TYPE_MAX
 };
 #define TYPE_MAX		(__TYPE_MAX - 1)
@@ -231,6 +232,7 @@ extern const struct datatype icmp_code_type;
 extern const struct datatype icmpv6_code_type;
 extern const struct datatype icmpx_code_type;
 extern const struct datatype time_type;
+extern const struct datatype u32_type;
 
 extern const struct datatype *concat_type_alloc(uint32_t type);
 extern void concat_type_destroy(const struct datatype *dtype);
diff --git a/src/datatype.c b/src/datatype.c
index 1518606a3f89..cab42d47f0f0 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -48,6 +48,7 @@ static const struct datatype *datatypes[TYPE_MAX + 1] = {
 	[TYPE_ICMP_CODE]	= &icmp_code_type,
 	[TYPE_ICMPV6_CODE]	= &icmpv6_code_type,
 	[TYPE_ICMPX_CODE]	= &icmpx_code_type,
+	[TYPE_U32]		= &u32_type,
 };
 
 void datatype_register(const struct datatype *dtype)
@@ -1057,3 +1058,12 @@ struct error_record *rate_parse(const struct location *loc, const char *str,
 
 	return NULL;
 }
+
+const struct datatype u32_type = {
+	.type		= TYPE_U32,
+	.name		= "u32",
+	.desc		= "32bit host endian integer",
+	.size		= 4 * BITS_PER_BYTE,
+	.byteorder	= BYTEORDER_HOST_ENDIAN,
+	.basetype	= &integer_type,
+};
-- 
2.10.2

