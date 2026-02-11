Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D35D26F288
	for <netfilter-devel@vger.kernel.org>; Wed, 11 Feb 2026 03:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770778860; cv=none; b=hefoCw2noH1qXx0FV85gu2QPvbJmrqL+e7Moe+1W9kAbQGPwikLq6JTLRPBPQca30gUsE0RAQgD22vu84FdzUS/faCdXGosCvQrae74lxiHxF4Eq6wk+/LiGxzXE4vMvUntRkjY8l2PhYF+KOer8gjgHIuzJhO04xI7ueAtPR0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770778860; c=relaxed/simple;
	bh=cV2hgej0/d4CNxESVTQhrC5ZoHENM4JDwIXIV5kH5hM=;
	h=Mime-Version:Subject:From:To:CC:Message-ID:Date:Content-Type:
	 References; b=Hz9m27zYF7egWXB5oejj7izGVcQwn4/IoJjANRNYDD+dzVi6oeRXojYZoFiKVKdGUsVw3/iAFKbdulxcVkvIDHbh0XgZcTzoWxaVvpESKQDLuxxD1oRVYdesMR+omNKAP4oCe92WKGgNOYpF0I5ZSGNbVquqUfdBmO+6G8x44fE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=b7pTqacM; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="b7pTqacM"
Received: from epcas1p1.samsung.com (unknown [182.195.41.45])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20260211030049epoutp01e499c1fd0b4cd6651ad18fcc3805f100~TEftSNAtX3115431154epoutp01-
	for <netfilter-devel@vger.kernel.org>; Wed, 11 Feb 2026 03:00:49 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20260211030049epoutp01e499c1fd0b4cd6651ad18fcc3805f100~TEftSNAtX3115431154epoutp01-
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1770778849;
	bh=yK15z7XHXiZ7B8FRiXMjIxKjogn3BXQBJjSS6kwqE6Y=;
	h=Subject:Reply-To:From:To:CC:Date:References:From;
	b=b7pTqacMcE6I26IMosQrzcLWmoPebMBwMCrACnloz2/3Krln/txSAC7aJ9GIFcLFA
	 tdj7qiTOgf6zsuzDZb2wXn1Yw+UCe/LP8A07SEqYBoJxCHglepGDcoXpZOXBgdlCui
	 m4llYVmBA3v9jkkrDI6/+BO2Ci9FGmQsA3FAowXs=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas1p4.samsung.com (KnoxPortal) with ESMTPS id
	20260211030048epcas1p4e79df5d89e434485395c8cbd734ab0f2~TEfstmPRG1137711377epcas1p49;
	Wed, 11 Feb 2026 03:00:48 +0000 (GMT)
