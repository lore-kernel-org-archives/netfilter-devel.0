Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6751D6F51E;
	Thu,  8 Feb 2024 11:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707391724; cv=none; b=SVB1ldYi0yrgrISuFyVvmBRTjPNOnJcTbvWW4oi4WdDVqydX1phUXgV2f8LGfBkOXv5UsPdZAJUm3F6lTpFwNMaHKAp/8o7NAL0d15XqTe4oxBH6blTnSuj8huifle3H/WhEJmEvc9NuFOJbshSC/39PKAwuzGdTPe9/IXJYAbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707391724; c=relaxed/simple;
	bh=W1cSlmedix7odalk76TDIL1G+Kw9LBCOiQIAcgAngq0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tmIizZMtCjOu9FWffBozFmHJkfTAv6uwPmV+/6NPoRnLtIN8xOm4XrOKiknQ7lTuaaQqK7TDlVJ1hSbbul7Ua9HAbJYCFpIycD/Rm9eYwhO2VzFTsc6MUl03aVNtJfTwqpz6jSTdhI5KusTxZTQmR+nTUW0FqDy8wuzA1dDW5b4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	kadlec@netfilter.org
Subject: [PATCH net 05/13] netfilter: ipset: Missing gc cancellations fixed
Date: Thu,  8 Feb 2024 12:28:26 +0100
Message-Id: <20240208112834.1433-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240208112834.1433-1-pablo@netfilter.org>
References: <20240208112834.1433-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jozsef Kadlecsik <kadlec@netfilter.org>

The patch fdb8e12cc2cc ("netfilter: ipset: fix performance regression
in swap operation") missed to add the calls to gc cancellations
at the error path of create operations and at module unload. Also,
because the half of the destroy operations now executed by a
function registered by call_rcu(), neither NFNL_SUBSYS_IPSET mutex
or rcu read lock is held and therefore the checking of them results
false warnings.

Fixes: 97f7cf1cd80e ("netfilter: ipset: fix performance regression in swap operation")
Reported-by: syzbot+52bbc0ad036f6f0d4a25@syzkaller.appspotmail.com
Reported-by: Brad Spengler <spender@grsecurity.net>
Reported-by: Стас Ничипорович <stasn77@gmail.com>
Tested-by: Brad Spengler <spender@grsecurity.net>
Tested-by: Стас Ничипорович <stasn77@gmail.com>
Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipset/ip_set_core.c     | 2 ++
 net/netfilter/ipset/ip_set_hash_gen.h | 4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index bcaad9c009fe..3184cc6be4c9 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -1154,6 +1154,7 @@ static int ip_set_create(struct sk_buff *skb, const struct nfnl_info *info,
 	return ret;
 
 cleanup:
+	set->variant->cancel_gc(set);
 	set->variant->destroy(set);
 put_out:
 	module_put(set->type->me);
@@ -2378,6 +2379,7 @@ ip_set_net_exit(struct net *net)
 		set = ip_set(inst, i);
 		if (set) {
 			ip_set(inst, i) = NULL;
+			set->variant->cancel_gc(set);
 			ip_set_destroy_set(set);
 		}
 	}
diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 1136510521a8..cf3ce72c3de6 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -432,7 +432,7 @@ mtype_ahash_destroy(struct ip_set *set, struct htable *t, bool ext_destroy)
 	u32 i;
 
 	for (i = 0; i < jhash_size(t->htable_bits); i++) {
-		n = __ipset_dereference(hbucket(t, i));
+		n = (__force struct hbucket *)hbucket(t, i);
 		if (!n)
 			continue;
 		if (set->extensions & IPSET_EXT_DESTROY && ext_destroy)
@@ -452,7 +452,7 @@ mtype_destroy(struct ip_set *set)
 	struct htype *h = set->data;
 	struct list_head *l, *lt;
 
-	mtype_ahash_destroy(set, ipset_dereference_nfnl(h->table), true);
+	mtype_ahash_destroy(set, (__force struct htable *)h->table, true);
 	list_for_each_safe(l, lt, &h->ad) {
 		list_del(l);
 		kfree(l);
-- 
2.30.2

