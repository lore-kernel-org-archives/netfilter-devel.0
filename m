Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E68F26ADC
	for <netfilter-devel@vger.kernel.org>; Wed, 22 Apr 2026 18:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776882883; cv=none; b=HHXT96HQf4rE9FDiB6+SNKOQoKs0h2esuSatPdiOq9nrODRO45ys0AEFNCNpVBzQAkVj7QtFqDAAv34CYtGkRShhaDc+uOtHfhrl2pI+XRr7QZOI+WBi9YKjiVee1tdGnJD3ZhQWBbc9Tr4YPE7DAYnyJuXAoj3x1MnZ3fDFDOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776882883; c=relaxed/simple;
	bh=4YdaBHfRlwiro0J+S8Xz5f+D8bP/OdcaTymjKi3W7Lo=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n8woIpzLVosYHot47XM0J4DPEZ4yPzfXlnKydAkD4JwAImz4TtataydZm02002fnmbIGvRFbKf+uqMqXGbAALqVLj0kVBKvEzE8/5WaGXixxwbAD9FxFbZUyxcBOp0GyfMFkLR3ylqMTapQ3LSbw+KhrGaiYbaOOaynN8QawuY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=CBP6y/Cl; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="CBP6y/Cl"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id E80E56027E
	for <netfilter-devel@vger.kernel.org>; Wed, 22 Apr 2026 20:34:33 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1776882874;
	bh=9LUP/dvQlVisTl6iSVUES0igsm4BaDs8T/SetRuZgWE=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=CBP6y/Cl0wxfebZYFfK5/5lVAu6RLYPDDMz8T2a7zNRvdHqZHjRPDPE0QCnlLJuq4
	 6EzDBSqbmKhmA8wvRwH/tJs6hocPcjQVxUpOpQZPX+jy2smeYYGtcNu+zTZuIioOtJ
	 6g1n0ImG6AynmluG26faYqLQumpDpFDW4b+re+UdlEXJSTp9Z+PTNP8zaWIbgNurhL
	 +i0374DuxAky0nBMfM2vKbCntAOwyecon0KWF33EJ/XU2qQGkp5wn63QS1p7P1Pz8h
	 GcOAGztf0Qyh/GoBSv3JjubRNv/zZVKp22m1MRSidAI+1jSv4QGcN81ribz9mqpOPE
	 g9vvAezSRE4ww==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v3 2/3] netfilter: nft_fwd_netdev: drop packet if no device found when forwarding via neigh
Date: Wed, 22 Apr 2026 20:34:28 +0200
Message-ID: <20260422183429.240452-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260422183429.240452-1-pablo@netfilter.org>
References: <20260422183429.240452-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The ttl field has been decremented already and evaluate of this rule
would proceed, just drop this packet instead if there is no destination
device to forwards this packet. This is exactly what nf_dup already does
in this case.

Fixes: d32de98ea70f ("netfilter: nft_fwd_netdev: allow to forward packets via neighbour layer")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v3: no changes

 net/netfilter/nft_fwd_netdev.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_fwd_netdev.c b/net/netfilter/nft_fwd_netdev.c
index 2cc809303ce8..80416017a2d5 100644
--- a/net/netfilter/nft_fwd_netdev.c
+++ b/net/netfilter/nft_fwd_netdev.c
@@ -153,8 +153,10 @@ static void nft_fwd_neigh_eval(const struct nft_expr *expr,
 	}
 
 	dev = dev_get_by_index_rcu(nft_net(pkt), oif);
-	if (dev == NULL)
-		return;
+	if (dev == NULL) {
+		verdict = NF_DROP;
+		goto out;
+	}
 
 	skb->dev = dev;
 	skb_clear_tstamp(skb);
-- 
2.47.3

