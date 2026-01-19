Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 289E0313E34
	for <netfilter-devel@vger.kernel.org>; Mon, 19 Jan 2026 14:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768831712; cv=none; b=dsxyytfGYnz9157FiHdXzeBipzzvvHvPDg/UnVPe1Lwtiz0LAPGnfZsRBJXrS/dRKCv1W2JIoalyw8DgR3T/872LUGr/Qd8OfwnQliiIm859BqkOCF44FIMxUiseLedeioeEw+CT+kuI9T2Gp0iWM/8vhl7kjSUTTTO59Ny9P0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768831712; c=relaxed/simple;
	bh=18cAXTiebtjaDGjGPrvgBtR7sdeH4//fANviQ5hjlrw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ixSoXVRjRBIjRv51kve1LNf5lAu1VSeytDn7578QxrN3A+ip2bL5wKldfqeWu7l1K3QIYoYIjp2OOmcA7VScOndfAyCldEv05o/c5xU46SFv2/eGBDlFBxeMdZsC7P9hdM7eqv3wo/DzWNyLwEvCpzzHVZlS7XBalfsiBNykkuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cj1kdnjy; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cj1kdnjy"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4801ea9bafdso9799055e9.3
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Jan 2026 06:08:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768831708; x=1769436508; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RVnZhHpGxEuDpZAQvx4bTYMZMmOscI5gqGqAKOn9GJI=;
        b=cj1kdnjyyoHAy3OMWYIPMUF6lAWD0Le254Ho3+MnR0mufaArwl17UV86FiSCljzJta
         d/8wlx9nlB97LSb6swPkfo6cLK+VHpOUW2qDmnMhFMmPUByR1yr6rt6Ztioo3QSZxPx1
         79sPlVAOqSq9x4c04MqtATgJDmkjqRRWVh96scXuW68FE1+/H7Mb5+z6EdXhDPbI2waZ
         Jr6vlV3aZmlOzN77jfoAepvhAWbmISR/UQdQXkeYLmutI6r/a0xwOj2kXKNuv5wnfViF
         Kqq77eK/SyweCV1koKa9IOCab857HZXiuTzv6IhaCXzkn7Eh1H8um9zolFk2TMpmrJDd
         MYyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768831708; x=1769436508;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RVnZhHpGxEuDpZAQvx4bTYMZMmOscI5gqGqAKOn9GJI=;
        b=tEojbITyXJRvgOxEAonQBFCTl2l/s5UEF7JNpyYAX/EWtJMPLR5Xw2lUTUeVn+ptwp
         Idh1hEiNfKY9amWSLZiZaxfvCOWeqNE6NOsiqXFCg5CPgfV2OVh+X5gTc5jasLXqho+7
         3uQnTt27/zDlBL8QKB+hphVb7difLWprpA9yeQnY5aIxosZVWpQ1kyqVac+Lvr8vgHW6
         v+duNnjXF4+1qjLyyyaTX7FaaO0P3zyPoA9kYsODdBHn++qxKNT4k7BxjiWsftRWqLl7
         IH74DKnnBbl7zuNGHFRC9CJVCTJP7A9g4QmoyO+Yj0PgLCCwBWCipmBtsI1VwD4PR1sB
         7sPQ==
X-Gm-Message-State: AOJu0YwMxJyvn0pNMRkFEx5mBudFC8avxxgsABoudvp2pnYY1ZE+KYjL
	rreCQzW1nocceyTNf+UWLovhX4A+FRS22hzZ91XEHGzsHZcN09v/7yzjKc74tw==
X-Gm-Gg: AZuq6aLy+rtBwDfRejMJt0XZbD24gbzR1I0ONbYMVY7Scg7uPslbFW9SpGiE7SE3lsY
	0p2b/ChEQDry9IePquZy+wjESHR3KyK98oPoZ88DiQZ0h7rOOklO1BDs5aMQi6JkhYHqXRE4/Um
	o9GhHz4t0DvpQZQr1Iir52uH2FjcQZxTmU8VIVJpetN69mjyUEzfe04Zc+90M5e/eIPhlReQIa1
	x6Udk2MagtyWEyFA71PQjJWy8stDbCL7erc8AZ/VFvomvlDJgBn/RvGEuL6VCFj4dDKOGvu/Brw
	Jws6SMjVnMrmSBxVo0j1RQEFG7S5CsaS1ZX4qJyVK3JIj03riIdCJEGLiBkzf2jif1uZ0kA/zMl
	AhfeuHFU5GHq/Ofd/sSKiujsXuBcQ37+LvfiAFnMYwYNUW40QZmo3Q41S5Pu/8oJuRwuucg4mfc
	dtD0i7ctt4qP4GuIRvTYTZbB3G93C0mivcQkduDUeDkje5weoaxxS/23S1LOyG54gjYBvO9epch
	1N4mw==
X-Received: by 2002:adf:ce89:0:b0:435:713c:d5f6 with SMTP id ffacd0b85a97d-435713cd8a9mr9079574f8f.45.1768831707974;
        Mon, 19 Jan 2026 06:08:27 -0800 (PST)
Received: from bluefin (2a02-8440-e509-8e1d-0fa7-f9cb-e455-a769.rev.sfr.net. [2a02:8440:e509:8e1d:fa7:f9cb:e455:a769])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4356999824csm23233975f8f.39.2026.01.19.06.08.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jan 2026 06:08:27 -0800 (PST)
From: Alexandre Knecht <knecht.alexandre@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: phil@nwl.cc,
	fw@strlen.de,
	Alexandre Knecht <knecht.alexandre@gmail.com>
