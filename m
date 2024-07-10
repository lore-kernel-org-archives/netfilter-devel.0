Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63E0A1DDC5
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Jul 2024 13:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720618932; cv=none; b=Ae+/qUBbYkL/syK58SdmRBV5bmaShbH+mHu/LOirm/ZM6HNCl6zJdtgyU1z4d80XCSgubZaRYYuGr94BxnMYnPYZ7125SeHVES3SAUud+tGZtS9UajHXYks8w9Nqns4aR3hVBsXRf1pic/fc+au9B/1U5/LMeLrUghXv0fEvTEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720618932; c=relaxed/simple;
	bh=AnDdVeeDQ5IjJ5YB/vBJ3G7OLWAFsCpr8ImeF98DHiM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Pz0rc20+adyGKOD7dezeGV0EA/qCy089TTsr64dKR6KOrQUsiN9ikLcvf8GYg+tXpIqDJBLp4fhaFzZfTwY8WALAwF2aSEZ98XMIffOCFqJpxX1uh+c2OqgyNSr+5PSazeQQNJdBD4M6Gehe59xdUqtCsqrRm4G4gZYQqaaVdFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1sRXaB-0005Aw-EU; Wed, 10 Jul 2024 15:42:07 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] libnftables: fix crash when freeing non-malloc'd address
Date: Wed, 10 Jul 2024 15:31:44 +0200
Message-ID: <20240710133146.14287-1-fw@strlen.de>
X-Mailer: git-send-email 2.44.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

dirname may return static pointer:
munmap_chunk(): invalid pointer
20508 Aborted  nft -f test

Fixes: 6ef04f99382c ("libnftables: search for default include path last")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/libnftables.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/src/libnftables.c b/src/libnftables.c
index af4734c05004..586f8fdede76 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -789,12 +789,12 @@ static int nft_run_optimized_file(struct nft_ctx *nft, const char *filename)
 static int nft_ctx_add_basedir_include_path(struct nft_ctx *nft,
 					    const char *filename)
 {
-	const char *basedir = dirname(xstrdup(filename));
+	char *basedir = xstrdup(filename);
 	int ret;
 
-	ret = nft_ctx_add_include_path(nft, basedir);
+	ret = nft_ctx_add_include_path(nft, dirname(basedir));
 
-	free_const(basedir);
+	free(basedir);
 
 	return ret;
 }
-- 
2.44.2

