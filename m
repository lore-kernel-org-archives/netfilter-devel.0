Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A68E12B93
	for <netfilter-devel@vger.kernel.org>; Tue, 27 May 2025 19:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748374511; cv=none; b=QgExMuafjvjei2Wm3RWxEII+ZJWiywP60y8jEIenFJcUiNdJtCtd650Eep79+VifTZWQDQnr79clER8LWSAnfmOqRt7ke8P1GIwNvZL+zdgWaF1/rM6HX9h5ARsNBd/NcM/jFwXtuqDxsT1Dx+e9AaOcZjmSEHS5d4HJUr5Wgks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748374511; c=relaxed/simple;
	bh=7yU+5/hKzGup4S5hKA/uI85HkrYRoUNNhRUKAmu15YQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I86n9yLMpHd2g42QIw/jFdnYDrgFAiCxrh5Qip8bh3IDR7mSkle5nM1fTmB7S1XQVjGRDgOcStWV0LtVCN2SwuHLwcYhs7tGWRsvtTRqQEzNVfUoFGfoxJof+Gbz/EM1srmKXLO2gCKfRcC2Lx/ZvayMNWJNLHuxqpeU5/OB76E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=NCQQtXRT; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=oOhaoqPr; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=NCQQtXRT; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=oOhaoqPr; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="NCQQtXRT";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="oOhaoqPr";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="NCQQtXRT";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="oOhaoqPr"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 933F71F399;
	Tue, 27 May 2025 19:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1748374507; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xeZ9QgSSYIv3ipDqV8fHI32Iasv3cuRDxBDGuKLEAbw=;
	b=NCQQtXRTdePqUS4P5kRxAisxMnFsRWeOGHsVqrFQbftE5Bgav5IimB22Ip9W9B3Q7nwPAU
	+8fghdvfrc3TJSg8I7kgmQ4YMkvnoyHaZ6aSxn+fTKS47a7KIJrACzHKNzKHSSp3xWe2Xw
	hVmYwVGxFqVKnksCC0fm9OdELOkYhgA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1748374507;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xeZ9QgSSYIv3ipDqV8fHI32Iasv3cuRDxBDGuKLEAbw=;
	b=oOhaoqPrypbkE21WtEOHGMlH3Eh0qUtZtlH8Gvenfok8WGxIBVDqWanrvZ4eXB7AgtH7oc
	ssXPGSv3nRIqd/Bw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1748374507; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xeZ9QgSSYIv3ipDqV8fHI32Iasv3cuRDxBDGuKLEAbw=;
	b=NCQQtXRTdePqUS4P5kRxAisxMnFsRWeOGHsVqrFQbftE5Bgav5IimB22Ip9W9B3Q7nwPAU
	+8fghdvfrc3TJSg8I7kgmQ4YMkvnoyHaZ6aSxn+fTKS47a7KIJrACzHKNzKHSSp3xWe2Xw
	hVmYwVGxFqVKnksCC0fm9OdELOkYhgA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1748374507;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xeZ9QgSSYIv3ipDqV8fHI32Iasv3cuRDxBDGuKLEAbw=;
	b=oOhaoqPrypbkE21WtEOHGMlH3Eh0qUtZtlH8Gvenfok8WGxIBVDqWanrvZ4eXB7AgtH7oc
	ssXPGSv3nRIqd/Bw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4DAA91388B;
	Tue, 27 May 2025 19:35:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id UKH5D+sTNmg8FQAAD6G6ig
	(envelope-from <fmancera@suse.de>); Tue, 27 May 2025 19:35:07 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH 2/2 libnftnl v2] tunnel: add support to geneve options
Date: Tue, 27 May 2025 21:34:20 +0200
Message-ID: <20250527193420.9860-2-fmancera@suse.de>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527193420.9860-1-fmancera@suse.de>
References: <20250527193420.9860-1-fmancera@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -6.80
X-Spam-Flag: NO
X-Spamd-Result: default: False [-6.80 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:mid];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Level: 

Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
 include/libnftnl/object.h |   7 ++
 include/obj.h             |   9 +++
 src/libnftnl.map          |   4 +
 src/obj/tunnel.c          | 156 ++++++++++++++++++++++++++++++--------
 src/object.c              |  10 +++
 5 files changed, 156 insertions(+), 30 deletions(-)

