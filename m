Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5ADEA1CFBC
	for <netfilter-devel@vger.kernel.org>; Sat, 15 Jun 2024 09:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718443121; cv=none; b=d9obkzn/B9qLupAdgeIPhog1m/cemOfXcVXdKoPU2fmwbCS7uck4I43vbx+7XPfDC9W4GkITbwQiFpXTA3iDUNbPkJZCvvfXTbg20FXzjS19iMlEJM997bh+z5gBhjMuuplWGPSPxFRAWdigzs6fT1Q3MG7zBCErgH8cRstF2Kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718443121; c=relaxed/simple;
	bh=AaJzN1bfXlFvaeWA3aTf1bDTc3piubG1rgXR4IDY7vg=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Bxemqle30LyvpZwSb4TzDbJDOWLnwGHr1jrGhHo3CDhuazW8y8S0E7vSU/pc15yc+tbwlclgfXNEx/EgtutcdZrBSSzGe4Ofm14CjXsEyokirfy1XwnvfmR9G/AGQBXHiIHAT6xKO4mex9Q5W/51qCMhHkImQWwOVbo2k800gcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 1/2] libnftables: add base directory of -f/--filename to include path
Date: Sat, 15 Jun 2024 11:18:24 +0200
Message-Id: <20240615091825.152372-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240615091825.152372-1-pablo@netfilter.org>
References: <20240615091825.152372-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch adds an include path relative to the current (the including)
file's directory.

Users of -f/--filename have to explicitly specify -I with a redundant
path to find included files in the main file, eg.

 # nft -I /path/to/files -f /path/to/files/ruleset.nft

Assuming:

 # cat /path/to/files/ruleset.nft
 include "file1.nft"
 include "file2.nft"
 include "file3.nft"

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1661
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 doc/nft.txt       |  2 ++
 src/libnftables.c | 18 ++++++++++++++++++
 2 files changed, 20 insertions(+)

diff --git a/doc/nft.txt b/doc/nft.txt
index e4eb982e75af..3f4593a29831 100644
--- a/doc/nft.txt
+++ b/doc/nft.txt
@@ -43,6 +43,8 @@ understanding of their meaning. You can get information about options by running
 *-f*::
 *--file 'filename'*::
 	Read input from 'filename'. If 'filename' is -, read from stdin.
+	The directory path to this file is inserted at the beginning the list of
+	directories to be searched for included files (see *-I/--includepath*).
 
 *-D*::
 *--define 'name=value'*::
diff --git a/src/libnftables.c b/src/libnftables.c
index 0dee1bacb0db..40e37bdf8c06 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -17,6 +17,7 @@
 #include <cmd.h>
 #include <errno.h>
 #include <sys/stat.h>
+#include <libgen.h>
 
 static int nft_netlink(struct nft_ctx *nft,
 		       struct list_head *cmds, struct list_head *msgs)
@@ -786,6 +787,19 @@ static int nft_run_optimized_file(struct nft_ctx *nft, const char *filename)
 	return __nft_run_cmd_from_filename(nft, filename);
 }
 
+static int nft_ctx_add_basedir_include_path(struct nft_ctx *nft,
+					    const char *filename)
+{
+	const char *basedir = dirname(xstrdup(filename));
+	int ret;
+
+	ret = nft_ctx_add_include_path(nft, basedir);
+
+	free_const(basedir);
+
+	return ret;
+}
+
 EXPORT_SYMBOL(nft_run_cmd_from_filename);
 int nft_run_cmd_from_filename(struct nft_ctx *nft, const char *filename)
 {
@@ -798,6 +812,10 @@ int nft_run_cmd_from_filename(struct nft_ctx *nft, const char *filename)
 	    !nft_output_json(&nft->output))
 		nft->stdin_buf = stdin_to_buffer();
 
+	if (!nft->stdin_buf &&
+	    nft_ctx_add_basedir_include_path(nft, filename) < 0)
+		return -1;
+
 	if (nft->optimize_flags) {
 		ret = nft_run_optimized_file(nft, filename);
 		free_const(nft->stdin_buf);
-- 
2.30.2

