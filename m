Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48E5C38A73C
	for <netfilter-devel@vger.kernel.org>; Tue, 23 Jun 2026 17:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782235298; cv=none; b=N8VjVkQAa2rLgqRmMbTQANe7D77PQkoNcbSObeyFF0caXdy7t1WmpwG0RC/0w7682/lTi9iRUUdft5xYj4/ND5T0UleVD0dPaHQbRFH10YEGKs6stew73g4tjk6aZObMxBd5SZsTXM7mdUhAD/I416kS9kRp1MEQx48GNXWip4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782235298; c=relaxed/simple;
	bh=NYaVnfF3pFZR4oybc0klvEwYNncLmvpVV/y0lE4Avdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TZlo7eEaymVefllIThVUkbgnPsEvWDww1NWsNYOm4uA/toZr6OaUD4aEhHjKWB+tWKEc44t0FxCIGIl2/c6VORMRN/ZwtICIbl7f5eH7rW9YjhoY+1E1xu95N1CNA8KzmQvWv33Teeux9emfh05MVUKOLzIiXU3bJpjWzy2K8jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=fDozxNqU; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="fDozxNqU"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 7AE3A6057E;
	Tue, 23 Jun 2026 19:21:35 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1782235295;
	bh=h99a8o0aNLiOLnIExORW6vbLvQ7P0PcA1FdF7KS8M1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fDozxNqUK2+eM8reyLCt05lKi3CbmB6mIHYhkVVS+3MAEnIoOQh+hFqWLhpEoiuzZ
	 uYVmxRRGvOY/6pByg09ygFCWTIbaogi6ofSxJdRL1ALmP8FjjrxwGsOsk75jLJ0/SO
	 J1A7emHZuNqE08tfR5U1RxmPEuQ19vMSiQmE+MiMHTNIpIMqEbsVYTkL1enW+HFIpV
	 uu4sCuVQsawNGtFWgEoYITnu8Ven5wZKuIbO8avHBbPWXMOMvUVqfpz0Q0efgqhfdN
	 /HErPNn4FFcwKD+yVKB1eps0vYwthNcqqhrbNP8P4cT+PyXrRgDeFxeBUVuge+tXLY
	 tBXI7yz6pT+9g==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: phil@nwl.cc
Subject: [PATCH nft,v2 3/5] libnftables: use nft_run_cmds() in nft_run_cmd_from_filename()
Date: Tue, 23 Jun 2026 19:21:26 +0200
Message-ID: <20260623172128.401234-4-pablo@netfilter.org>
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

Update nft_run_cmd_from_filename() to use this new helper function.

Move err: tag to a later stage, which is run by the variables defined
via --define option, this should be safe.

No functional changes are intended, this comes in preparation to
support several reset commands in a batch.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/libnftables.c | 28 +++++-----------------------
 1 file changed, 5 insertions(+), 23 deletions(-)

diff --git a/src/libnftables.c b/src/libnftables.c
index 659f3a99a158..6e29bb019fb7 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -769,9 +769,9 @@ static struct error_record *filename_is_useable(struct nft_ctx *nft, const char
 static int __nft_run_cmd_from_filename(struct nft_ctx *nft, const char *filename)
 {
 	struct error_record *erec;
-	int rc, parser_rc;
 	LIST_HEAD(msgs);
 	LIST_HEAD(cmds);
+	int rc;
 
 	erec = filename_is_useable(nft, filename);
 	if (erec) {
@@ -790,30 +790,19 @@ static int __nft_run_cmd_from_filename(struct nft_ctx *nft, const char *filename
 	if (rc == -EINVAL)
 		rc = nft_parse_bison_filename(nft, filename, &msgs, &cmds);
 
-	parser_rc = rc;
-
 	if (nft->optimize_flags)
 		nft_optimize(nft, &cmds);
 
-	rc = nft_evaluate(nft, &msgs, &cmds);
-	if (rc < 0)
-		goto err;
-
-	if (parser_rc) {
-		rc = parser_rc;
-		goto err;
-	}
+	rc = nft_run_cmds(nft, &msgs, &cmds, rc);
 
-	if (nft_netlink(nft, &cmds, &msgs) != 0)
-		rc = -1;
-err:
-	nft_run_cmd_release(nft, &msgs, &cmds);
+	nft_finish_cmds(nft, &msgs, &cmds, rc);
 
 	iface_cache_release();
 	if (nft->scanner) {
 		scanner_destroy(nft);
 		nft->scanner = NULL;
 	}
+err:
 	if (!list_empty(&nft->vars_ctx.indesc_list)) {
 		struct input_descriptor *indesc, *next;
 
@@ -824,15 +813,8 @@ err:
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

