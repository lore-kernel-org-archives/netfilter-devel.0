Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B4B32236F2
	for <netfilter-devel@vger.kernel.org>; Tue, 29 Jul 2025 16:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753805923; cv=none; b=q1W9QiuDrSVl1gYqNafKxrwyMB1clLNMvmW6rlub8c9NWnBrudNgZY5riwz6i27tpiSfKo28cONZb9l4iJKZ5/eqSqiQ4MBrLP2/rVaVx9DoVd+sip8zGl4HddZKwNdlMs+2QIHlLQDPRzxwcejlrgzirObmE91mv0ooUvwxRYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753805923; c=relaxed/simple;
	bh=zaYUB0RYyFJnfsGAIs1lJ14VUy96ZJrlqxa5g5BSRow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AqABY4wd8WYyIvpr4bWdrykx6ONWJyiMyrMWEGHXuhj1H2ZRTCXmGgTrZYGHqxMMZX68id+3d99nL+Mo68iaXSNpbpb2l8/cPgIKLwULLBSiMNDTrpDVPLYCLL61S51jradMP8BtAuRU5WP8+PhDgjS3YMYslGk5yE1tKkzD5zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=oZEfmQ35; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="oZEfmQ35"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=0qcki8LKDVid1+JzoFXn2d9yWcpowk7U5hBVEb8nEBc=; b=oZEfmQ350sWuv7snizFp3UNUSo
	wsCII/65fFCrVCFbXY9X0zJNuRFB+IAt+7UZfxLcNHPwO7gAOimCOLLBj4prYuM/XRu8vX3d9v+5o
	+4k/sExllNTaouB2/I/GoWwiXCCl9SWvA9BJxW28PUC/8zu/cNaOgdLHnZIFh+BH4soKctvDmay9q
	KQDQzcN06HbH8J72Y6ORsST4SQPGbIXU83asrmx2y2pkraSgybYQc5JWxYS9rpXkgTBgPc0R8Eghn
	Y31FX1tty0zNDp+68E68U8nFhuGlNbccxTAVAmBHI9ZPiJe2ql7FvvTt9setmRKRBz9ujcA6drLbU
	jcyf8Olw==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1ugn2F-000000005Bn-1si1;
	Tue, 29 Jul 2025 18:18:40 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH v2 1/3] expression: Introduce is_symbol_value_expr() macro
Date: Tue, 29 Jul 2025 18:18:30 +0200
Message-ID: <20250729161832.6450-2-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250729161832.6450-1-phil@nwl.cc>
References: <20250729161832.6450-1-phil@nwl.cc>
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