diff --git a/include/libnftnl/object.h b/include/libnftnl/object.h
index 9930355..14a42cd 100644
--- a/include/libnftnl/object.h
+++ b/include/libnftnl/object.h
@@ -117,15 +117,19 @@ enum {
 	NFTNL_OBJ_TUNNEL_ERSPAN_V1_INDEX,
 	NFTNL_OBJ_TUNNEL_ERSPAN_V2_HWID,
 	NFTNL_OBJ_TUNNEL_ERSPAN_V2_DIR,
+	NFTNL_OBJ_TUNNEL_GENEVE_OPTS,
 	__NFTNL_OBJ_TUNNEL_MAX,
 };
 
+#define NFTNL_TUNNEL_GENEVE_DATA_MAXLEN	127
+
 enum {
 	NFTNL_OBJ_SECMARK_CTX	= NFTNL_OBJ_BASE,
 	__NFTNL_OBJ_SECMARK_MAX,
 };
 
 struct nftnl_obj;
+struct nftnl_obj_tunnel_geneve;
 
 struct nftnl_obj *nftnl_obj_alloc(void);
 void nftnl_obj_free(const struct nftnl_obj *ne);
@@ -171,6 +175,9 @@ void nftnl_obj_list_del(struct nftnl_obj *t);
 int nftnl_obj_list_foreach(struct nftnl_obj_list *table_list,
 			   int (*cb)(struct nftnl_obj *t, void *data),
 			   void *data);
+int nftnl_obj_tunnel_geneve_opts_foreach(struct nftnl_obj *e,
+					 int (*cb)(struct nftnl_obj_tunnel_geneve *e, void *data),
+					 void *data);
 
 struct nftnl_obj_list_iter;
 struct nftnl_obj_list_iter *nftnl_obj_list_iter_create(struct nftnl_obj_list *l);
diff --git a/include/obj.h b/include/obj.h
index fc78e2a..7c9898e 100644
--- a/include/obj.h
+++ b/include/obj.h
@@ -9,6 +9,14 @@ struct nlattr;
 struct nlmsghdr;
 struct nftnl_obj;
 
+struct nftnl_obj_tunnel_geneve {
+	struct list_head	list;
+	uint16_t		geneve_class;
+	uint8_t			type;
+	uint8_t			data[NFTNL_TUNNEL_GENEVE_DATA_MAXLEN];
+	uint32_t		data_len;
+};
+
 struct nftnl_obj {
 	struct list_head	head;
 	struct obj_ops		*ops;
@@ -92,6 +100,7 @@ struct nftnl_obj {
 						} v2;
 					} u;
 				} tun_erspan;
