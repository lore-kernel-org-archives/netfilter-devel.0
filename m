Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=111.22.67.139
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794278408;
	b=CY8Oj7y7bG1mzTiKgZrDk/a9YCpdLfYV4NIuHkshpNFYnB1JjsodtZ+Mr/CSfuSamSUi
	 7SDhOZ6mSVex28aic2PePOfCqkJVYUZ2mfkIxt2dSs4EMCLCwuUtIWP7VHgWNqXwD0udV
	 XsvUpiSh62q6H+Dt4xjCDVf5rjV+GTh7eAPnA4MxGIOJG/4FmmKo3oukXSPzoLS7oEVCu
	 w7rIKWCVaNGlNSoqBu43m4ieAq79lCEHz0usmAffv/tzd78oo651D6f/JdhATDSf6hdCl
	 fiRElHn/ljxYUkvFO0ySe7lDafTieoRHjNGA4ZVpjnv1Oh98fVUb3+BbjghdRtUgNeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794278408;
	h=DMARC-Filter:DKIM-Signature:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:
	 X-RM-TRANSID:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:X-RM-TRANSID:From:
	 To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=R0LUalAf1WjKxbXXXOxjUuNRVrMg/oLP3bhvMHoORYg=;
	b=G8CUQzQhT0GYrhayVDgURgVfaUM5meDBnmK00Jx7H141np/md0TVspgOxS1L+ipsiFZR
	 XFobsHw2VQGxlNr1b+KpuhgyVC/4Ghkp8j1FYcqjDCqskgXmteSBgNp3BKnrQjWkeDFY6
	 duFYEQW843LEI5C0K3MOYUzAO8kTJRKvMlasvogcREmNodBkygonQb86VVqIFTm/afLsM
	 bF4UwlwgGECQBZVLV2ty0850JBMTxxaQRKJ4K//vk+Fx1UrXxuJciGgPejB/ixV+1dSlY
	 8g9p4HRI0x5u+btkW71CRIwtejnQGszz+ZEcu5q57TXHbzzDTShPCYTjN4md9Q0OV2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cmss.chinamobile.com;
	spf=pass smtp.mailfrom=cmss.chinamobile.com;
	dkim=pass header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b="o1ig/Pmp";
	arc=none smtp.remote-ip=111.22.67.139
Received: from cmccmta6.chinamobile.com (cmccmta6.chinamobile.com [111.22.67.139])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E24A606A31C;
	Tue, 10 Nov 2026 02:40:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8E24A606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=o1ig/Pmp
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=cmss.chinamobile.com; s=default; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=o1ig/PmpJCYhT6GDBOo4ORt9RLTEe5+OBoJna+N7LPvUpYmR4ZgCPGfgSmSE1I5eUh6P51n3Lz302
	 f7ij2n+HbaibaXuOZtwOyA5YDkjr/1ffSqffTbmWN+nug0mjyMgmhBQqZF8oobwKo11COhmIWhWoDL
	 YWsLKjxGs3t8yTwM=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app05-12005 (RichMail) with SMTP id 2ee56af28400bab-c7103;
	Tue, 10 Nov 2026 10:40:00 +0800 (CST)
X-RM-TRANSID:2ee56af28400bab-c7103
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from [25.255.2.225] (unknown[10.55.1.70])
	by rmsmtp-syy-appsvr07-12007 (RichMail) with SMTP id 2ee76af283ffaf4-a3792;
	Tue, 10 Nov 2026 10:40:00 +0800 (CST)
X-RM-TRANSID:2ee76af283ffaf4-a3792
From: xujiahao <xujiahao@cmss.chinamobile.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Cc: Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+2e819f6641708bb6ab9d@syzkaller.appspotmail.com,
	xujiahao <xujiahao@cmss.chinamobile.com>
Subject: [PATCH nf v2] netfilter: conntrack: attach generated TCP resets as ESTABLISHED
Date: Tue, 10 Nov 2026 10:18:55 +0800
Message-ID: <20261110021855.893531-1-xujiahao@cmss.chinamobile.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261106065651.3504452-1-xujiahao@cmss.chinamobile.com>
References: <20261106065651.3504452-1-xujiahao@cmss.chinamobile.com>
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

nf_conntrack_attach() marks every packet it attaches as related to the
conntrack entry of the packet which caused it: IP_CT_RELATED_REPLY when
that packet was in the original direction, IP_CT_RELATED otherwise.

That is right for the ICMP errors built by icmp.c and icmpv6.c, but not
for the TCP resets built by nf_send_reset(): a reset is a packet of the
connection itself and carries the state of the connection, just like the
equivalent reset the TCP stack emits.

