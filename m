Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8A1B28370
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Apr 2024 23:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712791392; cv=none; b=sxqmbPr2OaYN8a7/V0aopmGNjOma+E3rVJMjr+GH+GwYDjxEgDmIOvvyvmlnHl5XeckOHmFt84K93Uxa6U/pez8s3Y5Dvmx9NtcREO52+oG6IrJIxWfiyAHR+F79zwwkgaoEclgxhNxdRK+DMu2xnWJfgnW5ahzpnYYcGvVmS4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712791392; c=relaxed/simple;
	bh=RPViTsMAa3oEpS75/HhrTzv3vCRtuyFHNfBojd9mFZ4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=axMpEOYyBS+anvrnpit08rc3hBJ07pIIumDOTVDueHZ65YQXuFcEl2a4Y/r2FEpgKab0DUpqTRcuCFFQR4QqQSWlhN0YYxs48Yle1LwSZVKxHtbTvPod2IaLxFWB0+F90OC7ipBEkq2jNTzSSPVrylCna6irvfmqJ0/a7PBogx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: nbd@nbd.name
Subject: [PATCH nf] netfilter: flowtable: incorrect pppoe tuple in reply direction
Date: Thu, 11 Apr 2024 01:23:06 +0200
Message-Id: <20240410232306.3379-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

pppoe traffic coming in reply direction does not match the flowtable
entry because the pppoe header is expected to be at the network header
offset. This bug causes a mismatch in the flow table lookup, so pppoe
packets in the reply direction enter the classical forwarding path in
the flow table.

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

