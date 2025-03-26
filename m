Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6736185955
	for <netfilter-devel@vger.kernel.org>; Wed, 26 Mar 2025 20:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743020612; cv=none; b=Yjnw0tW8u2fScxWLpxp10pmt8oZcMCQ3lRyqv5Gq95nlJmZosZx5ihwBav9SqmKz9QKrLf1qkeGvKSP537CHk2cpEmbOj1R91F/R81JcIx262qJguu2zlgSgqguRgc8nnnV4I+tGCjmUY177TNEEO/RBG7qr2LQWIBuA6/LOBhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743020612; c=relaxed/simple;
	bh=lcPg5A7myTfVcKLBkyfFWlGK9OQ+rBLl/EEp0qIUOHA=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=U9zu3cqkyAv52oDaWNDSYYOllLl6MhbeVn0gZX7uoI6wQ5zBxv10nce2OSNEWHCWcIvdkbjVh8mr0536AHXN3p/uORVpavmA+g3Nt7D/XQgkmMjrw0UrdfUHRm+sNq4cySEarm7ZN6vv2qdDKlfCXeDvPCX4yUbq5bQzTwj6gPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=BGueWhSu; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=jsk8HeZb; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="BGueWhSu";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="jsk8HeZb"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 17C2C607B7; Wed, 26 Mar 2025 21:23:21 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1743020601;
	bh=m/bb//DvCIpsFic0PCnkQ85Ms+z7nVpDloUfC3sf83c=;
	h=From:To:Subject:Date:From;
	b=BGueWhSu5Lfw9qhXyUHq6KsG/+ZX1/ymvs8b3UZVCwr5vUSQouRVyq2dXt0LHxuUg
	 2lk7oBuoGkWQ9OnMsvKfIDhGcE65kmUpDTdYK4d8eVI8dJpQSkkJdtO8fKOpZFKwtu
	 MgbLLfia0SfL2ePLcM50/Z9S91tI2ISO4bUoyrOOgoY1PS2aL7BGrv7wC3O6yw2Kh/
	 IHhO/CLx0xUITrSpo4eugpcwcOBvClYdJgaPWo5B/0nJ3qT99gMgHnjN4s2Evens6v
	 +sVpfTwA4cCUfxQnCnkETYDmMW14aUkHTPkOmDtK7O4ks8eWXxEPEFsXfsqu1PXH28
	 yoatlo+V22a2g==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id B523B606B5
	for <netfilter-devel@vger.kernel.org>; Wed, 26 Mar 2025 21:23:20 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1743020600;
	bh=m/bb//DvCIpsFic0PCnkQ85Ms+z7nVpDloUfC3sf83c=;
	h=From:To:Subject:Date:From;
	b=jsk8HeZbC5M+vnHkm2AN9X+cu+yHhX5Xtwi2b2B7jp/wuz/2JJBSZuHnKJJihWaIa
	 z7frX4Cr6tuz0ERUUfufwkQtIvBOko1FskGEOADnFWIwweWtqsvPY1dW7Pyr67C2xy
	 X5/7keSZ0noKIovMB1S1JOQMCea0b23JcSj5JV/ytr+QHvxtTJg+OhR1HxSZiIw0Bg
	 8zKOOZiRXZaW7IdkYrxBdLtfmS7yyZUnNd3zH19krwV2mLmetkmts2ieExYc0L9J4S
	 OxUjVQptp5ZNEtOldFqwfC3W7MMhKr7B+S+iIDAFQa6Ccze0RzSgmC34z4Al+dQvJW
	 1kxMcrZahgXCA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 1/4] optimize: incorrect comparison for reject statement
Date: Wed, 26 Mar 2025 21:23:00 +0100
Message-Id: <20250326202303.20396-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Logic is reverse, this should returns false if the compared reject
expressions are not the same.

Fixes: 38d48fe57fff ("optimize: fix reject statement")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/optimize.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/optimize.c b/src/optimize.c
index 05d8084b2a47..bb849267d8d9 100644
--- a/src/optimize.c
+++ b/src/optimize.c
@@ -235,7 +235,7 @@ static bool __stmt_type_eq(const struct stmt *stmt_a, const struct stmt *stmt_b,
 		if (!stmt_a->reject.expr)
 			return true;
 
-		if (__expr_cmp(stmt_a->reject.expr, stmt_b->reject.expr))
+		if (!__expr_cmp(stmt_a->reject.expr, stmt_b->reject.expr))
 			return false;
 		break;
 	case STMT_NAT:
-- 
2.30.2

