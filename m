Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2C07275AFB
	for <netfilter-devel@vger.kernel.org>; Wed, 12 Nov 2025 18:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762972957; cv=none; b=cQKKkxgn+zxUYxPfAdd+oxZ3FhNCZyllWdfP4IMvsYYKFV8EA/C+opDAhOhkxdAd5ghmltaidq98WG2z6Wya7MVOQ70tTPkKCn/mW6QAnbKN48vdYwTNYC5Wz15c7wgzmRFdupkmmS9F65wAZxKy5r0THUhUgyW2zE4s/8O0sMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762972957; c=relaxed/simple;
	bh=q/CUAtCQ0Juwe9KR0JPrqzfw9p0AyyeG+rKv9Flh4fY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jarg/N5pTQZE8o1D7jgR+QoKoKr58ZcoYwur7hWrtcRQLyhZv4igfn6G6QSJN6kYA4wI9PzoZ86GvGI+reENTFlSBqHgzHjzFfLT+mNCI2mZ+ATjD7jEGXqO+AiM4q7JVmuRAd5B5Uc0jHvzWUnClLCDj86rGHy9a2NrGUf4X0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Ad0+1y2x; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=OVjsXpE1; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Ad0+1y2x; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=OVjsXpE1; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Ad0+1y2x";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="OVjsXpE1";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Ad0+1y2x";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="OVjsXpE1"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 727CA21B97;
	Wed, 12 Nov 2025 18:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1762972942; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=5xS+b3X4KYQviNDDVSPo/AsvoXaG6hz5vNyLm1qX+qI=;
	b=Ad0+1y2xwd/newJbmfwdniKTJlYZ/S8XAZFy8C2AFCykSdfBkonuAbkafzaY9YyipFRS6r
	YED+X1VQ3kIecq2pRee8qUK8nBZkEeHQ5ilwZusfv7igDdjXCFUC2Au21to4AmNBgCV78t
	m1ZR3WQyAezNO9aWLdviIShNVUvSdHo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1762972942;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=5xS+b3X4KYQviNDDVSPo/AsvoXaG6hz5vNyLm1qX+qI=;
	b=OVjsXpE1YxrDftDjooCoYzx7DWfjrFqWsZJRRcGJmg9WSkxyKpsE2EJxb3T48koRafS/GP
	nIxSYbegtvcb76AA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1762972942; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=5xS+b3X4KYQviNDDVSPo/AsvoXaG6hz5vNyLm1qX+qI=;
	b=Ad0+1y2xwd/newJbmfwdniKTJlYZ/S8XAZFy8C2AFCykSdfBkonuAbkafzaY9YyipFRS6r
	YED+X1VQ3kIecq2pRee8qUK8nBZkEeHQ5ilwZusfv7igDdjXCFUC2Au21to4AmNBgCV78t
	m1ZR3WQyAezNO9aWLdviIShNVUvSdHo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1762972942;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=5xS+b3X4KYQviNDDVSPo/AsvoXaG6hz5vNyLm1qX+qI=;
	b=OVjsXpE1YxrDftDjooCoYzx7DWfjrFqWsZJRRcGJmg9WSkxyKpsE2EJxb3T48koRafS/GP
	nIxSYbegtvcb76AA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 29F0F3EA61;
	Wed, 12 Nov 2025 18:42:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id GBq6Bg7VFGn6LgAAD6G6ig
	(envelope-from <fmancera@suse.de>); Wed, 12 Nov 2025 18:42:22 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH nft] tunnel: add missing tunnel object list support
Date: Wed, 12 Nov 2025 19:42:04 +0100
Message-ID: <20251112184204.21907-1-fmancera@suse.de>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:helo];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 

Tunnel object listing support was missing. Now it is possible to list
tunnels. Example:

sudo nft list tunnel netdev x y
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

Fixes: a937a5dc02db ("src: add tunnel statement and expression support")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
 src/cache.c        | 4 ++++
 src/evaluate.c     | 3 +++
 src/parser_bison.y | 8 ++++++++
 src/scanner.l      | 1 -
 4 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/src/cache.c b/src/cache.c
index 09aa20bf..bb005c10 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -296,6 +296,10 @@ static unsigned int evaluate_cache_list(struct nft_ctx *nft, struct cmd *cmd,
 	case CMD_OBJ_SYNPROXYS:
 		obj_filter_setup(cmd, &flags, filter, NFT_OBJECT_SYNPROXY);
 		break;
+	case CMD_OBJ_TUNNEL:
+	case CMD_OBJ_TUNNELS:
+		obj_filter_setup(cmd, &flags, filter, NFT_OBJECT_TUNNEL);
+		break;
 	case CMD_OBJ_RULESET:
 	default:
 		flags |= NFT_CACHE_FULL;
diff --git a/src/evaluate.c b/src/evaluate.c
index 5a5e6cb5..4be52992 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -6279,6 +6279,8 @@ static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
 		return cmd_evaluate_list_obj(ctx, cmd, NFT_OBJECT_CT_EXPECT);
 	case CMD_OBJ_SYNPROXY:
 		return cmd_evaluate_list_obj(ctx, cmd, NFT_OBJECT_SYNPROXY);
+	case CMD_OBJ_TUNNEL:
+		return cmd_evaluate_list_obj(ctx, cmd, NFT_OBJECT_TUNNEL);
 	case CMD_OBJ_COUNTERS:
 	case CMD_OBJ_QUOTAS:
 	case CMD_OBJ_CT_HELPERS:
@@ -6289,6 +6291,7 @@ static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
 	case CMD_OBJ_SYNPROXYS:
 	case CMD_OBJ_CT_TIMEOUTS:
 	case CMD_OBJ_CT_EXPECTATIONS:
+	case CMD_OBJ_TUNNELS:
 		if (cmd->handle.table.name == NULL)
 			return 0;
 		if (!table_cache_find(&ctx->nft->cache.table_cache,
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 52730f71..3ceef794 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -1737,6 +1737,14 @@ list_cmd		:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_HOOKS, &$2, &@$, NULL);
 			}
+			|	TUNNELS	list_cmd_spec_any
+			{
+				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_TUNNELS, &$2, &@$, NULL);
+			}
+			|	TUNNEL	obj_spec	close_scope_tunnel
+			{
+				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_TUNNEL, &$2, &@$, NULL);
+			}
 			;
 
 basehook_device_name	:	DEVICE STRING
diff --git a/src/scanner.l b/src/scanner.l
index 8085c93b..df8e536b 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -404,7 +404,6 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 	"maps"			{ return MAPS; }
 	"secmarks"		{ return SECMARKS; }
 	"synproxys"		{ return SYNPROXYS; }
-	"tunnel"		{ return TUNNEL; }
 	"tunnels"		{ return TUNNELS; }
 	"hooks"			{ return HOOKS; }
 }
-- 
2.51.0

