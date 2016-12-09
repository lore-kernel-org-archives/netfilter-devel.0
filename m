From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftnl 4/7] set: add NFTNL_SET_OBJ_TYPE attribute
Date: Fri,  9 Dec 2016 14:31:56 +0100
Message-ID: <1481290319-10156-4-git-send-email-pablo@netfilter.org>
References: <1481290319-10156-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35554 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752117AbcLINcM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 9 Dec 2016 08:32:12 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5EF8096EC8
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Dec 2016 14:32:10 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4EE97DA729
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Dec 2016 14:32:10 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CC910DA729
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Dec 2016 14:32:04 +0100 (CET)
In-Reply-To: <1481290319-10156-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This new attribute specifies the stateful object type this set stores.
Similar to data type, but specific to store objects. You must set the
NFT_SET_OBJECT flag to use this.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/libnftnl/set.h |  1 +
 include/set.h          |  1 +
 src/set.c              | 27 +++++++++++++++++++++++++++
 3 files changed, 29 insertions(+)

diff --git a/include/libnftnl/set.h b/include/libnftnl/set.h
index adeb16c66e2b..0c978d916e4e 100644
--- a/include/libnftnl/set.h
+++ b/include/libnftnl/set.h
@@ -23,6 +23,7 @@ enum nftnl_set_attr {
 	NFTNL_SET_TIMEOUT,
 	NFTNL_SET_GC_INTERVAL,
 	NFTNL_SET_USERDATA,
+	NFTNL_SET_OBJ_TYPE,
 	__NFTNL_SET_MAX
 };
 #define NFTNL_SET_MAX (__NFTNL_SET_MAX - 1)
diff --git a/include/set.h b/include/set.h
index 85bd389a3bd8..c6deb73f54f4 100644
--- a/include/set.h
+++ b/include/set.h
@@ -14,6 +14,7 @@ struct nftnl_set {
 	uint32_t		key_len;
 	uint32_t		data_type;
 	uint32_t		data_len;
+	uint32_t		obj_type;
 	struct {
 		void		*data;
 		uint32_t	len;
diff --git a/src/set.c b/src/set.c
index a42b713c6f87..14d28b502c1d 100644
--- a/src/set.c
+++ b/src/set.c
@@ -80,6 +80,7 @@ void nftnl_set_unset(struct nftnl_set *s, uint16_t attr)
 	case NFTNL_SET_KEY_LEN:
 	case NFTNL_SET_DATA_TYPE:
 	case NFTNL_SET_DATA_LEN:
+	case NFTNL_SET_OBJ_TYPE:
 	case NFTNL_SET_FAMILY:
 	case NFTNL_SET_ID:
 	case NFTNL_SET_POLICY:
@@ -104,6 +105,7 @@ static uint32_t nftnl_set_validate[NFTNL_SET_MAX + 1] = {
 	[NFTNL_SET_KEY_LEN]		= sizeof(uint32_t),
 	[NFTNL_SET_DATA_TYPE]	= sizeof(uint32_t),
 	[NFTNL_SET_DATA_LEN]		= sizeof(uint32_t),
+	[NFTNL_SET_OBJ_TYPE]		= sizeof(uint32_t),
 	[NFTNL_SET_FAMILY]		= sizeof(uint32_t),
 	[NFTNL_SET_POLICY]		= sizeof(uint32_t),
 	[NFTNL_SET_DESC_SIZE]	= sizeof(uint32_t),
@@ -149,6 +151,9 @@ int nftnl_set_set_data(struct nftnl_set *s, uint16_t attr, const void *data,
 	case NFTNL_SET_DATA_LEN:
 		s->data_len = *((uint32_t *)data);
 		break;
+	case NFTNL_SET_OBJ_TYPE:
+		s->obj_type = *((uint32_t *)data);
+		break;
 	case NFTNL_SET_FAMILY:
 		s->family = *((uint32_t *)data);
 		break;
@@ -235,6 +240,9 @@ const void *nftnl_set_get_data(const struct nftnl_set *s, uint16_t attr,
 	case NFTNL_SET_DATA_LEN:
 		*data_len = sizeof(uint32_t);
 		return &s->data_len;
+	case NFTNL_SET_OBJ_TYPE:
+		*data_len = sizeof(uint32_t);
+		return &s->obj_type;
 	case NFTNL_SET_FAMILY:
 		*data_len = sizeof(uint32_t);
 		return &s->family;
@@ -360,6 +368,8 @@ void nftnl_set_nlmsg_build_payload(struct nlmsghdr *nlh, struct nftnl_set *s)
 		mnl_attr_put_u32(nlh, NFTA_SET_DATA_TYPE, htonl(s->data_type));
 	if (s->flags & (1 << NFTNL_SET_DATA_LEN))
 		mnl_attr_put_u32(nlh, NFTA_SET_DATA_LEN, htonl(s->data_len));
+	if (s->flags & (1 << NFTNL_SET_OBJ_TYPE))
+		mnl_attr_put_u32(nlh, NFTA_SET_OBJ_TYPE, htonl(s->obj_type));
 	if (s->flags & (1 << NFTNL_SET_ID))
 		mnl_attr_put_u32(nlh, NFTA_SET_ID, htonl(s->id));
 	if (s->flags & (1 << NFTNL_SET_POLICY))
@@ -498,6 +508,10 @@ int nftnl_set_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_set *s)
 		s->data_len = ntohl(mnl_attr_get_u32(tb[NFTA_SET_DATA_LEN]));
 		s->flags |= (1 << NFTNL_SET_DATA_LEN);
 	}
+	if (tb[NFTA_SET_OBJ_TYPE]) {
+		s->obj_type = ntohl(mnl_attr_get_u32(tb[NFTA_SET_OBJ_TYPE]));
+		s->flags |= (1 << NFTNL_SET_OBJ_TYPE);
+	}
 	if (tb[NFTA_SET_ID]) {
 		s->id = ntohl(mnl_attr_get_u32(tb[NFTA_SET_ID]));
 		s->flags |= (1 << NFTNL_SET_ID);
@@ -586,6 +600,14 @@ static int nftnl_jansson_parse_set_info(struct nftnl_set *s, json_t *tree,
 		nftnl_set_set_u32(s, NFTNL_SET_DATA_LEN, data_len);
 	}
 
+	if (nftnl_jansson_node_exist(root, "obj_type")) {
+		if (nftnl_jansson_parse_val(root, "obj_type", NFTNL_TYPE_U32,
+					  &data_type, err) < 0)
+			return -1;
+
+		nftnl_set_set_u32(s, NFTNL_SET_OBJ_TYPE, data_type);
+	}
+
 	if (nftnl_jansson_node_exist(root, "policy")) {
 		if (nftnl_jansson_parse_val(root, "policy", NFTNL_TYPE_U32,
 					  &policy, err) < 0)
@@ -759,6 +781,11 @@ static int nftnl_set_snprintf_json(char *buf, size_t size,
 		ret = snprintf(buf + offset, len, ",\"data_len\":%u", s->data_len);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
+	if (s->flags & (1 << NFTNL_SET_OBJ_TYPE)) {
+		ret = snprintf(buf + offset, len,
+				  ",\"obj_type\":%u", s->obj_type);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
 
 	if (s->flags & (1 << NFTNL_SET_POLICY)) {
 		ret = snprintf(buf + offset, len, ",\"policy\":%u",
-- 
2.1.4

