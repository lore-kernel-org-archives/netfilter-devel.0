Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C7D21AE05E
	for <netfilter-devel@vger.kernel.org>; Wed, 14 Aug 2024 11:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723633657; cv=none; b=NGfYFIoBb16HPmknbltxTkpgOwPEsJ+CGLzh5OYRhm5kCExJPpMZqmwbK3FJd4YN9jtfE4DLotFfvm50tDr3ejVAtDAArKORuVBZewr/264/IWcjf6+adO/Hk/jsuIwkRlO7oEiNSvIur7NPpTgYONljnEXytP1n7Pu5P3c8Db0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723633657; c=relaxed/simple;
	bh=i+fAVeFUQ3eo+yUeh8xEoHll3a7oQzbT3TBeZSVnptM=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YhJ+wft/IbJz+7vy1gMFWOMeCpvwNzlyxew7vWTMycU8eNRGcWrImL1Rc0OPbAc/7bY+bdl5wTaHBLftNmGZ6wN3eipgxM62BY2BfbookJv6HZZ8qFokHNRuTk9kfHecMUWKL8Nk/mjsimp0YQJy6BPMroCqRhY/tBRBrvuYHZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 2/2] datatype: improve error reporting when time unit is not correct
Date: Wed, 14 Aug 2024 13:07:22 +0200
Message-Id: <20240814110722.274358-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240814110722.274358-1-pablo@netfilter.org>
References: <20240814110722.274358-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Display:

  Wrong unit format, expecting bytes or kbytes or mbytes

instead of:

  Wrong rate format

Fixes: 6615676d825e ("src: add per-bytes limit")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/datatype.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/datatype.c b/src/datatype.c
index 8879ff0523e8..24c3512d2a06 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -1477,7 +1477,7 @@ static struct error_record *time_unit_parse(const struct location *loc,
 	else if (strcmp(str, "week") == 0)
 		*unit = 1ULL * 60 * 60 * 24 * 7;
 	else
-		return error(loc, "Wrong rate format");
+		return error(loc, "Wrong time format, expecting second or minute or hour or day or week");
 
 	return NULL;
 }
-- 
2.30.2

