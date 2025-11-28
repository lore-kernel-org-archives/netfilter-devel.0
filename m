Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37FC720D4E9;
	Fri, 28 Nov 2025 00:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764289449; cv=none; b=Ldaoc+AFioh1Q4ihrzsrd+wvny4zCG5oaOzhgTD2veYg0rLrjuOnBLwROVoGcr4HK0RDIQ3Nm/uzzB5lugrpmCmrPlcpcpS8Af7piEO8PSA1T97IOb6CWIVmUL7hA+eSV0ucWI3+q6xqOh24FKNGwg7UZIJ22H29+02Na7KuPck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764289449; c=relaxed/simple;
	bh=n8GOyvm/skz+FiYMoEL11gkm+QKP4wJkjxrnH26VdGo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W68O7BQwuRUPPCC4A4qzkeW1kWoqU3r77wX8p4uG0O4Gs0bU90qGy5gGGqy5WRYUvWTNUZf64s1mRuhfoA9P1WasQAwMRuOw5DpeJu/xUg3h0J2gzzJ/LBb2lGGzIMRob53gKnK22t+97JOEObKZA+fWWWULgT9Qlbb8PpwmceE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=TurA8CJh; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="TurA8CJh"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 35AF86027B;
	Fri, 28 Nov 2025 01:24:06 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1764289446;
	bh=5ihzBKctI4kHCf7B0S6Y9qviwTU7AEHx/N5r8AD+n3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TurA8CJhMIAo+vouQtOG3GbZf/hSf1DbUjmwmeGKDlOVjY3Crx5TFebed6VQPichw
	 iaAVR+HX01TRJjmkOjAeUtzWU9K0p1lkzKCkxB0uu8aIq2r0eGGx00RHLx5yJKbT5U
	 EIEw9ibZ6WoJ5MWyg7ojiwawkj2rL4r1ZovLGBnKKfhl8agEFuqAL/TmMJqc/QpgH3
	 5iEq4WCMPCZaGUSvZP/ir1Tx3nY7tbRfV7rTm+coRPe0BSs7vaGT3QqWimMAbs913d
	 u7g5hkgdVvdViZLoZFUYA0w/X077Fo53NwgSB9Gu5WeD8eXq1vOO6f9J9+PF9qWhO0
	 CRyRHkYqMnSiQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 13/17] netfilter: nft_connlimit: update the count if add was skipped
Date: Fri, 28 Nov 2025 00:23:40 +0000
Message-ID: <20251128002345.29378-14-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251128002345.29378-1-pablo@netfilter.org>
References: <20251128002345.29378-1-pablo@netfilter.org>
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
index d8893e172444..f1be4dd5cf85 100644
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

