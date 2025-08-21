Received: from localhost.localdomain (203.red-83-63-38.staticip.rima-tde.net [83.63.38.203])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26C5721C9ED
	for <netfilter-devel@vger.kernel.org>; Thu, 21 Aug 2025 09:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.63.38.203
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755767858; cv=none; b=NSQGy284GB9Cns6RY0xmC2fzbZlG76Gm3SGp/ZiKoFgVewwOegoPWLQpcyR3tvHB2zxHXtnmtTscdQgt5hGZcWp1f1jv+YaLLR6QwNy2G7YMrD3gLDZVVaO7eSRBIWMjYxP0/vFVOF4uZSfjEWCQTOS5hwh4pEj4+LuMJSx342A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755767858; c=relaxed/simple;
	bh=MKbMOiJ/PqdnQsfuWBLisc0pslwZx9c9qBk20N6sbco=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aloKHZCIRJMz4ORl52xFj4EHKJbhxEeiToBCEzmlEwbm2AgPI731/OIcM7ovJDt0QHkztO0GuJPy8qu2COTCqAlhhrzzV2vV3ftkeAkBHadT0UZAXo3Djua6j+4P174wP/Js3EyhPInUzxisFqq60OJtSKso9fKRtJ33RFhPEzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.de; spf=none smtp.mailfrom=localhost.localdomain; arc=none smtp.client-ip=83.63.38.203
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=localhost.localdomain
Received: by localhost.localdomain (Postfix, from userid 1000)
	id D0C462165B09; Thu, 21 Aug 2025 11:17:34 +0200 (CEST)
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	pablo@netfilter.org,
	fw@strlen.de,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH 1/2 libnftnl v4] tunnel: rework options
Date: Thu, 21 Aug 2025 11:17:17 +0200
Message-ID: <20250821091718.9129-1-fmancera@suse.de>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pablo Neira Ayuso <pablo@netfilter.org>

Only vxlan gbp can work before this patch because
NFTNL_OBJ_TUNNEL_ERSPAN_V2_DIR is off by one in the internal object
flags.

Replace them by NFTNL_OBJ_TUNNEL_OPTS and add two new opaque
nftnl_tunnel_opts and nftnl_tunnel_opt structs to represent tunnel
options.

- nftnl_tunnel_opt_alloc() allocates one tunnel option.
- nftnl_tunnel_opt_set() to sets it up.
- nftnl_tunnel_opt_get() to get the option attribute.

Then, to manage the list of options:

- nftnl_tunnel_opts_alloc() allocates a list of tunnel options.
- nftnl_tunnel_opts_add() adds a option to the list.

Although vxlan and erspan support for a single tunnel option at this
stage, this API prepares for supporting gevene which allows for more
tunnel options.

Joint work with Fernando.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
v4: rebased
---
 include/libnftnl/object.h |  51 +++-
 include/obj.h             |  16 +-
 src/libnftnl.map          |  16 ++
 src/obj/tunnel.c          | 473 +++++++++++++++++++++++++++++++-------
 src/object.c              |   4 +
 5 files changed, 459 insertions(+), 101 deletions(-)

diff --git a/include/libnftnl/object.h b/include/libnftnl/object.h
index 9930355..6d0aab0 100644
--- a/include/libnftnl/object.h
+++ b/include/libnftnl/object.h
@@ -112,14 +112,52 @@ enum {
 	NFTNL_OBJ_TUNNEL_FLAGS,
 	NFTNL_OBJ_TUNNEL_TOS,
 	NFTNL_OBJ_TUNNEL_TTL,
-	NFTNL_OBJ_TUNNEL_VXLAN_GBP,
-	NFTNL_OBJ_TUNNEL_ERSPAN_VERSION,
-	NFTNL_OBJ_TUNNEL_ERSPAN_V1_INDEX,
-	NFTNL_OBJ_TUNNEL_ERSPAN_V2_HWID,
-	NFTNL_OBJ_TUNNEL_ERSPAN_V2_DIR,
+	NFTNL_OBJ_TUNNEL_OPTS,
 	__NFTNL_OBJ_TUNNEL_MAX,
 };
 
