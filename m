Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EDC08F6D
	for <netfilter-devel@vger.kernel.org>; Mon, 10 Jun 2024 17:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718041250; cv=none; b=tHL6n082B+8EO4TDE9JYlaAjUwX35l4Gmky1+toEc1xjwsuh+DvJadm3uJvE58glKyaQ/io7F2lYJWS5WJE/ojyH26/vJVhJTWM2V76xv5yBg0mS9zikldIhFphn0k5aTzauNVXvRDiRGwGEJu68coqk7MbY+wiaJ0yJNeFTfts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718041250; c=relaxed/simple;
	bh=iN72YaT28uzTb7f2CILAc3niIVMz6fxaE+Z/6mZXhFk=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=ky7LBZY3SAl066EszAa+TZuqTbvW7T8bWsFZPUvBzy22UtsV+GSXfovdDVL7arTksEk34Fjl9/DUA5rrTH35We8+mReH7/GVYaQ80X3y/+BwUpsObdqwz6ImRf3AlDdKJQ5ymCviZEksFsdaCLJwiVajlkdrqX7j83eQR68qAeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft] cmd: provide better hint if chain is already declared with different type/hook/priority
Date: Mon, 10 Jun 2024 19:40:42 +0200
Message-Id: <20240610174042.12207-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Display the following error in such case:

  ruleset.nft:7:9-52: Error: Chain "input" already exists in table ip 'filter' with different declaration
          type filter hook postrouting priority filter;
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

instead of reporting a misleading unsupported chain type.

Fixes: 573788e05363 ("src: improve error reporting for unsupported chain type")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/cmd.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/src/cmd.c b/src/cmd.c
index 14cb1b5172cd..d6b1d844ed8d 100644
--- a/src/cmd.c
+++ b/src/cmd.c
@@ -256,7 +256,8 @@ static void nft_cmd_enoent(struct netlink_ctx *ctx, const struct cmd *cmd,
 static int nft_cmd_chain_error(struct netlink_ctx *ctx, struct cmd *cmd,
 			       struct mnl_err *err)
 {
-	struct chain *chain = cmd->chain;
+	struct chain *chain = cmd->chain, *existing_chain;
+	const struct table *table;
 	int priority;
 
 	switch (err->err) {
@@ -270,6 +271,18 @@ static int nft_cmd_chain_error(struct netlink_ctx *ctx, struct cmd *cmd,
 			return netlink_io_error(ctx, &chain->priority.loc,
 						"Chains of type \"nat\" must have a priority value above -200");
 
+		table = table_cache_find(&ctx->nft->cache.table_cache,
+					 cmd->handle.table.name, cmd->handle.family);
+		if (table) {
+			existing_chain = chain_cache_find(table, cmd->handle.chain.name);
+			if (existing_chain && existing_chain != chain &&
+			    !strcmp(existing_chain->handle.chain.name, chain->handle.chain.name))
+				return netlink_io_error(ctx, &chain->loc,
+							"Chain \"%s\" already exists in table %s '%s' with different declaration",
+							chain->handle.chain.name,
+							family2str(table->handle.family), table->handle.table.name);
+		}
+
 		return netlink_io_error(ctx, &chain->loc,
 					"Chain of type \"%s\" is not supported, perhaps kernel support is missing?",
 					chain->type.str);
-- 
2.30.2

