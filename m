Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69C783BB43
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Apr 2024 23:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712792048; cv=none; b=BvaUfh48wF6EL5IQwNu7zJaMkiEZVnyGWgKC5ZtzszVvONVyUHuIPwdfRGCRyMzfDtpKB1nYUL4ohX6BUNxORI5XGW8bGiKjIN9nNZfbIBUVTL1AG3jvXHdXCl7zbqnu1b0/HErDCP4HEbHcAuU3uYRj4rJ7AB3+yUwIyynpGo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712792048; c=relaxed/simple;
	bh=AU45IUrsV2LziPeZd0voSPGjizEst4/IuqSof6l2+xk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=de+WwaRLJilZqfrpYjlv/luEdsPVii7fm/MvjSQq7v7eBNrm5lSesMD275sLoxvir9ob1xYSzzKLPCwz/zqs7ecnqVPx3R0pLgNu2lwFgfgOqg4k9vvWgGkCol84OC7vf0e24qHlHHaXtr434/L7Q5l+GOSG7qJR9TkzA3YPTI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: nbd@nbd.name
Subject: [PATCH nf,v2] netfilter: flowtable: incorrect pppoe tuple
Date: Thu, 11 Apr 2024 01:34:01 +0200
Message-Id: <20240410233401.3744-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
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
v2: I have accidentally posted an older version of the commit description in v1.

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