+#define NFTNL_TUNNEL_TYPE	0
+#define NFTNL_TUNNEL_BASE	4
+
+enum nftnl_tunnel_type {
+	NFTNL_TUNNEL_TYPE_VXLAN,
+	NFTNL_TUNNEL_TYPE_ERSPAN,
+};
+
+enum {
+	NFTNL_TUNNEL_VXLAN_GBP		= NFTNL_TUNNEL_BASE,
+	__NFTNL_TUNNEL_VXLAN_MAX,
+};
+
+enum {
+	NFTNL_TUNNEL_ERSPAN_VERSION	= NFTNL_TUNNEL_BASE,
+	NFTNL_TUNNEL_ERSPAN_V1_INDEX,
+	NFTNL_TUNNEL_ERSPAN_V2_HWID,
+	NFTNL_TUNNEL_ERSPAN_V2_DIR,
+	__NFTNL_TUNNEL_ERSPAN_MAX,
+};
+
+struct nftnl_tunnel_opt;
+struct nftnl_tunnel_opts;
+
+struct nftnl_tunnel_opts *nftnl_tunnel_opts_alloc(enum nftnl_tunnel_type type);
+int nftnl_tunnel_opts_add(struct nftnl_tunnel_opts *opts,
+			  struct nftnl_tunnel_opt *opt);
+void nftnl_tunnel_opts_free(struct nftnl_tunnel_opts *opts);
+
+struct nftnl_tunnel_opt *nftnl_tunnel_opt_alloc(enum nftnl_tunnel_type type);
+int nftnl_tunnel_opt_set(struct nftnl_tunnel_opt *opt, uint16_t type,
+			 const void *data, uint32_t data_len);
+const void *nftnl_tunnel_opt_get(const struct nftnl_tunnel_opt *ne, uint16_t attr);
+const void *nftnl_tunnel_opt_get_data(const struct nftnl_tunnel_opt *ne,
+				      uint16_t attr,
+				      uint32_t *data_len);
+uint8_t nftnl_tunnel_opt_get_u8(const struct nftnl_tunnel_opt *ne, uint16_t attr);
+uint16_t nftnl_tunnel_opt_get_u16(const struct nftnl_tunnel_opt *ne, uint16_t attr);
+uint32_t nftnl_tunnel_opt_get_u32(const struct nftnl_tunnel_opt *ne, uint16_t attr);
+enum nftnl_tunnel_type nftnl_tunnel_opt_get_type(const struct nftnl_tunnel_opt *ne);
+uint32_t nftnl_tunnel_opt_get_flags(const struct nftnl_tunnel_opt *ne);
+
 enum {
 	NFTNL_OBJ_SECMARK_CTX	= NFTNL_OBJ_BASE,
 	__NFTNL_OBJ_SECMARK_MAX,
@@ -148,6 +186,9 @@ uint16_t nftnl_obj_get_u16(const struct nftnl_obj *obj, uint16_t attr);
 uint32_t nftnl_obj_get_u32(const struct nftnl_obj *ne, uint16_t attr);
 uint64_t nftnl_obj_get_u64(const struct nftnl_obj *obj, uint16_t attr);
 const char *nftnl_obj_get_str(const struct nftnl_obj *ne, uint16_t attr);
+int nftnl_obj_tunnel_opts_foreach(const struct nftnl_obj *ne,
+				  int (*cb)(struct nftnl_tunnel_opt *ne, void *data),
+				  void *data);
 
 void nftnl_obj_nlmsg_build_payload(struct nlmsghdr *nlh,
 				   const struct nftnl_obj *ne);
diff --git a/include/obj.h b/include/obj.h
index d217737..5d3c4ec 100644
--- a/include/obj.h
+++ b/include/obj.h
@@ -78,21 +78,7 @@ struct nftnl_obj {
 			uint32_t	tun_flags;
 			uint8_t		tun_tos;
 			uint8_t		tun_ttl;
-			union {
-				struct {
-					uint32_t	gbp;
-				} tun_vxlan;
-				struct {
-					uint32_t	version;
-					union {
-						uint32_t	v1_index;
-						struct {
-							uint8_t	hwid;
-							uint8_t	dir;
-						} v2;
-					} u;
-				} tun_erspan;
-			} u;
+			struct nftnl_tunnel_opts *tun_opts;
 		} tunnel;
 		struct nftnl_obj_secmark {
 			char		ctx[NFT_SECMARK_CTX_MAXLEN];
diff --git a/src/libnftnl.map b/src/libnftnl.map
index 8fffff1..10c0e7f 100644
--- a/src/libnftnl.map
+++ b/src/libnftnl.map
@@ -383,3 +383,19 @@ LIBNFTNL_16 {
 LIBNFTNL_17 {
   nftnl_set_elem_nlmsg_build;
 } LIBNFTNL_16;
+
+LIBNFTNL_18 {
+nftnl_tunnel_opt_get;
+nftnl_tunnel_opt_get_data;
+nftnl_tunnel_opt_get_u8;
+nftnl_tunnel_opt_get_u16;
+nftnl_tunnel_opt_get_u32;
+nftnl_tunnel_opt_set;
+nftnl_tunnel_opt_alloc;
+nftnl_tunnel_opt_get_type;
+nftnl_tunnel_opt_get_flags;
+nftnl_tunnel_opts_alloc;
+nftnl_obj_tunnel_opts_foreach;
+nftnl_tunnel_opts_add;
+nftnl_tunnel_opts_free;
+} LIBNFTNL_17;
diff --git a/src/obj/tunnel.c b/src/obj/tunnel.c
index 8941e39..bed0342 100644
--- a/src/obj/tunnel.c
+++ b/src/obj/tunnel.c
@@ -57,20 +57,8 @@ nftnl_obj_tunnel_set(struct nftnl_obj *e, uint16_t type,
 	case NFTNL_OBJ_TUNNEL_TTL:
 		memcpy(&tun->tun_ttl, data, data_len);
 		break;
-	case NFTNL_OBJ_TUNNEL_VXLAN_GBP:
-		memcpy(&tun->u.tun_vxlan.gbp, data, data_len);
-		break;
-	case NFTNL_OBJ_TUNNEL_ERSPAN_VERSION:
-		memcpy(&tun->u.tun_erspan.version, data, data_len);
-		break;
-	case NFTNL_OBJ_TUNNEL_ERSPAN_V1_INDEX:
-		memcpy(&tun->u.tun_erspan.u.v1_index, data, data_len);
-		break;
-	case NFTNL_OBJ_TUNNEL_ERSPAN_V2_HWID:
-		memcpy(&tun->u.tun_erspan.u.v2.hwid, data, data_len);
-		break;
-	case NFTNL_OBJ_TUNNEL_ERSPAN_V2_DIR:
-		memcpy(&tun->u.tun_erspan.u.v2.dir, data, data_len);
+	case NFTNL_OBJ_TUNNEL_OPTS:
+		memcpy(&tun->tun_opts, data, data_len);
 		break;
 	}
 	return 0;
@@ -116,21 +104,9 @@ nftnl_obj_tunnel_get(const struct nftnl_obj *e, uint16_t type,
 	case NFTNL_OBJ_TUNNEL_TTL:
 		*data_len = sizeof(tun->tun_ttl);
 		return &tun->tun_ttl;
-	case NFTNL_OBJ_TUNNEL_VXLAN_GBP:
-		*data_len = sizeof(tun->u.tun_vxlan.gbp);
-		return &tun->u.tun_vxlan.gbp;
-	case NFTNL_OBJ_TUNNEL_ERSPAN_VERSION:
-		*data_len = sizeof(tun->u.tun_erspan.version);
-		return &tun->u.tun_erspan.version;
-	case NFTNL_OBJ_TUNNEL_ERSPAN_V1_INDEX:
-		*data_len = sizeof(tun->u.tun_erspan.u.v1_index);
-		return &tun->u.tun_erspan.u.v1_index;
-	case NFTNL_OBJ_TUNNEL_ERSPAN_V2_HWID:
-		*data_len = sizeof(tun->u.tun_erspan.u.v2.hwid);
-		return &tun->u.tun_erspan.u.v2.hwid;
-	case NFTNL_OBJ_TUNNEL_ERSPAN_V2_DIR:
-		*data_len = sizeof(tun->u.tun_erspan.u.v2.dir);
-		return &tun->u.tun_erspan.u.v2.dir;
+	case NFTNL_OBJ_TUNNEL_OPTS:
+		*data_len = sizeof(tun->tun_opts);
+		return &tun->tun_opts;
 	}
 	return NULL;
 }
@@ -171,11 +147,14 @@ static int nftnl_obj_tunnel_cb(const struct nlattr *attr, void *data)
 	return MNL_CB_OK;
 }
 
+static void nftnl_tunnel_opts_build(struct nlmsghdr *nlh,
+				    struct nftnl_tunnel_opts *opts);
+
 static void
 nftnl_obj_tunnel_build(struct nlmsghdr *nlh, const struct nftnl_obj *e)
 {
 	struct nftnl_obj_tunnel *tun = nftnl_obj_data(e);
-	struct nlattr *nest, *nest_inner;
+	struct nlattr *nest;
 
 	if (e->flags & (1 << NFTNL_OBJ_TUNNEL_ID))
 		mnl_attr_put_u32(nlh, NFTA_TUNNEL_KEY_ID, htonl(tun->id));
@@ -212,34 +191,8 @@ nftnl_obj_tunnel_build(struct nlmsghdr *nlh, const struct nftnl_obj *e)
 		mnl_attr_put_u8(nlh, NFTA_TUNNEL_KEY_TTL, tun->tun_ttl);
 	if (e->flags & (1 << NFTNL_OBJ_TUNNEL_FLAGS))
 		mnl_attr_put_u32(nlh, NFTA_TUNNEL_KEY_FLAGS, htonl(tun->tun_flags));
-	if (e->flags & (1 << NFTNL_OBJ_TUNNEL_VXLAN_GBP)) {
-		nest = mnl_attr_nest_start(nlh, NFTA_TUNNEL_KEY_OPTS);
-		nest_inner = mnl_attr_nest_start(nlh, NFTA_TUNNEL_KEY_OPTS_VXLAN);
-		mnl_attr_put_u32(nlh, NFTA_TUNNEL_KEY_VXLAN_GBP,
-				 htonl(tun->u.tun_vxlan.gbp));
-		mnl_attr_nest_end(nlh, nest_inner);
-		mnl_attr_nest_end(nlh, nest);
-	}
-	if (e->flags & (1 << NFTNL_OBJ_TUNNEL_ERSPAN_VERSION) &&
-	    (e->flags & (1 << NFTNL_OBJ_TUNNEL_ERSPAN_V1_INDEX) ||
-	     (e->flags & (1 << NFTNL_OBJ_TUNNEL_ERSPAN_V2_HWID) &&
-	      e->flags & (1u << NFTNL_OBJ_TUNNEL_ERSPAN_V2_DIR)))) {
-		nest = mnl_attr_nest_start(nlh, NFTA_TUNNEL_KEY_OPTS);
-		nest_inner = mnl_attr_nest_start(nlh, NFTA_TUNNEL_KEY_OPTS_ERSPAN);
-		mnl_attr_put_u32(nlh, NFTA_TUNNEL_KEY_ERSPAN_VERSION,
-				 htonl(tun->u.tun_erspan.version));
-		if (e->flags & (1 << NFTNL_OBJ_TUNNEL_ERSPAN_V1_INDEX))
-			mnl_attr_put_u32(nlh, NFTA_TUNNEL_KEY_ERSPAN_V1_INDEX,
-					 htonl(tun->u.tun_erspan.u.v1_index));
-		if (e->flags & (1 << NFTNL_OBJ_TUNNEL_ERSPAN_V2_HWID))
-			mnl_attr_put_u8(nlh, NFTA_TUNNEL_KEY_ERSPAN_V2_HWID,
-					tun->u.tun_erspan.u.v2.hwid);
-		if (e->flags & (1u << NFTNL_OBJ_TUNNEL_ERSPAN_V2_DIR))
-			mnl_attr_put_u8(nlh, NFTA_TUNNEL_KEY_ERSPAN_V2_DIR,
-					tun->u.tun_erspan.u.v2.dir);
-		mnl_attr_nest_end(nlh, nest_inner);
-		mnl_attr_nest_end(nlh, nest);
-	}
+	if (e->flags & (1 << NFTNL_OBJ_TUNNEL_OPTS))
+		nftnl_tunnel_opts_build(nlh, tun->tun_opts);
 }
 
 static int nftnl_obj_tunnel_ip_cb(const struct nlattr *attr, void *data)
@@ -335,6 +288,131 @@ static int nftnl_obj_tunnel_parse_ip6(struct nftnl_obj *e, struct nlattr *attr,
 	return 0;
 }
 
+struct nftnl_tunnel_opt {
+	struct list_head			list;
+
+	enum nftnl_tunnel_type			type;
+	uint32_t				flags;
+
+	union {
+		struct {
+			uint32_t		gbp;
+		} vxlan;
+		struct {
+			uint32_t		version;
+			struct {
+				uint32_t	index;
+			} v1;
+			struct {
+				uint8_t		hwid;
+				uint8_t		dir;
+			} v2;
+		} erspan;
+	};
+};
+
+struct nftnl_tunnel_opts {
+	enum nftnl_tunnel_type			type;
+	uint32_t				num;
+	struct list_head			opts_list;
+};
+
+EXPORT_SYMBOL(nftnl_tunnel_opt_get_data);
+const void *nftnl_tunnel_opt_get_data(const struct nftnl_tunnel_opt *ne,
+				      uint16_t attr, uint32_t *data_len)
+{
+	if (!(ne->flags & (1 << attr)))
+		return NULL;
+
+	switch (ne->type) {
+	case NFTNL_TUNNEL_TYPE_ERSPAN:
+		switch (attr) {
+		case NFTNL_TUNNEL_ERSPAN_VERSION:
+			*data_len = sizeof(uint32_t);
+			return &ne->erspan.version;
+		case NFTNL_TUNNEL_ERSPAN_V1_INDEX:
+			*data_len = sizeof(uint32_t);
+			return &ne->erspan.v1.index;
+		case NFTNL_TUNNEL_ERSPAN_V2_HWID:
+			*data_len = sizeof(uint8_t);
+			return &ne->erspan.v2.hwid;
+		case NFTNL_TUNNEL_ERSPAN_V2_DIR:
+			*data_len = sizeof(uint8_t);
+			return &ne->erspan.v2.dir;
+		}
+		break;
+	case NFTNL_TUNNEL_TYPE_VXLAN:
+		switch (attr) {
+		case NFTNL_TUNNEL_VXLAN_GBP:
+			*data_len = sizeof(uint32_t);
+			return &ne->vxlan.gbp;
+		}
+		break;
+	}
+
+	errno = EOPNOTSUPP;
+	return NULL;
+}
+
+EXPORT_SYMBOL(nftnl_tunnel_opt_get);
+const void *
+nftnl_tunnel_opt_get(const struct nftnl_tunnel_opt *ne, uint16_t attr)
+{
+	uint32_t data_len;
+	return nftnl_tunnel_opt_get_data(ne, attr, &data_len);
+}
+
+EXPORT_SYMBOL(nftnl_tunnel_opt_get_u8);
+uint8_t nftnl_tunnel_opt_get_u8(const struct nftnl_tunnel_opt *ne, uint16_t attr)
+{
+	const void *ret = nftnl_tunnel_opt_get(ne, attr);
+	return ret == NULL ? 0 : *((uint8_t *)ret);
+}
+
+EXPORT_SYMBOL(nftnl_tunnel_opt_get_u16);
+uint16_t nftnl_tunnel_opt_get_u16(const struct nftnl_tunnel_opt *ne, uint16_t attr)
+{
+	const void *ret = nftnl_tunnel_opt_get(ne, attr);
+	return ret == NULL ? 0 : *((uint16_t *)ret);
+}
+
+EXPORT_SYMBOL(nftnl_tunnel_opt_get_u32);
+uint32_t nftnl_tunnel_opt_get_u32(const struct nftnl_tunnel_opt *ne, uint16_t attr)
+{
+	const void *ret = nftnl_tunnel_opt_get(ne, attr);
+	return ret == NULL ? 0 : *((uint32_t *)ret);
+}
+
+EXPORT_SYMBOL(nftnl_tunnel_opt_get_type);
+enum nftnl_tunnel_type nftnl_tunnel_opt_get_type(const struct nftnl_tunnel_opt *ne)
+{
+	return ne->type;
+}
+
+EXPORT_SYMBOL(nftnl_tunnel_opt_get_flags);
+uint32_t nftnl_tunnel_opt_get_flags(const struct nftnl_tunnel_opt *ne)
+{
+	return ne->flags;
+}
+
+EXPORT_SYMBOL(nftnl_obj_tunnel_opts_foreach);
+int nftnl_obj_tunnel_opts_foreach(const struct nftnl_obj *ne,
+                              int (*cb)(struct nftnl_tunnel_opt *opt, void *data),
+                              void *data)
+{
+	struct nftnl_obj_tunnel *tun = nftnl_obj_data(ne);
+        struct nftnl_tunnel_opt *cur, *tmp;
+        int ret;
+
+        list_for_each_entry_safe(cur, tmp, &tun->tun_opts->opts_list, list) {
+                ret = cb(cur, data);
+                if (ret < 0)
+                        return ret;
+        }
+
+        return 0;
+}
+
 static int nftnl_obj_tunnel_vxlan_cb(const struct nlattr *attr, void *data)
 {
 	const struct nlattr **tb = data;
@@ -354,21 +432,29 @@ static int nftnl_obj_tunnel_vxlan_cb(const struct nlattr *attr, void *data)
 	return MNL_CB_OK;
 }
 
+struct nftnl_tunnel_opt *nftnl_tunnel_opt_alloc(enum nftnl_tunnel_type type);
+
 static int
-nftnl_obj_tunnel_parse_vxlan(struct nftnl_obj *e, struct nlattr *attr,
-			     struct nftnl_obj_tunnel *tun)
+nftnl_obj_tunnel_parse_vxlan(struct nftnl_tunnel_opts *opts, struct nlattr *attr)
 {
 	struct nlattr *tb[NFTA_TUNNEL_KEY_VXLAN_MAX + 1] = {};
+	struct nftnl_tunnel_opt *opt;
 
 	if (mnl_attr_parse_nested(attr, nftnl_obj_tunnel_vxlan_cb, tb) < 0)
 		return -1;
 
+	opt = nftnl_tunnel_opt_alloc(NFTNL_TUNNEL_TYPE_VXLAN);
+	if (!opt)
+		return -1;
+
 	if (tb[NFTA_TUNNEL_KEY_VXLAN_GBP]) {
-		tun->u.tun_vxlan.gbp =
+		opt->vxlan.gbp =
 			ntohl(mnl_attr_get_u32(tb[NFTA_TUNNEL_KEY_VXLAN_GBP]));
-		e->flags |= (1 << NFTNL_OBJ_TUNNEL_VXLAN_GBP);
+		opt->flags |= (1 << NFTNL_TUNNEL_VXLAN_GBP);
 	}
 
+	list_add_tail(&opt->list, &opts->opts_list);
+
 	return 0;
 }
 
@@ -398,35 +484,41 @@ static int nftnl_obj_tunnel_erspan_cb(const struct nlattr *attr, void *data)
 }
 
 static int
