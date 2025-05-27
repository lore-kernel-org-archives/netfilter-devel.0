Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A3C71E5B7E
	for <netfilter-devel@vger.kernel.org>; Tue, 27 May 2025 19:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748375735; cv=none; b=WhZgDH420teKSHy/TNPuf/zXhVMdpsih5G2TdkCih2MzFPk79fktZPIyXnni9hSg5Ciyye+LAWicPzQViChkd5pTDIyvF3pkAlcuMjX9XKM2fRA0P+fCoBQXYKsxjEJVsUV3fimB/rDS8QMzoGCDMpJCiOvB1w8pFXvvV12qwHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748375735; c=relaxed/simple;
	bh=N+jyX5FdYSkM2B39D82Hflsk+hewmW4xoxxn14KWKlw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jxLy/C9y++9WHPkQWQ0zksMSOO9x39R88baiIIGJLfrXDXu6d0cY4qNCMa4RGhgado4EQA40dRUmrnd5NzFCEFwDZjjKidPM4FjbgRpACs3xTCqskcpjHWoHxjhSbjjY0qziAUlk0JOg8IQcC/Z4kek4oG7/XLAVkLKPbLm0wic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=QXPiNaja; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=oqwBKvqv; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=FinatxYf; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=IZ/z0Ay4; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="QXPiNaja";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="oqwBKvqv";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="FinatxYf";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="IZ/z0Ay4"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0A4D62118D;
	Tue, 27 May 2025 19:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1748375731; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=utwDyv7JdaafkzKzbHgV0ceQAKtPTpa/icHZtDE+I/8=;
	b=QXPiNajalHyJamDDXS42bPShjlwYI2ZsJuQSvyQ/yWIBD07RySVOfDtKQ45c3alzOjRG1u
	+YLJO4gt51tdfiqLJH27bXDmRDeSN19OJIP/lB4DpdQPIg4BgnhNn4qMEQ17Hjoq58nQR3
	Edtt7bByAj8rAmIbdAgTPpK63XG77jY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1748375731;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=utwDyv7JdaafkzKzbHgV0ceQAKtPTpa/icHZtDE+I/8=;
	b=oqwBKvqvF90J2uckkURdnvXfWQC+CoyPkhw43Zuvmw31b9HbzpngfTArLFx0kscqq9M/lT
	gaPOdRLcMAbjCqAw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=FinatxYf;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="IZ/z0Ay4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1748375730; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=utwDyv7JdaafkzKzbHgV0ceQAKtPTpa/icHZtDE+I/8=;
	b=FinatxYfEqBuGd3n6UoGbhX73FoeLMx9X0eVewjMHCvQ+AR6gTS1lm7McRSqo7R8bicV34
	/jswksh/lWn8l/h1MOYmGCY/CvN0e8MZi61ggi5oZHUzHXpXoWLMEUPMIlBCcDGBwtEO7q
	Km8wdNeqwlNkPX5RV+pXUiTxk8w0Hpw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1748375730;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=utwDyv7JdaafkzKzbHgV0ceQAKtPTpa/icHZtDE+I/8=;
	b=IZ/z0Ay4kPKWw9xiJgT8owtBNGX7ZV1vlG7TIPsqTUHpjMiBkrZgIfrw3VaX3iQIGP3xG5
	E7LgwstJZIKSEcDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B5708136E0;
	Tue, 27 May 2025 19:55:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wKQNKbEYNmhJGgAAD6G6ig
	(envelope-from <fmancera@suse.de>); Tue, 27 May 2025 19:55:29 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/7 nft] tunnel: add erspan support
Date: Tue, 27 May 2025 21:54:39 +0200
Message-ID: <ae88d3525c46a523e1b8a0b97450225804033014.1748374810.git.fmancera@suse.de>
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
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:mid,suse.de:dkim];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:25478, ipnet:::/0, country:RU];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 0A4D62118D
X-Spam-Flag: NO
X-Spam-Level: 
X-Spam-Score: -3.01

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
---
 include/rule.h     | 18 ++++++++++++++++++
 src/mnl.c          | 24 ++++++++++++++++++++++++
 src/netlink.c      | 16 ++++++++++++++++
 src/parser_bison.y | 46 +++++++++++++++++++++++++++++++++++++++++++++-
 src/rule.c         | 26 ++++++++++++++++++++++++++
 src/scanner.l      |  5 +++++
 6 files changed, 134 insertions(+), 1 deletion(-)

diff --git a/include/rule.h b/include/rule.h
index c10db949..2723af38 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -490,6 +490,11 @@ struct secmark {
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
@@ -498,6 +503,19 @@ struct tunnel {
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
index ee46892e..34d919ea 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -1580,6 +1580,30 @@ int mnl_nft_obj_add(struct netlink_ctx *ctx, struct cmd *cmd,
 						   nld.value, nld.len);
 			}
 		}
