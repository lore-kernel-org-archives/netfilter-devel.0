Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CA7E3DC4A5
	for <netfilter-devel@vger.kernel.org>; Thu,  2 Apr 2026 18:43:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775155413; cv=none; b=Wu4FXeC7OAOLE44n4i5xWvpyEhjqykA0ncgNaiiPn9ZfKccjy2c/982BU89dnJRf7jEruP6cyfrjKVvjtHvdXiwQWoUlAJZcCEaWg5ULdTOW3FLzO25UnFtMYgtK6jJshaeGkZlFYoVlINK5jdYazK10UJqi9NspOGs8ve7/pwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775155413; c=relaxed/simple;
	bh=jV427SFTgdy2a8X9flKsGlqLGWdM63DwQLCW8VTQNRY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KTNaEPiAWHyz45pMZLLFEORQIIMS0aZT6TY7DQdBiWh04NXizVmqLfuEgkXGC+BI7DXVolkMXWZimJO4Z1FI00jLfxX9gC8ldkZRxgwagEqk1szOHsmJxroznVfp7fK6WLz8twsgw0EfeLWQEonR8/tqhJyXtlhDtlvvBQrkKf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=bESikb8d; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="bESikb8d"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=syHq/m+XbaR4QnEyC9Y7UHAZwnrN6yXSfKzwrwADq4w=; b=bESikb8d5ao1RA1B4v/3HUjAHR
	oyes3IxKAklWOPhhzk/OBKEDGR947wbVh0Ov0DrJLOOJ0+84Vp67zUnIisN55WoY1z6q2dy+7/ooE
	pwzZ2thFPhrCl+6uL7FOBGBRCRXtO7+JRP1igAPMU+2/OuI1eT1UGib3b0ecEusx7PZaxxVNosQs9
	EYOkL5JmvoWi5hE0wPy6EpgAl8cvnrVc0bl88dqlGYTZJyLFI2mJUgTzKPNoih/AGdsWW47OKAih9
	QGm+fMuw6w0/8HP4XxZv3O7Cxr3X5Lx8nWas9etQ8s4MSm3siYkQGJPTdMtKocGNbt6biH56f/4lp
	E5BxpJrQ==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1w8N0o-000000005oq-3KU1;
	Thu, 02 Apr 2026 20:43:26 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Dion Bosschieter <dionbosschieter@gmail.com>
Subject: [nft PATCH 1/2] parser_json: Accept non-RHS expressions in binop RHS
Date: Thu,  2 Apr 2026 20:43:19 +0200
Message-ID: <20260402184320.14862-2-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260402184320.14862-1-phil@nwl.cc>
References: <20260402184320.14862-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

No need to restrict this anymore, binop expressions may contain
non-constant expressions in all places nowadays.

Fixes: 54bfc38c522ba ("src: allow binop expressions with variable right-hand operands")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/parser_json.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/parser_json.c b/src/parser_json.c
index 2f70b9877c6ed..b8b623ce05722 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -1296,7 +1296,7 @@ static struct expr *json_parse_binop_expr(struct json_ctx *ctx,
 		json_error(ctx, "Failed to parse LHS of binop expression.");
 		return NULL;
 	}
-	right = json_parse_rhs_expr(ctx, jright);
+	right = json_parse_primary_expr(ctx, jright);
 	if (!right) {
 		json_error(ctx, "Failed to parse RHS of binop expression.");
 		expr_free(left);
-- 
2.51.0

