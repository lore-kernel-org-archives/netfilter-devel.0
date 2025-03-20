Received: from Chamillionaire.breakpoint.cc (unknown [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 130961DED5E
	for <netfilter-devel@vger.kernel.org>; Thu, 20 Mar 2025 13:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742477545; cv=none; b=IAWlLD1D20PXCu0AfikrXYQgdJ/zsGybP2tHXja5Q46vk7c5QIVBncdG1im5Guy1OL9aNxG9Oh/dIku3RdUg4Tkdv4wDfK5P6D6J7k8PZ/Ayl9KOS+aDc9YkBJe5mN9cAf6T6NZ9jW3ATIGiZqmM4bcCq6/u/fO9DA78kfkfzAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742477545; c=relaxed/simple;
	bh=rLiaWq7Ipxwpx6EfLugXsqBmfAi9075y09lZQ3+2jQs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hvXUmK988kad+1yt3l6TA5UXshbVqHWIjaV2qOq6iTWP2YqJ7fB4ZQXrLo+82WbpE/+1BdFL+7OaL7Ys/Ri6Uk+gUsVMabPZ4qFwuibaPL1/546PM0jTEPD77ZXxQHVWXQhSI2Pks4M6ruRoCV1+WKvI2Bj208pbb0WjksK0aDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1tvG0S-0002Zq-W4; Thu, 20 Mar 2025 14:32:21 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] rule: return error if table does not exist
Date: Thu, 20 Mar 2025 14:31:42 +0100
Message-ID: <20250320133145.31833-1-fw@strlen.de>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The bogon triggers segfault due to NULL dereference.  Error out and set
errno to ENOENT; caller uses strerror() in the errmsg.

After fix, loading reproducer results in:
/tmp/A:2:1-18: Error: Could not process rule: No such file or directory
list table inet p
^^^^^^^^^^^^^^^^^^

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/rule.c                                                | 8 +++++++-
 .../testcases/bogons/nft-f/list_a_deleted_table_crash     | 3 +++
 2 files changed, 10 insertions(+), 1 deletion(-)
 create mode 100644 tests/shell/testcases/bogons/nft-f/list_a_deleted_table_crash

diff --git a/src/rule.c b/src/rule.c
index 3edfa4715853..00fbbc4c080a 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -2380,10 +2380,16 @@ static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
 	if (nft_output_json(&ctx->nft->output))
 		return do_command_list_json(ctx, cmd);
 
-	if (cmd->handle.table.name != NULL)
+	if (cmd->handle.table.name != NULL) {
 		table = table_cache_find(&ctx->nft->cache.table_cache,
 					 cmd->handle.table.name,
 					 cmd->handle.family);
+		if (!table) {
+			errno = ENOENT;
+			return -1;
+		}
+	}
+
 	switch (cmd->obj) {
 	case CMD_OBJ_TABLE:
 		if (!cmd->handle.table.name)
diff --git a/tests/shell/testcases/bogons/nft-f/list_a_deleted_table_crash b/tests/shell/testcases/bogons/nft-f/list_a_deleted_table_crash
new file mode 100644
index 000000000000..b802430bb6cc
--- /dev/null
+++ b/tests/shell/testcases/bogons/nft-f/list_a_deleted_table_crash
@@ -0,0 +1,3 @@
+table inet p
+list table inet p
+delete  table inet p
-- 
2.48.1

