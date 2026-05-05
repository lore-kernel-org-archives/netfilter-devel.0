Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8B4733C502
	for <netfilter-devel@vger.kernel.org>; Tue,  5 May 2026 10:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777977468; cv=none; b=igfJgN7Gos+fPnFFio2ie8x4pTHXoPgXsUneYwyXrAU2NuOjYalA8YuXlB63p0G7mLs8ChSLlWYAs+qEFemXpxQnsp96x1PQKrL0th2QfK8E0wWB2j4y4FUYXfnMHdlxKAL1NFHiy13uk3PkVeJfNYZR6b5ZrpXkKEqb2nX1Nes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777977468; c=relaxed/simple;
	bh=W5+xFC/lJtnAZDL0WPlbZDCZdFGUHqBmE2lkotgtrhI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FqmoTJEAldJoJRTHcBXQ889ZQoPYeo25E2Uvqcu40JB5OW34O/1E84CzsA08LiA0TyG+HRcTq3/WyZaKjO0tz4WBsXSgID7R6ecuauhBwu+hA9+mBAFywdkbvGC/hFWU+8O+nN5utj5rb5dQsJTcDe5aV03Pc79ZT+sbc+3KTRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 8D796607D4; Tue, 05 May 2026 12:37:44 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] scanner: enable verdicts in rate scope too
Date: Tue,  5 May 2026 12:37:30 +0200
Message-ID: <20260505103739.25949-1-fw@strlen.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Blamed commit added first use of exclusive start conditions in the
nftables parser.

Inclusive start conditions extend the grammar:
 - token NEW_COND will start to match in scanner.l
 - all other known tokens remain valid
 - bison calls back into scanner.l (via scanner_pop_start_cond())
   when it has parsed a complete rule.

Exclusive start conditions work in the same way, but with a slight
difference: Once we enter SCANSTATE_RATE, ALL OTHER tokens that are
not SCANSTATE_RATE or tagged as <*>, will stop matching.

This was done to allow something like 1 mbytes/second get handled
via NUM MBYTES SLASH SECOND rather than STRING (which is no longer
in scope).

This is a problem: in nftables, there is no end-token for
the 'rate' keyword.  The scanstate is popped the same way as for
the inclusive start conditions.  But flex is greedy.  By the time
we call scanner_pop_start_cond(), next token has already been parsed
according to RATE rules.

This breaks following rule:
  nft add rule .. limit rate over 1 mbytes/second drop
  Error: syntax error, unexpected junk
  expected any of: end of file, newline, semicolon, [..] drop, continue ...

Problem is that flex parsed 'd'(rop) while in SCANSTATE_RATE.

There is no good solution for this problem (aside from altering the
grammar to be explicitly scoped, e.g. limit rate { over ... }

Another alternative might be to add some string-alike catchall rule to
<SCANSTATE_RATE> in scanner.l and use that to pop state + rescan via
yyless(0).  But it feels even more gross than this.

Technially we'd have to <*> a lot more keywords, e.g.

 rate over 1 mbytes/second ip saddr 1.2.3.4

is valid (or should be).  Its not allowed anymore either.
It makes a bit less sense to add expressions after a rate limiter, however.

Fixes: 9d105581b5f1 ("scanner: Introduce SCANSTATE_RATE")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/scanner.l | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/src/scanner.l b/src/scanner.l
index 1b4eb1cf13a4..bd66cf7bbfa1 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -348,12 +348,15 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 }
 "tproxy"		{ scanner_push_start_cond(yyscanner, SCANSTATE_STMT_TPROXY); return TPROXY; }
 
+<*>{
 "accept"		{ return ACCEPT; }
 "drop"			{ return DROP; }
 "continue"		{ return CONTINUE; }
 "jump"			{ return JUMP; }
 "goto"			{ return GOTO; }
 "return"		{ return RETURN; }
+}
+
 <SCANSTATE_EXPR_QUEUE,SCANSTATE_STMT_DUP,SCANSTATE_STMT_FWD,SCANSTATE_STMT_NAT,SCANSTATE_STMT_TPROXY,SCANSTATE_IP,SCANSTATE_IP6>"to"			{ return TO; } /* XXX: SCANSTATE_IP is a workaround */
 
 "inet"			{ return INET; }
-- 
2.53.0

