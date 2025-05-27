Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B34001E5B7E
	for <netfilter-devel@vger.kernel.org>; Tue, 27 May 2025 19:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748375727; cv=none; b=tY1JVIX1r0AgK+MglN3j4TeiHOd2prDwjcIafgsMRj2s7rEsi15zR/flOgNOgn5e6seS6hpswbcQLuScklu5XhYMcUn8rDob0RZuF1M3oZ2msnxx3YORID1ynpKDpwJ7jdMoN7/h2IM44sQPhrV1DDTWDNpTZu+QBTV0tO/jOU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748375727; c=relaxed/simple;
	bh=pYCkif7HpzjvojG2x7S+sncTNFZbYQdbL/Ilij8+rb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dEEjTj5X7lrz+yffoDq+80m9EBfXHJAz/0674KK9MzLo48loi/JRwHtcoLLW5rFET/UItEBfIRChgvIen7h1cgmkzn9BRlvPngMF0pqFCbaweY4hMtQcB67bChQmvan64/VK+r+kLtIB/I0eARaQNkcn6bD89J8+c+b/ZU1RXEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=IckT9o2Y; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=/zjVAOoc; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=IckT9o2Y; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=/zjVAOoc; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="IckT9o2Y";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="/zjVAOoc";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="IckT9o2Y";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="/zjVAOoc"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 949632118D;
	Tue, 27 May 2025 19:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1748375722; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FkP0+Li8mq95zzj69dheVovDGsa4aD582+TlHl35tAU=;
	b=IckT9o2YA6U1UasodllyAAM89n3391U5ByEpBscObYIKUja2Qqqll6HU2EsPFef2C0EHEv
	dc1s4TxX7q5fAOfr1qb2/RTU2k76dYnAowQEg8zO2Id1z+r8mZb9MOerlDOrqiK5JVhYwn
	GRT62SSQWRJ585/4cCnulIsILq2haaE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1748375722;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FkP0+Li8mq95zzj69dheVovDGsa4aD582+TlHl35tAU=;
	b=/zjVAOocGpDyy5YVXmzrcOZtWYbaH/p9yEq5lGnzrjBMF3jkhk1vlegFOJc0NZaP7Xq56c
	UedbCDDLzXqP6HAA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=IckT9o2Y;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="/zjVAOoc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1748375722; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FkP0+Li8mq95zzj69dheVovDGsa4aD582+TlHl35tAU=;
	b=IckT9o2YA6U1UasodllyAAM89n3391U5ByEpBscObYIKUja2Qqqll6HU2EsPFef2C0EHEv
	dc1s4TxX7q5fAOfr1qb2/RTU2k76dYnAowQEg8zO2Id1z+r8mZb9MOerlDOrqiK5JVhYwn
	GRT62SSQWRJ585/4cCnulIsILq2haaE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1748375722;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FkP0+Li8mq95zzj69dheVovDGsa4aD582+TlHl35tAU=;
	b=/zjVAOocGpDyy5YVXmzrcOZtWYbaH/p9yEq5lGnzrjBMF3jkhk1vlegFOJc0NZaP7Xq56c
	UedbCDDLzXqP6HAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 47D08136E0;
	Tue, 27 May 2025 19:55:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id IP9KDqoYNmhJGgAAD6G6ig
	(envelope-from <fmancera@suse.de>); Tue, 27 May 2025 19:55:22 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/7 nft] src: add tunnel template support
Date: Tue, 27 May 2025 21:54:38 +0200
Message-ID: <6a6bd36db43a444ca12bdcb46977d2361f914a9d.1748374810.git.fmancera@suse.de>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1748374810.git.fmancera@suse.de>
References: <cover.1748374810.git.fmancera@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	ASN(0.00)[asn:25478, ipnet:::/0, country:RU];
	RCVD_COUNT_TWO(0.00)[2];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:dkim,suse.de:mid];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Queue-Id: 949632118D
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 

From: Pablo Neira Ayuso <pablo@netfilter.org>

This patch adds tunnel template support, this allows to attach a
metadata template that provides the configuration for the tunnel driver.

Example of generic tunnel configuration:

 table netdev x {
        tunnel y {
                id 10
                ip saddr 192.168.2.10
                ip daddr 192.168.2.11
                sport 10
                dport 20
                ttl 10
        }
 }

