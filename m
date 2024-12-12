Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F31AB2F2F
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Dec 2024 22:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734042287; cv=none; b=X8SzIuLoI8r++NStLGuTRMKtqMJnIMTtrDGpQ8DRlwj7j1QfLGiUW4y6/jVbdoD466B70wvnuJYHtAFoPLv9K8WSy30338FppOBWBEyg7J5LzZY+iSNlJjNmkXTPiorWW1yfkm1fdKONwy3JvIHjPVsGE96f9KnM+QDSiGeNrts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734042287; c=relaxed/simple;
	bh=7TNcgXoiSkg0W/BVS79Ngz7lFe82TlmQ0nO0GLfIkR4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=uOd6fWOEdpQwI8L5Zx62lwuuZGo2gcTV5AZrZ5TayBc+5nAqYVkTDDsk6A213IMKABPRoRoujACRy9rmcwhfFNKhfOqBrGG/1TINvuEUuhY+CkcWr6ngurTJQv1b9a36/j20hzp3i/ROA9WEBo+fFsLn8mww+3g/cu34VCjB9EE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: caskd@redxen.eu
Subject: [PATCH nft] libnftables: include canonical path to avoid duplicates
Date: Thu, 12 Dec 2024 23:24:36 +0100
Message-Id: <20241212222436.179133-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A recent commit adds base directory of -f/--filename to include paths by
default to address a silly use of -I/--include to make this work:

  # nft -I /path/to -f /path/to/main.nft

instead users can simply invoke:

  # nft -f /path/to/main.nft

because /path/to/ is added at the end of the list of include paths.

This example above assumes main.nft includes more files that are
contained in /path/to/.

However, globbing can cause duplicates after this recent update, eg.

  # cat test/main
  table inet test {
        chain test {
                include "include/*";
        }
  }
  # nft -I /tmp/test/ -f test/main

because /tmp/test and test/ twice refer to the same directory and both
are added to the list of include path.

Use realpath() to canonicalize include paths. Then, search and skip
duplicated include paths.

Fixes: 302e9f8b3a13 ("libnftables: add base directory of -f/--filename to include path")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/libnftables.c                             | 29 +++++++++++++++++--
 .../include/dumps/glob_duplicated_include.nft |  6 ++++
 .../testcases/include/glob_duplicated_include | 19 ++++++++++++
 3 files changed, 52 insertions(+), 2 deletions(-)
 create mode 100644 tests/shell/testcases/include/dumps/glob_duplicated_include.nft
 create mode 100755 tests/shell/testcases/include/glob_duplicated_include

diff --git a/src/libnftables.c b/src/libnftables.c
index 1df22b3cb57d..c8293f77677f 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -167,8 +167,19 @@ void nft_ctx_clear_vars(struct nft_ctx *ctx)
 	ctx->vars = NULL;
 }
 
-EXPORT_SYMBOL(nft_ctx_add_include_path);
-int nft_ctx_add_include_path(struct nft_ctx *ctx, const char *path)
+static bool nft_ctx_find_include_path(struct nft_ctx *ctx, const char *path)
+{
+	unsigned int i;
+
+	for (i = 0; i < ctx->num_include_paths; i++) {
+		if (!strcmp(ctx->include_paths[i], path))
+			return true;
+	}
+
+	return false;
+}
+
+static int __nft_ctx_add_include_path(struct nft_ctx *ctx, const char *path)
 {
 	char **tmp;
 	int pcount = ctx->num_include_paths;
@@ -184,6 +195,20 @@ int nft_ctx_add_include_path(struct nft_ctx *ctx, const char *path)
 	return 0;
 }
 
+EXPORT_SYMBOL(nft_ctx_add_include_path);
+int nft_ctx_add_include_path(struct nft_ctx *ctx, const char *path)
+{
+	char canonical_path[PATH_MAX];
+
+	if (!realpath(path, canonical_path))
+		return -1;
+
+	if (nft_ctx_find_include_path(ctx, canonical_path))
+		return 0;
+
+	return __nft_ctx_add_include_path(ctx, canonical_path);
+}
+
 EXPORT_SYMBOL(nft_ctx_clear_include_paths);
 void nft_ctx_clear_include_paths(struct nft_ctx *ctx)
 {
diff --git a/tests/shell/testcases/include/dumps/glob_duplicated_include.nft b/tests/shell/testcases/include/dumps/glob_duplicated_include.nft
new file mode 100644
index 000000000000..8e316e9dfa49
--- /dev/null
+++ b/tests/shell/testcases/include/dumps/glob_duplicated_include.nft
@@ -0,0 +1,6 @@
+table inet test {
+	chain test {
+		tcp dport 22 accept
+		tcp dport 25 accept
+	}
+}
diff --git a/tests/shell/testcases/include/glob_duplicated_include b/tests/shell/testcases/include/glob_duplicated_include
new file mode 100755
index 000000000000..4507f5d937e0
--- /dev/null
+++ b/tests/shell/testcases/include/glob_duplicated_include
@@ -0,0 +1,19 @@
+#!/bin/bash
+
+set -e
+
+trap "rm -rf $tmpdir" EXIT
+
+tmpdir=$(mktemp -d)
+mkdir -p $tmpdir/test/include
+cat > $tmpdir/test/main << EOF
+table inet test {
+        chain test {
+                include "include/*";
+        }
+}
+EOF
+echo "tcp dport 22 accept;" > $tmpdir/test/include/one
+echo "tcp dport 25 accept;" > $tmpdir/test/include/two
+
+$NFT -I $tmpdir/test/ -f $tmpdir/test/main
-- 
2.30.2

