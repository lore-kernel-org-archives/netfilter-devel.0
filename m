Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3B60214208
	for <netfilter-devel@vger.kernel.org>; Tue, 25 Feb 2025 23:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740526750; cv=none; b=GITy+sDi3nJF36mYSMNdfhMp31NpKT74NAH0h3gAYEUqgCaC0ZnoR8WznbQxFu4fiOIh5EVXrRcmKhXEtwEB8IdLSLzScu53ROvXjNnWnH2yg2UHf+PE6LFhZkfEkjqG6XlfscomzPRjVgWvleoanzXRLuxrgLm/l8OjhthERbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740526750; c=relaxed/simple;
	bh=ziYcqiM5AlKM8Cd70ntAs3xyNJIydTe7VDCBuHXIoWY=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=StdyW7kM05+Jg28HYzcG2Cp8aBIJpXx2nUNEF0D4wM5E80Dh0er/c6NBloFmIvtR2v39UozY7jxGqjZGv2tSQmvM3066zeBfyvPzGFzY1TP5bY67lWlIRYavT7yK84XqZFDIuRSTfl4FrrHZzlce8xmE3uAgizthAhJ3FrsbpLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=IcisIBYn; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=IcisIBYn; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="IcisIBYn";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="IcisIBYn"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 9A31360288; Wed, 26 Feb 2025 00:39:05 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1740526745;
	bh=qEvc15+wcmC/VZY6aDozsvVSf96HTt2fPYkSACqenLU=;
	h=From:To:Subject:Date:From;
	b=IcisIBYn7kA/5xlEi3GqeUXJcNLX9mHEaGF7vM6qT8SIKhW0ZmxFMbebjAjWzLYE/
	 GOPl5TAQqOdRk9PvAEszuFFxjYEScJwnGdc9bxJG/gFskMEEm1Xaomi+5WUa1nMmHD
	 geb0RrAPHc+9N2mQPXHCqdLmwKYYeZeY+6QMo4Wl/eVjvYphGMNAoBdJO9zWFblUjo
	 OZLRc2KuYPt7Mh9l2ujXe4X2lWI6YElRmlTye5UacjEiP5cMWx6c9Lktc1nJ+kACuz
	 5w/+czBMNlJ74quz5KwjS27qi+4kBZq0PibDagY9K385EE+DFigC3SkRnmTvI55QM6
	 LK9mZ7Xkr5YXw==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 2D0306027E
	for <netfilter-devel@vger.kernel.org>; Wed, 26 Feb 2025 00:39:05 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1740526745;
	bh=qEvc15+wcmC/VZY6aDozsvVSf96HTt2fPYkSACqenLU=;
	h=From:To:Subject:Date:From;
	b=IcisIBYn7kA/5xlEi3GqeUXJcNLX9mHEaGF7vM6qT8SIKhW0ZmxFMbebjAjWzLYE/
	 GOPl5TAQqOdRk9PvAEszuFFxjYEScJwnGdc9bxJG/gFskMEEm1Xaomi+5WUa1nMmHD
	 geb0RrAPHc+9N2mQPXHCqdLmwKYYeZeY+6QMo4Wl/eVjvYphGMNAoBdJO9zWFblUjo
	 OZLRc2KuYPt7Mh9l2ujXe4X2lWI6YElRmlTye5UacjEiP5cMWx6c9Lktc1nJ+kACuz
	 5w/+czBMNlJ74quz5KwjS27qi+4kBZq0PibDagY9K385EE+DFigC3SkRnmTvI55QM6
	 LK9mZ7Xkr5YXw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft] payload: honor inner payload description in payload_expr_cmp()
Date: Wed, 26 Feb 2025 00:39:01 +0100
Message-Id: <20250225233901.499749-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

payload comparison must consider inner_desc.

No test update because I could not find any specific bug related to
this. I found it through source code inspection.

Fixes: 772892a018b4 ("src: add vxlan matching support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
While working on something else I found this.

 src/payload.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/src/payload.c b/src/payload.c
index f8b192b5f2fa..673203581468 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -62,7 +62,8 @@ static void payload_expr_print(const struct expr *expr, struct output_ctx *octx)
 
 bool payload_expr_cmp(const struct expr *e1, const struct expr *e2)
 {
-	return e1->payload.desc   == e2->payload.desc &&
+	return e1->payload.inner_desc == e2->payload.inner_desc &&
+	       e1->payload.desc   == e2->payload.desc &&
 	       e1->payload.tmpl   == e2->payload.tmpl &&
 	       e1->payload.base   == e2->payload.base &&
 	       e1->payload.offset == e2->payload.offset;
-- 
2.30.2