Joint work with Fernando.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/parser.h   |  1 +
 include/rule.h     | 13 +++++++
 src/cache.c        |  2 +
 src/evaluate.c     | 23 ++++++++++++
 src/json.c         |  7 ++++
 src/mnl.c          | 40 ++++++++++++++++++++
 src/netlink.c      | 81 ++++++++++++++++++++++++++++++++++++++++
 src/parser_bison.y | 92 ++++++++++++++++++++++++++++++++++++++++++++--
 src/parser_json.c  |  8 ++++
 src/rule.c         | 74 ++++++++++++++++++++++++++++++++++++-
 src/scanner.l      | 12 ++++++
 11 files changed, 349 insertions(+), 4 deletions(-)

diff --git a/include/parser.h b/include/parser.h
index 576e5e43..8cfd22e9 100644
--- a/include/parser.h
+++ b/include/parser.h
@@ -51,6 +51,7 @@ enum startcond_type {
 	PARSER_SC_SECMARK,
 	PARSER_SC_TCP,
 	PARSER_SC_TYPE,
+	PARSER_SC_TUNNEL,
 	PARSER_SC_VLAN,
 	PARSER_SC_XT,
 	PARSER_SC_CMD_DESTROY,
diff --git a/include/rule.h b/include/rule.h
index 85a0d9c0..c10db949 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -490,6 +490,16 @@ struct secmark {
 	char		ctx[NFT_SECMARK_CTX_MAXLEN];
 };
 
+struct tunnel {
+	uint32_t	id;
+	struct expr	*src;
+	struct expr	*dst;
+	uint16_t	sport;
+	uint16_t	dport;
+	uint8_t		tos;
+	uint8_t		ttl;
+};
+
 /**
  * struct obj - nftables stateful object statement
  *
@@ -516,6 +526,7 @@ struct obj {
 		struct secmark		secmark;
 		struct ct_expect	ct_expect;
 		struct synproxy		synproxy;
+		struct tunnel		tunnel;
 	};
 };
 
@@ -662,6 +673,8 @@ enum cmd_obj {
 	CMD_OBJ_CT_EXPECTATIONS,
 	CMD_OBJ_SYNPROXY,
 	CMD_OBJ_SYNPROXYS,
+	CMD_OBJ_TUNNEL,
+	CMD_OBJ_TUNNELS,
 	CMD_OBJ_HOOKS,
 };
 
diff --git a/src/cache.c b/src/cache.c
index 3ac819cf..b3984a24 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -443,6 +443,8 @@ static int nft_handle_validate(const struct cmd *cmd, struct list_head *msgs)
 	case CMD_OBJ_CT_TIMEOUTS:
 	case CMD_OBJ_CT_EXPECT:
 	case CMD_OBJ_CT_EXPECTATIONS:
+	case CMD_OBJ_TUNNEL:
+	case CMD_OBJ_TUNNELS:
 		if (h->table.name &&
 		    strlen(h->table.name) > NFT_NAME_MAXLEN) {
 			loc = &h->table.location;
diff --git a/src/evaluate.c b/src/evaluate.c
index 9c7f23cb..84c150d8 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -5640,6 +5640,26 @@ static int ct_timeout_evaluate(struct eval_ctx *ctx, struct obj *obj)
 	return 0;
 }
 
+static int tunnel_evaluate(struct eval_ctx *ctx, struct obj *obj)
+{
+	if (obj->tunnel.src != NULL) {
+		__expr_set_context(&ctx->ectx, &ipaddr_type,
+				   BYTEORDER_BIG_ENDIAN,
+				   sizeof(struct in_addr) * BITS_PER_BYTE, 0);
+		if (expr_evaluate(ctx, &obj->tunnel.src) < 0)
+			return -1;
+	}
+	if (obj->tunnel.dst != NULL) {
+		__expr_set_context(&ctx->ectx, &ipaddr_type,
+				   BYTEORDER_BIG_ENDIAN,
+				   sizeof(struct in_addr) * BITS_PER_BYTE, 0);
+		if (expr_evaluate(ctx, &obj->tunnel.dst) < 0)
+			return -1;
+	}
+
+	return 0;
+}
+
 static int obj_evaluate(struct eval_ctx *ctx, struct obj *obj)
 {
 	struct table *table;
@@ -5658,6 +5678,8 @@ static int obj_evaluate(struct eval_ctx *ctx, struct obj *obj)
 		return ct_timeout_evaluate(ctx, obj);
 	case NFT_OBJECT_CT_EXPECT:
 		return ct_expect_evaluate(ctx, obj);
+	case NFT_OBJECT_TUNNEL:
+		return tunnel_evaluate(ctx, obj);
 	default:
 		break;
 	}
@@ -5710,6 +5732,7 @@ static int cmd_evaluate_add(struct eval_ctx *ctx, struct cmd *cmd)
 	case CMD_OBJ_SECMARK:
 	case CMD_OBJ_CT_EXPECT:
 	case CMD_OBJ_SYNPROXY:
+	case CMD_OBJ_TUNNEL:
 		handle_merge(&cmd->object->handle, &cmd->handle);
 		return obj_evaluate(ctx, cmd->object);
 	default:
diff --git a/src/json.c b/src/json.c
index cbed9ce9..a8fc10c4 100644
--- a/src/json.c
+++ b/src/json.c
@@ -468,6 +468,9 @@ static json_t *obj_print_json(const struct obj *obj)
 		json_object_update(root, tmp);
 		json_decref(tmp);
 		break;
+	case NFT_OBJECT_TUNNEL:
+		/* TODO */
+		break;
 	}
 
 	return json_pack("{s:o}", type, root);
