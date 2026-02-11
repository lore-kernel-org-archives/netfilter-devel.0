Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C97AA3EBF01
	for <netfilter-devel@vger.kernel.org>; Wed, 11 Feb 2026 05:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770787505; cv=none; b=qJQ2HVloON4AbzP70f5gJvWtNZupJdudno1GaHNz20uJjDoJdPoBsPwrZwF4Est7n2DpCaysiH4pR4aUv+3UFlRftaMUr/drf3wZnh0xkovIctNTqdKkpFYki8otTtoyyM+NOpJ91WA8TyAHPedSRmPrzcGDfsCYHGHV3O4cSRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770787505; c=relaxed/simple;
	bh=E++AaOjHrJIl1/RdzTM+lWdyRXBdrzMAd7gTMxD3KuI=;
	h=Mime-Version:Subject:From:To:CC:In-Reply-To:Message-ID:Date:
	 Content-Type:References; b=FB1bpb/srJKL/iK+5YjvQdQYnEG4FMd9O2ymbkotBTiKVfQ9mJ3sXpejPv97kS0u273dFHk10MOhM1Pzq4mEqoXSvAP0fry7y8oAyOa0/INaVCB+svt2U56eKJ8WgmM+s6NYTP5JcQ+OhzsULsvDc/AQXe7ksSnrrvBznhRP2/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=aZ6Gls1B; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="aZ6Gls1B"
Received: from epcas1p2.samsung.com (unknown [182.195.41.46])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20260211052500epoutp013e23ff30f002055ebda251e11b98bb6e~TGdmEullp1175611756epoutp01K
	for <netfilter-devel@vger.kernel.org>; Wed, 11 Feb 2026 05:25:00 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20260211052500epoutp013e23ff30f002055ebda251e11b98bb6e~TGdmEullp1175611756epoutp01K
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1770787500;
	bh=SM+h1LXna3rRYYBoGVSynlgoyRbqycsCuMEeIGraJ/E=;
	h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
	b=aZ6Gls1BZd8NEH1e/66pE5w/Pd1Dpo1DJIXie6+GABa2ZUtD2jQ9yo3jyIB0a/BfS
	 S2nwPKH6KVTwvsUpeN89neHXj6vAZd6UgT3jBi5FhWZn+TWKD/VFZqS84RkL0bFZ52
	 +q7nJGneJ0lk4vgYOvBLVS8sq1krdpvbAK/YrYwE=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas1p4.samsung.com (KnoxPortal) with ESMTPS id
	20260211052459epcas1p4e0d06fb878b72342f6a62c01bec96280~TGdlmEHNX2167121671epcas1p4L;
	Wed, 11 Feb 2026 05:24:59 +0000 (GMT)
