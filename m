Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=57.103.64.117
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794916441;
	b=FGSTJahGmHs4JaYOHpzezD+zQWtPBzpRwlGpinBjS3rR/bEGnPre2CGaDlI/hEL5Urz+
	 FmZ2rJNOu1BJX8rFX/My8scwmkHfXu5FSsiQYleqWpEwwjg+H2ymeL1NaFRlJwXnuuz8P
	 Q/dkDgKDZvLqnDjtg3+bc/OXDlGviqkj6iTF+IZ4R1IpALURo3+Uw1xIpogpwJBmPB0gS
	 nJiMZu+JZRfHzzn84fqyU8IdkJecJ35IDGmCnJv1HP1Gi0AFNkYPdseMCmJGSlPwjrdXb
	 FbyLa1Xs7C91aeZL4Xre0QOz7/yxq9SFFElhxgW+5qUPQpMd+xoZ0JGcUdRx1KhFl9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794916441;
	h=DMARC-Filter:Received:X-ICL-RepId:Dkim-Signature:
	 mail-alias-created-date:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Proofpoint-ORIG-GUID:X-Authority-Info-Out:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Details-Enc:X-JNJ;
	bh=2twkXYHjF0/8A77eNfNjhV5mOhxXr6xgBT1MH1j2qYM=;
	b=YLcff1I1Abm7K7TCvMYIfMfnEhkEzJjsXdEukRR6AiayayU8oEaGH6TLLZuaFSiXiWkK
	 Qs9e2N2M9WJcI0GwsGOp2ik0H9AqopeQ33VYIKIeAS6xrvJo9lt0eon83zG5kCuboOMYM
	 xiRKEiVEfGX2PZ9KuHZDqRQXWNZ7R7Fiz1mM8r4hq3qa5arDd66XjnUmdcS60cQvbokkN
	 TO/WAT2KtrD1pFSBaaW4a2vLDO47eMciiFznoh6sPUkzpXyh/OOXzWtZ+JbWkj5C79mhT
	 kZ51qjQFKgHX1a57DKdqoHWQytAlDn7YZHBUdx1/BmGub9HeQ/EDi0jdo7YjtjY55Gw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=verdict.gg;
	spf=pass smtp.mailfrom=verdict.gg;
	dkim=pass header.d=verdict.gg header.i=@verdict.gg header.a=rsa-sha256 header.s=sig1 header.b=ndcp1J5x;
	arc=none smtp.remote-ip=57.103.64.117
