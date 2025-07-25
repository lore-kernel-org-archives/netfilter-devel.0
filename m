Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 411772EF9C2;
	Fri, 25 Jul 2025 17:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753463038; cv=none; b=Pvhwsk94F0XEqxj5Oqgt8ivIssbC7AaUWvC0bYgeZ2mCKIcCLyubaV4o9jCg/HfRkUolJGSHPOmZGkwygYSsbMCP4XQv85U2IylCRizaL4v0z9AE0EIxiE73fjnVJNE7zisPNuzx60Wu36ml/zVpgfCJNILp9HY5Mj1Bo+e2oGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753463038; c=relaxed/simple;
	bh=ZUtfGbXNT3Z/Jl+Doqb5fLd3GRcC3PlUEBhMRbHbBqo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sd9oXSAG6eNBEN6arSGp/sUSaS3a1xKlb5a+7UQwr3oG64YEj8GZKUWjTCLNxxbi/QnxvGWTyeYXJxkkxFnMNQpiw7QGwvbwM0VpItzEW0ljG2rgL6lduD8T9qLAkiSpC3pbJDJ9GJBMZRaSQ0udGUOAKnRgkoyh0oqUAOG26KA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=R9e2Ap9/; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=W5J8t+fB; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="R9e2Ap9/";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="W5J8t+fB"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id B5F436027B; Fri, 25 Jul 2025 19:03:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1753463034;
	bh=HsMCTgfneNwflWl1j0F7tqAw5vJdRrvG8x25QGJXqHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R9e2Ap9/krz6jMAkRMVzPLG8guqvVZhaaayQFs96HXmvv7Ps2MC5i4Xj1AbBaDmqz
	 CEeUR97jsNbmEN3VtHcR2iYhsKwLJzIbTSLqannJRKyCHlSOHyRXA42x72n5jq3PSs
	 V6knv+YmC09Q+wG71V8tzFaRJGCz/9PV3Jj0QOHJ/iGAqnrK+IME8RjPs5/TkH15VF
	 Jt/dcpJFZqjRW/nOx8+1UpS194vL1/gCg5STO4+EpmFTiFqfV9hgoXpJJOJmzwE5Z+
	 PSuhuGxwYMFE4DQjGuNUlHwueDltdUZCrIK/Mpan7EsfNOiwO0oWrEttCtXY8Pf7Uv
	 Hqcvzy9brDSxA==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 2B2596027C;
	Fri, 25 Jul 2025 19:03:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1753463033;
	bh=HsMCTgfneNwflWl1j0F7tqAw5vJdRrvG8x25QGJXqHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W5J8t+fBHqLqMonL+U7HTbsKSq6wQy6drP7kamS0ffEZoL2ywnRPcMswxyyLxNu96
	 c/vXnfdotyiL0qRlCCuYPjGOw3XhGhnMGFZMquzCxaf5KYKrBXeggZ2vsHWLnzyVXq
	 1OlVv2NGTjHnhRAtyUlPIsajN95jsxXNVbIyHf7iblfO32i70FZoWiowVMpuXW+xEk
	 D/1CTjBJZOC2FoFBYQyu9fQ9HuBMI9y5FIMY3bJRBJImifMqTAZfk28t/aCLl+pHCK
	 uPectrpsWyjrdJzwD8RrrnPuG+YeWL4nM9vQteteWXFYaps1OaFhuy/O3EE7lyh207
	 2d+6lfCcfQhHg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 03/19] netfilter: x_tables: Remove unused functions xt_{in|out}name()
Date: Fri, 25 Jul 2025 19:03:24 +0200
Message-Id: <20250725170340.21327-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250725170340.21327-1-pablo@netfilter.org>
References: <20250725170340.21327-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yue Haibing <yuehaibing@huawei.com>

Since commit 2173c519d5e9 ("audit: normalize NETFILTER_PKT")
these are unused, so can be removed.

Signed-off-by: Yue Haibing <yuehaibing@huawei.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/x_tables.h | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index f39f688d7285..77c778d84d4c 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -51,21 +51,11 @@ static inline struct net_device *xt_in(const struct xt_action_param *par)
 	return par->state->in;
 }
 
-static inline const char *xt_inname(const struct xt_action_param *par)
-{
-	return par->state->in->name;
-}
-
 static inline struct net_device *xt_out(const struct xt_action_param *par)
 {
 	return par->state->out;
 }
 
-static inline const char *xt_outname(const struct xt_action_param *par)
-{
-	return par->state->out->name;
-}
-
 static inline unsigned int xt_hooknum(const struct xt_action_param *par)
 {
 	return par->state->hook;
-- 
2.30.2

