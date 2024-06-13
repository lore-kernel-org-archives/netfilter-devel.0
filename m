Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E09AD145B1C
	for <netfilter-devel@vger.kernel.org>; Thu, 13 Jun 2024 14:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718289182; cv=none; b=Wa3tYWayEaitOSrfvkrKKYCHdaa5esqn00SkHXvFjkIfICYndCl9NsltMxy0D6SZG5I2HNwnyeOAuTu32IaU2+6Y6dVmhDnNpJ0CLODRzX9h2WJPRxx4GycvkWs/zC67WISCsusVhD4EXo3B/2aOiZUlDpMYA2O52+qlaTFX8YA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718289182; c=relaxed/simple;
	bh=+nz8VGj097r2Ej8JPYSS8eAHmqrcAB0pQ+J/LKuYTNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F+NXDd7a+/m6Iuqj7rZq2Xg65BPTeZ6ErQqCnRKBXjplaSZULEl67IcjdyT3VX7Mxgzhvz8kCjY0E3f/8ONd4GU5nGXc0YSf6P9Zw9r/jpsrz+MpHy9jZR4V8/iahQWY9VQbuGBMrRp+610ss9a9mJhpxDcb0rgo8VOGwSfIjfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=jzqrQOTD; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="jzqrQOTD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=JL0MY1P9EPNSlFK5uGPRd6HvYJtWvcNKepWgnXLzV6c=; b=jzqrQOTDR6ZvVk6PmobFOzH7c9
	MBx4HXp+wNurEn5KKMYIOEdGipGrtyVWvOeXq9lSf1+PE56ZQKaIYyX7Y35dN7IjQIqptOBuuf3ap
	uzIc7csifv4up6j/LfeTAFjlfUXtwHZBHfuwzYt6OebILH5q6uZdOE4BVntEb9WqiOVjlT1cT9qzH
	zt53EMeqCRp6TrG5OQiDKyEmMrMy//PJZIItWczJZpFnCa4lHKM4LwhBJwlLFpJTcDmZE1i0U/hBf
	z0/tKLwOJdV/n7gBMduWYNm/JBWLNPYMCJh3dle+P4ctwYXTp5kepVAoomcJzk3Q0yhLWJ9NvkGed
	hUKYPkkw==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sHlVS-000000008W9-22AV;
	Thu, 13 Jun 2024 16:32:50 +0200
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org,
	Fabio <pedretti.fabio@gmail.com>
Subject: [nf-next PATCH 2/2] netfilter: xt_recent: Largely lift restrictions on max hitcount value
Date: Thu, 13 Jun 2024 16:32:54 +0200
Message-ID: <20240613143254.26622-3-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240613143254.26622-1-phil@nwl.cc>
References: <20240613143254.26622-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Support tracking of up to 2^32-1 packets per table. Since users provide
the hitcount value in a __u32 variable, they can't exceed the max value
anymore.

Requested-by: Fabio <pedretti.fabio@gmail.com>
Link: https://bugzilla.netfilter.org/show_bug.cgi?id=1745
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 net/netfilter/xt_recent.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/net/netfilter/xt_recent.c b/net/netfilter/xt_recent.c
index 60259280b2d5..77ac4964e2dc 100644
--- a/net/netfilter/xt_recent.c
+++ b/net/netfilter/xt_recent.c
@@ -59,9 +59,9 @@ MODULE_PARM_DESC(ip_list_gid, "default owning group of /proc/net/xt_recent/* fil
 /* retained for backwards compatibility */
 static unsigned int ip_pkt_list_tot __read_mostly;
 module_param(ip_pkt_list_tot, uint, 0400);
-MODULE_PARM_DESC(ip_pkt_list_tot, "number of packets per IP address to remember (max. 255)");
+MODULE_PARM_DESC(ip_pkt_list_tot, "number of packets per IP address to remember (max. 2^32 - 1)");
 
-#define XT_RECENT_MAX_NSTAMPS	256
+#define XT_RECENT_MAX_NSTAMPS	(1ULL << 32)
 
 struct recent_entry {
 	struct list_head	list;
@@ -69,8 +69,8 @@ struct recent_entry {
 	union nf_inet_addr	addr;
 	u_int16_t		family;
 	u_int8_t		ttl;
-	u_int8_t		index;
-	u_int8_t		nstamps;
+	u_int32_t		index;
+	u_int32_t		nstamps;
 	unsigned long		stamps[];
 };
 
@@ -80,7 +80,7 @@ struct recent_table {
 	union nf_inet_addr	mask;
 	unsigned int		refcnt;
 	unsigned int		entries;
-	u8			nstamps_max_mask;
+	uint32_t		nstamps_max_mask;
 	struct list_head	lru_list;
 	struct list_head	iphash[];
 };
@@ -360,11 +360,6 @@ static int recent_mt_check(const struct xt_mtchk_param *par,
 		return -EINVAL;
 	if ((info->check_set & XT_RECENT_REAP) && !info->seconds)
 		return -EINVAL;
-	if (info->hit_count >= XT_RECENT_MAX_NSTAMPS) {
-		pr_info_ratelimited("hitcount (%u) is larger than allowed maximum (%u)\n",
-				    info->hit_count, XT_RECENT_MAX_NSTAMPS - 1);
-		return -EINVAL;
-	}
 	ret = xt_check_proc_name(info->name, sizeof(info->name));
 	if (ret)
 		return ret;
-- 
2.43.0

