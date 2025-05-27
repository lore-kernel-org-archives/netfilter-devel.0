Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AAB01FFC4F
	for <netfilter-devel@vger.kernel.org>; Tue, 27 May 2025 19:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748375740; cv=none; b=BW/sLNJGGWkGJRJ697YuljQeQPcWl+vg9EdyTm1fGmSFURvvvIel6DCN993XZyDPvU/NtF8ArOlczc6kkr7mX+6V54//fuw7oGf1/w+4HXUSxoX6AudMbTKRorRQPHwhzM0JvqXDr8Qip3Fcqja9N0xzrpMMKSfwX6mieF2Ba0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748375740; c=relaxed/simple;
	bh=RpOqARQmU0DKU2TYyMumfqDBJD7oGDGZburhsLtR9Lo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sUM1FYqEK6YaP6QbFetZd9cGq3VkB99/HzhxYDjrNDCm/xhIOB6HmQOPOF0r2ZVhlJ+uUcO58D89gbJ1TxcmPmunZ7Fu/5Af/3kHcJCH2nhCcfcXmUqfuFLNdAVWI0xIXpZlmu4xRu6JqlqXFoc+e4DMvNxMi9IeaP2QaTgT9TE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C7E3E1F399;
	Tue, 27 May 2025 19:55:36 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7D796136E0;
	Tue, 27 May 2025 19:55:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id AGVcG7gYNmhJGgAAD6G6ig
	(envelope-from <fmancera@suse.de>); Tue, 27 May 2025 19:55:36 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH 5/7 nft] tunnel: add geneve support
Date: Tue, 27 May 2025 21:54:42 +0200
Message-ID: <9de6ba66ef0184e033b4402496d196075efdef51.1748374810.git.fmancera@suse.de>
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
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Queue-Id: C7E3E1F399
X-Spam-Flag: NO
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[];
	ASN(0.00)[asn:25478, ipnet:::/0, country:RU]
X-Spam-Score: -4.00
X-Spam-Level: 

This patch extends the tunnel metadata object to define geneve tunnel
specific configurations:

table netdev x {
	tunnel y {
		id 10
		ip saddr 192.168.2.10
		ip daddr 192.168.2.11
		sport 10
		dport 20
		ttl 10
		geneve {
			class 0x1010 opt-type 0x1 data "0x12345678"
			class 0x1020 opt-type 0x2 data "0x87654321"
			class 0x2020 opt-type 0x3 data "0x87654321abcdeffe"
		}
	}
}

Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
 include/rule.h     | 14 ++++++++++
 src/mnl.c          |  8 ++++++
 src/netlink.c      | 20 ++++++++++++++
 src/parser_bison.y | 43 ++++++++++++++++++++++++++++-
 src/rule.c         | 68 ++++++++++++++++++++++++++++++++++++++++++++++
 src/scanner.l      |  3 ++
 6 files changed, 155 insertions(+), 1 deletion(-)

diff --git a/include/rule.h b/include/rule.h
index f7872267..86239c38 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -494,6 +494,15 @@ enum tunnel_type {
 	TUNNEL_UNSPEC = 0,
 	TUNNEL_ERSPAN,
 	TUNNEL_VXLAN,
+	TUNNEL_GENEVE,
+};
+
+struct tunnel_geneve {
+	struct list_head	list;
+	uint16_t		geneve_class;
+	uint8_t			type;
+	uint8_t			data[NFTNL_TUNNEL_GENEVE_DATA_MAXLEN];
+	uint32_t		data_len;
 };
 
 struct tunnel {
@@ -519,9 +528,14 @@ struct tunnel {
 		struct {
 			uint32_t	gbp;
 		} vxlan;
+		struct list_head	geneve_opts;
 	};
 };
 