@@ -1997,6 +2000,10 @@ int do_command_list_json(struct netlink_ctx *ctx, struct cmd *cmd)
 	case CMD_OBJ_SYNPROXYS:
 		root = do_list_obj_json(ctx, cmd, NFT_OBJECT_SYNPROXY);
 		break;
+	case CMD_OBJ_TUNNEL:
+	case CMD_OBJ_TUNNELS:
+		root = do_list_obj_json(ctx, cmd, NFT_OBJECT_TUNNEL);
+		break;
 	case CMD_OBJ_FLOWTABLE:
 		root = do_list_flowtable_json(ctx, cmd, table);
 		break;
diff --git a/src/mnl.c b/src/mnl.c
index 64b1aaed..ee46892e 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -1453,6 +1453,7 @@ int mnl_nft_obj_add(struct netlink_ctx *ctx, struct cmd *cmd,
 		    unsigned int flags)
 {
 	struct obj *obj = cmd->object;
+	struct nft_data_linearize nld;
 	struct nftnl_udata_buf *udbuf;
 	struct nftnl_obj *nlo;
 	struct nlmsghdr *nlh;
@@ -1541,6 +1542,45 @@ int mnl_nft_obj_add(struct netlink_ctx *ctx, struct cmd *cmd,
 		nftnl_obj_set_u32(nlo, NFTNL_OBJ_SYNPROXY_FLAGS,
 				  obj->synproxy.flags);
 		break;
+	case NFT_OBJECT_TUNNEL:
+		nftnl_obj_set_u32(nlo, NFTNL_OBJ_TUNNEL_ID, obj->tunnel.id);
+		if (obj->tunnel.sport)
+			nftnl_obj_set_u16(nlo, NFTNL_OBJ_TUNNEL_SPORT,
+					  obj->tunnel.sport);
+		if (obj->tunnel.dport)
+			nftnl_obj_set_u16(nlo, NFTNL_OBJ_TUNNEL_DPORT,
+					  obj->tunnel.dport);
+		if (obj->tunnel.tos)
+			nftnl_obj_set_u8(nlo, NFTNL_OBJ_TUNNEL_TOS,
+					  obj->tunnel.tos);
+		if (obj->tunnel.ttl)
+			nftnl_obj_set_u8(nlo, NFTNL_OBJ_TUNNEL_TTL,
+					  obj->tunnel.ttl);
+		if (obj->tunnel.src) {
+			netlink_gen_data(obj->tunnel.src, &nld);
+			if (nld.len == sizeof(struct in_addr)) {
+				nftnl_obj_set_u32(nlo,
+						  NFTNL_OBJ_TUNNEL_IPV4_SRC,
+						  nld.value[0]);
+			} else {
+				nftnl_obj_set_data(nlo,
+						   NFTNL_OBJ_TUNNEL_IPV6_SRC,
+						   nld.value, nld.len);
+			}
+		}
+		if (obj->tunnel.dst) {
+			netlink_gen_data(obj->tunnel.dst, &nld);
+			if (nld.len == sizeof(struct in_addr)) {
+				nftnl_obj_set_u32(nlo,
+						  NFTNL_OBJ_TUNNEL_IPV4_DST,
+						  nld.value[0]);
+		        } else {
+				nftnl_obj_set_data(nlo,
+						   NFTNL_OBJ_TUNNEL_IPV6_DST,
+						   nld.value, nld.len);
+			}
+		}
+		break;
 	default:
 		BUG("Unknown type %d\n", obj->type);
 		break;
diff --git a/src/netlink.c b/src/netlink.c
index bed816af..ccf43580 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1692,6 +1692,51 @@ void netlink_dump_obj(struct nftnl_obj *nln, struct netlink_ctx *ctx)
 	fprintf(fp, "\n");
 }
 
+static struct in6_addr all_zeroes;
+
+static struct expr *
+netlink_obj_tunnel_parse_addr(struct nftnl_obj *nlo, int attr)
+{
+	struct nft_data_delinearize nld;
+	const struct datatype *dtype;
+	const uint32_t *addr6;
+	struct expr *expr;
+	uint32_t addr;
+
+	memset(&nld, 0, sizeof(nld));
+
+	switch (attr) {
+	case NFTNL_OBJ_TUNNEL_IPV4_SRC:
+	case NFTNL_OBJ_TUNNEL_IPV4_DST:
+		addr = nftnl_obj_get_u32(nlo, attr);
+		if (!addr)
+			return NULL;
+
+		dtype = &ipaddr_type;
+		nld.value = &addr;
+		nld.len = sizeof(struct in_addr);
+		break;
+	case NFTNL_OBJ_TUNNEL_IPV6_SRC:
+	case NFTNL_OBJ_TUNNEL_IPV6_DST:
+		addr6 = nftnl_obj_get(nlo, attr);
+		if (!memcmp(addr6, &all_zeroes, sizeof(all_zeroes)))
+			return NULL;
+
+		dtype = &ip6addr_type;
+		nld.value = addr6;
+		nld.len = sizeof(struct in6_addr);
+		break;
+	default:
+		return NULL;
+	}
+
+	expr = netlink_alloc_value(&netlink_location, &nld);
+	expr->dtype     = dtype;
+	expr->byteorder = BYTEORDER_BIG_ENDIAN;
+
+	return expr;
+}
+
 static int obj_parse_udata_cb(const struct nftnl_udata *attr, void *data)
 {
 	unsigned char *value = nftnl_udata_get(attr);
@@ -1805,6 +1850,42 @@ struct obj *netlink_delinearize_obj(struct netlink_ctx *ctx,
 		obj->synproxy.flags =
 			nftnl_obj_get_u32(nlo, NFTNL_OBJ_SYNPROXY_FLAGS);
 		break;
+	case NFT_OBJECT_TUNNEL:
+		if (nftnl_obj_is_set(nlo, NFTNL_OBJ_TUNNEL_ID))
+			obj->tunnel.id = nftnl_obj_get_u32(nlo, NFTNL_OBJ_TUNNEL_ID);
+		if (nftnl_obj_is_set(nlo, NFTNL_OBJ_TUNNEL_SPORT)) {
+			obj->tunnel.sport =
+				nftnl_obj_get_u16(nlo, NFTNL_OBJ_TUNNEL_SPORT);
+		}
+		if (nftnl_obj_is_set(nlo, NFTNL_OBJ_TUNNEL_DPORT)) {
+			obj->tunnel.dport =
+				nftnl_obj_get_u16(nlo, NFTNL_OBJ_TUNNEL_DPORT);
+		}
+		if (nftnl_obj_is_set(nlo, NFTNL_OBJ_TUNNEL_TOS)) {
+			obj->tunnel.tos =
+				nftnl_obj_get_u8(nlo, NFTNL_OBJ_TUNNEL_TOS);
+		}
+		if (nftnl_obj_is_set(nlo, NFTNL_OBJ_TUNNEL_TTL)) {
+			obj->tunnel.ttl =
+				nftnl_obj_get_u8(nlo, NFTNL_OBJ_TUNNEL_TTL);
+		}
+		if (nftnl_obj_is_set(nlo, NFTNL_OBJ_TUNNEL_IPV4_SRC)) {
+			obj->tunnel.src =
+				netlink_obj_tunnel_parse_addr(nlo, NFTNL_OBJ_TUNNEL_IPV4_SRC);
+		}
+		if (nftnl_obj_is_set(nlo, NFTNL_OBJ_TUNNEL_IPV4_DST)) {
+			obj->tunnel.dst =
+				netlink_obj_tunnel_parse_addr(nlo, NFTNL_OBJ_TUNNEL_IPV4_DST);
+		}
+		if (nftnl_obj_is_set(nlo, NFTNL_OBJ_TUNNEL_IPV6_SRC)) {
+			obj->tunnel.src =
+				netlink_obj_tunnel_parse_addr(nlo, NFTNL_OBJ_TUNNEL_IPV6_SRC);
+		}
+		if (nftnl_obj_is_set(nlo, NFTNL_OBJ_TUNNEL_IPV6_DST)) {
+			obj->tunnel.dst =
+				netlink_obj_tunnel_parse_addr(nlo, NFTNL_OBJ_TUNNEL_IPV6_DST);
+		}
+		break;
 	default:
 		netlink_io_error(ctx, NULL, "Unknown object type %u", type);
 		obj_free(obj);
diff --git a/src/parser_bison.y b/src/parser_bison.y
index ed6a24a1..c4694c77 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -410,6 +410,7 @@ int nft_lex(void *, void *, void *);
 %token LENGTH			"length"
 %token FRAG_OFF			"frag-off"
 %token TTL			"ttl"
+%token TOS			"tos"
 %token PROTOCOL			"protocol"
 %token CHECKSUM			"checksum"
 
@@ -604,9 +605,12 @@ int nft_lex(void *, void *, void *);
 %token LAST			"last"
 %token NEVER			"never"
 
+%token TUNNEL			"tunnel"
+
 %token COUNTERS			"counters"
 %token QUOTAS			"quotas"
 %token LIMITS			"limits"
+%token TUNNELS			"tunnels"
 %token SYNPROXYS		"synproxys"
 %token HELPERS			"helpers"
 
@@ -760,7 +764,7 @@ int nft_lex(void *, void *, void *);
 %type <flowtable>		flowtable_block_alloc flowtable_block
 %destructor { flowtable_free($$); }	flowtable_block_alloc
 
-%type <obj>			obj_block_alloc counter_block quota_block ct_helper_block ct_timeout_block ct_expect_block limit_block secmark_block synproxy_block
+%type <obj>			obj_block_alloc counter_block quota_block ct_helper_block ct_timeout_block ct_expect_block limit_block secmark_block synproxy_block tunnel_block
 %destructor { obj_free($$); }	obj_block_alloc
 
 %type <list>			stmt_list stateful_stmt_list set_elem_stmt_list
@@ -879,8 +883,8 @@ int nft_lex(void *, void *, void *);
 %type <expr>			and_rhs_expr exclusive_or_rhs_expr inclusive_or_rhs_expr
 %destructor { expr_free($$); }	and_rhs_expr exclusive_or_rhs_expr inclusive_or_rhs_expr
 
-%type <obj>			counter_obj quota_obj ct_obj_alloc limit_obj secmark_obj synproxy_obj
-%destructor { obj_free($$); }	counter_obj quota_obj ct_obj_alloc limit_obj secmark_obj synproxy_obj
+%type <obj>			counter_obj quota_obj ct_obj_alloc limit_obj secmark_obj synproxy_obj tunnel_obj
+%destructor { obj_free($$); }	counter_obj quota_obj ct_obj_alloc limit_obj secmark_obj synproxy_obj tunnel_obj
 
 %type <expr>			relational_expr
 %destructor { expr_free($$); }	relational_expr
@@ -1083,6 +1087,7 @@ close_scope_udplite	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_UDPL
 
 close_scope_log		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_STMT_LOG); }
 close_scope_synproxy	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_STMT_SYNPROXY); }
