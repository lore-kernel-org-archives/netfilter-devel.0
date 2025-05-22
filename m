Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF06629ACC3;
	Thu, 22 May 2025 16:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747932803; cv=none; b=VoklsL1oQZLJXgWuTMT6UkSU+M49TdUmDorUlPhZxiNNsHeHhcOhzuRQj6ewyHyk/PfzbkOydt5OdkA4vGRrxZj28tSOB/h8oUX5yq5ykARsv0cnsbc/keWLrqSWaaxbYhjfaLS1k768UVxe28ytCV9UjsFpLvlauG6h28jSt7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747932803; c=relaxed/simple;
	bh=CW6EoAO2gf8HRSWmIs9RYh0vZn4bXOh33+j+W0/2nug=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LEYIrVBb/MagO1p4Cb+3+yR3CV0NiruykQgynHB/6b6x4w6R7LI6PEVvU45SjBbtVyVt+Zso9b3tnEBQZsgo5DtLUfQ3hEUsiNJF22fxRYXLV+K5sntKEh741coWFb+ubuDXB2cPiFlWYygwC2PXe5fZQrNuCHVv+PtHxWWKQqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Z4PhENMz; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=bPaisyc1; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Z4PhENMz";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="bPaisyc1"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 589F3606ED; Thu, 22 May 2025 18:53:20 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747932800;
	bh=3hJ1ICFvaiIoo7clLaQ8Yz0R7kbbGHQ1T5gQo5PH7Mo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z4PhENMzUypTQ1nhqDwJq17XBIFOEsERCHAdITD2kytXvfqNrtqFtOmvoHJQ5QER2
	 IGK8fiykAFmrkLzsj6DapCdJa8U1MYXCO2U6LUNWh3bxqDsE4vW0oocD7ZeKgOIIQj
	 dYHlICB1okgEfHbZrSXjXC8d4XG+QuZbuokN62xpfqXJuRnyRdROmmZciiqilr+OgR
	 kKUgCk+HBekj3ZKlsIxVpXqJ7QRuXI0Sp9vFASD8acXd1MHaLmuiGLV7bkBR86tJuG
	 3/anJLS4UGWlvU1dI5f35EPfKuOXIrucg4Y9NypvoLeepbdrTR+bLySpe577PzJTbe
	 a1nw0+57RR2bQ==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 64FBC60734;
	Thu, 22 May 2025 18:52:57 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747932777;
	bh=3hJ1ICFvaiIoo7clLaQ8Yz0R7kbbGHQ1T5gQo5PH7Mo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bPaisyc1MoJ2dYbJZ0xHnDyYmpLy8sP9gIo4PYZp9ylOJ7MTMu2u5j06YUCDv00wi
	 C8oOXygFlYNU/82jJ7UDtfjooIcGNTnTDdpOBjN0lY1BgNe9EBIEMuhPMezuKgpRBN
	 85hLTDPk9GJjsBSXzGxhRAIkw7E8FW7vyGT7EfRnXVKaJIkQhWQu6C9DhFoZO00tZJ
	 GPdRwsMbvbcoHEKQwZe6hhofcKlKFficwZ6qcj1/2tWJ2py2xrt01HY2FLAC+dFy0p
	 b4yDoegjlVe9m7wc2I99l7v0gHsKji0LSzRXQoTEWBbr4B5mLfTUF7DkQCTlKlUR6O
	 i4twzMxopgVnQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 16/26] netfilter: nf_tables: Introduce nft_register_flowtable_ops()
Date: Thu, 22 May 2025 18:52:28 +0200
Message-Id: <20250522165238.378456-17-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250522165238.378456-1-pablo@netfilter.org>
References: <20250522165238.378456-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Phil Sutter <phil@nwl.cc>

Facilitate binding and registering of a flowtable hook via a single
function call.

Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 32 +++++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 11 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index c5b7922ca5bf..a1d705796282 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8929,6 +8929,26 @@ static void nft_unregister_flowtable_net_hooks(struct net *net,
 	__nft_unregister_flowtable_net_hooks(net, flowtable, hook_list, false);
 }
 
+static int nft_register_flowtable_ops(struct net *net,
+				      struct nft_flowtable *flowtable,
+				      struct nf_hook_ops *ops)
+{
+	int err;
+
+	err = flowtable->data.type->setup(&flowtable->data,
+					  ops->dev, FLOW_BLOCK_BIND);
+	if (err < 0)
+		return err;
+
+	err = nf_register_net_hook(net, ops);
+	if (!err)
+		return 0;
+
+	flowtable->data.type->setup(&flowtable->data,
+				    ops->dev, FLOW_BLOCK_UNBIND);
+	return err;
+}
+
 static int nft_register_flowtable_net_hooks(struct net *net,
 					    struct nft_table *table,
 					    struct list_head *hook_list,
@@ -8949,20 +8969,10 @@ static int nft_register_flowtable_net_hooks(struct net *net,
 			}
 		}
 
-		err = flowtable->data.type->setup(&flowtable->data,
-						  hook->ops.dev,
-						  FLOW_BLOCK_BIND);
+		err = nft_register_flowtable_ops(net, flowtable, &hook->ops);
 		if (err < 0)
 			goto err_unregister_net_hooks;
 
-		err = nf_register_net_hook(net, &hook->ops);
-		if (err < 0) {
-			flowtable->data.type->setup(&flowtable->data,
-						    hook->ops.dev,
-						    FLOW_BLOCK_UNBIND);
-			goto err_unregister_net_hooks;
-		}
-
 		i++;
 	}
 
-- 
2.30.2

