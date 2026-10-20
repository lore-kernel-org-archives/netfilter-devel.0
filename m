Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=165.173.180.15
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792457675;
	b=AbabL+szx8ZRfSqAJ0tDAc36bb2YX6Zm4XA94HMad+UeBpg3hxaEwl9Isc7Mb3P2Y9aK
	 xWPAhWB1RpwAPOG4UzbwVtfmb6wOYzwBFO/1ww9qXEVOPgOMKGtvlTa3QZERUEDlQX/a3
	 56JwZPKaPwRf0q06xVBl9Eu7bnhP4DcAQYvtYXaSc2TBj1FkgaNp7QVud5yN6Wi1cjuvU
	 EQ9TE12jLbKWNqz7eu+sqnmUYknhRMrkVFK8n6l6ukpkFGA3CubPXB40VlyDFykeh7TYO
	 AYvzqvabrTnPdgr91Xiivox4NIyksEma/CQyqf8GpAU/33m9aaOfmUmMKtN098eFpCg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792457675;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-ZohoMailClient;
	bh=A1MJaR1o5ofXZl/EKGW/7dIWDB6pUkbA+XzlNsaM+2U=;
	b=s+t/n6mJveIJ5zW4fyTcB71UXNStdRFNG3dTTMKm0YpvcCFp/iWGNZxH4ebk9cbPoKAm
	 OUZWmu1JETOCY2wS7lh8NFcVMab3FL/6rcUyu67r4N1YOVpn8O/dq50m9/FUXU2wWVpZZ
	 COm7/9KRD9MWDhIiZuUo4JHyk+dJJmBk2Q5DdZlUbJKes80fQRpwJCCdlzNsLyn8RmXxP
	 CE8B9MxUJOZY2xVLMDRxtZaslkmG+tc9KQ3zs2ayKE2UGrfkfjx5tiTSG/+c2C16fY5IJ
	 I4M2JlRYGsWS3vH/yU+aZTHaX+STXkNvMZLxTvrQNCg0cSao+ppAM5JuEqpS/ItGZ3Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=none header.from=laveeshbansal.com;
	spf=pass smtp.mailfrom=laveeshbansal.com;
	dkim=pass header.d=laveeshbansal.com header.i=laveeshb@laveeshbansal.com header.a=rsa-sha256 header.s=zoho header.b=MKwqh6jx;
	arc=pass header.oldest-pass=0 smtp.remote-ip=165.173.180.15