Received: from epcas1p3.samsung.com (unknown [182.195.38.190]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4f9jqN5X2dz2SSKf; Wed, 11 Feb
	2026 03:00:48 +0000 (GMT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: [PATCH] ipv6: shorten reassembly timeout under fragment memory
 pressure
Reply-To: soukjin.bae@samsung.com
Sender: =?UTF-8?B?67Cw7ISd7KeE?= <soukjin.bae@samsung.com>
From: =?UTF-8?B?67Cw7ISd7KeE?= <soukjin.bae@samsung.com>
To: "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	"davem@davemloft.net" <davem@davemloft.net>, "edumazet@google.com"
	<edumazet@google.com>, "pabeni@redhat.com" <pabeni@redhat.com>,
	"dsahern@kernel.org" <dsahern@kernel.org>, "kuba@kernel.org"
	<kuba@kernel.org>
X-Priority: 3
X-Content-Kind-Code: NORMAL
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20260211030048epcms1p54c6ed78458f57def8e3163032498ca00@epcms1p5>
Date: Wed, 11 Feb 2026 12:00:48 +0900
X-CMS-MailID: 20260211030048epcms1p54c6ed78458f57def8e3163032498ca00
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 101P
cpgsPolicy: CPGSC10-711,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260211030048epcms1p54c6ed78458f57def8e3163032498ca00
References: <CGME20260211030048epcms1p54c6ed78458f57def8e3163032498ca00@epcms1p5>


Hi,

this patch addresses an IPv6 reassembly issue observed under fragment buffer
starvation, where incomplete fragment queues may be retained for the full
reassembly timeout, leading to packet drops under real-world traffic
conditions.

## Problem description

In environments with a large number of devices generating IPv6 multicast
traffic, bursts of fragmented packets are common. Under such conditions,
partial fragment loss frequently occurs and some fragment streams fail to
complete reassembly.

As a result, incomplete fragment queues may remain active until the full
reassembly timeout expires.

In the current IPv6 reassembly implementation, fragment queues always use a
fixed timeout (IPV6_FRAG_TIMEOUT, 60 seconds), regardless of fragment memory
pressure or the likelihood of successful completion. When fragment memory
usage is high, this can lead to prolonged retention of incomplete fragment
queues and dropping of newly arriving fragmented packets due to memory
exhaustion.

## Impact on IMS traffic

This issue affects not only multicast discovery traffic. In current mobile
networks, IMS services are predominantly carried over IPv6, and both signaling
and media packets may arrive fragmented at the device.

When the device enters a fragment buffer starvation state, fragmented IMS
packets may fail reassembly and be dropped, which can result in IMS call
setup failures or unexpected call drops. This behavior has been observed in
production environments as a user-visible service failure.

## Proposed solution

This patch introduces an optional mechanism to dynamically shorten the IPv6
reassembly timeout when fragment memory usage exceeds the low threshold.

Different timeout values are applied depending on the upper-layer protocol:

- TCP / ESP: slightly longer timeout
- UDP and others: shorter timeout

This allows fragment queues that are unlikely to complete to be evicted
earlier, freeing fragment memory for newly arriving fragmented packets,
including latency-sensitive IMS traffic.

Thanks for your review.




From c46588fa40920832a0265c74cb265cd3e258ae48 Mon Sep 17 00:00:00 2001
From: Soukjin Bae <soukjin.bae@samsung.com>
Date: Wed, 11 Feb 2026 11:20:23 +0900
Subject: [PATCH] ipv6: shorten reassembly timeout under fragment memory
 pressure

Under heavy IPv6 fragmentation, incomplete fragment queues may persist
for the full reassembly timeout even when fragment memory is under
pressure.

This can lead to prolonged retention of fragment queues that are unlikely
to complete, causing newly arriving fragmented packets to be dropped due
to memory exhaustion.

Introduce an optional mechanism to shorten the IPv6 reassembly timeout
when fragment memory usage exceeds the low threshold. Different timeout
values are applied depending on the upper-layer protocol to balance
eviction speed and completion probability.

Signed-off-by: Soukjin Bae <soukjin.bae@samsung.com>
---
 include/net/inet_frag.h                 |  4 ++
 include/net/ip6_reasm_policy.h          | 20 +++++++
 net/ipv6/Kconfig                        | 10 ++++
 net/ipv6/netfilter/nf_conntrack_reasm.c | 27 +++++++++
 net/ipv6/reassembly.c                   | 79 +++++++++++++++++++++++++
 5 files changed, 140 insertions(+)
 create mode 100644 include/net/ip6_reasm_policy.h

diff --git a/include/net/inet_frag.h b/include/net/inet_frag.h
index 365925c9d262..0fc88ef61ca3 100644
--- a/include/net/inet_frag.h
+++ b/include/net/inet_frag.h
@@ -15,6 +15,10 @@ struct fqdir {
 	long			high_thresh;
 	long			low_thresh;
 	int			timeout;
+#ifdef CONFIG_IPV6_FRAG_TIMER_ADJ
+	int			timeout_failed_tcp;
+	int			timeout_failed_udp;
+#endif
 	int			max_dist;
 	struct inet_frags	*f;
 	struct net		*net;
diff --git a/include/net/ip6_reasm_policy.h b/include/net/ip6_reasm_policy.h
new file mode 100644
index 000000000000..cd80d38f3f5d
--- /dev/null
+++ b/include/net/ip6_reasm_policy.h
@@ -0,0 +1,20 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _NET_IP6_REASM_POLICY_H
+#define _NET_IP6_REASM_POLICY_H
+
+#include <linux/jiffies.h>
+
+struct sk_buff;
+struct frag_queue;
+
+u8 ip6_reasm_get_l4proto(struct sk_buff *skb, int nhoff);
+void ip6_reasm_adjust_timer(struct frag_queue *fq,
+			    struct sk_buff *skb, int nhoff);
+
+/*
+ * Default IPv6 reassembly timeouts under fragment memory pressure
+ */
+#define IPV6_REASM_TIMEOUT_FAILED_TCP	(3 * HZ)	/* 3 seconds */
+#define IPV6_REASM_TIMEOUT_FAILED_UDP	(1 * HZ)	/* 1 second */
+
+#endif /* _NET_IP6_REASM_POLICY_H */
diff --git a/net/ipv6/Kconfig b/net/ipv6/Kconfig
index b8f9a8c0302e..6e8db60f6a4d 100644
--- a/net/ipv6/Kconfig
+++ b/net/ipv6/Kconfig
@@ -340,4 +340,14 @@ config IPV6_IOAM6_LWTUNNEL
 
 	  If unsure, say N.
 
+config IPV6_FRAG_TIMER_ADJ
+	bool "IPv6: Adjust reassembly timer on buffer starvation"
+	default n
+	help
+	  Enable dynamic adjustment of the IPv6 reassembly timer when the
+	  fragment memory usage exceeds the low threshold. This helps to
+	  quickly evict incomplete fragment queues, making room for new
+	  incoming fragments such as latency-sensitive IMS traffic.
+	  If unsure, say N.
+
 endif # IPV6
diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index 64ab23ff559b..e088662a9146 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -30,6 +30,7 @@
 #include <linux/module.h>
 #include <net/netfilter/ipv6/nf_defrag_ipv6.h>
 #include <net/netns/generic.h>
+#include <net/ip6_reasm_policy.h>
 
 static const char nf_frags_cache_name[] = "nf-frags";
 
@@ -62,6 +63,20 @@ static struct ctl_table nf_ct_frag6_sysctl_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_doulongvec_minmax,
 	},
+#ifdef CONFIG_IPV6_FRAG_TIMER_ADJ
+	{
+		.procname	= "nf_conntrack_frag6_timeout_failed_tcp",
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_jiffies,
+	},
+	{
+		.procname	= "nf_conntrack_frag6_timeout_failed_udp",
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_jiffies,
+	},
+#endif
 };
 
 static int nf_ct_frag6_sysctl_register(struct net *net)
@@ -85,6 +100,10 @@ static int nf_ct_frag6_sysctl_register(struct net *net)
 	table[1].extra2	= &nf_frag->fqdir->high_thresh;
 	table[2].data	= &nf_frag->fqdir->high_thresh;
 	table[2].extra1	= &nf_frag->fqdir->low_thresh;
+#ifdef CONFIG_IPV6_FRAG_TIMER_ADJ
+	table[3].data	= &nf_frag->fqdir->timeout_failed_tcp;
+	table[4].data	= &nf_frag->fqdir->timeout_failed_udp;
+#endif
 
 	hdr = register_net_sysctl_sz(net, "net/netfilter", table,
 				     ARRAY_SIZE(nf_ct_frag6_sysctl_table));
@@ -214,6 +233,10 @@ static int nf_ct_frag6_queue(struct frag_queue *fq, struct sk_buff *skb,
 		}
 		fq->q.flags |= INET_FRAG_LAST_IN;
 		fq->q.len = end;
+
+#ifdef CONFIG_IPV6_FRAG_TIMER_ADJ
+		ip6_reasm_adjust_timer(fq, skb, nhoff);
+#endif
 	} else {
 		/* Check if the fragment is rounded to 8 bytes.
 		 * Required by the RFC.
@@ -513,6 +536,10 @@ static int nf_ct_net_init(struct net *net)
 	nf_frag->fqdir->high_thresh = IPV6_FRAG_HIGH_THRESH;
 	nf_frag->fqdir->low_thresh = IPV6_FRAG_LOW_THRESH;
 	nf_frag->fqdir->timeout = IPV6_FRAG_TIMEOUT;
+#ifdef CONFIG_IPV6_FRAG_TIMER_ADJ
+	nf_frag->fqdir->timeout_failed_tcp = IPV6_REASM_TIMEOUT_FAILED_TCP;
+	nf_frag->fqdir->timeout_failed_udp = IPV6_REASM_TIMEOUT_FAILED_UDP;
+#endif
 
 	res = nf_ct_frag6_sysctl_register(net);
 	if (res < 0)
diff --git a/net/ipv6/reassembly.c b/net/ipv6/reassembly.c
index 25ec8001898d..43b357b6479f 100644
--- a/net/ipv6/reassembly.c
+++ b/net/ipv6/reassembly.c
@@ -57,6 +57,7 @@
 #include <net/addrconf.h>
 #include <net/ipv6_frag.h>
 #include <net/inet_ecn.h>
+#include <net/ip6_reasm_policy.h>
 
 static const char ip6_frag_cache_name[] = "ip6-frags";
 
@@ -104,6 +105,58 @@ fq_find(struct net *net, __be32 id, const struct ipv6hdr *hdr, int iif)
 	return container_of(q, struct frag_queue, q);
 }
 
+#ifdef CONFIG_IPV6_FRAG_TIMER_ADJ
+u8 ip6_reasm_get_l4proto(struct sk_buff *skb, int nhoff)
+{
+	struct frag_hdr _fhdr, *fhdr;
+	u16 frag_off;
+	int offset;
+	u8 nexthdr;
+
+	fhdr = skb_header_pointer(skb, nhoff, sizeof(_fhdr), &_fhdr);
+	if (!fhdr)
+		return IPPROTO_NONE;
+
+	nexthdr = fhdr->nexthdr;
+	offset = nhoff + sizeof(struct frag_hdr);
+
+	/* Skip extension headers after fragment header */
+	if (ipv6_skip_exthdr(skb, offset, &nexthdr, &frag_off) < 0)
+		return IPPROTO_NONE;
+
+	return nexthdr;
+}
+
+/**
+ * ip6_reasm_adjust_timer - adjust IPv6 reassembly timer under memory pressure
+ * @fq: fragment queue
+ * @skb: current fragment skb
+ * @nhoff: offset to fragment header
+ *
+ * Shortens reassembly timeout on buffer starvation to
+ * allow faster eviction of incomplete fragment queues.
+ */
+void ip6_reasm_adjust_timer(struct frag_queue *fq,
+			    struct sk_buff *skb, int nhoff)
+{
+	u8 l4proto;
+	unsigned long new_timer;
+
+	if (frag_mem_limit(fq->q.fqdir) < fq->q.fqdir->low_thresh)
+		return;
+
+	l4proto = ip6_reasm_get_l4proto(skb, nhoff);
+
+	if (l4proto == IPPROTO_TCP || l4proto == IPPROTO_ESP)
+		new_timer = IPV6_REASM_TIMEOUT_FAILED_TCP;
+	else
+		new_timer = IPV6_REASM_TIMEOUT_FAILED_UDP;
+
+	if (time_after(fq->q.timer.expires, jiffies + new_timer))
+		mod_timer(&fq->q.timer, jiffies + new_timer);
+}
+#endif
+
 static int ip6_frag_queue(struct net *net,
 			  struct frag_queue *fq, struct sk_buff *skb,
 			  struct frag_hdr *fhdr, int nhoff,
@@ -154,6 +207,10 @@ static int ip6_frag_queue(struct net *net,
 			goto discard_fq;
 		fq->q.flags |= INET_FRAG_LAST_IN;
 		fq->q.len = end;
+
+#ifdef CONFIG_IPV6_FRAG_TIMER_ADJ
+		ip6_reasm_adjust_timer(fq, skb, nhoff);
+#endif
 	} else {
 		/* Check if the fragment is rounded to 8 bytes.
 		 * Required by the RFC.
@@ -437,6 +494,20 @@ static struct ctl_table ip6_frags_ns_ctl_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_jiffies,
 	},
+#ifdef CONFIG_IPV6_FRAG_TIMER_ADJ
+	{
+		.procname	= "ip6frag_timeout_failed_tcp",
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_jiffies,
+	},
+	{
+		.procname	= "ip6frag_timeout_failed_udp",
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_jiffies,
+	},
+#endif
 };
 
 /* secret interval has been deprecated */
@@ -468,6 +539,10 @@ static int __net_init ip6_frags_ns_sysctl_register(struct net *net)
 	table[1].data	= &net->ipv6.fqdir->low_thresh;
 	table[1].extra2	= &net->ipv6.fqdir->high_thresh;
 	table[2].data	= &net->ipv6.fqdir->timeout;
+#ifdef CONFIG_IPV6_FRAG_TIMER_ADJ
+	table[3].data	= &net->ipv6.fqdir->timeout_failed_tcp;
+	table[4].data	= &net->ipv6.fqdir->timeout_failed_udp;
+#endif
 
 	hdr = register_net_sysctl_sz(net, "net/ipv6", table,
 				     ARRAY_SIZE(ip6_frags_ns_ctl_table));
@@ -538,6 +613,10 @@ static int __net_init ipv6_frags_init_net(struct net *net)
 	net->ipv6.fqdir->high_thresh = IPV6_FRAG_HIGH_THRESH;
 	net->ipv6.fqdir->low_thresh = IPV6_FRAG_LOW_THRESH;
 	net->ipv6.fqdir->timeout = IPV6_FRAG_TIMEOUT;
+#ifdef CONFIG_IPV6_FRAG_TIMER_ADJ
+	net->ipv6.fqdir->timeout_failed_tcp = IPV6_REASM_TIMEOUT_FAILED_TCP;
+	net->ipv6.fqdir->timeout_failed_udp = IPV6_REASM_TIMEOUT_FAILED_UDP;
+#endif
 
 	res = ip6_frags_ns_sysctl_register(net);
 	if (res < 0)
-- 
2.25.1

