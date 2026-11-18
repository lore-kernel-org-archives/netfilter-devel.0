Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042201;
	b=Wp+D1m3XUk6nvRAL9XWboRCOfCeDgz6r0G865sbEmyj4eYtJavJ0JA3SdDc2V3cWNqZU
	 PzquV+mqyXAFQSfv7vHhQjqj5+XmlTidF4eGCPBEJYEfJ5hYjy9uCIwL2IziBdT1wm/c3
	 YPPHWlPCetKzMMQrSl7cvmWJ0VrlwofEJCwxAGKcvnZZ+zpIdXs6L3owWUas81APcm9V0
	 jZYRtLXf98IYQFTgc/jmZ2JV7E+kaboMZBd+dwHZclxCt3Yk+3aqOYI7etJ8RErob4isd
	 OiGBZZkdrF1wfsgkxt+J2e6T7tqXmlu61BkH+tMxauQ1SAi8fFJPGu7crw+yTsmqvxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042201;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding:X-Spam-Status:
	 X-Spam-Checker-Version;
	bh=BXGSzrViwahBqXK7uofR3YELpGaD7/R86NPm9GdDwts=;
	b=w6+iNnl9VApJOJkU01sc62YlFaBQjLoEeZb3uYK+rr1NoRCTo082hrEIswko5fp6Od3H
	 QIZ3y7auDPbpsmt4lXtYdR5F/0MBn7IDL166S6kuneiI2jjnFZdBLl0aldbfkMlQZrsRH
	 Qa0JPQEWyIDSOtjSScCccX1WkyhxKWnTNooYprqDXqu/2Q7aMMdUWQj3T2rIGVZJTGt65
	 CtOSnil718dXmrAK2HutMszlU1hWXs8IZB9ihyqVmNfwqeZt5HJXAaXTWHavuCavu1hmv
	 ChZY0R/JpKDqxpyJsChb6E4CcSdQAcGU9DjkIRtcWOyQPCLBW8ouFRx1J2XovTLgVtw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=MqyrnlWw;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48131606A320
	for <netfilter-devel@vger.kernel.org>; Wed, 18 Nov 2026 22:49:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 48131606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=MqyrnlWw
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1795042197;
	bh=BXGSzrViwahBqXK7uofR3YELpGaD7/R86NPm9GdDwts=;
	h=From:To:Subject:Date:From;
	b=MqyrnlWw8noTXoukwysjZbef33I8u/besM+NZAg/jQ9bIDM2Ih+2FHWJ2rjdU63aU
	 nO/nOwosg38FSfAmAZYitk769zStgSV2hjxrauWigJTKpBpj0RiysEmme84wXBm/8h
	 3ZuCuHdl7N32qePQGKX9HmjCopcnpd/XnSrOQlY1LVQBXyaPCsNNA1532AEZcmOReB
	 Y/WLQhuBMz3YYDio/d8Jaxyx08/WYupAG9ZVzKiNsiUEJ01oISiKOs2TlXZ4NwKdrG
	 7MItlYK4l+DVonIHlQFdax7rDL0k1uTrOJy0NUJhyzIqXUxG2Zs2K2d2bjwhMwvrOO
	 tJK4I6WncuGDA==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 0A8686007E
	for <netfilter-devel@vger.kernel.org>; Wed, 18 Nov 2026 23:49:56 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v2 1/3] netfilter: flowtable: remove redundant ifidx field in tuple output union
Date: Wed, 18 Nov 2026 23:49:51 +0100
Message-ID: <20261118224953.3279190-1-pablo@netfilter.org>
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