-nftnl_obj_tunnel_parse_erspan(struct nftnl_obj *e, struct nlattr *attr,
-			      struct nftnl_obj_tunnel *tun)
+nftnl_obj_tunnel_parse_erspan(struct nftnl_tunnel_opts *opts, struct nlattr *attr)
 {
 	struct nlattr *tb[NFTA_TUNNEL_KEY_ERSPAN_MAX + 1] = {};
+	struct nftnl_tunnel_opt *opt;
 
 	if (mnl_attr_parse_nested(attr, nftnl_obj_tunnel_erspan_cb, tb) < 0)
 		return -1;
 
+	opt = nftnl_tunnel_opt_alloc(NFTNL_TUNNEL_TYPE_ERSPAN);
+	if (!opt)
+		return -1;
+
 	if (tb[NFTA_TUNNEL_KEY_ERSPAN_VERSION]) {
-		tun->u.tun_erspan.version =
+		opt->erspan.version =
 			ntohl(mnl_attr_get_u32(tb[NFTA_TUNNEL_KEY_ERSPAN_VERSION]));
-		e->flags |= (1 << NFTNL_OBJ_TUNNEL_ERSPAN_VERSION);
+		opt->flags |= (1 << NFTNL_TUNNEL_ERSPAN_VERSION);
 	}
 	if (tb[NFTA_TUNNEL_KEY_ERSPAN_V1_INDEX]) {
-		tun->u.tun_erspan.u.v1_index =
+		opt->erspan.v1.index =
 			ntohl(mnl_attr_get_u32(tb[NFTA_TUNNEL_KEY_ERSPAN_V1_INDEX]));
-		e->flags |= (1 << NFTNL_OBJ_TUNNEL_ERSPAN_V1_INDEX);
+		opt->flags |= (1 << NFTNL_TUNNEL_ERSPAN_V1_INDEX);
 	}
 	if (tb[NFTA_TUNNEL_KEY_ERSPAN_V2_HWID]) {
-		tun->u.tun_erspan.u.v2.hwid =
+		opt->erspan.v2.hwid =
 			mnl_attr_get_u8(tb[NFTA_TUNNEL_KEY_ERSPAN_V2_HWID]);
-		e->flags |= (1 << NFTNL_OBJ_TUNNEL_ERSPAN_V2_HWID);
+		opt->flags |= (1 << NFTNL_TUNNEL_ERSPAN_V2_HWID);
 	}
 	if (tb[NFTA_TUNNEL_KEY_ERSPAN_V2_DIR]) {
-		tun->u.tun_erspan.u.v2.dir =
+		opt->erspan.v2.dir =
 			mnl_attr_get_u8(tb[NFTA_TUNNEL_KEY_ERSPAN_V2_DIR]);
-		e->flags |= (1u << NFTNL_OBJ_TUNNEL_ERSPAN_V2_DIR);
+		opt->flags |= (1 << NFTNL_TUNNEL_ERSPAN_V2_DIR);
 	}
 
+	list_add_tail(&opt->list, &opts->opts_list);
+
 	return 0;
 }
 
