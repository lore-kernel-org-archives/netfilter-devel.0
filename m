Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 659593F8EDE;
	Mon, 29 Jun 2026 09:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782725020; cv=none; b=i219GvF+LiJtE5toHZJyIsYIZJKMC4qKo3MjcYWe/+BM4Zm55VzOuTXG4zYNPAeUbPDzYcN77HA1hjlRU5u9ZRD+BE3X1Eyuk6MIM066EmlswIKJiTRH7SCG9s8AIjlBLYBLzuiZBEUa4uPYQZhNkeD8XyW5gTgacf3Oh0/oe20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782725020; c=relaxed/simple;
	bh=NOinlIUHK1O7KsV8/Sws+CeKyYdx2R8D9bQpxtImFts=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ZcMbnGtE8E8Ot+Fz2WpwJ8iouEq9odDP60tjdIOimugy8f4cU7OMGetsnNCmhTAkbhUyNb7zF+p1jwpyi56YSgu7NR+NVc80hNlfpYinkBhlmH+GJJzuwqMNnqf+qcScV9Zp0eAhSpbnFPeBLr05jrtisiGcm7tOx22magRu5cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=h-partners.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=jeUP7WDj; arc=none smtp.client-ip=113.46.200.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=h-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="jeUP7WDj"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=G2M8dDHxD+jz6xgmK0NGrGGjxPFhsJR72vzpL2rXGAg=;
	b=jeUP7WDjEepo3brfJMCRdy1wLlb/PDs6Ih+yaMuvj7+GJo/FHzp8clzSgCltX7I5GbJD6d/cz
	t/Wl56isEll41nk/w6Gk//1zIDW2YyVs6xSlbUMwNO1W37YQYXtGhLrA+kzzvqiApWOPh0CB8S3
	tM1tkkiIa+o4+jdSctm3Ivc=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4gpgbS6gYtzpSyh;
	Mon, 29 Jun 2026 17:15:00 +0800 (CST)
Received: from kwepemr100001.china.huawei.com (unknown [7.202.195.168])
	by mail.maildlp.com (Postfix) with ESMTPS id 363204057D;
	Mon, 29 Jun 2026 17:23:25 +0800 (CST)
Received: from huawei.com (10.50.159.234) by kwepemr100001.china.huawei.com
 (7.202.195.168) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Mon, 29 Jun
 2026 17:23:24 +0800
From: xietangxin <xietangxin@h-partners.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>, "David S . Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, Simon Horman <horms@kernel.org>
CC: gaoxingwang <gaoxingwang1@huawei.com>, huyizhen <huyizhen2@huawei.com>,
	<netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<stable@vger.kernel.org>
Subject: [PATCH net] netfilter: nf_nat_masquerade: recalculate TCP TS offset when port is randomized
Date: Mon, 29 Jun 2026 17:34:08 +0800
Message-ID: <20260629093408.3927103-1-xietangxin@h-partners.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemr100001.china.huawei.com (7.202.195.168)

Problem observed in Kubernetes environments where MASQUERADE target with
--random-fully is configured by default. after commit
165573e41f2f ("tcp: secure_seq: add back ports to TS offset") TCP short
connection QPS dropped from ~20000 to ~10000. This added source and
destination ports into TS offset calculation.

However, with MASQUERADE --random-fully, when multiple internal connections
(e.g sport 10000,20000) are mapped to the same external port (e.g 30000),
their TS offsets are calculated as ts_offset(10000) and ts_offset(20000).
If the server reuses the TIME_WAIT slot from the first connection, there is
a chance that ts_offset(20000) < ts_offset(10000), breaking TSval
monotonicity for the same 4-tuple and causing RST packets:
  Client -> Server 24870 -> 80 [SYN] TSval=2294041168
  Server -> Client 80 -> 24870 [ACK] TSecr=2846236456
  Client -> Server 24870 -> 80 [RST] Seq=855605690

After nf_nat_setup_info() successfully assigns a new randomized
source port, recalculate the TS offset using the new port and
update the SYN packet's TSval accordingly.

Test results on 4U4G VM with
`./wrk -t8 -c200 -H "Connection: close" -d10s --latency http://5.5.5.5:80`
Before:
  random:10712 req/s, random-fully:10986 req/s
After:
  random:21463 req/s, random-fully:19181 req/s

Fixes: 165573e41f2f ("tcp: secure_seq: add back ports to TS offset")
Cc: stable@vger.kernel.org
Closes:https://lore.kernel.org/all/92935c00-e0be-4591-ac44-5978c7804d57@yeah.net/
Signed-off-by: xietangxin <xietangxin@h-partners.com>
---
 net/netfilter/nf_nat_masquerade.c | 91 ++++++++++++++++++++++++++++++-
 1 file changed, 89 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_nat_masquerade.c b/net/netfilter/nf_nat_masquerade.c
index 4de6e0a51701..8c9ca5a051cc 100644
--- a/net/netfilter/nf_nat_masquerade.c
+++ b/net/netfilter/nf_nat_masquerade.c
@@ -6,8 +6,11 @@
 #include <linux/netfilter.h>
 #include <linux/netfilter_ipv4.h>
 #include <linux/netfilter_ipv6.h>
+#include <linux/tcp.h>
 
+#include <net/tcp.h>
 #include <net/netfilter/nf_nat_masquerade.h>
