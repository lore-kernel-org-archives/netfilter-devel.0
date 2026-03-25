Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09D46382377;
	Wed, 25 Mar 2026 22:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774477597; cv=none; b=j6sb7VOBFJdOwuGo4fo/zovVkGKuK0N4g7dItlBvD8iX8lA82Kr5Yl5Bcf32LyJ3fVoqVThD8hP56EEklA5HGx2GR5dvc8zSqrxLr0qqPkXr74Y2fnSzooJzzxB6mwv1VVYqMWijYDyIgAeLNFXwxdirmZThSpUMZ6VW3bJ2/hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774477597; c=relaxed/simple;
	bh=3M8SeXoNHLSfSINMUuDheIWOSxvuF8h+a8P9Ia2Rlqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bcit29FMpfHQg0AcqLizkuwjbPiuNqELD+8hL1EG49n4hI/VFj2ifSqNLjD80tXnX7pbL7UZ1LYIlBgmPytnsSM1K6+BxiWroVQcBkP3R9va15neKij/aOgvB2Fki82CUoLFiCLsRKHRek9151RlGSZXz3ZlNMuuJruUd9bp6w8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Cz/8Z+jv; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Cz/8Z+jv"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 0B2776024E;
	Wed, 25 Mar 2026 23:26:30 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1774477591;
	bh=GWPRWf1+yS2roJCPasyquMCXNaZuktYHTHQ8GKT903w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cz/8Z+jva0AWCktbXP2sjv9NJDjWKAjA1C5m8RRNzz5gLv0HpjV9F6D2GsxmtcfQA
	 Ui/icT0vEOjRyYB3mtWkPKqVnv2R6UCX6OPe+IHDdg4V4a2WeuFhyFOR5nYBb7utJM
	 bQKWbXTdJd+WBojiKyUSXR6vHTpV1nJlQCAK+Xt82oTQ921ghkiktS+NYNRGFhulow
	 PAfppWfEzM4wv/tC4Ikl4cKxV3Lt6mSjEokD95fz5AtKZ+4qtjQqMi4CWbRXQ+x206
	 y8u2o5G9xiW9nm+cf541M8hxxKCJdBIv5bZ5lhof/nzEz8XC6y/I3mt4gyjlYDdogd
	 HGKjPE3TqkQZA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 06/14] netfilter: ip6t_rt: reject oversized addrnr in rt_mt6_check()
Date: Wed, 25 Mar 2026 23:26:07 +0100
Message-ID: <20260325222615.637793-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260325222615.637793-1-pablo@netfilter.org>
References: <20260325222615.637793-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ren Wei <n05ec@lzu.edu.cn>

Reject rt match rules whose addrnr exceeds IP6T_RT_HOPS.

rt_mt6() expects addrnr to stay within the bounds of rtinfo->addrs[].
Validate addrnr during rule installation so malformed rules are rejected
before the match logic can use an out-of-range value.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Co-developed-by: Yuan Tan <yuantan098@gmail.com>
Signed-off-by: Yuan Tan <yuantan098@gmail.com>
Suggested-by: Xin Liu <bird@lzu.edu.cn>
Tested-by: Yuhang Zheng <z1652074432@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv6/netfilter/ip6t_rt.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/ipv6/netfilter/ip6t_rt.c b/net/ipv6/netfilter/ip6t_rt.c
index 4ad8b2032f1f..5561bd9cea81 100644
--- a/net/ipv6/netfilter/ip6t_rt.c
+++ b/net/ipv6/netfilter/ip6t_rt.c
@@ -157,6 +157,10 @@ static int rt_mt6_check(const struct xt_mtchk_param *par)
 		pr_debug("unknown flags %X\n", rtinfo->invflags);
 		return -EINVAL;
 	}
+	if (rtinfo->addrnr > IP6T_RT_HOPS) {
+		pr_debug("too many addresses specified\n");
+		return -EINVAL;
+	}
 	if ((rtinfo->flags & (IP6T_RT_RES | IP6T_RT_FST_MASK)) &&
 	    (!(rtinfo->flags & IP6T_RT_TYP) ||
 	     (rtinfo->rt_type != 0) ||
-- 
2.47.3

