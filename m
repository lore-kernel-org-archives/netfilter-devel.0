Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88E43221F38
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Jul 2025 15:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752592547; cv=none; b=GsPPRAtsmj+7bpeustDAFQS5Byex8VRVqPeRJnhe/br53e7aWRqxUqiI+6RxdFJZBWGpwyXhbm1ouLY8Ty4ZHN96Y2/8Y51T4UCPnZG2dMqCDFCPprR51H3z/2vwH4kcCmKxKtXv/5PQcSo5+4gaSpX3KQDVEGa5lCyUaTVDUOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752592547; c=relaxed/simple;
	bh=76ZKN3zey4EhZHiXOWXXjZEj00uyfKBB9LgiHP3Zl/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s/cpH83Dufmki0JDXRL5iQmpkfjJwH27fY6Ay0BexLwG/PyiK9JixzvqaaMkftFEr1sX3958cJEudtl8KNu/Dc+I1E9O5vEJb1QwdqvjcP4WjJEWg435fs0xAvoI3LP7srtazWrBHBN+RnR02URPlaXMtn/l1KymkVa69KxcVbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=PFCHgpVs; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="PFCHgpVs"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=lAeEl9QCLWoWmhBHUc1zmsddRjswvtfDbBPPCetD6OM=; b=PFCHgpVsJ+IF9z4s8xpf5T+5A2
	0I9vu0JHi09cFXZcB4ksrwWiFcq2Ix0fNOdJaV8jjPWk7M6sTXCOY7uETC7GQiAVFhNpDKRFslR13
	eRS1HtYOX5SncHWeFDwlycrwDVJ0yz71UVBrq72ufSytDZ4V1fwTeYGaFQDr0hev7eFgIQvXO0Tgl
	1ORDDRKvwU/0nWK15Tb0tqD8x+QxY8u2gg6wAnRHSvDyW5eCZAMfCDbtpSus4Y6u0o0Uc330wu0U0
	JXuXWTwAJNgraVHHG79ClNmbal+RQiU1iDBZ0fHNAtFampC8sNgG/mpe2gkiXivZzLwIfMqn/8kb5
	MB0Qaghg==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1ubhNf-000000003BB-1Fu1;
	Tue, 15 Jul 2025 17:15:43 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH v2 2/3] parser_bison: Accept ASTERISK_STRING in flowtable_expr_member
Date: Tue, 15 Jul 2025 17:15:37 +0200
Message-ID: <20250715151538.14882-3-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250715151538.14882-1-phil@nwl.cc>
References: <20250715151538.14882-1-phil@nwl.cc>
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
index 5b84331f220d3..c31fd05ec09cd 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -2472,16 +2472,7 @@ flowtable_list_expr	:	flowtable_expr_member
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
2.49.0

