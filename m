Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793979519;
	b=UnervCNifCzEzx0ET8NR/DJUih+0jL7Xrb4l7mq1JWLo+ScghRZkoSGX/aVtUVBbCYng
	 IzDZ4A/BcTX/1sAxH4Wu0nl6UdlHddmYesNsgbhv2/9OXk7WTHB4yg+C6oBBXFhqfw/Gr
	 ZdICOwTovzH3s2S/qQxwwswnuN6xzcwpEsDiawBQgdIj4/tj5uJZEjaZQWR+VGOYNtk9y
	 1et9K2qDjbmxDKFC1Ii9vY0ErdnZjn/17E0Wk1Czz2wO+jn3K91iK5F2QvA6j7KDLxSTU
	 fyWgXRiWqtTSCSJ+Aqq3ym4a7eH7Ph2ehw1hJnrEYof8yVhoqgoF5HbvbflSeZXGx5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793979519;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=OXsjAKmz1v/RRiP25j867uzCycXUmvhTMCbBXl/Bk20=;
	b=fqZ3LZCMMEb2VVs9mdZ1W6d/1tNTdHwoSob/Gs7RQ9X+3cUMObh4hsuUCQZrLgdfnULY
	 envblyczInoZTLZNXTmNtR7dSzgDW/ROrsTICBqNmOVOKy7WbMUHJTWCB2dCdOWDJXKTj
	 N5teNyVD2dG31o/7FabKYkf/Xs5HEc1TMze4jyxN+bslvSf98rPassU51XAs1R4CV+N15
	 vjWWcl5JjuYeTt9S2eSXAgnug9yR2v6Sm/symXxLxWj9wnt5vvG/JQrD+p83X/XwPJcSa
	 cKcZR00EXrZ18YpPAEGHAscGSl3+fVT9vYPD6qNoIJK/tXVMOtiMKne9tmfP8WzsjQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90509606A329
	for <netfilter-devel@vger.kernel.org>; Fri,  6 Nov 2026 15:38:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 90509606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 9A1576060B; Fri, 06 Nov 2026 16:38:36 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: herbert@gondor.apana.org.au,
	kadlec@netfilter.org,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v7 4/6] netfilter: ipset: also report mem size for cidr storage to userspace
Date: Fri,  6 Nov 2026 16:38:06 +0100
Message-ID: <20261106153808.25148-5-fw@strlen.de>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261106153808.25148-1-fw@strlen.de>
References: <20261106153808.25148-1-fw@strlen.de>
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
 No changes in v7.
 net/netfilter/ipset/ip_set_hash_gen.h | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 3d8d1046d1b8..32dd333fe790 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -614,6 +614,23 @@ mtype_rht_size(struct ip_set *set, u32 *elements, size_t *ext_size)
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
2.56.0

