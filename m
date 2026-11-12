Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794443634;
	b=akSMxgiFfaBgFx/zTVEL/hDjj8vL+XSMmQsl/W6ROhvtpMrdf+rs7RW88Dotdv04axKo
	 kTZZFWZrWwDAmSbS/dtdeSmuCs6ojg57JrzQNIFCEh15s6/3LlGcypgIO/QRMNuJN+zVd
	 IzRFzlTuzc6FQOuZGEivawfRqBXKLkyNEZmx9WUjOMhyrGSfm1TzTHvbshm6N6F7eCfm6
	 TJNja8EDAo7L5iUhmY3Oga2QqprhNOWw2GiD2kNpydWG/wRTRW1GuYjKoOf+kfjpZ+hk0
	 6DNjNCh4huZy/b91qtX77lDtMkBa8WhtUdEqSUGLJRbxJjLhLsGd7Q/Sf2+Nvywg/8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794443634;
	h=DMARC-Filter:Received:From:To:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=DXqXnVSN4CBoLjib7+jU1cM2byq2M4QP+k7HTZ68aNI=;
	b=EYDZATDYD8zT/t7gAwbp1o7AjaMnnsNIGv9I1B5+xM8jHessRsND4PmBiJHCCp4WzO5D
	 yu56h3GsSuSKBW/uu6jbSVvmbVmtg4FEDnqXBbADzSUiW9Z6+bL1JexdqFKFKEStjNJBq
	 4AFLjipu24CEV90Oy2Y/ycoeixNgyref0dUxCckAqEIAOQSnQKM2G8dWJMF5EjsPhG+n6
	 JZazPM+JZ6Oe4smAsPUzQWQsMMOsgrACac7eti7+Fq90Gft5zEp4Sy6bS0OaF8gIVmUd7
	 WsMx+KFC2yagRRqciufVs7meIY0NtNBq/EL7VLXS8D1sX86aeO44s0cdLBAuEYlo2tQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3550B606A31C
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Nov 2026 00:33:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3550B606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id A62476032F; Thu, 12 Nov 2026 01:33:52 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next v9 4/6] netfilter: ipset: also report mem size for cidr storage to userspace
Date: Thu, 12 Nov 2026 01:33:29 +0100
Message-ID: <20261112003331.16894-5-fw@strlen.de>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261112003331.16894-1-fw@strlen.de>
References: <20261112003331.16894-1-fw@strlen.de>
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
 no changes.
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

