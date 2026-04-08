Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66F823B95F9
	for <netfilter-devel@vger.kernel.org>; Wed,  8 Apr 2026 11:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775649575; cv=none; b=Jnb2xq2aXQeWnt/uKZvNIJPFuWkqGXvP0cRuMoZIsXdNzc8BqG2yJGBMkioReerb18MJ3atK4SWrWbJxbqv9jgT9fxyaie+0poBxHuEI79bGekOiaR9L11p8mLnMOMnZ0AuKM6636ykeUnrPzOn+GIHtFH+r6j5QU+R70d7tgx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775649575; c=relaxed/simple;
	bh=/uNecMsE5RmCjB517QwujTzEK/hrOz6YCdmztEHsnLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P61TD1X6Ff40CgjWWVoCkMez1gQXBtdz0aYqnEnN/AYJFyUHVqsdjFLORdi9Mdru5FYgShTQB61AXxtZTJSjJJK2VJ+Z2YJF4MxrS8pJMgjYuTRFs7dyU2v1acD3qxG3sJ8Uo9NCtt4dtQPyDym+O9JgOddcTfVSJJ6+5uI8/jU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=FZTprBf+; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="FZTprBf+"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 5DE706033E;
	Wed,  8 Apr 2026 13:59:32 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1775649572;
	bh=K5g/Ny+u1Z5k6emKUFuLoeUV7U209dMuKQTFoNcWQ2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FZTprBf+zNx4ftyhVPNhXmu2kCpQHBiiSNaem/fv8+xigPLpCBp9Rrt1kr2H8VYmk
	 0rLY1m8gL2Jt4Gs8vpHN7w8J4GGAW4Iu8UWz7CWayqlZaY9+Mq3+uZYeEVRCJSD06Q
	 xXwxJlKrauatGSEMwU7U4ODlSWfoq8LuzxTpliMzEIIpVerrHHgntoFsCQJoMwNxE2
	 YrOXby70ZcANvdh4Awh8Zo/cokuYtAUch2jGAXkXL9PvB/arwCp6MJ+rObydcPUXPf
	 w6jy92rT1zLgs83BSYcUihdN93W2AOuNKNNhnh89VA3TT9Aggy++nbNFAy+C4GzzTB
	 Z6IWw+GgyzVeA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: phil@nwl.cc,
	fw@strlen.de
Subject: [PATCH nft 4/5] libnftables: use nft_eval_run_cmds() in nft_run_cmd_from_filename()
Date: Wed,  8 Apr 2026 13:59:21 +0200
Message-ID: <20260408115922.48676-5-pablo@netfilter.org>
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

Update nft_run_cmd_from_filename() to use this new helper function.

Move err: tag to a later stage, which is run by the variables defined
via --define option, this should be safe.

No functional changes are intended, this comes in preparation to
support several list/reset commands in a batch.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/libnftables.c | 33 ++++-----------------------------
 1 file changed, 4 insertions(+), 29 deletions(-)

diff --git a/src/libnftables.c b/src/libnftables.c
index 5471ccf6f789..987f5d73ade4 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -761,9 +761,9 @@ static struct error_record *filename_is_useable(struct nft_ctx *nft, const char
 static int __nft_run_cmd_from_filename(struct nft_ctx *nft, const char *filename)
 {
 	struct error_record *erec;
-	int rc, parser_rc;
 	LIST_HEAD(msgs);
 	LIST_HEAD(cmds);
+	int rc;
 
 	erec = filename_is_useable(nft, filename);
 	if (erec) {
@@ -782,35 +782,17 @@ static int __nft_run_cmd_from_filename(struct nft_ctx *nft, const char *filename
 	if (rc == -EINVAL)
 		rc = nft_parse_bison_filename(nft, filename, &msgs, &cmds);
 
-	parser_rc = rc;
-
 	if (nft->optimize_flags)
 		nft_optimize(nft, &cmds);
 
-	rc = nft_evaluate(nft, &msgs, &cmds);
-	if (rc < 0) {
-		if (errno == EPERM) {
-			fprintf(stderr, "%s (you must be root)\n",
-				strerror(errno));
-		}
-		goto err;
-	}
-
-	if (parser_rc) {
-		rc = parser_rc;
-		goto err;
-	}
-
-	if (nft_netlink(nft, &cmds, &msgs) != 0)
-		rc = -1;
-err:
-	nft_run_cmd_release(nft, &msgs, &cmds);
+	rc = nft_eval_run_cmds(nft, &msgs, &cmds, rc);
 
 	iface_cache_release();
 	if (nft->scanner) {
 		scanner_destroy(nft);
 		nft->scanner = NULL;
 	}
+err:
 	if (!list_empty(&nft->vars_ctx.indesc_list)) {
 		struct input_descriptor *indesc, *next;
 
@@ -821,15 +803,8 @@ err:
 			free(indesc);
 		}
 	}
-	free_const(nft->vars_ctx.buf);
-
-	if (!rc &&
-	    nft_output_json(&nft->output) &&
-	    nft_output_echo(&nft->output))
-		json_print_echo(nft);
 
-	if (rc || nft->check)
-		nft_cache_release(&nft->cache);
+	free_const(nft->vars_ctx.buf);
 
 	scope_release(nft->state->scopes[0]);
 
-- 
2.47.3

