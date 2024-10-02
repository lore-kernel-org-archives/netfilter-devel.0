Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A0BD215F4F
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Oct 2024 19:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727897942; cv=none; b=m8a3luJMtuxV/DUSJoLHErRx5bhfMBv+E7iCch/T35vQIXTRQjlNwtOoPPVl8CMIby3yk1FcrtFg0NaDODspomvmopv2yQu3Vy+tlpfEd1PqX9YZgDT5MMdq7T5hCPtBiIUAV/rahTykKBMbxyx640EhGzDUjIrnc/Dy+2V46zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727897942; c=relaxed/simple;
	bh=jn5GXlm22OHb6owPf7MhmZvtFd0GJw7VbNzk1hvm6uE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nkLWxbD44TAJC63gtbN7/B4qIsMpa7jZI4vSIWJeYY96DEFjH4IHiTbrmTZ59ONB+r52DIfUmyu+UGKvFFo5UKAf6+tntwJRfuwFoaiwag/4F6+zS788Hcq7B7v/GuEjWIgdRuSXybzpUMMvYiNE6kwa5PHeukEu/8hBGazrYyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=BGPNSNGf; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="BGPNSNGf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=+cZDeeOHFqUE1FJ65YOJLLxiPA1/yunArSCmg5lJGms=; b=BGPNSNGf2Y7CJuEIJDky9K1cuP
	Fcf3BYwut1PuDNLx/m/GbW+IVl9eMiyWB0+VcHs1Ks9g9t2NqB+1aRMki24svSZJNZ4lYH+Hqg1IJ
	ViBFwIanhPXOx+Wh50uKXLX8vToIQOfjVaqv7jNASxllpEBCtR/CfsmfvsEa+6wqy9HL3Pn5/cS8h
	lpCc1QKNQMuwqh+IE64uaHIVH0OrQCKA2/pEcIu3XSE8+ImNBKGnXSJHZ5WquECr2Lxs+TTNC+txi
	gUmpRL5LrGJ/lvuEPXRlI+ImIlFeKUyd/ZZqB5vLVUsPLGIGDThfzEqOA9iC3UuPUtxXlMLbE0Jn5
	lL2KT7pA==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sw5Ba-0000000030j-48Zj;
	Wed, 02 Oct 2024 21:38:59 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 6/9] parser_bison: Accept ASTERISK_STRING in flowtable_expr_member
Date: Wed,  2 Oct 2024 21:38:50 +0200
Message-ID: <20241002193853.13818-7-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241002193853.13818-1-phil@nwl.cc>
References: <20241002193853.13818-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

All clauses are identical, so instead of adding a third one for
ASTERISK_STRING, use a single one for 'string' (which combines all three
variants).

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/parser_bison.y | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index e2936d10efe4c..d9cf2cd25c2f0 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -2477,16 +2477,7 @@ flowtable_list_expr	:	flowtable_expr_member
 			|	flowtable_list_expr	COMMA	opt_newline
 			;
 
-flowtable_expr_member	:	QUOTED_STRING
-			{
-				struct expr *expr = ifname_expr_alloc(&@$, state->msgs, $1);
-
-				if (!expr)
-					YYERROR;
-
-				$$ = expr;
-			}
-			|	STRING
+flowtable_expr_member	:	string
 			{
 				struct expr *expr = ifname_expr_alloc(&@$, state->msgs, $1);
 
-- 
2.43.0