Subject: [PATCH v5 1/3] parser_json: support handle for rule positioning in explicit JSON format
Date: Mon, 19 Jan 2026 15:08:11 +0100
Message-ID: <20260119140813.536515-2-knecht.alexandre@gmail.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20260119140813.536515-1-knecht.alexandre@gmail.com>
References: <20260119140813.536515-1-knecht.alexandre@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch enables handle-based rule positioning for JSON add/insert
commands by using a context flag to distinguish between explicit and
implicit command formats.

When processing JSON:
- Explicit commands like {"add": {"rule": ...}} set no flag, allowing
  handle fields to be converted to position for rule placement
- Implicit format (bare objects like {"rule": ...}, used in export/import)
  sets CTX_F_IMPLICIT flag, causing handles to be ignored for portability

This approach ensures that:
- Explicit rule adds with handles work for positioning
- Non-rule objects (tables, chains, sets, etc.) are unaffected
- Export/import remains compatible (handles ignored)

The semantics for explicit rule commands are:
  ADD with handle:    inserts rule AFTER the specified handle
  INSERT with handle: inserts rule BEFORE the specified handle

Implementation details:
- CTX_F_IMPLICIT flag (bit 10) marks implicit add commands
- CTX_F_EXPR_MASK uses inverse mask for future-proof expression flag filtering
- Handle-to-position conversion in json_parse_cmd_add_rule()
- Variables declared at function start per project style

Link: https://patchwork.ozlabs.org/project/netfilter-devel/patch/20251029224530.1962783-2-knecht.alexandre@gmail.com/
Suggested-by: Phil Sutter <phil@nwl.cc>
Suggested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Alexandre Knecht <knecht.alexandre@gmail.com>
---
 src/parser_json.c | 37 ++++++++++++++++++++++++++++++++++---
 1 file changed, 34 insertions(+), 3 deletions(-)

diff --git a/src/parser_json.c b/src/parser_json.c
index 7b4f3384..87266de6 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -51,6 +51,10 @@
 #define CTX_F_MAP	(1 << 7)	/* LHS of map_expr */
 #define CTX_F_CONCAT	(1 << 8)	/* inside concat_expr */
 #define CTX_F_COLLAPSED	(1 << 9)
+#define CTX_F_IMPLICIT	(1 << 10)	/* implicit add (export/import format) */
+
+/* Mask for flags that affect expression parsing context (all except command-level flags) */
+#define CTX_F_EXPR_MASK	(UINT32_MAX & ~(CTX_F_COLLAPSED | CTX_F_IMPLICIT))
 
 struct json_ctx {
 	struct nft_ctx *nft;
@@ -1725,10 +1729,14 @@ static struct expr *json_parse_expr(struct json_ctx *ctx, json_t *root)
 		return NULL;
 
 	for (i = 0; i < array_size(cb_tbl); i++) {
+		uint32_t expr_flags;
+
 		if (strcmp(type, cb_tbl[i].name))
 			continue;
 
-		if ((cb_tbl[i].flags & ctx->flags) != ctx->flags) {
+		/* Only check expression context flags, not command-level flags */
+		expr_flags = ctx->flags & CTX_F_EXPR_MASK;
+		if ((cb_tbl[i].flags & expr_flags) != expr_flags) {
 			json_error(ctx, "Expression type %s not allowed in context (%s).",
 				   type, ctx_flags_to_string(ctx));
 			return NULL;
@@ -3201,6 +3209,18 @@ static struct cmd *json_parse_cmd_add_rule(struct json_ctx *ctx, json_t *root,
 		h.index.id++;
 	}
 
+	/* For explicit add/insert/create commands, handle is used for positioning.
+	 * Convert handle to position for proper rule placement.
+	 * Skip this for implicit adds (export/import format).
+	 */
+	if (!(ctx->flags & CTX_F_IMPLICIT) &&
+	    !json_unpack(root, "{s:I}", "handle", &h.handle.id)) {
+		if (op == CMD_INSERT || op == CMD_ADD || op == CMD_CREATE) {
+			h.position.id = h.handle.id;
+			h.handle.id = 0;
+		}
+	}
+
 	rule = rule_alloc(int_loc, NULL);
 
 	json_unpack(root, "{s:s}", "comment", &comment);
@@ -4344,6 +4364,8 @@ static struct cmd *json_parse_cmd(struct json_ctx *ctx, json_t *root)
 	};
 	unsigned int i;
 	json_t *tmp;
+	uint32_t old_flags;
+	struct cmd *cmd;
 
 	for (i = 0; i < array_size(parse_cb_table); i++) {
 		tmp = json_object_get(root, parse_cb_table[i].key);
@@ -4352,8 +4374,17 @@ static struct cmd *json_parse_cmd(struct json_ctx *ctx, json_t *root)
 
 		return parse_cb_table[i].cb(ctx, tmp, parse_cb_table[i].op);
 	}
-	/* to accept 'list ruleset' output 1:1, try add command */
-	return json_parse_cmd_add(ctx, root, CMD_ADD);
+	/* to accept 'list ruleset' output 1:1, try add command
+	 * Mark as implicit to distinguish from explicit add commands.
+	 * This allows explicit {"add": {"rule": ...}} to use handle for positioning
+	 * while implicit {"rule": ...} (export format) ignores handles.
+	 */
+	old_flags = ctx->flags;
+	ctx->flags |= CTX_F_IMPLICIT;
+	cmd = json_parse_cmd_add(ctx, root, CMD_ADD);
+	ctx->flags = old_flags;
+
+	return cmd;
 }
 
 static int json_verify_metainfo(struct json_ctx *ctx, json_t *root)
-- 
2.51.1

