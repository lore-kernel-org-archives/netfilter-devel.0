Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14496341057
	for <netfilter-devel@vger.kernel.org>; Fri, 21 Aug 2026 13:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787319719; cv=none; b=U6Dw0GLuvSDBRCyjtoKYyud8mDVHCyZZKZPOmRSB+NnHrkp1RDgO9jwvEW7XuEITVfy0CQiZhxxKqKs58CTBSyKqJfC6rzhvo9w43TNDj8gwutChl2nkRow38Ei5P7TLTvKgI2ainK1mfjllnM9FFhx1VNtEZv32xc08UormBYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787319719; c=relaxed/simple;
	bh=i4uEKM/UpRZlwBOtOhczj6t4tPuew/BpfFMouOuLA2I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=u11C4wg1VNI0FJNnua5ONytvxh4j2t2h/pMBGWR7IpKzymEL1Bux9Akn+7mIOPfPdqe535ZDQEEB1/77oyKD7d1A6BokXpyyjgPVenx6OWbxLx0TuBnOLRBGTyykLwBSSN6XoweNX2lb89iCf1439wHEwhe5hBtdpTQgYhMiHm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 3273260181; Fri, 21 Aug 2026 15:41:49 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>,
	Zhiling Zou <zhilinz@nebusec.ai>
Subject: [PATCH nf-next] netfilter: x_tables: reject missing '-p' flag and check for INV flag
Date: Fri, 21 Aug 2026 15:41:36 +0200
Message-ID: <20260821134136.18191-1-fw@strlen.de>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ip6tables traverser doesn't walk ipv6 extension headers unless the PROTO
flag is set, so direct sockopt-users can bypass the check (ip6tables
always sets it if '-p' flag is given.  This is a cleanup patch, it
doesn't fix any real bug.

Reported-by: Zhiling Zou <zhilinz@nebusec.ai>
Fixes: 74f77a6b2b1c ("netfilter: introduce l2tp match extension")
Fixes: af0d29cd2a73 ("netfilter: xtables: add an IPv6 capable version of the ECN match")
Fixes: a89ecb6a2ef7 ("[NETFILTER]: x_tables: unify IPv4/IPv6 multiport match")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Can also be applied to nf, but I don't think this one is urgent.

 net/netfilter/xt_ecn.c       |  3 ++-
 net/netfilter/xt_l2tp.c      | 11 +++++++----
 net/netfilter/xt_multiport.c |  3 +++
 3 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/xt_ecn.c b/net/netfilter/xt_ecn.c
index a8503f5d26bf..008e7fcbeb22 100644
--- a/net/netfilter/xt_ecn.c
+++ b/net/netfilter/xt_ecn.c
@@ -139,7 +139,8 @@ static int ecn_mt_check6(const struct xt_mtchk_param *par)
 		return -EINVAL;
 
 	if (info->operation & (XT_ECN_OP_MATCH_ECE | XT_ECN_OP_MATCH_CWR) &&
-	    (ip->proto != IPPROTO_TCP || ip->invflags & IP6T_INV_PROTO)) {
+	    (!(ip->flags & IP6T_F_PROTO) ||
+	     ip->proto != IPPROTO_TCP || ip->invflags & IP6T_INV_PROTO)) {
 		pr_info_ratelimited("cannot match TCP bits for non-tcp packets\n");
 		return -EINVAL;
 	}
diff --git a/net/netfilter/xt_l2tp.c b/net/netfilter/xt_l2tp.c
index a61eb81e9f49..ad2d559caa99 100644
--- a/net/netfilter/xt_l2tp.c
+++ b/net/netfilter/xt_l2tp.c
@@ -267,8 +267,9 @@ static int l2tp_mt_check4(const struct xt_mtchk_param *par)
 	if (ret != 0)
 		return ret;
 
-	if ((ip->proto != IPPROTO_UDP) &&
-	    (ip->proto != IPPROTO_L2TP)) {
+	if (ip->invflags & IPT_INV_PROTO ||
+	    (ip->proto != IPPROTO_UDP &&
+	    ip->proto != IPPROTO_L2TP)) {
 		pr_info_ratelimited("missing protocol rule (udp|l2tpip)\n");
 		return -EINVAL;
 	}
@@ -294,8 +295,10 @@ static int l2tp_mt_check6(const struct xt_mtchk_param *par)
 	if (ret != 0)
 		return ret;
 
-	if ((ip->proto != IPPROTO_UDP) &&
-	    (ip->proto != IPPROTO_L2TP)) {
+	if (((ip->flags & IP6T_F_PROTO) == 0 ||
+	     ip->invflags & IP6T_INV_PROTO ||
+	   (ip->proto != IPPROTO_UDP &&
+	    ip->proto != IPPROTO_L2TP))) {
 		pr_info_ratelimited("missing protocol rule (udp|l2tpip)\n");
 		return -EINVAL;
 	}
diff --git a/net/netfilter/xt_multiport.c b/net/netfilter/xt_multiport.c
index a1691ff405d3..48aa25749063 100644
--- a/net/netfilter/xt_multiport.c
+++ b/net/netfilter/xt_multiport.c
@@ -160,6 +160,9 @@ static int multiport_mt6_check(const struct xt_mtchk_param *par)
 	const struct ip6t_ip6 *ip = par->entryinfo;
 	const struct xt_multiport_v1 *multiinfo = par->matchinfo;
 
+	if (!(ip->flags & IP6T_F_PROTO))
+		return -EINVAL;
+
 	if (!check(ip->proto, ip->invflags, multiinfo->flags, multiinfo->count))
 		return -EINVAL;
 
-- 
2.54.0

