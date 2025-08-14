Received: from localhost.localdomain (203.red-83-63-38.staticip.rima-tde.net [83.63.38.203])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7750A2F0C5F
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Aug 2025 11:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.63.38.203
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755169503; cv=none; b=Exsiy0EHKiyJJ+coVgqEyxys7IpOeMSaZSMlmt2zqkxTrRGdJ4JCO9fNmD8xQHg40toPbaky5qL3pRk95bZpul1W5Qt9HhHip79MMdWpykUu42KQLzesLSVmRd8xZHCHo0QENNIc5ZUTVQZToh0brPcKER/9i/nlE4RqOCJ8w+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755169503; c=relaxed/simple;
	bh=dmQJ5iU7sn5Lynz8NYsfVvxlM6amQKdam1klX0PyOpE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BtVidiBv77+Por47FegKKb17PxgMx6ElGJVKPK1SczVS20IJG5zG9Bhj1xhXE/2lwqFia7qcqziIDn/gNvqcpv9hz5tISdITTRHP1BLGcvKaVDLV4Q7NC64G0Tun9PGg8qhymppPWCPFzqGao8Nq1M5Io+eQHO9GuWXJTfbjvXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.de; spf=none smtp.mailfrom=localhost.localdomain; arc=none smtp.client-ip=83.63.38.203
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=localhost.localdomain
Received: by localhost.localdomain (Postfix, from userid 1000)
	id 79977202A1CD; Thu, 14 Aug 2025 13:05:00 +0200 (CEST)
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	pablo@netfilter.org,
	fw@strlen.de,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH 5/7 nft v2] tunnel: add geneve support
Date: Thu, 14 Aug 2025 13:04:48 +0200
Message-ID: <20250814110450.5434-5-fmancera@suse.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250814110450.5434-1-fmancera@suse.de>
References: <20250814110450.5434-1-fmancera@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
 src/mnl.c          | 25 +++++++++++++++++
 src/netlink.c      | 29 ++++++++++++++++++++
 src/parser_bison.y | 43 ++++++++++++++++++++++++++++-
 src/rule.c         | 67 ++++++++++++++++++++++++++++++++++++++++++++++
 src/scanner.l      |  3 +++
 6 files changed, 180 insertions(+), 1 deletion(-)

diff --git a/include/rule.h b/include/rule.h
index c52af2c4..498a88bf 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -496,6 +496,15 @@ enum tunnel_type {
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
@@ -521,9 +530,14 @@ struct tunnel {
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
index 0fcb8f6b..425ef51a 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -1524,6 +1524,31 @@ static void obj_tunnel_add_opts(struct nftnl_obj *nlo, struct tunnel *tunnel)
 		nftnl_tunnel_opts_add(opts, opt);
 		nftnl_obj_set_data(nlo, NFTNL_OBJ_TUNNEL_OPTS, &opts, sizeof(struct nftnl_tunnel_opts *));
 		break;
+	case TUNNEL_GENEVE:
+		struct tunnel_geneve *geneve;
+
+		opts = nftnl_tunnel_opts_alloc(NFTNL_TUNNEL_TYPE_GENEVE);
+		if (!opts)
+			memory_allocation_error();
+
+		list_for_each_entry(geneve, &tunnel->geneve_opts, list) {
+			opt = nftnl_tunnel_opt_alloc(NFTNL_TUNNEL_TYPE_GENEVE);
+			if (!opt)
+				memory_allocation_error();
+
+			nftnl_tunnel_opt_set(opt,
+					     NFTNL_TUNNEL_GENEVE_TYPE,
+					     &geneve->type, sizeof(geneve->type));
+			nftnl_tunnel_opt_set(opt,
+					     NFTNL_TUNNEL_GENEVE_CLASS,
+					     &geneve->geneve_class, sizeof(geneve->geneve_class));
+			nftnl_tunnel_opt_set(opt,
+					     NFTNL_TUNNEL_GENEVE_DATA,
+					     &geneve->data, geneve->data_len);
+			nftnl_tunnel_opts_add(opts, opt);
+		}
+		nftnl_obj_set_data(nlo, NFTNL_OBJ_TUNNEL_OPTS, &opts, sizeof(struct nftnl_tunnel_opts *));
+		break;
 	case TUNNEL_UNSPEC:
 		break;
 	}
diff --git a/src/netlink.c b/src/netlink.c
index 2a0b8f62..939a5d08 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1839,6 +1839,35 @@ static int tunnel_parse_opt_cb(struct nftnl_tunnel_opt *opt, void *data) {
 				obj->tunnel.vxlan.gbp = nftnl_tunnel_opt_get_u32(opt, NFTNL_TUNNEL_VXLAN_GBP);
 			}
 		break;
+		case NFTNL_TUNNEL_TYPE_GENEVE:
+			struct tunnel_geneve *geneve;
+			const void * data = NULL;
+
+			if (!obj->tunnel.type) {
+				init_list_head(&obj->tunnel.geneve_opts);
+				obj->tunnel.type = TUNNEL_GENEVE;
+			}
+
+			geneve = xmalloc(sizeof(struct tunnel_geneve));
+			if (!geneve)
+				memory_allocation_error();
+
+			if (nftnl_tunnel_opt_get_flags(opt) & (1 << NFTNL_TUNNEL_GENEVE_TYPE))
+				geneve->type = nftnl_tunnel_opt_get_u8(opt, NFTNL_TUNNEL_GENEVE_TYPE);
+
+			if (nftnl_tunnel_opt_get_flags(opt) & (1 << NFTNL_TUNNEL_GENEVE_CLASS))
+				geneve->geneve_class = nftnl_tunnel_opt_get_u16(opt, NFTNL_TUNNEL_GENEVE_CLASS);
+
+			if (nftnl_tunnel_opt_get_flags(opt) & (1 << NFTNL_TUNNEL_GENEVE_DATA)) {
+				data = nftnl_tunnel_opt_get_data(opt, NFTNL_TUNNEL_GENEVE_DATA,
+								 &geneve->data_len);
+				if (!data)
+					return -1;
+				memcpy(&geneve->data, data, geneve->data_len);
+			}
+
+			list_add_tail(&geneve->list, &obj->tunnel.geneve_opts);
+		break;
 	}
 
 	return 0;