+				struct list_head	tun_geneve;
 			} u;
 		} tunnel;
 		struct nftnl_obj_secmark {
diff --git a/src/libnftnl.map b/src/libnftnl.map
index 8fffff1..e125017 100644
--- a/src/libnftnl.map
+++ b/src/libnftnl.map
@@ -383,3 +383,7 @@ LIBNFTNL_16 {
 LIBNFTNL_17 {
   nftnl_set_elem_nlmsg_build;
 } LIBNFTNL_16;
+
+LIBNFTNL_18 {
+  nftnl_obj_tunnel_geneve_opts_foreach;
+} LIBNFTNL_17;
diff --git a/src/obj/tunnel.c b/src/obj/tunnel.c
index 8941e39..b8c07b7 100644
--- a/src/obj/tunnel.c
+++ b/src/obj/tunnel.c
@@ -22,6 +22,7 @@ nftnl_obj_tunnel_set(struct nftnl_obj *e, uint16_t type,
 		     const void *data, uint32_t data_len)
 {
 	struct nftnl_obj_tunnel *tun = nftnl_obj_data(e);
+	struct nftnl_obj_tunnel_geneve *geneve;
 
 	switch (type) {
 	case NFTNL_OBJ_TUNNEL_ID:
@@ -72,6 +73,15 @@ nftnl_obj_tunnel_set(struct nftnl_obj *e, uint16_t type,
 	case NFTNL_OBJ_TUNNEL_ERSPAN_V2_DIR:
 		memcpy(&tun->u.tun_erspan.u.v2.dir, data, data_len);
 		break;
+	case NFTNL_OBJ_TUNNEL_GENEVE_OPTS:
+		geneve = malloc(sizeof(struct nftnl_obj_tunnel_geneve));
+		memcpy(geneve, data, data_len);
+
+		if (!(e->flags & (1ULL << NFTNL_OBJ_TUNNEL_GENEVE_OPTS)))
+			INIT_LIST_HEAD(&tun->u.tun_geneve);
+
+		list_add_tail(&geneve->list, &tun->u.tun_geneve);
+		break;
 	}
 	return 0;
 }
@@ -135,6 +145,23 @@ nftnl_obj_tunnel_get(const struct nftnl_obj *e, uint16_t type,
 	return NULL;
 }
 
+EXPORT_SYMBOL(nftnl_obj_tunnel_geneve_opts_foreach);
+int nftnl_obj_tunnel_geneve_opts_foreach(struct nftnl_obj *e,
+					 int (*cb)(struct nftnl_obj_tunnel_geneve *e, void *data),
+					 void *data)
+{
+	struct nftnl_obj_tunnel *tun = nftnl_obj_data(e);
+	struct nftnl_obj_tunnel_geneve *cur, *tmp;
+	int ret;
+
+	list_for_each_entry_safe(cur, tmp, &tun->u.tun_geneve, list) {
+		ret = cb(cur, data);
+		if (ret < 0)
+			return ret;
+	}
+	return 0;
+}
+
 static int nftnl_obj_tunnel_cb(const struct nlattr *attr, void *data)
 {
 	const struct nlattr **tb = data;
@@ -240,6 +267,23 @@ nftnl_obj_tunnel_build(struct nlmsghdr *nlh, const struct nftnl_obj *e)
 		mnl_attr_nest_end(nlh, nest_inner);
 		mnl_attr_nest_end(nlh, nest);
 	}
+	if (e->flags & (1ULL << NFTNL_OBJ_TUNNEL_GENEVE_OPTS)) {
+		struct nftnl_obj_tunnel_geneve *geneve;
+
+		nest = mnl_attr_nest_start(nlh, NFTA_TUNNEL_KEY_OPTS);
+		list_for_each_entry(geneve, &tun->u.tun_geneve, list) {
+			nest_inner = mnl_attr_nest_start(nlh, NFTA_TUNNEL_KEY_OPTS_GENEVE);
+			mnl_attr_put_u16(nlh, NFTA_TUNNEL_KEY_GENEVE_CLASS,
+					 htons(geneve->geneve_class));
+			mnl_attr_put_u8(nlh, NFTA_TUNNEL_KEY_GENEVE_TYPE,
+					geneve->type);
+			mnl_attr_put(nlh, NFTA_TUNNEL_KEY_GENEVE_DATA,
+				     geneve->data_len,
+				     geneve->data);
+			mnl_attr_nest_end(nlh, nest_inner);
+		}
+		mnl_attr_nest_end(nlh, nest);
+	}
 }
 
 static int nftnl_obj_tunnel_ip_cb(const struct nlattr *attr, void *data)
@@ -335,6 +379,72 @@ static int nftnl_obj_tunnel_parse_ip6(struct nftnl_obj *e, struct nlattr *attr,
 	return 0;
 }
 
+static int nftnl_obj_tunnel_geneve_cb(const struct nlattr *attr, void *data)
+{
+	const struct nlattr **tb = data;
+	int type = mnl_attr_get_type(attr);
+
+	if (mnl_attr_type_valid(attr, NFTA_TUNNEL_KEY_GENEVE_MAX) < 0)
+		return MNL_CB_OK;
+
+	switch (type) {
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
+			abi_breakage();
+		break;
+	}
+
+	tb[type] = attr;
+	return MNL_CB_OK;
+}
+
+static int
+nftnl_obj_tunnel_parse_geneve(struct nftnl_obj *e, struct nlattr *attr,
+			      struct nftnl_obj_tunnel *tun)
+{
+	struct nlattr *tb[NFTA_TUNNEL_KEY_GENEVE_MAX + 1] = {};
+	struct nftnl_obj_tunnel_geneve *geneve;
+
+	if (mnl_attr_parse_nested(attr, nftnl_obj_tunnel_geneve_cb, tb) < 0)
+		return -1;
+
+	geneve = malloc(sizeof(struct nftnl_obj_tunnel_geneve));
+
+	if (!(e->flags & (1ULL << NFTNL_OBJ_TUNNEL_GENEVE_OPTS))) {
+		INIT_LIST_HEAD(&tun->u.tun_geneve);
+		e->flags |= (1ULL << NFTNL_OBJ_TUNNEL_GENEVE_OPTS);
+	}
+
+	if (tb[NFTA_TUNNEL_KEY_GENEVE_CLASS])
+		geneve->geneve_class =
+			ntohs(mnl_attr_get_u16(tb[NFTA_TUNNEL_KEY_GENEVE_CLASS]));
+
+	if (tb[NFTA_TUNNEL_KEY_GENEVE_TYPE])
+		geneve->type =
+			mnl_attr_get_u8(tb[NFTA_TUNNEL_KEY_GENEVE_TYPE]);
+
+	if (tb[NFTA_TUNNEL_KEY_GENEVE_DATA]) {
+		uint32_t len = mnl_attr_get_payload_len(tb[NFTA_TUNNEL_KEY_GENEVE_DATA]);
+
+		memcpy(geneve->data,
+		       mnl_attr_get_payload(tb[NFTA_TUNNEL_KEY_GENEVE_DATA]),
+		       len);
+		geneve->data_len = len;
+	}
+
+	list_add_tail(&geneve->list, &tun->u.tun_geneve);
+
+	return 0;
+}
+
 static int nftnl_obj_tunnel_vxlan_cb(const struct nlattr *attr, void *data)
 {
 	const struct nlattr **tb = data;
@@ -430,42 +540,28 @@ nftnl_obj_tunnel_parse_erspan(struct nftnl_obj *e, struct nlattr *attr,
 	return 0;
 }
 
-static int nftnl_obj_tunnel_opts_cb(const struct nlattr *attr, void *data)
-{
-	const struct nlattr **tb = data;
-	int type = mnl_attr_get_type(attr);
-
-	if (mnl_attr_type_valid(attr, NFTA_TUNNEL_KEY_OPTS_MAX) < 0)
-		return MNL_CB_OK;
-
-	switch (type) {
-	case NFTA_TUNNEL_KEY_OPTS_VXLAN:
-	case NFTA_TUNNEL_KEY_OPTS_ERSPAN:
-		if (mnl_attr_validate(attr, MNL_TYPE_NESTED) < 0)
-			abi_breakage();
-		break;
-	}
-
-	tb[type] = attr;
-	return MNL_CB_OK;
-}
-
 static int
-nftnl_obj_tunnel_parse_opts(struct nftnl_obj *e, struct nlattr *attr,
+nftnl_obj_tunnel_parse_opts(struct nftnl_obj *e, struct nlattr *nest,
 			    struct nftnl_obj_tunnel *tun)
 {
-	struct nlattr *tb[NFTA_TUNNEL_KEY_OPTS_MAX + 1] = {};
+	struct nlattr *attr;
 	int err = 0;
 
-	if (mnl_attr_parse_nested(attr, nftnl_obj_tunnel_opts_cb, tb) < 0)
-		return -1;
+	mnl_attr_for_each_nested(attr, nest) {
+		if (mnl_attr_validate(attr, MNL_TYPE_NESTED) < 0)
+			abi_breakage();
 
-	if (tb[NFTA_TUNNEL_KEY_OPTS_VXLAN]) {
-		err = nftnl_obj_tunnel_parse_vxlan(e, tb[NFTA_TUNNEL_KEY_OPTS_VXLAN],
-						   tun);
-	} else if (tb[NFTA_TUNNEL_KEY_OPTS_ERSPAN]) {
-		err = nftnl_obj_tunnel_parse_erspan(e, tb[NFTA_TUNNEL_KEY_OPTS_ERSPAN],
-						    tun);
+		switch (mnl_attr_get_type(attr)) {
+			case NFTA_TUNNEL_KEY_OPTS_VXLAN:
+				err = nftnl_obj_tunnel_parse_vxlan(e, attr, tun);
+				break;
+			case NFTA_TUNNEL_KEY_OPTS_ERSPAN:
+				err = nftnl_obj_tunnel_parse_erspan(e, attr, tun);
+				break;
+			case NFTA_TUNNEL_KEY_OPTS_GENEVE:
+				err = nftnl_obj_tunnel_parse_geneve(e, attr, tun);
+				break;
+		}
 	}
 
 	return err;
diff --git a/src/object.c b/src/object.c
index f307815..b5bdbbf 100644
--- a/src/object.c
+++ b/src/object.c
@@ -49,12 +49,22 @@ struct nftnl_obj *nftnl_obj_alloc(void)
 EXPORT_SYMBOL(nftnl_obj_free);
 void nftnl_obj_free(const struct nftnl_obj *obj)
 {
+	struct nftnl_obj_tunnel_geneve *geneve, *next;
+
 	if (obj->flags & (1 << NFTNL_OBJ_TABLE))
 		xfree(obj->table);
 	if (obj->flags & (1 << NFTNL_OBJ_NAME))
 		xfree(obj->name);
 	if (obj->flags & (1 << NFTNL_OBJ_USERDATA))
 		xfree(obj->user.data);
+	if (obj->flags & (1ULL << NFTNL_OBJ_TUNNEL_GENEVE_OPTS)) {
+		list_for_each_entry_safe(geneve, next,
+					 &obj->data.tunnel.u.tun_geneve,
+					 list) {
+			list_del(&geneve->list);
+			xfree(geneve);
+		}
+	}
 
 	xfree(obj);
 }
-- 
2.49.0

