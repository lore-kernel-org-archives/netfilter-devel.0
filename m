Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09579292934;
	Fri, 23 May 2025 13:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748006858; cv=none; b=ZXwM8UaGyNiT2jEExnw19xyrLN/AMmxCZDIrvzu0Ku+UoIQByeafx18YySCAERFDl5TU3j17e4JW/t0ldeqAC1FI1YWrrLxh7HyAKo0UfFqLEKIrsmyXhX1NMzrDa/bctz0vMH4vKcIjTCb87QYxfBdf52LipIwrwzBL9jn/TG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748006858; c=relaxed/simple;
	bh=+RxcN1Uh+QPDVJAYOyNbBN3j+ADTL/9Twz7ECbKb3AU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=m5Rv7zFaybfzDYAJKF5+vyZngcNdtF9aDHv0DDYDi7NMNcCKL2s1nbr53ebHlk1pNoEoKIQTS1RHOIS3RRfBM1+fDBvJHYyvSEUi6iGmlDSBajv8F2XQNQS791q/kJkRZz6cHYR1VTgTjdiN20i7kJ1NQaYeN3Q+etRPXJ0gNl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Y7Vz0sew; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=C377e5jv; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Y7Vz0sew";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="C377e5jv"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 4E1E260784; Fri, 23 May 2025 15:27:35 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1748006855;
	bh=6Jph4bWy9QL2136aunA+oFBDB+vYXhseO7uA6qD5Wo8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y7Vz0sewbj4LSZv+FspLExiTG8s9fxUNaGMtFmxTW2H4mHHPtAXx3iVp/7gxbjpTy
	 aaoRVNozOnkRWdB1toub+j4PczYbRMGknS5jsTtZp47kRxGAzf0v/XzCEQ5aA9KKg4
	 tedz1z8SF4ODZk/26Dx7ZpIn4Y2c7jnb0U1gazyY+/n1yAgpSm9aiUEcE6yoQezDm3
	 zcie+adoZNPkqxP3FG72qknf/8tt47opSBr+smGSGhW/QwOkiMgXalyxiGQwzXxQ6o
	 0iVryqcAaE58yMQkLzH/8imKrRLQ1s+4ClrWxb4dj+x72FYX3rogH7sqxTwuKtsUea
	 /Rso31/iuCZDQ==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 3C1306075E;
	Fri, 23 May 2025 15:27:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1748006843;
	bh=6Jph4bWy9QL2136aunA+oFBDB+vYXhseO7uA6qD5Wo8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C377e5jv5L0pe/e5ivZSvfQf75Ahu4inetTeQ3BFpCgRRJS0jVMeE9YcyvuS8YInJ
	 A5GJTPh7HGMpMbA7Kj98xYG8bbLidkb5sWDbZIF3c3Qn8qQwsvsFBuZAmj/BDeHQW5
	 UqRqFJL9rRH2fgZGTraEvSbskuGYo6QCcm0QsiYrm8BqopJ1LDOYj0arGqK3KnxZFI
	 CFpM/OnvQ2mDPpuwFrwBXacyqeMNkFHgxFSVmxL9kpEuo+imxpB7xxctIC4hD6O4zb
	 KpGPMfU2JNpTYKrj2oPg6cO8fGW8VcObPgLeCIlO644tu+IyEEyQY9U5wt21jXOXkV
	 9oo411IaDDDGA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 05/26] netfilter: nf_tables: nft_fib_ipv6: fix VRF ipv4/ipv6 result discrepancy
Date: Fri, 23 May 2025 15:26:51 +0200
Message-Id: <20250523132712.458507-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250523132712.458507-1-pablo@netfilter.org>
References: <20250523132712.458507-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

With a VRF, ipv4 and ipv6 FIB expression behave differently.

   fib daddr . iif oif

Will return the input interface name for ipv4, but the real device
for ipv6.  Example:

If VRF device name is tvrf and real (incoming) device is veth0.
First round is ok, both ipv4 and ipv6 will yield 'veth0'.

But in the second round (incoming device will be set to "tvrf"), ipv4
will yield "tvrf" whereas ipv6 returns "veth0" for the second round too.

This makes ipv6 behave like ipv4.

A followup patch will add a test case for this, without this change
it will fail with:
  get element inet t fibif6iif { tvrf . dead:1::99 . tvrf }
  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  FAIL: did not find tvrf . dead:1::99 . tvrf in fibif6iif

Alternatively we could either not do anything at all or change
ipv4 to also return the lower/real device, however, nft (userspace)
doc says "iif: if fib lookup provides a route then check its output
interface is identical to the packets input interface." which is what
the nft fib ipv4 behaviour is.

Fixes: f6d0cbcf09c5 ("netfilter: nf_tables: add fib expression")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv6/netfilter/nft_fib_ipv6.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/netfilter/nft_fib_ipv6.c b/net/ipv6/netfilter/nft_fib_ipv6.c
index 7fd9d7b21cd4..f1f5640da672 100644
--- a/net/ipv6/netfilter/nft_fib_ipv6.c
+++ b/net/ipv6/netfilter/nft_fib_ipv6.c
@@ -158,6 +158,7 @@ void nft_fib6_eval(const struct nft_expr *expr, struct nft_regs *regs,
 {
 	const struct nft_fib *priv = nft_expr_priv(expr);
 	int noff = skb_network_offset(pkt->skb);
+	const struct net_device *found = NULL;
 	const struct net_device *oif = NULL;
 	u32 *dest = &regs->data[priv->dreg];
 	struct ipv6hdr *iph, _iph;
@@ -203,11 +204,15 @@ void nft_fib6_eval(const struct nft_expr *expr, struct nft_regs *regs,
 	if (rt->rt6i_flags & (RTF_REJECT | RTF_ANYCAST | RTF_LOCAL))
 		goto put_rt_err;
 
-	if (oif && oif != rt->rt6i_idev->dev &&
-	    l3mdev_master_ifindex_rcu(rt->rt6i_idev->dev) != oif->ifindex)
-		goto put_rt_err;
+	if (!oif) {
+		found = rt->rt6i_idev->dev;
+	} else {
+		if (oif == rt->rt6i_idev->dev ||
+		    l3mdev_master_ifindex_rcu(rt->rt6i_idev->dev) == oif->ifindex)
+			found = oif;
+	}
 
-	nft_fib_store_result(dest, priv, rt->rt6i_idev->dev);
+	nft_fib_store_result(dest, priv, found);
  put_rt_err:
 	ip6_rt_put(rt);
 }
-- 
2.30.2

