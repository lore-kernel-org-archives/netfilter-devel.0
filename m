Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=165.173.182.15
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794252036;
	b=S1PJKh+CZ7uyUb/TfWQiG8h+1tpnWv96YtLDbOHntZZg642al4iAfyNuMMX3+L+7LRX2
	 Nl1Xk9nmpFYYgYUnTC1ejVbO4nWykGVOFI0sUUaZ6fAIetobs80uy3c2S5aLio8My6phq
	 bX5/twJNXKnFgzvib1vXJGAhXLewaUiZhuoDb/RJt+YWs3WCASlEl7i5HgN/mvqDwEl3s
	 /8X7P7QlhRLvZ5bRFnBLxFlW6ER/5rGPq7KGnl0VjlgmDmT0uTnzica/RqQeMxRSZikul
	 4pgiESnApIq3xaCSM9l+JdznLZMn4U3Undii0PiHHEbXyH4rmftrYQeWVoEnxqjfPCw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794252036;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-ZohoMailClient;
	bh=Nhzq97sTIHN2BoJBu56XtPBI3mv0MPq/xb24cHqVV6g=;
	b=hHByca/vixwhZa+WS4XmEbgBfZHX+TgqkWe0MxQrFnVhx7VQQpBsQyO6/rQMgFk9fUtW
	 qmFi+1C4taiIDSBqNEVc6BX/OSZOhLmLf9XepI2vxQ1AYGLb24J+eVU5czaIgSFmrpb7s
	 4Ot2P4bzJZ7FYR7Gdlqychvy6SVn7mZHJ+ARRCz2K1u5KN718XEYT76dFGxnnC1QMGpM3
	 wDDmcJGy4ZBlLi+RyOhSuImClfywiLED0rETJB4u6Ft+ORizQpX1PJcz0NbTfoZbgE3uG
	 KatFjWTvqduYvvBkAQ1ue9zwebMzfyx993qt78T7BTidfq+DQbL47nw++eWerqJh29g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=none header.from=laveeshbansal.com;
	spf=pass smtp.mailfrom=laveeshbansal.com;
	dkim=pass header.d=laveeshbansal.com header.i=@laveeshbansal.com header.a=rsa-sha256 header.s=zoho header.b=Y+mYSF2U;
	arc=pass header.oldest-pass=0 smtp.remote-ip=165.173.182.15
