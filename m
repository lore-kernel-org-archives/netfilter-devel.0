Received: from localhost.localdomain (203.red-83-63-38.staticip.rima-tde.net [83.63.38.203])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A8472EE5F8
	for <netfilter-devel@vger.kernel.org>; Thu, 21 Aug 2025 09:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.63.38.203
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755767860; cv=none; b=Ku85AWDcQTHskN0bdy/44+Tc/NNPpuwWu1ctKZNRJIOrB3gDqAtoSmCc1+TCBXZAyjmPX37Nk7r/l9vH4fHa+6vo0TViUtWzeZjK0ehUrnYwyqQ2n8Q4NJEf+3jng0mkPpqSMV8nzOfmOjZanlxfCPopNu9m50xwabTsKv7+LmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755767860; c=relaxed/simple;
	bh=HTdrXb05N7SWnxw/IuY/kWfItw+lRPnWGfFQ9S3moNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XhxaV88+wOPpCda8544EMusdpXcKaYuKwk0firTovxG0c90HaT1hvPyA2Bn8pcy4bpwUkwsDZGcl9E3IWFeqKNECUAWjI4gISnUtrYMwiTiPykmLjiwGJ8b4LVkv3E5feqbuyQoiOMfeN5CLRVKyqWHSHUDq+lkQd7H/mZTc4sE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.de; spf=none smtp.mailfrom=localhost.localdomain; arc=none smtp.client-ip=83.63.38.203
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=localhost.localdomain
Received: by localhost.localdomain (Postfix, from userid 1000)
	id 2BB712165B0C; Thu, 21 Aug 2025 11:17:36 +0200 (CEST)
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	pablo@netfilter.org,
	fw@strlen.de,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH 2/2 libnftnl v4] tunnel: add support to geneve options
Date: Thu, 21 Aug 2025 11:17:18 +0200
Message-ID: <20250821091718.9129-2-fmancera@suse.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250821091718.9129-1-fmancera@suse.de>
References: <20250821091718.9129-1-fmancera@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In addition, modifies the netlink parsing to loop through the nested
array of NFTA_TUNNEL_KEY_OPTS.

Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v4: rebased
---
 include/libnftnl/object.h |   9 ++
 src/obj/tunnel.c          | 176 ++++++++++++++++++++++++++++++++++----
 2 files changed, 166 insertions(+), 19 deletions(-)

diff --git a/include/libnftnl/object.h b/include/libnftnl/object.h
index 6d0aab0..490e8b4 100644
--- a/include/libnftnl/object.h
+++ b/include/libnftnl/object.h
@@ -119,9 +119,12 @@ enum {
 #define NFTNL_TUNNEL_TYPE	0
 #define NFTNL_TUNNEL_BASE	4
 
+#define NFTNL_TUNNEL_GENEVE_DATA_MAXLEN		127
+
 enum nftnl_tunnel_type {
 	NFTNL_TUNNEL_TYPE_VXLAN,
 	NFTNL_TUNNEL_TYPE_ERSPAN,
+	NFTNL_TUNNEL_TYPE_GENEVE,
 };
 
 enum {
@@ -137,6 +140,12 @@ enum {
 	__NFTNL_TUNNEL_ERSPAN_MAX,
 };
 
+enum {
+	NFTNL_TUNNEL_GENEVE_CLASS	= NFTNL_TUNNEL_BASE,
+	NFTNL_TUNNEL_GENEVE_TYPE,
+	NFTNL_TUNNEL_GENEVE_DATA,
+};
+
 struct nftnl_tunnel_opt;
 struct nftnl_tunnel_opts;
 
diff --git a/src/obj/tunnel.c b/src/obj/tunnel.c
index bed0342..ea9cb02 100644
--- a/src/obj/tunnel.c
+++ b/src/obj/tunnel.c
@@ -308,6 +308,12 @@ struct nftnl_tunnel_opt {
 				uint8_t		dir;
 			} v2;
 		} erspan;
+		struct {
+			uint16_t	geneve_class;
+			uint8_t		type;
+			uint8_t		data[NFTNL_TUNNEL_GENEVE_DATA_MAXLEN];
+			uint32_t	data_len;
+		} geneve;
 	};
 };
 
@@ -348,6 +354,19 @@ const void *nftnl_tunnel_opt_get_data(const struct nftnl_tunnel_opt *ne,
 			return &ne->vxlan.gbp;
 		}
 		break;
