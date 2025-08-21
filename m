Received: from localhost.localdomain (203.red-83-63-38.staticip.rima-tde.net [83.63.38.203])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8F4C2ED147
	for <netfilter-devel@vger.kernel.org>; Thu, 21 Aug 2025 09:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.63.38.203
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755767602; cv=none; b=UUaHVUsXon5loAh6CiuFhHxndP0oL09SUL2uAXwDh5swpspGC0B17Yk1F9payHKaacrTB/p8vKBP6AaPE55r6Uedqg6LhpuiRKUd3GC+ttTgBU3rdWq1SZ+nlR2HaClIUmXBc22G7WrzmI7c9JkiHsmdndcVriZnOJ2BK4rcajs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755767602; c=relaxed/simple;
	bh=mgvyhpELiRD9kS5sqZiOhbAcI0G8qC4CsmWjVH6qzYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aImpqZkQddNI/NycT4iINlH2+awi+s7DhzqfWVS5EyTwzI1EqqlSucoKgSTSzgJdPuFyC7sXDJtZKASQKtBLpPwATDmVMwciVUqpGRSRap0TNM0m8KvTV5AXcIIqLVaZUFOa6qVLRRoPx4gmz3460+4aRi0LoVkRGFME1265zl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.de; spf=none smtp.mailfrom=localhost.localdomain; arc=none smtp.client-ip=83.63.38.203
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=localhost.localdomain
Received: by localhost.localdomain (Postfix, from userid 1000)
	id B111C2165AF5; Thu, 21 Aug 2025 11:13:18 +0200 (CEST)
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	pablo@netfilter.org,
	fw@strlen.de,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH 2/7 nft v3] tunnel: add erspan support
Date: Thu, 21 Aug 2025 11:12:57 +0200
Message-ID: <20250821091302.9032-2-fmancera@suse.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250821091302.9032-1-fmancera@suse.de>
References: <20250821091302.9032-1-fmancera@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pablo Neira Ayuso <pablo@netfilter.org>

This patch extends the tunnel metadata object to define erspan tunnel
specific configurations:

 table netdev x {
        tunnel y {
                id 10
                ip saddr 192.168.2.10
                ip daddr 192.168.2.11
                sport 10
                dport 20
                ttl 10
                erspan {
                        version 1
                        index 2
                }
        }
 }

Joint work with Fernando.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
v3: rebased
---
 include/rule.h     | 18 ++++++++++++++++++
 src/mnl.c          | 43 +++++++++++++++++++++++++++++++++++++++++++
 src/netlink.c      | 38 ++++++++++++++++++++++++++++++++++++++
 src/parser_bison.y | 46 +++++++++++++++++++++++++++++++++++++++++++++-
 src/rule.c         | 26 ++++++++++++++++++++++++++
 src/scanner.l      |  5 +++++
 6 files changed, 175 insertions(+), 1 deletion(-)

diff --git a/include/rule.h b/include/rule.h
index 0fa87b52..71e9a07e 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -492,6 +492,11 @@ struct secmark {
 	char		ctx[NFT_SECMARK_CTX_MAXLEN];
 };
 
