Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 216C23BADBF
	for <netfilter-devel@vger.kernel.org>; Wed,  8 Apr 2026 11:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775649574; cv=none; b=VehdguFrbOOByu4tTWXvOsfXKo+FbYpBas4f/29heSl+r2RHiCdTyEellpKWU7jXcUe9upuuwzKF2V995rJ3/6IV2+6/Y6oXt7kN46z96+/9K4T3ij5zuAmPLnRElBE8CDRSMtTAIP3V0Tb+DN2BN1dIhImWamFhXqyWa2kCA0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775649574; c=relaxed/simple;
	bh=fDEXEB2kskSwuPvaSNC3rLfPdpCGJjEMiseheJHEVKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UHX2lZQPQRsFXj2QsOgt9tTuhN15jwu75KUxwhoa2ixeiqeZGLtbKREiR1KAEMQ/EYujb/Q0aCnm2ItsrFcaBtcUMSelQ+3qVh5Lgi102JUUvCuaontXGmde01AW/d02V6Hirdc6Cw5WD393gokttiC0dXIdjnaJ8zzZdZI9JC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=CWHO9b9J; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="CWHO9b9J"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 7585E6033D;
	Wed,  8 Apr 2026 13:59:31 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1775649571;
	bh=N2s2UR1EWijMM2odnIthaVG0+z4aXJs2zb7F5psM3sE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CWHO9b9Jx6RXVwVugKuYRRz+Hd7WgO85+qdaw9iPQxWoQ3u6U+VMX+W2EtYAksdFH
	 qdDHpMIU9W8iw76MUJRe7q9AoN/Wnbud2zvWAy0dUd5pR+wcPHiOtQ5n4XoTASu6z1
	 mrkZir8s6GKHF2AB4s1f/RYW2BWEfcKDKPtO4EezHjdjeibDVBRm5jVC5vAK7q5zw7
	 zdZJHYMm1tOyGoSoJ/aKR1nMz7oO20ystgDewgQgGSF0MdHZzfnfIGbXVVPUXImt2b
	 G+LT9LSVHpLH8/hKl1/ppKRkVRjAY3uL8/wO/bIoThcNDhMqgEPQSJknrivTbMtX1Y
	 xGcSzKV41EYFw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: phil@nwl.cc,
	fw@strlen.de
Subject: [PATCH nft 3/5] libnftables: consolidate evaluation and netlink run
Date: Wed,  8 Apr 2026 13:59:20 +0200
Message-ID: <20260408115922.48676-4-pablo@netfilter.org>
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

Add a helper function to wrap the code that evaluates the list of
commands and serialize them into the netlink batch.

Add a first user: nft_run_cmd_from_buffer(), there is a follow up patch
which will do the same for nft_run_cmd_from_filename().

No functional changes are intended, this comes in preparation to
support several list/reset commands in a batch.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/libnftables.c | 61 ++++++++++++++++++++++++++++-------------------
 1 file changed, 37 insertions(+), 24 deletions(-)

diff --git a/src/libnftables.c b/src/libnftables.c
index 46d9c0df590b..5471ccf6f789 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -618,22 +618,13 @@ static void nft_run_cmd_release(struct nft_ctx *nft,
 	}
 }
 
-EXPORT_SYMBOL(nft_run_cmd_from_buffer);
-int nft_run_cmd_from_buffer(struct nft_ctx *nft, const char *buf)
+static int nft_eval_run_cmds(struct nft_ctx *nft, struct list_head *msgs,
+			     struct list_head *cmds, int rc)
 {
-	int rc = -EINVAL, parser_rc;
-	LIST_HEAD(msgs);
-	LIST_HEAD(cmds);
-	char *nlbuf;
+	int parser_rc;
 
-	nlbuf = xzalloc(strlen(buf) + 2);
-	sprintf(nlbuf, "%s\n", buf);
-
-	if (nft_output_json(&nft->output) || nft_input_json(&nft->input))
-		rc = nft_parse_json_buffer(nft, nlbuf, &msgs, &cmds);
-	if (rc == -EINVAL)
-		rc = nft_parse_bison_buffer(nft, nlbuf, &msgs, &cmds,
-					    &indesc_cmdline);
+	if (rc < 0)
+		goto err;
 
 #if HAVE_FUZZER_BUILD
 	if (nft->afl_ctx_stage == NFT_AFL_FUZZER_PARSER)
@@ -641,7 +632,7 @@ int nft_run_cmd_from_buffer(struct nft_ctx *nft, const char *buf)
 #endif
 	parser_rc = rc;
 
-	rc = nft_evaluate(nft, &msgs, &cmds);
+	rc = nft_evaluate(nft, msgs, cmds);
 	if (rc < 0) {
 		if (errno == EPERM) {
 			fprintf(stderr, "%s (you must be root)\n",
@@ -655,17 +646,10 @@ int nft_run_cmd_from_buffer(struct nft_ctx *nft, const char *buf)
 		goto err;
 	}
 
-	if (nft_netlink(nft, &cmds, &msgs) != 0)
+	if (nft_netlink(nft, cmds, msgs) != 0)
 		rc = -1;
 err:
-	nft_run_cmd_release(nft, &msgs, &cmds);
-
-	iface_cache_release();
-	if (nft->scanner) {
-		scanner_destroy(nft);
-		nft->scanner = NULL;
-	}
-	free(nlbuf);
+	nft_run_cmd_release(nft, msgs, cmds);
 
 	if (!rc &&
 	    nft_output_json(&nft->output) &&
@@ -678,6 +662,35 @@ err:
 	return rc;
 }
 
+EXPORT_SYMBOL(nft_run_cmd_from_buffer);
+int nft_run_cmd_from_buffer(struct nft_ctx *nft, const char *buf)
+{
+	int rc = -EINVAL;
+	LIST_HEAD(msgs);
+	LIST_HEAD(cmds);
+	char *nlbuf;
+
+	nlbuf = xzalloc(strlen(buf) + 2);
+	sprintf(nlbuf, "%s\n", buf);
+
+	if (nft_output_json(&nft->output) || nft_input_json(&nft->input))
+		rc = nft_parse_json_buffer(nft, nlbuf, &msgs, &cmds);
+	if (rc == -EINVAL)
+		rc = nft_parse_bison_buffer(nft, nlbuf, &msgs, &cmds,
+					    &indesc_cmdline);
+
+	rc = nft_eval_run_cmds(nft, &msgs, &cmds, rc);
+
+	free(nlbuf);
+	iface_cache_release();
+	if (nft->scanner) {
+		scanner_destroy(nft);
+		nft->scanner = NULL;
+	}
+
+	return rc;
+}
+
 static int load_cmdline_vars(struct nft_ctx *ctx, struct list_head *msgs)
 {
 	unsigned int bufsize, ret, i, offset = 0;
-- 
2.47.3

