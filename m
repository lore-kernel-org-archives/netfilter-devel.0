Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46FFD18951A
	for <netfilter-devel@vger.kernel.org>; Mon, 19 Aug 2024 22:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724106354; cv=none; b=X9Gcjen44Dlkjq/e+oQVUHq4INZ5bzRUxd+FhPIkTxBwnMuQpkTo/2ty3Bubqc+lp32So/Xb4Eb2zTOYbJMl5fNtdb5HHBDJlXRA/c1fp6Ia+lhaAuPd9Kc1fUfYxJUsMDQ5sQE1V2LWuetCZ+ws4+9olAzph6izyuRhRPcigLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724106354; c=relaxed/simple;
	bh=Vq6bvja97p2dT7IAP3b7VgvK8X3A1Z8iaAJDjevUxh4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Om48OFCXcgSzwbNYr1hgy2qBpslp4qWRG9eHZl1zG7ZlxAaBPZ8amQhOgQubzg4PkpfF0xWRRJSnkO2mf4tagbptkDHGmrNGGfJ66/GioxyE5CoyHMMgxlNWiEDlXBGhlwbBmD1FdfBBLYRJgMWG19z6hujbGkU79FhMimycFmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: sebastian.walz@secunet.com
Subject: [PATCH nft 1/4] parser_json: release buffer returned by json_dumps
Date: Tue, 20 Aug 2024 00:23:01 +0200
Message-Id: <20240819222304.1041208-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240819222304.1041208-1-pablo@netfilter.org>
References: <20240819222304.1041208-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Sebastian Walz (sivizius)" <sebastian.walz@secunet.com>

The signature of `json_dumps` is:

`char *json_dumps(const json_t *json, size_t flags)`:

It will return a pointer to an owned string, the caller must free it.
However, `json_error` just borrows the string to format it as `%s`, but
after printing the formatted error message, the pointer to the string is
lost and thus never freed.

Fixes: 586ad210368b ("libnftables: Implement JSON parser")
Signed-off-by: Sebastian Walz (sivizius) <sebastian.walz@secunet.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/parser_json.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/src/parser_json.c b/src/parser_json.c
index 4912d3608b2b..fc20fe2969f7 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -181,8 +181,11 @@ static int json_unpack_stmt(struct json_ctx *ctx, json_t *root,
 	assert(value);
 
 	if (json_object_size(root) != 1) {
+		const char *dump = json_dumps(root, 0);
+
 		json_error(ctx, "Malformed object (too many properties): '%s'.",
-			   json_dumps(root, 0));
+			   dump);
+		free_const(dump);
 		return 1;
 	}
 
@@ -3378,8 +3381,10 @@ static struct cmd *json_parse_cmd_add_set(struct json_ctx *ctx, json_t *root,
 		} else if ((set->data = json_parse_dtype_expr(ctx, tmp))) {
 			set->flags |= NFT_SET_MAP;
 		} else {
-			json_error(ctx, "Invalid map type '%s'.",
-				   json_dumps(tmp, 0));
+			const char *dump = json_dumps(tmp, 0);
+
+			json_error(ctx, "Invalid map type '%s'.", dump);
+			free_const(dump);
 			set_free(set);
 			handle_free(&h);
 			return NULL;
-- 
2.30.2

