Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1878850EC1E
	for <netfilter-devel@vger.kernel.org>; Fri,  4 Sep 2026 18:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788548059; cv=none; b=uyhrWKg58jRyFhJTHL0D+PRGK/UScKZKxWKjTlGzJNQRLmEjWm9I288pV3MDAXgooTTZkEuDw1RKalvWaIlBgH7E95E96baBLu8Ar/cyj9LkmTwyOZI8s7SBUy86lHKGJauuDVDON72lWUdKB2NOqAbrf2Wh2lTNHOpd5RecDks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788548059; c=relaxed/simple;
	bh=HiVwyygdN+MrkP6WRXlzBvvPC27ZFs7n10Im5oy97Sg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LhJS9MFyX9EaG/NAbdvtiSAUEVvQqTq3nRvQH+ykzKWb3irFLh4wowvpsK/RHqjkWqa+CgRSafM7yNq8wl466I69eh5Ucf25V0VE9bfa/Dth7opvrvaB3TBi1yBybwWTc47RqsK9FfGribqaTCgL3mClhZGvck1AMOaMAUSwLOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 671C96066D; Fri, 04 Sep 2026 20:54:16 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v4 10/13] netfilter: ipset: remove resize completely
Date: Fri,  4 Sep 2026 20:53:18 +0200
Message-ID: <20260904185321.30313-11-fw@strlen.de>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904185321.30313-1-fw@strlen.de>
References: <20260904185321.30313-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jozsef Kadlecsik <kadlec@netfilter.org>

It is not needed anymore.

Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/netfilter/ipset/ip_set.h | 2 --
 net/netfilter/ipset/ip_set_core.c      | 5 +----
 net/netfilter/ipset/ip_set_hash_gen.h  | 1 -
 3 files changed, 1 insertion(+), 7 deletions(-)

diff --git a/include/linux/netfilter/ipset/ip_set.h b/include/linux/netfilter/ipset/ip_set.h
index 37cfda517c1b..9a0a2944700b 100644
--- a/include/linux/netfilter/ipset/ip_set.h
+++ b/include/linux/netfilter/ipset/ip_set.h
@@ -166,8 +166,6 @@ struct ip_set_type_variant {
 	/* Low level add/del/test functions */
 	ipset_adtfn adt[IPSET_ADT_MAX];
 
-	/* When adding entries and set is full, try to resize the set */
-	int (*resize)(struct ip_set *set, bool retried);
 	/* Destroy the set */
 	void (*destroy)(struct ip_set *set);
 	/* Flush the elements */
diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index 339726b33342..f1378e9540a1 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -1744,10 +1744,7 @@ call_ad(struct net *net, struct sock *ctnl, struct sk_buff *skb,
 
 		ret = set->variant->uadt(set, tb, adt, &lineno, flags, retried);
 		retried = true;
-	} while (ret == -ERANGE ||
-		 (ret == -EAGAIN &&
-		  set->variant->resize &&
-		  (ret = set->variant->resize(set, retried)) == 0));
+	} while (ret == -ERANGE);
 
 	if (!ret || (ret == -IPSET_ERR_EXIST && eexist))
 		return 0;
diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 973adb854082..225f30e5b749 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -1302,7 +1302,6 @@ static const struct ip_set_type_variant mtype_variant = {
 	.head	= mtype_head,
 	.list	= mtype_list,
 	.uref	= mtype_uref,
-	.resize	= NULL,
 	.same_set = mtype_same_set,
 	.cancel_gc = mtype_cancel_gc,
 };
-- 
2.55.0