Received: from epcas1p1.samsung.com (unknown [182.195.38.192]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4f9n1l5Kplz2SSKX; Wed, 11 Feb
	2026 05:24:59 +0000 (GMT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: [PATCHv2] ipv6: shorten reassembly timeout under fragment memory
 pressure
Reply-To: soukjin.bae@samsung.com
Sender: =?UTF-8?B?67Cw7ISd7KeE?= <soukjin.bae@samsung.com>
From: =?UTF-8?B?67Cw7ISd7KeE?= <soukjin.bae@samsung.com>
To: "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC: =?UTF-8?B?67Cw7ISd7KeE?= <soukjin.bae@samsung.com>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	"davem@davemloft.net" <davem@davemloft.net>, "edumazet@google.com"
	<edumazet@google.com>, "pabeni@redhat.com" <pabeni@redhat.com>,
	"dsahern@kernel.org" <dsahern@kernel.org>, "kuba@kernel.org"
	<kuba@kernel.org>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <20260211030048epcms1p54c6ed78458f57def8e3163032498ca00@epcms1p5>
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20260211052459epcms1p461ef587d229a8c300d69151f3c246ba6@epcms1p4>
Date: Wed, 11 Feb 2026 14:24:59 +0900
X-CMS-MailID: 20260211052459epcms1p461ef587d229a8c300d69151f3c246ba6
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 101P
cpgsPolicy: CPGSC10-711,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260211030048epcms1p54c6ed78458f57def8e3163032498ca00
References: <20260211030048epcms1p54c6ed78458f57def8e3163032498ca00@epcms1p5>
	<CGME20260211030048epcms1p54c6ed78458f57def8e3163032498ca00@epcms1p4>

Changes in v2:
 - Fix build_allconfig warnings by removing HZ from policy header
 - Export only ip6_reasm_adjust_timer, make get_l4proto static
 - Correct sysctl and timeout units (jiffies)



From ed2f719d156376dd6ede8e4d0cd58fd372233bfa Mon Sep 17 00:00:00 2001
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
 include/net/ip6_reasm_policy.h          | 17 ++++++
 net/ipv6/Kconfig                        | 10 ++++
 net/ipv6/netfilter/nf_conntrack_reasm.c | 27 +++++++++
 net/ipv6/reassembly.c                   | 80 +++++++++++++++++++++++++
 5 files changed, 138 insertions(+)
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
index 000000000000..994482a03bc0
--- /dev/null
+++ b/include/net/ip6_reasm_policy.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _NET_IP6_REASM_POLICY_H
+#define _NET_IP6_REASM_POLICY_H
+
+struct sk_buff;
+struct frag_queue;
+
+void ip6_reasm_adjust_timer(struct frag_queue *fq,
+			    struct sk_buff *skb, int nhoff);
+
+/*
+ * Default IPv6 reassembly timeouts under fragment memory pressure
+ */
+#define IPV6_REASM_TIMEOUT_FAILED_TCP	3	/* 3 seconds */
+#define IPV6_REASM_TIMEOUT_FAILED_UDP	1	/* 1 second */
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
index 64ab23ff559b..7e0e33f98924 100644
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
+	nf_frag->fqdir->timeout_failed_tcp = IPV6_REASM_TIMEOUT_FAILED_TCP * HZ;
+	nf_frag->fqdir->timeout_failed_udp = IPV6_REASM_TIMEOUT_FAILED_UDP * HZ;
+#endif
 
 	res = nf_ct_frag6_sysctl_register(net);
 	if (res < 0)
diff --git a/net/ipv6/reassembly.c b/net/ipv6/reassembly.c
index 25ec8001898d..ba5f9053dc5a 100644
--- a/net/ipv6/reassembly.c
+++ b/net/ipv6/reassembly.c
@@ -57,6 +57,7 @@
 #include <net/addrconf.h>
 #include <net/ipv6_frag.h>
 #include <net/inet_ecn.h>
+#include <net/ip6_reasm_policy.h>
 
 static const char ip6_frag_cache_name[] = "ip6-frags";
 
@@ -104,6 +105,59 @@ fq_find(struct net *net, __be32 id, const struct ipv6hdr *hdr, int iif)
 	return container_of(q, struct frag_queue, q);
 }
 
+#ifdef CONFIG_IPV6_FRAG_TIMER_ADJ
+static u8 ip6_reasm_get_l4proto(struct sk_buff *skb, int nhoff)
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
+		new_timer = fq->q.fqdir->timeout_failed_tcp;
+	else
+		new_timer = fq->q.fqdir->timeout_failed_udp;
+
+	if (time_after(fq->q.timer.expires, jiffies + new_timer))
+		mod_timer(&fq->q.timer, jiffies + new_timer);
+}
+EXPORT_SYMBOL_GPL(ip6_reasm_adjust_timer);
+#endif
+
 static int ip6_frag_queue(struct net *net,
 			  struct frag_queue *fq, struct sk_buff *skb,
 			  struct frag_hdr *fhdr, int nhoff,
@@ -154,6 +208,10 @@ static int ip6_frag_queue(struct net *net,
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
@@ -437,6 +495,20 @@ static struct ctl_table ip6_frags_ns_ctl_table[] = {
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
@@ -468,6 +540,10 @@ static int __net_init ip6_frags_ns_sysctl_register(struct net *net)
 	table[1].data	= &net->ipv6.fqdir->low_thresh;
 	table[1].extra2	= &net->ipv6.fqdir->high_thresh;
 	table[2].data	= &net->ipv6.fqdir->timeout;
+#ifdef CONFIG_IPV6_FRAG_TIMER_ADJ
+	table[3].data	= &net->ipv6.fqdir->timeout_failed_tcp;
+	table[4].data	= &net->ipv6.fqdir->timeout_failed_udp;
+#endif
 
 	hdr = register_net_sysctl_sz(net, "net/ipv6", table,
 				     ARRAY_SIZE(ip6_frags_ns_ctl_table));
@@ -538,6 +614,10 @@ static int __net_init ipv6_frags_init_net(struct net *net)
 	net->ipv6.fqdir->high_thresh = IPV6_FRAG_HIGH_THRESH;
 	net->ipv6.fqdir->low_thresh = IPV6_FRAG_LOW_THRESH;
 	net->ipv6.fqdir->timeout = IPV6_FRAG_TIMEOUT;
+#ifdef CONFIG_IPV6_FRAG_TIMER_ADJ
+	net->ipv6.fqdir->timeout_failed_tcp = IPV6_REASM_TIMEOUT_FAILED_TCP * HZ;
+	net->ipv6.fqdir->timeout_failed_udp = IPV6_REASM_TIMEOUT_FAILED_UDP * HZ;
+#endif
 
 	res = ip6_frags_ns_sysctl_register(net);
 	if (res < 0)
-- 
2.25.1

