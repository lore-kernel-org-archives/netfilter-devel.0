Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BAB3311968
	for <netfilter-devel@vger.kernel.org>; Tue, 23 Jun 2026 17:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782235297; cv=none; b=oZ8I1c9FT/+KmDnh5p4jwc0KLKAntHmzavFgyvK4ZAzjiOtzYgDbTggTIfjo9JfwyjDvkOiEEjCcn0POk4JLBo69l1zmmRm6El0jA3kghWaiqpf12Xe1DWX8n2W25twGwdqR0WNFwud3GDS6g1s0z6bXVFrDf1nkRIARzBQ9uyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782235297; c=relaxed/simple;
	bh=QDAjjIbsDWfYHGVCowpQ8ZzcVssojWATAQM9xQdVA5c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F4daAdSdsjp/6vOmaHDORxt37GuPXojfnym/6MLMbG1mY8u7VEem/Tkk/x2EVpUDVWYEMFkxRqai7HWEs5yXHq6qqn9ecuYvzd0WjUFxiCtaZf1hLIOdWjya1LvzWF9wlgTD20SON54DuWEG5jTEEr48Izh5cwZDmW4y5Be0etY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=XKftgz8w; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="XKftgz8w"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id B166D6057C;
	Tue, 23 Jun 2026 19:21:33 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1782235293;
	bh=frOVgcRoiP8WNKSbLrHtiu1m2EBxE4Z7s7P2ihFl4WM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XKftgz8wKq7eQQOIMdQwxzJARHFjpogCKkZoVHQUPYFpS4hh6+T7b6DVsnQRG2qXD
	 RcZ2K86mHXfFBY8SKQJmyYDXz7qZfouWcBtRa93fsPVnczxucLH6YRwtzlAlbuKSPP
	 qSQrBM63y0LI0FZ4pj01OXCPhuWB/v3r9EDhBvrJIwIyDOHOYBVvUusJG0b6sMFpA2
	 cKJgV6mFVXp4yu1MK4D9w/IejodxySu24nlDYPlM/Pho7I7sv6Oc6Ba1ibq6zvT5wE
	 Sxi9NMGJaXSatYYopwilqFWNh6akiVzgqVOYVfqGfyDRSYbABVWD4zHoN2IaWOps7S
	 XG0KvQgagxvFQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: phil@nwl.cc
Subject: [PATCH nft,v2 1/5] libnftables: add nft_run_cmd_release() helper and use it
Date: Tue, 23 Jun 2026 19:21:24 +0200
Message-ID: <20260623172128.401234-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260623172128.401234-1-pablo@netfilter.org>
References: <20260623172128.401234-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Wrap the code to release the list of commands in a helper function, then
use it to consolidate codebase.

Not functional changes are intended.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/libnftables.c | 29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/src/libnftables.c b/src/libnftables.c
index db9ee388adde..b4735f330075 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -611,11 +611,23 @@ static int nft_evaluate(struct nft_ctx *nft, struct list_head *msgs,
 	return 0;
 }
 
+static void nft_run_cmd_release(struct nft_ctx *nft,
+				struct list_head *msgs,
+				struct list_head *cmds)
+{
+	struct cmd *cmd, *next;
+
+	erec_print_list(&nft->output, msgs, nft->debug_mask);
+	list_for_each_entry_safe(cmd, next, cmds, list) {
+		list_del(&cmd->list);
+		cmd_free(cmd);
+	}
+}
+
 EXPORT_SYMBOL(nft_run_cmd_from_buffer);
 int nft_run_cmd_from_buffer(struct nft_ctx *nft, const char *buf)
 {
 	int rc = -EINVAL, parser_rc;
-	struct cmd *cmd, *next;
 	LIST_HEAD(msgs);
 	LIST_HEAD(cmds);
 	char *nlbuf;
@@ -647,11 +659,8 @@ int nft_run_cmd_from_buffer(struct nft_ctx *nft, const char *buf)
 	if (nft_netlink(nft, &cmds, &msgs) != 0)
 		rc = -1;
 err:
-	erec_print_list(&nft->output, &msgs, nft->debug_mask);
-	list_for_each_entry_safe(cmd, next, &cmds, list) {
-		list_del(&cmd->list);
-		cmd_free(cmd);
-	}
+	nft_run_cmd_release(nft, &msgs, &cmds);
+
 	iface_cache_release();
 	if (nft->scanner) {
 		scanner_destroy(nft);
@@ -740,7 +749,6 @@ static struct error_record *filename_is_useable(struct nft_ctx *nft, const char
 static int __nft_run_cmd_from_filename(struct nft_ctx *nft, const char *filename)
 {
 	struct error_record *erec;
-	struct cmd *cmd, *next;
 	int rc, parser_rc;
 	LIST_HEAD(msgs);
 	LIST_HEAD(cmds);
@@ -779,11 +787,8 @@ static int __nft_run_cmd_from_filename(struct nft_ctx *nft, const char *filename
 	if (nft_netlink(nft, &cmds, &msgs) != 0)
 		rc = -1;
 err:
-	erec_print_list(&nft->output, &msgs, nft->debug_mask);
-	list_for_each_entry_safe(cmd, next, &cmds, list) {
-		list_del(&cmd->list);
-		cmd_free(cmd);
-	}
+	nft_run_cmd_release(nft, &msgs, &cmds);
+
 	iface_cache_release();
 	if (nft->scanner) {
 		scanner_destroy(nft);
-- 
2.47.3

