Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7881C494809
	for <netfilter-devel@vger.kernel.org>; Fri, 21 Aug 2026 13:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787319015; cv=none; b=HVcTmY6yiDWYjxT4zRBVSf6a5J/t5cyeXQDssdiGHY8Ju3krjYzsVadp2SVnUq9e7VlIqVM6CmZBiul5ttp3+hhVRFXRcP3krF2Kp/9m8boN4P8qTs9vEhSkNeYVfWInexeVv/O+85iH7nX7AZ3mbQUeJVqN/wOKGPeiJzA81s0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787319015; c=relaxed/simple;
	bh=9GLDLaDk1D2e+9CwvI77yOR3VtEoIBWAyGEaVZLC1bs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qpU99EwiJgAIUsDoANg9QrECo8QrvRJswKTi1osFJGXqBfIoc9a9dR4uGpJzfOz6DCYZd9Z9zw0W9tC+cX2amApHHzIzuButEAs+GoPGTXmwhwAxUI2jeWxBTZ4nRZXztzTjXCQ7maVjpPR6cI3F1HU1DnbetsHBz3ADUXL1Scc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=WX6JCLra; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="WX6JCLra"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1787319010;
	bh=vITNVFSOLWnVb2Sr+f7FIAjbvsc4G072AvU70+ZMrLo=;
	h=From:To:Cc:Subject:Date:From;
	b=WX6JCLraPoD4Y5r/tpUz5O6rAB+vmWmtpcjUKR+20OSFJuZB6DV1SgYpXQtXZhEXk
	 swWq4sVS9DR6G1lf4PWJtK6y17neYfGE+doKBYrjBU7zTT6n7XDMHgVVogp7iCIvpS
	 69ZMPihHCoWx9K0TKXU3rcASFTgq3C/ypNM22p4KESOF2ReNtbnnDbCEpaRbNEDjLl
	 NQ3/uvjXxhZEydLTKT1sR6AvIqKUZ8qZaXsL8ze468PdSfcWyLDj9upeuNO8zembxm
	 +oLpUpoDyaCY/rldQDOBwmG1uK1XWa0jMuJbX2xRlGRkSV+x+rClh09alywZHJkDH3
	 oY80GNHLw17BA==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id C78416008E;
	Fri, 21 Aug 2026 15:30:09 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: ZhilingZouzhilinz@nebusec.ai
Subject: [PATCH nf] netfilter: x_tables: require IP6T_F_PROTO when matching protocol
Date: Fri, 21 Aug 2026 15:29:52 +0200
Message-ID: <20260821132952.90204-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Several check() functions validate the protocol field value but do not
require IP6T_F_PROTO. A crafted ip6tables rule can set the field to TCP
or UDP while leaving the protocol matching flag clear.

Reject rules without IP6T_F_PROTO so the match/target is invoked only
for the protocols it supports.

In the TPROXY target, this allows to reach a WARN in packet path.

Fixes: 6ad7889327a5e ("tproxy: added IPv6 support to the TPROXY target")
Link: https://patch.msgid.link/cover.1786968834.git.zhilinz@nebusec.ai/
Reported-by: Vega <vega@nebusec.ai>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
Florian mentioned xt_l2tp is also missing this, but xt_multiport also
needs it. I could not find any other user of .proto which does not
validate IP6T_F_PROTO in IPv6.

 net/netfilter/xt_TPROXY.c    |  3 ++-
 net/netfilter/xt_ecn.c       |  1 +
 net/netfilter/xt_l2tp.c      | 20 ++++++++++++--------
 net/netfilter/xt_multiport.c |  3 +++
 4 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/xt_TPROXY.c b/net/netfilter/xt_TPROXY.c
index 5f60e7298a1e..13a94c9d06c0 100644
--- a/net/netfilter/xt_TPROXY.c
+++ b/net/netfilter/xt_TPROXY.c
@@ -179,7 +179,8 @@ static int tproxy_tg6_check(const struct xt_tgchk_param *par)
 	if (err)
 		return err;
 
