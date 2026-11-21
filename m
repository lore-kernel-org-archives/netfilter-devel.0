Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795302401;
	b=VqQLObbvmD1wC4B7vHcKzv4yGzDEaYpEpH2O1CPnAd0Qbt9dSGUXd/2t3Qqt0Fn/5t72
	 x3VFMBqItyC+LtbtuCyOXPuJ3Hgw5W4rch+mmQ/IGcNQX+bIv3sIc4Y4pUiJaB5EdFzQc
	 IDieRBup44cyC5zv6kFmcdKFVw/mm6hdyAlMcZS/ZnJ8lI5o8oq1iFRrE9uWlXTGmFBZW
	 OhRua90c47esl3NvCgFKc3n5emG1axehFG2WBqPff9dwD2qzm2z5lts8v7q0azzDVp69F
	 3FneJwvj+hRCPjgYlUyoCdTpRixYeck1mWJjAmIzZxOWmDpn159Ei15XoKlundH9h3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795302401;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding:X-Spam-Status:
	 X-Spam-Checker-Version;
	bh=BNnTA0oxFqQORHoOtPT4U/WELmiL/ovPZLd8aPodLiM=;
	b=fMSSYdUZgGwDVQgklO1ppkkxXOxHC6aKOwxqxxo+SfnIXhL6UTFKleW/npFraGDIxycw
	 1YC4SS1uNfu2oAisdip9bI0a/nRwobrtw/7mguLRKxGv2HUUTqTS7Lk3O/wUf5UJcP9MU
	 2Avz2Kx6l7zRTLS1E7xQ4RzPGqt4jlqMPodnWOyj5aRVTFCyjw4lmJShl+oy9o0yaRqG0
	 XxJ97XJYQ8EdVYZ/74dO6FmXoOvI57TRsS0Vo77DCwmACr3g0PHw0Rc7rqHrLX/mw44d1
	 FxUjzabRPyt8ZAqaUOtOyEEvwzSAofIf/Mzes5gpIpsfi8iqdgl1MaXqwyRrMuPkL7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=hL46OYUB;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1622606A320
	for <netfilter-devel@vger.kernel.org>; Sat, 21 Nov 2026 23:06:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D1622606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=hL46OYUB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1795302393;
	bh=BNnTA0oxFqQORHoOtPT4U/WELmiL/ovPZLd8aPodLiM=;
	h=From:To:Subject:Date:From;
	b=hL46OYUBQiAlS5ADJACX4+Cfa5PvA6qEk1C1JQeKr5PeAdQoS5v/JwfRrghJGfS7/
	 BbmymRF9KrxwQhoyIkBsJYlPTlk88hjLqK7UxjRcqsl9ye2HoeBJHpdkOv+yo8q9kD
	 FFt/q3JVl06cThbef8/0jPvXgdJkMEHVYgGjEfZ6TGA23QKtWVA7Htq8v84EjYse7K
	 7s8spLMClKJZjD2uYUdivW0kZQpJbswmBCvqT3Ftfd/P/36zMAfGbi3bnHE6iYmyqE
	 O+4mzjwy8HJp/AH0cq/IJ2pPDSBHxxRXGs4SeqGRHnnaNadA8HifPBJsPDGRlfXSX0
	 cEIZmw1N+/AIQ==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 06A1E60074
	for <netfilter-devel@vger.kernel.org>; Sun, 22 Nov 2026 00:06:32 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v7 1/3] netfilter: flowtable: remove redundant ifidx field in tuple output union
Date: Sun, 22 Nov 2026 00:06:27 +0100
Message-ID: <20261121230629.3744139-1-pablo@netfilter.org>
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
v7: no changes

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

