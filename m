Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794877996;
	b=tACSSzm9Dp+rrWvwiLDQeGn3gbv7iGTOWdnF9hY6LCT+GD68VzMm2X/LzCkYuOH1n1Tz
	 NVYP5YgeILIaRdo/oqltZl69ouALzkPwxtDehHSuMBha5YCJ+3D5frq+GlSZFeCCDpzDj
	 IYM73bYMgkPiXrwQE7XESzZQGodF1kUS+0OAiUsNTOUndrZaSkssBxNoWievmV9A/1p7s
	 Oa0KsazlOfknBkweP7amz1/P7eAKg5t/XNeNY5AUpwre2kRvzP9gKjT8mLIGmp9Wd85rF
	 Y2hYodbQJ+KlznUfUsKiCmeHRTySHz8LcdfSkpaRsD2HBtMcmoyImrbU5wAQSYQaXuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794877996;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-Spam-Status:X-Spam-Checker-Version;
	bh=HAs88HrSBlpEEfBYYk/FLGjD9hbqcMWliB7fh09BqL8=;
	b=YxXSiHGh6ZKkNvLKyW02Lf04LR0q4jfX5XffSUJ47HKwYteq/EWdc6Beqm+CbEEyCVeP
	 /b668n1cpkmpDbSFPKoOl+H/hlJLvlTCDaupzcss9PT8pM72Iu071WcDj6xY3qRp4cbKR
	 0RG/XbkN10RVaCTN26pECSOIQVlTx05QuY6fJC1nuqNOXbhVyct+PvmSIkVUoOZsINUkO
	 wasUlhK95h4rkLhryF/5ew6rcz2FAEFRNWm2CNZrhYjAl7kwfbIgQuGwT7hyPJtMDJZiR
	 5F/Xe6TAVmDmWPDW160Dop+qFc0CWSP3ioGK2LJpgPKTpcJXNojnnfbULGJQhlJ1zrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=pVtTO9El;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9902606A31C
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Nov 2026 01:13:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E9902606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=pVtTO9El
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794877986;
	bh=HAs88HrSBlpEEfBYYk/FLGjD9hbqcMWliB7fh09BqL8=;
	h=From:To:Cc:Subject:Date:From;
	b=pVtTO9ElHJw0HwEKfLESwNAREkGqj6Kai1RMVT8kdux+N0wgzkSSl7P7oUxJOHwNS
	 uq8nKZx+Zl4tB3hFW+J6v2S3H2sZ/DgeZHEx5uigh4Yga4JDdNd4uG1GXPllayLoPX
	 YVLgPBwbuYrIk0meeitVubZ8IZET6jYf7cb67Co2ODU4TCEVqWBlMsWA+7dw94NJjG
	 OgSP3boqP3EoGw6fRWYo5ZvccRGQ2/ko+WmzaVOtY3Jp31tvuIxd3wvjuy15uQCR1S
	 Zaug+jBM/GuMc0gk/tFg6ivMV5ryrZgRfh1+NOyvZoWyv7IvYvBfuXofdHoacr6plh
	 S2cek6VkQ1V9A==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id EDE7560057;
	Tue, 17 Nov 2026 02:13:05 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: shffr@protonmail.com
Subject: [PATCH nf-next 1/2] netfilter: flowtable: remove redundant ifidx field in tuple output union
Date: Tue, 17 Nov 2026 02:12:47 +0100
Message-ID: <20261117011248.3004853-1-pablo@netfilter.org>
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
index 9bb46457c192..143bcfce3678 100644
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
index d5652e45ee04..57517712a0af 100644
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
index 78bba416dd5b..b265b5bd356b 100644
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

