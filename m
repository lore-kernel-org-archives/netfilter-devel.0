Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E14143F823E;
	Fri, 10 Jul 2026 13:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.224
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783689577; cv=none; b=eg/rBTkadA0YycdFXADKqEKdXWydbpWK/5yd5pRZB8pKg3htcBSOsz5dLfswp7vjFuaVfkRydl9y59H4uwsY1ysvf/CRA6MQh0bL7B4LkHpiFusfbisVwq7aQB2+dcWtYLxC3ZlCW3+AM6MGE2PqJrD9YJqiFJZzV/tZMdHWxT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783689577; c=relaxed/simple;
	bh=IU69ZUkHrELWZnUZ4ETZ933K+ZtaQr725O+7PVTc3tM=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=pOKoqSC2sHyPH2SsVfH0uLTiQMiahiwmJxuM3Trxrxzpfc9as6AUVbJjT/jiB6LojNqK9l5Kp3oZOR+qJLzYsxTPidKMqUpjaylEwo3rlYfKBnduuzGuINsqwG2mMBiqUmVlJquVzZq2LH3A0NCsdbVYNm13o7s12wknBHZJ6pM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=h-partners.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=ZhmmC7o5; arc=none smtp.client-ip=113.46.200.224
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=h-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="ZhmmC7o5"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=FwOB4aNUmcbe/Vp+PkAjDobNppCtF1ztgspFdovc6pM=;
	b=ZhmmC7o5aQWKY/lXT+Jjp/w4zAhrDgAcFl3LnROQ1ub6c2NsRyyOFupkhA93VqPsx/XlMs0SA
	VVVHMMAaCykv6FGJivyUFuQlaEoFu7YHmC1tIypgKf0S0WElKHqymtOEIgck/BRWPR3RFfLyGTX
	0KJw3VN1FMLfAgXD+PElAT8=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4gxXHf6Byjz1cyP2;
	Fri, 10 Jul 2026 21:10:06 +0800 (CST)
Received: from kwepemr100001.china.huawei.com (unknown [7.202.195.168])
	by mail.maildlp.com (Postfix) with ESMTPS id C449240563;
	Fri, 10 Jul 2026 21:19:20 +0800 (CST)
Received: from huawei.com (10.50.159.234) by kwepemr100001.china.huawei.com
 (7.202.195.168) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Fri, 10 Jul
 2026 21:19:19 +0800
From: xietangxin <xietangxin@h-partners.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>,
	"David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Phil Sutter <phil@nwl.cc>, Simon Horman <horms@kernel.org>,
	<netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Victor Nogueira
	<victor@mojatatu.com>, gaoxingwang <gaoxingwang1@huawei.com>, huyizhen
	<huyizhen2@huawei.com>, xietangxin <xietangxin@h-partners.com>
Subject: [PATCH net v3] netfilter: nf_nat: recalculate TCP TS offset after SNAT port rewrite
Date: Fri, 10 Jul 2026 21:30:00 +0800
Message-ID: <20260710133000.3342718-1-xietangxin@h-partners.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
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

After nf_nat_inet_fn() successfully assigns a new randomized
source port, recalculate the TS offset using the new port and
update the SYN packet's TSval accordingly.

Test results on 4U4G VM with
`./wrk -t8 -c200 -H "Connection: close" -d10s --latency http://5.5.5.5:80`
Before:
  random:10712 req/s, random-fully:10986 req/s
After:
  random:20530 req/s, random-fully:19511 req/s

Fixes: 165573e41f2f ("tcp: secure_seq: add back ports to TS offset")
Cc: stable@vger.kernel.org
Closes:https://lore.kernel.org/all/92935c00-e0be-4591-ac44-5978c7804d57@yeah.net/
Signed-off-by: xietangxin <xietangxin@h-partners.com>
---
v3:
  - Add skb_ensure_writable check before munge packet and some comments.
  - Use get/put_unaligned_be32() op tsval and update tcp checksum.
  - Reorder variables to follow the reverse xmas tree style.
  - Keep the helper in POST_ROUTING since MASQUERADE runs there, and 
    move `if (!skb->sk)` to the very beginning.

v2: https://lore.kernel.org/all/20260709131216.2189210-1-xietangxin@h-partners.com/
  - Move the new helper in the IP_CT_NEW case of nf_nat_inet_fn().
  - Fix a compilation failure when CONFIG_IPV6 is disabled.

v1: https://lore.kernel.org/all/20260629093408.3927103-1-xietangxin@h-partners.com/ 
---
 net/netfilter/nf_nat_core.c | 116 +++++++++++++++++++++++++++++++++++-
 1 file changed, 115 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 63ff6b4d5d21..01836ad70b0f 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -16,6 +16,8 @@
 #include <linux/siphash.h>
 #include <linux/rtnetlink.h>
 
