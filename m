Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.19
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794985537;
	b=Cz781a3r6A0J8Q7lZPoTRdDPy0NyfuHgHMZFLOJrZVdVUdiu+2LV9sPbdccEa5F4sfhL
	 bzbvrZT5fmYYuDeOvebXU1MeAxNcRLjW9hBU19BKKe4S8VNAV+KxeZ+sRGHz4owV2Jp3W
	 +qAv0UWexJ/NYVWm7yWhhtt3EhPswyrrOzZqD0ly0yT1NK7pEuVcphRzEtMKbluu/fa6p
	 bXEH+8sOFhgWmZUBm056LKhiw0mbG1Xy082cbG3sRzkHd4eKsVj0NLyPcsQEsqjH5qvCO
	 CtKdKJbLA6tjtv8dyiyixc1DFXU0KnsVYrSYqfbEvKlvDTFtEuvjwHIdPHDq0+34U/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794985537;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=mjq3meMdrcgGtZQ1Co1hA6n/sOXNFEBDu4lniMuprQQ=;
	b=a//ksLvTR79RVx7hCrhrFQVscMDFi3KobQK7MmL2hjGEdz6+fAKj3NVX9jl9JljEF67n
	 IdgejKbztwc8sK2HUZ17di5w5RDa7gPC+wT4d4fHauetkU1aUILhxxtZTS3UEKf+tGx+P
	 eYwiYS7c7pnenXu1HDCVXFpfe2Ryfq6PPBneMOKEYIgNTJBQ0Ty8Pv7whQu1qikbD/pjs
	 FdtqrL/C8WOY8YkQq0hwZYAG2K5Wh8GBZfoQdXg9CrpJwrKf1yw+bAEq8rsCMw/ClIVM4
	 4H34FAb3M8RD2QSo1LQBQY5Sg1G6vn7izdSl2A+L3+1Yw2n/5B9Iixjuh7A8iXAmP9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=kQI0m0iY;
	arc=none smtp.remote-ip=91.218.175.19
Received: from mta0.migadu.com (out-19.mta0.migadu.com [91.218.175.19])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02384606A32A
	for <netfilter-devel@vger.kernel.org>; Wed, 18 Nov 2026 07:05:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 02384606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=kQI0m0iY
X-Envelope-To: netfilter-devel@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=ca/pNcctimUgIrRQnFieYRz/dmOQ2n2YtK9gXeLDLIY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794985535; v=1; x=1795590335;
 b=kQI0m0iYqmNqwiAWJCoDFA9gf3bg61VNfOINGKhwKU5jCSucCpn4BL3b/+f2tnrXhYiGKyRK
 c73mohE9I7fbKVTO/bD+nQiV9K4FsSSahm1L9sEMulUrPTxXeiVfELxn/B3keEzCWXWQ/69iUfI
 VCj47Mno0pk9Kr1qNd9hYzt8=
X-Envelope-To: netfilter-devel@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 8ae76fde31622f60;
	Wed, 18 Nov 2026 07:05:33 +0000
X-Mizu-Trace-ID: 8ae76fde31622f60
X-Migadu-Flow: FLOW_OUT
From: Jiayuan Chen <jiayuan.chen@linux.dev>
To: netdev@vger.kernel.org
Cc: Jiayuan Chen <jiayuan.chen@linux.dev>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Alexander Aring <alex.aring@gmail.com>,
	Stefan Schmidt <stefan@datenfreihafen.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	David Ahern <dsahern@kernel.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	linux-kernel@vger.kernel.org,
	linux-wpan@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org
Subject: [PATCH net-next] net: dropreason: add SKB_DROP_REASON_FRAG_MEM_LIMIT
Date: Wed, 18 Nov 2026 15:05:19 +0800
Message-ID: <20261118070524.310356-1-jiayuan.chen@linux.dev>
X-Mailer: git-send-email 2.43.0
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

This is used to track fragments dropped when the reassembly memory is
over the limit (ipfrag_high_thresh, ip6frag_high_thresh).

Fragments dropped because high_thresh is 0 get this reason too, the
same way they are counted in IPSTATS_MIB_REASMFAILS.

Tested with pwru.

Before:

... PROTO  MTU   LEN   FUNC
... 0x0800 65536 1500  ip_defrag
... 0x0800 65536 548   ip_defrag
... 0x0800 65536 548   sk_skb_reason_drop(SKB_DROP_REASON_NOT_SPECIFIED)

After:

... PROTO  MTU   LEN   FUNC
... 0x0800 65536 1500  ip_defrag
... 0x0800 65536 548   ip_defrag
... 0x0800 65536 548   sk_skb_reason_drop(SKB_DROP_REASON_FRAG_MEM_LIMIT)

Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
---
 include/net/dropreason-core.h           |  7 +++++++
 include/net/inet_frag.h                 |  3 ++-
 net/ieee802154/6lowpan/reassembly.c     |  2 +-
 net/ipv4/inet_fragment.c                |  8 ++++++--
 net/ipv4/ip_fragment.c                  | 10 ++++++----
 net/ipv6/netfilter/nf_conntrack_reasm.c |  2 +-
 net/ipv6/reassembly.c                   | 10 ++++++----
 7 files changed, 29 insertions(+), 13 deletions(-)

