Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E570364EB2
	for <netfilter-devel@vger.kernel.org>; Wed,  8 Apr 2026 11:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775649573; cv=none; b=PAhyTn8KEpnwbHW1ce7bZBZSTNct/eYksFxvXHmr8dmA+pbeJ0ZUefWeKFtFzYyEgc/E61kE+GO66egFHXcclLNq/rcAySiX2zkTS5Z2aylhHeRiJnHBiPlU6g+HQvbYOVeYRzszEfVo5C8Vz34nUwkv2khcBcBlo+gvFTKszYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775649573; c=relaxed/simple;
	bh=x1fDM4WQ9j9LVEYvAYRygbdBu7tprFslEWWrJIrA0GE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jdJ+khooT8rgwqWHX3RfoiZIaqNbAti7SvH3M6RclK0yXMsoXV2rjw/xmWUk2YSA7QgcLSqpAMRE3rhf40XenbzCQLv5FvR9IeIi/ae3jllkhnR19pXjZ1WYPaTN9rJxh8aKmfyDlkVtyHIMg7jcX0UfO2Ur/QKRFgxrwbwSQVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=jIGNd1J8; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="jIGNd1J8"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 968406033C;
	Wed,  8 Apr 2026 13:59:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1775649570;
	bh=3BVTQz6obgyvalWWOXJPDxYjm1n5yX+bVTf6wsh1QBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jIGNd1J83vw6T6qLWqGpwCpUOWbbQxTBuX1bZ//4P2p6wb8MvYEqCUrZMbjp8tLMK
	 /2niy6+Hp5Cs8ivpltIf7ub+3HG4/RBlObQFSUjPP7BvE/NfK6kYcEmx6rgpQzACIq
	 5mqn2GAby7hI/oCLY6XvDMXvu3BWCr7eyrmSUECXEeOVkD4Zta4ntuTbIzXJtoQpLL
	 m63QvSm1LRG0K8CB3zgx7q+7qvAF9xMzdVEBCRX7b+ZrizRgPdl+7R9UyQ4Q4essn1
	 3iR9IuKR8dalv3PnDWT6gaJ017TetExU+uUsERzl2jn3QBoMARHua8b4RbRtarug/t
	 r8kYDWUUbq/jg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: phil@nwl.cc,
	fw@strlen.de
Subject: [PATCH nft 2/5] libnftables: add nft_run_cmd_release() helper and use it
Date: Wed,  8 Apr 2026 13:59:19 +0200
Message-ID: <20260408115922.48676-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260408115922.48676-1-pablo@netfilter.org>
References: <20260408115922.48676-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Wrap the code to release the list of commands in a helper function, then
use it to consolidate codebase.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/libnftables.c | 29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/src/libnftables.c b/src/libnftables.c
index e3218da9f48f..46d9c0df590b 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -605,11 +605,23 @@ static int nft_evaluate(struct nft_ctx *nft, struct list_head *msgs,
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
@@ -646,11 +658,8 @@ int nft_run_cmd_from_buffer(struct nft_ctx *nft, const char *buf)
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
@@ -739,7 +748,6 @@ static struct error_record *filename_is_useable(struct nft_ctx *nft, const char
 static int __nft_run_cmd_from_filename(struct nft_ctx *nft, const char *filename)
 {
 	struct error_record *erec;
-	struct cmd *cmd, *next;
 	int rc, parser_rc;
 	LIST_HEAD(msgs);
 	LIST_HEAD(cmds);
@@ -783,11 +791,8 @@ static int __nft_run_cmd_from_filename(struct nft_ctx *nft, const char *filename
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

