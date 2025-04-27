Received: from out30-87.freemail.mail.aliyun.com (out30-87.freemail.mail.aliyun.com [115.124.30.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A4783BB48;
	Sun, 27 Apr 2025 06:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745734635; cv=none; b=glqK/NYo+g3MvJsGnMOaa9gTVzIkPo2Lb8D2wkNNvkxP/20Qs7RhKNV3cOMmOmu8HKmvivVt2jZraknlhoIjxlmzcjgYoZd9tfbDQ23/uJxWiz+HR2F1KSBnoPEpdOyEPSuTqzrDh92hKft/FU+WwePyuBMUz1WCU5td/2y6qOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745734635; c=relaxed/simple;
	bh=gbSMFJmbFCs8UxyB41r2trmHJs9hJWBd2mtskWj+NY8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=obzJ66VcUHM3ZfgP/1S+4aJZvU6F+oLUhdStTPrEKVm6/5I8uEQ9qyC8G2SUqbAuYfWUeY7Xq/t1fda4uVWIWcxGBp8gYX3yptwrMtTK+MokjsJuyjci3/eMd0f6ghTktHZJfE6M01PuMbQDZmXrCa9oOyowq7KnZl6nRdEbehw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=aliyun.com; spf=pass smtp.mailfrom=aliyun.com; dkim=pass (1024-bit key) header.d=aliyun.com header.i=@aliyun.com header.b=QnrpRDGZ; arc=none smtp.client-ip=115.124.30.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=aliyun.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aliyun.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=aliyun.com header.i=@aliyun.com header.b="QnrpRDGZ"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=aliyun.com; s=s1024;
	t=1745734629; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=ewz3YKdZUxD2ycD/PcdBcvNZjRxN+t3Ej5aU5o05fNA=;
	b=QnrpRDGZQqWjjoFLrtI+kT+7ENmGwYztLudweAVDfSfGtLLHiqbZDJ+XqSJCqz/Tpjd7yJ6pJqpUQUOFw1LkJ/i/t9Ry74LBVtLwgRUXLOegyIh3tHfYYtOedQafFm0OT1LpCNHaBlIjxZEA+Ds27UJ4y+zh0B+e1KttfNkzhEU=
Received: from wdhh6.sugon.cn(mailfrom:wdhh6@aliyun.com fp:SMTPD_---0WY7wnYI_1745734628 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sun, 27 Apr 2025 14:17:09 +0800
From: Chaohai Chen <wdhh6@aliyun.com>
To: davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	steffen.klassert@secunet.com,
	herbert@gondor.apana.org.au,
	paul@paul-moore.com,
	pablo@netfilter.org,
	kadlec@netfilter.org,
	netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	Chaohai Chen <wdhh6@aliyun.com>
Subject: [PATCH] net:ipv4: Use shift left 2 to calculate the length of the IPv4 header.
Date: Sun, 27 Apr 2025 14:17:06 +0800
Message-Id: <20250427061706.391920-1-wdhh6@aliyun.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Encapsulate the IPV4_HEADER_LEN macro and use shift left 2 to calculate
the length of the IPv4 header instead of multiplying 4 everywhere.

Signed-off-by: Chaohai Chen <wdhh6@aliyun.com>
---
 include/net/ip.h                    | 2 ++
 net/ipv4/ah4.c                      | 8 ++++----
 net/ipv4/cipso_ipv4.c               | 4 ++--
 net/ipv4/ip_input.c                 | 8 ++++----
 net/ipv4/netfilter/nf_reject_ipv4.c | 4 ++--
 5 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/include/net/ip.h b/include/net/ip.h
index ba7b43447775..0fa172d73a52 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -38,6 +38,8 @@
 #define IPV4_MAX_PMTU		65535U		/* RFC 2675, Section 5.1 */
 #define IPV4_MIN_MTU		68			/* RFC 791 */
 
+#define IPV4_HEADER_LEN(ihl)    (ihl << 2)
+
 extern unsigned int sysctl_fib_sync_mem;
 extern unsigned int sysctl_fib_sync_mem_min;
 extern unsigned int sysctl_fib_sync_mem_max;
diff --git a/net/ipv4/ah4.c b/net/ipv4/ah4.c
index 64aec3dff8ec..d09e07408c2e 100644
--- a/net/ipv4/ah4.c
+++ b/net/ipv4/ah4.c
@@ -77,7 +77,7 @@ static inline struct scatterlist *ah_req_sg(struct crypto_ahash *ahash,
 static int ip_clear_mutable_options(const struct iphdr *iph, __be32 *daddr)
 {
 	unsigned char *optptr = (unsigned char *)(iph+1);
-	int  l = iph->ihl*4 - sizeof(struct iphdr);
+	int  l = IPV4_HEADER_LEN(iph->ihl) - sizeof(struct iphdr);
 	int  optlen;
 
 	while (l > 0) {
@@ -134,7 +134,7 @@ static void ah_output_done(void *data, int err)
 	top_iph->frag_off = iph->frag_off;
 	if (top_iph->ihl != 5) {
 		top_iph->daddr = iph->daddr;
-		memcpy(top_iph+1, iph+1, top_iph->ihl*4 - sizeof(struct iphdr));
+		memcpy(top_iph + 1, iph + 1, IPV4_HEADER_LEN(top_iph->ihl) - sizeof(struct iphdr));
 	}
 
 	kfree(AH_SKB_CB(skb)->tmp);
@@ -194,7 +194,7 @@ static int ah_output(struct xfrm_state *x, struct sk_buff *skb)
 
 	if (top_iph->ihl != 5) {
 		iph->daddr = top_iph->daddr;
-		memcpy(iph+1, top_iph+1, top_iph->ihl*4 - sizeof(struct iphdr));
+		memcpy(iph + 1, top_iph + 1, IPV4_HEADER_LEN(top_iph->ihl) - sizeof(struct iphdr));
 		err = ip_clear_mutable_options(top_iph, &top_iph->daddr);
 		if (err)
 			goto out_free;
@@ -250,7 +250,7 @@ static int ah_output(struct xfrm_state *x, struct sk_buff *skb)
 	top_iph->frag_off = iph->frag_off;
 	if (top_iph->ihl != 5) {
 		top_iph->daddr = iph->daddr;
-		memcpy(top_iph+1, iph+1, top_iph->ihl*4 - sizeof(struct iphdr));
+		memcpy(top_iph + 1, iph + 1, IPV4_HEADER_LEN(top_iph->ihl) - sizeof(struct iphdr));
 	}
 
 out_free:
diff --git a/net/ipv4/cipso_ipv4.c b/net/ipv4/cipso_ipv4.c
index 740af8541d2f..9134d31bd64b 100644
--- a/net/ipv4/cipso_ipv4.c
+++ b/net/ipv4/cipso_ipv4.c
@@ -1501,7 +1501,7 @@ unsigned char *cipso_v4_optptr(const struct sk_buff *skb)
 	int optlen;
 	int taglen;
 
-	for (optlen = iph->ihl*4 - sizeof(struct iphdr); optlen > 1; ) {
+	for (optlen = IPV4_HEADER_LEN(iph->ihl) - sizeof(struct iphdr); optlen > 1; ) {
 		switch (optptr[0]) {
 		case IPOPT_END:
 			return NULL;
@@ -1728,7 +1728,7 @@ void cipso_v4_error(struct sk_buff *skb, int error, u32 gateway)
 	 */
 
 	memset(opt, 0, sizeof(struct ip_options));
-	opt->optlen = ip_hdr(skb)->ihl*4 - sizeof(struct iphdr);
+	opt->optlen = IPV4_HEADER_LEN(ip_hdr(skb)->ihl) - sizeof(struct iphdr);
 	rcu_read_lock();
 	res = __ip_options_compile(dev_net(skb->dev), opt, skb, NULL);
 	rcu_read_unlock();
diff --git a/net/ipv4/ip_input.c b/net/ipv4/ip_input.c
index 30a5e9460d00..235553f50b6c 100644
--- a/net/ipv4/ip_input.c
+++ b/net/ipv4/ip_input.c
@@ -276,7 +276,7 @@ static inline bool ip_rcv_options(struct sk_buff *skb, struct net_device *dev)
 
 	iph = ip_hdr(skb);
 	opt = &(IPCB(skb)->opt);
-	opt->optlen = iph->ihl*4 - sizeof(struct iphdr);
+	opt->optlen = IPV4_HEADER_LEN(iph->ihl) - sizeof(struct iphdr);
 
 	if (ip_options_compile(dev_net(dev), opt, skb)) {
 		__IP_INC_STATS(dev_net(dev), IPSTATS_MIB_INHDRERRORS);
@@ -501,7 +501,7 @@ static struct sk_buff *ip_rcv_core(struct sk_buff *skb, struct net *net)
 		       IPSTATS_MIB_NOECTPKTS + (iph->tos & INET_ECN_MASK),
 		       max_t(unsigned short, 1, skb_shinfo(skb)->gso_segs));
 
-	if (!pskb_may_pull(skb, iph->ihl*4))
+	if (!pskb_may_pull(skb, IPV4_HEADER_LEN(iph->ihl)))
 		goto inhdr_error;
 
 	iph = ip_hdr(skb);
@@ -514,7 +514,7 @@ static struct sk_buff *ip_rcv_core(struct sk_buff *skb, struct net *net)
 		drop_reason = SKB_DROP_REASON_PKT_TOO_SMALL;
 		__IP_INC_STATS(net, IPSTATS_MIB_INTRUNCATEDPKTS);
 		goto drop;
-	} else if (len < (iph->ihl*4))
+	} else if (len < IPV4_HEADER_LEN(iph->ihl))
 		goto inhdr_error;
 
 	/* Our transport medium may have padded the buffer out. Now we know it
@@ -527,7 +527,7 @@ static struct sk_buff *ip_rcv_core(struct sk_buff *skb, struct net *net)
 	}
 
 	iph = ip_hdr(skb);
-	skb->transport_header = skb->network_header + iph->ihl*4;
+	skb->transport_header = skb->network_header + IPV4_HEADER_LEN(iph->ihl);
 
 	/* Remove any debris in the socket control block */
 	memset(IPCB(skb), 0, sizeof(struct inet_skb_parm));
diff --git a/net/ipv4/netfilter/nf_reject_ipv4.c b/net/ipv4/netfilter/nf_reject_ipv4.c
index 87fd945a0d27..ec2d8d93c241 100644
--- a/net/ipv4/netfilter/nf_reject_ipv4.c
+++ b/net/ipv4/netfilter/nf_reject_ipv4.c
@@ -27,10 +27,10 @@ static int nf_reject_iphdr_validate(struct sk_buff *skb)
 	len = ntohs(iph->tot_len);
 	if (skb->len < len)
 		return 0;
-	else if (len < (iph->ihl*4))
+	else if (len < IPV4_HEADER_LEN(iph->ihl))
 		return 0;
 
-	if (!pskb_may_pull(skb, iph->ihl*4))
+	if (!pskb_may_pull(skb, IPV4_HEADER_LEN(iph->ihl)))
 		return 0;
 
 	return 1;
-- 
2.34.1

