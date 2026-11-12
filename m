Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794494324;
	b=shXkazbl+mXvVtdprJN/Lby3yRNvSrQJ9VPMddkad1auPxuQyBwRCyGhbEvIurpdnfGc
	 ONQm9EPpInukuO6o0DoPeqmebUKnhLFyBIdz0ai5VGDhQWelCuYjzqvyq0fJ2CkIx29Gk
	 XTwgfnN/m73CJWwftXBGpBhQRo/Dvvcc0c/HU6waREYeJqtFtJE1JU3FvgaJ7AtkjLRMP
	 jX4Rrq2zgtdJ+ryCEiLVaGJmVV+VT/DzPcbELYHCyGe0Ij1HHrdxrYeNmGTg8lmvV4W6s
	 fhszf+u2iulJwyQppqHdptcESsbSpvvbaCQaKZDnRbEC12Xw6ODGxCH3DHS70PhOsSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794494324;
	h=DMARC-Filter:Received:From:To:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=8PVmKAp5ETp+y/OFerOcqAaFz9lhtFE8SzBw9QE3F/c=;
	b=VSleKZCyYkumql4JElcotgQSOsAVMxTFhugTcsa/7fKdLvinuiBsfVWjnBVGcjFnmE1h
	 wN3KYB5bSYhqjtToDOEtSGFa7wZZK8kDhg4m6uvpDPjr3FG9VdUwaHZ/87w2bZ2u8NgeU
	 +nYVIejRJjFNJTd2KT5iDjfm4yN5nfGaPIVF2SA3XPhg1DmhyOJNHuBEfKKsKaoIxKv7H
	 66DZ5vyyye4e8FECUGpjgpaab8rCSy2ynfKodJdNfYkgoF8I+jw1CY+jpZcSGns6gOTIE
	 u3inb+xEeEe10UAtvr0RX3JhmJK6cZ41tt3wpppaO8Ag1ge5GOK0rcFXdgsVa8v3rsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA85E606A8A6
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Nov 2026 14:38:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DA85E606A8A6
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 539676028B; Thu, 12 Nov 2026 15:38:42 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next v10 4/6] netfilter: ipset: also report mem size for cidr storage to userspace
Date: Thu, 12 Nov 2026 15:38:16 +0100
Message-ID: <20261112143818.30638-5-fw@strlen.de>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261112143818.30638-1-fw@strlen.de>
References: <20261112143818.30638-1-fw@strlen.de>
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

After the 'Fixes' commit, the storage is allocated dynamically.
Include this when reporting the mem usage.

Fixes: 8e5fd2a55e24 ("netfilter: ipset: rework cidr bookkeeping")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 8ac1b0f04856..e7f2e584a7a5 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -616,6 +616,23 @@ mtype_rht_size(struct ip_set *set, u32 *elements, size_t *ext_size)
 	*elements = ipset_hash_nelems(h);
 	*ext_size = *elements *
 		    (offsetof(struct mtype_rht_elem, elem) + set->dsize);
+
+#ifdef IP_SET_HASH_WITH_NETS
+	{
+		const struct net_prefixes *nets;
+		int i;
+
+		rcu_read_lock();
+
+		for (i = 0; i < IPSET_NET_COUNT; i++) {
+			nets = rcu_dereference(h->rnets[i]);
+			if (nets)
+				*ext_size += ksize(nets);
+		}
+
+		rcu_read_unlock();
+	}
+#endif
 }
 
 /**
-- 
2.56.1

