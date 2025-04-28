Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA3892116F4;
	Mon, 28 Apr 2025 22:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745878400; cv=none; b=NK+ytxMhExjeLGcW9f2x19w2ftFFSkxv5/5V+o3v9ZiV/UPjJ/yny3jhNJL5ixRbOet8c/C53anits/VS03tBeD0osDixMwSvS4uFcJOYdVU+mPdndKBWmPwNkxFLTikMYo5KEfJtytT0k8fG9xBlBqFaV2MkyfOheWC/YmUX0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745878400; c=relaxed/simple;
	bh=sqWzHCleqx+aTkor+eWfgpG807luOl3QJh2I302WKkw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pcMybJXcRXfs9oMXZk55TRyseprik5aRGkPvUHrYSGLaCM2qHtCbNMQHN42gv0dBPDTv3mApDbnZhznRDahooHWPzlqSl4QVE0RaVZULnNIQn0swb1stCFkprHSevlJfv1ACGVvDjv9ludOcAXrthUJ2jMp6FRQ9cjU8DdaGZOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=hY2G1ag4; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=YJVS+nR+; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="hY2G1ag4";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="YJVS+nR+"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 61EFA603C4; Tue, 29 Apr 2025 00:13:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1745878397;
	bh=z017CUzGV0l71hUx/IApQSwLDsb3L4hLiuy85K8bahU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hY2G1ag45sJAakiuepL/8UbAXOJqYAc07+sR9J+4PO/8FnZ8fB5kW4ynJJxPHr1oO
	 w4veQ0H1MZURLHfC7Cvq4hD1h46aT0wYGf5pAxJ10KkF9RlSZCwcxQooWByxU/J8dj
	 SYUg1wKhf313VxeKMG8SIW7StXHog5xOSx7VDJFIpqImglMokikFvDAR0hY9r+PMRq
	 BfT94I9VMf2jId8gJvQVCnaf4+GD85Rju6cH3ZWuYiy/4jkVLcLr0seEmB1/zAD7Ru
	 eZ6JjFDPv2Zoep6UB8r2ROh8JRXSbUNWSdkBmbflMLiAX2TDD3lliAcE7ecbQTzUQ6
	 vI9OFJFy7ppGw==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id A85CE6052B;
	Tue, 29 Apr 2025 00:13:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1745878394;
	bh=z017CUzGV0l71hUx/IApQSwLDsb3L4hLiuy85K8bahU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YJVS+nR+9W0HWX/u2b7ngoiGfaDDLHwy594rprd1QL3e/Xt9+02uiSvo9eoV1uoBl
	 KacT3sdFfiDfZpBQpTutOWLYIrHn2awMxbXDs6p/cllw+x4Jx89acusHNo0SMCIjr6
	 MWUeILEYp5z6xlv5PzHc8+8X4VZkIam6CqYwEzrZlXT2paEawxzkDQr0b9sMe/AFA9
	 dXLHRxC7YEUu80Ii675jeM0Y2jXH1slHuZmD/W+mZ2zZI39EXY1c83mBif0msth/ME
	 waWgIj0H7Bx9corbDrwoIqqu5GsPGTzlJgZWgwVzYix0emerAJKM7Q5kWt7rXmv/tR
	 RHKRGq7FhqPVg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 3/6] net: cgroup: Guard users of sock_cgroup_classid()
Date: Tue, 29 Apr 2025 00:12:51 +0200
Message-Id: <20250428221254.3853-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250428221254.3853-1-pablo@netfilter.org>
References: <20250428221254.3853-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Michal Koutný <mkoutny@suse.com>

Exclude code that relies on sock_cgroup_classid() as preparation of
removal of the function.

Signed-off-by: Michal Koutný <mkoutny@suse.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/inet_diag.c      | 2 +-
 net/netfilter/xt_cgroup.c | 9 +++++++++
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/inet_diag.c b/net/ipv4/inet_diag.c
index 907bad776b42..1d1d6ad53f4c 100644
--- a/net/ipv4/inet_diag.c
+++ b/net/ipv4/inet_diag.c
@@ -160,7 +160,7 @@ int inet_diag_msg_attrs_fill(struct sock *sk, struct sk_buff *skb,
 	    ext & (1 << (INET_DIAG_TCLASS - 1))) {
 		u32 classid = 0;
 
-#ifdef CONFIG_SOCK_CGROUP_DATA
+#ifdef CONFIG_CGROUP_NET_CLASSID
 		classid = sock_cgroup_classid(&sk->sk_cgrp_data);
 #endif
 		/* Fallback to socket priority if class id isn't set.
diff --git a/net/netfilter/xt_cgroup.c b/net/netfilter/xt_cgroup.c
index 66915bf0d89a..c437fbd59ec1 100644
--- a/net/netfilter/xt_cgroup.c
+++ b/net/netfilter/xt_cgroup.c
@@ -117,6 +117,7 @@ static int cgroup_mt_check_v2(const struct xt_mtchk_param *par)
 static bool
 cgroup_mt_v0(const struct sk_buff *skb, struct xt_action_param *par)
 {
+#ifdef CONFIG_CGROUP_NET_CLASSID
 	const struct xt_cgroup_info_v0 *info = par->matchinfo;
 	struct sock *sk = skb->sk;
 
@@ -125,6 +126,8 @@ cgroup_mt_v0(const struct sk_buff *skb, struct xt_action_param *par)
 
 	return (info->id == sock_cgroup_classid(&skb->sk->sk_cgrp_data)) ^
 		info->invert;
+#endif
+	return false;
 }
 
 static bool cgroup_mt_v1(const struct sk_buff *skb, struct xt_action_param *par)
@@ -140,9 +143,12 @@ static bool cgroup_mt_v1(const struct sk_buff *skb, struct xt_action_param *par)
 	if (ancestor)
 		return cgroup_is_descendant(sock_cgroup_ptr(skcd), ancestor) ^
 			info->invert_path;
+#ifdef CONFIG_CGROUP_NET_CLASSID
 	else
 		return (info->classid == sock_cgroup_classid(skcd)) ^
 			info->invert_classid;
+#endif
+	return false;
 }
 
 static bool cgroup_mt_v2(const struct sk_buff *skb, struct xt_action_param *par)
@@ -158,9 +164,12 @@ static bool cgroup_mt_v2(const struct sk_buff *skb, struct xt_action_param *par)
 	if (ancestor)
 		return cgroup_is_descendant(sock_cgroup_ptr(skcd), ancestor) ^
 			info->invert_path;
+#ifdef CONFIG_CGROUP_NET_CLASSID
 	else
 		return (info->classid == sock_cgroup_classid(skcd)) ^
 			info->invert_classid;
+#endif
+	return false;
 }
 
 static void cgroup_mt_destroy_v1(const struct xt_mtdtor_param *par)
-- 
2.30.2

