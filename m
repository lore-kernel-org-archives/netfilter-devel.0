Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 582B43A4F36
	for <netfilter-devel@vger.kernel.org>; Tue, 20 Jan 2026 19:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768938802; cv=none; b=hIJBUkI6eDdNEDOWOgR2r0naee/9t1omw76m1qCiPt8jFF9iMyb8LLFb9MqZYi/bANUYw1INMd/fDRK8G//jP0eKj2M6B/zrIOC+/+lIYjKlGYpNVcoZUyR48MWyjl6tcH1NqBkarUYXzmG/jYrqKgAZy2xim2rZ1g6bn5jbAS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768938802; c=relaxed/simple;
	bh=UjHH5MCFZeSocjkv9BSfBrZKoudUsKxlVWwOmN8qeSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Opsdg7k6L4OaK3RDnLe4a3E8EZDfCUakyL7KIu9Gxg7AeGGZ1bULJT2wN8GfbtUqx6Hub4BkQuPQ2NOtgeuCy2A3SYIYK+ecygSl6Oe5ewlaTwxgubVZtwwRpOtY14qxeRWpRGzX4Qv96A1brSUg+9iAPy+BxxKyz3uKM+wGCIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W76AQBcn; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W76AQBcn"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-47d6a1f08bbso20990655e9.2
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Jan 2026 11:53:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768938798; x=1769543598; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2Bhim7B8njEtHyS+0qFwQQU4Ve1tBK3Z6/T6pUYUl38=;
        b=W76AQBcn/jv6znagcO2vITt+kUdrF+v82UOCEXF+pGtfffyhJxdlDUxu9cjjAqKdDT
         pw3gO0cI2c1I+3h4ZNu/arddQsY1kJqWmaXNct3HQg9Ojra7lQDDChg5K+v12+in/re7
         l0yq3C3vZwpkUQKo+XumzRZRpVfV1DmX4ukM0qTW8wjdZK1yZ4wmkRdti+tWvUPElJxL
         APaIgPaptxLMBJw+xUAX8cZgqsqhERY/Li+5y5TrWoJx7sm+CUD2c0kPCFC4tOrs/8mB
         N785viUeBh0/F3c0VByLwqOO4wZ8WTmMZirpitUtDGILsjNxNy5fMp4aD3KS7t3Gt7q2
         wZig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768938798; x=1769543598;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2Bhim7B8njEtHyS+0qFwQQU4Ve1tBK3Z6/T6pUYUl38=;
        b=evRtr7Mxg0qyo9zbzRLeu6dABvvjYLRjycKBesS71e2GCN1kuZOPYVN41rUsTLtBGv
         bOMGmuIPG38f9OB8UiFj/e8TOtTQYwLqlh8i12F0pR8WtMGEvToVYERpDAbtezAz9O0r
         PGPfcjF8d+5dY/l/5icjVjhe3pie5wskSOTRnRO3bkpF5vStKPzIHbusv3iPgQSX8AHT
         +V7MyzjOaOuw9Vv4tLDBVZ2rySeH6pbktZHdejQyhPws+52OYJ2BZs/z16E7eJynLGM8
         UAPzp7HC/HAA7QYbb35So42e1NTGfp5uGIEzAJVYflBNr2N8nYz6Rld4UvMnDAqtPEgt
         vU/g==
X-Gm-Message-State: AOJu0YyJR4it7zl2u/8fr+Ql437DT1upyANHCQVe5rVf5PNrcebWSH3Z
	w62LupvdakIGQOxSxLxrPkGZ/Vg1UVvlTTl3ScPctqRmMWANy/nvP5JAuiBdKA==
X-Gm-Gg: AY/fxX6UyL2x5vTrUKM4LEwmcSJx0CDjjdHfcqkpkar848tLPGW9Elm5oLcGd93gJ5W
	zRORPsqQ2YtSsE/+1GEBKgcSUH6fgkGqzPV7dDxnKluYePcVEFQt9tYZpaR80cm7I9HyLtFXFNv
	L5xia+9n+RxFVlxuuj1t6rcDQTMTaEiHN1gkQDxYbSxtj7viQCMeFY6uEOKhdhGkDSFdWX9yteA
	lvqGZLFh348zBlGdR6N4TKysqnoz7X58Ipn6H3OKkWqA2ggz2tgkT9TPgTZ4hRqkHXCHeaBmCCx
	YWA83Qw6wSHTJ0fSyZg4017I3pbpJqTcZUiI1CwLJmPNnCOnMt53fXSJaBrnQ1AUNAQgpCk5zBF
	otukjIdp2qSniLCMJL253PVjphkv1/5vMZfc4UKar1faYawc3X2tpfYPfvVuHUSY+1Ewh2MK8lL
	RO9pDF2MbMIB4EwIeTwqmo
X-Received: by 2002:a05:600c:6091:b0:480:1a9a:e571 with SMTP id 5b1f17b1804b1-4801eb04160mr202649745e9.22.1768938797930;
        Tue, 20 Jan 2026 11:53:17 -0800 (PST)
Received: from bluefin ([2a01:cb1c:8441:2b00:c694:3c2c:878b:f4c0])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47f4289b789sm320114165e9.1.2026.01.20.11.53.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jan 2026 11:53:17 -0800 (PST)
From: Alexandre Knecht <knecht.alexandre@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: phil@nwl.cc,
	fw@strlen.de,
	Alexandre Knecht <knecht.alexandre@gmail.com>
Subject: [PATCH v6 1/3] parser_json: support handle for rule positioning in explicit JSON format
Date: Tue, 20 Jan 2026 20:53:01 +0100
Message-ID: <20260120195303.1987192-2-knecht.alexandre@gmail.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20260120195303.1987192-1-knecht.alexandre@gmail.com>
References: <20260120195303.1987192-1-knecht.alexandre@gmail.com>
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
 src/parser_json.c | 36 +++++++++++++++++++++++++++++++++---
 1 file changed, 33 insertions(+), 3 deletions(-)

diff --git a/src/parser_json.c b/src/parser_json.c
index 7b4f3384..67e4f2c0 100644
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
@@ -3201,6 +3209,17 @@ static struct cmd *json_parse_cmd_add_rule(struct json_ctx *ctx, json_t *root,
 		h.index.id++;
 	}
 
+	/* For explicit add/insert/create commands, handle is used for positioning.
+	 * Convert handle to position for proper rule placement.
+	 * Skip this for implicit adds (export/import format).
+	 */
+	if (!(ctx->flags & CTX_F_IMPLICIT) &&
+	    (op == CMD_INSERT || op == CMD_ADD || op == CMD_CREATE) &&
+	    !json_unpack(root, "{s:I}", "handle", &h.handle.id)) {
+		h.position.id = h.handle.id;
+		h.handle.id = 0;
+	}
+
 	rule = rule_alloc(int_loc, NULL);
 
 	json_unpack(root, "{s:s}", "comment", &comment);
@@ -4342,6 +4361,8 @@ static struct cmd *json_parse_cmd(struct json_ctx *ctx, json_t *root)
 		//{ "monitor", CMD_MONITOR, json_parse_cmd_monitor },
 		//{ "describe", CMD_DESCRIBE, json_parse_cmd_describe }
 	};
+	uint32_t old_flags;
+	struct cmd *cmd;
 	unsigned int i;
 	json_t *tmp;
 
@@ -4352,8 +4373,17 @@ static struct cmd *json_parse_cmd(struct json_ctx *ctx, json_t *root)
 
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

