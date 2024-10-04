Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B225A1FB3C2;
	Fri,  4 Oct 2024 18:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728066225; cv=none; b=GvGOHl9kcAmSsWnzOpFQX0GUDK1m9VuTuABxBcySUAn8gomjl8VJ2UlB4ipAZIkH+xcNSh5JgEGigLiPFNBOp55taeSNoI+dd2EdzKDUfEafBbTW3KstfImmHl7udEI9qFqPiu1zY9hUSrgfSKpvneXkTnysJx+ZwYQHL2PpV3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728066225; c=relaxed/simple;
	bh=EzVBYaCHBX8DZNJXTY8R/ao9hbVSq/400hzx71wVHY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=axiNSnDvl2qAeaLgCIgTs0rzup8mOdYUHi+loabYUA8tO2NqxmPWO6+hRwH9qkY7OpjPLk/AiOdXrnE3MskaxyR3AYoQokcctouBtikleEliFUHvZIGJXVE9MkG7PZo3YiajA+C9H5T0Qkzp6sOq8f4CwXr77y9OoiJp1mbiFdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dHAVvoRr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dHAVvoRr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE2EAC4CECD;
	Fri,  4 Oct 2024 18:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728066225;
	bh=EzVBYaCHBX8DZNJXTY8R/ao9hbVSq/400hzx71wVHY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dHAVvoRrsKb9lKWCwcGJwTXZ23Anqbm3aOa2ZHtMDJ4xvNztMwzht7b7I7m0010hi
	 Cb9hflKgIB87Uexjo2y+ok3bQJ38U9qj96jffHtSF1Ipyx7tUM/+JiOdt/pXb0cD2I
	 hVjg30gaW8WU4RXPSTyuugsjrt6qtqf6BWpjGp3GXN+JDJo0jNBjHVIXdt6Zt1kJJ0
	 nyRiaOgar/QGtLrIvdqh9rnRfGmyI4JFxoSUgFzoBEAFKjo50okVF9pHo/EdnB1J5+
	 L8HUC10GjX6djwGAubqGaBtlnqvFewJNp1sYo7ToHhTDENCUOqYjeITCg6ez/KxK7+
	 roFrTv5DD5Mlw==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Simon Horman <horms@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>,
	kadlec@netfilter.org,
	davem@davemloft.net,
	dsahern@kernel.org,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.10 54/70] netfilter: nf_reject: Fix build warning when CONFIG_BRIDGE_NETFILTER=n
Date: Fri,  4 Oct 2024 14:20:52 -0400
Message-ID: <20241004182200.3670903-54-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241004182200.3670903-1-sashal@kernel.org>
References: <20241004182200.3670903-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.10.13
Content-Transfer-Encoding: 8bit

From: Simon Horman <horms@kernel.org>

[ Upstream commit fc56878ca1c288e49b5cbb43860a5938e3463654 ]

If CONFIG_BRIDGE_NETFILTER is not enabled, which is the case for x86_64
defconfig, then building nf_reject_ipv4.c and nf_reject_ipv6.c with W=1
using gcc-14 results in the following warnings, which are treated as
errors:

net/ipv4/netfilter/nf_reject_ipv4.c: In function 'nf_send_reset':
net/ipv4/netfilter/nf_reject_ipv4.c:243:23: error: variable 'niph' set but not used [-Werror=unused-but-set-variable]
  243 |         struct iphdr *niph;
      |                       ^~~~
cc1: all warnings being treated as errors
net/ipv6/netfilter/nf_reject_ipv6.c: In function 'nf_send_reset6':
net/ipv6/netfilter/nf_reject_ipv6.c:286:25: error: variable 'ip6h' set but not used [-Werror=unused-but-set-variable]
  286 |         struct ipv6hdr *ip6h;
      |                         ^~~~
cc1: all warnings being treated as errors

Address this by reducing the scope of these local variables to where
they are used, which is code only compiled when CONFIG_BRIDGE_NETFILTER
enabled.

Compile tested and run through netfilter selftests.

Reported-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Closes: https://lore.kernel.org/netfilter-devel/20240906145513.567781-1-andriy.shevchenko@linux.intel.com/
Signed-off-by: Simon Horman <horms@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/netfilter/nf_reject_ipv4.c | 10 ++++------
 net/ipv6/netfilter/nf_reject_ipv6.c |  5 ++---
 2 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/net/ipv4/netfilter/nf_reject_ipv4.c b/net/ipv4/netfilter/nf_reject_ipv4.c
