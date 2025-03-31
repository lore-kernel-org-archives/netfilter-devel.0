Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C62C1DDC07
	for <netfilter-devel@vger.kernel.org>; Mon, 31 Mar 2025 17:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743443792; cv=none; b=aMxlhLQrI5/+01Gq5i3a9x1hSusLDAkKB4vS1YWH/2yfzwfZOGzWhJYKDpEkCicAsoc7NhCMwbTjzGgWqKakCm4lmbByFSIXGDgC/ePngYwP9U4Yeht8NnFH82TbHikvmvvKj6gaBkhC6wt/7IOtSGEkiwpeQ5KPt6EnffvE8yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743443792; c=relaxed/simple;
	bh=nTU+3HF0EN0NRnzkCf8w6hVXAar4MVZlQ1GKGuV44+M=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=o85G+MMWJMaHVFq6HG8X+TUh2dRYaaTUOy5gNMfUGVAE+pE+edKUnylvmxOUQg/nQIWF0mVQ2P5ZVic+qwrrxKy/3vUb2fQyPaF1Uqyxj0qNu3C2qnjxmqDU8lM8W6hKhiakZSZ4ji5+cB/f5qofYrZ4aF+qdQX+ZNTAW5FV/mI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=FwLqTvAz; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=PTvXTor3; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="FwLqTvAz";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="PTvXTor3"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 10B2F60398; Mon, 31 Mar 2025 19:56:27 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1743443787;
	bh=jhVhetr2VKCr/h1C3Isjxi3aGb5zpVu33z8Lj/Z3naY=;
	h=From:To:Cc:Subject:Date:From;
	b=FwLqTvAzzB5k41JdGNLO6BMqq5HtxcDmvm/pgba470yzWCgNer03Av7H3G4MDqZhh
	 sHJU+wkoMnALz+rMOQ3A6IxSGdD6LTAaP+r0t76v3hkhU4Q27Atxj42c1gy3F2duuC
	 GiT67Tk1e+GSryQk2AjbkxOe7cKTnj2OwYqXkQd2w66CYnKQIHhG0ez6H03k7taqt6
	 LRfubrvitaV5nNH5QEq+sZnyNn/3wnaxqHOOvWGh5EHe24ac3UzabgnWRCz0VTM2Nh
	 bo8Z/yqNl00SWoricdV9Bocd9eP6T06JqoUYjefqRQ6xtHNkJ4oKQ2GoHhzRVsnupZ
	 lV8waiao0TDWA==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 6134F60398;
	Mon, 31 Mar 2025 19:56:26 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1743443786;
	bh=jhVhetr2VKCr/h1C3Isjxi3aGb5zpVu33z8Lj/Z3naY=;
	h=From:To:Cc:Subject:Date:From;
	b=PTvXTor30sYKf9xpbgXk4wELP7RdA0NaRFmPZklUIsFHyLk93O4uqGEwiEhLAwJDf
	 ihsSapsJGuLUgUmtNpAquU705eWZhihxVZGM5rEQqdr9UagBjaBgcZjN31W4BJ9nxr
	 u6wShX/hckdlCeFy+GrUgcdywGzTchrci5A4CjDBegOGbZX08Mbpl7Bnoq3bpiQvuz
	 fUfZtK/gs7Acj8E2vvBzuLMUnLHUZKNz1+cwRwIXjojse2NwU5ZSVzZLGS1FcCYcZF
	 aKJlKUHRrAU0+EI2mK4ssxl9O26NKp2u/pn42KHEr7T++dR8vhGAARCLd5Icr1wvk8
	 rLZrgnpwi0LZw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: [PATCH nft,v2] parser_json: reject empty jump/goto chain
Date: Mon, 31 Mar 2025 19:56:21 +0200
Message-Id: <20250331175621.857806-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When parsing a verdict map json where element jumps to chain represented
as empty string.

internal:0:0-0: Error: Parsing list expression item at index 0 failed.
internal:0:0-0: Error: Invalid set elem at index 0.
internal:0:0-0: Error: Invalid set elem expression.
internal:0:0-0: Error: Parsing command array at index 2 failed.

Fixes: 586ad210368b ("libnftables: Implement JSON parser")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: missing check for .need_chain, previous patch breaks.

 src/parser_json.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/src/parser_json.c b/src/parser_json.c
index 9d5ec2275b30..053dd81a076f 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -1360,9 +1360,13 @@ static struct expr *json_parse_verdict_expr(struct json_ctx *ctx,
 		if (strcmp(type, verdict_tbl[i].name))
 			continue;
 
-		if (verdict_tbl[i].need_chain &&
-		    json_unpack_err(ctx, root, "{s:s}", "target", &chain))
-			return NULL;
+		if (verdict_tbl[i].need_chain) {
+			if (json_unpack_err(ctx, root, "{s:s}", "target", &chain))
+				return NULL;
+
+			if (!chain || chain[0] == '\0')
+				return NULL;
+		}
 
 		return verdict_expr_alloc(int_loc, verdict_tbl[i].verdict,
 					  json_alloc_chain_expr(chain));
-- 
2.30.2