+int tunnel_geneve_data_str2array(const char *hexstr,
+				 uint8_t *out_data,
+				 uint32_t *out_len);
+
 /**
  * struct obj - nftables stateful object statement
  *
diff --git a/src/mnl.c b/src/mnl.c
index 302bb5ce..6d8e4da0 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -1455,6 +1455,7 @@ int mnl_nft_obj_add(struct netlink_ctx *ctx, struct cmd *cmd,
 	struct obj *obj = cmd->object;
 	struct nft_data_linearize nld;
 	struct nftnl_udata_buf *udbuf;
+	struct tunnel_geneve *geneve;
 	struct nftnl_obj *nlo;
 	struct nlmsghdr *nlh;
 
@@ -1606,6 +1607,13 @@ int mnl_nft_obj_add(struct netlink_ctx *ctx, struct cmd *cmd,
 					  NFTNL_OBJ_TUNNEL_VXLAN_GBP,
 					  obj->tunnel.vxlan.gbp);
 			break;
+		case TUNNEL_GENEVE:
+			list_for_each_entry(geneve, &obj->tunnel.geneve_opts, list) {
+				nftnl_obj_set_data(nlo,
+						   NFTNL_OBJ_TUNNEL_GENEVE_OPTS,
+						   geneve, sizeof(struct tunnel_geneve));
+			}
+			break;
 		case TUNNEL_UNSPEC:
 			break;
 		}
diff --git a/src/netlink.c b/src/netlink.c
index 9d1984a7..53feabfb 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1756,6 +1756,23 @@ static int obj_parse_udata_cb(const struct nftnl_udata *attr, void *data)
 	return 0;
 }
 
+static int netlink_parse_obj_tunnel_geneve(struct nftnl_obj_tunnel_geneve *e, void *data)
+{
+	struct tunnel_geneve *geneve;
+	struct obj *obj = data;
+
+	if (!obj->tunnel.type) {
+		init_list_head(&obj->tunnel.geneve_opts);
+		obj->tunnel.type = TUNNEL_GENEVE;
+	}
+
+	geneve = xmalloc(sizeof(struct tunnel_geneve));
+	memcpy(geneve, e, sizeof(struct tunnel_geneve));
+	list_add_tail(&geneve->list, &obj->tunnel.geneve_opts);
+
+	return 0;
+}
+
 struct obj *netlink_delinearize_obj(struct netlink_ctx *ctx,
 				    struct nftnl_obj *nlo)
 {
@@ -1905,6 +1922,9 @@ struct obj *netlink_delinearize_obj(struct netlink_ctx *ctx,
 			obj->tunnel.type = TUNNEL_VXLAN;
 			obj->tunnel.vxlan.gbp = nftnl_obj_get_u32(nlo, NFTNL_OBJ_TUNNEL_VXLAN_GBP);
 		}
+		if (nftnl_obj_is_set(nlo, NFTNL_OBJ_TUNNEL_GENEVE_OPTS)) {
+			nftnl_obj_tunnel_geneve_opts_foreach(nlo, netlink_parse_obj_tunnel_geneve, obj);
+		}
 		break;
 	default:
 		netlink_io_error(ctx, NULL, "Unknown object type %u", type);
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 53c2dc2b..8e0e27e9 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -612,6 +612,8 @@ int nft_lex(void *, void *, void *);
 %token EGRESS			"egress"
 %token INGRESS			"ingress"
 %token GBP			"gbp"
+%token CLASS			"class"
+%token OPTTYPE			"opt-type"
 
 %token COUNTERS			"counters"
 %token QUOTAS			"quotas"
@@ -770,7 +772,7 @@ int nft_lex(void *, void *, void *);
 %type <flowtable>		flowtable_block_alloc flowtable_block
 %destructor { flowtable_free($$); }	flowtable_block_alloc
 
-%type <obj>			obj_block_alloc counter_block quota_block ct_helper_block ct_timeout_block ct_expect_block limit_block secmark_block synproxy_block tunnel_block erspan_block erspan_block_alloc vxlan_block vxlan_block_alloc
+%type <obj>			obj_block_alloc counter_block quota_block ct_helper_block ct_timeout_block ct_expect_block limit_block secmark_block synproxy_block tunnel_block erspan_block erspan_block_alloc vxlan_block vxlan_block_alloc geneve_block geneve_block_alloc
 %destructor { obj_free($$); }	obj_block_alloc
 
 %type <list>			stmt_list stateful_stmt_list set_elem_stmt_list
@@ -5002,6 +5004,44 @@ erspan_config		:	HDRVERSION	NUM
 			}
 			;
 
+geneve_block		:	/* empty */	{ $$ = $<obj>-1; }
+			|	geneve_block	common_block
+			|	geneve_block	stmt_separator
+			|	geneve_block	geneve_config	stmt_separator
+			{
+				$$ = $1;
+			}
+			;
+
+geneve_block_alloc	:	/* empty */
+			{
+				$$ = $<obj>-1;
+			}
+			;
+
+geneve_config		:	CLASS	NUM	OPTTYPE	NUM	DATA	string
+			{
+				struct tunnel_geneve *geneve;
+
+				geneve = xmalloc(sizeof(struct tunnel_geneve));
+				geneve->geneve_class = $2;
+				geneve->type = $4;
+				if (tunnel_geneve_data_str2array($6, geneve->data, &geneve->data_len)) {
+					erec_queue(error(&@6, "Invalid data array %s\n", $6), state->msgs);
+					free_const($6);
+					free(geneve);
+					YYERROR;
+				}
+
+				if (!$<obj>0->tunnel.type) {
+					$<obj>0->tunnel.type = TUNNEL_GENEVE;
+					init_list_head(&$<obj>0->tunnel.geneve_opts);
+				}
+				list_add_tail(&geneve->list, &$<obj>0->tunnel.geneve_opts);
+				free_const($6);
+			}
+			;
+
 vxlan_block		:	/* empty */	{ $$ = $<obj>-1; }
 			|	vxlan_block	common_block
 			|	vxlan_block	stmt_separator