+enum tunnel_type {
+	TUNNEL_UNSPEC = 0,
+	TUNNEL_ERSPAN,
+};
+
 struct tunnel {
 	uint32_t	id;
 	struct expr	*src;
@@ -500,6 +505,19 @@ struct tunnel {
 	uint16_t	dport;
 	uint8_t		tos;
 	uint8_t		ttl;
+	enum tunnel_type type;
+	union {
+		struct {
+			uint32_t	version;
+			struct {
+				uint32_t	index;
+			} v1;
+			struct {
+				uint8_t		direction;
+				uint8_t		hwid;
+			} v2;
+		} erspan;
+	};
 };
 
 /**
diff --git a/src/mnl.c b/src/mnl.c
index e17f2c2f..3762b6f9 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -1474,6 +1474,48 @@ err:
 	return NULL;
 }
 
+static void obj_tunnel_add_opts(struct nftnl_obj *nlo, struct tunnel *tunnel)
+{
+	struct nftnl_tunnel_opts *opts;
+	struct nftnl_tunnel_opt *opt;
+
+	switch (tunnel->type) {
+	case TUNNEL_ERSPAN:
+		opts = nftnl_tunnel_opts_alloc(NFTNL_TUNNEL_TYPE_ERSPAN);
+		if (!opts)
+			memory_allocation_error();
+
+		opt = nftnl_tunnel_opt_alloc(NFTNL_TUNNEL_TYPE_ERSPAN);
+		if (!opt)
+			memory_allocation_error();
+
+		nftnl_tunnel_opt_set(opt, NFTNL_TUNNEL_ERSPAN_VERSION,
+				     &tunnel->erspan.version,
+				     sizeof(tunnel->erspan.version));
+		switch (tunnel->erspan.version) {
+		case 1:
+			nftnl_tunnel_opt_set(opt, NFTNL_TUNNEL_ERSPAN_V1_INDEX,
+					     &tunnel->erspan.v1.index,
+					     sizeof(tunnel->erspan.v1.index));
+			break;
+		case 2:
+			nftnl_tunnel_opt_set(opt, NFTNL_TUNNEL_ERSPAN_V2_DIR,
+					     &tunnel->erspan.v2.direction,
+					     sizeof(tunnel->erspan.v2.direction));
+			nftnl_tunnel_opt_set(opt, NFTNL_TUNNEL_ERSPAN_V2_HWID,
+					     &tunnel->erspan.v2.hwid,
+					     sizeof(tunnel->erspan.v2.hwid));
+			break;
+		}
+
+		nftnl_tunnel_opts_add(opts, opt);
+		nftnl_obj_set_data(nlo, NFTNL_OBJ_TUNNEL_OPTS, &opts, sizeof(struct nftnl_tunnel_opts *));
+		break;
+	case TUNNEL_UNSPEC:
+		break;
+	}
+}
+
 int mnl_nft_obj_add(struct netlink_ctx *ctx, struct cmd *cmd,
 		    unsigned int flags)
 {
@@ -1605,6 +1647,7 @@ int mnl_nft_obj_add(struct netlink_ctx *ctx, struct cmd *cmd,
 						   nld.value, nld.len);
 			}
 		}
+		obj_tunnel_add_opts(nlo, &obj->tunnel);
 		break;
 	default:
 		BUG("Unknown type %d\n", obj->type);
diff --git a/src/netlink.c b/src/netlink.c
index f0a9c02b..4ef88402 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1808,6 +1808,41 @@ static int obj_parse_udata_cb(const struct nftnl_udata *attr, void *data)
 	return 0;
 }
 
+static int tunnel_parse_opt_cb(struct nftnl_tunnel_opt *opt, void *data) {
+
+	struct obj *obj = data;
+
+	switch (nftnl_tunnel_opt_get_type(opt)) {
+	case NFTNL_TUNNEL_TYPE_ERSPAN:
+		obj->tunnel.type = TUNNEL_ERSPAN;
+		if (nftnl_tunnel_opt_get_flags(opt) & (1 << NFTNL_TUNNEL_ERSPAN_VERSION)) {
+			obj->tunnel.erspan.version =
+				nftnl_tunnel_opt_get_u32(opt,
+							 NFTNL_TUNNEL_ERSPAN_VERSION);
+		}
+		if (nftnl_tunnel_opt_get_flags(opt) & (1 << NFTNL_TUNNEL_ERSPAN_V1_INDEX)) {
+			obj->tunnel.erspan.v1.index =
+				nftnl_tunnel_opt_get_u32(opt,
+							 NFTNL_TUNNEL_ERSPAN_V1_INDEX);
+		}
+		if (nftnl_tunnel_opt_get_flags(opt) & (1 << NFTNL_TUNNEL_ERSPAN_V2_HWID)) {
+			obj->tunnel.erspan.v2.hwid =
+				nftnl_tunnel_opt_get_u8(opt,
+							NFTNL_TUNNEL_ERSPAN_V2_HWID);
+		}
+		if (nftnl_tunnel_opt_get_flags(opt) & (1 << NFTNL_TUNNEL_ERSPAN_V2_DIR)) {
+			obj->tunnel.erspan.v2.direction =
+				nftnl_tunnel_opt_get_u8(opt,
+							NFTNL_TUNNEL_ERSPAN_V2_DIR);
+		}
+		break;
+	default:
+		break;
+	}
+
+	return 0;
+}
+
 struct obj *netlink_delinearize_obj(struct netlink_ctx *ctx,
 				    struct nftnl_obj *nlo)
 {
@@ -1938,6 +1973,9 @@ struct obj *netlink_delinearize_obj(struct netlink_ctx *ctx,
 			obj->tunnel.dst =
 				netlink_obj_tunnel_parse_addr(nlo, NFTNL_OBJ_TUNNEL_IPV6_DST);
 		}
+		if (nftnl_obj_is_set(nlo, NFTNL_OBJ_TUNNEL_OPTS)) {
+			nftnl_obj_tunnel_opts_foreach(nlo, tunnel_parse_opt_cb, obj);
+		}
 		break;
 	default:
 		netlink_io_error(ctx, NULL, "Unknown object type %u", type);
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 367c6b3b..557977e2 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -607,6 +607,9 @@ int nft_lex(void *, void *, void *);
 %token NEVER			"never"
 
 %token TUNNEL			"tunnel"
+%token ERSPAN			"erspan"
+%token EGRESS			"egress"
+%token INGRESS			"ingress"
 
 %token COUNTERS			"counters"
 %token QUOTAS			"quotas"
@@ -765,7 +768,7 @@ int nft_lex(void *, void *, void *);
 %type <flowtable>		flowtable_block_alloc flowtable_block
 %destructor { flowtable_free($$); }	flowtable_block_alloc
 
-%type <obj>			obj_block_alloc counter_block quota_block ct_helper_block ct_timeout_block ct_expect_block limit_block secmark_block synproxy_block tunnel_block
+%type <obj>			obj_block_alloc counter_block quota_block ct_helper_block ct_timeout_block ct_expect_block limit_block secmark_block synproxy_block tunnel_block erspan_block erspan_block_alloc
 %destructor { obj_free($$); }	obj_block_alloc
 
 %type <list>			stmt_list stateful_stmt_list set_elem_stmt_list
@@ -4958,6 +4961,43 @@ limit_obj		:	/* empty */
 			}
 			;
 