Received: from sender5-op-o15.zoho.com (sender5-op-o15.zoho.com [165.173.182.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 656F960A2604;
	Mon,  9 Nov 2026 19:20:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 656F960A2604
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=laveeshbansal.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=laveeshbansal.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=laveeshbansal.com header.i=@laveeshbansal.com header.a=rsa-sha256 header.s=zoho header.b=Y+mYSF2U
ARC-Seal: i=1; a=rsa-sha256; t=1794252013; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=fKji/bUVi/MFPeTIh2ae8l981xMMXy1zZfjKYTusbXoJxsc9SpLPcRANoRwuq5I128Pf+xiFCBHUavytj88B8EZisnUER1ld1O6YTXmZ9h5XthPkACa8elGdfZJjXDCgOG+JxzFwvhoTP46qHlRFpjR0rkuyvIf03dMcjzTJaW0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1794252013; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=Nhzq97sTIHN2BoJBu56XtPBI3mv0MPq/xb24cHqVV6g=; 
	b=mako8I1mdwlo7TWPcJQsoIwsJ42v9fnTHWHm5BqTT9W41b4FDvuXNtBf7eucqgSF1wns4gV3kGeWlG2VgJo2CNA2OM5xUwB7gRKRuUTNeqDgYqxiJquQ6rWlWJ1q+T2IK0AMPY67AoHAjfUdR0oax1gP+0FrLFL6guf7oopKsJc=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=laveeshbansal.com;
	spf=pass  smtp.mailfrom=laveeshb@laveeshbansal.com;
	dmarc=pass header.from=<laveeshb@laveeshbansal.com>
DKIM-Signature: a=rsa-sha256; b=Y+mYSF2UpdPAEuwHpfZTReZl0ZdymqnqX9CaQLR9L8Uq00MH/HeSgUBMTJqlP6blskQm7mRu5I/cl+w159+SsCkLi01HwT1kN88ivPW73/OmeTQHTl6gB0GalNaF1fW+IRcKR5gLJsAG4XhLRBLlRThCkHT5SRn+fP1zj+d0SSM=; c=relaxed/relaxed; s=zoho; d=laveeshbansal.com; v=1; bh=Nhzq97sTIHN2BoJBu56XtPBI3mv0MPq/xb24cHqVV6g=; h=Content-Description:Content-ID:Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:List-Subscribe:List-Post:List-Owner:List-Id:List-Archive:List-Help:List-Unsubscribe:MIME-Version:Message-ID:Resent-Sender:Resent-Cc:Resent-Date:Resent-To:Reply-To:Resent-Message-ID:Resent-From:Sender:Subject:To:Date:From:Message-Id:Reply-To:Subject:To:Cc;
Received: by smtp.zohomail.com with SMTPS id 1794252012567274.2306335321746;
	Mon, 9 Nov 2026 11:20:12 -0800 (PST)
From: Laveesh Bansal <laveeshb@laveeshbansal.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Cc: Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	syzbot+a8ba738fe2db6b4bb27f@syzkaller.appspotmail.com,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	bridge@lists.linux.dev,
	netdev@vger.kernel.org
Subject: [PATCH nf-next 1/2] netfilter: bridge: refragment packets with a vlan tag moved by the bridge
Date: Mon,  9 Nov 2026 11:18:41 -0800
Message-ID: <20261109191842.57359-2-laveeshb@laveeshbansal.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261109191842.57359-1-laveeshb@laveeshbansal.com>
References: <20261109191842.57359-1-laveeshb@laveeshbansal.com>
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

Fragmented IPv4 and IPv6 packets are dropped on a vlan filtering bridge
with bridge conntrack when the protocol of their vlan tag differs from the
vlan_protocol of the bridge, an 802.1Q tag on an 802.1ad bridge for
instance. Unfragmented traffic is not affected.

br_allowed_ingress() moves such a tag back into the packet after the
NF_BR_PRE_ROUTING hooks and sets skb->protocol to the vlan ethertype, but
bridge conntrack has already defragmented the packet by then. In
postrouting nf_ct_bridge_refrag() does not know that ethertype and drops
the packet. On CONFIG_DEBUG_NET kernels the drop also warns, which is what
syzbot reported.

Save the tag with the ethernet header, pull the tag off before fragmenting
and push it back onto each fragment in nf_ct_bridge_frag_restore(), as
br_netfilter does with its encapsulation header. A ruleset can rewrite the
tag, so check the IP version against its ethertype first.

Reported-by: syzbot+a8ba738fe2db6b4bb27f@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=a8ba738fe2db6b4bb27f
Signed-off-by: Laveesh Bansal <laveeshb@laveeshbansal.com>
---
 include/linux/netfilter_bridge.h           |  4 +-
 net/bridge/netfilter/nf_conntrack_bridge.c | 46 ++++++++++++++++++----
 2 files changed, 41 insertions(+), 9 deletions(-)

diff --git a/include/linux/netfilter_bridge.h b/include/linux/netfilter_bridge.h
index 743475ca7e9d..772f6da27237 100644
--- a/include/linux/netfilter_bridge.h
+++ b/include/linux/netfilter_bridge.h
@@ -3,10 +3,12 @@
 #define __LINUX_BRIDGE_NETFILTER_H
 
 #include <uapi/linux/netfilter_bridge.h>
+#include <linux/if_vlan.h>
 #include <linux/skbuff.h>
 
 struct nf_bridge_frag_data {
-	char    mac[ETH_HLEN];
+	char    mac[ETH_HLEN + VLAN_HLEN];
+	u8      encap_len;
 	bool    vlan_present;
 	u16     vlan_tci;
 	__be16  vlan_proto;
diff --git a/net/bridge/netfilter/nf_conntrack_bridge.c b/net/bridge/netfilter/nf_conntrack_bridge.c
index 8c83dc05114b..be4a04e9c90e 100644
--- a/net/bridge/netfilter/nf_conntrack_bridge.c
+++ b/net/bridge/netfilter/nf_conntrack_bridge.c
@@ -326,8 +326,10 @@ static unsigned int nf_ct_bridge_in(void *priv, struct sk_buff *skb,
 }
 
 static void nf_ct_bridge_frag_save(struct sk_buff *skb,
-				   struct nf_bridge_frag_data *data)
+				   struct nf_bridge_frag_data *data,
+				   unsigned int encap_len)
 {
+	data->encap_len = encap_len;
 	if (skb_vlan_tag_present(skb)) {
 		data->vlan_present = true;
 		data->vlan_tci = skb->vlan_tci;
@@ -335,7 +337,8 @@ static void nf_ct_bridge_frag_save(struct sk_buff *skb,
 	} else {
 		data->vlan_present = false;
 	}
-	skb_copy_from_linear_data_offset(skb, -ETH_HLEN, data->mac, ETH_HLEN);
+	skb_copy_from_linear_data_offset(skb, -ETH_HLEN, data->mac,
+					 ETH_HLEN + encap_len);
 }
 
 static unsigned int
@@ -345,12 +348,38 @@ nf_ct_bridge_refrag(struct sk_buff *skb, const struct nf_hook_state *state,
 				  struct sk_buff *))
 {
 	struct nf_bridge_frag_data data;
+	__be16 proto = skb->protocol;
+	unsigned int encap_len = 0;
 
 	if (!BR_INPUT_SKB_CB(skb)->frag_max_size)
 		return NF_ACCEPT;
 
-	nf_ct_bridge_frag_save(skb, &data);
-	switch (skb->protocol) {
+	/* A vlan filtering bridge moves a vlan tag into the packet if its
+	 * protocol differs from the bridge vlan_protocol, after prerouting
+	 * defragmented the packet. Look past that tag.
+	 */
+	if (eth_type_vlan(proto)) {
+		const struct vlan_hdr *vhdr;
+
+		if (skb_network_offset(skb) != VLAN_HLEN) {
+			DEBUG_NET_WARN_ON_ONCE(1);
+			return NF_DROP;
+		}
+
+		vhdr = (const struct vlan_hdr *)skb->data;
+		encap_len = VLAN_HLEN;
+		proto = vhdr->h_vlan_encapsulated_proto;
+
+		/* A ruleset can rewrite the tag, make sure it still matches */
+		if ((proto == htons(ETH_P_IP) && ip_hdr(skb)->version != 4) ||
+		    (proto == htons(ETH_P_IPV6) && ipv6_hdr(skb)->version != 6))
+			return NF_DROP;
+	}
+
+	nf_ct_bridge_frag_save(skb, &data, encap_len);
+	__skb_pull(skb, encap_len);
+
+	switch (proto) {
 	case htons(ETH_P_IP):
 		nf_br_ip_fragment(state->net, state->sk, skb, &data, output);
 		break;
@@ -358,20 +387,19 @@ nf_ct_bridge_refrag(struct sk_buff *skb, const struct nf_hook_state *state,
 		nf_br_ip6_fragment(state->net, state->sk, skb, &data, output);
 		break;
 	default:
-		DEBUG_NET_WARN_ON_ONCE(1);
+		DEBUG_NET_WARN_ON_ONCE(!encap_len);
 		return NF_DROP;
 	}
 
 	return NF_STOLEN;
 }
 
-/* Actually only slow path refragmentation needs this. */
 static int nf_ct_bridge_frag_restore(struct sk_buff *skb,
 				     const struct nf_bridge_frag_data *data)
 {
 	int err;
 
-	err = skb_cow_head(skb, ETH_HLEN);
+	err = skb_cow_head(skb, ETH_HLEN + data->encap_len);
 	if (err) {
 		kfree_skb(skb);
 		return -ENOMEM;
@@ -381,7 +409,9 @@ static int nf_ct_bridge_frag_restore(struct sk_buff *skb,
 	else if (skb_vlan_tag_present(skb))
 		__vlan_hwaccel_clear_tag(skb);
 
-	skb_copy_to_linear_data_offset(skb, -ETH_HLEN, data->mac, ETH_HLEN);
+	__skb_push(skb, data->encap_len);
+	skb_copy_to_linear_data_offset(skb, -ETH_HLEN, data->mac,
+				       ETH_HLEN + data->encap_len);
 	skb_reset_mac_header(skb);
 
 	return 0;
-- 
2.43.0

