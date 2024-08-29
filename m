Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2602218A6D1
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Aug 2024 11:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724931121; cv=none; b=aYDmX+IRz+n83rPAX8CptX5CP3CmJjU834nO4ozdyHHRVh2r1dQfeufhrIgvWUu4eL71gl4mrsf1SA+huBUm0t3ISxOs+Oy5Rjn3DxLAG2b9uOhCkp0Foqf97kEeB8QXnNmNa760SthKKuNeO5mVb/HZenkaEYBkGI2Vkk1eLmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724931121; c=relaxed/simple;
	bh=LKvAjwyRIEJ1+bjpdLTIlYg48nqkj1QLYWyCFc7NVps=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=HHfZZsQVYKZQfhOBT3Lutg+VyTtj/SxWcpuczVYmrkV0mGaGSSii17rMwvVgMC4HUt38QBWe1rcqB9saE73LXdfglQ6rjeZv8qNAPadiGy693amTMHRNGEHxeydGMGvqE2hh+PuYYg3fP18lxZ8PILa2jOecOfzEXfN6UCOiIQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: eric@garver.life
Subject: [PATCH nft 1/5] cache: assert filter when calling nft_cache_evaluate()
Date: Thu, 29 Aug 2024 13:31:49 +0200
Message-Id: <20240829113153.1553089-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nft_cache_evaluate() always takes a non-null filter, remove superfluous
checks when calculating cache requirements via flags.

Note that filter is still option from netlink dump path, since this can
be called from error path to provide hints.

Fixes: 08725a9dc14c ("cache: filter out rules by chain")
Fixes: b3ed8fd8c9f3 ("cache: missing family in cache filtering")
Fixes: 635ee1cad8aa ("cache: filter out sets and maps that are not requested")
Fixes: 3f1d3912c3a6 ("cache: filter out tables that are not requested")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/cache.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/src/cache.c b/src/cache.c
index 72f2972f0259..8cddabdb7b98 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -212,18 +212,17 @@ static unsigned int evaluate_cache_list(struct nft_ctx *nft, struct cmd *cmd,
 {
 	switch (cmd->obj) {
 	case CMD_OBJ_TABLE:
-		if (filter)
-			filter->list.family = cmd->handle.family;
+		filter->list.family = cmd->handle.family;
 		if (!cmd->handle.table.name) {
 			flags |= NFT_CACHE_TABLE;
 			break;
-		} else if (filter) {
+		} else {
 			filter->list.table = cmd->handle.table.name;
 		}
 		flags |= NFT_CACHE_FULL;
 		break;
 	case CMD_OBJ_CHAIN:
-		if (filter && cmd->handle.chain.name) {
+		if (cmd->handle.chain.name) {
 			filter->list.family = cmd->handle.family;
 			filter->list.table = cmd->handle.table.name;
 			filter->list.chain = cmd->handle.chain.name;
@@ -236,7 +235,7 @@ static unsigned int evaluate_cache_list(struct nft_ctx *nft, struct cmd *cmd,
 		break;
 	case CMD_OBJ_SET:
 	case CMD_OBJ_MAP:
-		if (filter && cmd->handle.table.name && cmd->handle.set.name) {
+		if (cmd->handle.table.name && cmd->handle.set.name) {
 			filter->list.family = cmd->handle.family;
 			filter->list.table = cmd->handle.table.name;
 			filter->list.set = cmd->handle.set.name;
@@ -256,8 +255,7 @@ static unsigned int evaluate_cache_list(struct nft_ctx *nft, struct cmd *cmd,
 			flags |= NFT_CACHE_SETELEM;
 		break;
 	case CMD_OBJ_FLOWTABLE:
-		if (filter &&
-		    cmd->handle.table.name &&
+		if (cmd->handle.table.name &&
 		    cmd->handle.flowtable.name) {
 			filter->list.family = cmd->handle.family;
 			filter->list.table = cmd->handle.table.name;
@@ -314,8 +312,6 @@ static unsigned int evaluate_cache_list(struct nft_ctx *nft, struct cmd *cmd,
 static unsigned int evaluate_cache_reset(struct cmd *cmd, unsigned int flags,
 					 struct nft_cache_filter *filter)
 {
-	assert(filter);
-
 	switch (cmd->obj) {
 	case CMD_OBJ_TABLE:
 	case CMD_OBJ_CHAIN:
@@ -482,6 +478,8 @@ int nft_cache_evaluate(struct nft_ctx *nft, struct list_head *cmds,
 	unsigned int flags, batch_flags = NFT_CACHE_EMPTY;
 	struct cmd *cmd;
 
+	assert(filter);
+
 	list_for_each_entry(cmd, cmds, list) {
 		if (nft_handle_validate(cmd, msgs) < 0)
 			return -1;
-- 
2.30.2