diff --git a/src/parser_bison.y b/src/parser_bison.y
index df42c4aa..daf718c7 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -613,6 +613,8 @@ int nft_lex(void *, void *, void *);
 %token EGRESS			"egress"
 %token INGRESS			"ingress"
 %token GBP			"gbp"
+%token CLASS			"class"
+%token OPTTYPE			"opt-type"
 
 %token COUNTERS			"counters"
 %token QUOTAS			"quotas"
@@ -771,7 +773,7 @@ int nft_lex(void *, void *, void *);
 %type <flowtable>		flowtable_block_alloc flowtable_block
 %destructor { flowtable_free($$); }	flowtable_block_alloc
 
-%type <obj>			obj_block_alloc counter_block quota_block ct_helper_block ct_timeout_block ct_expect_block limit_block secmark_block synproxy_block tunnel_block erspan_block erspan_block_alloc vxlan_block vxlan_block_alloc
+%type <obj>			obj_block_alloc counter_block quota_block ct_helper_block ct_timeout_block ct_expect_block limit_block secmark_block synproxy_block tunnel_block erspan_block erspan_block_alloc vxlan_block vxlan_block_alloc geneve_block geneve_block_alloc
 %destructor { obj_free($$); }	obj_block_alloc
 
 %type <list>			stmt_list stateful_stmt_list set_elem_stmt_list
@@ -5011,6 +5013,44 @@ erspan_config		:	HDRVERSION	NUM
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
@@ -5068,6 +5108,7 @@ tunnel_config		:	ID	NUM
 			{
 				$<obj>0->tunnel.type = TUNNEL_VXLAN;
 			}
+			|	GENEVE	geneve_block_alloc '{' geneve_block '}'
 			;
 
 tunnel_block		:	/* empty */	{ $$ = $<obj>-1; }
diff --git a/src/rule.c b/src/rule.c
index 0450851c..b9346759 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1707,6 +1707,14 @@ void obj_free(struct obj *obj)
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
@@ -1787,6 +1795,44 @@ static const char *synproxy_timestamp_to_str(const uint32_t flags)
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
@@ -2053,6 +2099,27 @@ static void obj_print_data(const struct obj *obj,
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
index 74ebca3b..8085c93b 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -828,6 +828,9 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 	"ingress"		{ return INGRESS; }
 	"path"			{ return PATH; }
 	"gbp"			{ return GBP; }
+	"class"			{ return CLASS; }
+	"opt-type"		{ return OPTTYPE; }
+	"data"			{ return DATA; }
 }
 
 "notrack"		{ return NOTRACK; }
-- 
2.50.1

