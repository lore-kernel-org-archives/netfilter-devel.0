Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EC732777EE;
	Tue, 22 Apr 2025 20:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745353438; cv=none; b=Bx643H4uNB8TGl7hQs4tTzvq6vpcYVM0C93G0J8/vOnFyxlQU2hKBP44ZyM5VoeWHwdIroZZdFZivVKFXgSYKeg07eiK5Gr4EtUwC7iy3cneRwRZmuzwHlWZDuBVjZYWG1WN5uXk135U0kRFYdr8KQMk0vp6lRZHs3oHSgL5HxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745353438; c=relaxed/simple;
	bh=sqWzHCleqx+aTkor+eWfgpG807luOl3QJh2I302WKkw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rATmYEYziF0zciacED0WQuwOQy+cy5DIV1eWrJrjuIyioDuymjI+eqYgBhHINcKwolf4IGCBusDWWhnN7ZqdiMPXFRvpE0+qKgBk5d232fu0cTkl9pEnZx/lwUzIWib9sKaAR6voBAnQo5r+Or4lPgJHJZtFwriY2nxOukiUEvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=n/iL+lRI; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=CCwyGzuM; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="n/iL+lRI";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="CCwyGzuM"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 0D65C609AF; Tue, 22 Apr 2025 22:23:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1745353435;
	bh=z017CUzGV0l71hUx/IApQSwLDsb3L4hLiuy85K8bahU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n/iL+lRIvbKB08ksr2LCEuXiIScSqhdIjxM1djyZSlqzKtgaZUtalJ0ACxQwmWtlJ
	 LAESzV7WtctniGB6KhEMSIMHNXGPskQqA2Ke4tDoKkaLj30o+yQ8nvFngg2eehbToc
	 ODb/7U23AMjCJW9AtZF1jwBOPRnTKQtBbl2tDAIXjyfOisdmyI3wuZPSLagmMm9+I4
	 KehVbZUTNRJxw+Wu4Xv/oGgyrtrvumPggc83HBEwWWhicQfaEObANv8Mkrelcu4cdE
	 2j2AhRhdqIPMWXh13yOYMWyM2A2VDJLxFDv1aEbiWgCcXWg0Ih4BkQmFOEWtfJW0kw
	 tGGrPHP2N/9sg==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 8EB11609BF;
	Tue, 22 Apr 2025 22:23:50 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1745353430;
	bh=z017CUzGV0l71hUx/IApQSwLDsb3L4hLiuy85K8bahU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CCwyGzuM0nRG9ZJruAK5cBrril4cWatXCH8fZm9ebGtNBx1SGbfMbvcqxavXOPPUg
	 FzB8X6vfaSphshNLu1fAuTzfyLxDVL3fjYXK5r3Xw91Wl2MMY1cx/hqBg3Dm/915IM
	 8fT7aZOiDFMLxsYVhmselDmuzeRxBEqVSZ39CXC62U2IEsXcTn/8wArZyzVzclztzx
	 rd3f+eR+fMycUysZKeSydJvMIer5rgfpsNgdbSkGl4dG9J8OF6E+404JvjWuCx+PKf
	 ZDK08XNxj/omV+tYxHo7Y9vkipp9H3bt7ByUYUISmOpOgxoRxmeMI+g1MWK7YiZONQ
	 v49UblwkNQpeg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 3/7] net: cgroup: Guard users of sock_cgroup_classid()
Date: Tue, 22 Apr 2025 22:23:23 +0200
Message-Id: <20250422202327.271536-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250422202327.271536-1-pablo@netfilter.org>
References: <20250422202327.271536-1-pablo@netfilter.org>
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

