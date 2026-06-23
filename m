Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5272D360EC0
	for <netfilter-devel@vger.kernel.org>; Tue, 23 Jun 2026 17:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782235297; cv=none; b=sbxtwFEI9oIe6c1BPTeaObbAiauQJiwmEuohMrinllM9VOCwK1TS95ZhfmAA9Q5wGCnr/HsInCx2/T1Qy2s3K1EAqKEDvIWODlWngLsDL2025SvyG+vYjJtoH633/pWa9rNsNEy0SOapc+Dphc9aOCqhqxinbVjR2nKVjJgryLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782235297; c=relaxed/simple;
	bh=Hq32d8P5fCm9K7czc+h3o6jDhGSbeSpWQ1TNXPeGofk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RCKTT72U0x01jJ8i2wrnppsvjxyYicXGlF6CgK3SKjWUxERA1zxxe2M05XZlwjmsM0ilRP9F7o8oN9nDEZmAgdGTnUN/HjjyOgiaF8Gix3rtB5w5H78qL5VTMW0CoKtmxHkdSAVYFUx/vS53JulWj0jFrxXOQUej1iI2UWDMFrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=bD0FXBEx; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="bD0FXBEx"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 9767A6057D;
	Tue, 23 Jun 2026 19:21:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1782235294;
	bh=javMc434vexYUfhP4ACj6OZrXQDsZpOHgujzWtInJFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bD0FXBExfrwpZYldoRG6dhespTZ9zzvjjM5i3rWfNMLi9C/Rzx+nBHu/3gilHr/TN
	 9Hj4kesKnPDJPyHfCvXfN5fuuesRG2j/XQVybQ39320QjeulSnTybIfAH0/mqpTfk4
	 ptqQZeCD5rf81SJEdPf87KIt9aoG4YvppiGg/s/PXQN89wl0cEDybE4fwsqnz9tHsy
	 4mnzHv3u20r5b393IQzqWLE0xrNvuWIhQfKTDT4828Y+eKxCZPLNDNlSQzS2FPEauf
	 pg64JO2sLxNYQPXroULIIgSXXaVZia5nsj0XLUALX0QCT72SLmfG5PTp6xKJHwUN9g
	 QFGURNX2j2R9A==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: phil@nwl.cc
Subject: [PATCH nft,v2 2/5] libnftables: split nft_run_cmd_from_buffer() in helper functions
Date: Tue, 23 Jun 2026 19:21:25 +0200
Message-ID: <20260623172128.401234-3-pablo@netfilter.org>
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

Add a helper function called nft_run_cmds() to wrap the code that
evaluates the list of commands and serialize them into the netlink
batch.

Add another helper function called nft_finish_cmds() to print the error,
release them, as well as displaying the json output and releasing the
cache.

Add a first user: nft_run_cmd_from_buffer(), there is a follow up patch
which updates nft_run_cmd_from_filename() to use these helper functions.

No functional changes are intended, this comes in preparation to
support several reset commands in a batch.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/libnftables.c | 66 ++++++++++++++++++++++++++++++-----------------
 1 file changed, 43 insertions(+), 23 deletions(-)

diff --git a/src/libnftables.c b/src/libnftables.c
index b4735f330075..659f3a99a158 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -624,22 +624,13 @@ static void nft_run_cmd_release(struct nft_ctx *nft,
 	}
 }
 
-EXPORT_SYMBOL(nft_run_cmd_from_buffer);
-int nft_run_cmd_from_buffer(struct nft_ctx *nft, const char *buf)
+static int nft_run_cmds(struct nft_ctx *nft, struct list_head *msgs,
+			struct list_head *cmds, int rc)
 {
-	int rc = -EINVAL, parser_rc;
-	LIST_HEAD(msgs);
-	LIST_HEAD(cmds);
-	char *nlbuf;
-
-	nlbuf = xzalloc(strlen(buf) + 2);
-	sprintf(nlbuf, "%s\n", buf);
+	int parser_rc;
 
-	if (nft_output_json(&nft->output) || nft_input_json(&nft->input))
-		rc = nft_parse_json_buffer(nft, nlbuf, &msgs, &cmds);
-	if (rc == -EINVAL)
-		rc = nft_parse_bison_buffer(nft, nlbuf, &msgs, &cmds,
-					    &indesc_cmdline);
+	if (rc < 0)
+		goto err;
 
 #if HAVE_FUZZER_BUILD
 	if (nft->afl_ctx_stage == NFT_AFL_FUZZER_PARSER)
@@ -647,7 +638,7 @@ int nft_run_cmd_from_buffer(struct nft_ctx *nft, const char *buf)
 #endif
 	parser_rc = rc;
 
-	rc = nft_evaluate(nft, &msgs, &cmds);
+	rc = nft_evaluate(nft, msgs, cmds);
 	if (rc < 0)
 		goto err;
 
@@ -656,17 +647,16 @@ int nft_run_cmd_from_buffer(struct nft_ctx *nft, const char *buf)
 		goto err;
 	}
 
-	if (nft_netlink(nft, &cmds, &msgs) != 0)
+	if (nft_netlink(nft, cmds, msgs) != 0)
 		rc = -1;
 err:
-	nft_run_cmd_release(nft, &msgs, &cmds);
+	return rc;
+}
 
-	iface_cache_release();
-	if (nft->scanner) {
-		scanner_destroy(nft);
-		nft->scanner = NULL;
-	}
-	free(nlbuf);
+static void nft_finish_cmds(struct nft_ctx *nft, struct list_head *msgs,
+			    struct list_head *cmds, int rc)
+{
+	nft_run_cmd_release(nft, msgs, cmds);
 
 	if (!rc &&
 	    nft_output_json(&nft->output) &&
@@ -675,6 +665,36 @@ err:
 
 	if (rc || nft->check)
 		nft_cache_release(&nft->cache);
+}
+
+
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
+	rc = nft_run_cmds(nft, &msgs, &cmds, rc);
+
+	nft_finish_cmds(nft, &msgs, &cmds, rc);
+
+	free(nlbuf);
+	iface_cache_release();
+	if (nft->scanner) {
+		scanner_destroy(nft);
+		nft->scanner = NULL;
+	}
 
 	return rc;
 }
-- 
2.47.3