+close_scope_tunnel	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_TUNNEL); }
 close_scope_xt		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_XT); }
 
 common_block		:	INCLUDE		QUOTED_STRING	stmt_separator
@@ -1299,6 +1304,10 @@ add_cmd			:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_ADD, CMD_OBJ_SYNPROXY, &$2, &@$, $3);
 			}
+			|	TUNNEL		obj_spec	tunnel_obj	'{' tunnel_block '}' close_scope_tunnel
+			{
+				$$ = cmd_alloc(CMD_ADD, CMD_OBJ_TUNNEL, &$2, &@$, $3);
+			}
 			;
 
 replace_cmd		:	RULE		ruleid_spec	rule
@@ -1402,6 +1411,10 @@ create_cmd		:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_CREATE, CMD_OBJ_SYNPROXY, &$2, &@$, $3);
 			}
+			|	TUNNEL		obj_spec	tunnel_obj	'{' tunnel_block '}'	close_scope_tunnel
+			{
+				$$ = cmd_alloc(CMD_CREATE, CMD_OBJ_TUNNEL, &$2, &@$, $3);
+			}
 			;
 
 insert_cmd		:	RULE		rule_position	rule
@@ -1499,6 +1512,10 @@ delete_cmd		:	TABLE		table_or_id_spec
 			{
 				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_SYNPROXY, &$2, &@$, NULL);
 			}
