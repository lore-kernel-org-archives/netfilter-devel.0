Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F0C03DD85F;
	Sat, 16 May 2026 11:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778932604; cv=none; b=gjEmnKxGMJToA/uSj7nLbI34AnUUkATUECHi5zrfBo2gyOhIZshr2T5nVT8Rqw7bBVVobutcm74BXoStyohlmPLIBiCBenC0vD0xe4UkzOVwqhkw10C6UIjLn9yy0I0Lo7uLM3VV00XO/eRjivum/HGPG3mNQucFEOa9+52oRqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778932604; c=relaxed/simple;
	bh=JefqsPYBkJHuwCij1iFGEuAgMSCJkR/jRWODK7bmbnA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EgesNXD2B64Pu+KzcdODB49NdpmOAPxnWSrTgKS6/PiPM7M2VgBtHapTZwbIJyBCqlbJSdjbVcIMh+4TRYod0Uo1Lty7WzWw4qOoV3Xqkh4u/KMWOj01rrcvMs9R+dnIP+Oas2xEWuhJYqsHL6bjsJq3L5Ptaa+O6N4iSKhyTXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=L61z6dK5; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="L61z6dK5"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 3BC0F601AC;
	Sat, 16 May 2026 13:56:40 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1778932600;
	bh=2396ArVGoiugvDwfn7q9+W8VnBJfBYPrShW4td7yOPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L61z6dK5dqM9Pc/5id5akm3u70bra5MWSL8iOOse22Stf60Icspr5xSEV/iW2/her
	 VpKdctldKxztSekuXHfTc4E3etO+uSyXQQYL5mp+6eBxvUJ8Zfa6hZl/l83sGhWOgw
	 dh6Q1J3/ll4cqJe6okvrkQR29g5CWHl704gpghg+OuDQVH6nF3iX7nUgl/37h5dbyU
	 OUr9LlngdkEyfDGENZ+u47G2uC5pagSeqq4WxngURm9W15FOnWUt8XQ+AnhbyPB5Pv
	 rxAtKrNeScVlePU4DsoHH5q2pP0bb6P7U7heQoRnFcx378d1olJfql93rETkZmMSOF
	 sDoI9GNk9p61A==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 07/12] netfilter: ip6t_hbh: reject oversized option lists
Date: Sat, 16 May 2026 13:56:22 +0200
Message-ID: <20260516115627.967773-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260516115627.967773-1-pablo@netfilter.org>
References: <20260516115627.967773-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zhengchuan Liang <zcliangcn@gmail.com>

struct ip6t_opts stores at most IP6T_OPTS_OPTSNR option descriptors,
but hbh_mt6_check() does not reject larger optsnr values supplied from
userspace.

Validate optsnr in the rule setup path so only match data that fits the
fixed-size opts array can be installed. This follows the existing xtables
pattern of rejecting invalid user-provided counts in checkentry() and
keeps the packet matching path unchanged.

`struct ip6t_opts` has a fixed `opts[IP6T_OPTS_OPTSNR]` array,
where `IP6T_OPTS_OPTSNR` is 16, then off-by-one array access is possible:

[  137.924693][ T8692] UBSAN: array-index-out-of-bounds in ../net/ipv6/netfilter/ip6t_hbh.c:110:29
[  137.926167][ T8692] index 16 is out of range for type '__u16 [16]'

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Signed-off-by: Zhengchuan Liang <zcliangcn@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv6/netfilter/ip6t_hbh.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/ipv6/netfilter/ip6t_hbh.c b/net/ipv6/netfilter/ip6t_hbh.c
index e7a3fb9355ee..450dd53846a2 100644
--- a/net/ipv6/netfilter/ip6t_hbh.c
+++ b/net/ipv6/netfilter/ip6t_hbh.c
@@ -168,6 +168,10 @@ static int hbh_mt6_check(const struct xt_mtchk_param *par)
 		pr_debug("unknown flags %X\n", optsinfo->invflags);
 		return -EINVAL;
 	}
+	if (optsinfo->optsnr > IP6T_OPTS_OPTSNR) {
+		pr_debug("too many supported opts specified\n");
+		return -EINVAL;
+	}
 
 	if (optsinfo->flags & IP6T_OPTS_NSTRICT) {
 		pr_debug("Not strict - not implemented");
-- 
2.47.3

