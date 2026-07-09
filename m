Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D9C13859D7
	for <netfilter-devel@vger.kernel.org>; Thu,  9 Jul 2026 11:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783597241; cv=none; b=k4mtZIA3amOQ3lwI/Sazm5NxTerQfuSKu84qeFTKzdHG+XsqYnlBQ7oJzo0G7Ng4tduue7SzZpcnUYXZHlM0396DRK6QNK4kX3fwMLDrlp6sDVmcao44O70zM/SCDi3V9IHYRLDtVuUpbqJkRhyK3LIXHsdav68OHV+bizdQPhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783597241; c=relaxed/simple;
	bh=jhOXFRDhRDE9UWehd+Ep5Rn4mlTjoYo/MLMzmXqFtU4=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=a9CButd/B+WSMwf1yVulo9bRgBlM+sh2DLPV2zOh4AxJtlYaxawyqhVcaXMx+zaL5lsl9juX0a0nStoJKZEW1jI1hM+MIBHM25ngkweGoIKFBCqNrJu4V9GLEYvAUd1KK1wqiVNIliUxPLbdxgxNiQ9jJYwGtf0f4hh3BBALsYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=jeWqdXWL; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="jeWqdXWL"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 73F6D6057E
	for <netfilter-devel@vger.kernel.org>; Thu,  9 Jul 2026 13:40:29 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1783597229;
	bh=BwRsCYCT+NIINNC1MMc6JKO8sohapTYaZBwEF761hFY=;
	h=From:To:Subject:Date:From;
	b=jeWqdXWLp5Z9fF1n5xisEyXqA/VEbeQTCOmzippKRawghEkTxq7vuwFkyAZWJsfgs
	 FPV1uBJY+J7tdDqX+yv/+GCjTFxBRL6R2R/+Qq5pu1Zz2WlJzLy0juuqbx8wHq0v44
	 I1nK+ehHlLaqb3CMx0Bn3KebDuWLbSuPa4QEiARpAoWsZ1qJn5NcBEpXbgN2ccaCyd
	 Zl2gwRVKEzyYFDi765zG22SrRUaU4SwDhORBuR6/kUM3apZFrWzS8uj91CPsUHjSk5
	 w8j0SqYgOiMY3WcyX7UcfGdshNpQK/zHn16OENFGlYPjACWshHWvdMFUd8ETvWo9xT
	 tmAUsq1ktReSA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf] netfilter: flowtable: use correct direction to set up tunnel route
Date: Thu,  9 Jul 2026 13:40:25 +0200
Message-ID: <20260709114025.1294044-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The layer 2 encapsulation and layer 3 tunnel information in the xmit
path is taken from the other tuple, because the tunnel information that
is included in the tuple for hashtable lookups is also used to perform
the egress encapsulation in the transmit path.

This patch uses the correct direction when setting up the tunnel, the
original proposed patch to address this fix uses the reversed direction.

While at it, remove the redundant check to call dst_release() to drop
the reference on the dst that was obtained from the forward path, which
is not useful in the direct xmit path unless tunneling is performed.

Fixes: fa7395c02d95 ("netfilter: flowtable: support IPIP tunnel with direct xmit")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 2a829b5e8240..b66e65439341 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -127,18 +127,18 @@ static int flow_offload_fill_route(struct flow_offload *flow,
 
 	switch (route->tuple[dir].xmit_type) {
 	case FLOW_OFFLOAD_XMIT_DIRECT:
-		if (flow_tuple->tun_num) {
+		if (route->tuple[!dir].in.num_tuns) {
 			flow_tuple->dst_cache = dst;
 			flow_tuple->dst_cookie =
 				flow_offload_dst_cookie(flow_tuple);
+		} else {
+			dst_release(dst);
 		}
 		memcpy(flow_tuple->out.h_dest, route->tuple[dir].out.h_dest,
 		       ETH_ALEN);
 		memcpy(flow_tuple->out.h_source, route->tuple[dir].out.h_source,
 		       ETH_ALEN);
 		flow_tuple->out.ifidx = route->tuple[dir].out.ifindex;
-		if (!flow_tuple->tun_num)
-			dst_release(dst);
 		break;
 	case FLOW_OFFLOAD_XMIT_XFRM:
 	case FLOW_OFFLOAD_XMIT_NEIGH:
-- 
2.47.3