+			|	TUNNEL		obj_or_id_spec	close_scope_tunnel
+			{
+				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_TUNNEL, &$2, &@$, NULL);
+			}
 			;
 
 destroy_cmd		:	TABLE		table_or_id_spec
@@ -1566,6 +1583,10 @@ destroy_cmd		:	TABLE		table_or_id_spec
 			{
 				$$ = cmd_alloc(CMD_DESTROY, CMD_OBJ_SYNPROXY, &$2, &@$, NULL);
 			}
+			|	TUNNEL		obj_or_id_spec	close_scope_tunnel
+			{
+				$$ = cmd_alloc(CMD_DESTROY, CMD_OBJ_TUNNEL, &$2, &@$, NULL);
+			}
 			;
 
 
@@ -2045,6 +2066,17 @@ table_block		:	/* empty */	{ $$ = $<table>-1; }
 				list_add_tail(&$4->list, &$1->objs);
 				$$ = $1;
 			}
+			|	table_block	TUNNEL	obj_identifier
+					obj_block_alloc '{'     tunnel_block     '}'
+					stmt_separator close_scope_tunnel
+			{
+				$4->location = @3;
+				$4->type = NFT_OBJECT_TUNNEL;
+				handle_merge(&$4->handle, &$3);
+				handle_free(&$3);
+				list_add_tail(&$4->list, &$1->objs);
+				$$ = $1;
+			}
 			;
 
 chain_block_alloc	:	/* empty */
