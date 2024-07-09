Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A90719D074
	for <netfilter-devel@vger.kernel.org>; Tue,  9 Jul 2024 15:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720537614; cv=none; b=VC50QpVIXRfTHJSJqwaeBxUjj59DfsysPgzBUH51tadvhqCvMKw8tNBccfSx3kyLIbdDpPvVGXyRlglx8gcni9S9ACbnuzxzZ4XVPHYUonJQTQybwFjUxOix3C2siHRgYtDMrg+6+1aIuLb2EZMzNMgiAyfUzmDHYppTUGsYjKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720537614; c=relaxed/simple;
	bh=pfXf6PuFDShGLO1Goh7Vh1fkkAFOyz8TMbKdWaajcz8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pAxGWatF1b2P8CDn7bwWWGwckos33HjBNYU5FxcDPoVY+7DcPf20EZOygMb7NQvu6QcNDbiHdSxdkokgCoF/60SmwgBdxRRFTakonGu42p/9lQHT0Po45Cw4JvyUFPNU8AFBAkKczv6k5xq6YOCSDlLvqvareZtliPkdlR7jwbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: jami.maenpaa@wapice.com
Subject: [PATCH nft 2/2] libnftables: skip useable checks for /dev/stdin
Date: Tue,  9 Jul 2024 16:59:53 +0200
Message-Id: <20240709145953.135124-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240709145953.135124-1-pablo@netfilter.org>
References: <20240709145953.135124-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

/dev/stdin is a placeholder, read() from STDIN_FILENO is used to fetch
the standard input into a buffer.

Since 5c2b2b0a2ba7 ("src: error reporting with -f and read from stdin")
stdin is stored in a buffer to fix error reporting.

Fixes: 149b1c95d129 ("libnftables: refuse to open onput files other than named pipes or regular files")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/libnftables.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/src/libnftables.c b/src/libnftables.c
index af4734c05004..4676b30a04b1 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -664,6 +664,7 @@ retry:
 
 /* need to use stat() to, fopen() will block for named fifos and
  * libjansson makes no checks before or after open either.
+ * /dev/stdin is *never* used, read() from STDIN_FILENO is used instead.
  */
 static struct error_record *filename_is_useable(struct nft_ctx *nft, const char *name)
 {
@@ -671,6 +672,9 @@ static struct error_record *filename_is_useable(struct nft_ctx *nft, const char
 	struct stat sb;
 	int err;
 
+	if (!strcmp(name, "/dev/stdin"))
+		return NULL;
+
 	err = stat(name, &sb);
 	if (err)
 		return error(&internal_location, "Could not open file \"%s\": %s\n",
@@ -681,9 +685,6 @@ static struct error_record *filename_is_useable(struct nft_ctx *nft, const char
 	if (type == S_IFREG || type == S_IFIFO)
 		return NULL;
 
-	if (type == S_IFCHR && 0 == strcmp(name, "/dev/stdin"))
-		return NULL;
-
 	return error(&internal_location, "Not a regular file: \"%s\"\n", name);
 }
 
-- 
2.30.2