+		switch (obj->tunnel.type) {
+		case TUNNEL_ERSPAN:
+			nftnl_obj_set_u32(nlo,
+					  NFTNL_OBJ_TUNNEL_ERSPAN_VERSION,
+					  obj->tunnel.erspan.version);
+			switch (obj->tunnel.erspan.version) {
+			case 1:
+				nftnl_obj_set_u32(nlo,
+						  NFTNL_OBJ_TUNNEL_ERSPAN_V1_INDEX,
+						  obj->tunnel.erspan.v1.index);
+				break;
+			case 2:
+				nftnl_obj_set_u8(nlo,
+						 NFTNL_OBJ_TUNNEL_ERSPAN_V2_DIR,
+						 obj->tunnel.erspan.v2.direction);
+				nftnl_obj_set_u8(nlo,
+						 NFTNL_OBJ_TUNNEL_ERSPAN_V2_HWID,
+						 obj->tunnel.erspan.v2.hwid);
+				break;
+			}
+			break;
+		case TUNNEL_UNSPEC:
+			break;
+		}
 		break;
 	default:
 		BUG("Unknown type %d\n", obj->type);
diff --git a/src/netlink.c b/src/netlink.c
index ccf43580..086846ce 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1885,6 +1885,22 @@ struct obj *netlink_delinearize_obj(struct netlink_ctx *ctx,
 			obj->tunnel.dst =
 				netlink_obj_tunnel_parse_addr(nlo, NFTNL_OBJ_TUNNEL_IPV6_DST);
 		}
+		if (nftnl_obj_is_set(nlo, NFTNL_OBJ_TUNNEL_ERSPAN_VERSION)) {
+			obj->tunnel.type = TUNNEL_ERSPAN;
+			obj->tunnel.erspan.version = nftnl_obj_get_u32(nlo, NFTNL_OBJ_TUNNEL_ERSPAN_VERSION);
+		}
+		if (nftnl_obj_is_set(nlo, NFTNL_OBJ_TUNNEL_ERSPAN_V1_INDEX)) {
+			obj->tunnel.type = TUNNEL_ERSPAN;
+			obj->tunnel.erspan.v1.index = nftnl_obj_get_u8(nlo, NFTNL_OBJ_TUNNEL_ERSPAN_V1_INDEX);
+		}
+		if (nftnl_obj_is_set(nlo, NFTNL_OBJ_TUNNEL_ERSPAN_V2_DIR)) {
+			obj->tunnel.type = TUNNEL_ERSPAN;
+			obj->tunnel.erspan.v2.direction = nftnl_obj_get_u8(nlo, NFTNL_OBJ_TUNNEL_ERSPAN_V2_DIR);
+		}
+		if (nftnl_obj_is_set(nlo, NFTNL_OBJ_TUNNEL_ERSPAN_V2_HWID)) {
+			obj->tunnel.type = TUNNEL_ERSPAN;
+			obj->tunnel.erspan.v2.hwid = nftnl_obj_get_u8(nlo, NFTNL_OBJ_TUNNEL_ERSPAN_V2_HWID);
+		}
 		break;
 	default:
 		netlink_io_error(ctx, NULL, "Unknown object type %u", type);
diff --git a/src/parser_bison.y b/src/parser_bison.y
index c4694c77..9ba6e8f2 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -606,6 +606,9 @@ int nft_lex(void *, void *, void *);
 %token NEVER			"never"
 
 %token TUNNEL			"tunnel"
+%token ERSPAN			"erspan"
+%token EGRESS			"egress"
+%token INGRESS			"ingress"
 
 %token COUNTERS			"counters"
 %token QUOTAS			"quotas"
@@ -764,7 +767,7 @@ int nft_lex(void *, void *, void *);
 %type <flowtable>		flowtable_block_alloc flowtable_block
 %destructor { flowtable_free($$); }	flowtable_block_alloc
 
-%type <obj>			obj_block_alloc counter_block quota_block ct_helper_block ct_timeout_block ct_expect_block limit_block secmark_block synproxy_block tunnel_block
+%type <obj>			obj_block_alloc counter_block quota_block ct_helper_block ct_timeout_block ct_expect_block limit_block secmark_block synproxy_block tunnel_block erspan_block erspan_block_alloc
 %destructor { obj_free($$); }	obj_block_alloc
 
 %type <list>			stmt_list stateful_stmt_list set_elem_stmt_list
@@ -4948,6 +4951,43 @@ limit_obj		:	/* empty */
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
@@ -4976,6 +5016,10 @@ tunnel_config		:	ID	NUM
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
index 1cea0d48..8acb6346 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -2005,6 +2005,32 @@ static void obj_print_data(const struct obj *obj,
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
index 232bce67..c5c394b7 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -817,6 +817,11 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
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
2.49.0

