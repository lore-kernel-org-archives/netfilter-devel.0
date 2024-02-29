Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A2DC7A714
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Feb 2024 10:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709203518; cv=none; b=gPi60xcXaXqGg3yX0oCQPE5yT1IzMa/0nYjo+sfLcwvCnuAAragRUg67k2Xd47VI1+j1PzhVvS9uNfOKP7j7McG8PlYyRdWKN8gYiGNXG4DbJHVsYhkzyhSjIToQ6tejSHSiBkEgxhVTT/MoEbE0/z94d2yMu5ExrVx/Beg9b7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709203518; c=relaxed/simple;
	bh=DfPgEWwY1a0JHV5G0IkxFZsnCWbA708Dng/iJ77jps4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TeZH8hLORxTf9DTs6KG1HUebC7ougSeVwJxts9BqqIk7KgFVKhdEFT7Qw2lJXfOwsUlQEIr8rAMBvpipOPSJnn8+4PMbSHJMeKu0Y4BMzGiRaxww7t/NqeZ7mEVt5a6tF4A2lj40HU005iu9l/L5LblJ9XDzsIW1McwZeZD2hqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rfduW-0007dM-VM; Thu, 29 Feb 2024 11:45:08 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 1/3] parser: allow typeof in objref maps
Date: Thu, 29 Feb 2024 11:41:23 +0100
Message-ID: <20240229104347.5156-2-fw@strlen.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240229104347.5156-1-fw@strlen.de>
References: <20240229104347.5156-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Its currently not possible to declare a map that
stores object references with the "typeof" keyword, e.g.

map m {
	type ipv4_addr : limit

will work, but

map m {
	typeof ip saddr : limit

will give a syntax error ("unexpected limit").
Followup pach will add support for listing side too.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/parser_bison.y | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index cba37c686f66..cd1dc658882d 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -2340,6 +2340,15 @@ map_block		:	/* empty */	{ $$ = $<set>-1; }
 				$1->flags  |= NFT_SET_OBJECT;
 				$$ = $1;
 			}
+			|	map_block	TYPEOF
+						typeof_expr 	COLON	map_block_obj_type
+						stmt_separator
+			{
+				$1->key = $3;
+				$1->objtype = $5;
+				$1->flags  |= NFT_SET_OBJECT;
+				$$ = $1;
+			}
 			|	map_block	FLAGS		set_flag_list	stmt_separator
 			{
 				$1->flags |= $3;
-- 
2.43.0

