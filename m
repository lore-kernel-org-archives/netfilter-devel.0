Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C2422DA76C
	for <netfilter-devel@vger.kernel.org>; Mon, 22 Jun 2026 11:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782129432; cv=none; b=JgkuxcK5T5m6nCBjnt8uwh69AWjLU+WvzWEqRsYL+7wM3BVmBt60CbZ6OUXHz1lsvcVGGPH4rl4snJETYfAz1xyDQ2GEln/41VbC/scaYl6fy8sNinz/KpEIUxVtM1OUinD1X8bVb1EU27brjHMXCiikVke8gGh5k+wwP3ST6kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782129432; c=relaxed/simple;
	bh=FdaZoKlCX4RNwI611HaEh5JSGGIDBjfCAPgFuWLUD9Y=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=svlAw3SbA1oFkgbQiaW9JSLqOrEsGtFZiRDUKW2sD5S2f2+p+UwUzHsUXq5zuWldr3t1c7/lBgHy3mI9UmyCAS1OnQE2/gOXaSMdDWKlgIR4ELlCHHLrWuvzcKeafDNAykxh9t0lmKPTxjah+7KNXe61U8EhSAjdJy0XHi+LC34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=rxD2BV/t; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="rxD2BV/t"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 46075600B9
	for <netfilter-devel@vger.kernel.org>; Mon, 22 Jun 2026 13:57:08 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1782129428;
	bh=ptkEkvfnhtZow1Br/yf7xrBiy10pLnv2SW6isotjBzE=;
	h=From:To:Subject:Date:From;
	b=rxD2BV/tJUEwCcA4mcbpxhgpLKfvZZwdDebRALWTlZwkq3CfTcvezVs389Zk+fUrm
	 s5QX2wv9HrpAbTg55yJ8vxQqii8EcZc/3zsx+Nwe9+dps8vdjG9iJNTqJOWwQmeeiE
	 ISo/CpdcK2tM/cU9qtLTnN47+ASFB0yGlRTCJP4P6GJ263r+NaCFjvdMyZIWsIVUgn
	 GrG0bZb4KUvu/TrRGkYudf/wUdTz0p7ycBpKPyYJT0PSwwnZO2yVGEMDtFBE5yYah5
	 pRTssVmIaoqKZ48ydblsQ1sxKwvsCZPxmuZz/zO0tp5h2DwOysql8KMY9twJkhOLaK
	 j+xYi4BAofGWw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf] netfilter: ctnetlink: do not allow to reset helper on existing conntrack
Date: Mon, 22 Jun 2026 13:57:05 +0200
Message-ID: <20260622115705.145391-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This feature allows to reset a helper for an existing conntrack, but it
is not safe. This requires a synchronized_rcu() call after resetting the
helper, which is going to be expensive for a large batch of conntrack
entries. This also needs to call to the .destroy callback to release the
GRE/PPTP mappings to fix it.

Given that I cannot find any user in the netfilter.org userspace tree, I
prefer to remove this feature. This feature antedates the creation of
the conntrack-tools.

Fixes: c1d10adb4a52 ("[NETFILTER]: Add ctnetlink port for nf_conntrack")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_netlink.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index e4095fb4bb4c..4217715d42dc 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1953,19 +1953,6 @@ static int ctnetlink_change_helper(struct nf_conn *ct,
 		return err;
 	}
 
-	if (!strcmp(helpname, "") && help) {
-		helper = rcu_dereference(help->helper);
-		if (helper) {
-			/* we had a helper before ... */
-			nf_ct_remove_expectations(ct);
-			RCU_INIT_POINTER(help->helper, NULL);
-			if (refcount_dec_and_test(&helper->ct_refcnt))
-				kfree_rcu(helper, rcu);
-		}
-		rcu_read_unlock();
-		return 0;
-	}
-
 	helper = __nf_conntrack_helper_find(helpname, nf_ct_l3num(ct),
 					    nf_ct_protonum(ct));
 	if (helper == NULL) {
-- 
2.47.3

