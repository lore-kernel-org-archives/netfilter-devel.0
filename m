Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793108060;
	b=ss4l8ZgD5d8cmMjcmE1rYIOHa67jV9O9McZAM5UXYB+MoP5flU6F4PiHCy278tQUarjl
	 g9EImarQ21V9Il0ANzxp6iOVvJ7gqpUOoGV2ZESwpgM9JAw8LYvCg2Us/riyq9z2uL81+
	 O/Tns9+aaX413/24wroi6JJNTaSHv2BWj9UQfUPJjHtwMISwMBzAgmQzJ2lLtLDpvce1M
	 ZMqRzPmbfRn3yD1j3zjZy5GGUh0V+NCboOVaGgp1HYmuvKWCgfR4j7BTmIDpXP9dPH47w
	 PgfW5wlpMhxWbWz7Iepk5Kt4EYKo3vLgtKxk7h9PGchNcxW/OggE86NuK8lDNqSs2BQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793108060;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=bMgbE9X7taIuHSHV7gOUoJzRNchfiUp9puZAZesmraA=;
	b=PGWAxFMMHtXmdRzXaprzH93sXofqrqL8VEcILr0qy1sbDrriKJnt9QoXafm4MpH2JA3Z
	 TCthJG8+zsfocT4O0lQ3bGwU4SLZnWFGMSDRChXaMwWnS/gZwPfQqkUoUl2TMRm6zEBNd
	 PqcVy3OwAJDGCG3bF7qw+5m4SdAaH/SfNpty8DX4L3iznrTMk1wEn7+WBOdv2gwRcdaEm
	 rsA0VL/5dwtHZN8cfGT+/9MsbMoT6L+/mBMPESBXrv17Exehr5rdSkOWl6JzZtI1M31/X
	 lnAdnO0Rglm835T4ys9oAWBfYKWrf9GgCY3Eqnz0jzyekVAI92r3YDqMDar0pOohdNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07513606A31A
	for <netfilter-devel@vger.kernel.org>; Tue, 27 Oct 2026 13:34:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 07513606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 5342160788; Tue, 27 Oct 2026 14:34:18 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nf v6 6/6] netfilter: ipset: also report mem size for cidr storage to userspace
Date: Tue, 27 Oct 2026 14:33:31 +0100
Message-ID: <20261027133331.25979-7-fw@strlen.de>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261027133331.25979-1-fw@strlen.de>
References: <20261027133331.25979-1-fw@strlen.de>
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
index b07757d528dd..32b0104fde15 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -656,6 +656,23 @@ mtype_rht_size(struct ip_set *set, u32 *elements, size_t *ext_size)
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
 
 static int mtype_remove_cmpfn(struct rhashtable_compare_arg *arg, const void *obj)
-- 
2.55.0

