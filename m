Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C1F04C99;
	Thu, 22 Aug 2024 00:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724285838; cv=none; b=FQI/oyoU8Y6JOd6VELrkgb/OqjtDXk2Zh1x3y/iFISAByNCMLN4uQhsr/3Ehj52vDlaCP9hyw9zzTYcDriCTceSqb4nBwfeNFtkbIAJOdIHkyDTA+VDYk/6ARFRwqm5obD2hExu3EvN/3DrgTsii4trUhd8/AhgSOh4BVwVxos8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724285838; c=relaxed/simple;
	bh=QlkbnX3So7ybXk9gnLxo2Ib8PM6TvzIwAyY14gZWxEU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZYzPLOCZQcHZnNgRR0SIYlaFTx5sBguLaX/5BTdA7Ad2pRshJwTg1bMdGjZr7S6cbGIAn1Li1R9CJOiDkrYtpqan5huf300mbFFHXppwNYmcYj7urevl3pUB6E5M/U9pH32ycu3VY8kADkhIYVaCRfN5KbVg/ToG5CQbJQi2qg4=
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
Subject: [PATCH net 3/3] netfilter: flowtable: validate vlan header
Date: Thu, 22 Aug 2024 02:17:07 +0200
Message-Id: <20240822001707.2116-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240822001707.2116-1-pablo@netfilter.org>
References: <20240822001707.2116-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Ensure there is sufficient room to access the protocol field of the
VLAN header, validate it once before the flowtable lookup.

=====================================================
BUG: KMSAN: uninit-value in nf_flow_offload_inet_hook+0x45a/0x5f0 net/netfilter/nf_flow_table_inet.c:32
 nf_flow_offload_inet_hook+0x45a/0x5f0 net/netfilter/nf_flow_table_inet.c:32
 nf_hook_entry_hookfn include/linux/netfilter.h:154 [inline]
 nf_hook_slow+0xf4/0x400 net/netfilter/core.c:626
 nf_hook_ingress include/linux/netfilter_netdev.h:34 [inline]
 nf_ingress net/core/dev.c:5440 [inline]

Fixes: 4cd91f7c290f ("netfilter: flowtable: add vlan support")
Reported-by: syzbot+8407d9bb88cd4c6bf61a@syzkaller.appspotmail.com
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_inet.c | 3 +++
 net/netfilter/nf_flow_table_ip.c   | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/net/netfilter/nf_flow_table_inet.c b/net/netfilter/nf_flow_table_inet.c
index 88787b45e30d..dd9a392052ee 100644
--- a/net/netfilter/nf_flow_table_inet.c
+++ b/net/netfilter/nf_flow_table_inet.c
@@ -17,6 +17,9 @@ nf_flow_offload_inet_hook(void *priv, struct sk_buff *skb,
 
 	switch (skb->protocol) {
 	case htons(ETH_P_8021Q):
+		if (!pskb_may_pull(skb, VLAN_HLEN))
+			return NF_ACCEPT;
+
 		veth = (struct vlan_ethhdr *)skb_mac_header(skb);
 		proto = veth->h_vlan_encapsulated_proto;
 		break;
diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index c2c005234dcd..9a9031e9ea1c 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -281,6 +281,9 @@ static bool nf_flow_skb_encap_protocol(struct sk_buff *skb, __be16 proto,
 
 	switch (skb->protocol) {
 	case htons(ETH_P_8021Q):
+		if (!pskb_may_pull(skb, VLAN_HLEN))
+			return false;
+
 		veth = (struct vlan_ethhdr *)skb_mac_header(skb);
 		if (veth->h_vlan_encapsulated_proto == proto) {
 			*offset += VLAN_HLEN;
-- 
2.30.2

