Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97CE41FFC59
	for <netfilter-devel@vger.kernel.org>; Tue, 27 May 2025 19:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748375749; cv=none; b=b4qiYHwbKoN4b5yyke5tE1YgMNJ8yfHaHupfgNHfN5AHD0n9QcOVOHV8pOft0zxJ0VuwluqC6UVxymKM23Y96n197vHri1/TewQycLNnUMGjrAgDVq9GpGKFmIyGXJGVAx0QeoGA12rBRalxWVVuIltqm/+mfj4E+sFczLbVCL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748375749; c=relaxed/simple;
	bh=9YcySY6g2Rm/7CS/nWHaufLlLLfN4OLE9eh7jHgloMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dD0UKXRyxIVUuWeAq73zwaFNZAREuNKCVPzo25zDj/6L0WlWET2HtW+QVxerRAuib187UySlre3bwz1SpY+ZNZGRpkf0Gk0cfrxsllOZTfaH9xWAcb1c55c5YGrqFNUgd8s56ECYa5Q0rpeDm0uCWP3zO5aLhzFKwPRo6SDaYNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2682C21E0F;
	Tue, 27 May 2025 19:55:35 +0000 (UTC)
Authentication-Results: smtp-out1.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D0C70136E0;
	Tue, 27 May 2025 19:55:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id uJ9uL7YYNmhJGgAAD6G6ig
	(envelope-from <fmancera@suse.de>); Tue, 27 May 2025 19:55:34 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH 4/7 nft] tunnel: add vxlan support
Date: Tue, 27 May 2025 21:54:41 +0200
Message-ID: <5a8edcd2cd353faaff464134a4e8fc288bf1688e.1748374810.git.fmancera@suse.de>
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
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[];
	ASN(0.00)[asn:25478, ipnet:::/0, country:RU]
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spam-Level: 
X-Rspamd-Queue-Id: 2682C21E0F

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
 src/mnl.c          |  5 +++++
 src/netlink.c      |  4 ++++
 src/parser_bison.y | 28 +++++++++++++++++++++++++++-
 src/rule.c         | 10 ++++++++++
 src/scanner.l      |  1 +
 6 files changed, 51 insertions(+), 1 deletion(-)

diff --git a/include/rule.h b/include/rule.h
index 2723af38..f7872267 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -493,6 +493,7 @@ struct secmark {
 enum tunnel_type {
 	TUNNEL_UNSPEC = 0,
 	TUNNEL_ERSPAN,
+	TUNNEL_VXLAN,
 };
 
 struct tunnel {
@@ -515,6 +516,9 @@ struct tunnel {
 				uint8_t		hwid;
 			} v2;
 		} erspan;
+		struct {
+			uint32_t	gbp;
+		} vxlan;
 	};
 };
 
diff --git a/src/mnl.c b/src/mnl.c
index 34d919ea..302bb5ce 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -1601,6 +1601,11 @@ int mnl_nft_obj_add(struct netlink_ctx *ctx, struct cmd *cmd,
 				break;
 			}
 			break;
+		case TUNNEL_VXLAN:
+			nftnl_obj_set_u32(nlo,
+					  NFTNL_OBJ_TUNNEL_VXLAN_GBP,
+					  obj->tunnel.vxlan.gbp);
+			break;
 		case TUNNEL_UNSPEC:
 			break;
 		}
diff --git a/src/netlink.c b/src/netlink.c
index 086846ce..9d1984a7 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1901,6 +1901,10 @@ struct obj *netlink_delinearize_obj(struct netlink_ctx *ctx,
 			obj->tunnel.type = TUNNEL_ERSPAN;
 			obj->tunnel.erspan.v2.hwid = nftnl_obj_get_u8(nlo, NFTNL_OBJ_TUNNEL_ERSPAN_V2_HWID);
 		}
+		if (nftnl_obj_is_set(nlo, NFTNL_OBJ_TUNNEL_VXLAN_GBP)) {
+			obj->tunnel.type = TUNNEL_VXLAN;
+			obj->tunnel.vxlan.gbp = nftnl_obj_get_u32(nlo, NFTNL_OBJ_TUNNEL_VXLAN_GBP);
+		}
 		break;
 	default:
 		netlink_io_error(ctx, NULL, "Unknown object type %u", type);
diff --git a/src/parser_bison.y b/src/parser_bison.y
index e533370a..53c2dc2b 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -611,6 +611,7 @@ int nft_lex(void *, void *, void *);
 %token ERSPAN			"erspan"
 %token EGRESS			"egress"
 %token INGRESS			"ingress"
+%token GBP			"gbp"
 
 %token COUNTERS			"counters"
 %token QUOTAS			"quotas"
@@ -769,7 +770,7 @@ int nft_lex(void *, void *, void *);
 %type <flowtable>		flowtable_block_alloc flowtable_block
 %destructor { flowtable_free($$); }	flowtable_block_alloc
 
-%type <obj>			obj_block_alloc counter_block quota_block ct_helper_block ct_timeout_block ct_expect_block limit_block secmark_block synproxy_block tunnel_block erspan_block erspan_block_alloc
+%type <obj>			obj_block_alloc counter_block quota_block ct_helper_block ct_timeout_block ct_expect_block limit_block secmark_block synproxy_block tunnel_block erspan_block erspan_block_alloc vxlan_block vxlan_block_alloc
 %destructor { obj_free($$); }	obj_block_alloc
 
 %type <list>			stmt_list stateful_stmt_list set_elem_stmt_list
@@ -5001,6 +5002,27 @@ erspan_config		:	HDRVERSION	NUM
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
@@ -5033,6 +5055,10 @@ tunnel_config		:	ID	NUM
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
index 8acb6346..e020cfb9 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -2027,6 +2027,16 @@ static void obj_print_data(const struct obj *obj,
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
index 7d1fae0c..77c84923 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -823,6 +823,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 	"egress"		{ return EGRESS; }
 	"ingress"		{ return INGRESS; }
 	"path"			{ return PATH; }
+	"gbp"			{ return GBP; }
 }
 
 "notrack"		{ return NOTRACK; }
-- 
2.49.0