+#include <net/tcp.h>
+#include <net/secure_seq.h>
 #include <net/netfilter/nf_conntrack_bpf.h>
 #include <net/netfilter/nf_conntrack_core.h>
 #include <net/netfilter/nf_conntrack_helper.h>
@@ -894,6 +896,112 @@ static bool in_vrf_postrouting(const struct nf_hook_state *state)
 	return false;
 }
 
+static unsigned char *nf_nat_tcp_ts_option_ptr(struct sk_buff *skb)
+{
+	unsigned int optlen, offset;
+	unsigned char opsize;
+	unsigned char opcode;
+	unsigned char *ptr;
+	struct tcphdr *th;
+
+	if (skb_ensure_writable(skb, tcp_hdrlen(skb)))
+		return NULL;
+
+	offset = 0;
+	th = tcp_hdr(skb);
+	optlen = tcp_optlen(skb);
+	ptr = (unsigned char *)(th + 1);
+
+	while (offset < optlen) {
+		opcode = ptr[offset];
+		if (opcode == TCPOPT_EOL)
+			break;
+
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
+			return ptr + offset + 2;
+
+		offset += opsize;
+	}
+
+	return NULL;
+}
+
+/* Update TCP TS offset for local packets after SNAT port rewrite */
+static void nf_nat_update_tcp_ts_offset(struct nf_conn *ct, struct sk_buff *skb)
+{
+	struct nf_conntrack_tuple *reply_tuple;
+	struct nf_conntrack_tuple *orig_tuple;
+	union tcp_seq_and_ts_off st;
+	unsigned char *tsptr;
+	struct tcp_sock *tp;
+	struct tcphdr *th;
+	struct net *net;
+	u32 old_ts, new_ts;
+
+	if (!skb->sk)
+		return;
+
+	orig_tuple = &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple;
+	reply_tuple = &ct->tuplehash[IP_CT_DIR_REPLY].tuple;
+
+	/* No port rewrite? No need to update anything */
+	if (orig_tuple->src.u.tcp.port == reply_tuple->dst.u.tcp.port)
+		return;
+
+	th = tcp_hdr(skb);
+	if (!th || !th->syn || th->ack)
+		return;
+
+	net = nf_ct_net(ct);
+
+	/* Avoid bogus tsoff update for non-randomized tcp timestamps */
+	if (READ_ONCE(net->ipv4.sysctl_tcp_timestamps) != 1)
+		return;
+
+	tsptr = nf_nat_tcp_ts_option_ptr(skb);
+	if (!tsptr)
+		return;
+
+	switch (nf_ct_l3num(ct)) {
+	case NFPROTO_IPV4:
+		st = secure_tcp_seq_and_ts_off(net, reply_tuple->dst.u3.ip,
+					       reply_tuple->src.u3.ip,
+					       reply_tuple->dst.u.tcp.port,
+					       reply_tuple->src.u.tcp.port);
+		break;
+#if IS_ENABLED(CONFIG_IPV6)
+	case NFPROTO_IPV6:
+		st = secure_tcpv6_seq_and_ts_off(net, reply_tuple->dst.u3.ip6,
+						 reply_tuple->src.u3.ip6,
+						 reply_tuple->dst.u.tcp.port,
+						 reply_tuple->src.u.tcp.port);
+		break;
+#endif
+	default:
+		return;
+	}
+
+	tp = tcp_sk(skb->sk);
+	old_ts = get_unaligned_be32(tsptr);
+	new_ts = tcp_skb_timestamp_ts(tp->tcp_usec_ts, skb) + st.ts_off;
+	put_unaligned_be32(new_ts, tsptr);
+	inet_proto_csum_replace4(&th->check, skb, cpu_to_be32(old_ts),
+				 cpu_to_be32(new_ts), false);
+	WRITE_ONCE(tp->tsoffset, st.ts_off);
+}
+
 unsigned int
 nf_nat_inet_fn(void *priv, struct sk_buff *skb,
 	       const struct nf_hook_state *state)
@@ -937,8 +1045,14 @@ nf_nat_inet_fn(void *priv, struct sk_buff *skb,
 						       state);
 				if (ret != NF_ACCEPT)
 					return ret;
-				if (nf_nat_initialized(ct, maniptype))
+				if (nf_nat_initialized(ct, maniptype)) {
+					if (state->hook == NF_INET_POST_ROUTING &&
+					    nf_ct_protonum(ct) == IPPROTO_TCP &&
+					    (ct->status & IPS_SRC_NAT)) {
+						nf_nat_update_tcp_ts_offset(ct, skb);
+					}
 					goto do_nat;
+				}
 			}
 null_bind:
 			ret = nf_nat_alloc_null_binding(ct, state->hook);
-- 
2.43.0

