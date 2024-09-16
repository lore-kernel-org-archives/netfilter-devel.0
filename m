Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 561DC14B97D;
	Mon, 16 Sep 2024 09:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726480244; cv=none; b=d4/+LUKqJl6XP+mZ7dUfNMB8KIjjWpcZFnMSeJ8w02dwPVrIX80vkjYM6/rsBfpHaNIn3bMIVm0Bn6a7CrRxkGiP5hJTgz/ezKbwt2nI483m5B0M8dyNietrlkaGD/2H9llE9TEf0nEgSV3aPVFHfZRcDXgz74vHy0iS4r/zaJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726480244; c=relaxed/simple;
	bh=HOoo8GgBBtI55/AwTvXOlcqvlg3QMeDP5VLTBW8tvhk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=I7P17vp+jegbSjEvQgQ122YPkDIY894izT0PSEcKLH72CLzAwtN2RWLWpMJyaiJdQKSI/6ucRNzaWSVDfHPxYUpEPudvd4BugTWn4GTCu3hGMSaQoqWIyopZV05uA8EFIzBBLEV+tE+aBPwIqZCzdFc7yvUsX1TISvLpLbAuTp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fck5qltM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fck5qltM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEF44C4CECC;
	Mon, 16 Sep 2024 09:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726480243;
	bh=HOoo8GgBBtI55/AwTvXOlcqvlg3QMeDP5VLTBW8tvhk=;
	h=From:Date:Subject:To:Cc:From;
	b=Fck5qltMBpWO49cf9aOYG4k+P5vdIK4ujuHNKdditJGXXZVsGN6584FFYNLwcF4V0
	 uVj1fO0nKnRDra8TwYNc8OTJ1iysQZw1Gy8b1rq6GPITZOeaDOGisBejla8D6LTn74
	 l3ZtGwdpGbYix19NwurWeF5SQI0ma6IcUEtIUjjameF8OY0WjwEx8G6Nzj+sl0p9qP
	 Xb6vNWKnY/grm7sdAAP9/6o89wIqnpxcr2doNt9TgTApSXlh1fleKuicAZl8bTmj/M
	 FsLPCBVyp5SZiZ7W8Ei8l2n20cusKmUISTtG7F05aq0QUTj/FhXLGVqybL0AYiWLF5
	 aWksh9lC0kHHA==
From: Simon Horman <horms@kernel.org>
Date: Mon, 16 Sep 2024 10:50:34 +0100
Subject: [PATCH nf-next] netfilter: nf_reject: Fix build warning when
 CONFIG_BRIDGE_NETFILTER=n
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240916-nf-reject-v1-1-24b6dd651c83@kernel.org>
X-B4-Tracking: v=1; b=H4sIAGn/52YC/x3MSwqAIBRG4a3EHSdkT2sr0SD0r24DC5UQpL0nD
 Q98nEQejuFpKhI5POz5sjlkWZA+VrtDsMlNdVW31Sh7YTfhcEIHMagOo5aNhDKU/e2wcfxfM2V
 mEQMt7/sBpmk9nGQAAAA=
To: Pablo Neira Ayuso <pablo@netfilter.org>, 
 Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, 
 "David S. Miller" <davem@davemloft.net>, David Ahern <dsahern@kernel.org>, 
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, netfilter-devel@vger.kernel.org, 
 coreteam@netfilter.org, netdev@vger.kernel.org
X-Mailer: b4 0.14.0

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

--
My feeling is that this is not a bug fix, as the build failure only shows up
with W=1 builds. However, I can see the other side of that argument,
and if you prefer to take these via nf or net, then I am happy with
that.

I believe the fixes tags would be those supplied by Andy at the cited
Link above.

Fixes: 8bfcdf6671b1 ("netfilter: nf_reject_ipv6: split nf_send_reset6() in smaller functions")
Fixes: 052b9498eea5 ("netfilter: nf_reject_ipv4: split nf_send_reset() in smaller functions")
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

