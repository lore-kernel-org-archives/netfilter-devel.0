Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=151.80.46.58
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795206297;
	b=LTStE+/E3t4rtxcG7oEq0Rt08btKneT/jj1qSj2ks3lbng0XpHZS8rS+epAGnoxlGR7P
	 Y3526wmm8DQ72M65+CDSHWlzDCKh/6Cf3k++A1Uuz8vg9xcOWM7bkynpRqnWgEm7ASpE2
	 Y3WcYvbbfp4zdxQ268ZLVlbcZyIlChT+ZAoLSEm6ThsHpBspAlRjWTsi8Xj1ZNMLe+KPF
	 IhCKwhD6Q110UHXKCevsQDo40QexKN4gMZ/18RXLMITZTsMBGeWZuyhLyrhLVTq7cfyfm
	 sUuX6XsoQjVwhtntgThtLhvC1a9L23VMaXGrP2PZVvmiFRgtcCw8jvpERZIkXQNzKRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795206297;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=LBmp+kQFbYMunYHvbbFyWE9yLcRxqnYUGM4QcwasHMM=;
	b=c/0IHzUsk3NZxWeZQqh8KJThH1qJo7+x9xhqxDDtMKy+hARKYfjLqibhFXIJrXPmGL2d
	 71yC9nMFjCKq9uAMoKOt17S3N/cUtCixAE7+lwmjWr8My/0ev5mvns+6M7qea964dFrCH
	 takYpBbf95lcebIQ7QxH8QeSrI/ETWApNXY6krbWftdPabVY3rEsWE4A+N/dFBB/rmcEg
	 l7D4oxHznJ7G1F4lDwOZsbqrjCeuB3oZBv7+ShcrWa6IfScA0QaqsjPmTHm6r3V4ORkUl
	 D/8a5I/tK9UIYbH2BJxYZcV08Z6gjWOIcBV7siWfzUybIxwguvYVuIgxwZekfXAt1pg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=nwl.cc;
	spf=pass smtp.mailfrom=nwl.cc;
	dkim=pass header.d=nwl.cc header.i=@nwl.cc header.a=rsa-sha256 header.s=mail2022 header.b=qWJ1AKXG;
	arc=none smtp.remote-ip=151.80.46.58
Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E1B8606A6ED
	for <netfilter-devel@vger.kernel.org>; Fri, 20 Nov 2026 20:24:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6E1B8606A6ED
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.a=rsa-sha256 header.s=mail2022 header.b=qWJ1AKXG
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=LBmp+kQFbYMunYHvbbFyWE9yLcRxqnYUGM4QcwasHMM=; b=qWJ1AKXGxYHNsrPqXe4eBu5YKq
	EiI79xqSxYC3kP+ajqmVwuRkgGkpKp8/SpdkltnZ/a1Q79pyNftdwj1BRFJhdQH5pqdMVgKePhjks
	hXAXTCLe1nqjmDeP3uPn01PtcOZMnxWwxZg3kOiCBlFHSPaVEptSabDhJBJ24LNKKSOM9UY+628Yv
	ly4XezCnf8bc2/hXILYD5WPgNEdNf+gDFzBv5rg8fjvHxQRN5YhixTICJPh3w46Jsya1yrHcujPmY
	2xBMtLKouVAHcA8xENgr6bIAVGSufvB3Qu/miXDPKvva6JG0janoUn2jL/QzOhI13jfzye9YfN0Po
	zS5WpXiA==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=tia)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1xUVA0-000000005tf-02co;
	Fri, 20 Nov 2026 21:24:40 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nf-next PATCH 1/2] netfilter: br_netfilter: Fix for missing refrag of VLAN packets
Date: Fri, 20 Nov 2026 21:24:33 +0100
Message-ID: <20261120202434.1084006-1-phil@nwl.cc>
X-Mailer: git-send-email 2.54.0
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It is possible to create a VLAN-aware bridge via IFLA_BR_VLAN_FILTERING
netlink attribute while keeping the global bridge-nf-filter-vlan-tagged
sysctl off.

When combining this constellation with conntrack, incoming traffic is
defragmented but due to the failing is_vlan_* macros, packet
refragmentation does not happen.

In detail, br_nf_forward hook has to set nf_bridge->physoutdev so
br_nf_post_routing hook does not return early and ip_do_fragment gets
called (via br_nf_dev_queue_xmit and br_nf_ip_fragment).

Extending the is_vlan_* macros to also take into account the bridge's
BROPT_VLAN_ENABLED flag fixes for all this.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 net/bridge/br_netfilter_hooks.c | 29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
index 3b28f81a461a..ae7cae0a82c7 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -90,27 +90,38 @@ static inline __be16 vlan_proto(const struct sk_buff *skb)
 		return 0;
 }
 
-static inline bool is_vlan_ip(const struct sk_buff *skb, const struct net *net)
+static inline bool is_vlan_enabled(const struct sk_buff *skb,
+				   const struct net *net)
 {
 	struct brnf_net *brnet = net_generic(net, brnf_net_id);
+	struct net_bridge_port *port = NULL;
+
+	if (brnet->filter_vlan_tagged)
+		return true;
+
+	if (skb->dev)
+		port = br_port_get_rcu(skb->dev);
+
+	if (port && port->br)
+		return br_opt_get(port->br, BROPT_VLAN_ENABLED);
+
+	return false;
+}
 
-	return vlan_proto(skb) == htons(ETH_P_IP) && brnet->filter_vlan_tagged;
+static inline bool is_vlan_ip(const struct sk_buff *skb, const struct net *net)
+{
+	return vlan_proto(skb) == htons(ETH_P_IP) && is_vlan_enabled(skb, net);
 }
 
 static inline bool is_vlan_ipv6(const struct sk_buff *skb,
 				const struct net *net)
 {
-	struct brnf_net *brnet = net_generic(net, brnf_net_id);
-
-	return vlan_proto(skb) == htons(ETH_P_IPV6) &&
-	       brnet->filter_vlan_tagged;
+	return vlan_proto(skb) == htons(ETH_P_IPV6) && is_vlan_enabled(skb, net);
 }
 
 static inline bool is_vlan_arp(const struct sk_buff *skb, const struct net *net)
 {
-	struct brnf_net *brnet = net_generic(net, brnf_net_id);
-
-	return vlan_proto(skb) == htons(ETH_P_ARP) && brnet->filter_vlan_tagged;
+	return vlan_proto(skb) == htons(ETH_P_ARP) && is_vlan_enabled(skb, net);
 }
 
 static inline __be16 pppoe_proto(const struct sk_buff *skb)
-- 
2.54.0

