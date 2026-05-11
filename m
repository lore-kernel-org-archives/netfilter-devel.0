Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB72037FF71
	for <netfilter-devel@vger.kernel.org>; Mon, 11 May 2026 20:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778529999; cv=none; b=JAG+KgjxGxjB0Yd0iUHZMH0yHDSMb5peAeYEBuwzzFIOeTbGGdNc1K7yWXzvOXt5+eqzHvsAH1oN6um0ndV45THlgRnCAXlWhEGGPyzuEUglLFn4mDpSKyCE0l8U4L4nOrIZcWB/7WNiVuGUBd5qEajUKpj5CW1WMHGTPK7TEys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778529999; c=relaxed/simple;
	bh=5N9R2VVjnvcl9UYVv0roYO9s8FPv5Xifw9PGLSGtnmQ=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=E3u6gwT1bQEZmwVD1CEjfYtrJyigFeQw+SOSzyD3DChaAewG1n404CuJyhQ9ynRgwCTq2P3QXdC/2agd3Po/BmyYXzraCPQb1ZXIgvecR0TuKF88FMVup3D4a2kC1NuQ1ZKpz7UgajBy7n3b3bIgycYbFMxgZOiIkzekc7YQTcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=hwD4YJoM; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="hwD4YJoM"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 46038600BA
	for <netfilter-devel@vger.kernel.org>; Mon, 11 May 2026 22:06:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1778529994;
	bh=dh5MJpL5ymD+lW3Qko0ZEr3RVOyjLL1OVw6yQGBAuaA=;
	h=From:To:Subject:Date:From;
	b=hwD4YJoMtW55QvMPgKueJ8oe72NucaWX35hSQufU4ZyrK9Ij08Zn1R0aebnZ7zmh7
	 3nMTmt9KlVL/AfE4ErINX3e68NYXzbf7a7zCmb4XBuXTHjYdNZEB97uRwiDmDqtAar
	 /EWjtI2Kg8oKEL5+2RJwTuks5L+Pk7riQC2QU2DJbS1Y9RDy3EI+Vvih11ziJQDMr+
	 o0Xf3gimJo+M/MtggItJAt4DWJh3/AtOfYrEC36ZO2sl7Z2DLipwe+gMeSJeQEa+w0
	 Di6vQjg+poRpBB1wbAF0wnfh0w9cWrcncihjT0Fyq1flRJBZlGREz74ZnpmMubfnB4
	 b0SHPXxdJiXMw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft] cache: honor -c/--check for reset commands
Date: Mon, 11 May 2026 22:06:30 +0200
Message-ID: <20260511200630.719755-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently:

  nft -c reset rules ip x

ignores -c/--check.

The reset and list commands use the netlink GET/DUMP nfnetlink API which
provides no check semantics, compared to the NEW/DELETE nfnetlink batch
API which indeed does.

Emulate -c/--check for the reset command by handling this as a list
command, so the state of the objects is just listed, not reset. This
allows to check for presence and dump the content of the objects.

Fixes: dbff26bfba83 ("cache: consolidate reset command")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/cache.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/src/cache.c b/src/cache.c
index bad8275326c7..75b4877d83cb 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -516,7 +516,10 @@ int nft_cache_evaluate(struct nft_ctx *nft, struct list_head *cmds,
 			flags = evaluate_cache_get(cmd, flags);
 			break;
 		case CMD_RESET:
-			flags = evaluate_cache_reset(cmd, flags, filter);
+			if (nft->check)
+				flags = evaluate_cache_list(nft, cmd, flags, filter);
+			else
+				flags = evaluate_cache_reset(cmd, flags, filter);
 			break;
 		case CMD_LIST:
 			flags = evaluate_cache_list(nft, cmd, flags, filter);
-- 
2.47.3

