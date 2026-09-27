Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA3B0429013;
	Sun, 27 Sep 2026 22:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790548491; cv=none; b=O5iPgApuVk0/tKa5AgMbxM2HJwflzMWoVjcjmyj69zCIJM8YSL5IHGVZHC2IQ7/B1A6Rf6NSaZNueu/K8L2AH9/XtDkwh09a5ByQpBvbQnpoK3jP5PHis4JUZIeG2YUfXHLKJvMIP26GLjiH4phTi4PNfYX7CKbafI5uWu/N0bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790548491; c=relaxed/simple;
	bh=p3LOn1dNKK7FAoRZ2H8TlFwuXuZ3iVQmO2gaHxjyWDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=efeAdQaDOsruAsCIDY3PFVRRxikKYvL4OapTdoqNDMtSBgNMEPEAVKDAYIoX+SkvbYPHqxSvPOHS68mXafn7AdQW7084S9dcDWLt4K96ZRdl58IKcRHfXWLCUg04ovNMZpUyvr8Fp73UHJmSXzDoz8KyaMlO4vLJEXzOVB/MVMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Ql8NN1EM; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Ql8NN1EM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1790548487;
	bh=q7Z/Gp5i0yjPI8SSJQEFXqrkNRwdtrO/sJiTMFYfRrQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ql8NN1EMZtzoeJKwlgN6gzB2e1txwVQcN4UktZaiBzJiRrPCRz/NkZ/Jji7K6dsdY
	 0qCp3s2rjJCDs+mMNN1ZuCcVampacrODR1NIuiHUcUDsNdV7CksVVWqWd0tlGWS8Q8
	 Blh8vPr2z4FcJ5Vaa9gqMLAXX2tDmmd+UT6Ao6GWMgjIcALUDRmEKLv3UI9CN1Bu5/
	 xqDbS9mbQX1zVvwoZS9tkDK1BgCZ2XRq0CFa6GdkXAxgeQjYrxH0qdBLkyCPGvFPxK
	 qYzgo3sjWEwLd7cpwSv/Wfj9EXZoYxbQf6WpATEnlTswe/AIxWlsR1fzuGUdw+PvpP
	 SOrrJkChAcV8A==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 7EAA060082;
	Mon, 28 Sep 2026 00:34:47 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net-next 06/11] netfilter: conntrack: Untangle drop and invalid counters
Date: Mon, 28 Sep 2026 00:34:31 +0200
Message-ID: <20260927223436.269024-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260927223436.269024-1-pablo@netfilter.org>
References: <20260927223436.269024-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Phil Sutter <phil@nwl.cc>

In nf_conntrack_in, 'drop' counter increments if
nf_conntrack_handle_packet returns NF_DROP. This is a special case with
TCP packets (added by commit 6b69fe0c73c0 ("netfilter: nf_conntrack_tcp:
fix endless loop") and not related to invalid packets which are
responsible for all the other <=0 returns. So don't increment 'invalid'
ounter in this case.

Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 53401e21ad99..f9b8927327ba 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -2065,9 +2065,10 @@ nf_conntrack_in(struct sk_buff *skb, const struct nf_hook_state *state)
 		if (ret == -NF_REPEAT)
 			goto repeat;
 
-		NF_CT_STAT_INC_ATOMIC(state->net, invalid);
 		if (ret == NF_DROP)
 			NF_CT_STAT_INC_ATOMIC(state->net, drop);
+		else
+			NF_CT_STAT_INC_ATOMIC(state->net, invalid);
 
 		ret = -ret;
 		goto out;
-- 
2.47.3

