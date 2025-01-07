Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 685E5273F9
	for <netfilter-devel@vger.kernel.org>; Tue,  7 Jan 2025 23:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736291963; cv=none; b=j+mj/nVtrc9KaRi0TNYCIPT/52P3RtGjVSuemhphqCWjMjGoWJjtrmK/u/+1jXK720b/bfNrnE/JsKsf/EiYMn3Yv43qq1jt0ZiD0+t2RHQUooMDEhIXXqF6E6Ir8/2FtdWzSagAilNW7yQGkWN0WMS0lKunS8qReIf9o795qRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736291963; c=relaxed/simple;
	bh=kyD8+xF5zJIdsH7eIN8sn+A6sWutYaLrCTbuYoNvm1o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GvvRiRCwM7suvHvG2kJeZIYFzw+t8LsL8zw5Mm65Tuj+8oXYgrr8wPB4ydqgmNJBXl7e80OnJO2HGnmN87Zq4WY9vDwq7vTOhdI1RaQHNWtqlMnEDejulHHGSvp1tdnogY73CAQvHy3JDJVTBBx2jqKIzYrLrmIl+pQxw/NpnPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1tVIr0-0004vZ-BL; Wed, 08 Jan 2025 00:19:18 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] parser_bison: fix UaF when reporting table parse error
Date: Tue,  7 Jan 2025 23:55:06 +0100
Message-ID: <20250107225509.6539-1-fw@strlen.de>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It passed already-freed memory to erec function.  Found with afl++ and asan.

Fixes: 4955ae1a81b7 ("Add support for table's persist flag")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/parser_bison.y | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 6e6f3cf8335d..7ab15244be52 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -1943,12 +1943,14 @@ table_flags		:	table_flag
 table_flag		:	STRING
 			{
 				$$ = parse_table_flag($1);
-				free_const($1);
 				if ($$ == 0) {
 					erec_queue(error(&@1, "unknown table option %s", $1),
 						   state->msgs);
+					free_const($1);
 					YYERROR;
 				}
+
+				free_const($1);
 			}
 			;
 
-- 
2.45.2

