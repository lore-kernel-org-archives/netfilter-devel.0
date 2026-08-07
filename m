Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77D9D37268C
	for <netfilter-devel@vger.kernel.org>; Fri,  7 Aug 2026 12:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786104831; cv=none; b=lOYFp1m0r+hZB8fFB+62xfmkHwCulKXYYn5fZQDdEZ9TmnZUPm2JGLBmG/roa6MUab9Ld/DDkmUELT5INF5mXWxJChC2n+GYmuq/Pp4gjxhJArWLuRkT06q0MadjgJaqp4nLq86a4/AQzvI+wTz07UvPCv6xB0PpYGnjWETZUQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786104831; c=relaxed/simple;
	bh=P/X74ZoXlAI0CVtpz/Jggk2bkdX0lDT0ZJbbqPGZO4E=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=rDXaziUNMSTia+b+PJFCtPi++/LlEpzQBN1nMHoaNJ/pBIBLcjiIjTYyHFvt5RwAe1y6M26tUvkJ/jCQ+v5Qud6ZrsK+uuMKTpO337b+NFcFyvQkKLe6lmUyMrHyUYxtV/3J+T25dszAydRm/Hn/3hHk76nW0sdXXROsjv/50CA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ENEHFkJP; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ENEHFkJP"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id E7B48601A5
	for <netfilter-devel@vger.kernel.org>; Fri,  7 Aug 2026 14:13:31 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1786104812;
	bh=T86zp2hXTfC23mWhyVulBwm1TueMzLJSaXKNyeSWQQM=;
	h=From:To:Subject:Date:From;
	b=ENEHFkJP9YI1GGM12ml2pr9MiYB/fNoGoVbnDtEP+aSwPZ+BpzOxF75Z0JfIgtNUw
	 bZtLtYEiKpzMImcsapD0O2zybL2d7DBv+CZmu8ptOgC+WRRihK2yAquJSr3EXbQVzn
	 9sfF/4mOYdpbZJSM26TSr05GaIR0Q2PrmHBjVZ6Bi+PWwAO/Y+ruSCER0sRT/czBPr
	 XFOJeBAXaiSs1u8nUpiKb2wD3EXAe8VKTUpTWlwiX7fLnNn22rfAUyhv4u5QJcMYE1
	 IfZ8m3uj0k/ZvgVqTXVYNQzUoDw6C11pjTbjMbgeOvqcrg/7P9SqqT1F8B9ZGootSZ
	 5O7URPoY8xpqQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v3 1/2] netfilter: nf_conntrack_helper: remove synchronize_rcu() on helper removal
Date: Fri,  7 Aug 2026 14:13:26 +0200
Message-ID: <20260807121327.597152-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The helper stays around after unregistration if it is still in use, turn
the expectation removal into a best effort clean up. A helper might win
race to create an expectation while it is going away, but such
expectation still depends on master conntrack.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v3: - new in this series

 net/netfilter/nf_conntrack_helper.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 506c58034761..5cafb133ba0c 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -458,11 +458,9 @@ void nf_conntrack_helper_unregister(struct nf_conntrack_helper *me)
 	/* This helper is going away, disable it. */
 	rcu_assign_pointer(me->help, NULL);
 
-	/* Make sure every nothing is still using the helper unless its a
-	 * connection in the hash.
+	/* This is best effort, helper might win race to create an
+	 * expectation but it still depends on the master conntrack.
 	 */
-	synchronize_rcu();
-
 	nf_ct_expect_iterate_destroy(expect_iter_me, me);
 
 	if (refcount_dec_and_test(&me->ct_refcnt))
-- 
2.47.3