A locally generated reset therefore currently leaves through the
LOCAL_OUT nat hook as IP_CT_RELATED_REPLY.  As no nat mapping is
initialized for it, nf_nat_inet_fn() evaluates the nat OUTPUT chain, so a
DNAT target reachable from that chain rewrites the reset and warns:

  WARNING: net/netfilter/xt_nat.c:154 at xt_dnat_target_v2+0x97/0xc0

Pass the protocol of the generated packet to nf_ct_attach() and mark TCP
resets as ESTABLISHED/ESTABLISHED_REPLY.  They then take the default
branch of nf_nat_inet_fn(), which only applies the mapping already
installed on the connection.  ICMP errors keep IP_CT_RELATED/_REPLY.

Passing u8 l4proto rather than a boolean keeps the call sites readable,
as nf_ct_attach(new, skb, IPPROTO_TCP) says which packet is built.

Suggested-by: Florian Westphal <fw@strlen.de>
Reported-by: syzbot+2e819f6641708bb6ab9d@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=2e819f6641708bb6ab9d
Signed-off-by: xujiahao <xujiahao@cmss.chinamobile.com>
---
 include/linux/netfilter.h           |  8 +++++---
 net/ipv4/icmp.c                     |  2 +-
 net/ipv4/netfilter/nf_reject_ipv4.c |  2 +-
 net/ipv6/icmp.c                     |  2 +-
 net/ipv6/netfilter/nf_reject_ipv6.c |  2 +-
 net/netfilter/core.c                |  4 ++--
 net/netfilter/nf_conntrack_core.c   | 27 +++++++++++++++++++++------
 7 files changed, 32 insertions(+), 15 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index e99afc141..c9771578f 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -454,13 +454,14 @@ nf_nat_decode_session(struct sk_buff *skb, struct flowi *fl, u_int8_t family)
 #if IS_ENABLED(CONFIG_NF_CONNTRACK)
 #include <linux/netfilter/nf_conntrack_zones_common.h>
 
-void nf_ct_attach(struct sk_buff *, const struct sk_buff *);
+void nf_ct_attach(struct sk_buff *, const struct sk_buff *, u8 l4proto);
 void nf_ct_set_closing(struct nf_conntrack *nfct);
 struct nf_conntrack_tuple;
 bool nf_ct_get_tuple_skb(struct nf_conntrack_tuple *dst_tuple,
 			 const struct sk_buff *skb);
 #else