Received: from sender6-op-o15.zoho.com (sender6-op-o15.zoho.com [165.173.180.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6226B606A320;
	Tue, 20 Oct 2026 00:54:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6226B606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=laveeshbansal.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=laveeshbansal.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=laveeshbansal.com header.i=laveeshb@laveeshbansal.com header.a=rsa-sha256 header.s=zoho header.b=MKwqh6jx
ARC-Seal: i=1; a=rsa-sha256; t=1792457649; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=GBndXZ/9cNtB7FamAN9/pKav4zU5WanCuMk0o11T2cEaXX1W2SnJsaQb/4hbaGE4m864mLuTBveLL7oqTRxSgExxqXAPAI1DkzI88oRv1Q7bhQ0zgXvbbBISgq+6BHDjlmBwXyX8bMBwdPTC5HogyC7WBI6+TGb0VM9eH0pAJck=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1792457649; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=A1MJaR1o5ofXZl/EKGW/7dIWDB6pUkbA+XzlNsaM+2U=; 
	b=Y9HCc0YRl+LNcQEBvHKTaH6UUJQ/wbr+eCz5ISLp02BQBaQQ6IKaJ0MXXJwPkt8x2MZFoTLNnECWxSoc8z8w++kcv/iO+c+AU17bUyuklWDgCSpSvoM/uy2NUIzWnyVPQUdgRBsVzimJ5FI9a2dCAMKx1QjrrYJt5CzFZ2x+HxM=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=laveeshbansal.com;
	spf=pass  smtp.mailfrom=laveeshb@laveeshbansal.com;
	dmarc=pass header.from=<laveeshb@laveeshbansal.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1792457648;
	s=zoho; d=laveeshbansal.com; i=laveeshb@laveeshbansal.com;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=A1MJaR1o5ofXZl/EKGW/7dIWDB6pUkbA+XzlNsaM+2U=;
	b=MKwqh6jxC5yItOzCatX3x7o1L8FDkxBvCe6fk4UqpOiwmzGsJRggFx0esHMM1w63
	TN7work5/lcuFe8PEMqwdKuee4/xMszTbYyBJcgXyEBXWdSWE8itv234BXYyy0kFXAg
	QoKMRQvBxtNw7oGsocUOPFdp4Z16vZ5GgLzhaA1s=
Received: by smtp.zohomail.com with SMTPS id 1792457646847783.02779030023;
	Mon, 19 Oct 2026 17:54:06 -0700 (PDT)
From: Laveesh Bansal <laveeshb@laveeshbansal.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Cc: Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	bridge@lists.linux.dev,
	netdev@vger.kernel.org
Subject: [PATCH 1/2] netfilter: bridge: refragment packets with a vlan tag moved by the bridge
Date: Mon, 19 Oct 2026 17:54:03 -0700
Message-ID: <20261020005403.38212-1-laveeshb@laveeshbansal.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261020000308.37362-1-laveeshb@laveeshbansal.com>
References: <20261020000308.37362-1-laveeshb@laveeshbansal.com>
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
X-ZohoMailClient: External

With vlan_filtering enabled, br_allowed_ingress() moves the vlan tag back
into the packet when its protocol differs from the bridge's vlan_protocol,
an 802.1Q tag on an 802.1ad bridge for instance, and sets skb->protocol to
the vlan ethertype. That happens after the NF_BR_PRE_ROUTING hooks.

Bridge conntrack has already defragmented the packet by then, based on the
original protocol. In postrouting nf_ct_bridge_refrag() finds a vlan
ethertype it cannot fragment, warns and drops the packet:

 WARNING: net/bridge/netfilter/nf_conntrack_bridge.c:361 at nf_ct_bridge_post
 Call trace:
  nf_ct_bridge_post
  nf_hook_slow
  br_forward_finish
  __br_forward
  deliver_clone
  br_flood
  br_handle_frame_finish
  br_handle_frame

The warning is the smaller problem. Every fragmented IPv4 or IPv6 packet
that crosses such a bridge is dropped while unfragmented traffic is fine,
so it looks like an MTU issue. And anyone who can send fragments into a
port of such a bridge can trigger the warning, which takes the machine
down with panic_on_warn.

Look past the vlan tag in nf_ct_bridge_refrag(): remember it, pull it,
fragment as before and push it back onto each fragment in
nf_ct_bridge_frag_restore(), together with the outer protocol, so that
br_dev_queue_push_xmit() sees the fragments like any other tagged frame.
The protocol behind the tag comes from the packet, so check it against the
header before fragmenting.

Removing the WARN_ON_ONCE() would only hide the problem, the packets would
still be dropped. Not tracking these frames in nf_ct_bridge_pre() instead
would change what is tracked today for unfragmented traffic, and would have
to duplicate the decision that br_allowed_ingress() makes later.

The syzbot reproducer is an IPv6 atomic fragment with a frag_max_size of
60, which br_ip6_fragment() drops silently because it is below
IPV6_MIN_MTU. It no longer warns either.

Reported-by: syzbot+a8ba738fe2db6b4bb27f@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=a8ba738fe2db6b4bb27f
Fixes: 3c171f496ef5 ("netfilter: bridge: add connection tracking system")
Fixes: 764dd163ac92 ("netfilter: nf_conntrack_bridge: add support for IPv6")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Laveesh Bansal <laveeshb@laveeshbansal.com>
---
 include/linux/netfilter_bridge.h           |  4 ++
 net/bridge/netfilter/nf_conntrack_bridge.c | 43 ++++++++++++++++++++--
 2 files changed, 43 insertions(+), 4 deletions(-)

diff --git a/include/linux/netfilter_bridge.h b/include/linux/netfilter_bridge.h
index 743475ca7e9d..7091e01abe77 100644
--- a/include/linux/netfilter_bridge.h
+++ b/include/linux/netfilter_bridge.h
@@ -10,6 +10,10 @@ struct nf_bridge_frag_data {
 	bool    vlan_present;
 	u16     vlan_tci;
 	__be16  vlan_proto;
+	bool    inband_vlan_present;
+	u16     inband_vlan_tci;
+	__be16  inband_vlan_proto;
+	__be16  inband_vlan_encap_proto;
 };
 
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
diff --git a/net/bridge/netfilter/nf_conntrack_bridge.c b/net/bridge/netfilter/nf_conntrack_bridge.c
index b5444335b86f..e16071eb2df0 100644
--- a/net/bridge/netfilter/nf_conntrack_bridge.c
+++ b/net/bridge/netfilter/nf_conntrack_bridge.c
@@ -344,13 +344,41 @@ nf_ct_bridge_refrag(struct sk_buff *skb, const struct nf_hook_state *state,
 				  const struct nf_bridge_frag_data *data,
 				  struct sk_buff *))
 {
-	struct nf_bridge_frag_data data;
+	struct nf_bridge_frag_data data = {};
+	__be16 proto = skb->protocol;
 
 	if (!BR_INPUT_SKB_CB(skb)->frag_max_size)
 		return NF_ACCEPT;
 
 	nf_ct_bridge_frag_save(skb, &data);
-	switch (skb->protocol) {
+
+	/* A vlan filtering bridge moves a vlan tag into the packet if its
+	 * protocol differs from the bridge's vlan_protocol, after prerouting
+	 * defragmented the packet. Look past that tag.
+	 */
+	if (eth_type_vlan(proto)) {
+		const struct vlan_hdr *vhdr;
+
+		if (skb_network_offset(skb) != VLAN_HLEN ||
+		    !pskb_may_pull(skb, VLAN_HLEN))
+			return NF_DROP;
+
+		vhdr = (const struct vlan_hdr *)skb->data;
+		data.inband_vlan_present = true;
+		data.inband_vlan_tci = ntohs(vhdr->h_vlan_TCI);
+		data.inband_vlan_proto = proto;
+		data.inband_vlan_encap_proto = vhdr->h_vlan_encapsulated_proto;
+
+		proto = data.inband_vlan_encap_proto;
+		__skb_pull(skb, VLAN_HLEN);
+		skb->protocol = proto;
+
+		if ((proto == htons(ETH_P_IP) && ip_hdr(skb)->version != 4) ||
+		    (proto == htons(ETH_P_IPV6) && ipv6_hdr(skb)->version != 6))
+			return NF_DROP;
+	}
+
+	switch (proto) {
 	case htons(ETH_P_IP):
 		nf_br_ip_fragment(state->net, state->sk, skb, &data, output);
 		break;
@@ -358,7 +386,7 @@ nf_ct_bridge_refrag(struct sk_buff *skb, const struct nf_hook_state *state,
 		nf_br_ip6_fragment(state->net, state->sk, skb, &data, output);
 		break;
 	default:
-		WARN_ON_ONCE(1);
+		WARN_ON_ONCE(!data.inband_vlan_present);
 		return NF_DROP;
 	}
 
@@ -371,11 +399,18 @@ static int nf_ct_bridge_frag_restore(struct sk_buff *skb,
 {
 	int err;
 
-	err = skb_cow_head(skb, ETH_HLEN);
+	err = skb_cow_head(skb, ETH_HLEN + (data->inband_vlan_present ? VLAN_HLEN : 0));
 	if (err) {
 		kfree_skb(skb);
 		return -ENOMEM;
 	}
+	if (data->inband_vlan_present) {
+		struct vlan_hdr *vhdr = skb_push(skb, VLAN_HLEN);
+
+		vhdr->h_vlan_TCI = htons(data->inband_vlan_tci);
+		vhdr->h_vlan_encapsulated_proto = data->inband_vlan_encap_proto;
+		skb->protocol = data->inband_vlan_proto;
+	}
 	if (data->vlan_present)
 		__vlan_hwaccel_put_tag(skb, data->vlan_proto, data->vlan_tci);
 	else if (skb_vlan_tag_present(skb))
-- 
2.54.0 (Apple Git-157)

