Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2DA733A9F7;
	Tue, 24 Feb 2026 20:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771966273; cv=none; b=DydxmsOPyN+vrKlb4Hug/7rMVBPBgBIKFxVN/wreClyvV0c7jk66+7fA6sbcsry5WdGTFJfYeCFAVnukQC6EW+MdJ7DOn2R6hmryJrclcilMHwpQy559yQU+BV5KX4IhjmdxCLjjPNpG0GqWfAIxHASMmW0UpGBFJRAXfOzl5q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771966273; c=relaxed/simple;
	bh=GXGTVGGolesOFm+bZzZsZNCVCIOzFzxCOIySkOMQxp4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DHxGGsVFtPvgH8Lh0DDDhlN3c5zQ6wZNZ+4X+yC61OuLrTYN9GkC12YECEpSBVaDESrG3tYgyUJbrQHWq7CMKR42W+30eajKJCV1vfqUkf9gME3h8tTHCeGnUbvInYCfEiwKloOSywssdEWgYDGJyMlC5Y+ZufDHcrqGUZx1ezg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 2FFFD6052A; Tue, 24 Feb 2026 21:51:10 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next 4/9] ipvs: do not keep dest_dst after dest is removed
Date: Tue, 24 Feb 2026 21:50:43 +0100
Message-ID: <20260224205048.4718-5-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260224205048.4718-1-fw@strlen.de>
References: <20260224205048.4718-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Julian Anastasov <ja@ssi.bg>

Before now dest->dest_dst is not released when server is moved into
dest_trash list after removal. As result, we can keep dst/dev
references for long time without actively using them.

It is better to avoid walking the dest_trash list when
ip_vs_dst_event() receives dev events. So, make sure we do not
hold dev references in dest_trash list. As packets can be flying
while server is being removed, check the IP_VS_DEST_F_AVAILABLE
flag in slow path to ensure we do not save new dev references to
removed servers.

Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/ipvs/ip_vs_ctl.c  | 20 ++++++++------------
 net/netfilter/ipvs/ip_vs_xmit.c | 12 ++++++++----
 2 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index 2ef1f99dada6..7c0e2d9b5b98 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -809,7 +809,6 @@ static void ip_vs_dest_free(struct ip_vs_dest *dest)
 {
 	struct ip_vs_service *svc = rcu_dereference_protected(dest->svc, 1);
 
-	__ip_vs_dst_cache_reset(dest);
 	__ip_vs_svc_put(svc);
 	call_rcu(&dest->rcu_head, ip_vs_dest_rcu_free);
 }
@@ -1012,10 +1011,6 @@ __ip_vs_update_dest(struct ip_vs_service *svc, struct ip_vs_dest *dest,
 
 	dest->af = udest->af;
 
-	spin_lock_bh(&dest->dst_lock);
-	__ip_vs_dst_cache_reset(dest);
-	spin_unlock_bh(&dest->dst_lock);
-
 	if (add) {
 		list_add_rcu(&dest->n_list, &svc->destinations);
 		svc->num_dests++;
@@ -1023,6 +1018,10 @@ __ip_vs_update_dest(struct ip_vs_service *svc, struct ip_vs_dest *dest,
 		if (sched && sched->add_dest)
 			sched->add_dest(svc, dest);
 	} else {
+		spin_lock_bh(&dest->dst_lock);
+		__ip_vs_dst_cache_reset(dest);
+		spin_unlock_bh(&dest->dst_lock);
+
 		sched = rcu_dereference_protected(svc->scheduler, 1);
 		if (sched && sched->upd_dest)
 			sched->upd_dest(svc, dest);
@@ -1257,6 +1256,10 @@ static void __ip_vs_unlink_dest(struct ip_vs_service *svc,
 {
 	dest->flags &= ~IP_VS_DEST_F_AVAILABLE;
 
+	spin_lock_bh(&dest->dst_lock);
+	__ip_vs_dst_cache_reset(dest);
+	spin_unlock_bh(&dest->dst_lock);
+
 	/*
 	 *  Remove it from the d-linked destination list.
 	 */
@@ -1747,13 +1750,6 @@ static int ip_vs_dst_event(struct notifier_block *this, unsigned long event,
 	}
 	rcu_read_unlock();
 
-	mutex_lock(&ipvs->service_mutex);
-	spin_lock_bh(&ipvs->dest_trash_lock);
-	list_for_each_entry(dest, &ipvs->dest_trash, t_list) {
-		ip_vs_forget_dev(dest, dev);
-	}
-	spin_unlock_bh(&ipvs->dest_trash_lock);
-	mutex_unlock(&ipvs->service_mutex);
 	return NOTIFY_DONE;
 }
 
diff --git a/net/netfilter/ipvs/ip_vs_xmit.c b/net/netfilter/ipvs/ip_vs_xmit.c
index 4389bfe3050d..394b5b5f2ccd 100644
--- a/net/netfilter/ipvs/ip_vs_xmit.c
+++ b/net/netfilter/ipvs/ip_vs_xmit.c
@@ -336,9 +336,11 @@ __ip_vs_get_out_rt(struct netns_ipvs *ipvs, int skb_af, struct sk_buff *skb,
 				goto err_unreach;
 			}
 			/* It is forbidden to attach dest->dest_dst if
-			 * device is going down.
+			 * device is going down or if server is removed and
+			 * stored in dest_trash.
 			 */
-			if (!rt_dev_is_down(dst_dev_rcu(&rt->dst)))
+			if (!rt_dev_is_down(dst_dev_rcu(&rt->dst)) &&
+			    dest->flags & IP_VS_DEST_F_AVAILABLE)
 				__ip_vs_dst_set(dest, dest_dst, &rt->dst, 0);
 			else
 				noref = 0;
@@ -513,9 +515,11 @@ __ip_vs_get_out_rt_v6(struct netns_ipvs *ipvs, int skb_af, struct sk_buff *skb,
 			rt = dst_rt6_info(dst);
 			cookie = rt6_get_cookie(rt);
 			/* It is forbidden to attach dest->dest_dst if
-			 * device is going down.
+			 * device is going down or if server is removed and
+			 * stored in dest_trash.
 			 */
-			if (!rt_dev_is_down(dst_dev_rcu(&rt->dst)))
+			if (!rt_dev_is_down(dst_dev_rcu(&rt->dst)) &&
+			    dest->flags & IP_VS_DEST_F_AVAILABLE)
 				__ip_vs_dst_set(dest, dest_dst, &rt->dst, cookie);
 			else
 				noref = 0;
-- 
2.52.0

