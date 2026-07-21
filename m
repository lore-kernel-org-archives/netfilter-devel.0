Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5043346F490
	for <netfilter-devel@vger.kernel.org>; Tue, 21 Jul 2026 20:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665576; cv=none; b=ley0SQ2JnWG0pFGYZYMs2mqKhNC43pEErAwm8R1RGmPgD3OAztx4ZPRN88IPZJrZUD7qdpM3GL6C2+Nj9Xy9lnbocwVSRUNZuJ/2e1ZMSPMAs9tD1CwxNllA6+VdL2a63VdmBkGhlQ7WYI/zjxN7pskntF//46A6PIJo21zRumY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665576; c=relaxed/simple;
	bh=8kizyVo+45hCKQ3Ysp1n8+KUXuMmXRaR9WYrHP6zpCI=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=ScTgia0ydHE+EPIlr76Hq5NhN4O0jVT1OFxuEQAX/JvK23VvYPZQ8AlZtm8qMUFSPwMW0t02AX8oTy99RZhsKaQCv7fZ1/119tdl9hT62a2H6njHtOzK+N6fFK1pc4xdzK+tE3WFlC3rWAGfioQMW3H9AbccYogzRvGTgQXFRxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=GCa26GRl; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="GCa26GRl"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 69E1260195
	for <netfilter-devel@vger.kernel.org>; Tue, 21 Jul 2026 22:20:14 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1784665214;
	bh=i5Xat3TWI7d3ojALrTKOMOYhDZYGEa0bbaSUBq4BMw4=;
	h=From:To:Subject:Date:From;
	b=GCa26GRl0vCQFPNekZsvSUVfVWE4u/Tzn2oNKTa04EoKRI4meuFoGISYwhb6wTp+e
	 yQbdvKUVHBEJ2kNy+ZKIFwY09KtisVF0Uqdlw4vy3nKne5Y/VjeoIJHvQGTuKVfhoJ
	 aVhkqt9O6DSflob0ZgIOSgWjPl/K85SlBVQGlJ4CtbejMzeHcdvsExCAUZPnzdMb36
	 B8z4X/DRJk9iqVDZ1O1OKSmrkX25hw0+zqNinznjmWydludPmREGhcfjLD2s5iojlV
	 RDoKjjN6wqSqfxLNg6WvxhIPRvX1cMA0yXs1ttYpHWVXk5bF7qVYVHuDkwYBJxUV5b
	 DKOVpR/eoUy3w==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf] netfilter: xt_hashlimit: validate hashtable supports XT_HASHLIMIT_RATE_MATCH
Date: Tue, 21 Jul 2026 22:20:10 +0200
Message-ID: <20260721202010.24083-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The XT_HASHLIMIT_RATE_MATCH flag mode changes the semantics of the
dsthash_ent structure which represents an entry in the hashtable.
Update .checkentry path to validate the XT_HASHLIMIT_RATE_MATCH flag
mode is requested by two or more different rules that refer to the
same hashtable.

Fixes: bea74641e378 ("netfilter: xt_hashlimit: add rate match mode")
Reported-by: Talha Berk Arslan <talha.anything.info@gmail.com>
Link: https://patch.msgid.link/20260721074629.668-1-talha.anything.info@gmail.com/
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/xt_hashlimit.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index 2704b4b60d1e..330d931cab71 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -117,6 +117,7 @@ struct xt_hashlimit_htable {
 	refcount_t use;
 	u_int8_t family;
 	bool rnd_initialized;
+	bool ratematch;
 
 	struct hashlimit_cfg3 cfg;	/* config */
 
@@ -323,6 +324,7 @@ static int htable_create(struct net *net, struct hashlimit_cfg3 *cfg,
 		kvfree(hinfo);
 		return -ENOMEM;
 	}
+	hinfo->ratematch = !!(cfg->mode & XT_HASHLIMIT_RATE_MATCH);
 	spin_lock_init(&hinfo->lock);
 
 	switch (revision) {
@@ -905,6 +907,13 @@ static int hashlimit_mt_check_common(const struct xt_mtchk_param *par,
 			mutex_unlock(&hashlimit_mutex);
 			return ret;
 		}
+	} else {
+		if (cfg->mode & XT_HASHLIMIT_RATE_MATCH &&
+		    !(*hinfo)->ratematch) {
+			mutex_unlock(&hashlimit_mutex);
+			htable_put(*hinfo);
+			return -EINVAL;
+		}
 	}
 	mutex_unlock(&hashlimit_mutex);
 
-- 
2.47.3

