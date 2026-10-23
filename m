Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792763929;
	b=xikfzTmf5XLwFybrOIC5Gyy/6Tnv4gvw+9rRgL49PXZddDBoXZI8r5nbRZmpFtBq1s5P
	 iUtf0+cG4r9gIH65BTlp+AZvSNEads2/X6D+0lqMpijLBdjz/UMCfEVPBkNo1FyVG52Tn
	 qkc1NRb1MC7HYD0C57tPGr/s9DjVQ3+4GVlVtZfr1JjdjCAXC8sPrqem7AFHRzoiEI1+D
	 19yowTfuODp5VlZs+Xj90yi+CRntkiTwPvWK4Utz0z95TiEVJtv9siBjhCZs0s+gkeBlD
	 +qNxfYaj5n/gLSQ1kbohXP73cEBzEbKeRtCtA28mgAd/u+UMlBFYSst2WkY6utyGrFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792763929;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=QdI4+hSNa3VzdaAGMwr9UTxFvfOHZHg07LsQJI4eBLA=;
	b=UaVApWPrH+YZMlloLZ5bK2eTSFj4DYAUTFwhfAeBwU4SVuhOmgxTn83s/ltSHHY+7zf8
	 KCLhsj52RtX2+6wqYlTOchuJQEEvJh7jv2JgY2+70JkYkTdteieVPz5gxudLBe0jRD4E7
	 DmXWN6VP4A1JjcQcItPHq4Y5BWHAzI0/bhzbAf6zmZ16MZF9qW/ljOzapBNz7pbOrdpKQ
	 7OAcHg0FqJBvIodB+ntC91gy8Kz142U9nkEa/6cR7m6CubcsoN1hlFX+T9ZT3Ed98MlBb
	 IfF4zVLzrLDE4ZiF73brig2c362oPiQiIC9Ut5E3OcFH+PfNWn10shD+iPTYsh4b5bQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A792606A31B
	for <netfilter-devel@vger.kernel.org>; Fri, 23 Oct 2026 13:58:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7A792606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id DB2DF60796; Fri, 23 Oct 2026 15:58:46 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH libnftnl 7/7] src: add and use nftnl_mem_blob for user_data
Date: Fri, 23 Oct 2026 15:58:06 +0200
Message-ID: <20261023135806.7259-8-fw@strlen.de>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261023135806.7259-1-fw@strlen.de>
References: <20261023135806.7259-1-fw@strlen.de>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

user_data is handled via copypaste pattern.
Like the earlier change, LLM correctly points out that on alloc
failure we leave user_data area in inconsistent state.

The attribute flag remains set, ->user.data becomes NULL, ->user.len stale.
Caller would get NULL with non-zero len.

Add a single helper that has this issue resolved and switch
all udata users to that helper: obj, rule, set, chain, table and
set_elem.

While at it, fix set_elem parsing which tested/set the wrong flag bit
(NFTNL_RULE_USERDATA instead of NFTNL_SET_ELEM_USERDATA) when storing
userdata.

This doesn't change the library API, this is all internal.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/obj.h      |  5 +----
 include/rule.h     |  5 +----
 include/set.h      |  5 +----
 include/set_elem.h |  6 ++----
 include/utils.h    | 24 ++++++++++++++++++++++++
 src/chain.c        | 23 +++++++----------------
 src/object.c       | 18 ++++++------------
 src/rule.c         | 41 +++++++++++++----------------------------
 src/set.c          | 18 ++++++------------
 src/set_elem.c     | 31 +++++++++++--------------------
 src/table.c        | 23 +++++++----------------
 src/utils.c        | 19 +++++++++++++++++++
 12 files changed, 98 insertions(+), 120 deletions(-)

