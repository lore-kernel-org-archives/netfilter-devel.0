Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8067414A087;
	Thu, 11 Apr 2024 11:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712834956; cv=none; b=aiKhcvaDdHd92ANgI2sSo1W00Zyvn0liphPM5SJQ+BjiK8EeCrww2gohI4bYcOsKV2oK/A3A4tqquAfaSUW7Pw+V+WZC4AKMvVxtcEB7CcxXPZCfnEvf0Q51staK4js1YQogg8UlKTJ+LN0EkpjZOPg7mb4bsEb6Vmojdd1RxqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712834956; c=relaxed/simple;
	bh=gXgVC7n6vM41TnnKzvyYVavk1jd7hpTh63ldXwJ0HTY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TioNz1WWiXDuD9JSGh5DuJPzwQZZo9g2F3oW46yZ81hH1t1W10/7gnE8c7at7Lgub+nkmwfUuKUpSVsZ4qXy6fRNtpNyqrUw2h0trH2Oq5jKBwYiVi3W0HHprbI21sGZPiQJaycmBuJXnQLJZq7wguR/dJwxL+CRFmgspt4gX68=
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
Subject: [PATCH net 7/7] netfilter: flowtable: incorrect pppoe tuple
Date: Thu, 11 Apr 2024 13:29:00 +0200
Message-Id: <20240411112900.129414-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240411112900.129414-1-pablo@netfilter.org>
References: <20240411112900.129414-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

pppoe traffic reaching ingress path does not match the flowtable entry
because the pppoe header is expected to be at the network header offset.
This bug causes a mismatch in the flow table lookup, so pppoe packets
enter the classical forwarding path.

Fixes: 72efd585f714 ("netfilter: flowtable: add pppoe support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_ip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 9e9e105052da..5383bed3d3e0 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -157,7 +157,7 @@ static void nf_flow_tuple_encap(struct sk_buff *skb,
 		tuple->encap[i].proto = skb->protocol;
 		break;
 	case htons(ETH_P_PPP_SES):
-		phdr = (struct pppoe_hdr *)skb_mac_header(skb);
+		phdr = (struct pppoe_hdr *)skb_network_header(skb);
 		tuple->encap[i].id = ntohs(phdr->sid);
 		tuple->encap[i].proto = skb->protocol;
 		break;
-- 
2.30.2

