Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AA34225A29
	for <netfilter-devel@vger.kernel.org>; Wed, 30 Jul 2025 22:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753914353; cv=none; b=r7b7cnZHSbSoT5KGXHVleYdfX8bF/uXVOAdUNi3TSbfNVeickMkySwYhaMUDM8XkEgUOmMgnClDfN727QUvDtxeMOmsXejSSpKz/Kqnmw+S3qL2NutDkdWJ4YKnvwO+fWhXK1gMgCIPU/YUef+5PMty5J7JWRgCGBvYYQd7SNaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753914353; c=relaxed/simple;
	bh=zaYUB0RYyFJnfsGAIs1lJ14VUy96ZJrlqxa5g5BSRow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NRJUH74GxtMdlxnBwUhAsbibpqEYXvv4RCHUiDmmpglp6O5Iq2egOP7ccvG9XiDN0mN+faqeMgheNiPRR9Du5vQbWsz9jd1qBVB+AJ6tniSMtBIcGCG81GbailfzDxcjTAv7TsK2BLNoL69nCfud/DH3e2S7H7vmZj2hL9xixp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=h0YM2IRU; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="h0YM2IRU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=0qcki8LKDVid1+JzoFXn2d9yWcpowk7U5hBVEb8nEBc=; b=h0YM2IRURzwccF5SNIOTIyKm1H
	sowpV8CcWOpdRwJ2Iip1aVakXy/ey7uE5S/kIivZmNfR2FTzXrwN4hp5KFcA2rhA3q/CxYiIQIFUh
	UElj8B5pI5o2Mv03YiDtedhgXqINEclLCyXRRs1da/BUHoO2LG9AoL0QmUNiDu9tEuk3TchiQGxdP
	9kS8y6H7G6FzJ0PTuivHaras3xC74lpp2TiiVh5neEn8bzv0vng0dUGcZFBGltvxH2wonFpDhBFhL
	YIBckg5y8L6t0QVFONwWXBEDksjyYI/u5tMBEepvS0e0OdzcZHt8+x3QaUKrTL026YpG4Q19y4isz
	Zsh+e+yA==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uhFF0-000000004Ro-3vsR;
	Thu, 31 Jul 2025 00:25:42 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH v3 1/3] expression: Introduce is_symbol_value_expr() macro
Date: Thu, 31 Jul 2025 00:25:34 +0200
Message-ID: <20250730222536.786-2-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250730222536.786-1-phil@nwl.cc>
References: <20250730222536.786-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Annotate and combine the 'etype' and 'symtype' checks done in bison
parser for readability and because JSON parser will start doing the same
in a follow-up patch.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/expression.h | 2 ++
 src/parser_bison.y   | 6 ++----
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/expression.h b/include/expression.h
index 5b60c1b0825e3..e483b7e76f4ca 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -470,6 +470,8 @@ extern struct expr *verdict_expr_alloc(const struct location *loc,
 extern struct expr *symbol_expr_alloc(const struct location *loc,
 				      enum symbol_types type, struct scope *scope,
 				      const char *identifier);
+#define is_symbol_value_expr(expr) \
+	((expr)->etype == EXPR_SYMBOL && (expr)->symtype == SYMBOL_VALUE)
 
 const char *expr_name(const struct expr *e);
 
diff --git a/src/parser_bison.y b/src/parser_bison.y
index c31fd05ec09cd..0b03e4dad1a3f 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -4486,10 +4486,8 @@ prefix_rhs_expr		:	basic_rhs_expr	SLASH	NUM
 
 range_rhs_expr		:	basic_rhs_expr	DASH	basic_rhs_expr
 			{
-				if ($1->etype == EXPR_SYMBOL &&
-				    $1->symtype == SYMBOL_VALUE &&
-				    $3->etype == EXPR_SYMBOL &&
-				    $3->symtype == SYMBOL_VALUE) {
+				if (is_symbol_value_expr($1) &&
+				    is_symbol_value_expr($3)) {
 					$$ = symbol_range_expr_alloc(&@$, $1->symtype, $1->scope, $1->identifier, $3->identifier);
 					expr_free($1);
 					expr_free($3);
-- 
2.49.0

