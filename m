Received: from 3gy.de (3gy.de [202.61.255.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 618A02F6561
	for <netfilter-devel@vger.kernel.org>; Wed,  3 Dec 2025 13:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.61.255.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764768261; cv=none; b=lgNZbMAZf4itP3ppdvMuMyAKXE86uD4aZT5j5MZiWLgdCDoyO8LSfcmyVU6KPd2eZ7WOg2rgBuZ4bUxd0r4cvfWenlDrGDQhfzc/v2dA9AvVIfRWfXUg9LilMyHst4JG7W4OXsSZcdC8LbWj9OR0oHk08PmxFcBdFMN9BP9y044=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764768261; c=relaxed/simple;
	bh=jeAhfaZ53TMsxF4zhUYUHGNANCNO3oCM+l1Fcy+4MlE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=J8LLPU3nyKEQnK1qimn8buCFlrqIucOA8PzA1RAVvNywqs1dRx9ObW++vH880Z8mwWKuvC2s4JSqWUER3aqPlZ6obaZ+4ixC9sX45w9ADgoIfNAlr8BiEzpxy9fQNs2DFiAqHDcTo/XG3PwFfSZRu0MGw4pR2hYMR9alF42U2NA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=syscid.com; spf=pass smtp.mailfrom=syscid.com; dkim=pass (2048-bit key) header.d=syscid.com header.i=@syscid.com header.b=lYKoUZcK; arc=none smtp.client-ip=202.61.255.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=syscid.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=syscid.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=syscid.com header.i=@syscid.com header.b="lYKoUZcK"
Received: from localhost.localdomain (unknown [176.74.141.242])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-384) server-digest SHA384)
	(No client certificate requested)
	(Authenticated sender: georg@syscid.com)
	by 3gy.de (FREEDOM) with ESMTPSA id A8214442F1C0;
	Wed,  3 Dec 2025 14:18:36 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=syscid.com; s=light;
	t=1764767916; h=from:subject:date:message-id:to:cc:mime-version:
	 content-transfer-encoding; bh=+ftr3p6vO4wbsnAWy9WyaMg5/vly3/DZ43mzRthYKrw=;
	b=lYKoUZcK/H/SIcWuY2scm+A+Ll+VyT4MbnVVBeFfEvxQFGO/m1CjMuTTYlT+xS03ItT8pC
	K0d1Anl0IRQsXqHXS4bWv9uAs4UDXMpgyBg+/ZX9GNp2lUDP6WlXUxd3Lbd7EnE5WswxhS
	7JZX1rldisSJK6C5jJ3kcLZeoqAw0xtfdNGdKcxZ0DwQnDqykPkpfDuH6LQ9DL6Q1fo1UY
	AOrC4d/jo5HYQDBSy2yc+v9iXSS1feTN7Nv3617NB3pJQgxkYDkIgBSVp/txsT1WE9WfIz
	yEx4kUgVte0pwBM9EPjMJmFVUaFEcN/mfIv+hiCAVSstVe3FHuEUodIJ+wIImw==
From: Georg Pfuetzenreuter <georg@syscid.com>
To: netfilter-devel@vger.kernel.org
Cc: Georg Pfuetzenreuter <georg.pfuetzenreuter@suse.com>
Subject: [nftables PATCH] json: support element output
Date: Wed,  3 Dec 2025 14:17:36 +0100
Message-ID: <20251203131736.4036382-2-georg@syscid.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Last-TLS-Session-Version: TLSv1.3

From: Georg Pfuetzenreuter <georg.pfuetzenreuter@suse.com>

JSON was skipped for `get element` operations. Resolve this by
introducing JSON output handling for set elements - the structure is
kept close to what's already implemented for `list set`.

Signed-off-by: Georg Pfuetzenreuter <georg.pfuetzenreuter@suse.com>
---
 include/json.h |  1 +
 src/json.c     | 36 ++++++++++++++++++++++++++++++++++++
 src/rule.c     |  3 +++
 3 files changed, 40 insertions(+)

diff --git a/include/json.h b/include/json.h
index 3b8d045f87bb..8c15e92ed90f 100644
--- a/include/json.h
+++ b/include/json.h
@@ -98,6 +98,7 @@ json_t *optstrip_stmt_json(const struct stmt *stmt, struct output_ctx *octx);
 json_t *xt_stmt_json(const struct stmt *stmt, struct output_ctx *octx);
 
 int do_command_list_json(struct netlink_ctx *ctx, struct cmd *cmd);
+int do_get_setelems_json(struct netlink_ctx *ctx, struct cmd *cmd, bool reset);
 
 int nft_parse_json_buffer(struct nft_ctx *nft, const char *buf,
 			  struct list_head *msgs, struct list_head *cmds);
diff --git a/src/json.c b/src/json.c
index 9fb6d715a53d..e205c508e36b 100644
--- a/src/json.c
+++ b/src/json.c
@@ -2170,6 +2170,42 @@ int do_command_list_json(struct netlink_ctx *ctx, struct cmd *cmd)
 	return 0;
 }
 
+int do_get_setelems_json(struct netlink_ctx *ctx, struct cmd *cmd, bool reset)
+{
+	struct set *set, *new_set;
+	struct expr *init;
+	json_t *root = json_array();
+	int err;
+
+	set = cmd->elem.set;
+
+	if (set_is_non_concat_range(set))
+		init = get_set_intervals(set, cmd->expr);
+	else
+		init = cmd->expr;
+
+	new_set = set_clone(set);
+
+	json_array_insert_new(root, 0, generate_json_metainfo());
+
+	err = netlink_get_setelem(ctx, &cmd->handle, &cmd->location,
+				  cmd->elem.set, new_set, init, reset);
+	if (err >= 0)
+		json_array_append_new(root, set_print_json(&ctx->nft->output, new_set));
+
+	if (set_is_non_concat_range(set))
+		expr_free(init);
+
+	set_free(new_set);
+
+	root = nft_json_pack("{s:o}", "nftables", root);
+	json_dumpf(root, ctx->nft->output.output_fp, 0);
+	json_decref(root);
+	fprintf(ctx->nft->output.output_fp, "\n");
+	fflush(ctx->nft->output.output_fp);
+	return 0;
+}
+
 static void monitor_print_json(struct netlink_mon_handler *monh,
 			       const char *cmd, json_t *obj)
 {
diff --git a/src/rule.c b/src/rule.c
index 8f8b77f1e883..5d3382632728 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -2681,6 +2681,9 @@ static int do_get_setelems(struct netlink_ctx *ctx, struct cmd *cmd, bool reset)
 	struct expr *init;
 	int err;
 
+	if (nft_output_json(&ctx->nft->output))
+		return do_get_setelems_json(ctx, cmd, reset);
+
 	set = cmd->elem.set;
 
 	/* Create a list of elements based of what we got from command line. */
-- 
2.52.0

