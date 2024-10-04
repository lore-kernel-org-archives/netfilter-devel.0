Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC17B20A5C2;
	Fri,  4 Oct 2024 18:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728066389; cv=none; b=cPDgqmjyAobA3tvl5MFCTdeeosuG4IV7T1fFqpLpYtBFbkWGUG7Snatc1yNeOSd8WO+TOULCfd0g8YWv9j71NRQfqCNlsW0PZyZF271Vgnv2emp0xlMQ3EpV+DXCAGllRZ3xpoGZ3ZY5FlmAzKPxqsW678SFqHy2yBSTG2EHQ0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728066389; c=relaxed/simple;
	bh=NrzXJZDx0dptT72YikNWgimxGvTxxOJTbTzoheB5UfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jRguFCg4+gN7D54CZltjayGs5YzKxoVKam7NP7V5XO3L4MyHvo7qd33OEf2Gs3jN6rKtyggHgdooQ04GlpdH6q6m2LzKy/zeRc2UcF1vjVCxw5VE6K9ojMhfzQKavE4xkq4LfmI3Kok+r/9jbfinjyfhVcP4S9qWrEEi+op+oEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uhSI1O3p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uhSI1O3p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12BCEC4CECC;
	Fri,  4 Oct 2024 18:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728066389;
	bh=NrzXJZDx0dptT72YikNWgimxGvTxxOJTbTzoheB5UfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uhSI1O3pX9mhN4kn1eRmGihl94Cfr6wbJ8A+kbSC0DmhlWJB0QQqc9TkDXhTaR7C+
	 BGjBRvEEqayj+lminn9ebWLsyN0bY9OHXoyIgQKAICbYua6LYu5uYBo0Q6stBnFdYG
	 Pn0FCsO+9GxkWpjgPcRrhTgjEuvQA+9/9rRcbaho/ZFiPralQt6F4a5NufQLdo4xE6
	 5hZh7KnMSCzLrh9hF4c18c1bwxwmvsOxN3kzzM0lr6/vgFn97MGEwdRvs7rWe3URqJ
	 mNwRAHHpeq+nBP5/pAmdq/9ei9yucwflgcK8bHpFmYgzq5MBs0pZBiXytsVHxCmqbZ
	 YbKAnOUuJrAcQ==
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
Subject: [PATCH AUTOSEL 6.6 47/58] netfilter: nf_reject: Fix build warning when CONFIG_BRIDGE_NETFILTER=n
Date: Fri,  4 Oct 2024 14:24:20 -0400
Message-ID: <20241004182503.3672477-47-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241004182503.3672477-1-sashal@kernel.org>
References: <20241004182503.3672477-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.54
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
index fc761915c5f6f..675b5bbed638e 100644
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
index 71d692728230e..c8f5196d752e6 100644
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

