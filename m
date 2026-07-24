Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C9FF425873;
	Fri, 24 Jul 2026 10:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784890194; cv=none; b=osZwSd+/+pae5FJ1SJYjuXPyDJDaKk+w6QARATCcEQ+3apu0vIfHduznJzCe7HnMwz2CANP1+K0Oo99d6GRtG71zR3VhSUcaH9Yy4wmrA17FfOP3G+sk9TFNy/CMYwE9X808kMYAlLzp7VSg60pJFEOl4qYVV7lpKjX6Mwz//Ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784890194; c=relaxed/simple;
	bh=/AjP3OxKaUkOsyz3xtHuCai4caXudoWqt6rYfs0eVmw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MWCP7mEQ9f50Nub33AgCDTDyGSsbzuqNuXgF4oXUq6HkT/iXBQ7IoSUYSbL7LvVd+9/peThRR4zn6g40vfkdKrlZWgll3aAUJ9rzZ2cv3YEEcRL0uZTL+2jLgWH2L3SckLqYStKSva6bE481j165EzhwFgWRUjKVONo9ZxGU/BE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=q92VWkEn; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="q92VWkEn"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 4D0C5601A6;
	Fri, 24 Jul 2026 12:49:50 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1784890190;
	bh=SpbYwq08UmZQp8OH7y/ASuK/hcRN7HdxY8WPbEZ2txQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q92VWkEnNJh6877HQCAIp8G7GCmrgWWCMI1dUBkdUIvV/WDyx3TY/z4R91Yg0x2pu
	 4UiXZfLxVhDuWC0F08Xv051YRPjTm4+P8Bbe/4b5y6VcKiSgBaUgUEDEOa9bQOnkBw
	 KKtJwjqSWLTudCG0ZnomkyC0gQ9meMBFTZHD2CmRne4CvfLe1VwKQZafZiFEG8OiqM
	 TwiWNAdM4csoNBEu00asmj73+hHZkN16A2Wom1pwb8HAiR3fZ+YZUE/LscL4uotxsA
	 Hrr36k+UlK21tuQgKSLJCrjB4Ckmlyvs4hNU7T0RTjlzl7aL9aOOqbSGlJCww++y8j
	 EUJwS97BeLwPQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 7/7] ipvs: use type-safe allocation helpers in ip_vs_rht_alloc
Date: Fri, 24 Jul 2026 12:49:32 +0200
Message-ID: <20260724104932.437729-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260724104932.437729-1-pablo@netfilter.org>
References: <20260724104932.437729-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Subasri S <subasris1210@gmail.com>

As per Documentation/process/deprecated.rst, open-coded kmalloc
assignments for struct objects are deprecated. Replace
kzalloc(sizeof(*ptr), GFP_KERNEL) with kzalloc_obj() and
kvmalloc_array(n, sizeof(*ptr), GFP_KERNEL) with kvmalloc_objs()
in ip_vs_rht_alloc().

Compile tested with CONFIG_IP_VS=y and runtime tested using
tools/testing/selftests/net/netfilter/ipvs.sh on x86_64/QEMU.

Signed-off-by: Subasri S <subasris1210@gmail.com>
Reviewed-by: Phil Sutter <phil@nwl.cc>
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipvs/ip_vs_core.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index bafab93451d0..a896bfb53f07 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -176,7 +176,7 @@ void ip_vs_rht_rcu_free(struct rcu_head *head)
 
 struct ip_vs_rht *ip_vs_rht_alloc(int buckets, int scounts, int locks)
 {
-	struct ip_vs_rht *t = kzalloc(sizeof(*t), GFP_KERNEL);
+	struct ip_vs_rht *t = kzalloc_obj(*t);
 	int i;
 
 	if (!t)
@@ -186,7 +186,7 @@ struct ip_vs_rht *ip_vs_rht_alloc(int buckets, int scounts, int locks)
 
 		scounts = min(scounts, buckets);
 		scounts = min(scounts, ml);
-		t->seqc = kvmalloc_array(scounts, sizeof(*t->seqc), GFP_KERNEL);
+		t->seqc = kvmalloc_objs(*t->seqc, scounts);
 		if (!t->seqc)
 			goto err;
 		for (i = 0; i < scounts; i++)
@@ -194,8 +194,7 @@ struct ip_vs_rht *ip_vs_rht_alloc(int buckets, int scounts, int locks)
 
 		if (locks) {
 			locks = min(locks, scounts);
-			t->lock = kvmalloc_array(locks, sizeof(*t->lock),
-						 GFP_KERNEL);
+			t->lock = kvmalloc_objs(*t->lock, locks);
 			if (!t->lock)
 				goto err;
 			for (i = 0; i < locks; i++)
@@ -203,7 +202,7 @@ struct ip_vs_rht *ip_vs_rht_alloc(int buckets, int scounts, int locks)
 		}
 	}
 
-	t->buckets = kvmalloc_array(buckets, sizeof(*t->buckets), GFP_KERNEL);
+	t->buckets = kvmalloc_objs(*t->buckets, buckets);
 	if (!t->buckets)
 		goto err;
 	for (i = 0; i < buckets; i++)
-- 
2.47.3

