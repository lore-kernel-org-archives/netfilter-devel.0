Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E5D0339391;
	Mon, 10 Aug 2026 19:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786388798; cv=none; b=XpATz0r1AWCO2mj4wa6n0mwd6tZMqVQfOGmqUMqhMmXMQXu6su4YOLaOUMxf9uMAyS+JdJvI9xYBEeGTT4VjRdRdNPZGWSr9SPH2IgzKXhx7oz9qbDR/VL1hG4gAXakGz9HQAaumnM0R85Hsv7PYcYuuac4ABbSkveeoUM4dna0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786388798; c=relaxed/simple;
	bh=/PjTonEg/Pdiel3kfJzelrmU/r5I8RW0FIJY1Mkn7cU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JJ/ZUtFR5G0bXIZA6aBK/BFPG3vY51mJCELtB8q8INLB7DvZZ59BPIFCk+Kk3UMQpDckoQq1gDpW7xSKkgApgaqeYRHGLLvDWjzQlD4kfRIx1DrFqdz/62G2ea7ByaV0R4lau7KXK/D+Xj1mtVkGuSLT7BWjAaI5JCqoR2nNnLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Z2q2I18q; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Z2q2I18q"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 27EB16028B;
	Mon, 10 Aug 2026 21:06:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1786388794;
	bh=tHg/VPEgf8FhAXf7mX7rYmIofkOTBQXP3sL1wZOiZkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z2q2I18qvcFmngZbhi+MUOcOwfMKsIbFu8/He6ttgZJHEkTTFVKQbH1i6HVctMXFp
	 erbQ7//i/djT0aG0L391uBc4keaLqoEVwldsKA088y/Xgz4+05nAby6zHIncSuTHlv
	 74AEmexN5vRAVMOHldPMht7wAeRJxHu2H/SfuAdODKeu43hkznJPVjhXWk+pt/ijez
	 KNmBD5SgR6fqzNBThysAmLGI7s7FuDemcGWyJQZZpG6/kRuRil/GryNrDLSRAr9NNa
	 pbngWZ0kZV6lLQMptV4RpfliUsYZTSR+CKV5fPO7iYiAOiJO/siTmtV+3fFa5m0nyZ
	 FiFcleorCVrKA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net 01/13] netfilter: ipset: fix refcount race between list:set GC and swap
Date: Mon, 10 Aug 2026 21:06:09 +0200
Message-ID: <20260810190621.894119-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260810190621.894119-1-pablo@netfilter.org>
References: <20260810190621.894119-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Xiang Mei (Microsoft)" <xmei5@asu.edu>

__ip_set_put_byindex() resolved the index to a set pointer under RCU,
then took ip_set_ref_lock in __ip_set_put() to decrement set->ref.
ip_set_swap() holds that same lock while swapping both the ip_set_list
slots and the two sets' ref counters, so it can interleave between the
dereference and the lock acquisition, leaving the caller to decrement a
set whose reference already moved to the other index and hit
BUG_ON(set->ref == 0). list_set_gc() reaches this from timer softirq,
which the nfnl mutex does not serialize against swap: an expiring
list:set member calls list_set_del() -> ip_set_put_byindex() while
IPSET_CMD_SWAP runs on the referenced sets.

Resolve the index and decrement under ip_set_ref_lock, as ip_set_swap()
already does, keeping the refcount tied to the index rather than to a
stale set pointer.

  kernel BUG at net/netfilter/ipset/ip_set_core.c:685!
  Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
  RIP: 0010:ip_set_put_byindex (net/netfilter/ipset/ip_set_core.c:870)
  Call Trace:
   <IRQ>
   list_set_del (net/netfilter/ipset/ip_set_list_set.c:159)
   set_cleanup_entries (net/netfilter/ipset/ip_set_list_set.c:181)
   list_set_gc (net/netfilter/ipset/ip_set_list_set.c:578)
   call_timer_fn (kernel/time/timer.c:1748)
   __run_timers (kernel/time/timer.c:1799 kernel/time/timer.c:2374)
   run_timer_softirq (kernel/time/timer.c:2405)
   </IRQ>
  Kernel panic - not syncing: Fatal exception in interrupt

Fixes: 9076aea76538 ("netfilter: ipset: Increase the number of maximal sets automatically")
Reported-by: AutonomousCodeSecurity@microsoft.com
Signed-off-by: Xiang Mei (Microsoft) <xmei5@asu.edu>
Acked-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipset/ip_set_core.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index 543851a923d0..0a86a170ba90 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -680,11 +680,18 @@ __ip_set_get(struct ip_set *set)
 }
 
 static void
-__ip_set_put(struct ip_set *set)
+__ip_set_put_locked(struct ip_set *set)
 {
-	write_lock_bh(&ip_set_ref_lock);
+	lockdep_assert_held(&ip_set_ref_lock);
 	BUG_ON(set->ref == 0);
 	set->ref--;
+}
+
+static void
+__ip_set_put(struct ip_set *set)
+{
+	write_lock_bh(&ip_set_ref_lock);
+	__ip_set_put_locked(set);
 	write_unlock_bh(&ip_set_ref_lock);
 }
 
@@ -855,11 +862,11 @@ __ip_set_put_byindex(struct ip_set_net *inst, ip_set_id_t index)
 {
 	struct ip_set *set;
 
-	rcu_read_lock();
-	set = rcu_dereference(inst->ip_set_list)[index];
+	write_lock_bh(&ip_set_ref_lock);
+	set = ip_set(inst, index);
 	if (set)
-		__ip_set_put(set);
-	rcu_read_unlock();
+		__ip_set_put_locked(set);
+	write_unlock_bh(&ip_set_ref_lock);
 }
 
 void
-- 
2.47.3

