Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B96133AD8B;
	Tue, 25 Nov 2025 22:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764110016; cv=none; b=X64QNzm2TV6tW50TDIHbIOUYTaZSzR80I9PVgl31mLHHir3paYEzUImqr2n30EosfdM10FrxJCNZYxqICy5PvaJ3UpNqYSCf7FrqHdwrPwrJHw+U0be4vqI5Wxjjk7Bj/JKX5CUhA3O0g6JC9fN7J17CiP4DXcJINp+njRGRLm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764110016; c=relaxed/simple;
	bh=KPOQ2bYFxIG9+WByVpISt0rOpPa2CfcFOUAPdpYjvW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D9liWuwOyd8k8lE8rDkF5NJfM5EdvgwLiUGogBN2xfYsfR3SiODN/WSmNQqacryuY0U3VbHlAd8JJnH3qYfnqCbpzDEYBA7Kjvvc2o9frnMZhHWChihtD9h8qXbv/feWsaJecM77joBMgFjDefj7fpSwDR3HQBvHuwFqKR+cIMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=BZWPKgCf; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="BZWPKgCf"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 9D13E602B8;
	Tue, 25 Nov 2025 23:33:32 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1764110013;
	bh=xE/17Ed/y4QX1/OVT+xBsj7wnIaJPgm1Pdomy8d+388=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BZWPKgCfZCdqB0kD21ltrcnzrN8iBSfSSW9eUwpXqvMTpvyti/stYQyUrNjzykBLj
	 1h8xmhcxK6fp5Yym0s0xdduOQcKPL3vT0IYy4U3koiLDj/PrjoXfWjbHHgdLGcs8ki
	 e1ZNKpKzg+8mZb71zebcwN1x0QHn9i0D+qve/q3334B+sH6VHkQmM0jtbc86Jj0Qqc
	 noJKKYcwxlVhMLxaYD/x6ZHp546W89xJmjV2phs2vP217M0gdLbxhooHlbjLZwtuBL
	 MAq/wazd98BaW61iETjLdwpDbb+TWvrCrYqm+KuK42FgXdulnfaOzL5LzxT1guRL2K
	 5DtBf8+tJh/JQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 12/16] netfilter: nft_connlimit: update the count if add was skipped
Date: Tue, 25 Nov 2025 22:33:08 +0000
Message-ID: <20251125223312.1246891-13-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251125223312.1246891-1-pablo@netfilter.org>
References: <20251125223312.1246891-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Fernando Fernandez Mancera <fmancera@suse.de>

Connlimit expression can be used for all kind of packets and not only
for packets with connection state new. See this ruleset as example:

table ip filter {
        chain input {
                type filter hook input priority filter; policy accept;
                tcp dport 22 ct count over 4 counter
        }
}

Currently, if the connection count goes over the limit the counter will
count the packets. When a connection is closed, the connection count
won't decrement as it should because it is only updated for new
connections due to an optimization on __nf_conncount_add() that prevents
updating the list if the connection is duplicated.

To solve this problem, check whether the connection was skipped and if
so, update the list. Adjust count_tree() too so the same fix is applied
for xt_connlimit.

Fixes: 976afca1ceba ("netfilter: nf_conncount: Early exit in nf_conncount_lookup() and cleanup")
Closes: https://lore.kernel.org/netfilter/trinity-85c72a88-d762-46c3-be97-36f10e5d9796-1761173693813@3c-app-mailcom-bs12/
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conncount.c  | 12 ++++++++----
 net/netfilter/nft_connlimit.c | 13 +++++++++++--
 2 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
index eabce7e141f8..81915ef99a83 100644
--- a/net/netfilter/nf_conncount.c
+++ b/net/netfilter/nf_conncount.c
@@ -179,7 +179,7 @@ static int __nf_conncount_add(struct net *net,
 	if (ct && nf_ct_is_confirmed(ct)) {
 		if (refcounted)
 			nf_ct_put(ct);
-		return 0;
+		return -EEXIST;
 	}
 
 	if ((u32)jiffies == list->last_gc)
@@ -408,7 +408,7 @@ insert_tree(struct net *net,
 			int ret;
 
 			ret = nf_conncount_add_skb(net, skb, l3num, &rbconn->list);
-			if (ret)
+			if (ret && ret != -EEXIST)
 				count = 0; /* hotdrop */
 			else
 				count = rbconn->list.count;
@@ -511,10 +511,14 @@ count_tree(struct net *net,
 			/* same source network -> be counted! */
 			ret = __nf_conncount_add(net, skb, l3num, &rbconn->list);
 			spin_unlock_bh(&rbconn->list.list_lock);
-			if (ret)
+			if (ret && ret != -EEXIST) {
 				return 0; /* hotdrop */
-			else
+			} else {
+				/* -EEXIST means add was skipped, update the list */
+				if (ret == -EEXIST)
+					nf_conncount_gc_list(net, &rbconn->list);
 				return rbconn->list.count;
+			}
 		}
 	}
 
diff --git a/net/netfilter/nft_connlimit.c b/net/netfilter/nft_connlimit.c
index 41770bde39d3..714a59485935 100644
--- a/net/netfilter/nft_connlimit.c
+++ b/net/netfilter/nft_connlimit.c
@@ -29,8 +29,17 @@ static inline void nft_connlimit_do_eval(struct nft_connlimit *priv,
 
 	err = nf_conncount_add_skb(nft_net(pkt), pkt->skb, nft_pf(pkt), priv->list);
 	if (err) {
-		regs->verdict.code = NF_DROP;
-		return;
+		if (err == -EEXIST) {
+			/* Call gc to update the list count if any connection has
+			 * been closed already. This is useful for softlimit
+			 * connections like limiting bandwidth based on a number
+			 * of open connections.
+			 */
+			nf_conncount_gc_list(nft_net(pkt), priv->list);
+		} else {
+			regs->verdict.code = NF_DROP;
+			return;
+		}
 	}
 
 	count = READ_ONCE(priv->list->count);
-- 
2.47.3

