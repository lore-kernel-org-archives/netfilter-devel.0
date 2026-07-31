Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55CC343BDD4;
	Fri, 31 Jul 2026 15:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785511106; cv=none; b=LCWKWMIwInQvzMF7CypekcF1lL+xAtsr77Mf2REmhz6Z5/zfp0Aobt8HTVieIhsmU9poOQAqdVhDqKqd35N8kxmH37+vsfC0IXV4PEmhDxgAmPOkGdr9R/ikC//UU8cu+cAlqJeLmTY9PobkYsUq/h5Rq8yWLq4ARp0Ui/LKHYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785511106; c=relaxed/simple;
	bh=ZNJnYNqyvUerq+gVCFRq7uAAW/3x4veEbQrWne62cFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E0ZB2MQ8vCaAaLbZ0vIulDveVH/0ho+o52PEWguj78N8KzHdqZazBRP1lpdgzq0+vZQeGUjbPoLI5GRY7YPa8PP9tSSpFT6N9otPsBbzghgebyrRBI7IN1gr/Qv4j8ZGoG6UJVxqD/VvoQd5KDcSEb7THTaSpUnEDAxAzgrryio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=FcGOX3ck; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="FcGOX3ck"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 1FD436028B;
	Fri, 31 Jul 2026 17:18:20 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1785511100;
	bh=eJipNObVTmBrykg+VQzBtDlUT90s+n/z82mgMH9TE8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FcGOX3ckiWHKSxkXuHXW6B2SnTFI04g6eKwhtvLlg2aeGB2I9cBusSvB8WbXe0ly6
	 f+P4taHPJByiZkOAtoF0Ow0qfap4mY1fLGeXHD/pkzwoFg1BwrkJ/XmXCYUzGiNmVh
	 YKg71DgLkhmcY9aZD5NgSobZHIgTYTA66y/pAfItA7EYKeTwcv6DJG/1UvZNNsNArC
	 6J+A3YjCu2WBH9+UUDXh+fwQkW3AxwklqF3nzoKrKF7Sln9kJWj31O/0FT3wDyE6JV
	 pXT6HhPVaVfwTxRZ1aCvmLTEMmIel5cbfOvYm8xp2mLt2PGRJwpgUOqsTCu7UjlOcc
	 1D0jlz/A2TbtA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 06/10] netfilter: ipset: add and use mtype_del_cidr_all helper
Date: Fri, 31 Jul 2026 17:18:02 +0200
Message-ID: <20260731151806.849724-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260731151806.849724-1-pablo@netfilter.org>
References: <20260731151806.849724-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

Reduces size of upcoming rhashtable conversion.

Assisted-by: Claude:claude-sonnet-4-6
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 34 +++++++++++++--------------
 1 file changed, 16 insertions(+), 18 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index ef586b486f51..f00c82acd7f0 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -195,6 +195,7 @@ static const union nf_inet_addr zeromask = {};
 #undef mtype_ext_cleanup
 #undef mtype_add_cidr
 #undef mtype_del_cidr
+#undef mtype_del_cidr_all
 #undef mtype_ahash_memsize
 #undef mtype_flush
 #undef mtype_destroy
@@ -242,6 +243,7 @@ static const union nf_inet_addr zeromask = {};
 #define mtype_ext_cleanup	IPSET_TOKEN(MTYPE, _ext_cleanup)
 #define mtype_add_cidr		IPSET_TOKEN(MTYPE, _add_cidr)
 #define mtype_del_cidr		IPSET_TOKEN(MTYPE, _del_cidr)
+#define mtype_del_cidr_all	IPSET_TOKEN(MTYPE, _del_cidr_all)
 #define mtype_ahash_memsize	IPSET_TOKEN(MTYPE, _ahash_memsize)
 #define mtype_flush		IPSET_TOKEN(MTYPE, _flush)
 #define mtype_destroy		IPSET_TOKEN(MTYPE, _destroy)
@@ -410,6 +412,17 @@ mtype_del_cidr(struct ip_set *set, struct htype *h, u8 cidr, u8 n)
 }
 #endif
 
+static void
+mtype_del_cidr_all(struct ip_set *set, struct htype *h, const struct mtype_elem *data)
+{
+#ifdef IP_SET_HASH_WITH_NETS
+	int k;
+
+	for (k = 0; k < IPSET_NET_COUNT; k++)
+		mtype_del_cidr(set, h, DCIDR_GET(data->cidr, k), k);
+#endif
+}
+
 /* Calculate the actual memory size of the set data */
 static size_t
 mtype_ahash_memsize(const struct htype *h, const struct htable *t)
@@ -551,9 +564,6 @@ mtype_gc_do(struct ip_set *set, struct htype *h, struct htable *t, u32 r)
 	struct mtype_elem *data;
 	u32 i, j, d;
 	size_t dsize = set->dsize;
-#ifdef IP_SET_HASH_WITH_NETS
-	u8 k;
-#endif
 	u8 pos, htable_bits = t->htable_bits;
 
 	spin_lock_bh(&t->hregion[r].lock);
@@ -574,11 +584,7 @@ mtype_gc_do(struct ip_set *set, struct htype *h, struct htable *t, u32 r)
 			pr_debug("expired %u/%u\n", i, j);
 			clear_bit(j, n->used);
 			smp_mb__after_atomic();
-#ifdef IP_SET_HASH_WITH_NETS
-			for (k = 0; k < IPSET_NET_COUNT; k++)
-				mtype_del_cidr(set, h,
-					DCIDR_GET(data->cidr, k), k);
-#endif
+			mtype_del_cidr_all(set, h, data);
 			t->hregion[r].elements--;
 			ip_set_ext_destroy(set, data);
 			d++;
@@ -1004,11 +1010,7 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 			j = 0;
 		data = ahash_data(n, j, set->dsize);
 		if (!deleted) {
-#ifdef IP_SET_HASH_WITH_NETS
-			for (i = 0; i < IPSET_NET_COUNT; i++)
-				mtype_del_cidr(set, h,
-					DCIDR_GET(data->cidr, i), i);
-#endif
+			mtype_del_cidr_all(set, h, data);
 			ip_set_ext_destroy(set, data);
 			t->hregion[r].elements--;
 		}
@@ -1163,11 +1165,7 @@ mtype_del(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 		if (i + 1 == pos)
 			smp_store_release(&n->pos, --pos);
 		t->hregion[r].elements--;
-#ifdef IP_SET_HASH_WITH_NETS
-		for (j = 0; j < IPSET_NET_COUNT; j++)
-			mtype_del_cidr(set, h,
-				DCIDR_GET(d->cidr, j), j);
-#endif
+		mtype_del_cidr_all(set, h, d);
 		ip_set_ext_destroy(set, data);
 
 		if (t->resizing && ext && ext->target) {
-- 
2.47.3

