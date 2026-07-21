Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE3493B47E3
	for <netfilter-devel@vger.kernel.org>; Tue, 21 Jul 2026 20:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665984; cv=none; b=HIFMOklP2FRuFG7lC2ZCpUPjjdCfBi1XtwbGoLBxNdH4A02OuIe3Y1ReQEH/TuDO3bJHbhlDC7naAHJ1HOubm2BriJdXYhUK6idinQD0PGdWO9C9QPrmLoj/OTnjUcHyJKRRbb0e/ZYvC4FFFRA1f4Xzk3SQLHJFSi6hazdsEFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665984; c=relaxed/simple;
	bh=+bDQBawpAsJj+EiO1YKF6Zl99dt8LNczpV+ue3Fdm3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=S9U3iaSYyQ6WQVKDtZ1+fi4lmrscCfkJvMT/yLiStZRHzh9ws9UNP90lLqbsQykAvcV05fIONgJ4cwOtElidTMCJDoJ1YbX8LECUqk3BvBDug7/4vNbDhfMwcyTbk5TkYxc4XOvyFPCIdQKit01gjOjiFnVM6nQOCKGvIDI6lIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=NWXbM2Pv; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="NWXbM2Pv"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id AF2DD6019B;
	Tue, 21 Jul 2026 22:33:00 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1784665980;
	bh=NFWXcpb1o4mjAgDGliRDnQg80+4ySoJlkmbJG0sOXz8=;
	h=From:To:Cc:Subject:Date:From;
	b=NWXbM2Pv1d5oqtToZ1UNPlrDOvStyXaD8noI63qk7d0czRRgPw0hzKQRQv5Gf9pYb
	 ucVQ2UO9B+FnkEzXShgXXvBMH0gGsoTYOtrzZM5Ib40O20k7OjWcp56ksG/Ovdq/id
	 yuptyTLBh6CXD5Ne7SKnxnp1Wf1Rm8Bcv6UO3Ektwv3TOAwbO4jxivgMC6bzvmF6KS
	 U3tUl/zP6sUS8BGb4+hX3+0/Ra8wQE0vWgJlw0V6WxseIwjnT2jhSn07LHa4bAOpSh
	 eGaLXh57t56+yKloENBMPZOZ+iUAaGHrtFGn5aNn2BooQ+1M5A1ml8PWLKLJDXMM+O
	 bpmp1gxwp2/Dg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: talha.anything.info@gmail.com
Subject: [PATCH nf,v2] netfilter: xt_hashlimit: validate hashtable supports XT_HASHLIMIT_RATE_MATCH
Date: Tue, 21 Jul 2026 22:32:56 +0200
Message-ID: <20260721203256.25052-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The XT_HASHLIMIT_RATE_MATCH flag mode changes the semantics of the
dsthash_ent structure which represents an entry in the hashtable.  There
is a union area which uses a different layout to express the rate match
mode.

Update .checkentry path to validate the XT_HASHLIMIT_RATE_MATCH flag
mode is requested by two or more different rules that refer to the same
hashtable. Otherwise, uninitialized access to the burst field in the
union is possible.

Fixes: bea74641e378 ("netfilter: xt_hashlimit: add rate match mode")
Reported-by: Talha Berk Arslan <talha.anything.info@gmail.com>
Link: https://patch.msgid.link/20260721074629.668-1-talha.anything.info@gmail.com/
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: insufficient validation in flag mode.

 net/netfilter/xt_hashlimit.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index 2704b4b60d1e..d5dd68cd8151 100644
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
@@ -905,6 +907,15 @@ static int hashlimit_mt_check_common(const struct xt_mtchk_param *par,
 			mutex_unlock(&hashlimit_mutex);
 			return ret;
 		}
+	} else {
+		if ((cfg->mode & XT_HASHLIMIT_RATE_MATCH &&
+		     !(*hinfo)->ratematch) ||
+		    (!(cfg->mode & XT_HASHLIMIT_RATE_MATCH) &&
+		      (*hinfo)->ratematch)) {
+			mutex_unlock(&hashlimit_mutex);
+			htable_put(*hinfo);
+			return -EINVAL;
+		}
 	}
 	mutex_unlock(&hashlimit_mutex);
 
-- 
2.47.3