@@ -5059,6 +5099,7 @@ tunnel_config		:	ID	NUM
 			{
 				$<obj>0->tunnel.type = TUNNEL_VXLAN;
 			}
+			|	GENEVE	geneve_block_alloc '{' geneve_block '}'
 			;
 
 tunnel_block		:	/* empty */	{ $$ = $<obj>-1; }
diff --git a/src/rule.c b/src/rule.c
index e020cfb9..588c01b1 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1694,6 +1694,14 @@ void obj_free(struct obj *obj)
 	case NFT_OBJECT_TUNNEL:
 		expr_free(obj->tunnel.src);
 		expr_free(obj->tunnel.dst);
+		if (obj->tunnel.type == TUNNEL_GENEVE) {
+			struct tunnel_geneve *geneve, *next;
+
+			list_for_each_entry_safe(geneve, next, &obj->tunnel.geneve_opts, list) {
+				list_del(&geneve->list);
+				free(geneve);
+			}
+		}
 		break;
 	default:
 		break;
@@ -1771,6 +1779,44 @@ static const char *synproxy_timestamp_to_str(const uint32_t flags)
         return "";
 }
 
+int tunnel_geneve_data_str2array(const char *hexstr,
+				 uint8_t *out_data,
+				 uint32_t *out_len)
+{
+	char bytestr[3] = {0};
+	size_t len;
+
+	if (hexstr[0] == '0' && (hexstr[1] == 'x' || hexstr[1] == 'X'))
+		hexstr += 2;
+	else
+		return -1;
+
+	len = strlen(hexstr);
+	if (len % 4 != 0)
+		return -1;
+
+	len = len / 2;
+	if (len > NFTNL_TUNNEL_GENEVE_DATA_MAXLEN)
+		return -1;
+
+	for (size_t i = 0; i < len; i++) {
+		char *endptr;
+		uint32_t value;
+
+		bytestr[0] = hexstr[i * 2];
+		bytestr[1] = hexstr[i * 2 + 1];
+
+		value = strtoul(bytestr, &endptr, 16);
+		if (*endptr != '\0')
+			return -1;
+
+		out_data[i] = (uint8_t) value;
+	}
+	*out_len = (uint8_t) len;
+
+	return 0;
+}
+
 static void obj_print_comment(const struct obj *obj,
 			      struct print_fmt_options *opts,
 			      struct output_ctx *octx)
@@ -2005,6 +2051,7 @@ static void obj_print_data(const struct obj *obj,
 				  opts->nl, opts->tab, opts->tab,
 				  obj->tunnel.ttl);
 		}
+
 		switch (obj->tunnel.type) {
 		case TUNNEL_ERSPAN:
 			nft_print(octx, "%s%s%serspan {",
@@ -2037,6 +2084,27 @@ static void obj_print_data(const struct obj *obj,
 			nft_print(octx, "%s%s%s}",
 				  opts->nl, opts->tab, opts->tab);
 			break;
+		case TUNNEL_GENEVE:
+			struct tunnel_geneve *geneve;
+
+			nft_print(octx, "%s%s%sgeneve {", opts->nl, opts->tab, opts->tab);
+			list_for_each_entry(geneve, &obj->tunnel.geneve_opts, list) {
+				char data_str[256];
+				int offset = 0;
+
+				for (uint32_t i = 0; i < geneve->data_len; i++) {
+					offset += snprintf(data_str + offset,
+							   geneve->data_len,
+							   "%x",
+							   geneve->data[i]);
+				}
+				nft_print(octx, "%s%s%s%sclass 0x%x opt-type 0x%x data \"0x%s\"",
+					  opts->nl, opts->tab, opts->tab, opts->tab,
+					  geneve->geneve_class, geneve->type, data_str);
+
+			}
+			nft_print(octx, "%s%s%s}", opts->nl, opts->tab, opts->tab);
+			break;
 		default:
 			break;
 		}
diff --git a/src/scanner.l b/src/scanner.l
index 77c84923..6eacfcb0 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -824,6 +824,9 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 	"ingress"		{ return INGRESS; }
 	"path"			{ return PATH; }
 	"gbp"			{ return GBP; }
+	"class"			{ return CLASS; }
+	"opt-type"		{ return OPTTYPE; }
+	"data"			{ return DATA; }
 }
 
 "notrack"		{ return NOTRACK; }
-- 
2.49.0

