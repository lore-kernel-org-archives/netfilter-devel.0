Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E64717A2F8
	for <netfilter-devel@vger.kernel.org>; Wed, 26 Mar 2025 21:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743023793; cv=none; b=bgnCVQirRmrKkaoju2la7ifP+0LHXunPftU2IXdkxM34zcX3ToKzHw1Q/H/ja7XzQhyga7AO74YmMdkIlv/SFLX+z+sEbwjxL9iI6hqhKjVOEqDhPSfRl22hmEtpPLpEC+IgLWxfyBPw0DrVD8wiRvcHjHgZaTdxpcEdNkYVrkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743023793; c=relaxed/simple;
	bh=1DpjfBi1RQDQi7BQfTgFbHnzoIjcgKmmYpxAPNT5isI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Trd5PfwjLVthb3JnCdg/B+YMpyRmlb8oApcH6rqBm36qWZEO/BHeP0OM9e+pxsiR+/vQatwg51zolnto2mh7qBE8dn32GMzrRS3IWFHsg1UsmAwLmLQvIhKCiUnncEU4K1QW6/Othcq38o0hEvnlhvQez36CtD4KCflOx9CB1mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=dI2aYKDs; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=dI2aYKDs; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="dI2aYKDs";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="dI2aYKDs"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id C42BF605E4; Wed, 26 Mar 2025 22:16:29 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1743023789;
	bh=2mqFBuOK91JeyRzbm2dsr89eRXV4sNbivZQETF+URTk=;
	h=From:To:Cc:Subject:Date:From;
	b=dI2aYKDsodDhtTAhdXlSyAZ/cWIae1sL7nWRMUA0vY38K8z5iyxiZHMP4juzXR3Pd
	 DrGkxYuyL/IAZKcBRVaL9qL+uXedO9ZNXevvg86+4GB6Hk4IVxdQ7jmUnHsQzWiHig
	 YErUel6s0epoZmdt6E/paypydCMJF15Xpt2jpTBRB5sAMbvLig7kEsoqexu3h+99fZ
	 mhuNnhLhNpTd3AgZ/xCUtENQr6ar9CW6MSFtfSC9cLSUQTbu6ajzhYBV6EsaSTGupr
	 dDeU2RspthymXlyhmdMc2IAgk+pYIhShw32hh5Epjs3nGXDYcFt958hcqgCTr3uSJd
	 Yqmuf28vY93Rg==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 384C9605E1;
	Wed, 26 Mar 2025 22:16:29 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1743023789;
	bh=2mqFBuOK91JeyRzbm2dsr89eRXV4sNbivZQETF+URTk=;
	h=From:To:Cc:Subject:Date:From;
	b=dI2aYKDsodDhtTAhdXlSyAZ/cWIae1sL7nWRMUA0vY38K8z5iyxiZHMP4juzXR3Pd
	 DrGkxYuyL/IAZKcBRVaL9qL+uXedO9ZNXevvg86+4GB6Hk4IVxdQ7jmUnHsQzWiHig
	 YErUel6s0epoZmdt6E/paypydCMJF15Xpt2jpTBRB5sAMbvLig7kEsoqexu3h+99fZ
	 mhuNnhLhNpTd3AgZ/xCUtENQr6ar9CW6MSFtfSC9cLSUQTbu6ajzhYBV6EsaSTGupr
	 dDeU2RspthymXlyhmdMc2IAgk+pYIhShw32hh5Epjs3nGXDYcFt958hcqgCTr3uSJd
	 Yqmuf28vY93Rg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: [PATCH nft] expression: add __EXPR_MAX and use it to define EXPR_MAX
Date: Wed, 26 Mar 2025 22:16:25 +0100
Message-Id: <20250326211625.193318-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

EXPR_MAX was never updated to the newest expression, add __EXPR_MAX and
use it to define EXPR_MAX.

Add case to expr_ops() other gcc complains with a warning on the
__EXPR_MAX case is not handled.

Fixes: 347039f64509 ("src: add symbol range expression to further compact intervals")
Suggested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/expression.h | 4 ++--
 src/expression.c     | 1 +
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/expression.h b/include/expression.h
index 8472748621ef..6e8675b0cc1a 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -84,9 +84,9 @@ enum expr_types {
 	EXPR_FLAGCMP,
 	EXPR_RANGE_VALUE,
 	EXPR_RANGE_SYMBOL,
-
-	EXPR_MAX = EXPR_FLAGCMP
+	__EXPR_MAX
 };
+#define EXPR_MAX	(__EXPR_MAX - 1)
 
 enum ops {
 	OP_INVALID,
diff --git a/src/expression.c b/src/expression.c
index 156a66eb37f0..52e4c7d187ac 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -1794,6 +1794,7 @@ static const struct expr_ops *__expr_ops_by_type(enum expr_types etype)
 	case EXPR_FLAGCMP: return &flagcmp_expr_ops;
 	case EXPR_RANGE_VALUE: return &constant_range_expr_ops;
 	case EXPR_RANGE_SYMBOL: return &symbol_range_expr_ops;
+	case __EXPR_MAX: break;
 	}
 
 	return NULL;
-- 
2.30.2