@@ -450,22 +542,36 @@ static int nftnl_obj_tunnel_opts_cb(const struct nlattr *attr, void *data)
 	return MNL_CB_OK;
 }
 
+struct nftnl_tunnel_opts *nftnl_tunnel_opts_alloc(enum nftnl_tunnel_type type);
+
 static int
 nftnl_obj_tunnel_parse_opts(struct nftnl_obj *e, struct nlattr *attr,
 			    struct nftnl_obj_tunnel *tun)
 {
 	struct nlattr *tb[NFTA_TUNNEL_KEY_OPTS_MAX + 1] = {};
+	struct nftnl_tunnel_opts *opts = NULL;
 	int err = 0;
 
 	if (mnl_attr_parse_nested(attr, nftnl_obj_tunnel_opts_cb, tb) < 0)
 		return -1;
 
 	if (tb[NFTA_TUNNEL_KEY_OPTS_VXLAN]) {
-		err = nftnl_obj_tunnel_parse_vxlan(e, tb[NFTA_TUNNEL_KEY_OPTS_VXLAN],
-						   tun);
+		opts = nftnl_tunnel_opts_alloc(NFTNL_TUNNEL_TYPE_VXLAN);
+		if (!opts)
+			return -1;
+
+		err = nftnl_obj_tunnel_parse_vxlan(opts, tb[NFTA_TUNNEL_KEY_OPTS_VXLAN]);
 	} else if (tb[NFTA_TUNNEL_KEY_OPTS_ERSPAN]) {
-		err = nftnl_obj_tunnel_parse_erspan(e, tb[NFTA_TUNNEL_KEY_OPTS_ERSPAN],
-						    tun);
+		opts = nftnl_tunnel_opts_alloc(NFTNL_TUNNEL_TYPE_ERSPAN);
+		if (!opts)
+			return -1;
+
+		err = nftnl_obj_tunnel_parse_erspan(opts, tb[NFTA_TUNNEL_KEY_OPTS_ERSPAN]);
+	}
+
+	if (opts) {
+		tun->tun_opts = opts;
+		e->flags |= (1 << NFTNL_OBJ_TUNNEL_OPTS);
 	}
 
 	return err;
@@ -532,6 +638,215 @@ static int nftnl_obj_tunnel_snprintf(char *buf, size_t len,
 	return snprintf(buf, len, "id %u ", tun->id);
 }
 
+EXPORT_SYMBOL(nftnl_tunnel_opts_alloc);
+struct nftnl_tunnel_opts *nftnl_tunnel_opts_alloc(enum nftnl_tunnel_type type)
+{
+	struct nftnl_tunnel_opts *opts;
+
+	switch (type) {
+	case NFTNL_TUNNEL_TYPE_VXLAN:
+	case NFTNL_TUNNEL_TYPE_ERSPAN:
+		break;
+	default:
+		errno = EOPNOTSUPP;
+		return NULL;
+	}
+
+	opts = calloc(1, sizeof(struct nftnl_tunnel_opts));
+	if (!opts)
+		return NULL;
+
+	opts->type = type;
+	INIT_LIST_HEAD(&opts->opts_list);
+
+	return opts;
+}
+
+EXPORT_SYMBOL(nftnl_tunnel_opts_add);
+int nftnl_tunnel_opts_add(struct nftnl_tunnel_opts *opts,
+			  struct nftnl_tunnel_opt *opt)
+{
+	if (opt->type != opts->type) {
+		errno = EOPNOTSUPP;
+		return -1;
+	}
+
+	switch (opts->type) {
+	case NFTNL_TUNNEL_TYPE_VXLAN:
+	case NFTNL_TUNNEL_TYPE_ERSPAN:
+		if (opts->num > 0) {
+			errno = EEXIST;
+			return -1;
+		}
+		break;
+	default:
+		errno = EOPNOTSUPP;
+		return -1;
+	}
+
+	list_add_tail(&opt->list, &opts->opts_list);
+
+	return 0;
+}
+
+EXPORT_SYMBOL(nftnl_tunnel_opts_free);
+void nftnl_tunnel_opts_free(struct nftnl_tunnel_opts *opts)
+{
+	struct nftnl_tunnel_opt *opt, *next;
+
+	list_for_each_entry_safe(opt, next, &opts->opts_list, list) {
+		switch(opts->type) {
+		case NFTNL_TUNNEL_TYPE_VXLAN:
+		case NFTNL_TUNNEL_TYPE_ERSPAN:
+			list_del(&opt->list);
+			xfree(opt);
+			break;
+		}
+	}
+}
+
+EXPORT_SYMBOL(nftnl_tunnel_opt_alloc);
+struct nftnl_tunnel_opt *nftnl_tunnel_opt_alloc(enum nftnl_tunnel_type type)
+{
+	struct nftnl_tunnel_opt *opt;
+
+	switch (type) {
+	case NFTNL_TUNNEL_TYPE_VXLAN:
+	case NFTNL_TUNNEL_TYPE_ERSPAN:
+		break;
+	default:
+		errno = EOPNOTSUPP;
+		return NULL;
+	}
+
+	opt = calloc(1, sizeof(struct nftnl_tunnel_opt));
+	if (!opt)
+		return NULL;
+
+	opt->type = type;
+
+	return opt;
+}
+
+static int nftnl_tunnel_opt_vxlan_set(struct nftnl_tunnel_opt *opt, uint16_t type,
+				      const void *data, uint32_t data_len)
+{
+	switch (type) {
+	case NFTNL_TUNNEL_VXLAN_GBP:
+		memcpy(&opt->vxlan.gbp, data, data_len);
+		break;
+	default:
+		errno = EOPNOTSUPP;
+		return -1;
+	}
+
+	opt->flags |= (1 << type);
+
+	return 0;
+}
+
+static int nftnl_tunnel_opt_erspan_set(struct nftnl_tunnel_opt *opt, uint16_t type,
+				       const void *data, uint32_t data_len)
+{
+	switch (type) {
+	case NFTNL_TUNNEL_ERSPAN_VERSION:
+		memcpy(&opt->erspan.version, data, data_len);
+		break;
+	case NFTNL_TUNNEL_ERSPAN_V1_INDEX:
+		memcpy(&opt->erspan.v1.index, data, data_len);
+		break;
+	case NFTNL_TUNNEL_ERSPAN_V2_HWID:
+		memcpy(&opt->erspan.v2.hwid, data, data_len);
+		break;
+	case NFTNL_TUNNEL_ERSPAN_V2_DIR:
+		memcpy(&opt->erspan.v2.dir, data, data_len);
+		break;
+	default:
+		errno = EOPNOTSUPP;
+		return -1;
+	}
+
+	opt->flags |= (1 << type);
+
+	return 0;
+}
+
+EXPORT_SYMBOL(nftnl_tunnel_opt_set);
+int nftnl_tunnel_opt_set(struct nftnl_tunnel_opt *opt, uint16_t type,
+			 const void *data, uint32_t data_len)
+{
+	switch (opt->type) {
+	case NFTNL_TUNNEL_TYPE_VXLAN:
+		return nftnl_tunnel_opt_vxlan_set(opt, type, data, data_len);
+	case NFTNL_TUNNEL_TYPE_ERSPAN:
+		return nftnl_tunnel_opt_erspan_set(opt, type, data, data_len);
+	default:
+		errno = EOPNOTSUPP;
+		return -1;
+	}
+
+	return 0;
+}
+
+static void nftnl_tunnel_opt_build_vxlan(struct nlmsghdr *nlh,
+					 const struct nftnl_tunnel_opt *opt)
+{
+	struct nlattr *nest_inner;
+
+	if (opt->flags & (1 << NFTNL_TUNNEL_VXLAN_GBP)) {
+		nest_inner = mnl_attr_nest_start(nlh, NFTA_TUNNEL_KEY_OPTS_VXLAN);
+		mnl_attr_put_u32(nlh, NFTA_TUNNEL_KEY_VXLAN_GBP,
+				 htonl(opt->vxlan.gbp));
+		mnl_attr_nest_end(nlh, nest_inner);
+	}
+}
+
+static void nftnl_tunnel_opt_build_erspan(struct nlmsghdr *nlh,
+					  const struct nftnl_tunnel_opt *opt)
+{
+	struct nlattr *nest_inner;
+
+	if (opt->flags & (1 << NFTNL_TUNNEL_ERSPAN_VERSION) &&
+	    (opt->flags & (1 << NFTNL_TUNNEL_ERSPAN_V1_INDEX) ||
+	     (opt->flags & (1 << NFTNL_TUNNEL_ERSPAN_V2_HWID) &&
+	      opt->flags & (1 << NFTNL_TUNNEL_ERSPAN_V2_DIR)))) {
+		nest_inner = mnl_attr_nest_start(nlh, NFTA_TUNNEL_KEY_OPTS_ERSPAN);
+		mnl_attr_put_u32(nlh, NFTA_TUNNEL_KEY_ERSPAN_VERSION,
+				 htonl(opt->erspan.version));
+		if (opt->flags & (1 << NFTNL_TUNNEL_ERSPAN_V1_INDEX))
+			mnl_attr_put_u32(nlh, NFTA_TUNNEL_KEY_ERSPAN_V1_INDEX,
+					 htonl(opt->erspan.v1.index));
+		if (opt->flags & (1 << NFTNL_TUNNEL_ERSPAN_V2_HWID))
+			mnl_attr_put_u8(nlh, NFTA_TUNNEL_KEY_ERSPAN_V2_HWID,
+					opt->erspan.v2.hwid);
+		if (opt->flags & (1 << NFTNL_TUNNEL_ERSPAN_V2_DIR))
+			mnl_attr_put_u8(nlh, NFTA_TUNNEL_KEY_ERSPAN_V2_DIR,
+					opt->erspan.v2.dir);
+		mnl_attr_nest_end(nlh, nest_inner);
+	}
+}
+
+void nftnl_tunnel_opts_build(struct nlmsghdr *nlh,
+			     struct nftnl_tunnel_opts *opts)
+{
+	const struct nftnl_tunnel_opt *opt;
+	struct nlattr *nest;
+
+	nest = mnl_attr_nest_start(nlh, NFTA_TUNNEL_KEY_OPTS);
+
+	list_for_each_entry(opt, &opts->opts_list, list) {
+		switch (opts->type) {
+		case NFTNL_TUNNEL_TYPE_VXLAN:
+			nftnl_tunnel_opt_build_vxlan(nlh, opt);
+			break;
+		case NFTNL_TUNNEL_TYPE_ERSPAN:
+			nftnl_tunnel_opt_build_erspan(nlh, opt);
+			break;
+		}
+	}
+	mnl_attr_nest_end(nlh, nest);
+}
+
 static struct attr_policy obj_tunnel_attr_policy[__NFTNL_OBJ_TUNNEL_MAX] = {
 	[NFTNL_OBJ_TUNNEL_ID]		= { .maxlen = sizeof(uint32_t) },
 	[NFTNL_OBJ_TUNNEL_IPV4_SRC]	= { .maxlen = sizeof(uint32_t) },
@@ -544,11 +859,7 @@ static struct attr_policy obj_tunnel_attr_policy[__NFTNL_OBJ_TUNNEL_MAX] = {
 	[NFTNL_OBJ_TUNNEL_FLAGS]	= { .maxlen = sizeof(uint32_t) },
 	[NFTNL_OBJ_TUNNEL_TOS]		= { .maxlen = sizeof(uint8_t) },
 	[NFTNL_OBJ_TUNNEL_TTL]		= { .maxlen = sizeof(uint8_t) },
-	[NFTNL_OBJ_TUNNEL_VXLAN_GBP]	= { .maxlen = sizeof(uint32_t) },
-	[NFTNL_OBJ_TUNNEL_ERSPAN_VERSION] = { .maxlen = sizeof(uint32_t) },
-	[NFTNL_OBJ_TUNNEL_ERSPAN_V1_INDEX] = { .maxlen = sizeof(uint32_t) },
-	[NFTNL_OBJ_TUNNEL_ERSPAN_V2_HWID] = { .maxlen = sizeof(uint8_t) },
-	[NFTNL_OBJ_TUNNEL_ERSPAN_V2_DIR] = { .maxlen = sizeof(uint8_t) },
+	[NFTNL_OBJ_TUNNEL_OPTS]		= { .maxlen = sizeof(struct nftnl_tunnel_opts *) },
 };
 
 struct obj_ops obj_ops_tunnel = {
diff --git a/src/object.c b/src/object.c
index bfcceb9..275a202 100644
--- a/src/object.c
+++ b/src/object.c
@@ -55,6 +55,10 @@ void nftnl_obj_free(const struct nftnl_obj *obj)
 		xfree(obj->name);
 	if (obj->flags & (1 << NFTNL_OBJ_USERDATA))
 		xfree(obj->user.data);
+	if (obj->flags & (1 << NFTNL_OBJ_TUNNEL_OPTS)) {
+		nftnl_tunnel_opts_free(obj->data.tunnel.tun_opts);
+		xfree(obj->data.tunnel.tun_opts);
+	}
 
 	xfree(obj);
 }
-- 
2.50.1