Received: from outbound.pv.icloud.com (pv-2001d-snip4-4.eps.apple.com [57.103.64.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECF4F606A334
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Nov 2026 11:53:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ECF4F606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=verdict.gg
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=verdict.gg
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=verdict.gg header.i=@verdict.gg header.a=rsa-sha256 header.s=sig1 header.b=ndcp1J5x
Received: from outbound.pv.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-west-1a-20-percent-1 (Postfix) with ESMTPS id 0FA5B18005A8;
	Tue, 17 Nov 2026 11:53:55 +0000 (UTC)
X-ICL-RepId: 01a1e95b-47fe-75a1-aaf2-09e0ba1f92cc
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verdict.gg; s=sig1; t=1794916439; x=1826452439; bh=2twkXYHjF0/8A77eNfNjhV5mOhxXr6xgBT1MH1j2qYM=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=ndcp1J5x0stHpyrYYmhh1r9GBuX8+7s3pPjGH7KzAod0YJk0In3nR4Q6K+m5rL47TTEe9mdv8NMFn14IFai28oH0v/MA6ZOXWbf2J8OjqVbLwEfgkxP4z7eDHN//zYmZiCVXdZM33IcmlNqOZwbLKOgB9O+/euFp7lGnAQz8MGrYnCtqmQuqREZiaEX0XeqZq61Y0LiPEroDHY7VX/nB/pQFAUUO1Tx3WxsUcaOvTlruTPjPBH/BKfh7lcPc4QBBzmtuvXptbOcvKMbd3udOY+Pjzbfdb9C+7aJOSElwCYQ0X4ZjZcuepbAVJcFy5nU7/J8Lt4Cu+OOxwxjc2tv/4Q==
mail-alias-created-date: 1621344842221
Received: from DelNac.mail.msk (unknown [17.156.192.29])
	by p00-icloudmta-asmtp-us-west-1a-20-percent-1 (Postfix) with ESMTPSA id 43C3F180014F;
	Tue, 17 Nov 2026 11:53:51 +0000 (UTC)
From: Vladimir Vdovin <deliran@verdict.gg>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Aaron Conole <aconole@redhat.com>,
	Eelco Chaudron <echaudro@redhat.com>,
	Ilya Maximets <i.maximets@ovn.org>
Cc: Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dev@openvswitch.org,
	linux-hardening@vger.kernel.org,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Vladimir Vdovin <deliran@verdict.gg>
Subject: [PATCH nf-next v1 3/5] netfilter: nf_conncount: size the number of slots from the cpu count
Date: Tue, 17 Nov 2026 14:53:06 +0300
Message-ID: <20261117115308.95134-4-deliran@verdict.gg>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261117115308.95134-1-deliran@verdict.gg>
References: <20261117115308.95134-1-deliran@verdict.gg>
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
X-Proofpoint-ORIG-GUID: rCAXIVkkF_cc1loMeC_C3WXRKh43SzxK
X-Authority-Info-Out: v=2.4 cv=Cv+ys34D c=1 sm=1 tr=0 ts=6afc4055
 cx=c_apl:c_pps:t_out a=aW9mcIavGNWWFvFFKOxBSA==:117
 a=aW9mcIavGNWWFvFFKOxBSA==:17 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=sVoYjay53MzFMQOSY88A:9
X-Proofpoint-GUID: rCAXIVkkF_cc1loMeC_C3WXRKh43SzxK
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE3MDA0NyBTYWx0ZWRfX4mBNNxI3vFUL
 B1xermQ4KgMQOej7haWShFJTvKYxkMq0ez1HouTXCONW9difsn2aCWtr++9DVkPnIsMXdU2dkxh
 Wkj13vJMNirjiMHdgj9KaQN/8OEa4In340C5ZPbGEc72BlQRZWGQlcEU67AdUYNk5iw9a2g7ouo
 mB6JU9gTvoIeWepDZLhvnvfkYMgjwOjM/LOItAOvSdiWGezomAtAB9QZDdYSFKkmz2XclPc2cPT
 vJAYY9RxIf9sPwBAK9Cp87JGkP6jKDti+GO4UzK0SYe3jDjNEdP2LghZwOdbSXBSvgd8d6wGpHY
 8+dSdQBJLLhpB5VScp0c6VukoD54C6wFmDri0xU2tg6GDTC2VO2kJfciSk4XYo=
X-JNJ: AAAAAAABHfEnCad7cckNCojQUZnEkegM2FjSQ0NzN6FyQfG8rW1E4wKaGS7xTmIvZYZWjM
 C2KHMf0W9XimiX2/czzw7nxlvHv/W0L1cuyJcZhaHIEM0Cp51O/8IZNMScHcbzR5doALpr
 z8PvsacfQXC0KAHBjHCcDJLK6V9WqHJ9ksk290cLCcVekTfxtfZV+PKTukx2Td1FUXZdM/
 x5I9hDCtRTX1JylkpccJ0BIHDzD3BW2Eaxkk8Ys7wntq0GIQN8Thwekxo5xbqY9qtIin2z
 aRC9XTZV70rc5oADZ7qZYaFaMbQC/ih2/OQQmO4oB0pc5q682rmrnVop+P11nXCsTFaRYM
 CdcAJaBjpJAcO5L63delXMFiqr/QvPNuijYBjpDNCd2iN7onWtHQe3X85W/IKgwoD7lScS
 T/uiPR7kyiUc4nIbjfwCRGgMx5zRyz/p7m3KMT3oKpj91lJOr46JSRBBp8Frisor0td4or
 Dz1O5ONpLBHtUahJfga7X7PadUGe2KthLi3N7YU3V8P79SDxfemEp3+GhWv+9BQDeVylqY
 afMoV0k54MJYHYX45iVftfJKaZxUVThbDTVY/Mr9tJWzQudZ2ge7VXvI1aO7KBIJW7vXpO
 tJCmiMK/vgxEQCLqgFwBMMJG3Z2N0Hj+crzxJ/s+ARk6kTGu5erpkPFLukXG6alA+dbYNE
 jbu+JVJL8a/JJBnUjaL0OTBUBYvYtLR9M+ilefLspaMUMHYXcSZT8P/p2Js1Nb2vEypCi8
 F3zkB5qRkLpyLihG6m/CxYeKaA8E49qYLNkQ75EFmGzrcLW/xEZC9xATKAeXSIvdNYr3+1
 KSuXxWzolzHGW9kEnj9DOMyvNiZm55MLm41YxkjoAv1iPwsPMYKgNJ1zRd+7e/InRSB47u
 qUY4Dpo3qlgNM8T14NezYWGh+JcAH959BvG7zdY3/tENNc6wSbJJH3wpy4

Every key space is spread over CONNCOUNT_SLOTS rb-trees, each with its
own lock, so that cpus inserting or reaping different keys do not
serialize on one another. The number has been 256 since 2014, when
that was comfortably above the cpu count of anything running this
code. With 128 or more rx cpus two of them needing the same slot lock
at once is no longer rare, and the array also bounds how many trees
the gc worker can walk independently.

Size it at module init from the number of possible cpus, 16 slots per
cpu rounded up to a power of two, between the historical 256 and 8192.
A small system keeps exactly what it had; a 160 cpu one gets 4096
slots. Possible rather than online cpus: the array is allocated once,
and cpus that come online later still need their share of slots. The
array becomes a flexible array member allocated with struct_size(),
and the pending tree bitmap goes with it.

Suggested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Vladimir Vdovin <deliran@verdict.gg>
---
 net/netfilter/nf_conncount.c | 48 ++++++++++++++++++++++++++----------
 1 file changed, 35 insertions(+), 13 deletions(-)

diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
index be9e395e25b6..7a4b00c2bc65 100644
--- a/net/netfilter/nf_conncount.c
+++ b/net/netfilter/nf_conncount.c
@@ -32,7 +32,11 @@
 #include <net/netfilter/nf_conntrack_tuple.h>
 #include <net/netfilter/nf_conntrack_zones.h>
 
-#define CONNCOUNT_SLOTS		256U
+/* Number of rb-trees (and locks) a key space is spread over. Sized from
+ * the number of possible cpus at module init, see nf_conncount_modinit().
+ */
+#define CONNCOUNT_SLOTS_MIN		256U
+#define CONNCOUNT_SLOTS_MAX		8192U
 
 #define CONNCOUNT_GC_MAX_NODES		8
 #define CONNCOUNT_GC_MAX_COLLECT	64
@@ -65,13 +69,15 @@ struct nf_conncount_root {
 struct nf_conncount_data {
 	unsigned int keylen;
 	u32 initval;
-	struct nf_conncount_root root[CONNCOUNT_SLOTS];
 	struct net *net;
 	struct work_struct gc_work;
-	unsigned long pending_trees[BITS_TO_LONGS(CONNCOUNT_SLOTS)];
+	unsigned long *pending_trees;
 	unsigned int gc_tree;
+	unsigned int nr_slots;
+	struct nf_conncount_root root[] __counted_by(nr_slots);
 };
 
+static unsigned int conncount_slots __read_mostly;
 static struct kmem_cache *conncount_rb_cachep __read_mostly;
 static struct kmem_cache *conncount_conn_cachep __read_mostly;
 
@@ -574,7 +580,7 @@ count_tree(struct net *net,
 	unsigned int hash;
 	int ret;
 
-	hash = jhash2(key, data->keylen, data->initval) % CONNCOUNT_SLOTS;
+	hash = jhash2(key, data->keylen, data->initval) & (data->nr_slots - 1);
 	root = &data->root[hash];
 
 	rbconn = find_tree_node(root, data, key);
@@ -634,9 +640,9 @@ static void tree_gc_worker(struct work_struct *work)
 	struct rb_node *node;
 
 	if (data->gc_tree == 0)
-		data->gc_tree = find_first_bit(data->pending_trees, CONNCOUNT_SLOTS);
+		data->gc_tree = find_first_bit(data->pending_trees, data->nr_slots);
 
-	tree = data->gc_tree % CONNCOUNT_SLOTS;
+	tree = data->gc_tree & (data->nr_slots - 1);
 	root = &data->root[tree];
 
 	spin_lock_bh(&root->lock);
@@ -679,10 +685,10 @@ static void tree_gc_worker(struct work_struct *work)
 	tree_nodes_free(root, gc_nodes, gc_count);
 	clear_bit(tree, data->pending_trees);
 
-	next_tree = (tree + 1) % CONNCOUNT_SLOTS;
-	next_tree = find_next_bit(data->pending_trees, CONNCOUNT_SLOTS, next_tree);
+	next_tree = (tree + 1) & (data->nr_slots - 1);
+	next_tree = find_next_bit(data->pending_trees, data->nr_slots, next_tree);
 
-	if (next_tree < CONNCOUNT_SLOTS) {
+	if (next_tree < data->nr_slots) {
 		data->gc_tree = next_tree;
 		schedule_work(work);
 	} else {
@@ -717,18 +723,26 @@ static void nf_conncount_root_init(struct nf_conncount_root *r)
 struct nf_conncount_data *nf_conncount_init(struct net *net, unsigned int keylen)
 {
 	struct nf_conncount_data *data;
-	int i;
+	unsigned int i;
 
 	if (keylen % sizeof(u32) ||
 	    keylen / sizeof(u32) > MAX_KEYLEN ||
 	    keylen == 0)
 		return ERR_PTR(-EINVAL);
 
-	data = kvzalloc_obj(*data, GFP_KERNEL_ACCOUNT);
+	data = kvzalloc(struct_size(data, root, conncount_slots),
+			GFP_KERNEL_ACCOUNT);
 	if (!data)
 		return ERR_PTR(-ENOMEM);
 
-	for (i = 0; i < ARRAY_SIZE(data->root); ++i)
+	data->nr_slots = conncount_slots;
+	data->pending_trees = bitmap_zalloc(data->nr_slots, GFP_KERNEL_ACCOUNT);
+	if (!data->pending_trees) {
+		kvfree(data);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	for (i = 0; i < data->nr_slots; ++i)
 		nf_conncount_root_init(&data->root[i]);
 
 	data->keylen = keylen / sizeof(u32);
@@ -771,15 +785,23 @@ void nf_conncount_destroy(struct net *net, struct nf_conncount_data *data)
 
 	disable_work_sync(&data->gc_work);
 
-	for (i = 0; i < ARRAY_SIZE(data->root); ++i)
+	for (i = 0; i < data->nr_slots; ++i)
 		destroy_tree(&data->root[i]);
 
+	bitmap_free(data->pending_trees);
 	kvfree(data);
 }
 EXPORT_SYMBOL_GPL(nf_conncount_destroy);
 
 static int __init nf_conncount_modinit(void)
 {
+	/* Each slot has its own lock, so give the cpus that can be in
+	 * insert_tree() or the gc worker at the same time enough of them to
+	 * rarely collide, while a small system keeps the historical 256.
+	 */
+	conncount_slots = clamp(roundup_pow_of_two(num_possible_cpus() * 16),
+				CONNCOUNT_SLOTS_MIN, CONNCOUNT_SLOTS_MAX);
+
 	conncount_conn_cachep = KMEM_CACHE(nf_conncount_tuple, 0);
 	if (!conncount_conn_cachep)
 		return -ENOMEM;
-- 
2.56.0