+	case NFTNL_TUNNEL_TYPE_GENEVE:
+		switch (attr) {
+		case NFTNL_TUNNEL_GENEVE_CLASS:
+			*data_len = sizeof(uint16_t);
+			return &ne->geneve.geneve_class;
+		case NFTNL_TUNNEL_GENEVE_TYPE:
+			*data_len = sizeof(uint8_t);
+			return &ne->geneve.type;
+		case NFTNL_TUNNEL_GENEVE_DATA:
+			*data_len = ne->geneve.data_len;
+			return &ne->geneve.data;
+		}
+		break;
 	}
 
 	errno = EOPNOTSUPP;
@@ -522,18 +541,25 @@ nftnl_obj_tunnel_parse_erspan(struct nftnl_tunnel_opts *opts, struct nlattr *att
 	return 0;
 }
 
-static int nftnl_obj_tunnel_opts_cb(const struct nlattr *attr, void *data)
+static int nftnl_obj_tunnel_geneve_cb(const struct nlattr *attr, void *data)
 {
 	const struct nlattr **tb = data;
 	int type = mnl_attr_get_type(attr);
 
-	if (mnl_attr_type_valid(attr, NFTA_TUNNEL_KEY_OPTS_MAX) < 0)
+	if (mnl_attr_type_valid(attr, NFTA_TUNNEL_KEY_GENEVE_MAX) < 0)
 		return MNL_CB_OK;
 
 	switch (type) {
-	case NFTA_TUNNEL_KEY_OPTS_VXLAN:
-	case NFTA_TUNNEL_KEY_OPTS_ERSPAN:
-		if (mnl_attr_validate(attr, MNL_TYPE_NESTED) < 0)
+	case NFTA_TUNNEL_KEY_GENEVE_CLASS:
+		if (mnl_attr_validate(attr, MNL_TYPE_U16) < 0)
+			abi_breakage();
+		break;
+	case NFTA_TUNNEL_KEY_GENEVE_TYPE:
+		if (mnl_attr_validate(attr, MNL_TYPE_U8) < 0)
+			abi_breakage();
+		break;
+	case NFTA_TUNNEL_KEY_GENEVE_DATA:
+		if (mnl_attr_validate(attr, MNL_TYPE_BINARY) < 0)
 			abi_breakage();
 		break;
 	}
@@ -542,31 +568,85 @@ static int nftnl_obj_tunnel_opts_cb(const struct nlattr *attr, void *data)
 	return MNL_CB_OK;
 }
 
+static int
+nftnl_obj_tunnel_parse_geneve(struct nftnl_tunnel_opts *opts, struct nlattr *attr)
+{
+	struct nlattr *tb[NFTA_TUNNEL_KEY_GENEVE_MAX + 1] = {};
+	struct nftnl_tunnel_opt *opt;
+
+	if (mnl_attr_parse_nested(attr, nftnl_obj_tunnel_geneve_cb, tb) < 0)
+		return -1;
+
+	opt = nftnl_tunnel_opt_alloc(NFTNL_TUNNEL_TYPE_GENEVE);
+	if (!opt)
+		return -1;
+
+	if (tb[NFTA_TUNNEL_KEY_GENEVE_CLASS]) {
+		opt->geneve.geneve_class =
+			ntohs(mnl_attr_get_u16(tb[NFTA_TUNNEL_KEY_GENEVE_CLASS]));
+		opt->flags |= (1 << NFTNL_TUNNEL_GENEVE_CLASS);
+	}
+
+	if (tb[NFTA_TUNNEL_KEY_GENEVE_TYPE]) {
+		opt->geneve.type =
+			mnl_attr_get_u8(tb[NFTA_TUNNEL_KEY_GENEVE_TYPE]);
+		opt->flags |= (1 << NFTNL_TUNNEL_GENEVE_TYPE);
+	}
+
+	if (tb[NFTA_TUNNEL_KEY_GENEVE_DATA]) {
+		uint32_t len = mnl_attr_get_payload_len(tb[NFTA_TUNNEL_KEY_GENEVE_DATA]);
+
+		memcpy(opt->geneve.data,
+		       mnl_attr_get_payload(tb[NFTA_TUNNEL_KEY_GENEVE_DATA]),
+		       len);
+		opt->geneve.data_len = len;
+		opt->flags |= (1 << NFTNL_TUNNEL_GENEVE_DATA);
+	}
+
+	list_add_tail(&opt->list, &opts->opts_list);
+
+	return 0;
+}
+
 struct nftnl_tunnel_opts *nftnl_tunnel_opts_alloc(enum nftnl_tunnel_type type);
 
 static int