-static inline void nf_ct_attach(struct sk_buff *new, struct sk_buff *skb) {}
+static inline void nf_ct_attach(struct sk_buff *new, struct sk_buff *skb,
+				u8 l4proto) {}
 static inline void nf_ct_set_closing(struct nf_conntrack *nfct) {}
 struct nf_conntrack_tuple;
 static inline bool nf_ct_get_tuple_skb(struct nf_conntrack_tuple *dst_tuple,
@@ -478,7 +479,8 @@ struct nf_ct_hook {
 	void (*destroy)(struct nf_conntrack *);
 	bool (*get_tuple_skb)(struct nf_conntrack_tuple *,
 			      const struct sk_buff *);
-	void (*attach)(struct sk_buff *nskb, const struct sk_buff *skb);
+	void (*attach)(struct sk_buff *nskb, const struct sk_buff *skb,
+		       u8 l4proto);
 	void (*set_closing)(struct nf_conntrack *nfct);
 	int (*confirm)(struct sk_buff *skb);
 	u32 (*get_id)(const struct nf_conntrack *nfct);
diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index 90c0e22c2..e01e32941 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -375,7 +375,7 @@ static int icmp_glue_bits(void *from, char *to, int offset, int len, int odd,
 	if (icmp_param->data.icmph.type <= NR_ICMP_TYPES &&
 	    icmp_pointers[array_index_nospec(icmp_param->data.icmph.type,
 					     NR_ICMP_TYPES + 1)].error)
-		nf_ct_attach(skb, icmp_param->skb);
+		nf_ct_attach(skb, icmp_param->skb, IPPROTO_ICMP);
 	return 0;
 }
 
diff --git a/net/ipv4/netfilter/nf_reject_ipv4.c b/net/ipv4/netfilter/nf_reject_ipv4.c
index 7cb33af67..2b7251b4a 100644
--- a/net/ipv4/netfilter/nf_reject_ipv4.c
+++ b/net/ipv4/netfilter/nf_reject_ipv4.c
@@ -308,7 +308,7 @@ void nf_send_reset(struct net *net, struct sock *sk, struct sk_buff *oldskb,
 	if (nskb->len > dst4_mtu(skb_dst(nskb)))
 		goto free_nskb;
 
-	nf_ct_attach(nskb, oldskb);
+	nf_ct_attach(nskb, oldskb, IPPROTO_TCP);
 	nf_ct_set_closing(skb_nfct(oldskb));
 
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
index a95b03518..f95800d54 100644
--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -327,7 +327,7 @@ static int icmpv6_getfrag(void *from, char *to, int offset, int len, int odd, st
 				      to, len);
 	skb->csum = csum_block_add(skb->csum, csum, odd);
 	if (!(msg->type & ICMPV6_INFOMSG_MASK))
-		nf_ct_attach(skb, org_skb);
+		nf_ct_attach(skb, org_skb, IPPROTO_ICMP);
 	return 0;
 }
 
diff --git a/net/ipv6/netfilter/nf_reject_ipv6.c b/net/ipv6/netfilter/nf_reject_ipv6.c
index 5e08d8529..7c0035964 100644
--- a/net/ipv6/netfilter/nf_reject_ipv6.c
+++ b/net/ipv6/netfilter/nf_reject_ipv6.c
@@ -377,7 +377,7 @@ void nf_send_reset6(struct net *net, struct sock *sk, struct sk_buff *oldskb,
 	nf_reject_ip6hdr_put(nskb, oldskb, IPPROTO_TCP, ip6_dst_hoplimit(dst));
 	nf_reject_ip6_tcphdr_put(nskb, oldskb, otcph, otcplen);
 
-	nf_ct_attach(nskb, oldskb);
+	nf_ct_attach(nskb, oldskb, IPPROTO_TCP);
 	nf_ct_set_closing(skb_nfct(oldskb));
 
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 44c856c1e..a6ac17237 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -702,7 +702,7 @@ EXPORT_SYMBOL_GPL(nf_nat_hook);
  * tracking in use: without this, connection may not be in hash table, and hence
  * manufactured ICMP or RST packets will not be associated with it.
  */
-void nf_ct_attach(struct sk_buff *new, const struct sk_buff *skb)
+void nf_ct_attach(struct sk_buff *new, const struct sk_buff *skb, u8 l4proto)
 {
 	const struct nf_ct_hook *ct_hook;
 
@@ -710,7 +710,7 @@ void nf_ct_attach(struct sk_buff *new, const struct sk_buff *skb)
 		rcu_read_lock();
 		ct_hook = rcu_dereference(nf_ct_hook);
 		if (ct_hook)
-			ct_hook->attach(new, skb);
+			ct_hook->attach(new, skb, l4proto);
 		rcu_read_unlock();
 	}
 }
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 931b76aac..5cb068e14 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -2178,17 +2178,32 @@ EXPORT_SYMBOL_GPL(nf_ct_port_nlattr_tuple_size);
 #endif
 
 /* Used by ipt_REJECT and ip6t_REJECT. */
-static void nf_conntrack_attach(struct sk_buff *nskb, const struct sk_buff *skb)
+static void nf_conntrack_attach(struct sk_buff *nskb, const struct sk_buff *skb,
+				u8 l4proto)
 {
 	struct nf_conn *ct;
 	enum ip_conntrack_info ctinfo;
 
-	/* This ICMP is in reverse direction to the packet which caused it */
 	ct = nf_ct_get(skb, &ctinfo);
-	if (CTINFO2DIR(ctinfo) == IP_CT_DIR_ORIGINAL)
-		ctinfo = IP_CT_RELATED_REPLY;
-	else
-		ctinfo = IP_CT_RELATED;
+	if (l4proto == IPPROTO_TCP) {
+		/*
+		 * A reset we generate for an existing TCP connection belongs
+		 * to that connection, it is not an error related to it, so it
+		 * carries the state of the connection.  Attaching it as
+		 * related would let it take a fresh NAT mapping on its way
+		 * out, i.e. rewrite the reset.
+		 */
+		if (CTINFO2DIR(ctinfo) == IP_CT_DIR_ORIGINAL)
+			ctinfo = IP_CT_ESTABLISHED_REPLY;
+		else
+			ctinfo = IP_CT_ESTABLISHED;
+	} else {
+		/* Errors are in reverse direction to the packet that caused them. */
+		if (CTINFO2DIR(ctinfo) == IP_CT_DIR_ORIGINAL)
+			ctinfo = IP_CT_RELATED_REPLY;
+		else
+			ctinfo = IP_CT_RELATED;
+	}
 
 	/* Attach to new skbuff, and increment count */
 	nf_ct_set(nskb, ct, ctinfo);
-- 
2.43.0



