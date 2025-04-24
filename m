Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14D9928A1F3;
	Thu, 24 Apr 2025 21:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745529322; cv=none; b=tzlHTZ1k3z8MymOGn7WH13N0Ww78+xwhHml7/fXRW3d5LLFlv65Ms834UrIV4rot5OV9NkR0m03eDyIFKFmD9OWJj2CRslwMqTecqCQWb9GqH3yU2HxIhjSJZvde8zGgUCAS2TD1rfqR1U4mgxxLkosQ3ZvkjAjoTQYj6iDNG3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745529322; c=relaxed/simple;
	bh=sqWzHCleqx+aTkor+eWfgpG807luOl3QJh2I302WKkw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hKjwlUIBNC6AfvGgBm1e2sM92Yxw1b4jiPBsf7xC3nlKqjX74X0CYdUSA/HKJwnVNWLv/z7vRT3XNy48sLwVv67MH6oDyDbOwfqF3kaYidy8BIRYq2UKw6TjR6mlZuxpYfrcbT3NS5PuawCRlalFDfsYxEfxalurbHq7q4EHArk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=KyMemei4; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=o20p+UeW; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="KyMemei4";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="o20p+UeW"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 442B36072A; Thu, 24 Apr 2025 23:15:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1745529317;
	bh=z017CUzGV0l71hUx/IApQSwLDsb3L4hLiuy85K8bahU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KyMemei4sUVZdOsWi7a2zYTGFFGCtBMsJrwuARDBFNGtAHTGc9R8YBPoH9eSZYmsO
	 9I24bb9IOXAv78bMZl/E1w6/5/TDO/sTYKARuf4SFGa6TnKERLB1TPolJLmg5L+wJ9
	 FKGTxK69yz2ITDLePvssFh3RCMWeU6oJqaxjOlCxYjv3PgNbuLNVhdzb+0V8wzKLag
	 QYQfGVBtvFNPXy/NsPSL4EYIt+lbtN0Ah3rhYvC7yQEHwCCAYv4JOG8Wfp5h9vErSe
	 +WhgGXCsJZvMQVRNGjKE2t9FqmUFJXryXK7XUfVsYRQYtn0iYSMhuQmLAhUFnXOH82
	 +Yp5qbcI4kGXQ==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id DCD1D6070D;
	Thu, 24 Apr 2025 23:15:12 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1745529313;
	bh=z017CUzGV0l71hUx/IApQSwLDsb3L4hLiuy85K8bahU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o20p+UeWdJfu0cQmNQkSXrmW61BGhx6bkk/rsrTrd59HVn/To8wNq5JqLD8X0Gzj+
	 xHsxLOARpePlZG2qZP/UC3ByTJzgNDQo+IZCt8nGul9pGMGCm6K6pCUH2qMpL+RKsn
	 QCRPHpul48y+cVvj2g/6dmhwXQ/R0HBVf/C89j793o2pfrNkqJAl8Mox2HaXZE2Coc
	 3ZNU9HoQww1vaQfhsHZSbZvVX2aHGAlQyL8Rr9IfwxqxCOjsP1wbsc+4jnraVB83pG
	 gsDpwDAAXwNlkXrB0rFvLgTihf0x2wyDsLIB1BNVsY4Vkx9WMq8vr3onJHHOeVI23k
	 a248dPtqBwhdw==
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
Date: Thu, 24 Apr 2025 23:14:51 +0200
Message-Id: <20250424211455.242482-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250424211455.242482-1-pablo@netfilter.org>
References: <20250424211455.242482-1-pablo@netfilter.org>
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