@@ -4916,6 +4948,60 @@ limit_obj		:	/* empty */
 			}
 			;
 
+tunnel_config		:	ID	NUM
+			{
+				$<obj>0->tunnel.id = $2;
+			}
+			|	IP	SADDR	expr	close_scope_ip
+			{
+				$<obj>0->tunnel.src = $3;
+			}
+			|	IP	DADDR	expr	close_scope_ip
+			{
+				$<obj>0->tunnel.dst = $3;
+			}
+			|	SPORT	NUM
+			{
+				$<obj>0->tunnel.sport = $2;
+			}
+			|	DPORT	NUM
+			{
+				$<obj>0->tunnel.dport = $2;
+			}
+			|	TTL	NUM
+			{
+				$<obj>0->tunnel.ttl = $2;
+			}
+			|	TOS	NUM
+			{
+				$<obj>0->tunnel.tos = $2;
+			}
+			;
+
+tunnel_block		:	/* empty */	{ $$ = $<obj>-1; }
+			|       tunnel_block     common_block
+			|       tunnel_block     stmt_separator
+			|       tunnel_block     tunnel_config	stmt_separator
+			{
+				$$ = $1;
+			}
+			|       tunnel_block     comment_spec
+			{
+				if (already_set($<obj>1->comment, &@2, state)) {
+					free_const($2);
+					YYERROR;
+				}
+				$<obj>1->comment = $2;
+			}
+			;
+
+tunnel_obj		:	/* empty */
+			{
+				$$ = obj_alloc(&@$);
+				$$->type = NFT_OBJECT_TUNNEL;
+			}
+			;
+
 relational_expr		:	expr	/* implicit */	rhs_expr
 			{
 				$$ = relational_expr_alloc(&@$, OP_IMPLICIT, $1, $2);
diff --git a/src/parser_json.c b/src/parser_json.c
index e3dd14cd..c1bd7570 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -3161,6 +3161,7 @@ static int string_to_nft_object(const char *str)
 		[NFT_OBJECT_SECMARK]	= "secmark",
 		[NFT_OBJECT_CT_EXPECT]	= "ct expectation",
 		[NFT_OBJECT_SYNPROXY]	= "synproxy",
+		[NFT_OBJECT_TUNNEL]	= "tunnel",
 	};
 	unsigned int i;
 
@@ -3661,6 +3662,9 @@ static struct cmd *json_parse_cmd_add_object(struct json_ctx *ctx,
 
 		obj->synproxy.flags |= flags;
 		break;
+	case CMD_OBJ_TUNNEL:
+		/* TODO */
+		break;
 	default:
 		BUG("Invalid CMD '%d'", cmd_obj);
 	}
