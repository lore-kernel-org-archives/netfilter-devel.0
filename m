Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3041A3B6BF7
	for <netfilter-devel@vger.kernel.org>; Wed,  8 Apr 2026 11:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775649572; cv=none; b=aEkR//aOWgyAjlM4Lz41sD0Vu1rTOAmpsCl4nyV0azgB7FZ/8Aarh9xtdRDrj7OwMNzA5hDmQEXYUL6v9SY+GMiqD4t47SoDc6xOAK+9RyUT/wHDuldz/rf3M/HR0cfrz6vflGWoBkeYxcsqTD5tO/wrmAHAw+8pBlTKQKA7t7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775649572; c=relaxed/simple;
	bh=Z4quZgflTmYrPJlhqO9J+meC5XZQYHv2hoTxFOtVXUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sKXM+hX8pfR8NgIp1Pw9Naa8u8Ej99ccuS3Ybn/t8crr6JlgSotGs7eUJkmT0nqQqRqSuzJymVSPKEUAQzRLQO9AwygkGcD/BM4DBrumiWj8HwsGLPX6qxyqbHaTuz6lEdyyx8w9hi93bGxLJXEJw7z7V7QWKKjYvaRlGLUPqVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=cLUSwaex; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="cLUSwaex"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id AD5826033A;
	Wed,  8 Apr 2026 13:59:29 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1775649569;
	bh=YIUsS0/NiGxqVY30KO0n2Ja21g9wzYsL+FCcI8lUwuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cLUSwaexb7n3dag61TJo4NJDoN+0iL3K12mwwcY7ZESmkjOiRpp5/tS+E1MhrY6Z6
	 oWLOo2BwirerFEZOPtHKcPEjRzXFpm5HG3XszCy7xMNv3xrx7UZ3BGQ9D384H0kO5a
	 x+EggO0qfySFnoOJaws/dQe6N87OsuaslH+BRBYftiuF5imo6D+zf+Rru3TEZaFsWm
	 tn5iQ5+Nph6mybhQgcUXLzCcWCa/QoOLU/dWutTpbmOkS5UzzW4cVtA8yWDV1ZDVzt
	 CHWukkmiP+kYPyn66WTuwWHncJR/tmCxxl7iznZuz7khv18JgYUmZSeyOYkIMhFUCI
	 VGg6Pp20EfGcQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: phil@nwl.cc,
	fw@strlen.de
Subject: [PATCH nft 1/5] libnftables: report EPERM to non-root users with -f/--filename
Date: Wed,  8 Apr 2026 13:59:18 +0200
Message-ID: <20260408115922.48676-2-pablo@netfilter.org>
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

Similar to 3cfb9e4b3e40 ("src: report EPERM for non-root users").

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/libnftables.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/src/libnftables.c b/src/libnftables.c
index 66b03a1170bb..e3218da9f48f 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -767,8 +767,13 @@ static int __nft_run_cmd_from_filename(struct nft_ctx *nft, const char *filename
 		nft_optimize(nft, &cmds);
 
 	rc = nft_evaluate(nft, &msgs, &cmds);
-	if (rc < 0)
+	if (rc < 0) {
+		if (errno == EPERM) {
+			fprintf(stderr, "%s (you must be root)\n",
+				strerror(errno));
+		}
 		goto err;
+	}
 
 	if (parser_rc) {
 		rc = parser_rc;
-- 
2.47.3

