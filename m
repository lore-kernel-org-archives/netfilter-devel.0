Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84E3439DBF9
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Jun 2026 09:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780307426; cv=none; b=rkLaN/FshyDnHmQKRVqSkx9neK3nvwFO62jiXflrKi2J43GqrjkyHd1kdOY6qCSRTNSfCwnKFvr+kaZbggZ12hMMd44EUFdiZdzuTdU0ZN+wRgp01aQ39CDY3uLgDvpccQfM6vGVgjP4cY5Ga523JLOpQZ2idOkLeoMAXJct1Ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780307426; c=relaxed/simple;
	bh=kFflRUGqmcmH0XOCMdxDF9qHXy9Fpt4Rlsuj2e3P4rs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RlRhmJpnX8Hm2Qx1CNPWoUQsHAf+Jk2aEbiCiSm3vb4Lg/nkZG7z2YfwzG3CAqr/JcLtbp8AWWGTXo9rEY6aUZmEqPNHoMWylpJKfuDBVKfmkunBUO7+GfEiueuO9wa2YDuJWdhqfaojAPkDjVbws3md9Rq9a8wuHMw9/iyDwqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 4BE0D604DC; Mon, 01 Jun 2026 11:50:11 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>,
	Hacking <eilaimemedsnaimel@gmail.com>
Subject: [PATCH nf] netfilter: bridge: ebt_redirect: don't assume bridge port exists
Date: Mon,  1 Jun 2026 11:50:00 +0200
Message-ID: <20260601095000.595383-1-fw@strlen.de>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ebt_redirect_tg() dereferences br_port_get_rcu() return without a
NULL check, causing a kernel panic when the bridge port has been
removed between the original hook invocation and an NFQUEUE
reinject.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Hacking <eilaimemedsnaimel@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/bridge/netfilter/ebt_redirect.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/net/bridge/netfilter/ebt_redirect.c b/net/bridge/netfilter/ebt_redirect.c
index 307790562b49..379662961aeb 100644
--- a/net/bridge/netfilter/ebt_redirect.c
+++ b/net/bridge/netfilter/ebt_redirect.c
@@ -20,16 +20,25 @@ static unsigned int
 ebt_redirect_tg(struct sk_buff *skb, const struct xt_action_param *par)
 {
 	const struct ebt_redirect_info *info = par->targinfo;
+	const unsigned char *dev_addr;
 
 	if (skb_ensure_writable(skb, 0))
 		return EBT_DROP;
 
-	if (xt_hooknum(par) != NF_BR_BROUTING)
-		/* rcu_read_lock()ed by nf_hook_thresh */
-		ether_addr_copy(eth_hdr(skb)->h_dest,
-				br_port_get_rcu(xt_in(par))->br->dev->dev_addr);
-	else
-		ether_addr_copy(eth_hdr(skb)->h_dest, xt_in(par)->dev_addr);
+	if (xt_hooknum(par) != NF_BR_BROUTING) {
+		const struct net_bridge_port *port;
+
+		port = br_port_get_rcu(xt_in(par));
+		if (!port)
+			return EBT_DROP;
+
+		dev_addr = port->br->dev->dev_addr;
+	} else {
+		dev_addr = xt_in(par)->dev_addr;
+	}
+
+	ether_addr_copy(eth_hdr(skb)->h_dest, dev_addr);
+
 	skb->pkt_type = PACKET_HOST;
 	return info->target;
 }
-- 
2.54.0

