Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37B231429A
	for <netfilter-devel@vger.kernel.org>; Sat, 15 Jun 2024 09:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718443121; cv=none; b=nPKI0wY+hIJJ/1OrM1O+B9CF0WoWtL5k4Nc2lekcEYgC0h6IQz21YmHM6J04hDQ37s/n0ffA9+ZbFY/xQl7IltJaJLT8asHrqhmdu7kF5tvdTy1xONsxcZCEb29VpifAXZ8N5XB7C0QSF1UU3omcFd5DpkBHRb44Y1TnN5LUhpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718443121; c=relaxed/simple;
	bh=TxJOFKLnzqFwKe5hGBncXELBY2sjRVXchf0tO9T+p2g=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CPTtQ+2sTA4PQc/kfuGJvJDLUThG43cTrhVbkVSsl6MJyX67tMB1ihH/nwNbmnJuhkt4nbiixzXO/5XU4VLZnT3RvJp670xjzyHDc6yBidgkV4GN/F6twQddSfsS8uggdpXQRXOwZyJSHIg5mU5SlhRoNVWxVlsfTvMtp1Xl0nY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 2/2] libnftables: search for default include path last
Date: Sat, 15 Jun 2024 11:18:25 +0200
Message-Id: <20240615091825.152372-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240615091825.152372-1-pablo@netfilter.org>
References: <20240615091825.152372-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The default include path is searched for files before include paths
specified via -I/--include.

Search for default include path after user-specified include paths to
allow users for test nftables configurations spanning multiple files
without overwriting the globally installed ones.

See:
https://patchwork.ozlabs.org/project/netfilter-devel/patch/20220627222304.93139-1-dxld@darkboxed.org/

Reported-by: Daniel Gröber <dxld@darkboxed.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/libnftables.c |  1 -
 src/scanner.l     | 63 ++++++++++++++++++++++++++++++-----------------
 2 files changed, 41 insertions(+), 23 deletions(-)

diff --git a/src/libnftables.c b/src/libnftables.c
index 40e37bdf8c06..af4734c05004 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -202,7 +202,6 @@ struct nft_ctx *nft_ctx_new(uint32_t flags)
 	nft_init(ctx);
 
 	ctx->state = xzalloc(sizeof(struct parser_state));
-	nft_ctx_add_include_path(ctx, DEFAULT_INCLUDE_PATH);
 	ctx->parser_max_errors	= 10;
 	cache_init(&ctx->cache.table_cache);
 	ctx->top_scope = scope_alloc();
diff --git a/src/scanner.l b/src/scanner.l
index 96c505bcdd48..c825fa79cfd9 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -1175,39 +1175,58 @@ static bool search_in_include_path(const char *filename)
 		filename[0] != '/');
 }
 
+static int include_path_glob(struct nft_ctx *nft, void *scanner,
+			     const char *include_path, const char *filename,
+			     const struct location *loc)
+{
+	struct parser_state *state = yyget_extra(scanner);
+	struct error_record *erec;
+	char buf[PATH_MAX];
+	int ret;
+
+	ret = snprintf(buf, sizeof(buf), "%s/%s", include_path, filename);
+	if (ret < 0 || ret >= PATH_MAX) {
+		erec = error(loc, "Too long file path \"%s/%s\"\n",
+			     include_path, filename);
+		erec_queue(erec, state->msgs);
+		return -1;
+	}
+
+	ret = include_glob(nft, scanner, buf, loc);
+
+	/* error was already handled */
+	if (ret == -1)
+		return -1;
+	/* no wildcards and file was processed: break early. */
+	if (ret == 0)
+		return 0;
+
+	/* else 1 (no wildcards) or 2 (wildcards): keep
+	 * searching.
+	 */
+	return ret;
+}
+
 int scanner_include_file(struct nft_ctx *nft, void *scanner,
 			 const char *filename, const struct location *loc)
 {
 	struct parser_state *state = yyget_extra(scanner);
 	struct error_record *erec;
-	char buf[PATH_MAX];
 	unsigned int i;
 	int ret = -1;
 
 	if (search_in_include_path(filename)) {
 		for (i = 0; i < nft->num_include_paths; i++) {
-			ret = snprintf(buf, sizeof(buf), "%s/%s",
-				       nft->include_paths[i], filename);
-			if (ret < 0 || ret >= PATH_MAX) {
-				erec = error(loc, "Too long file path \"%s/%s\"\n",
-					     nft->include_paths[i], filename);
-				erec_queue(erec, state->msgs);
-				return -1;
-			}
-
-			ret = include_glob(nft, scanner, buf, loc);
-
-			/* error was already handled */
-			if (ret == -1)
-				return -1;
-			/* no wildcards and file was processed: break early. */
-			if (ret == 0)
-				return 0;
-
-			/* else 1 (no wildcards) or 2 (wildcards): keep
-			 * searching.
-			 */
+			ret = include_path_glob(nft, scanner,
+						nft->include_paths[i],
+						filename, loc);
+			if (ret <= 0)
+				return ret;
 		}
+		ret = include_path_glob(nft, scanner, DEFAULT_INCLUDE_PATH,
+					filename, loc);
+		if (ret <= 0)
+			return ret;
 	} else {
 		/* an absolute path (starts with '/') */
 		ret = include_glob(nft, scanner, filename, loc);
-- 
2.30.2

