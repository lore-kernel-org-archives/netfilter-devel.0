Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDD8B126F05
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Mar 2024 12:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709814766; cv=none; b=pcCJjoPO0JU0E359tctJrFvVamduomxZEDDrgVGYtzVbuUBsAPgsIhHoC++29vYPYKPhKiJ6tDX5L6x+w4aj8AKFu5hdY3C13T0z/xXxqlrT/s6/NWMxNQAahtK+R+3wuUdS9tFeLTmR8NTPrAPT1mOWgUX9NR1t6aaZWHCPiAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709814766; c=relaxed/simple;
	bh=aGYCoYd0M3XnXowY8IzHF4YZm+55eZw22bkSQKd7lKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YQAcsz8QlTZdK0aCXEeaQhOtf2GwT/LVBMI7I+ZfbouwNt3xLBa4pxiqkf/5BJl2Twq0ZLsLDkGqmyeNrdB2zXc0lR5NjQnMmU9kYKRs6nBAu0s8rGQ7kZnV2hGwFal5G41ZqEZFt+Or0uLMjb35I5FaJJmotZMXNdXMuHvLLBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1riCvT-00072e-7l; Thu, 07 Mar 2024 13:32:43 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: phil@nwl.cc,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 1/5] parser_json: move some code around
Date: Thu,  7 Mar 2024 13:26:31 +0100
Message-ID: <20240307122640.29507-2-fw@strlen.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240307122640.29507-1-fw@strlen.de>
References: <20240307122640.29507-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Place the helper earlier, next pach will call this from json_parse_cmd.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/parser_json.c | 44 ++++++++++++++++++++++----------------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/src/parser_json.c b/src/parser_json.c
index ff52423af4d7..d4cc2c1e4e9c 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -63,6 +63,17 @@ struct json_ctx {
 #define is_DTYPE(ctx)	(ctx->flags & CTX_F_DTYPE)
 #define is_SET_RHS(ctx)	(ctx->flags & CTX_F_SET_RHS)
 
+struct json_cmd_assoc {
+	struct json_cmd_assoc *next;
+	struct hlist_node hnode;
+	const struct cmd *cmd;
+	json_t *json;
+};
+
+#define CMD_ASSOC_HSIZE		512
+static struct hlist_head json_cmd_assoc_hash[CMD_ASSOC_HSIZE];
+static struct json_cmd_assoc *json_cmd_assoc_list;
+
 static char *ctx_flags_to_string(struct json_ctx *ctx)
 {
 	static char buf[1024];
@@ -4089,6 +4100,17 @@ static struct cmd *json_parse_cmd_rename(struct json_ctx *ctx,
 	return cmd;
 }
 
+static void json_cmd_assoc_add(json_t *json, const struct cmd *cmd)
+{
+	struct json_cmd_assoc *new = xzalloc(sizeof *new);
+
+	new->json	= json;
+	new->cmd	= cmd;
+	new->next	= json_cmd_assoc_list;
+
+	json_cmd_assoc_list = new;
+}
+
 static struct cmd *json_parse_cmd(struct json_ctx *ctx, json_t *root)
 {
 	struct {
@@ -4141,17 +4163,6 @@ static int json_verify_metainfo(struct json_ctx *ctx, json_t *root)
 	return 0;
 }
 
-struct json_cmd_assoc {
-	struct json_cmd_assoc *next;
-	struct hlist_node hnode;
-	const struct cmd *cmd;
-	json_t *json;
-};
-
-#define CMD_ASSOC_HSIZE		512
-static struct hlist_head json_cmd_assoc_hash[CMD_ASSOC_HSIZE];
-static struct json_cmd_assoc *json_cmd_assoc_list;
-
 static void json_cmd_assoc_free(void)
 {
 	struct json_cmd_assoc *cur;
@@ -4173,17 +4184,6 @@ static void json_cmd_assoc_free(void)
 	}
 }
 
-static void json_cmd_assoc_add(json_t *json, const struct cmd *cmd)
-{
-	struct json_cmd_assoc *new = xzalloc(sizeof *new);
-
-	new->json	= json;
-	new->cmd	= cmd;
-	new->next	= json_cmd_assoc_list;
-
-	json_cmd_assoc_list = new;
-}
-
 static json_t *seqnum_to_json(const uint32_t seqnum)
 {
 	struct json_cmd_assoc *cur;
-- 
2.43.0

