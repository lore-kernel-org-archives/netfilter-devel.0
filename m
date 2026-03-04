Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 131C136AB7E;
	Wed,  4 Mar 2026 17:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772645391; cv=none; b=UKNPZnLmikyjUz49zEF5fepL3q9+ucdbQMolMikVWAX55H0Al5SUxwKlpBUK/aYBNBB6gsyajJdKszMf8W60nYJyjk6wTKZiA47vlCx7cLFVwYp9+d+UubYCRirf/hfxo8jyrQ4Erp24eyjAfr4I7gaNRHMUHa5ENZEpaQ54qow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772645391; c=relaxed/simple;
	bh=Kq1C3KP4QSCFyGVbxqwx3s7fIeCZ9CZSmM4ob+8yt48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nnaOuNIBYUWYxsfyazQjAN+dJlacjVWMikUD2A1jjcb46XS9eJhxPOhKqh7lusqBHW4i97tspAJINhMb2xZeLrnO9oZjd7Ypk5/VyWxUN2tox0e8kHxsRyL5lRF0pis9/kNpHG0jClIFa2t79YgWJ3ULN1Bf2SxtWs4tSrwMOEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id C3C666024F; Wed, 04 Mar 2026 18:29:47 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net 1/4] netfilter: nf_flow_table_ip: Introduce nf_flow_vlan_push()
Date: Wed,  4 Mar 2026 18:29:37 +0100
Message-ID: <20260304172940.24948-2-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260304172940.24948-1-fw@strlen.de>
References: <20260304172940.24948-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Woudstra <ericwouds@gmail.com>

With double vlan tagged packets in the fastpath, getting the error:

skb_vlan_push got skb with skb->data not at mac header (offset 18)

Introduce nf_flow_vlan_push(), that can correctly push the inner vlan
in the fastpath. It is closedly modelled on existing nf_flow_pppoe_push()

Fixes: c653d5a78f34 ("netfilter: flowtable: inline vlan encapsulation in xmit path")
Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_flow_table_ip.c | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 3fdb10d9bf7f..e65c8148688e 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -544,6 +544,27 @@ static int nf_flow_offload_forward(struct nf_flowtable_ctx *ctx,
 	return 1;
 }
 
+static int nf_flow_vlan_push(struct sk_buff *skb, __be16 proto, u16 id)
+{
+	if (skb_vlan_tag_present(skb)) {
+		struct vlan_hdr *vhdr;
+
+		if (skb_cow_head(skb, VLAN_HLEN))
+			return -1;
+
+		__skb_push(skb, VLAN_HLEN);
+		skb_reset_network_header(skb);
+
+		vhdr = (struct vlan_hdr *)(skb->data);
+		vhdr->h_vlan_TCI = htons(id);
+		vhdr->h_vlan_encapsulated_proto = skb->protocol;
+		skb->protocol = proto;
+	} else {
+		__vlan_hwaccel_put_tag(skb, proto, id);
+	}
+	return 0;
+}
+
 static int nf_flow_pppoe_push(struct sk_buff *skb, u16 id)
 {
 	int data_len = skb->len + sizeof(__be16);
@@ -738,8 +759,8 @@ static int nf_flow_encap_push(struct sk_buff *skb,
 		switch (tuple->encap[i].proto) {
 		case htons(ETH_P_8021Q):
 		case htons(ETH_P_8021AD):
-			if (skb_vlan_push(skb, tuple->encap[i].proto,
-					  tuple->encap[i].id) < 0)
+			if (nf_flow_vlan_push(skb, tuple->encap[i].proto,
+					      tuple->encap[i].id) < 0)
 				return -1;
 			break;
 		case htons(ETH_P_PPP_SES):
-- 
2.52.0

