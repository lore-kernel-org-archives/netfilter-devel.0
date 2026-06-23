Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66CD53C3420;
	Tue, 23 Jun 2026 22:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782252970; cv=none; b=QN9gYEQ3aJUVMc1X5ndWEHRcomdcFOOf2u1FVeSWjVXUqcXsmhGPj8+VZ4HR3ZLSacVWE3/rQm0ny4Dx9ombX9y4VHRKbmKh7sTi0zL7aDPqvUwKUB36Tt3F0Zew4CABu04UMRkFxcM9P4ZW1l5JlpRo3YWpbv5/b8N+Bo5Y3bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782252970; c=relaxed/simple;
	bh=e8sXgpbsl/6efxfSADMQF8ysHhjt2oMWeAx5HIAXS0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tuvy0DbdUf2KlVT9bcQ2ptiqDZHA6QT3tf4MtC7qq2F/oNKMvS95jDhvrdohDEF8W7I6bscBpZInqTGkwMbK/8xe0CbllNrZh4K/IOGLIVRaHiwKcZsQt7OdoIRlMR5EWh5KJdOte3WNAKrfdpEtte/2ju48UOAsMhun/o6XTlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=nXcdTJBD; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="nXcdTJBD"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 87B1F60582;
	Wed, 24 Jun 2026 00:16:04 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1782252964;
	bh=jS8qIqOTMNqkOp9wG43pHlmk1/idF8vLgphjjq4nWck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nXcdTJBDnDm+RNYMf6VFBOLq4GrCuNfTQxI1D4UuY06Mb054T9SLvF6HskvqGrPyW
	 MyJlKKKNpakEAdq5/pSVmD//6tFCzwDHfKaurifc9t7JuKKi0wSMPRDJ/40eoXNIQv
	 qZAgzzkZmBi6Jb3WUWQ0pnVEUlP7iyGEkShVpDquTCMegb6a+6imXD6YMUnGnu131b
	 ACbOwJPgOvbngb4vjzQKzINqvWcQQaV3GTqJ5AdxAhfbJ1qZasPs22pebVSCwo0eue
	 VapYTUTJ/zTJ7zgTIvXhwYb4QSDsSgTGAzeXQPyG4QmAL2BFMhtZBqdhMlsS4dUaOU
	 QztgTgyOAOm6w==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 09/14] netfilter: ctnetlink: do not allow to reset helper on existing conntrack
Date: Wed, 24 Jun 2026 00:15:42 +0200
Message-ID: <20260623221548.701545-10-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260623221548.701545-1-pablo@netfilter.org>
References: <20260623221548.701545-1-pablo@netfilter.org>
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