index 04504b2b51df5..87fd945a0d27a 100644
--- a/net/ipv4/netfilter/nf_reject_ipv4.c
+++ b/net/ipv4/netfilter/nf_reject_ipv4.c
@@ -239,9 +239,8 @@ static int nf_reject_fill_skb_dst(struct sk_buff *skb_in)
 void nf_send_reset(struct net *net, struct sock *sk, struct sk_buff *oldskb,
 		   int hook)
 {
-	struct sk_buff *nskb;
-	struct iphdr *niph;
 	const struct tcphdr *oth;
+	struct sk_buff *nskb;
 	struct tcphdr _oth;
 
 	oth = nf_reject_ip_tcphdr_get(oldskb, &_oth, hook);
@@ -266,14 +265,12 @@ void nf_send_reset(struct net *net, struct sock *sk, struct sk_buff *oldskb,
 	nskb->mark = IP4_REPLY_MARK(net, oldskb->mark);
 
 	skb_reserve(nskb, LL_MAX_HEADER);
-	niph = nf_reject_iphdr_put(nskb, oldskb, IPPROTO_TCP,
-				   ip4_dst_hoplimit(skb_dst(nskb)));
+	nf_reject_iphdr_put(nskb, oldskb, IPPROTO_TCP,
+			    ip4_dst_hoplimit(skb_dst(nskb)));
 	nf_reject_ip_tcphdr_put(nskb, oldskb, oth);
 	if (ip_route_me_harder(net, sk, nskb, RTN_UNSPEC))
 		goto free_nskb;
 
-	niph = ip_hdr(nskb);
-
 	/* "Never happens" */
 	if (nskb->len > dst_mtu(skb_dst(nskb)))
 		goto free_nskb;
@@ -290,6 +287,7 @@ void nf_send_reset(struct net *net, struct sock *sk, struct sk_buff *oldskb,
 	 */
 	if (nf_bridge_info_exists(oldskb)) {
 		struct ethhdr *oeth = eth_hdr(oldskb);
+		struct iphdr *niph = ip_hdr(nskb);
 		struct net_device *br_indev;
 
 		br_indev = nf_bridge_get_physindev(oldskb, net);
diff --git a/net/ipv6/netfilter/nf_reject_ipv6.c b/net/ipv6/netfilter/nf_reject_ipv6.c
index dedee264b8f6c..69a78550261fb 100644
--- a/net/ipv6/netfilter/nf_reject_ipv6.c
+++ b/net/ipv6/netfilter/nf_reject_ipv6.c
@@ -283,7 +283,6 @@ void nf_send_reset6(struct net *net, struct sock *sk, struct sk_buff *oldskb,
 	const struct tcphdr *otcph;
 	unsigned int otcplen, hh_len;
 	const struct ipv6hdr *oip6h = ipv6_hdr(oldskb);
-	struct ipv6hdr *ip6h;
 	struct dst_entry *dst = NULL;
 	struct flowi6 fl6;
 
@@ -339,8 +338,7 @@ void nf_send_reset6(struct net *net, struct sock *sk, struct sk_buff *oldskb,
 	nskb->mark = fl6.flowi6_mark;
 
 	skb_reserve(nskb, hh_len + dst->header_len);
-	ip6h = nf_reject_ip6hdr_put(nskb, oldskb, IPPROTO_TCP,
-				    ip6_dst_hoplimit(dst));
+	nf_reject_ip6hdr_put(nskb, oldskb, IPPROTO_TCP, ip6_dst_hoplimit(dst));
 	nf_reject_ip6_tcphdr_put(nskb, oldskb, otcph, otcplen);
 
 	nf_ct_attach(nskb, oldskb);
@@ -355,6 +353,7 @@ void nf_send_reset6(struct net *net, struct sock *sk, struct sk_buff *oldskb,
 	 */
 	if (nf_bridge_info_exists(oldskb)) {
 		struct ethhdr *oeth = eth_hdr(oldskb);
+		struct ipv6hdr *ip6h = ipv6_hdr(nskb);
 		struct net_device *br_indev;
 
 		br_indev = nf_bridge_get_physindev(oldskb, net);
-- 
2.43.0