diff --git a/include/obj.h b/include/obj.h
index 811680e56f68..1689a70a8a73 100644
--- a/include/obj.h
+++ b/include/obj.h
@@ -22,10 +22,7 @@ struct nftnl_obj {
 	uint32_t		flags;
 	uint64_t		handle;
 
-	struct {
-		void		*data;
-		uint32_t	len;
-	} user;
+	struct nftnl_mem_blob	user_data;
 
 	union {
 		struct nftnl_obj_counter {
diff --git a/include/rule.h b/include/rule.h
index 036c7225d3ed..f03adc99bcef 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -12,10 +12,7 @@ struct nftnl_rule {
 	uint64_t	position;
 	uint32_t	id;
 	uint32_t	position_id;
-	struct {
-			void		*data;
-			uint32_t	len;
-	} user;
+	struct nftnl_mem_blob user_data;
 	struct {
 			uint32_t	flags;
 			uint32_t	proto;
diff --git a/include/set.h b/include/set.h
index bda80685590d..705189a40bf2 100644
--- a/include/set.h
+++ b/include/set.h
@@ -18,10 +18,7 @@ struct nftnl_set {
 	uint32_t		data_type;
 	uint32_t		data_len;
 	uint32_t		obj_type;
-	struct {
-		void		*data;
-		uint32_t	len;
-	} user;
+	struct nftnl_mem_blob	user_data;
 	uint32_t		id;
 	enum nft_set_policies	policy;
 	struct {
diff --git a/include/set_elem.h b/include/set_elem.h
index 76280051bb80..77f4c20f4687 100644
--- a/include/set_elem.h
+++ b/include/set_elem.h
@@ -2,6 +2,7 @@
 #define _LIBNFTNL_SET_ELEM_INTERNAL_H_
 
 #include <data_reg.h>
+#include "utils.h"
 
 struct nftnl_set_elem {
 	struct list_head	head;
@@ -14,10 +15,7 @@ struct nftnl_set_elem {
 	uint64_t		timeout;
 	uint64_t		expiration;
 	const char		*objref;
-	struct {
-		void		*data;
-		uint32_t	len;
-	} user;
+	struct nftnl_mem_blob	user;
 };
 
 int nftnl_set_elem_snprintf_default(char *buf, size_t size,
diff --git a/include/utils.h b/include/utils.h
index 5dcd287f491c..f1bf3f6ddd41 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -68,6 +68,13 @@ void __nftnl_assert_attr_exists(uint16_t attr, uint16_t attr_max,
 
 #define array_size(arr)		(sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
 
+struct nftnl_mem_blob {
+	void *data;
+	uint32_t len;
+};
+#define nftnl_mem_blob_attr_put(nlh, type, b) \
+	mnl_attr_put((nlh), (type), (b)->len, (b)->data)
+
 const char *nftnl_family2str(uint32_t family);
 
 const char *nftnl_verdict2str(uint32_t verdict);
@@ -80,6 +87,8 @@ int nftnl_fprintf(FILE *fpconst, const void *obj, uint32_t cmd, uint32_t type,
 			  	     uint32_t cmd, uint32_t type,
 				     uint32_t flags));
 
+int nftnl_set_udata_attr(struct nftnl_mem_blob *b, uint32_t *flags,
+			uint16_t attr, const void *data, uint32_t data_len);
 int nftnl_set_str_attr(const char **dptr, uint32_t *flags,
 		       uint16_t attr, const void *data, uint32_t data_len);
 
@@ -101,4 +110,19 @@ static inline uint32_t bytesum(uint8_t *buf, size_t buflen)
 	return ret;
 }
 
+static inline void nftnl_mem_blob_free(const struct nftnl_mem_blob *const_b)
+{
+	struct nftnl_mem_blob *b = (struct nftnl_mem_blob *)const_b;
+
+	xfree(b->data);
+	b->data = NULL;
+	b->len = 0;
+}
+
+static inline const void *nftnl_mem_blob_get(const struct nftnl_mem_blob *b, uint32_t *len)
+{
+	*len = b->len;
+	return b->data;
+}
+
 #endif
diff --git a/src/chain.c b/src/chain.c
index 5ee8e128556c..13b0231ee345 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -46,10 +46,7 @@ struct nftnl_chain {
 	uint32_t	flags;
 	uint32_t	chain_id;
 
-	struct {
-		void		*data;
-		uint32_t	len;
-	} user;
+	struct nftnl_mem_blob user_data;
 
 	struct list_head rule_list;
 };
@@ -125,7 +122,7 @@ void nftnl_chain_free(const struct nftnl_chain *c)
 	if (c->flags & (1 << NFTNL_CHAIN_DEV))
 		xfree(c->dev);
 	if (c->flags & (1 << NFTNL_CHAIN_USERDATA))
-		xfree(c->user.data);
+		nftnl_mem_blob_free(&c->user_data);
 	if (c->flags & (1 << NFTNL_CHAIN_DEVICES))
 		nftnl_str_array_clear((struct nftnl_str_array *)&c->dev_array);
 	xfree(c);
@@ -172,7 +169,7 @@ void nftnl_chain_unset(struct nftnl_chain *c, uint16_t attr)
 		nftnl_str_array_clear(&c->dev_array);
 		break;
 	case NFTNL_CHAIN_USERDATA:
-		xfree(c->user.data);
+		nftnl_mem_blob_free(&c->user_data);
 		break;
 	default:
 		return;
@@ -249,14 +246,9 @@ int nftnl_chain_set_data(struct nftnl_chain *c, uint16_t attr,
 		memcpy(&c->chain_id, data, sizeof(c->chain_id));
 		break;
 	case NFTNL_CHAIN_USERDATA:
-		if (c->flags & (1 << NFTNL_CHAIN_USERDATA))
-			xfree(c->user.data);
-
-		c->user.data = malloc(data_len);
-		if (!c->user.data)
+		if (nftnl_set_udata_attr(&c->user_data, &c->flags,
+					attr, data, data_len) < 0)
 			return -1;
-		memcpy(c->user.data, data, data_len);
-		c->user.len = data_len;
 		break;
 	}
 	c->flags |= (1 << attr);
@@ -360,8 +352,7 @@ const void *nftnl_chain_get_data(const struct nftnl_chain *c, uint16_t attr,
 		*data_len = sizeof(uint32_t);
 		return &c->chain_id;
 	case NFTNL_CHAIN_USERDATA:
-		*data_len = c->user.len;
-		return c->user.data;
+		return nftnl_mem_blob_get(&c->user_data, data_len);
 	}
 	return NULL;
 }
@@ -494,7 +485,7 @@ void nftnl_chain_nlmsg_build_payload(struct nlmsghdr *nlh, const struct nftnl_ch
 	if (c->flags & (1 << NFTNL_CHAIN_ID))
 		mnl_attr_put_u32(nlh, NFTA_CHAIN_ID, htonl(c->chain_id));
 	if (c->flags & (1 << NFTNL_CHAIN_USERDATA))
-		mnl_attr_put(nlh, NFTA_CHAIN_USERDATA, c->user.len, c->user.data);
+		nftnl_mem_blob_attr_put(nlh, NFTA_CHAIN_USERDATA, &c->user_data);
 }
 
 EXPORT_SYMBOL(nftnl_chain_rule_add);
diff --git a/src/object.c b/src/object.c
index aa5b544dbb7a..1198be6965d9 100644
--- a/src/object.c
+++ b/src/object.c
@@ -55,7 +55,7 @@ void nftnl_obj_free(const struct nftnl_obj *obj)
 	if (obj->flags & (1 << NFTNL_OBJ_NAME))
 		xfree(obj->name);
 	if (obj->flags & (1 << NFTNL_OBJ_USERDATA))
-		xfree(obj->user.data);
+		nftnl_mem_blob_free(&obj->user_data);
 	if (obj->flags & (1 << NFTNL_OBJ_TUNNEL_OPTS)) {
 		nftnl_tunnel_opts_free(obj->data.tunnel.tun_opts);
 		xfree(obj->data.tunnel.tun_opts);
@@ -84,7 +84,7 @@ void nftnl_obj_unset(struct nftnl_obj *obj, uint16_t attr)
 		xfree(obj->name);
 		break;
 	case NFTNL_OBJ_USERDATA:
-		xfree(obj->user.data);
+		nftnl_mem_blob_free(&obj->user_data);
 		break;
 	case NFTNL_OBJ_TYPE:
 	case NFTNL_OBJ_FAMILY:
@@ -135,14 +135,9 @@ int nftnl_obj_set_data(struct nftnl_obj *obj, uint16_t attr,
 		memcpy(&obj->handle, data, sizeof(obj->handle));
 		break;
 	case NFTNL_OBJ_USERDATA:
-		if (obj->flags & (1 << NFTNL_OBJ_USERDATA))
-			xfree(obj->user.data);
-
-		obj->user.data = malloc(data_len);
-		if (!obj->user.data)
+		if (nftnl_set_udata_attr(&obj->user_data, &obj->flags,
+					attr, data, data_len) < 0)
 			return -1;
-		memcpy(obj->user.data, data, data_len);
-		obj->user.len = data_len;
 		break;
 	default:
 		if (!obj->ops ||
@@ -226,8 +221,7 @@ const void *nftnl_obj_get_data(const struct nftnl_obj *obj, uint16_t attr,
 		*data_len = sizeof(uint64_t);
 		return &obj->handle;
 	case NFTNL_OBJ_USERDATA:
-		*data_len = obj->user.len;
-		return obj->user.data;
+		return nftnl_mem_blob_get(&obj->user_data, data_len);
 	default:
 		if (obj->ops)
 			return obj->ops->get(obj, attr, data_len);
@@ -290,7 +284,7 @@ void nftnl_obj_nlmsg_build_payload(struct nlmsghdr *nlh,
 	if (obj->flags & (1 << NFTNL_OBJ_HANDLE))
 		mnl_attr_put_u64(nlh, NFTA_OBJ_HANDLE, htobe64(obj->handle));
 	if (obj->flags & (1 << NFTNL_OBJ_USERDATA))
-		mnl_attr_put(nlh, NFTA_OBJ_USERDATA, obj->user.len, obj->user.data);
+		nftnl_mem_blob_attr_put(nlh, NFTA_OBJ_USERDATA, &obj->user_data);
 	if (obj->ops) {
 		struct nlattr *nest = mnl_attr_nest_start(nlh, NFTA_OBJ_DATA);
 
diff --git a/src/rule.c b/src/rule.c
index f8109969a918..c7bf6f3b14ad 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -52,7 +52,7 @@ void nftnl_rule_free(const struct nftnl_rule *r)
 	if (r->flags & (1 << (NFTNL_RULE_CHAIN)))
 		xfree(r->chain);
 	if (r->flags & (1 << (NFTNL_RULE_USERDATA)))
-		xfree(r->user.data);
+		nftnl_mem_blob_free(&r->user_data);
 
 	xfree(r);
 }
@@ -85,7 +85,7 @@ void nftnl_rule_unset(struct nftnl_rule *r, uint16_t attr)
 	case NFTNL_RULE_POSITION_ID:
 		break;
 	case NFTNL_RULE_USERDATA:
-		xfree(r->user.data);
+		nftnl_mem_blob_free(&r->user_data);
 		break;
 	}
 
@@ -132,15 +132,9 @@ int nftnl_rule_set_data(struct nftnl_rule *r, uint16_t attr,
 		memcpy(&r->position, data, sizeof(r->position));
 		break;
 	case NFTNL_RULE_USERDATA:
-		if (r->flags & (1 << NFTNL_RULE_USERDATA))
-			xfree(r->user.data);
-
-		r->user.data = malloc(data_len);
-		if (!r->user.data)
+		if (nftnl_set_udata_attr(&r->user_data, &r->flags,
+					 attr, data, data_len) < 0)
 			return -1;
-
-		memcpy(r->user.data, data, data_len);
-		r->user.len = data_len;
 		break;
 	case NFTNL_RULE_ID:
 		memcpy(&r->id, data, sizeof(r->id));
@@ -207,8 +201,7 @@ const void *nftnl_rule_get_data(const struct nftnl_rule *r, uint16_t attr,
 		*data_len = sizeof(uint64_t);
 		return &r->position;
 	case NFTNL_RULE_USERDATA:
-		*data_len = r->user.len;
-		return r->user.data;
+		return nftnl_mem_blob_get(&r->user_data, data_len);
 	case NFTNL_RULE_ID:
 		*data_len = sizeof(uint32_t);
 		return &r->id;
@@ -279,10 +272,8 @@ void nftnl_rule_nlmsg_build_payload(struct nlmsghdr *nlh, struct nftnl_rule *r)
 		mnl_attr_put_u64(nlh, NFTA_RULE_HANDLE, htobe64(r->handle));
 	if (r->flags & (1 << NFTNL_RULE_POSITION))
 		mnl_attr_put_u64(nlh, NFTA_RULE_POSITION, htobe64(r->position));
-	if (r->flags & (1 << NFTNL_RULE_USERDATA)) {
-		mnl_attr_put(nlh, NFTA_RULE_USERDATA, r->user.len,
-			     r->user.data);
-	}
+	if (r->flags & (1 << NFTNL_RULE_USERDATA))
+		nftnl_mem_blob_attr_put(nlh, NFTA_RULE_USERDATA, &r->user_data);
 
 	if (!list_empty(&r->expr_list)) {
 		nest = mnl_attr_nest_start(nlh, NFTA_RULE_EXPRESSIONS);
@@ -456,20 +447,14 @@ int nftnl_rule_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_rule *r)
 		r->flags |= (1 << NFTNL_RULE_POSITION);
 	}
 	if (tb[NFTA_RULE_USERDATA]) {
+		uint16_t ulen =
+			mnl_attr_get_payload_len(tb[NFTA_RULE_USERDATA]);
 		const void *udata =
 			mnl_attr_get_payload(tb[NFTA_RULE_USERDATA]);
 
-		if (r->flags & (1 << NFTNL_RULE_USERDATA))
-			xfree(r->user.data);
-
-		r->user.len = mnl_attr_get_payload_len(tb[NFTA_RULE_USERDATA]);
-
-		r->user.data = malloc(r->user.len);
-		if (r->user.data == NULL)
+		if (nftnl_set_udata_attr(&r->user_data, &r->flags,
+					 NFTNL_RULE_USERDATA, udata, ulen) < 0)
 			return -1;
-
-		memcpy(r->user.data, udata, r->user.len);
-		r->flags |= (1 << NFTNL_RULE_USERDATA);
 	}
 	if (tb[NFTA_RULE_ID]) {
 		r->id = ntohl(mnl_attr_get_u32(tb[NFTA_RULE_ID]));
@@ -572,10 +557,10 @@ static int nftnl_rule_snprintf_default(char *buf, size_t remain,
 		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 
-	if (r->user.len) {
+	if (r->user_data.len) {
 		ret = snprintf(buf + offset, remain,
 			       "\n  userdata len %d sum 0x%x",
-			       r->user.len, bytesum(r->user.data, r->user.len));
+			       r->user_data.len, bytesum(r->user_data.data, r->user_data.len));
 		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 
diff --git a/src/set.c b/src/set.c
index 7dc442bc95ae..f7b0526253ff 100644
--- a/src/set.c
+++ b/src/set.c
@@ -48,7 +48,7 @@ void nftnl_set_free(const struct nftnl_set *s)
 	if (s->flags & (1 << NFTNL_SET_NAME))
 		xfree(s->name);
 	if (s->flags & (1 << NFTNL_SET_USERDATA))
-		xfree(s->user.data);
+		nftnl_mem_blob_free(&s->user_data);
 
 	list_for_each_entry_safe(expr, next, &s->expr_list, head) {
 		list_del(&expr->head);
@@ -102,7 +102,7 @@ void nftnl_set_unset(struct nftnl_set *s, uint16_t attr)
 	case NFTNL_SET_COUNT:
 		break;
 	case NFTNL_SET_USERDATA:
-		xfree(s->user.data);
+		nftnl_mem_blob_free(&s->user_data);
 		break;
 	case NFTNL_SET_EXPR:
 	case NFTNL_SET_EXPRESSIONS:
@@ -206,14 +206,9 @@ int nftnl_set_set_data(struct nftnl_set *s, uint16_t attr, const void *data,
 		memcpy(&s->elemcount, data, sizeof(s->elemcount));
 		break;
 	case NFTNL_SET_USERDATA:
-		if (s->flags & (1 << NFTNL_SET_USERDATA))
-			xfree(s->user.data);
-
-		s->user.data = malloc(data_len);
-		if (!s->user.data)
+		if (nftnl_set_udata_attr(&s->user_data, &s->flags,
+					 attr, data, data_len) < 0)
 			return -1;
-		memcpy(s->user.data, data, data_len);
-		s->user.len = data_len;
 		break;
 	case NFTNL_SET_EXPR:
 		list_for_each_entry_safe(expr, tmp, &s->expr_list, head) {
@@ -315,8 +310,7 @@ const void *nftnl_set_get_data(const struct nftnl_set *s, uint16_t attr,
 		*data_len = sizeof(uint32_t);
 		return &s->elemcount;
 	case NFTNL_SET_USERDATA:
-		*data_len = s->user.len;
-		return s->user.data;
+		return nftnl_mem_blob_get(&s->user_data, data_len);
 	case NFTNL_SET_EXPR:
 		list_for_each_entry(expr, &s->expr_list, head)
 			break;
@@ -434,7 +428,7 @@ void nftnl_set_nlmsg_build_payload(struct nlmsghdr *nlh, struct nftnl_set *s)
 	if (s->flags & (1 << NFTNL_SET_GC_INTERVAL))
 		mnl_attr_put_u32(nlh, NFTA_SET_GC_INTERVAL, htonl(s->gc_interval));
 	if (s->flags & (1 << NFTNL_SET_USERDATA))
-		mnl_attr_put(nlh, NFTA_SET_USERDATA, s->user.len, s->user.data);
+		nftnl_mem_blob_attr_put(nlh, NFTA_SET_USERDATA, &s->user_data);
 	if (!list_empty(&s->expr_list)) {
 		struct nftnl_expr *expr;
 
diff --git a/src/set_elem.c b/src/set_elem.c
index 83c65ee33548..3504a2306e47 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -49,7 +49,7 @@ void nftnl_set_elem_free(struct nftnl_set_elem *s)
 		nftnl_expr_free(e);
 
 	if (s->flags & (1 << NFTNL_SET_ELEM_USERDATA))
-		xfree(s->user.data);
+		nftnl_mem_blob_free(&s->user);
 
 	if (s->flags & (1 << NFTNL_SET_ELEM_OBJREF))
 		xfree(s->objref);
@@ -84,7 +84,7 @@ void nftnl_set_elem_unset(struct nftnl_set_elem *s, uint16_t attr)
 	case NFTNL_SET_ELEM_EXPIRATION:	/* NFTA_SET_ELEM_EXPIRATION */
 		break;
 	case NFTNL_SET_ELEM_USERDATA:	/* NFTA_SET_ELEM_USERDATA */
-		xfree(s->user.data);
+		nftnl_mem_blob_free(&s->user);
 		break;
 	case NFTNL_SET_ELEM_EXPR:
 	case NFTNL_SET_ELEM_EXPRESSIONS:
@@ -154,14 +154,9 @@ __nftnl_set_elem_set(struct nftnl_set_elem *s, uint16_t attr, const void *data,
 		memcpy(&s->expiration, data, sizeof(s->expiration));
 		break;
 	case NFTNL_SET_ELEM_USERDATA: /* NFTA_SET_ELEM_USERDATA */
-		if (s->flags & (1 << NFTNL_SET_ELEM_USERDATA))
-			xfree(s->user.data);
-
-		s->user.data = malloc(data_len);
-		if (!s->user.data)
+		if (nftnl_set_udata_attr(&s->user, &s->flags,
+					 attr, data, data_len) < 0)
 			return -1;
-		memcpy(s->user.data, data, data_len);
-		s->user.len = data_len;
 		break;
 	case NFTNL_SET_ELEM_OBJREF:
 		if (s->flags & (1 << NFTNL_SET_ELEM_OBJREF))
@@ -250,8 +245,7 @@ const void *nftnl_set_elem_get(struct nftnl_set_elem *s, uint16_t attr, uint32_t
 		*data_len = sizeof(s->expiration);
 		return &s->expiration;
 	case NFTNL_SET_ELEM_USERDATA:
-		*data_len = s->user.len;
-		return s->user.data;
+		return nftnl_mem_blob_get(&s->user, data_len);
 	case NFTNL_SET_ELEM_EXPR:
 		list_for_each_entry(expr, &s->expr_list, head)
 			break;
@@ -340,7 +334,7 @@ void nftnl_set_elem_nlmsg_build_payload(struct nlmsghdr *nlh,
 		mnl_attr_nest_end(nlh, nest1);
 	}
 	if (e->flags & (1 << NFTNL_SET_ELEM_USERDATA))
-		mnl_attr_put(nlh, NFTA_SET_ELEM_USERDATA, e->user.len, e->user.data);
+		nftnl_mem_blob_attr_put(nlh, NFTA_SET_ELEM_USERDATA, &e->user);
 	if (e->flags & (1 << NFTNL_SET_ELEM_OBJREF))
 		mnl_attr_put_strz(nlh, NFTA_SET_ELEM_OBJREF, e->objref);
 
@@ -557,20 +551,17 @@ static int nftnl_set_elems_parse2(struct nftnl_set *s, const struct nlattr *nest
 		e->flags |= (1 << NFTNL_SET_ELEM_EXPRESSIONS);
 	}
 	if (tb[NFTA_SET_ELEM_USERDATA]) {
+		uint32_t ulen =
+			mnl_attr_get_payload_len(tb[NFTA_SET_ELEM_USERDATA]);
 		const void *udata =
 			mnl_attr_get_payload(tb[NFTA_SET_ELEM_USERDATA]);
 
-		if (e->flags & (1 << NFTNL_RULE_USERDATA))
-			xfree(e->user.data);
-
-		e->user.len  = mnl_attr_get_payload_len(tb[NFTA_SET_ELEM_USERDATA]);
-		e->user.data = malloc(e->user.len);
-		if (e->user.data == NULL) {
+		if (nftnl_set_udata_attr(&e->user, &e->flags,
+					 NFTNL_SET_ELEM_USERDATA,
+					 udata, ulen) < 0) {
 			ret = -1;
 			goto out_set_elem;
 		}
-		memcpy(e->user.data, udata, e->user.len);
-		e->flags |= (1 << NFTNL_RULE_USERDATA);
 	}
 	if (nftnl_parse_str_attr(tb[NFTA_SET_ELEM_OBJREF],
 				 NFTNL_SET_ELEM_OBJREF,
diff --git a/src/table.c b/src/table.c
index 61382838ae1c..03aee30db9ec 100644
--- a/src/table.c
+++ b/src/table.c
@@ -31,10 +31,7 @@ struct nftnl_table {
 	uint32_t	use;
 	uint32_t	flags;
 	uint32_t	owner;
-	struct {
-		void		*data;
-		uint32_t	len;
-	} user;
+	struct nftnl_mem_blob user;
 };
 
 EXPORT_SYMBOL(nftnl_table_alloc);
@@ -49,7 +46,7 @@ void nftnl_table_free(const struct nftnl_table *t)
 	if (t->flags & (1 << NFTNL_TABLE_NAME))
 		xfree(t->name);
 	if (t->flags & (1 << NFTNL_TABLE_USERDATA))
-		xfree(t->user.data);
+		nftnl_mem_blob_free(&t->user);
 
 	xfree(t);
 }
@@ -71,7 +68,7 @@ void nftnl_table_unset(struct nftnl_table *t, uint16_t attr)
 		xfree(t->name);
 		break;
 	case NFTNL_TABLE_USERDATA:
-		xfree(t->user.data);
+		nftnl_mem_blob_free(&t->user);
 		break;
 	case NFTNL_TABLE_FLAGS:
 	case NFTNL_TABLE_HANDLE:
@@ -115,14 +112,9 @@ int nftnl_table_set_data(struct nftnl_table *t, uint16_t attr,
 		memcpy(&t->use, data, sizeof(t->use));
 		break;
 	case NFTNL_TABLE_USERDATA:
-		if (t->flags & (1 << NFTNL_TABLE_USERDATA))
-			xfree(t->user.data);
-
-		t->user.data = malloc(data_len);
-		if (!t->user.data)
+		if (nftnl_set_udata_attr(&t->user, &t->flags,
+					 attr, data, data_len) < 0)
 			return -1;
-		memcpy(t->user.data, data, data_len);
-		t->user.len = data_len;
 		break;
 	case NFTNL_TABLE_OWNER:
 		memcpy(&t->owner, data, sizeof(t->owner));
@@ -186,8 +178,7 @@ const void *nftnl_table_get_data(const struct nftnl_table *t, uint16_t attr,
 		*data_len = sizeof(uint32_t);
 		return &t->use;
 	case NFTNL_TABLE_USERDATA:
-		*data_len = t->user.len;
-		return t->user.data;
+		return nftnl_mem_blob_get(&t->user, data_len);
 	case NFTNL_TABLE_OWNER:
 		*data_len = sizeof(uint32_t);
 		return &t->owner;
@@ -239,7 +230,7 @@ void nftnl_table_nlmsg_build_payload(struct nlmsghdr *nlh, const struct nftnl_ta
 	if (t->flags & (1 << NFTNL_TABLE_FLAGS))
 		mnl_attr_put_u32(nlh, NFTA_TABLE_FLAGS, htonl(t->table_flags));
 	if (t->flags & (1 << NFTNL_TABLE_USERDATA))
-		mnl_attr_put(nlh, NFTA_TABLE_USERDATA, t->user.len, t->user.data);
+		nftnl_mem_blob_attr_put(nlh, NFTA_TABLE_USERDATA, &t->user);
 }
 
 static int nftnl_table_parse_attr_cb(const struct nlattr *attr, void *data)
diff --git a/src/utils.c b/src/utils.c
index ec15f9bc8646..f7d035baa3ae 100644
--- a/src/utils.c
+++ b/src/utils.c
@@ -136,6 +136,25 @@ void __noreturn __abi_breakage(const char *file, int line, const char *reason)
        exit(EXIT_FAILURE);
 }
 
+int nftnl_set_udata_attr(struct nftnl_mem_blob *b, uint32_t *flags,
+			 uint16_t attr, const void *data, uint32_t data_len)
+{
+	void *tmp = malloc(data_len);
+
+	if (!tmp)
+		return -1;
+
+	memcpy(tmp, data, data_len);
+
+	if (*flags & (1 << attr))
+		xfree(b->data);
+
+	b->data = tmp;
+	b->len = data_len;
+	*flags |= (1 << attr);
+	return 0;
+}
+
 int nftnl_set_str_attr(const char **dptr, uint32_t *flags,
 		       uint16_t attr, const void *data, uint32_t data_len)
 {
-- 
2.55.0

