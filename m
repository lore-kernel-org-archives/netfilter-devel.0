Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C240322A
	for <netfilter-devel@vger.kernel.org>; Tue, 23 Jun 2026 05:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782193603; cv=none; b=Kcuio3zbr9cLRx++X2BttNAYCQ/yAFvPZTn4I22jgG/FHKF4z0z2m+tipvK4GhzdRm/8lEpRCRdanFmqdObYwfL/FRr9UfmL84BxOrf/pMwctnXKVinL4injhSViceZtb1TyZ+0PRdNWXqHEcYRimiUL5ilkTGWbf9wepAY2CBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782193603; c=relaxed/simple;
	bh=EGP8dYRHJpXqrn75x0njGpRHdzyF7cOavB3qZxXKQZo=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=JFX9y6FznLFWD5FpNyM3xzTnuPfT3dVSYuCCw+GSLQaMLI//rNIwc6ZdADos6uhlWuTzN3BjFb4twFRy1EPlz5J9kWvDJeQifUrOxH6veJZPJj9GhC/hxJ1U8R/dkPATRpKBFZIiGqGCbiab6aPJcjis9qCJck2h3WG8nX4HSuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=F9UMSiZd; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="F9UMSiZd"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id DD62A6059F
	for <netfilter-devel@vger.kernel.org>; Tue, 23 Jun 2026 07:46:38 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1782193599;
	bh=oaHlf133EnXP53IOFCMs4POizGXhF8T3sMiAMHXTJpY=;
	h=From:To:Subject:Date:From;
	b=F9UMSiZd7X4cR1mgKV3ZNkYqjCOqwjMv3Ro6rZ+wyl3LZemns3oez41tPR3sI62Rr
	 g21pjREeyk9X6wHzPry3DH5bjnKs0wCjEA9Edy7Z00hYeNvdOD7GXSir+0m/NKM3gG
	 UhbgZI4HD3vhKBgecr0FvgEFTXZP2sFo4CHgWI7FvBc2DGVNwqmaZ7snvkydZDkm69
	 buZOWCU9VpPwcg8VnqwHS9yWidwOYoZ/27UBWu9V9S5z9ewdvUnDCYWejFK/kBnPG9
	 sgb2RzxniqtQ75qNh24SYClxog+en+X4laWlprz005JybWaiPa/xXydJuiJoPYQcMy
	 yg+p4dtpLdgpw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v1 1/4] netfilter: ctnetlink: do not allow to reset helper on existing conntrack
Date: Tue, 23 Jun 2026 07:46:32 +0200
Message-ID: <20260623054635.335065-1-pablo@netfilter.org>
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

This feature antedates the creation of the conntrack-tools and I cannot
find a good use-case for this. Given that I cannot find any user in the
netfilter.org userspace tree, I prefer to remove this feature.

Fixes: c1d10adb4a52 ("[NETFILTER]: Add ctnetlink port for nf_conntrack")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v1: resend to let sashiko pick in with this batch.

 net/netfilter/nf_conntrack_netlink.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 4e78d2482989..cb38ef42e9e6 100644
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