-nftnl_obj_tunnel_parse_opts(struct nftnl_obj *e, struct nlattr *attr,
+nftnl_obj_tunnel_parse_opts(struct nftnl_obj *e, struct nlattr *nest,
 			    struct nftnl_obj_tunnel *tun)
 {
-	struct nlattr *tb[NFTA_TUNNEL_KEY_OPTS_MAX + 1] = {};
+	struct nlattr *attr;
 	struct nftnl_tunnel_opts *opts = NULL;
 	int err = 0;
 
-	if (mnl_attr_parse_nested(attr, nftnl_obj_tunnel_opts_cb, tb) < 0)
-		return -1;
+	mnl_attr_for_each_nested(attr, nest) {
+		if (mnl_attr_validate(attr, MNL_TYPE_NESTED) < 0)
+			abi_breakage();
 
-	if (tb[NFTA_TUNNEL_KEY_OPTS_VXLAN]) {
-		opts = nftnl_tunnel_opts_alloc(NFTNL_TUNNEL_TYPE_VXLAN);
-		if (!opts)
-			return -1;
+		switch(mnl_attr_get_type(attr)) {
+			case NFTA_TUNNEL_KEY_OPTS_VXLAN:
+				opts = nftnl_tunnel_opts_alloc(NFTNL_TUNNEL_TYPE_VXLAN);
+				if (!opts)
+					return -1;
 
-		err = nftnl_obj_tunnel_parse_vxlan(opts, tb[NFTA_TUNNEL_KEY_OPTS_VXLAN]);
-	} else if (tb[NFTA_TUNNEL_KEY_OPTS_ERSPAN]) {
-		opts = nftnl_tunnel_opts_alloc(NFTNL_TUNNEL_TYPE_ERSPAN);
-		if (!opts)
-			return -1;
+				err = nftnl_obj_tunnel_parse_vxlan(opts, attr);
+			break;
+			case NFTA_TUNNEL_KEY_OPTS_ERSPAN:
+				opts = nftnl_tunnel_opts_alloc(NFTNL_TUNNEL_TYPE_ERSPAN);
+				if (!opts)
+					return -1;
+
+				err = nftnl_obj_tunnel_parse_erspan(opts, attr);
+			break;
+			case NFTA_TUNNEL_KEY_OPTS_GENEVE:
+				if (!opts)
+					opts = nftnl_tunnel_opts_alloc(NFTNL_TUNNEL_TYPE_GENEVE);
 
-		err = nftnl_obj_tunnel_parse_erspan(opts, tb[NFTA_TUNNEL_KEY_OPTS_ERSPAN]);
+				if (!opts)
+					return -1;
+
+				err = nftnl_obj_tunnel_parse_geneve(opts, attr);
+			break;
+		}
 	}
 
 	if (opts) {
@@ -646,6 +726,7 @@ struct nftnl_tunnel_opts *nftnl_tunnel_opts_alloc(enum nftnl_tunnel_type type)
 	switch (type) {
 	case NFTNL_TUNNEL_TYPE_VXLAN:
 	case NFTNL_TUNNEL_TYPE_ERSPAN:
+	case NFTNL_TUNNEL_TYPE_GENEVE:
 		break;
 	default:
 		errno = EOPNOTSUPP;
@@ -679,6 +760,8 @@ int nftnl_tunnel_opts_add(struct nftnl_tunnel_opts *opts,
 			return -1;
 		}
 		break;
+	case NFTNL_TUNNEL_TYPE_GENEVE:
+		break;
 	default:
 		errno = EOPNOTSUPP;
 		return -1;
@@ -698,6 +781,7 @@ void nftnl_tunnel_opts_free(struct nftnl_tunnel_opts *opts)
 		switch(opts->type) {
 		case NFTNL_TUNNEL_TYPE_VXLAN:
 		case NFTNL_TUNNEL_TYPE_ERSPAN:
+		case NFTNL_TUNNEL_TYPE_GENEVE:
 			list_del(&opt->list);
 			xfree(opt);
 			break;
@@ -713,6 +797,7 @@ struct nftnl_tunnel_opt *nftnl_tunnel_opt_alloc(enum nftnl_tunnel_type type)
 	switch (type) {
 	case NFTNL_TUNNEL_TYPE_VXLAN:
 	case NFTNL_TUNNEL_TYPE_ERSPAN:
+	case NFTNL_TUNNEL_TYPE_GENEVE:
 		break;
 	default:
 		errno = EOPNOTSUPP;
@@ -771,6 +856,34 @@ static int nftnl_tunnel_opt_erspan_set(struct nftnl_tunnel_opt *opt, uint16_t ty
 	return 0;
 }
 
+static int nftnl_tunnel_opt_geneve_set(struct nftnl_tunnel_opt *opt, uint16_t type,
+				       const void *data, uint32_t data_len)
+{
+	switch(type) {
+	case NFTNL_TUNNEL_GENEVE_CLASS:
+		memcpy(&opt->geneve.geneve_class, data, data_len);
+		break;
+	case NFTNL_TUNNEL_GENEVE_TYPE:
+		memcpy(&opt->geneve.type, data, data_len);
+		break;
+	case NFTNL_TUNNEL_GENEVE_DATA:
+		if (data_len > NFTNL_TUNNEL_GENEVE_DATA_MAXLEN) {
+			errno = EINVAL;
+			return -1;
+		}
+		memcpy(&opt->geneve.data, data, data_len);
+		opt->geneve.data_len = data_len;
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
 EXPORT_SYMBOL(nftnl_tunnel_opt_set);
 int nftnl_tunnel_opt_set(struct nftnl_tunnel_opt *opt, uint16_t type,
 			 const void *data, uint32_t data_len)
@@ -780,6 +893,8 @@ int nftnl_tunnel_opt_set(struct nftnl_tunnel_opt *opt, uint16_t type,
 		return nftnl_tunnel_opt_vxlan_set(opt, type, data, data_len);
 	case NFTNL_TUNNEL_TYPE_ERSPAN:
 		return nftnl_tunnel_opt_erspan_set(opt, type, data, data_len);
+	case NFTNL_TUNNEL_TYPE_GENEVE:
+		return nftnl_tunnel_opt_geneve_set(opt, type, data, data_len);
 	default:
 		errno = EOPNOTSUPP;
 		return -1;
@@ -826,6 +941,26 @@ static void nftnl_tunnel_opt_build_erspan(struct nlmsghdr *nlh,
 	}
 }
 
+static void nftnl_tunnel_opt_build_geneve(struct nlmsghdr *nlh,
+					  const struct nftnl_tunnel_opt *opt)
+{
+	struct nlattr *nest_inner;
+
+	if (opt->flags & (1 << NFTNL_TUNNEL_GENEVE_CLASS) &&
+	    opt->flags & (1 << NFTNL_TUNNEL_GENEVE_TYPE) &&
+	    opt->flags & (1 << NFTNL_TUNNEL_GENEVE_DATA)) {
+		nest_inner = mnl_attr_nest_start(nlh, NFTA_TUNNEL_KEY_OPTS_GENEVE);
+		mnl_attr_put_u16(nlh, NFTA_TUNNEL_KEY_GENEVE_CLASS,
+				 htons(opt->geneve.geneve_class));
+		mnl_attr_put_u8(nlh, NFTA_TUNNEL_KEY_GENEVE_TYPE,
+				opt->geneve.type);
+		mnl_attr_put(nlh, NFTA_TUNNEL_KEY_GENEVE_DATA,
+			     opt->geneve.data_len,
+			     opt->geneve.data);
+		mnl_attr_nest_end(nlh, nest_inner);
+	}
+}
+
 void nftnl_tunnel_opts_build(struct nlmsghdr *nlh,
 			     struct nftnl_tunnel_opts *opts)
 {
@@ -842,6 +977,9 @@ void nftnl_tunnel_opts_build(struct nlmsghdr *nlh,
 		case NFTNL_TUNNEL_TYPE_ERSPAN:
 			nftnl_tunnel_opt_build_erspan(nlh, opt);
 			break;
+		case NFTNL_TUNNEL_TYPE_GENEVE:
+			nftnl_tunnel_opt_build_geneve(nlh, opt);
+			break;
 		}
 	}
 	mnl_attr_nest_end(nlh, nest);
-- 
2.50.1

