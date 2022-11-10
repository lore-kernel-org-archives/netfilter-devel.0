Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 137C7C4332F
	for <netfilter-devel@archiver.kernel.org>; Thu, 10 Nov 2022 21:32:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232229AbiKJVcD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 10 Nov 2022 16:32:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231670AbiKJVby (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Nov 2022 16:31:54 -0500
Received: from mx0a-00190b01.pphosted.com (mx0a-00190b01.pphosted.com [IPv6:2620:100:9001:583::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C436D1D6
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Nov 2022 13:31:52 -0800 (PST)
Received: from pps.filterd (m0050095.ppops.net [127.0.0.1])
        by m0050095.ppops.net-00190b01. (8.17.1.19/8.17.1.19) with ESMTP id 2AAJ8a9g014385;
        Thu, 10 Nov 2022 21:31:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=jan2016.eng;
 bh=JZDpBRS9ofX42Ligs7lH8RrpoRkkv+Q7PrWy6A2UJ5w=;
 b=ig5+C50t9Of0VTzZdPCRG8IwR5jZGpIZKs0XEk2rlsqOzfAXz196GjueGemeGDoVTtPg
 Jz48W8bat40puh7i1wc/Sthn9Stydgrp2RRXm4am/86qWT7lAxrbQEkLtdpt4LMIJc2C
 x0Eti173p0ZrVGCCM5Mpyrkcy2tLutnNryxjeGanWT+OugYdP9MonWRi3kKKfSnoKhqW
 94Z0fVwc/qFjNZIXBspCxTtJp6zxCvEKPRUoDbThSyUif8UT/prlO38KNG3GIj7peXpw
 b1Ukt6FUN+gpGJfxThp7KZ9pCfk5HTSWpuuH/trpFBcG7/jE4Y7JVTrXlufr6Oul48/0 mg== 
Received: from prod-mail-ppoint6 (prod-mail-ppoint6.akamai.com [184.51.33.61] (may be forged))
        by m0050095.ppops.net-00190b01. (PPS) with ESMTPS id 3ks25jb7tw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Nov 2022 21:31:47 +0000
Received: from pps.filterd (prod-mail-ppoint6.akamai.com [127.0.0.1])
        by prod-mail-ppoint6.akamai.com (8.17.1.5/8.17.1.5) with ESMTP id 2AAHV4Cp031605;
        Thu, 10 Nov 2022 16:31:46 -0500
Received: from email.msg.corp.akamai.com ([172.27.91.27])
        by prod-mail-ppoint6.akamai.com (PPS) with ESMTPS id 3knk5xj74m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Nov 2022 16:31:46 -0500
Received: from usma1ex-dag4mb1.msg.corp.akamai.com (172.27.91.20) by
 usma1ex-dag4mb4.msg.corp.akamai.com (172.27.91.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.15; Thu, 10 Nov 2022 16:31:46 -0500
Received: from bos-lhvuce.bos01.corp.akamai.com (172.28.220.70) by
 usma1ex-dag4mb1.msg.corp.akamai.com (172.27.91.20) with Microsoft SMTP Server
 id 15.2.1118.15 via Frontend Transport; Thu, 10 Nov 2022 16:31:46 -0500
Received: by bos-lhvuce.bos01.corp.akamai.com (Postfix, from userid 35863)
        id 0FFC515FA7F; Thu, 10 Nov 2022 16:31:46 -0500 (EST)
From:   Vishwanath Pai <vpai@akamai.com>
To:     <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>
CC:     Vishwanath Pai <vpai@akamai.com>, <johunt@akamai.com>,
        <netfilter-devel@vger.kernel.org>
Subject: [PATCH v3 1/6] netfilter: ipset: Add support for new bitmask parameter
Date:   Thu, 10 Nov 2022 16:31:26 -0500
Message-ID: <20221110213131.2083331-2-vpai@akamai.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221110213131.2083331-1-vpai@akamai.com>
References: <20221110213131.2083331-1-vpai@akamai.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-10_13,2022-11-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 malwarescore=0 bulkscore=0 suspectscore=0 mlxscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211100150
X-Proofpoint-ORIG-GUID: UAhtGdQm91soZ2VDOmGWsg4jegZBUfvM
X-Proofpoint-GUID: UAhtGdQm91soZ2VDOmGWsg4jegZBUfvM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-10_13,2022-11-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 clxscore=1015 bulkscore=0 mlxlogscore=999 lowpriorityscore=0
 suspectscore=0 spamscore=0 priorityscore=1501 mlxscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211100150
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add a new parameter to complement the existing 'netmask' option. The
main difference between netmask and bitmask is that bitmask takes any
arbitrary ip address as input, it does not have to be a valid netmask.

The name of the new parameter is 'bitmask'. This lets us mask out
arbitrary bits in the ip address, for example:
ipset create set1 hash:ip bitmask 255.128.255.0
ipset create set2 hash:ip,port family inet6 bitmask ffff::ff80

Signed-off-by: Vishwanath Pai <vpai@akamai.com>
Signed-off-by: Joshua Hunt <johunt@akamai.com>
---
 include/libipset/args.h         |  1 +
 include/libipset/data.h         |  6 +++--
 include/libipset/linux_ip_set.h |  2 ++
 include/libipset/parse.h        |  2 ++
 lib/args.c                      |  8 ++++++
 lib/data.c                      | 10 ++++++++
 lib/debug.c                     |  1 +
 lib/errcode.c                   |  2 ++
 lib/parse.c                     | 43 +++++++++++++++++++++++++++++++++
 lib/print.c                     |  3 ++-
 lib/session.c                   |  8 ++++++
 11 files changed, 83 insertions(+), 3 deletions(-)

diff --git a/include/libipset/args.h b/include/libipset/args.h
index ef861c1..a549e42 100644
--- a/include/libipset/args.h
+++ b/include/libipset/args.h
@@ -58,6 +58,7 @@ enum ipset_keywords {
 	IPSET_ARG_SKBQUEUE,			/* skbqueue */
 	IPSET_ARG_BUCKETSIZE,			/* bucketsize */
 	IPSET_ARG_INITVAL,			/* initval */
+	IPSET_ARG_BITMASK,			/* bitmask */
 	IPSET_ARG_MAX,
 };
 
diff --git a/include/libipset/data.h b/include/libipset/data.h
index 0e33c67..afaf18c 100644
--- a/include/libipset/data.h
+++ b/include/libipset/data.h
@@ -37,6 +37,7 @@ enum ipset_opt {
 	IPSET_OPT_RESIZE,
 	IPSET_OPT_SIZE,
 	IPSET_OPT_FORCEADD,
+	IPSET_OPT_BITMASK,
 	/* Create-specific options, filled out by the kernel */
 	IPSET_OPT_ELEMENTS,
 	IPSET_OPT_REFERENCES,
@@ -70,7 +71,7 @@ enum ipset_opt {
 	IPSET_OPT_BUCKETSIZE,
 	IPSET_OPT_INITVAL,
 	/* Internal options */
-	IPSET_OPT_FLAGS = 48,	/* IPSET_FLAG_EXIST| */
+	IPSET_OPT_FLAGS = 49,	/* IPSET_FLAG_EXIST| */
 	IPSET_OPT_CADT_FLAGS,	/* IPSET_FLAG_BEFORE| */
 	IPSET_OPT_ELEM,
 	IPSET_OPT_TYPE,
@@ -105,7 +106,8 @@ enum ipset_opt {
 	| IPSET_FLAG(IPSET_OPT_COUNTERS)\
 	| IPSET_FLAG(IPSET_OPT_CREATE_COMMENT)\
 	| IPSET_FLAG(IPSET_OPT_FORCEADD)\
-	| IPSET_FLAG(IPSET_OPT_SKBINFO))
+	| IPSET_FLAG(IPSET_OPT_SKBINFO)\
+	| IPSET_FLAG(IPSET_OPT_BITMASK))
 
 #define IPSET_ADT_FLAGS			\
 	(IPSET_FLAG(IPSET_OPT_IP)	\
diff --git a/include/libipset/linux_ip_set.h b/include/libipset/linux_ip_set.h
index 1852636..4e32a50 100644
--- a/include/libipset/linux_ip_set.h
+++ b/include/libipset/linux_ip_set.h
@@ -89,6 +89,7 @@ enum {
 	IPSET_ATTR_CADT_LINENO = IPSET_ATTR_LINENO,	/* 9 */
 	IPSET_ATTR_MARK,	/* 10 */
 	IPSET_ATTR_MARKMASK,	/* 11 */
+	IPSET_ATTR_BITMASK,	/* 12 */
 	/* Reserve empty slots */
 	IPSET_ATTR_CADT_MAX = 16,
 	/* Create-only specific attributes */
@@ -157,6 +158,7 @@ enum ipset_errno {
 	IPSET_ERR_COMMENT,
 	IPSET_ERR_INVALID_MARKMASK,
 	IPSET_ERR_SKBINFO,
+	IPSET_ERR_BITMASK_NETMASK_EXCL,
 
 	/* Type specific error codes */
 	IPSET_ERR_TYPE_SPECIFIC = 4352,
diff --git a/include/libipset/parse.h b/include/libipset/parse.h
index 3fa9129..0123d4b 100644
--- a/include/libipset/parse.h
+++ b/include/libipset/parse.h
@@ -92,6 +92,8 @@ extern int ipset_parse_uint8(struct ipset_session *session,
 			     enum ipset_opt opt, const char *str);
 extern int ipset_parse_netmask(struct ipset_session *session,
 			       enum ipset_opt opt, const char *str);
+extern int ipset_parse_bitmask(struct ipset_session *session,
+			       enum ipset_opt opt, const char *str);
 extern int ipset_parse_flag(struct ipset_session *session,
 			    enum ipset_opt opt, const char *str);
 extern int ipset_parse_typename(struct ipset_session *session,
diff --git a/lib/args.c b/lib/args.c
index bab3b13..e47105c 100644
--- a/lib/args.c
+++ b/lib/args.c
@@ -300,6 +300,14 @@ static const struct ipset_arg ipset_args[] = {
 		.print = ipset_print_hexnumber,
 		.help = "[initval VALUE]",
 	},
+	[IPSET_ARG_BITMASK] = {
+		.name = { "bitmask", NULL },
+		.has_arg = IPSET_MANDATORY_ARG,
+		.opt = IPSET_OPT_BITMASK,
+		.parse = ipset_parse_bitmask,
+		.print = ipset_print_ip,
+		.help = "[bitmask bitmask]",
+	},
 };
 
 const struct ipset_arg *
diff --git a/lib/data.c b/lib/data.c
index 7720178..72f1330 100644
--- a/lib/data.c
+++ b/lib/data.c
@@ -53,6 +53,7 @@ struct ipset_data {
 			uint8_t bucketsize;
 			uint8_t resize;
 			uint8_t netmask;
+			union nf_inet_addr bitmask;
 			uint32_t hashsize;
 			uint32_t maxelem;
 			uint32_t markmask;
@@ -301,6 +302,12 @@ ipset_data_set(struct ipset_data *data, enum ipset_opt opt, const void *value)
 	case IPSET_OPT_NETMASK:
 		data->create.netmask = *(const uint8_t *) value;
 		break;
+	case IPSET_OPT_BITMASK:
+		if (!(data->family == NFPROTO_IPV4 ||
+		      data->family == NFPROTO_IPV6))
+			return -1;
+		copy_addr(data->family, &data->create.bitmask, value);
+		break;
 	case IPSET_OPT_BUCKETSIZE:
 		data->create.bucketsize = *(const uint8_t *) value;
 		break;
@@ -508,6 +515,8 @@ ipset_data_get(const struct ipset_data *data, enum ipset_opt opt)
 		return &data->create.markmask;
 	case IPSET_OPT_NETMASK:
 		return &data->create.netmask;
+	case IPSET_OPT_BITMASK:
+		return &data->create.bitmask;
 	case IPSET_OPT_BUCKETSIZE:
 		return &data->create.bucketsize;
 	case IPSET_OPT_RESIZE:
@@ -594,6 +603,7 @@ ipset_data_sizeof(enum ipset_opt opt, uint8_t family)
 	case IPSET_OPT_IP_TO:
 	case IPSET_OPT_IP2:
 	case IPSET_OPT_IP2_TO:
+	case IPSET_OPT_BITMASK:
 		return family == NFPROTO_IPV4 ? sizeof(uint32_t)
 					 : sizeof(struct in6_addr);
 	case IPSET_OPT_MARK:
diff --git a/lib/debug.c b/lib/debug.c
index bf57a41..dbc5cfb 100644
--- a/lib/debug.c
+++ b/lib/debug.c
@@ -40,6 +40,7 @@ static const struct ipset_attrname createattr2name[] = {
 	[IPSET_ATTR_MAXELEM]	= { .name = "MAXELEM" },
 	[IPSET_ATTR_MARKMASK]	= { .name = "MARKMASK" },
 	[IPSET_ATTR_NETMASK]	= { .name = "NETMASK" },
+	[IPSET_ATTR_BITMASK]    = { .name = "BITMASK" },
 	[IPSET_ATTR_BUCKETSIZE]	= { .name = "BUCKETSIZE" },
 	[IPSET_ATTR_RESIZE]	= { .name = "RESIZE" },
 	[IPSET_ATTR_SIZE]	= { .name = "SIZE" },
diff --git a/lib/errcode.c b/lib/errcode.c
index 76bab74..49c97a1 100644
--- a/lib/errcode.c
+++ b/lib/errcode.c
@@ -44,6 +44,8 @@ static const struct ipset_errcode_table core_errcode_table[] = {
 	  "The value of the markmask parameter is invalid" },
 	{ IPSET_ERR_INVALID_FAMILY, 0,
 	  "Protocol family not supported by the set type" },
+	{ IPSET_ERR_BITMASK_NETMASK_EXCL, 0,
+	  "netmask and bitmask options are mutually exclusive, provide only one" },
 
 	/* DESTROY specific error codes */
 	{ IPSET_ERR_BUSY, IPSET_CMD_DESTROY,
diff --git a/lib/parse.c b/lib/parse.c
index 974eaf8..48d71be 100644
--- a/lib/parse.c
+++ b/lib/parse.c
@@ -1703,6 +1703,9 @@ ipset_parse_netmask(struct ipset_session *session,
 	assert(str);
 
 	data = ipset_session_data(session);
+	if (ipset_data_test(data, IPSET_OPT_BITMASK))
+		return syntax_err("bitmask and netmask are mutually exclusive, provide only one");
+
 	family = ipset_data_family(data);
 	if (family == NFPROTO_UNSPEC) {
 		family = NFPROTO_IPV4;
@@ -1721,6 +1724,46 @@ ipset_parse_netmask(struct ipset_session *session,
 	return ipset_data_set(data, opt, &cidr);
 }
 
+/**
+ * ipset_parse_bitmask - parse string as a bitmask
+ * @session: session structure
+ * @opt: option kind of the data
+ * @str: string to parse
+ *
+ * Parse string as a bitmask value, depending on family type.
+ * If family is not set yet, INET is assumed.
+ * The value is stored in the data blob of the session.
+ *
+ * Returns 0 on success or a negative error code.
+ */
+int
+ipset_parse_bitmask(struct ipset_session *session,
+		    enum ipset_opt opt, const char *str)
+{
+	uint8_t family;
+	struct ipset_data *data;
+
+	assert(session);
+	assert(opt == IPSET_OPT_BITMASK);
+	assert(str);
+
+	data = ipset_session_data(session);
+	if (ipset_data_test(data, IPSET_OPT_NETMASK))
+		return syntax_err("bitmask and netmask are mutually exclusive, provide only one");
+
+	family = ipset_data_family(data);
+	if (family == NFPROTO_UNSPEC) {
+		family = NFPROTO_IPV4;
+		ipset_data_set(data, IPSET_OPT_FAMILY, &family);
+	}
+
+	if (parse_ipaddr(session, opt, str, family))
+		return syntax_err("bitmask is not valid for family = %s",
+				  family == NFPROTO_IPV4 ? "inet" : "inet6");
+
+	return 0;
+}
+
 /**
  * ipset_parse_flag - "parse" option flags
  * @session: session structure
diff --git a/lib/print.c b/lib/print.c
index a7ffd81..50f0ad6 100644
--- a/lib/print.c
+++ b/lib/print.c
@@ -265,7 +265,7 @@ ipset_print_ip(char *buf, unsigned int len,
 	assert(buf);
 	assert(len > 0);
 	assert(data);
-	assert(opt == IPSET_OPT_IP || opt == IPSET_OPT_IP2);
+	assert(opt == IPSET_OPT_IP || opt == IPSET_OPT_IP2 || opt == IPSET_OPT_BITMASK);
 
 	D("len: %u", len);
 	family = ipset_data_family(data);
@@ -976,6 +976,7 @@ ipset_print_data(char *buf, unsigned int len,
 		size = ipset_print_elem(buf, len, data, opt, env);
 		break;
 	case IPSET_OPT_IP:
+	case IPSET_OPT_BITMASK:
 		size = ipset_print_ip(buf, len, data, opt, env);
 		break;
 	case IPSET_OPT_PORT:
diff --git a/lib/session.c b/lib/session.c
index 1ca26ff..cdc59e0 100644
--- a/lib/session.c
+++ b/lib/session.c
@@ -462,6 +462,10 @@ static const struct ipset_attr_policy create_attrs[] = {
 		.type = MNL_TYPE_U32,
 		.opt = IPSET_OPT_MEMSIZE,
 	},
+	[IPSET_ATTR_BITMASK] = {
+		.type = MNL_TYPE_NESTED,
+		.opt = IPSET_OPT_BITMASK,
+	},
 };
 
 static const struct ipset_attr_policy adt_attrs[] = {
@@ -1721,6 +1725,10 @@ rawdata2attr(struct ipset_session *session, struct nlmsghdr *nlh,
 	if (attr->type == MNL_TYPE_NESTED) {
 		/* IP addresses */
 		struct nlattr *nested;
+
+		if (type == IPSET_ATTR_BITMASK)
+			family = ipset_data_family(session->data);
+
 		int atype = family == NFPROTO_IPV4 ? IPSET_ATTR_IPADDR_IPV4
 					      : IPSET_ATTR_IPADDR_IPV6;
 
-- 
2.25.1

