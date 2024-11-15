Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78D551CDA27;
	Fri, 15 Nov 2024 13:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731677545; cv=none; b=ADluu1MnnEYc3Kyw92Xb5BF4xfmtAbk48xKEznp2X9dIsznsUutdD5ckGGB0bMajXyxVeggJM1Ogv/pxaRdAXT38bedNvLLp+G/wWoK4FzY3dGxtByedDAAde6EhGrncSnW0h0V6tahkz7hsyUwuHBAo86I8RCVJs0OtKvQdjSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731677545; c=relaxed/simple;
	bh=vD2o0Thd2sYZ496V2/KfnXyjfk4bhoWtbxhpIYIXex4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qHY25O2T8RUx1nS6FKjauNdnM9RqRg0xgBw06K2Y36Aw622Jjx/qdrJqnUeM1vC97cdu2Yl2yp6YfGkayiyTpu4VUhhM31A1Dk9FRQHRYfzWwD7Oa9xnRJhCOyvJyX5X0PwTr1RLfhI+jA2vp4DfKsjPkd35srwhGctoEpBNIVQ=
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
Subject: [PATCH net-next 08/14] netfilter: ipv4: Convert ip_route_me_harder() to dscp_t.
Date: Fri, 15 Nov 2024 14:32:01 +0100
Message-Id: <20241115133207.8907-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20241115133207.8907-1-pablo@netfilter.org>
References: <20241115133207.8907-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Guillaume Nault <gnault@redhat.com>

Use ip4h_dscp()instead of reading iph->tos directly.

ip4h_dscp() returns a dscp_t value which is temporarily converted back
to __u8 with inet_dscp_to_dsfield(). When converting ->flowi4_tos to
dscp_t in the future, we'll only have to remove that
inet_dscp_to_dsfield() call.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/netfilter.c b/net/ipv4/netfilter.c
index e0aab66cd925..08bc3f2c0078 100644
--- a/net/ipv4/netfilter.c
+++ b/net/ipv4/netfilter.c
@@ -44,7 +44,7 @@ int ip_route_me_harder(struct net *net, struct sock *sk, struct sk_buff *skb, un
 	 */
 	fl4.daddr = iph->daddr;
 	fl4.saddr = saddr;
-	fl4.flowi4_tos = iph->tos & INET_DSCP_MASK;
+	fl4.flowi4_tos = inet_dscp_to_dsfield(ip4h_dscp(iph));
 	fl4.flowi4_oif = sk ? sk->sk_bound_dev_if : 0;
 	fl4.flowi4_l3mdev = l3mdev_master_ifindex(dev);
 	fl4.flowi4_mark = skb->mark;
-- 
2.30.2

