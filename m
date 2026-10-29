Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793295832;
	b=l07SBTUwBpklfJf1qwFTKXJlyZjRQa4MzcjGtMVPGHMKwhIOCTYbNzyTEH/IxAHS7uKB
	 M71hvI83pvVzjBM+auzQgaNV7pvHEkCu4OJLDiiBE+tJQ+qjPxzwQta1O5lgnO5S2DsZu
	 eXBbl/L11Xviv4KPLDDo0t67c+ptoJLn15yf9KOD2LgZH0FyRUJmw1WbAlMPe4zjilJr2
	 Qol2FsORT/CPY2DY5OlQyD30mieK0gPhVISpJUfme6ozt+13PXI9P/+Phds/m5clFLcAh
	 ia7/IxGU/xCWH4e17S2n1FJUHrFqHhjrVtWBpy+y3qy3nL4HPT9dl7inIjEmI0mSbGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793295832;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding:X-Spam-Status:
	 X-Spam-Checker-Version;
	bh=vf2Nx1KhuuTq0v1u2yrwrKh/PW/G//87vc4XY9y63ug=;
	b=dO6PmaAfvhR0s8biyRhtfKxYHtRHy4cINoQ+lRElOoST5R9fmZYBbr53yKk7HwCqEO2N
	 irwSho+8lxkLeCAAM6sN81t9REQ5ZG7nHeDGq9Cl2U2cdRqN2p+W4suf/Ei334VYm8v2M
	 th2NfA9cYMGHK/euMmsSSD0omhdCfTFH5SkcOoSdYLDkcCweIif39Z1cP+elKHMrlLpX5
	 cJX+h5lV3npOgkct1X82ZiiseQFi2gTDOv8lVRYso/N7irbSwXbUA11D2RG2LbSXr4TUk
	 0OcpZ+aDuQE9Op2OuIlTZTIk7PrRufiyNabZ6ixIoxXKAknZGVZPBdDeHuNk/ALyYfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=TXTSsNnk;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41B8A606A31A
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2026 17:43:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 41B8A606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=TXTSsNnk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1793295830;
	bh=vf2Nx1KhuuTq0v1u2yrwrKh/PW/G//87vc4XY9y63ug=;
	h=From:To:Subject:Date:From;
	b=TXTSsNnk2LiTLTiPj25uFSH7xmnn6jfz+RN2n+UtmjS2riaWx+IvwMPq/EkC8Of6y
	 71LkoIqB5ZQrpxYVcdR/5g5+9kmkJLVQK+vTeklcc9X2JzQqzaLl70HjAqxkd4Bghj
	 NKwWStGXnqiCd1WIYOWtr5Wc9t3uoxn7+OUSIb3mVBy1kYtiOhsZwwi02Kx7UJh6bz
	 yNWdagqWCXIhIObDLiMFCrbNhjiGLLiqTX+XNEQgf1ubU8jHj8QiUlmVOwYY+oJLPe
	 b84zFPCaK1wD6PaJd4V+LlXUD17Fjzf7aVb7kQVVQAxxiEd/3pX0j/+P0wb0PsuAKf
	 AgoPrDrDylCAw==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 4CDE76005D
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2026 18:43:50 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v3] netfilter: lwtunnel: expose read-only sysctl nf_hooks_lwtunnel for non init-netns
Date: Thu, 29 Oct 2026 18:43:46 +0100
Message-ID: <20261029174346.232836-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Expose nf_hooks_lwtunnel sysctl with 0444 mode from non init-netns
instead of 0644, sashiko reports this is exposing a global static branch
to modification by unprivileged users.

Fixes: 7a3f5b0de364 ("netfilter: add netfilter hooks to SRv6 data plane")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v3: recover non-const struct ctl_table *dup to address compilation warning.

 net/netfilter/nf_hooks_lwtunnel.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_hooks_lwtunnel.c b/net/netfilter/nf_hooks_lwtunnel.c
index 40c6fce14a63..7e2ee8677f1f 100644
--- a/net/netfilter/nf_hooks_lwtunnel.c
+++ b/net/netfilter/nf_hooks_lwtunnel.c
@@ -68,14 +68,18 @@ static int __net_init nf_lwtunnel_net_init(struct net *net)
 {
 	const struct ctl_table *table;
 	struct ctl_table_header *hdr;
+	struct ctl_table *dup;
 
 	table = nf_lwtunnel_sysctl_table;
 	if (!net_eq(net, &init_net)) {
-		table = kmemdup(nf_lwtunnel_sysctl_table,
-				sizeof(nf_lwtunnel_sysctl_table),
-				GFP_KERNEL_ACCOUNT);
-		if (!table)
+		dup = kmemdup(nf_lwtunnel_sysctl_table,
+			      sizeof(nf_lwtunnel_sysctl_table),
+			      GFP_KERNEL_ACCOUNT);
+		if (!dup)
 			goto err_alloc;
+
+		dup->mode = 0444;
+		table = dup;
 	}
 
 	hdr = register_net_sysctl_sz(net, "net/netfilter", table,
-- 
2.47.3

