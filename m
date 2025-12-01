Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCC1D301475;
	Mon,  1 Dec 2025 10:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764584589; cv=none; b=QjZqb61h0OA3QzmVdy0re0xV6BxnstyybL5Kzc6KDWMayoPX+OtpDu2+eVF5HlZCLn76mpn1NacBTjC27e7HgOozxPPjT2d/qhx55ueaDLwI1/Oy+pqOSJzmRvaR0CF2fSwhInFXoZBm51z7sKzllv0dYk9fX0Q9/bW+F6sg1Us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764584589; c=relaxed/simple;
	bh=kwh+Hg/LLxhbNL95rorHfY6ghNbojJFzs7vONsAbfOc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=ngd4dx31UD6ZIulc93v6I7jCW4q8CCAlq/J7dJmjvuCydcpTEPjxHWmw1LpjsM6sw9mHxmAMLVNE6QAHF1nxPAE/oG3IiWzDA+4NP7BH4wa7UTjx0WyX3GFVN4HCj8wqxRHZvszODsrFTBtXlnzSpQz0Lbrm/EGX/VE3Y8YHNjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WvqBgENG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WvqBgENG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C042C4CEF1;
	Mon,  1 Dec 2025 10:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764584588;
	bh=kwh+Hg/LLxhbNL95rorHfY6ghNbojJFzs7vONsAbfOc=;
	h=From:Date:Subject:To:Cc:From;
	b=WvqBgENGEDXHC7flebeOx3Tz33HtLbC9uwdT2JsgzyIGVwXIh847fEcplLdSQaS/C
	 s6KLUXw6WrBcXQVfrbKQat4D2mxMwg+Y/6rcTDdo5kAp5gImiVJCUh/WfvVw5PD6DQ
	 kC2OZgcnfDVylKmfAUgCFpjkjOOPvXlqDof7JaY3zZHN6/+80FUl54f59BWoJ0j05Q
	 Z2F5PrBuf/2NUtvpJjbtLenVm3ZAuBYY0b1LKXcmusKMZhraj3B6oWRr2RxgZU/yLf
	 PrvzRWX0qBcjIz/1FFwId71Miq7lgaCK1oNwLKakOtAwCHvWM/HKqC5z2qr1/287j7
	 88yZ5B8G4fysw==
From: Lorenzo Bianconi <lorenzo@kernel.org>
Date: Mon, 01 Dec 2025 11:22:45 +0100
Subject: [PATCH nf-next] netfilter: Always set route tuple out ifindex
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251201-nft-flowtable-always-set-ifidx-v1-1-0aa6f08ffe4b@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x3NTQqEMAxA4atI1hNog104VxlcdGzqBEodmuIP4
 t0tLr/NeycoF2GFd3dC4VVUltxgXx1MP59nRgnNQIacJWMxx4oxLVv138To0+YPReWKEiXsaIj
 7gZ0LQ0/QIv/CUfZn8Bmv6wYhy2igcAAAAA==
X-Change-ID: 20251201-nft-flowtable-always-set-ifidx-02e49e55d942
To: Pablo Neira Ayuso <pablo@netfilter.org>, 
 Jozsef Kadlecsik <kadlec@netfilter.org>, Florian Westphal <fw@strlen.de>, 
 Phil Sutter <phil@nwl.cc>, "David S. Miller" <davem@davemloft.net>, 
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
 netdev@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>
X-Mailer: b4 0.14.2

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
---
 net/netfilter/nf_flow_table_path.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_flow_table_path.c b/net/netfilter/nf_flow_table_path.c
index f0984cf69a09bbd8404caf67c2a774bf5833f572..eb24fe2715dcd5fcafa054309c91ccb2601249c1 100644
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

---
base-commit: 0177f0f07886e54e12c6f18fa58f63e63ddd3c58
change-id: 20251201-nft-flowtable-always-set-ifidx-02e49e55d942

Best regards,
-- 
Lorenzo Bianconi <lorenzo@kernel.org>

