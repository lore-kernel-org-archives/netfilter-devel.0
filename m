Received: from sender-op-o17.zoho.eu (sender-op-o17.zoho.eu [136.143.169.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F9F63B42DB
	for <netfilter-devel@vger.kernel.org>; Tue,  7 Jul 2026 19:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.169.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783453947; cv=pass; b=mDLmN/EnPInFapfS8Zdq5mOIO3VZAQBhhucGpGGtObH4wQuFGgF/saLqN5swRVh9Ua3laEbTCyfJi0TaLH86tlwmU2mSohn36NFV1ohVU6H2eKvukDp8iBmOwEO8QIp3hdbRc/qFK3V9GwF4/jHjnHrMT/wS+yzi/5H86l04w8c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783453947; c=relaxed/simple;
	bh=scB7ypqBgqkiRte7mKOkKRltOE07loqucZudwbis/0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=StQIQODGoydRdYMk1afAsNOgfSj1BdT3U8yC/oMc1R4Sxyss64ksOL4mZkoYABEmjik7QDEdv5VK7rCiHOl/MlCvnsMVqmcnyyrkqNwUbCffvXfUusA8GhvNgVUvCCuOXtk1I1Ovi/XhQ+nHRFx0JOrVSVL8F5YbAfbIA7Mfzo8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=carlosgrillet.me; spf=pass smtp.mailfrom=carlosgrillet.me; dkim=pass (1024-bit key) header.d=carlosgrillet.me header.i=carlos@carlosgrillet.me header.b=el5LPWP/; arc=pass smtp.client-ip=136.143.169.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=carlosgrillet.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=carlosgrillet.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=carlosgrillet.me header.i=carlos@carlosgrillet.me header.b="el5LPWP/"
ARC-Seal: i=1; a=rsa-sha256; t=1783453894; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=EeKu6D+XGZEI/eaBBDR+woAtZP81vCFAkGwVKHuorDMnv+XZ7TaPJBwpxG2aq6OzfyOd2AlwCy6G49iBFQl+zij96TMA8fcIJfq1uVdXMrHqmAjGUWQwDoVOcN6wH+4zBNK0Ga2Y8KpybG81D8q3nfrFkPemsSgpxbZjs2L5C9w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1783453894; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=luS/Mu16YvAN7KlUBG+ZtPKjUL/3alwz5jLEoHft+xE=; 
	b=aObuOQTY5H8A2h/48gP6FBkYgOG52fC8P0CZPUaQCZQ+rWtI5irHNGINoRcOKgSHE1O7m3ZK0lV7CNfdfFhIT4y+DaUNK1yoFmkQswuc/WTno0xTEMkgoT3YiXuWigul0rKoUtBkX5n+GBYB2MpXr83jkXB/BDGKtCnmOxF1dCs=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=carlosgrillet.me;
	spf=pass  smtp.mailfrom=carlos@carlosgrillet.me;
	dmarc=pass header.from=<carlos@carlosgrillet.me>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1783453894;
	s=zmail; d=carlosgrillet.me; i=carlos@carlosgrillet.me;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=luS/Mu16YvAN7KlUBG+ZtPKjUL/3alwz5jLEoHft+xE=;
	b=el5LPWP/PykR/z7DHyxDne3jjY9feRPGlWtT6U9HGoJJhNwkUTKUpdlQKewcLP23
	XWC76bCjJAi3hMIjg83Ou66HuYNBfai9auoljKLg93+C04SclBO/uRodRZfZ7BuFqP9
	pvjN5rek00U1n0Hs/9tyfTSWPQLWlqV5CrHFybaQ=
Received: by mx.zoho.eu with SMTPS id 1783453891863504.45466547053843;
	Tue, 7 Jul 2026 21:51:31 +0200 (CEST)
From: Carlos Grillet <carlos@carlosgrillet.me>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>
Cc: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH nf-next 4/4] netfilter: nfnetlink_osf: replace u_int8_t with u8
Date: Tue,  7 Jul 2026 21:51:09 +0200
Message-ID: <20260707195111.34899-5-carlos@carlosgrillet.me>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260707195111.34899-1-carlos@carlosgrillet.me>
References: <20260707195111.34899-1-carlos@carlosgrillet.me>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

Use preferred kernel integer type u8 instead of the POSIX u_int8_t
variant and update the corresponding header definition.

No functional change.

Signed-off-by: Carlos Grillet <carlos@carlosgrillet.me>
---
 include/linux/netfilter/nfnetlink_osf.h | 2 +-
 net/netfilter/nfnetlink_osf.c           | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/netfilter/nfnetlink_osf.h b/include/linux/netfilter/nfnetlink_osf.h
index 788613f36935..d720abf59ca8 100644
--- a/include/linux/netfilter/nfnetlink_osf.h
+++ b/include/linux/netfilter/nfnetlink_osf.h
@@ -26,7 +26,7 @@ struct nf_osf_data {
 	const char *version;
 };
 
-bool nf_osf_match(const struct sk_buff *skb, u_int8_t family,
+bool nf_osf_match(const struct sk_buff *skb, u8 family,
 		  int hooknum, struct net_device *in, struct net_device *out,
 		  const struct nf_osf_info *info, struct net *net,
 		  const struct list_head *nf_osf_fingers);
diff --git a/net/netfilter/nfnetlink_osf.c b/net/netfilter/nfnetlink_osf.c
index 92002079f8ea..88382e2108eb 100644
--- a/net/netfilter/nfnetlink_osf.c
+++ b/net/netfilter/nfnetlink_osf.c
@@ -179,7 +179,7 @@ static const struct tcphdr *nf_osf_hdr_ctx_init(struct nf_osf_hdr_ctx *ctx,
 }
 
 bool
-nf_osf_match(const struct sk_buff *skb, u_int8_t family,
+nf_osf_match(const struct sk_buff *skb, u8 family,
 	     int hooknum, struct net_device *in, struct net_device *out,
 	     const struct nf_osf_info *info, struct net *net,
 	     const struct list_head *nf_osf_fingers)
-- 
2.55.0