+erspan_block		:	/* empty */	{ $$ = $<obj>-1; }
+			|       erspan_block     common_block
+			|       erspan_block     stmt_separator
+			|       erspan_block     erspan_config	stmt_separator
+			{
+				$$ = $1;
+			}
+			;
+
+erspan_block_alloc	:	/* empty */
+			{
+				$$ = $<obj>-1;
+			}
+			;
+
+erspan_config		:	HDRVERSION	NUM
+			{
+				$<obj>0->tunnel.erspan.version = $2;
+			}
+			|	INDEX		NUM
+			{
+				$<obj>0->tunnel.erspan.v1.index = $2;
+			}
+			|	DIRECTION	INGRESS
+			{
+				$<obj>0->tunnel.erspan.v2.direction = 0;
+			}
+			|	DIRECTION	EGRESS
+			{
+				$<obj>0->tunnel.erspan.v2.direction = 1;
+			}
+			|	ID		NUM
+			{
+				$<obj>0->tunnel.erspan.v2.hwid = $2;
+			}
+			;
+
 tunnel_config		:	ID	NUM
 			{
 				$<obj>0->tunnel.id = $2;
@@ -4998,6 +5038,10 @@ tunnel_config		:	ID	NUM
 			{
 				$<obj>0->tunnel.tos = $2;
 			}
+			|	ERSPAN	erspan_block_alloc '{' erspan_block '}'
+			{
+				$<obj>0->tunnel.type = TUNNEL_ERSPAN;
+			}
 			;
 
 tunnel_block		:	/* empty */	{ $$ = $<obj>-1; }
diff --git a/src/rule.c b/src/rule.c
index 5b79facb..2557f4cc 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -2021,6 +2021,32 @@ static void obj_print_data(const struct obj *obj,
 				  opts->nl, opts->tab, opts->tab,
 				  obj->tunnel.ttl);
 		}
+		switch (obj->tunnel.type) {
+		case TUNNEL_ERSPAN:
+			nft_print(octx, "%s%s%serspan {",
+				  opts->nl, opts->tab, opts->tab);
+			nft_print(octx, "%s%s%s%sversion %u",
+				  opts->nl, opts->tab, opts->tab, opts->tab,
+				  obj->tunnel.erspan.version);
+			if (obj->tunnel.erspan.version == 1) {
+				nft_print(octx, "%s%s%s%sindex %u",
+					  opts->nl, opts->tab, opts->tab, opts->tab,
+					  obj->tunnel.erspan.v1.index);
+			} else {
+				nft_print(octx, "%s%s%s%sdirection %s",
+					  opts->nl, opts->tab, opts->tab, opts->tab,
+					  obj->tunnel.erspan.v2.direction ? "egress"
+									  : "ingress");
+				nft_print(octx, "%s%s%s%sid %u",
+					  opts->nl, opts->tab, opts->tab, opts->tab,
+					  obj->tunnel.erspan.v2.hwid);
+			}
+			nft_print(octx, "%s%s%s}",
+				  opts->nl, opts->tab, opts->tab);
+		default:
+			break;
+		}
+
 		nft_print(octx, "%s", opts->stmt_separator);
 		break;
 	default:
diff --git a/src/scanner.l b/src/scanner.l
index 5e848890..def0ac0e 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -821,6 +821,11 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 	"dport"			{ return DPORT; }
 	"ttl"			{ return TTL; }
 	"tos"			{ return TOS; }
+	"version"		{ return HDRVERSION; }
+	"direction"		{ return DIRECTION; }
+	"erspan"		{ return ERSPAN; }
+	"egress"		{ return EGRESS; }
+	"ingress"		{ return INGRESS; }
 }
 
 "notrack"		{ return NOTRACK; }
-- 
2.50.1

