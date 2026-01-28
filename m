Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80145284671
	for <netfilter-devel@vger.kernel.org>; Wed, 28 Jan 2026 02:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769566213; cv=none; b=L5nZJTtCFWhBmk+XUYtmo26DfpPOBXF5RGvyAXQHKA0EPO0Ojg7M9KgRsFTojDeXtBc9lcm39JbZJA+dvl63EmXLCDMDYeUhmuKiQKD0f1x1CZ7T8q58olYn6GmQZBGyoVubncb22mrHUqilj+ltEV2HaEfENpeSVYA981zrYoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769566213; c=relaxed/simple;
	bh=nSpBX8QwPYQ6iHQ5QKV9dMY79Y4UnjtozYHwtsfy7mA=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=Tk/UpQlmcHPbN6urvfxs/ltqVPKSPH6Caa63t/mqHVnf5FaR/dL+NqpiHaFKbAQ354pcrCE+R7bW6tnmsCZb6OY5IKAIqw5VPvFhFmTLayhCURo1UEgZOeykuyq1Yz2/BFzxwuBA/ufgOfE7E8izakuqdXCzv3aPNoQ5Sl9Uh1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=QgtPHETI; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="QgtPHETI"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id B50AD60178
	for <netfilter-devel@vger.kernel.org>; Wed, 28 Jan 2026 03:10:09 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1769566209;
	bh=BL8MzyFIuoqlnLfFDISkSZzzTvUN/V62dN476Q812+o=;
	h=From:To:Subject:Date:From;
	b=QgtPHETIgcucBNiYiRedi1OP4kHxB8/+jsQtTuh16w2EGKJJBgPJogrdRZibipCiV
	 03N0BYh2+kb6m62037SKinatWW8jtMYaMHtg/e92CyV+uEGi3MqA58l0Dx8S37gOzt
	 P0LLAuaiU2holacZJVAz/O6arYHXQf7Mqyhwh43eJJ9ZVsD1DmOHbBs/Whd33BTqWz
	 KVtrSbfVpa4v/EzDnCaAcNCm1112P8YsYlOkP6cnJt2g0xESFUznub2LMtZK8/MFnU
	 DSL3fAf41JqLZ/PAs+q/YdzhknQnu7fXLM/YLD0USBv8ZhFRMOVrmlZrW3gohLFWek
	 rLw/P/WtHIFSA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft WIP] src: disable set dump content for incremental interval set updates
Date: Wed, 28 Jan 2026 03:10:06 +0100
Message-ID: <20260128021006.763275-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Overlap detection for interval sets needs a content dump because kernel
overlap detection is incomplete.

This patch removes this set content dump. Thus, NFT_CACHE_SETELEM_MAYBE
only fetches the set content if the auto-merge flag is set on.

set_overlap() still remain in place because this can be used from error
path to provide better error reporting at the cost of dumping the set
content.

This patch requires kernel patches to complete the overlap detection for
interval sets.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
Do not apply, set_overlap() still needs to be used from error path, this
is to test the posted interval set kernel patches for overlap detection.

 include/intervals.h |  1 +
 src/cache.c         |  3 ++-
 src/evaluate.c      |  2 +-
 src/intervals.c     | 14 ++++++++++++--
 4 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/include/intervals.h b/include/intervals.h
index 2366c295ca08..aa1514df727d 100644
--- a/include/intervals.h
+++ b/include/intervals.h
@@ -5,6 +5,7 @@ int set_automerge(struct list_head *msgs, struct cmd *cmd, struct set *set,
 		  struct expr *init, unsigned int debug_mask);
 int set_delete(struct list_head *msgs, struct cmd *cmd, struct set *set,
 	       struct expr *init, unsigned int debug_mask);
+int set_add(struct list_head *msgs, struct set *set, struct expr *init);
 int set_overlap(struct list_head *msgs, struct set *set, struct expr *init);
 int set_to_intervals(const struct set *set, struct expr *init, bool add);
 int setelem_to_interval(const struct set *set, struct expr *elem,
diff --git a/src/cache.c b/src/cache.c
index bb005c10f999..93f2c59ef60d 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -1188,7 +1188,8 @@ static int cache_init_objects(struct netlink_ctx *ctx, unsigned int flags,
 				if (cache_filter_find(filter, &set->handle))
 					continue;
 
-				if (!set_is_non_concat_range(set))
+				if (!set_is_non_concat_range(set) ||
+				    !set->automerge)
 					continue;
 
 				ret = netlink_list_setelems(ctx, &set->handle,
diff --git a/src/evaluate.c b/src/evaluate.c
index 4be5299274d2..41385a805065 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2041,7 +2041,7 @@ static int interval_set_eval(struct eval_ctx *ctx, struct set *set,
 			ret = set_automerge(ctx->msgs, ctx->cmd, set, init,
 					    ctx->nft->debug_mask);
 		} else {
-			ret = set_overlap(ctx->msgs, set, init);
+			ret = set_add(ctx->msgs, set, init);
 		}
 		break;
 	case CMD_DELETE:
diff --git a/src/intervals.c b/src/intervals.c
index 40ab42832fd9..6462ee49500d 100644
--- a/src/intervals.c
+++ b/src/intervals.c
@@ -504,8 +504,10 @@ int set_delete(struct list_head *msgs, struct cmd *cmd, struct set *set,
 	int err;
 
 	set_to_range(init);
-	if (set->automerge)
-		automerge_delete(msgs, set, init, debug_mask);
+	if (!set->automerge)
+		return 0;
+
+	automerge_delete(msgs, set, init, debug_mask);
 
 	if (existing_set->init) {
 		set_to_range(existing_set->init);
@@ -629,6 +631,14 @@ err_out:
 	return err;
 }
 
+int set_add(struct list_head *msgs, struct set *set, struct expr *init)
+{
+	set_to_range(init);
+	list_expr_sort(&expr_set(init)->expressions);
+
+	return 0;
+}
+
 /* overlap detection for intervals already exists in Linux kernels >= 5.7. */
 int set_overlap(struct list_head *msgs, struct set *set, struct expr *init)
 {
-- 
2.47.3