@@ -3697,6 +3701,7 @@ static struct cmd *json_parse_cmd_add(struct json_ctx *ctx,
 		{ "ct helper", NFT_OBJECT_CT_HELPER, json_parse_cmd_add_object },
 		{ "ct timeout", NFT_OBJECT_CT_TIMEOUT, json_parse_cmd_add_object },
 		{ "ct expectation", NFT_OBJECT_CT_EXPECT, json_parse_cmd_add_object },
+		{ "tunnel", NFT_OBJECT_TUNNEL, json_parse_cmd_add_object },
 		{ "limit", CMD_OBJ_LIMIT, json_parse_cmd_add_object },
 		{ "secmark", CMD_OBJ_SECMARK, json_parse_cmd_add_object },
 		{ "synproxy", CMD_OBJ_SYNPROXY, json_parse_cmd_add_object }
@@ -3832,6 +3837,7 @@ static struct cmd *json_parse_cmd_list_multiple(struct json_ctx *ctx,
 	case CMD_OBJ_SETS:
 	case CMD_OBJ_COUNTERS:
 	case CMD_OBJ_CT_HELPERS:
+	case CMD_OBJ_TUNNELS:
 		if (!json_unpack(root, "{s:s}", "table", &tmp))
 			h.table.name = xstrdup(tmp);
 		break;
@@ -3870,6 +3876,8 @@ static struct cmd *json_parse_cmd_list(struct json_ctx *ctx,
 		{ "ct helpers", CMD_OBJ_CT_HELPERS, json_parse_cmd_list_multiple },
 		{ "ct timeout", NFT_OBJECT_CT_TIMEOUT, json_parse_cmd_add_object },
 		{ "ct expectation", NFT_OBJECT_CT_EXPECT, json_parse_cmd_add_object },
+		{ "tunnel", NFT_OBJECT_TUNNEL, json_parse_cmd_add_object },
+		{ "tunnels", CMD_OBJ_TUNNELS, json_parse_cmd_list_multiple },
 		{ "limit", CMD_OBJ_LIMIT, json_parse_cmd_add_object },
 		{ "limits", CMD_OBJ_LIMIT, json_parse_cmd_list_multiple },
 		{ "ruleset", CMD_OBJ_RULESET, json_parse_cmd_list_multiple },
diff --git a/src/rule.c b/src/rule.c
index 80315837..1cea0d48 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1426,6 +1426,7 @@ void cmd_free(struct cmd *cmd)
 		case CMD_OBJ_LIMIT:
 		case CMD_OBJ_SECMARK:
 		case CMD_OBJ_SYNPROXY:
+		case CMD_OBJ_TUNNEL:
 			obj_free(cmd->object);
 			break;
 		case CMD_OBJ_FLOWTABLE:
@@ -1526,6 +1527,7 @@ static int do_command_add(struct netlink_ctx *ctx, struct cmd *cmd, bool excl)
 	case CMD_OBJ_LIMIT:
 	case CMD_OBJ_SECMARK:
 	case CMD_OBJ_SYNPROXY:
+	case CMD_OBJ_TUNNEL:
 		return mnl_nft_obj_add(ctx, cmd, flags);
 	case CMD_OBJ_FLOWTABLE:
 		return mnl_nft_flowtable_add(ctx, cmd, flags);
@@ -1606,6 +1608,8 @@ static int do_command_delete(struct netlink_ctx *ctx, struct cmd *cmd)
 		return mnl_nft_obj_del(ctx, cmd, NFT_OBJECT_SECMARK);
 	case CMD_OBJ_SYNPROXY:
 		return mnl_nft_obj_del(ctx, cmd, NFT_OBJECT_SYNPROXY);
+	case CMD_OBJ_TUNNEL:
+		return mnl_nft_obj_del(ctx, cmd, NFT_OBJECT_TUNNEL);
 	case CMD_OBJ_FLOWTABLE:
 		return mnl_nft_flowtable_del(ctx, cmd);
 	default:
@@ -1676,7 +1680,8 @@ void obj_free(struct obj *obj)
 		return;
 	free_const(obj->comment);
 	handle_free(&obj->handle);
-	if (obj->type == NFT_OBJECT_CT_TIMEOUT) {
+	switch (obj->type) {
+	case NFT_OBJECT_CT_TIMEOUT: {
 		struct timeout_state *ts, *next;
 
 		list_for_each_entry_safe(ts, next, &obj->ct_timeout.timeout_list, head) {
@@ -1684,6 +1689,14 @@ void obj_free(struct obj *obj)
 			free_const(ts->timeout_str);
 			free(ts);
 		}
+		}
+		break;
+	case NFT_OBJECT_TUNNEL:
+		expr_free(obj->tunnel.src);
+		expr_free(obj->tunnel.dst);
+		break;
+	default:
+		break;
 	}
 	free(obj);
 }
@@ -1940,6 +1953,60 @@ static void obj_print_data(const struct obj *obj,
 		nft_print(octx, "%s", opts->stmt_separator);
 		}
 		break;
+	case NFT_OBJECT_TUNNEL:
+		nft_print(octx, " %s {", obj->handle.obj.name);
+		if (nft_output_handle(octx))
+			nft_print(octx, " # handle %" PRIu64, obj->handle.handle.id);
+
+		obj_print_comment(obj, opts, octx);
+
+		nft_print(octx, "%s%s%sid %u",
+			  opts->nl, opts->tab, opts->tab, obj->tunnel.id);
+
+		if (obj->tunnel.src) {
+			if (obj->tunnel.src->len == 32) {
+				nft_print(octx, "%s%s%sip saddr ",
+					  opts->nl, opts->tab, opts->tab);
+				expr_print(obj->tunnel.src, octx);
+			} else if (obj->tunnel.src->len == 128) {
+				nft_print(octx, "%s%s%sip6 saddr ",
+					  opts->nl, opts->tab, opts->tab);
+				expr_print(obj->tunnel.src, octx);
+			}
+		}
+		if (obj->tunnel.dst) {
+			if (obj->tunnel.dst->len == 32) {
+				nft_print(octx, "%s%s%sip daddr ",
+					  opts->nl, opts->tab, opts->tab);
+				expr_print(obj->tunnel.dst, octx);
+			} else if (obj->tunnel.dst->len == 128) {
+				nft_print(octx, "%s%s%sip6 daddr ",
+					  opts->nl, opts->tab, opts->tab);
+				expr_print(obj->tunnel.dst, octx);
+			}
+		}
+		if (obj->tunnel.sport) {
+			nft_print(octx, "%s%s%ssport %u",
+				  opts->nl, opts->tab, opts->tab,
+				  obj->tunnel.sport);
+		}
+		if (obj->tunnel.dport) {
+			nft_print(octx, "%s%s%sdport %u",
+				  opts->nl, opts->tab, opts->tab,
+				  obj->tunnel.dport);
+		}
+		if (obj->tunnel.tos) {
+			nft_print(octx, "%s%s%stos %u",
+				  opts->nl, opts->tab, opts->tab,
+				  obj->tunnel.tos);
+		}
+		if (obj->tunnel.ttl) {
+			nft_print(octx, "%s%s%sttl %u",
+				  opts->nl, opts->tab, opts->tab,
+				  obj->tunnel.ttl);
+		}
+		nft_print(octx, "%s", opts->stmt_separator);
+		break;
 	default:
 		nft_print(octx, " unknown {%s", opts->nl);
 		break;
@@ -1955,6 +2022,7 @@ static const char * const obj_type_name_array[] = {
 	[NFT_OBJECT_SECMARK]	= "secmark",
 	[NFT_OBJECT_SYNPROXY]	= "synproxy",
 	[NFT_OBJECT_CT_EXPECT]	= "ct expectation",
+	[NFT_OBJECT_TUNNEL]	= "tunnel",
 };
 
 const char *obj_type_name(unsigned int type)
@@ -1973,6 +2041,7 @@ static uint32_t obj_type_cmd_array[NFT_OBJECT_MAX + 1] = {
 	[NFT_OBJECT_SECMARK]	= CMD_OBJ_SECMARK,
 	[NFT_OBJECT_SYNPROXY]	= CMD_OBJ_SYNPROXY,
 	[NFT_OBJECT_CT_EXPECT]	= CMD_OBJ_CT_EXPECT,
+	[NFT_OBJECT_TUNNEL]	= CMD_OBJ_TUNNEL,
 };
 
 enum cmd_obj obj_type_to_cmd(uint32_t type)
@@ -2439,6 +2508,9 @@ static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
 	case CMD_OBJ_SYNPROXY:
 	case CMD_OBJ_SYNPROXYS:
 		return do_list_obj(ctx, cmd, NFT_OBJECT_SYNPROXY);
+	case CMD_OBJ_TUNNEL:
+	case CMD_OBJ_TUNNELS:
+		return do_list_obj(ctx, cmd, NFT_OBJECT_TUNNEL);
 	case CMD_OBJ_FLOWTABLE:
 		return do_list_flowtable(ctx, cmd, table);
 	case CMD_OBJ_FLOWTABLES:
diff --git a/src/scanner.l b/src/scanner.l
index 4787cc12..232bce67 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -223,6 +223,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 %s SCANSTATE_SECMARK
 %s SCANSTATE_TCP
 %s SCANSTATE_TYPE
+%s SCANSTATE_TUNNEL
 %s SCANSTATE_VLAN
 %s SCANSTATE_XT
 %s SCANSTATE_CMD_DESTROY
@@ -403,6 +404,8 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 	"maps"			{ return MAPS; }
 	"secmarks"		{ return SECMARKS; }
 	"synproxys"		{ return SYNPROXYS; }
+	"tunnel"		{ return TUNNEL; }
+	"tunnels"		{ return TUNNELS; }
 	"hooks"			{ return HOOKS; }
 }
 
@@ -807,6 +810,15 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 	"sack-perm"		{ return SACK_PERM; }
 }
 
+"tunnel"		{ scanner_push_start_cond(yyscanner, SCANSTATE_TUNNEL); return TUNNEL; }
+<SCANSTATE_TUNNEL>{
+	"id"			{ return ID; }
+	"sport"			{ return SPORT; }
+	"dport"			{ return DPORT; }
+	"ttl"			{ return TTL; }
+	"tos"			{ return TOS; }
+}
+
 "notrack"		{ return NOTRACK; }
 
 "all"			{ return ALL; }
-- 
2.49.0

