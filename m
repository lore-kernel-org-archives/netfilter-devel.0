Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CF0E1AF4F7;
	Thu, 26 Sep 2024 11:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727348858; cv=none; b=GoXJKHcSf6eqQbMRCAGnrfl+JhNd2OFmBns1tCxKwELO6lafhlGHkV9MyLLmsG9wT0In2e1g08AZfhhPpnfOFfGa+GyVH9uFnccDIuO8WGhf2i3UUOT6OQbBhW8ckcb0cKKE+E2cPygtNJndfp+KXoQmpkQ3XN7b0/AWzvr36dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727348858; c=relaxed/simple;
	bh=7GTRjcrDHdtxAeMHhSUqmgkei9QeFrE8d18fxEId5dU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dg4oz51Y6jFGUnV9BcbD6PtrWzziyJJdH2bBL6BTBZUymI55ztu/RACqG6CnvnjUZCc7Xi+dSib0IJQyDJgj3Rcz2yx5sMzsX5uGPQq0GMuVZbtN673sy9/ZM2zik2gvyFfRTXMjISFDpbR4AeWxjBpZTcylTf7YB7ibk0dtIlo=
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
Subject: [PATCH net 08/14] netfilter: nf_reject: Fix build warning when CONFIG_BRIDGE_NETFILTER=n
Date: Thu, 26 Sep 2024 13:07:11 +0200
Message-Id: <20240926110717.102194-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240926110717.102194-1-pablo@netfilter.org>
References: <20240926110717.102194-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Simon Horman <horms@kernel.org>

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
---
 net/ipv4/netfilter/nf_reject_ipv4.c | 10 ++++------
 net/ipv6/netfilter/nf_reject_ipv6.c |  5 ++---
 2 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/net/ipv4/netfilter/nf_reject_ipv4.c b/net/ipv4/netfilter/nf_reject_ipv4.c
index 04504b2b51df..87fd945a0d27 100644
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
index dedee264b8f6..69a78550261f 100644
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
2.30.2

