Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BA4A1DF968;
	Sun, 19 Jan 2025 17:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737307268; cv=none; b=Lj13UYKnFw975aKt84NbZLwDtrj2XQXtnGG2xBhL8VAwa9r4Ti8h3vQoGZ2sFHW1o8zf+PvaKxUK6HdGChmp7qHsb5tMjvdTukU8GF6LzR8WJBDlMKJFt9H339ALWyRfOWTyvEqBxboOSkfT5lxixp2oB+U1ujWz8/6DwEHotfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737307268; c=relaxed/simple;
	bh=Nkd46QEpYCHldISYDFEY+9AVgnHq3zTgxeiRXfhjR1E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GkZw3n+YEzcdnUFI1iPuK8iaJ7huBEKolDdCRjReJ0sIBp33Its9g6QYvxx0UC80LpOAR2hBIbnlxVoDfTRy55w0ppmoNiRH0V2RpWtGN9+LzJeUpcPWQOLAX6ohgYFzOBtnqn4nvxz+VVA3JDa/+NLrRZYf/cdFBHQgzHr97co=
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
	fw@strlen.de
Subject: [PATCH net-next 05/14] netfilter: nf_tables: Use stored ifname in netdev hook dumps
Date: Sun, 19 Jan 2025 18:20:42 +0100
Message-Id: <20250119172051.8261-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250119172051.8261-1-pablo@netfilter.org>
References: <20250119172051.8261-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Phil Sutter <phil@nwl.cc>

The stored ifname and ops.dev->name may deviate after creation due to
interface name changes. Prefer the more deterministic stored name in
dumps which also helps avoiding inadvertent changes to stored ruleset
dumps.

Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 95d8d33589b1..87175cd1d39b 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1956,15 +1956,16 @@ static int nft_dump_basechain_hook(struct sk_buff *skb,
 			if (!first)
 				first = hook;
 
-			if (nla_put_string(skb, NFTA_DEVICE_NAME,
-					   hook->ops.dev->name))
+			if (nla_put(skb, NFTA_DEVICE_NAME,
+				    hook->ifnamelen, hook->ifname))
 				goto nla_put_failure;
 			n++;
 		}
 		nla_nest_end(skb, nest_devs);
 
 		if (n == 1 &&
-		    nla_put_string(skb, NFTA_HOOK_DEV, first->ops.dev->name))
+		    nla_put(skb, NFTA_HOOK_DEV,
+			    first->ifnamelen, first->ifname))
 			goto nla_put_failure;
 	}
 	nla_nest_end(skb, nest);
@@ -9324,7 +9325,8 @@ static int nf_tables_fill_flowtable_info(struct sk_buff *skb, struct net *net,
 
 	list_for_each_entry_rcu(hook, hook_list, list,
 				lockdep_commit_lock_is_held(net)) {
-		if (nla_put_string(skb, NFTA_DEVICE_NAME, hook->ops.dev->name))
+		if (nla_put(skb, NFTA_DEVICE_NAME,
+			    hook->ifnamelen, hook->ifname))
 			goto nla_put_failure;
 	}
 	nla_nest_end(skb, nest_devs);
-- 
2.30.2

