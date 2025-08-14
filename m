Received: from localhost.localdomain (203.red-83-63-38.staticip.rima-tde.net [83.63.38.203])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C8252F0698
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Aug 2025 11:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.63.38.203
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755169502; cv=none; b=Avd5G0QOGH3sjGaoty+FnYc3ycyCRqkp4BE7b79Txn4OMtil86E8q3vM4S1Py3Q0q6U9VkPcWkLgHEYab1XhfqVllEljRgfGn2P6ETUTKhpHbHsjNdDq4f0SEEjPSRYRJylg52XQNfr4n5HGWop7Jc9XBwxsUztvIDMl8+rSS3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755169502; c=relaxed/simple;
	bh=qDTvbNjNHbDFqxKiwUxah7twnaLYfDUvqvZsA6gd4KQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BfZlqIS67akkElmcFB8hpcxz1FaBArUtgahyhuZwa7z+BNcLZwYdJ1MSaj1Nu57jOyjHcXwjKZovoJpY7kSIqm/Smx1tqcrj1zyRyOQLPFrBuMgO50rTtUbJqi5SswlOKRsz0yzDIfKHsy6we7CEXH7PjNrKvLAMTQv0TfcXHNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.de; spf=none smtp.mailfrom=localhost.localdomain; arc=none smtp.client-ip=83.63.38.203
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=localhost.localdomain
Received: by localhost.localdomain (Postfix, from userid 1000)
	id 1E92C202A1CA; Thu, 14 Aug 2025 13:04:59 +0200 (CEST)
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	pablo@netfilter.org,
	fw@strlen.de,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH 4/7 nft v2] tunnel: add vxlan support
Date: Thu, 14 Aug 2025 13:04:47 +0200
Message-ID: <20250814110450.5434-4-fmancera@suse.de>
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

This patch extends the tunnel metadata object to define vxlan tunnel
specific configurations:

table netdev x {
	tunnel y {
		id 10
		ip saddr 192.168.2.10
		ip daddr 192.168.2.11
		sport 10
		dport 20
		ttl 10
		vxlan {
			gbp 200
		}
	}
}

Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
 include/rule.h     |  4 ++++
 src/mnl.c          | 16 ++++++++++++++++
 src/netlink.c      |  7 +++++++
 src/parser_bison.y | 28 +++++++++++++++++++++++++++-
 src/rule.c         | 10 ++++++++++
 src/scanner.l      |  1 +
 6 files changed, 65 insertions(+), 1 deletion(-)

diff --git a/include/rule.h b/include/rule.h
index 71e9a07e..c52af2c4 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -495,6 +495,7 @@ struct secmark {
 enum tunnel_type {
 	TUNNEL_UNSPEC = 0,
 	TUNNEL_ERSPAN,
+	TUNNEL_VXLAN,
 };
 
 struct tunnel {
@@ -517,6 +518,9 @@ struct tunnel {
 				uint8_t		hwid;
 			} v2;
 		} erspan;
+		struct {
+			uint32_t	gbp;
+		} vxlan;
 	};
 };
 
diff --git a/src/mnl.c b/src/mnl.c
index 722bfa2a..0fcb8f6b 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -1505,6 +1505,22 @@ static void obj_tunnel_add_opts(struct nftnl_obj *nlo, struct tunnel *tunnel)
 			break;
 		}
 
+		nftnl_tunnel_opts_add(opts, opt);
+		nftnl_obj_set_data(nlo, NFTNL_OBJ_TUNNEL_OPTS, &opts, sizeof(struct nftnl_tunnel_opts *));
+		break;
+	case TUNNEL_VXLAN:
+		opts = nftnl_tunnel_opts_alloc(NFTNL_TUNNEL_TYPE_VXLAN);
+		if (!opts)
+			memory_allocation_error();
+
+		opt = nftnl_tunnel_opt_alloc(NFTNL_TUNNEL_TYPE_VXLAN);
+		if (!opt)
+			memory_allocation_error();
+
+		nftnl_tunnel_opt_set(opt, NFTNL_TUNNEL_VXLAN_GBP,
+				     &tunnel->vxlan.gbp,
+				     sizeof(tunnel->vxlan.gbp));
+
 		nftnl_tunnel_opts_add(opts, opt);
 		nftnl_obj_set_data(nlo, NFTNL_OBJ_TUNNEL_OPTS, &opts, sizeof(struct nftnl_tunnel_opts *));
 		break;