diff --git a/include/net/dropreason-core.h b/include/net/dropreason-core.h
index 27bc63cbc020f..5b7a758603d90 100644
--- a/include/net/dropreason-core.h
+++ b/include/net/dropreason-core.h
@@ -98,6 +98,7 @@
 	FN(DUP_FRAG)			\
 	FN(FRAG_REASM_TIMEOUT)		\
 	FN(FRAG_TOO_FAR)		\
+	FN(FRAG_MEM_LIMIT)		\
 	FN(TCP_MINTTL)			\
 	FN(IPV6_BAD_EXTHDR)		\
 	FN(IPV6_TOO_MANY_EXTHDRS)	\
@@ -493,6 +494,12 @@ enum skb_drop_reason {
 	 * (/proc/sys/net/ipv4/ipfrag_max_dist)
 	 */
 	SKB_DROP_REASON_FRAG_TOO_FAR,
+	/**
+	 * @SKB_DROP_REASON_FRAG_MEM_LIMIT: reassembly memory is over the limit.
+	 * (/proc/sys/net/ipv4/ipfrag_high_thresh,
+	 * /proc/sys/net/ipv6/ip6frag_high_thresh)
+	 */
+	SKB_DROP_REASON_FRAG_MEM_LIMIT,
 	/**
 	 * @SKB_DROP_REASON_TCP_MINTTL: ipv4 ttl or ipv6 hoplimit below
 	 * the threshold (IP_MINTTL or IPV6_MINHOPCOUNT).
diff --git a/include/net/inet_frag.h b/include/net/inet_frag.h
index c1fb419a9cf03..ea5a5484c65ef 100644
--- a/include/net/inet_frag.h
+++ b/include/net/inet_frag.h
@@ -130,7 +130,8 @@ void fqdir_exit(struct fqdir *fqdir);
 
 void inet_frag_kill(struct inet_frag_queue *q, int *refs);
 void inet_frag_destroy(struct inet_frag_queue *q);
-struct inet_frag_queue *inet_frag_find(struct fqdir *fqdir, void *key);
+struct inet_frag_queue *inet_frag_find(struct fqdir *fqdir, void *key,
+				       enum skb_drop_reason *reason);
 
 void inet_frag_queue_flush(struct inet_frag_queue *q,
 			   enum skb_drop_reason reason);
diff --git a/net/ieee802154/6lowpan/reassembly.c b/net/ieee802154/6lowpan/reassembly.c
index ddb6a5817d098..dcbadb1abb0f4 100644
--- a/net/ieee802154/6lowpan/reassembly.c
+++ b/net/ieee802154/6lowpan/reassembly.c
@@ -76,7 +76,7 @@ fq_find(struct net *net, const struct lowpan_802154_cb *cb,
 	key.src = *src;
 	key.dst = *dst;
 
-	q = inet_frag_find(ieee802154_lowpan->fqdir, &key);
+	q = inet_frag_find(ieee802154_lowpan->fqdir, &key, NULL);
 	if (!q)
 		return NULL;
 
diff --git a/net/ipv4/inet_fragment.c b/net/ipv4/inet_fragment.c
index f330d0a398233..728fa78f56b37 100644
--- a/net/ipv4/inet_fragment.c
+++ b/net/ipv4/inet_fragment.c
@@ -421,14 +421,18 @@ static struct inet_frag_queue *inet_frag_create(struct fqdir *fqdir,
 	return q;
 }
 
-struct inet_frag_queue *inet_frag_find(struct fqdir *fqdir, void *key)
+struct inet_frag_queue *inet_frag_find(struct fqdir *fqdir, void *key,
+				       enum skb_drop_reason *reason)
 {
 	/* This pairs with WRITE_ONCE() in fqdir_pre_exit(). */
 	long high_thresh = READ_ONCE(fqdir->high_thresh);
 	struct inet_frag_queue *fq = NULL, *prev;
 
-	if (!high_thresh || frag_mem_limit(fqdir) > high_thresh)
+	if (!high_thresh || frag_mem_limit(fqdir) > high_thresh) {
+		if (reason)
+			*reason = SKB_DROP_REASON_FRAG_MEM_LIMIT;
 		return NULL;
+	}
 
 	prev = rhashtable_lookup(&fqdir->rhashtable, key, fqdir->f->rhash_params);
 	if (!prev)
diff --git a/net/ipv4/ip_fragment.c b/net/ipv4/ip_fragment.c
index ef7fd61284a3f..7eb40c1041ef9 100644
--- a/net/ipv4/ip_fragment.c
+++ b/net/ipv4/ip_fragment.c
@@ -197,7 +197,8 @@ static void ip_expire(struct timer_list *t)
  * this IP datagram, and create new one, if nothing is found.
  */
 static struct ipq *ip_find(struct net *net, struct iphdr *iph,
-			   u32 user, int vif)
+			   u32 user, int vif,
+			   enum skb_drop_reason *reason)
 {
 	struct frag_v4_compare_key key = {
 		.saddr = iph->saddr,
@@ -209,7 +210,7 @@ static struct ipq *ip_find(struct net *net, struct iphdr *iph,
 	};
 	struct inet_frag_queue *q;
 
-	q = inet_frag_find(net->ipv4.fqdir, &key);
+	q = inet_frag_find(net->ipv4.fqdir, &key, reason);
 	if (!q)
 		return NULL;
 
@@ -475,6 +476,7 @@ int ip_defrag(struct net *net, struct sk_buff *skb, u32 user)
 {
 	struct net_device *dev;
 	struct ipq *qp;
+	SKB_DR(reason);
 	int vif;
 
 	__IP_INC_STATS(net, IPSTATS_MIB_REASMREQDS);
@@ -483,7 +485,7 @@ int ip_defrag(struct net *net, struct sk_buff *skb, u32 user)
 	rcu_read_lock();
 	dev = skb->dev ? : skb_dst_dev_rcu(skb);
 	vif = l3mdev_master_ifindex_rcu(dev);
-	qp = ip_find(net, ip_hdr(skb), user, vif);
+	qp = ip_find(net, ip_hdr(skb), user, vif, &reason);
 	if (qp) {
 		int ret, refs = 0;
 
@@ -499,7 +501,7 @@ int ip_defrag(struct net *net, struct sk_buff *skb, u32 user)
 	rcu_read_unlock();
 
 	__IP_INC_STATS(net, IPSTATS_MIB_REASMFAILS);
-	kfree_skb(skb);
+	kfree_skb_reason(skb, reason);
 	return -ENOMEM;
 }
 EXPORT_SYMBOL(ip_defrag);
diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index f25ff2a12a824..019f6669015d0 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -159,7 +159,7 @@ static struct frag_queue *fq_find(struct net *net, __be32 id, u32 user,
 					    IPV6_ADDR_LINKLOCAL)))
 		key.iif = 0;
 
-	q = inet_frag_find(nf_frag->fqdir, &key);
+	q = inet_frag_find(nf_frag->fqdir, &key, NULL);
 	if (!q)
 		return NULL;
 
diff --git a/net/ipv6/reassembly.c b/net/ipv6/reassembly.c
index 91a65fe673500..649f2e3283656 100644
--- a/net/ipv6/reassembly.c
+++ b/net/ipv6/reassembly.c
@@ -82,7 +82,8 @@ static void ip6_frag_expire(struct timer_list *t)
 }
 
 static struct frag_queue *
