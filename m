Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795078206;
	b=CBxA927urMxir4SKRzH6DuIRikJGUhf5fecBkSm4jieLP5KPDbjrygM+KC9mrmtNk7sG
	 0NfYksNrNhpOLZOfR2bxgUJagDcaZkp5KY81u5D9wIYSZv4qDCpm1UX95+0vpjw2fz42/
	 4cTXMl/LOMlh9nWCGi0r3q7UuYtIwbOFoR4T8rpScbKFt2DCVMbqFLXg0Nmif1eD1AlUg
	 xcO5PJNioFd5mJyfbh9nUjiLpBFR62l90AuqQ8NuvcmaoARAc70Yi++mrJSsPNglTz1U4
	 TJ0P1KuSK7zPmlgvZqgQ3ug2HyaD/Qihgp/banQPIf74AXtywla+bMGvtCdGeMDSfYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795078206;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding:X-Spam-Status:
	 X-Spam-Checker-Version;
	bh=CAirTi2WOwL7kDyLTSpHwGGiQxU1YWeu9fkxpap83wk=;
	b=Z0vT0sww05wT5oYs4H3pwtA+sMgKXnKQJFJQUXI4KX4jU17y0lstNOx9/+SYAObiy+E4
	 MBH8nZPTWmmxXzxCP48lYAWO8ztLfXMyIeAijRtjgy5s8ms5I19Y+THRTFI+1NehfznBW
	 ziFLQ1xhHSziiKTpNm3LDPbnAZiH3RRvtKc5jz3rKF4Bichi61lYU5mCIS8GZMgpevGPJ
	 EniRevkL/lwXDPBD9jHuWVGGW4rJVdSa6XP7grbeIWntuRBZ8SXDkub/JmHuAZCAeG8DD
	 Pf1f9jXxKl2TSBEGgBzvYjz7bB207TipgYci2dl2XJGrS3ez2kHlA4Fhnx27Hit4Ocg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=BXN4soxT;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE34C606A320
	for <netfilter-devel@vger.kernel.org>; Thu, 19 Nov 2026 08:50:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DE34C606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=BXN4soxT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1795078203;
	bh=CAirTi2WOwL7kDyLTSpHwGGiQxU1YWeu9fkxpap83wk=;
	h=From:To:Subject:Date:From;
	b=BXN4soxToYcEbtgo4w4Bukmwnmhqvm5Ych1cGpwQIpv1tu6mAE7DCBDvsgEHZq2/L
	 DSvF4YWiePeAtm46HPFVHgUFChDBxYs9HnN8SRjDqqRGQLivJB/fL6ePDNHvv4DUyd
	 ajMpW3QXGX5z2I1nEHdNE4l7NwLpn//tvTstnaXQX27SdC/VbRlsDE+Ps1lPQ1yxrx
	 DmfxzGWwiJZKtXZaSukJzEDbN8UtW6HgzMrpLTJhjxoHoUmBGyOthGrL6OjnyXrBT+
	 eA22pua5bOCJxoyKO2d2fZ4HrGnLwjdpj9wE6bkqyJC00in0/UDSry8NgPUcqHmduK
	 xHehGhzbZNH+A==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 5560260573
	for <netfilter-devel@vger.kernel.org>; Thu, 19 Nov 2026 09:50:03 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v3 1/3] netfilter: flowtable: remove redundant ifidx field in tuple output union
Date: Thu, 19 Nov 2026 09:49:57 +0100
Message-ID: <20261119085000.3330145-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
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

The XMIT_NEIGH and XMIT_DIRECT types use an output ifidx field to
determine the destination netdevice. Remove the redundant ifidx field in
the flow_offload_tuple union that represents the output path, use the
existing struct.

No functional change, this is just a preparation patch.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v3: no changes

 include/net/netfilter/nf_flow_table.h | 3 ---
 net/netfilter/nf_flow_table_core.c    | 2 +-
 net/netfilter/nf_flow_table_ip.c      | 4 ++--
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 5b22d31cb140..61ac43b17dc9 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -160,9 +160,6 @@ struct flow_offload_tuple {
 	struct dst_entry		*dst_cache;
 
 	union {
-		struct {
-			u32		ifidx;
-		};
 		struct {
 			u32		ifidx;
 			u8		h_source[ETH_ALEN];
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 2aa2647ed9df..a7b4fc5766a9 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -142,7 +142,7 @@ static int flow_offload_fill_route(struct flow_offload *flow,
 		break;
 	case FLOW_OFFLOAD_XMIT_XFRM:
 	case FLOW_OFFLOAD_XMIT_NEIGH:
-		flow_tuple->ifidx = route->tuple[dir].out.ifindex;
+		flow_tuple->out.ifidx = route->tuple[dir].out.ifindex;
 		flow_tuple->dst_cache = dst;
 		flow_tuple->dst_cookie = flow_offload_dst_cookie(flow_tuple);
 		break;
diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 19cafae748ab..115c54ad4633 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -867,7 +867,7 @@ static int nf_flow_queue_xmit4(struct sk_buff *skb,
 	switch (tuplehash->tuple.xmit_type) {
 	case FLOW_OFFLOAD_XMIT_NEIGH:
 		rt = dst_rtable(tuplehash->tuple.dst_cache);
-		xmit.outdev = dev_get_by_index_rcu(state->net, tuplehash->tuple.ifidx);
+		xmit.outdev = dev_get_by_index_rcu(state->net, tuplehash->tuple.out.ifidx);
 		if (!xmit.outdev) {
 			flow_offload_teardown(flow);
 			return NF_DROP;
@@ -1196,7 +1196,7 @@ static int nf_flow_queue_xmit6(struct sk_buff *skb,
 	switch (tuplehash->tuple.xmit_type) {
 	case FLOW_OFFLOAD_XMIT_NEIGH:
 		rt = dst_rt6_info(tuplehash->tuple.dst_cache);
-		xmit.outdev = dev_get_by_index_rcu(state->net, tuplehash->tuple.ifidx);
+		xmit.outdev = dev_get_by_index_rcu(state->net, tuplehash->tuple.out.ifidx);
 		if (!xmit.outdev) {
 			flow_offload_teardown(flow);
 			return NF_DROP;
-- 
2.47.3

