Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A5AF39150A
	for <netfilter-devel@vger.kernel.org>; Mon, 24 Aug 2026 21:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787606959; cv=none; b=bmw37VDs9yPNtmeGfnBa3aIZ4ygPMqvUFoHs3UHFSmOP32R28vmKkhfH4QZ8hsc+uC92BPxi8er2DLXegOSHYfZDi6MNLTMIdil/6TBzta6LbO92wM6T8BwNd2OEd/I8r92vR3697t5gy6bt7NMpD5HyHrnowEDsRZh4L5dwu/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787606959; c=relaxed/simple;
	bh=xpU0dWxAQZhr6qT7JRoqb5tl6asmQyqEv/O8jHXO7+U=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=gf+OQcnNHlzOLSkdd8eLFVHQo7vsyM5pTkJzF2ckOqnO42ZzbVHC1xRYTUz3WrHESwk3JvgswyVAl+JvJrzO7yvnGJAGL6LGt3ZXux4uwYM+wi/J0HygEA9ZG00sGmICyLmMzS0OT1PO2AK89M2reG8PWRrbBKvN8lCI9U3m3zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=d4SEc0FQ; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="d4SEc0FQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1787606955;
	bh=OdgMWP/U7xXw+CqvouAWEFstllVccuCxn3zZs2ZYrio=;
	h=From:To:Subject:Date:From;
	b=d4SEc0FQsWHjE1FlaXtB15n0q3N+1CGYYb94WGpjaY+f2tUwsnTBJJH1Jt+Tb9bRg
	 +qLVbFXE5X8f6myY3RLwvRvopIMseEZrfUst67QZXRAKbyyiN+lE3Ypo6gFHn2v1kN
	 D8dzHoSJ+N8oG5ZAwaa9cfPhSdPspvdBhu7Cl8amLc97e6gyIRbQN2S/vA5uLjF5Q5
	 5JDHOs162oYz5z+mxhJotggEWYtNb4QjTiTFU0tCnaLHl+TSjsgvqkrZ4zj1iicwMb
	 7UopO6l280j40Tmmyxne1XOl8ng67G91V1p37+W/pFaci8UD+fTHqcNYe3viv0w1LE
	 QQyHqVxw6Iaxw==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 2756B6007D
	for <netfilter-devel@vger.kernel.org>; Mon, 24 Aug 2026 23:29:15 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 1/3] segtree: assert on value expressions
Date: Mon, 24 Aug 2026 23:29:07 +0200
Message-ID: <20260824212909.68597-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Assert value expression before performing math on them instead of
crashing with unsupported expressions.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/segtree.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/src/segtree.c b/src/segtree.c
index c8a7a3541ac3..4f758e6c9f99 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -253,6 +253,9 @@ int get_set_decompose(struct set *cache_set, struct set *set)
 		if (i->key->flags & EXPR_F_INTERVAL_END && left) {
 			list_del(&left->list);
 			list_del(&i->list);
+
+			assert(i->key->etype == EXPR_VALUE);
+
 			mpz_sub_ui(i->key->value, i->key->value, 1);
 			range = get_set_interval_find(cache_set, left, i);
 			if (!range) {
@@ -325,6 +328,10 @@ static int expr_value_cmp(const void *p1, const void *p2)
 		return -1;
 
 	key_e2 = expr_value(e2);
+
+	assert(key_e1->etype == EXPR_VALUE);
+	assert(key_e2->etype == EXPR_VALUE);
+
 	ret = mpz_cmp(key_e1->value, key_e2->value);
 	if (ret == 0) {
 		if (e1->key->flags & EXPR_F_INTERVAL_END)
@@ -592,6 +599,10 @@ add_interval(struct expr *set, struct expr *low, struct expr *i, bool closed)
 	mpz_init(p);
 
 	key = expr_value(low);
+
+	assert(expr_value(i)->etype == EXPR_VALUE);
+	assert(key->etype == EXPR_VALUE);
+
 	mpz_sub(range, expr_value(i)->value, key->value);
 	if (closed)
 		mpz_sub_ui(range, range, 1);
-- 
2.47.3

