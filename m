Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6ABA1586C9
	for <netfilter-devel@vger.kernel.org>; Mon, 19 Aug 2024 22:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724106355; cv=none; b=MM8papOUPazaYKygmshefIOW1v7PbXz5ks6pSl3ua3+N3UVprAUdZFT7dpOgOkGWiwRQxffIm/lCMDYiTkgvrCfzu8y9iXdRUjosmpKvwBqrGlItFxM7q/JlqzK3VGY6UfaqpmdUKUeeWsWGBkR/MicmUbFQlZWzFMGrgYor4dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724106355; c=relaxed/simple;
	bh=2fwUbI1Jzhl324ACcyLryirCYgQ4NVRA+WmEHhx2hBw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ongFB5+PichHCpCptlGXwKKlfqc7wv/cZXXivWepZVV3FPw2rDhYjDQkIeBdq7B8SAuRX7YjUxm7ry8hweZI8gd+0AFUCyJIsjG7BoDe7S7axrkH0902tbMDoZ8QxMcqUfA+F+bzXOFGyocP/KHhV7pCyQ7gblfgCkehQYc/+yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: sebastian.walz@secunet.com
Subject: [PATCH nft 4/4] parser_json: fix crash in json_parse_set_stmt_list
Date: Tue, 20 Aug 2024 00:23:04 +0200
Message-Id: <20240819222304.1041208-5-pablo@netfilter.org>
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

Due to missing `NULL`-check, there will be a segfault for invalid statements.

Fixes: 07958ec53830 ("json: add set statement list support")
Signed-off-by: Sebastian Walz (sivizius) <sebastian.walz@secunet.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/parser_json.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/src/parser_json.c b/src/parser_json.c
index d18188d81b3f..bbe3b1c59192 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -2380,7 +2380,7 @@ static void json_parse_set_stmt_list(struct json_ctx *ctx,
 				     json_t *stmt_json)
 {
 	struct list_head *head;
-	struct stmt *tmp;
+	struct stmt *stmt;
 	json_t *value;
 	size_t index;
 
@@ -2392,9 +2392,14 @@ static void json_parse_set_stmt_list(struct json_ctx *ctx,
 
 	head = stmt_list;
 	json_array_foreach(stmt_json, index, value) {
-		tmp = json_parse_stmt(ctx, value);
-		list_add(&tmp->list, head);
-		head = &tmp->list;
+		stmt = json_parse_stmt(ctx, value);
+		if (!stmt) {
+			json_error(ctx, "Parsing set statements array at index %zd failed.", index);
+			stmt_list_free(stmt_list);
+			return;
+		}
+		list_add(&stmt->list, head);
+		head = &stmt->list;
 	}
 }
 
-- 
2.30.2

