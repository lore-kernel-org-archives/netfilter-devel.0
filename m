Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C87A4321F39;
	Wed, 10 Dec 2025 11:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765364895; cv=none; b=F6DkKXa8RiOeBlzKn9ukq9wCXJzH9SA5aVvBhiMbvF1xPAhCRmodTnembFwaknu9g+mNCcuJtBsyJJNecQFAEyfFIdTIzf3nmlj6+S2ncDSmZBZ/8tmD8YyhxS2bM7NQm9fXjAQxobP8ddm6U5QzrLANVxiBw7QJxNGnnN1Bcrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765364895; c=relaxed/simple;
	bh=8TBoKxKVTVyKrmWai7e/jg4Ts0uGPdgiZfKDIsdxr1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PtLAi5vB94+w9dYy6kaQxGa5XhLcjDx3pA49xvqvV1cOAh97SiesxJr8qsPw6b6UKzBdZMDUnBfyzr9Oe9+UwP+NSLmagvAuvG2LZ5xesFAiqMr36otPws2QbtSMLivPhkmVc4pINfL5SKqo49SFLlxNOLSxksV7CKKkJDFidIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 18FA96054D; Wed, 10 Dec 2025 12:08:12 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net 3/4] netfilter: always set route tuple out ifindex
Date: Wed, 10 Dec 2025 12:07:53 +0100
Message-ID: <20251210110754.22620-4-fw@strlen.de>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251210110754.22620-1-fw@strlen.de>
References: <20251210110754.22620-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Lorenzo Bianconi <lorenzo@kernel.org>

Always set nf_flow_route tuple out ifindex even if the indev is not one
of the flowtable configured devices since otherwise the outdev lookup in
nf_flow_offload_ip_hook() or nf_flow_offload_ipv6_hook() for
FLOW_OFFLOAD_XMIT_NEIGH flowtable entries will fail.
The above issue occurs in the following configuration since IP6IP6
tunnel does not support flowtable acceleration yet:

$ip addr show
5: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 00:11:22:33:22:55 brd ff:ff:ff:ff:ff:ff link-netns ns1
    inet6 2001:db8:1::2/64 scope global nodad
       valid_lft forever preferred_lft forever
    inet6 fe80::211:22ff:fe33:2255/64 scope link tentative proto kernel_ll
       valid_lft forever preferred_lft forever
6: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 00:22:22:33:22:55 brd ff:ff:ff:ff:ff:ff link-netns ns3
    inet6 2001:db8:2::1/64 scope global nodad
       valid_lft forever preferred_lft forever
    inet6 fe80::222:22ff:fe33:2255/64 scope link tentative proto kernel_ll
       valid_lft forever preferred_lft forever
7: tun0@NONE: <POINTOPOINT,NOARP,UP,LOWER_UP> mtu 1452 qdisc noqueue state UNKNOWN group default qlen 1000
    link/tunnel6 2001:db8:2::1 peer 2001:db8:2::2 permaddr a85:e732:2c37::
    inet6 2002:db8:1::1/64 scope global nodad
       valid_lft forever preferred_lft forever
    inet6 fe80::885:e7ff:fe32:2c37/64 scope link proto kernel_ll
       valid_lft forever preferred_lft forever

$ip -6 route show
2001:db8:1::/64 dev eth0 proto kernel metric 256 pref medium
2001:db8:2::/64 dev eth1 proto kernel metric 256 pref medium
2002:db8:1::/64 dev tun0 proto kernel metric 256 pref medium
default via 2002:db8:1::2 dev tun0 metric 1024 pref medium

$nft list ruleset
table inet filter {
        flowtable ft {
                hook ingress priority filter
                devices = { eth0, eth1 }
        }

        chain forward {
                type filter hook forward priority filter; policy accept;
                meta l4proto { tcp, udp } flow add @ft
        }
}

Fixes: b5964aac51e0 ("netfilter: flowtable: consolidate xmit path")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_flow_table_path.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_flow_table_path.c b/net/netfilter/nf_flow_table_path.c
index f0984cf69a09..eb24fe2715dc 100644
--- a/net/netfilter/nf_flow_table_path.c
+++ b/net/netfilter/nf_flow_table_path.c
@@ -250,6 +250,9 @@ static void nft_dev_forward_path(const struct nft_pktinfo *pkt,
 	if (nft_dev_fill_forward_path(route, dst, ct, dir, ha, &stack) >= 0)
 		nft_dev_path_info(&stack, &info, ha, &ft->data);
 
+	if (info.outdev)
+		route->tuple[dir].out.ifindex = info.outdev->ifindex;
+
 	if (!info.indev || !nft_flowtable_find_dev(info.indev, ft))
 		return;
 
@@ -269,7 +272,6 @@ static void nft_dev_forward_path(const struct nft_pktinfo *pkt,
 
 	route->tuple[!dir].in.num_encaps = info.num_encaps;
 	route->tuple[!dir].in.ingress_vlans = info.ingress_vlans;
-	route->tuple[dir].out.ifindex = info.outdev->ifindex;
 
 	if (info.xmit_type == FLOW_OFFLOAD_XMIT_DIRECT) {
 		memcpy(route->tuple[dir].out.h_source, info.h_source, ETH_ALEN);
-- 
2.51.2

