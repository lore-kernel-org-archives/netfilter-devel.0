Received: from a3.inai.de (a3.inai.de [144.76.212.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F7F21AB506
	for <netfilter-devel@vger.kernel.org>; Thu,  3 Oct 2024 18:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.212.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727981828; cv=none; b=puFN4yw8X7h4zJYM3vfXY4aEClDgNOolwqv8qjOJ+5+XEZhYX3gxq+AP35EC/vOFrF187Opo5mX8s0yOWI374NaoB8yWGdmVTioU5NHWCgEac2exkdY1M1Not4LsxIb2c8IDMb3vU4RI/8/fBH+TOoVw3FqceoX6Wu3+wIttSFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727981828; c=relaxed/simple;
	bh=NrGyKcI8Uhc4TaixU7kdkIJzi4FSZCtcVHabJ51ZBBU=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=MpflJaG4xbMtxT1rwf/IzbsajgGAFodzhguQPvELv3lgd7ximBSFopHGPZWOe6pBmLwOstUKTSX9k42CpEi/B1qo10He5AzsycsAkGH6RfRlp0Ke4yBOcA7GdDMr2LJu9l3cTEM4U04UUwovWuls7l4ziezmf7gVhO1vXjeiR8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de; spf=fail smtp.mailfrom=inai.de; arc=none smtp.client-ip=144.76.212.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=inai.de
Received: by a3.inai.de (Postfix, from userid 25121)
	id E6D83100448A49; Thu,  3 Oct 2024 20:50:12 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by a3.inai.de (Postfix) with ESMTP id E52541100A8C0F;
	Thu,  3 Oct 2024 20:50:12 +0200 (CEST)
Date: Thu, 3 Oct 2024 20:50:12 +0200 (CEST)
From: Jan Engelhardt <ej@inai.de>
To: Florian Westphal <fw@strlen.de>
cc: netfilter-devel@vger.kernel.org, syzkaller-bugs@googlegroups.com, 
    syzbot+256c348558aa5cf611a9@syzkaller.appspotmail.com
Subject: Re: [PATCH nf] netfilter: xt_cluster: enable ebtables operation?
In-Reply-To: <20241003183053.8555-1-fw@strlen.de>
Message-ID: <0n89n176-p660-1953-3sn7-0q4rn8359sso@vanv.qr>
References: <20241003183053.8555-1-fw@strlen.de>
User-Agent: Alpine 2.26 (LSU 649 2022-06-02)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII


On Thursday 2024-10-03 20:30, Florian Westphal wrote:
>
>Module registers to NFPROTO_UNSPEC, but it assumes ipv4/ipv6 packet
>processing.  As this is only useful to restrict locally terminating
>TCP/UDP traffic, reject non-ip families at rule load time.
>
>@@ -124,6 +124,14 @@ static int xt_cluster_mt_checkentry(const struct xt_mtchk_param *par)
> 	struct xt_cluster_match_info *info = par->matchinfo;
> 	int ret;
> 
>+	switch (par->family) {
>+	case NFPROTO_IPV4:
>+	case NFPROTO_IPV6:
>+		break;
>+	default:
>+		return -EAFNOSUPPORT;
>+	}

I wonder if we could just implement the logic for it.
Like this patch [untested!]:


From d534984879b9b3c4b8cf536cad1044c29b843a2d Mon Sep 17 00:00:00 2001
From: Jan Engelhardt <jengelh@inai.de>
Date: Thu, 3 Oct 2024 20:49:02 +0200
Subject: [PATCH] xt_cluster: add logic for use from NFPROTO_BRIDGE

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 net/netfilter/xt_cluster.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/net/netfilter/xt_cluster.c b/net/netfilter/xt_cluster.c
index a047a545371e..cf4a74d68577 100644
--- a/net/netfilter/xt_cluster.c
+++ b/net/netfilter/xt_cluster.c
@@ -68,6 +68,9 @@ xt_cluster_is_multicast_addr(const struct sk_buff *skb, u_int8_t family)
 	case NFPROTO_IPV6:
 		is_multicast = ipv6_addr_is_multicast(&ipv6_hdr(skb)->daddr);
 		break;
+	case NFPROTO_BRIDGE:
+		is_multicast = is_multicast_ether_addr(eth_hdr(skb)->h_dest);
+		break;
 	default:
 		WARN_ON(1);
 		break;
@@ -124,6 +127,15 @@ static int xt_cluster_mt_checkentry(const struct xt_mtchk_param *par)
 	struct xt_cluster_match_info *info = par->matchinfo;
 	int ret;
 
+	switch (par->family) {
+	case NFPROTO_IPV4:
+	case NFPROTO_IPV6:
+	case NFPROTO_BRIDGE:
+		break;
+	default:
+		return -EAFNOSUPPORT;
+	}
+
 	if (info->total_nodes > XT_CLUSTER_NODES_MAX) {
 		pr_info_ratelimited("you have exceeded the maximum number of cluster nodes (%u > %u)\n",
 				    info->total_nodes, XT_CLUSTER_NODES_MAX);
-- 
2.46.1

