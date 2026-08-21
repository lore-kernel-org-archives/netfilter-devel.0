Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7281223D7FF;
	Fri, 21 Aug 2026 15:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787326739; cv=none; b=HhpP7T1JMcxgBxyT1K9gYz4Jw87z9gxG1+V5sGWYrlxfcWHtx6A5Cd+2a73r1K4jvEmW8C9p+j9eVAsN95WwUNxNmG8JbN/aZ4qD5z85NZauzggggauzPozLHdcc8fVMg8Euajp6SHBJTsShtCP46W4BnDf5J3hoC4yS/ffxIIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787326739; c=relaxed/simple;
	bh=II5JoCPW3HLMlskf3/SsR5+SqkUSC4J6WiJiyiMMba4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fmGcaklR1GzyJJMqhv/RkhkmW4stP2pAaLU7pOxs2RPSu+bHcbrjDMVEF4nmLZazQ+A0dNSX0FMYq03pm7gx8SJ4ZXsBxAuiR0T9YPT9qnps3XBqBr1P22c29sT4cSjrF8KeMjLuojJg82h4xF2091fKRhueP+YPxUpWgdL3wds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=GKpeNyPK; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="GKpeNyPK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1787326733;
	bh=sn3LCXplqtWLOv+Fl8eFVSXtgDcPZ9TYxc+Uz7mpKaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GKpeNyPKoLLvHpZondRdGSGbd6m1pl1+DDRZVomD7KIFoi3UXy0VytOvJ0qLEYxnm
	 7XGZrjeNlNFpC9/81PdCUaZ4WWXL77C/5ToVe/51C2lLyixNcl4W6h1mlJ5r/USq5s
	 1QeaFeAh5NIOSjLa16M0TABUMO8zc3uCKatDlUlPEg7Z2Yzvq+bCJVun/8iGbgX1zr
	 6j1VEC+pPLHUDjruVkUfJf2jYMLjIfdyIimAXjLg91z89CgQZRVREdwZ3mv67qzdwz
	 qJZ0Xfg+sfsed2uMl6kwpizPedjVqNoa/yKVFVhi23wS3hlXQx/PNi3UMHSWeAgXQZ
	 QjEiIpuyXtohw==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 23C1260098;
	Fri, 21 Aug 2026 17:38:53 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net 06/10] netfilter: xt_cgroup: use pr_info_ratelimited()
Date: Fri, 21 Aug 2026 17:38:29 +0200
Message-ID: <20260821153833.245589-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260821153833.245589-1-pablo@netfilter.org>
References: <20260821153833.245589-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This seems to be the last xtables extension not using the ratelimited
version, update it.

Fixes: c38c4597e4bf ("netfilter: implement xt_cgroup cgroup2 path match")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/xt_cgroup.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/xt_cgroup.c b/net/netfilter/xt_cgroup.c
index 43d2ae2be628..ac1b7e71cd7f 100644
--- a/net/netfilter/xt_cgroup.c
+++ b/net/netfilter/xt_cgroup.c
@@ -33,7 +33,7 @@ static int cgroup_mt_check_v0(const struct xt_mtchk_param *par)
 		return -EINVAL;
 
 	if (!IS_ENABLED(CONFIG_CGROUP_NET_CLASSID)) {
-		pr_info(NET_CLS_CLASSID_INVALID_MSG);
+		pr_info_ratelimited(NET_CLS_CLASSID_INVALID_MSG);
 		return -EINVAL;
 	}
 
@@ -49,7 +49,7 @@ static int cgroup_mt_check_v1(const struct xt_mtchk_param *par)
 		return -EINVAL;
 
 	if (!info->has_path && !info->has_classid) {
-		pr_info("xt_cgroup: no path or classid specified\n");
+		pr_info_ratelimited("xt_cgroup: no path or classid specified\n");
 		return -EINVAL;
 	}
 
@@ -59,7 +59,7 @@ static int cgroup_mt_check_v1(const struct xt_mtchk_param *par)
 	}
 
 	if (info->has_classid && !IS_ENABLED(CONFIG_CGROUP_NET_CLASSID)) {
-		pr_info(NET_CLS_CLASSID_INVALID_MSG);
+		pr_info_ratelimited(NET_CLS_CLASSID_INVALID_MSG);
 		return -EINVAL;
 	}
 
@@ -89,7 +89,7 @@ static int cgroup_mt_check_v2(const struct xt_mtchk_param *par)
 		return -EINVAL;
 
 	if (!info->has_path && !info->has_classid) {
-		pr_info("xt_cgroup: no path or classid specified\n");
+		pr_info_ratelimited("xt_cgroup: no path or classid specified\n");
 		return -EINVAL;
 	}
 
@@ -99,7 +99,7 @@ static int cgroup_mt_check_v2(const struct xt_mtchk_param *par)
 	}
 
 	if (info->has_classid && !IS_ENABLED(CONFIG_CGROUP_NET_CLASSID)) {
-		pr_info(NET_CLS_CLASSID_INVALID_MSG);
+		pr_info_ratelimited(NET_CLS_CLASSID_INVALID_MSG);
 		return -EINVAL;
 	}
 
-- 
2.47.3

