Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9DB53CCFD3
	for <netfilter-devel@vger.kernel.org>; Thu,  9 Apr 2026 13:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775742798; cv=none; b=UaYosYFTNQp8SX2T6aMI3+kwwzh8fhCH+5v4stxt4EcGas78GjAfA3BaKsfpE9jsxHbx+w63m+NNN2Le4k9Nw6POWPtEfS6mmEIuotM06XGFoJRP95fNK5IyaOoGra9PWu6IASMIaZoOrYZyOKiqLKo6ENO/sizX9IZ9fQmNQnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775742798; c=relaxed/simple;
	bh=9u6ngc0ZuFsLWmVJgMpInLo4LBvVV3K2EPyYBVxtFXY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RN2NHb6SHyZrKvP8mpQ1XrR8cCXBL9RilXmxigAA8BsTD+F474J/ZSma8Ue3HlTglWTGS1bzZ7A9Skg6WaRwxiDmGeLfqMjtGytMe3QH1/a1LYWRFhIjHBuQgK4PJLZPtSuAdcQu5XNV9BGNBnwjKvT6f8lmNwsOMMZoXAJZuQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=pVqNEfWO; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="pVqNEfWO"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id B7A0660181;
	Thu,  9 Apr 2026 15:53:14 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1775742795;
	bh=2UPQ5oMClfE6GCt3zBww21zcRdq2X/3rTwxhiiYG3Hg=;
	h=From:To:Cc:Subject:Date:From;
	b=pVqNEfWOZrKuPUmwzP0yILcmw+vr4snGi+TQ8Np+wMIhV0Yr60JIYyAMHcnrU6xAL
	 05BXohasuGpALHNXgiXlANdp+QprYf+TMimxFQ+HwekoQ3b9PxmQ9BmxcFNm3py+6C
	 rg2pYCC+DRz7pClJdpu8xsUsX3Wxbt5aq9Phezo+faczXXLKPt1CW/9Lrx2ai5Oer+
	 W3IM+ChF8Uq6cU//BYhZ7YJY0L7ROlIrSKgL7h5+IysZ5a11qQIc5O9ueW5VmuM/PP
	 +2joCGV78ONgwq2IY4FuKPgeg/JLTVj9K5zzMEhyCqFnowBFb70JSPTzjTlIEN6DOW
	 28TqxiKugyl0w==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de,
	phil@nwl.cc
Subject: [PATCH nft,v2 1/5] main: consolidate EPERM to non-root users
Date: Thu,  9 Apr 2026 15:53:11 +0200
Message-ID: <20260409135311.49221-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Move the check added by 3cfb9e4b3e40 ("src: report EPERM for non-root users")
to the main function.

EPERM is also possible when removing a ruleset that is owned by a
process, tone it down to suggest that root is maybe needed.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: handle EPERM from main, per Florian.
    I'm not resending the entire series at this stage,
    patch 2/5, 3/5, 4/5 and 5/5 got no changes.

 src/libnftables.c | 7 +------
 src/main.c        | 2 ++
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/src/libnftables.c b/src/libnftables.c
index 66b03a1170bb..bc42c32de889 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -630,13 +630,8 @@ int nft_run_cmd_from_buffer(struct nft_ctx *nft, const char *buf)
 	parser_rc = rc;
 
 	rc = nft_evaluate(nft, &msgs, &cmds);
-	if (rc < 0) {
-		if (errno == EPERM) {
-			fprintf(stderr, "%s (you must be root)\n",
-				strerror(errno));
-		}
+	if (rc < 0)
 		goto err;
-	}
 
 	if (parser_rc) {
 		rc = parser_rc;
diff --git a/src/main.c b/src/main.c
index 29b0533dee7c..4cb51ff7f5fe 100644
--- a/src/main.c
+++ b/src/main.c
@@ -548,6 +548,8 @@ int main(int argc, char * const *argv)
 		goto out_fail;
 	}
 
+	if (rc && errno == EPERM)
+		 fprintf(stderr, "Error: %s (perhaps you must be root?)\n", strerror(errno));
 out:
 	nft_ctx_free(nft);
 	return rc;
-- 
2.47.3