diff --git a/src/netlink.c b/src/netlink.c
index ff81b185..2a0b8f62 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1832,6 +1832,13 @@ static int tunnel_parse_opt_cb(struct nftnl_tunnel_opt *opt, void *data) {
 						opt,
 						NFTNL_TUNNEL_ERSPAN_V2_DIR);
 		break;
+		case NFTNL_TUNNEL_TYPE_VXLAN:
+			obj->tunnel.type = TUNNEL_VXLAN;
+			if (nftnl_tunnel_opt_get_flags(opt) & (1 << NFTNL_TUNNEL_VXLAN_GBP)) {
+				obj->tunnel.type = TUNNEL_VXLAN;
+				obj->tunnel.vxlan.gbp = nftnl_tunnel_opt_get_u32(opt, NFTNL_TUNNEL_VXLAN_GBP);
+			}
+		break;
 	}
 
 	return 0;
diff --git a/src/parser_bison.y b/src/parser_bison.y
index e195c12a..df42c4aa 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -612,6 +612,7 @@ int nft_lex(void *, void *, void *);
 %token ERSPAN			"erspan"
 %token EGRESS			"egress"
 %token INGRESS			"ingress"
+%token GBP			"gbp"
 
 %token COUNTERS			"counters"
 %token QUOTAS			"quotas"
@@ -770,7 +771,7 @@ int nft_lex(void *, void *, void *);
 %type <flowtable>		flowtable_block_alloc flowtable_block
 %destructor { flowtable_free($$); }	flowtable_block_alloc
 
-%type <obj>			obj_block_alloc counter_block quota_block ct_helper_block ct_timeout_block ct_expect_block limit_block secmark_block synproxy_block tunnel_block erspan_block erspan_block_alloc
+%type <obj>			obj_block_alloc counter_block quota_block ct_helper_block ct_timeout_block ct_expect_block limit_block secmark_block synproxy_block tunnel_block erspan_block erspan_block_alloc vxlan_block vxlan_block_alloc
 %destructor { obj_free($$); }	obj_block_alloc
 
 %type <list>			stmt_list stateful_stmt_list set_elem_stmt_list
@@ -5010,6 +5011,27 @@ erspan_config		:	HDRVERSION	NUM
 			}
 			;
 
+vxlan_block		:	/* empty */	{ $$ = $<obj>-1; }
+			|	vxlan_block	common_block
+			|	vxlan_block	stmt_separator
+			|	vxlan_block	vxlan_config	stmt_separator
+			{
+				$$ = $1;
+			}
+			;
+
+vxlan_block_alloc	:	/* empty */
+			{
+				$$ = $<obj>-1;
+			}
+			;
+
+vxlan_config		:	GBP	NUM
+			{
+				$<obj>0->tunnel.vxlan.gbp = $2;
+			}
+			;
+
 tunnel_config		:	ID	NUM
 			{
 				$<obj>0->tunnel.id = $2;
@@ -5042,6 +5064,10 @@ tunnel_config		:	ID	NUM
 			{
 				$<obj>0->tunnel.type = TUNNEL_ERSPAN;
 			}
+			|	VXLAN	vxlan_block_alloc '{' vxlan_block '}'
+			{
+				$<obj>0->tunnel.type = TUNNEL_VXLAN;
+			}
 			;
 
 tunnel_block		:	/* empty */	{ $$ = $<obj>-1; }
diff --git a/src/rule.c b/src/rule.c
index 2557f4cc..0450851c 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -2043,6 +2043,16 @@ static void obj_print_data(const struct obj *obj,
 			}
 			nft_print(octx, "%s%s%s}",
 				  opts->nl, opts->tab, opts->tab);
+			break;
+		case TUNNEL_VXLAN:
+			nft_print(octx, "%s%s%svxlan {",
+				  opts->nl, opts->tab, opts->tab);
+			nft_print(octx, "%s%s%s%sgbp %u",
+				  opts->nl, opts->tab, opts->tab, opts->tab,
+				  obj->tunnel.vxlan.gbp);
+			nft_print(octx, "%s%s%s}",
+				  opts->nl, opts->tab, opts->tab);
+			break;
 		default:
 			break;
 		}
diff --git a/src/scanner.l b/src/scanner.l
index 9695d710..74ebca3b 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -827,6 +827,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 	"egress"		{ return EGRESS; }
 	"ingress"		{ return INGRESS; }
 	"path"			{ return PATH; }
+	"gbp"			{ return GBP; }
 }
 
 "notrack"		{ return NOTRACK; }
-- 
2.50.1