+#include <net/secure_seq.h>
 
 struct masq_dev_work {
 	struct work_struct work;
@@ -24,6 +27,76 @@ static DEFINE_MUTEX(masq_mutex);
 static unsigned int masq_refcnt __read_mostly;
 static atomic_t masq_worker_count __read_mostly;
 
+static __be32 *tcp_ts_option_ptr(const struct sk_buff *skb)
+{
+	const struct tcphdr *th;
+	unsigned char *ptr;
+	unsigned char opsize;
+	unsigned int optlen, offset;
+
+	th = tcp_hdr(skb);
+	optlen = (th->doff - 5) * 4;
+	ptr = (unsigned char *)(th + 1);
+	offset = 0;
+
+	while (offset < optlen) {
+		unsigned char opcode = ptr[offset];
+
+		if (opcode == TCPOPT_EOL)
+			break;
+		if (opcode == TCPOPT_NOP) {
+			offset++;
+			continue;
+		}
+
+		if (offset + 1 >= optlen)
+			break;
+
+		opsize = ptr[offset + 1];
+		if (opsize < 2 || offset + opsize > optlen)
+			break;
+
+		if (opcode == TCPOPT_TIMESTAMP && opsize == TCPOLEN_TIMESTAMP)
+			return (__be32 *)(ptr + offset + 2);
+
+		offset += opsize;
+	}
+
+	return NULL;
+}
+
+static void masquerade_update_tcp_ts_offset(struct nf_conn *ct, struct sk_buff *skb)
+{
+	__be32 *tsptr;
+	struct net *net;
+	struct tcphdr *th;
+	struct tcp_sock *tp;
+	union tcp_seq_and_ts_off st;
+	struct nf_conntrack_tuple *tuple;
+
+	th = tcp_hdr(skb);
+	net = nf_ct_net(ct);
+	tuple = &ct->tuplehash[IP_CT_DIR_REPLY].tuple;
+
+	if (th && th->syn && !th->ack && skb->sk &&
+	    READ_ONCE(net->ipv4.sysctl_tcp_timestamps) == 1) {
+		tp = tcp_sk(skb->sk);
+		tsptr = tcp_ts_option_ptr(skb);
+		if (!tsptr)
+			return;
+
+		if (nf_ct_l3num(ct) == NFPROTO_IPV4)
+			st = secure_tcp_seq_and_ts_off(net, tuple->src.u3.ip, tuple->dst.u3.ip,
+				tuple->src.u.tcp.port, tuple->dst.u.tcp.port);
+		else
+			st = secure_tcpv6_seq_and_ts_off(net, tuple->src.u3.ip6,
+				tuple->dst.u3.ip6, tuple->src.u.tcp.port, tuple->dst.u.tcp.port);
+
+		*tsptr = htonl(tcp_skb_timestamp_ts(tp->tcp_usec_ts, skb) + st.ts_off);
+		WRITE_ONCE(tp->tsoffset, st.ts_off);
+	}
+}
+
 unsigned int
 nf_nat_masquerade_ipv4(struct sk_buff *skb, unsigned int hooknum,
 		       const struct nf_nat_range2 *range,
@@ -35,6 +108,7 @@ nf_nat_masquerade_ipv4(struct sk_buff *skb, unsigned int hooknum,
 	struct nf_nat_range2 newrange;
 	const struct rtable *rt;
 	__be32 newsrc, nh;
+	unsigned int ret;
 
 	WARN_ON(hooknum != NF_INET_POST_ROUTING);
 
@@ -71,7 +145,13 @@ nf_nat_masquerade_ipv4(struct sk_buff *skb, unsigned int hooknum,
 	newrange.max_proto   = range->max_proto;
 
 	/* Hand modified range to generic setup. */
-	return nf_nat_setup_info(ct, &newrange, NF_NAT_MANIP_SRC);
+	ret = nf_nat_setup_info(ct, &newrange, NF_NAT_MANIP_SRC);
+
+	if (ret == NF_ACCEPT && nf_ct_protonum(ct) == IPPROTO_TCP &&
+	    (range->flags & NF_NAT_RANGE_PROTO_RANDOM_ALL))
+		masquerade_update_tcp_ts_offset(ct, skb);
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(nf_nat_masquerade_ipv4);
 
@@ -229,6 +309,7 @@ nf_nat_masquerade_ipv6(struct sk_buff *skb, const struct nf_nat_range2 *range,
 	struct in6_addr src;
 	struct nf_conn *ct;
 	struct nf_nat_range2 newrange;
+	unsigned int ret;
 
 	ct = nf_ct_get(skb, &ctinfo);
 	WARN_ON(!(ct && (ctinfo == IP_CT_NEW || ctinfo == IP_CT_RELATED ||
@@ -248,7 +329,13 @@ nf_nat_masquerade_ipv6(struct sk_buff *skb, const struct nf_nat_range2 *range,
 	newrange.min_proto	= range->min_proto;
 	newrange.max_proto	= range->max_proto;
 
-	return nf_nat_setup_info(ct, &newrange, NF_NAT_MANIP_SRC);
+	ret = nf_nat_setup_info(ct, &newrange, NF_NAT_MANIP_SRC);
+
+	if (ret == NF_ACCEPT && nf_ct_protonum(ct) == IPPROTO_TCP &&
+	    (range->flags & NF_NAT_RANGE_PROTO_RANDOM_ALL))
+		masquerade_update_tcp_ts_offset(ct, skb);
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(nf_nat_masquerade_ipv6);
 
-- 
2.43.0

