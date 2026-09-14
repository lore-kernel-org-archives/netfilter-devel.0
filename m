Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65CEB449B34
	for <netfilter-devel@vger.kernel.org>; Mon, 14 Sep 2026 19:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789414143; cv=none; b=FcNdVazCOcXJr72JUHaWyKKNU8uUo2bpkrJsCpWve36BWJwkR4XeyzxGlD6vc8iT5lD9jD2+SKqjM7mgSvdM6jXQzr6lmTCvu/+DvnxQdQF1Byc8y3WzZMXW/KTieRLg+tYE4C3G62oGdWaAlCx1qr/5ASmYr7Yf7ym9DjBirpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789414143; c=relaxed/simple;
	bh=BwtVQKiiPx4WiW+m//aQOrfnd3UrWkpFh6VIsaGutmI=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=gAVMTz3Av3lP7g7Hl9dU7sxXEEv0dSdF6JkLYSA6SjFop2w50XHqRJ2V/Z2TTja+vVV7HQ27/oCskGv0pkh7MxJTuKIy4HjHQyDJKHfTml4UoC+L1GpiHq86bV/f0HduOxfKYL1OXK394kTmINRnyQU9iFXdMj4xMR9V8/tq/Tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=on9UY0oi; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="on9UY0oi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1789414138;
	bh=8SxfoSCey0CG3ouhJN5hNz+hXyD3a9Z4x2gSiypoACc=;
	h=From:To:Subject:Date:From;
	b=on9UY0oid/bFr1bBh1Zpr5gY6+E25kUr1Joob1kGyRj4+QJVyEN6TGN5g0V1h90ei
	 Lht3qC8jWBx3QSPBvaf18zAOaCJPfUxHdT79bDNTmwBcl6XECKZyz5eHxzslCZH8o8
	 taA2p1HrOoHqfFaIcf+rZuMpSAuyy39JHRdF6vKvx5/tAdpsLteIpgSKefEJBZtENl
	 JCSEaVTY9L5+79Y+qBlF/49jYbdOZmN8tEXnl7jMQ2ORL3qkPus5MTDpQK9muiaZE/
	 xQ5yG7XsySjV5MTVoJ2ER2k5LJWG7P8s9N7noUtZJxq9a4aE08S75aFgM615haEtqK
	 ommsSsjD3H9Rw==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id DDB7F60057
	for <netfilter-devel@vger.kernel.org>; Mon, 14 Sep 2026 21:28:57 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 1/2] expression: assert if clone interface is undefine
Date: Mon, 14 Sep 2026 21:28:53 +0200
Message-ID: <20260914192854.2052448-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add assert() to ensure expression type provides a clone interface.
This is a hardening patch, no real crash has been observed here.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/expression.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/src/expression.c b/src/expression.c
index eb9b7f50f56d..bf60aa3ce42a 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -56,8 +56,12 @@ struct expr *expr_alloc(const struct location *loc, enum expr_types etype,
 
 struct expr *expr_clone(const struct expr *expr)
 {
+	const struct expr_ops *ops = expr_ops(expr);
 	struct expr *new;
 
+	assert(ops);
+	assert(ops->clone);
+
 	new = expr_alloc(&expr->location, expr->etype,
 			 expr->dtype, expr->byteorder, expr->len);
 	new->flags = expr->flags;
-- 
2.47.3