-	if ((i->proto == IPPROTO_TCP || i->proto == IPPROTO_UDP) &&
+	if ((i->flags & IP6T_F_PROTO) &&
+	    (i->proto == IPPROTO_TCP || i->proto == IPPROTO_UDP) &&
 	    !(i->invflags & IP6T_INV_PROTO))
 		return 0;
 
diff --git a/net/netfilter/xt_ecn.c b/net/netfilter/xt_ecn.c
index a8503f5d26bf..a5c99f00c201 100644
--- a/net/netfilter/xt_ecn.c
+++ b/net/netfilter/xt_ecn.c
@@ -139,6 +139,7 @@ static int ecn_mt_check6(const struct xt_mtchk_param *par)
 		return -EINVAL;
 
 	if (info->operation & (XT_ECN_OP_MATCH_ECE | XT_ECN_OP_MATCH_CWR) &&
+	    ip->flags & IP6T_F_PROTO &&
 	    (ip->proto != IPPROTO_TCP || ip->invflags & IP6T_INV_PROTO)) {
 		pr_info_ratelimited("cannot match TCP bits for non-tcp packets\n");
 		return -EINVAL;
diff --git a/net/netfilter/xt_l2tp.c b/net/netfilter/xt_l2tp.c
index a61eb81e9f49..346cbc168009 100644
--- a/net/netfilter/xt_l2tp.c
+++ b/net/netfilter/xt_l2tp.c
@@ -267,14 +267,16 @@ static int l2tp_mt_check4(const struct xt_mtchk_param *par)
 	if (ret != 0)
 		return ret;
 
-	if ((ip->proto != IPPROTO_UDP) &&
-	    (ip->proto != IPPROTO_L2TP)) {
+	if (!(ip->flags & IP6T_F_PROTO) ||
+	    (ip->proto != IPPROTO_UDP &&
+	     ip->proto != IPPROTO_L2TP)) {
 		pr_info_ratelimited("missing protocol rule (udp|l2tpip)\n");
 		return -EINVAL;
 	}
 
-	if ((ip->proto == IPPROTO_L2TP) &&
-	    (info->version == 2)) {
+	if (!(ip->flags & IP6T_F_PROTO) ||
+	    (ip->proto == IPPROTO_L2TP &&
+	     info->version == 2)) {
 		pr_info_ratelimited("v2 doesn't support IP mode\n");
 		return -EINVAL;
 	}
@@ -294,14 +296,16 @@ static int l2tp_mt_check6(const struct xt_mtchk_param *par)
 	if (ret != 0)
 		return ret;
 
-	if ((ip->proto != IPPROTO_UDP) &&
-	    (ip->proto != IPPROTO_L2TP)) {
+	if (!(ip->flags & IP6T_F_PROTO) ||
+	    (ip->proto != IPPROTO_UDP &&
+	     ip->proto != IPPROTO_L2TP)) {
 		pr_info_ratelimited("missing protocol rule (udp|l2tpip)\n");
 		return -EINVAL;
 	}
 
-	if ((ip->proto == IPPROTO_L2TP) &&
-	    (info->version == 2)) {
+	if (!(ip->flags & IP6T_F_PROTO) ||
+	    (ip->proto == IPPROTO_L2TP &&
+	     info->version == 2)) {
 		pr_info_ratelimited("v2 doesn't support IP mode\n");
 		return -EINVAL;
 	}
diff --git a/net/netfilter/xt_multiport.c b/net/netfilter/xt_multiport.c
index bff5f53a9bef..b48c2cbbee62 100644
--- a/net/netfilter/xt_multiport.c
+++ b/net/netfilter/xt_multiport.c
@@ -156,6 +156,9 @@ static int multiport_mt6_check(const struct xt_mtchk_param *par)
 	const struct ip6t_ip6 *ip = par->entryinfo;
 	const struct xt_multiport_v1 *multiinfo = par->matchinfo;
 
+	if (!(ip->flags & IP6T_F_PROTO))
+		return -EINVAL;
+
 	if (!check(ip->proto, ip->invflags, multiinfo->flags, multiinfo->count))
 		return -EINVAL;
 
-- 
2.47.3