-fq_find(struct net *net, __be32 id, const struct ipv6hdr *hdr, int iif)
+fq_find(struct net *net, __be32 id, const struct ipv6hdr *hdr, int iif,
+	enum skb_drop_reason *reason)
 {
 	struct frag_v6_compare_key key = {
 		.id = id,
@@ -97,7 +98,7 @@ fq_find(struct net *net, __be32 id, const struct ipv6hdr *hdr, int iif)
 					    IPV6_ADDR_LINKLOCAL)))
 		key.iif = 0;
 
-	q = inet_frag_find(net->ipv6.fqdir, &key);
+	q = inet_frag_find(net->ipv6.fqdir, &key, reason);
 	if (!q)
 		return NULL;
 
@@ -337,6 +338,7 @@ static int ipv6_frag_rcv(struct sk_buff *skb)
 	struct inet6_dev *idev;
 	struct frag_hdr *fhdr;
 	struct frag_queue *fq;
+	SKB_DR(reason);
 	u8 nexthdr;
 	int iif;
 
@@ -385,7 +387,7 @@ static int ipv6_frag_rcv(struct sk_buff *skb)
 
 	iif = skb->dev ? skb->dev->ifindex : 0;
 	rcu_read_lock();
-	fq = fq_find(net, fhdr->identification, hdr, iif);
+	fq = fq_find(net, fhdr->identification, hdr, iif, &reason);
 	if (fq) {
 		u32 prob_offset = 0;
 		int ret, refs = 0;
@@ -409,7 +411,7 @@ static int ipv6_frag_rcv(struct sk_buff *skb)
 	rcu_read_unlock();
 
 	__IP6_INC_STATS(net, idev, IPSTATS_MIB_REASMFAILS);
-	kfree_skb(skb);
+	kfree_skb_reason(skb, reason);
 	return -1;
 
 fail_hdr:
-- 
2.43.0

