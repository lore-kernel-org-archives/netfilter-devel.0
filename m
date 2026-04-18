Received: from mail-dy1-f170.google.com (mail-dy1-f170.google.com [74.125.82.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4F042E6CC7
	for <netfilter-devel@vger.kernel.org>; Sat, 18 Apr 2026 16:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776529942; cv=none; b=M6zAqN7uYWAxDq/Dvs12pFrc+6kSR1yzwXlJK1Y+2c721Yp+uPOA5y0n3ZsGsw99OZthiQc7KNDRgG7cwI2w0qVtXjFNhJGZ94SFSaHHbMfH74Kwgy0EC9hL5Q+O4M1zIh9X7ISWazwlvtr0n+/SK1VzdYCukVjO6UwxqIRdQMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776529942; c=relaxed/simple;
	bh=M7B2FiAQ68bmq17gT51ms1yjCM5hrhJ8ivTJGQv6vmI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EarGMnSRBZmscgWP/qKHwyUd6GE2Ulb+3vzyCkJ1CqoBkf/hGMFqbQvSpjizRVacucOVs/l/G/L4SElOiDbtPtFGBUgeSBY4M8RAMdtF8vy/YLtZNGOIWih49OI0y1IJvT7lDnDWKXp/2fPrRY0USi8OoqGZo9sUANUiW3lGkm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=To7DAt54; arc=none smtp.client-ip=74.125.82.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="To7DAt54"
Received: by mail-dy1-f170.google.com with SMTP id 5a478bee46e88-2e622a9da9cso2429860eec.0
        for <netfilter-devel@vger.kernel.org>; Sat, 18 Apr 2026 09:32:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776529940; x=1777134740; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=3kxoQx5x6kYpwthdIyOArHGCLCerv98lrw2KVJASpKc=;
        b=To7DAt54CBNFikgfoMwt+Ya3cmFxCxyD2DJ+v0gEiFWAKqQr/40RXAYp4UXnokoipq
         IvRQPVJJ6uDmPe1b+7gQ8p25CwcVYdG1iUcHWOLDfN9DtSjsBCfz8+0AfxhCzsqA4L1s
         9p0FmEj1ddfNcl8m0/cbT5EEdqe8nvTMVdEoNDix/b8Hp1SZVD7d5EVuSsM6tzMBYSHH
         3Yqyt/b+IDS8b6vcmmj2edgVDr5DtFbhhyGBaStBfNh7/xocyY6Fnslep1MdxcZ7g5Gy
         2boB6h1Pw/Nlj7A9250L+4IpiitDzpmdzmK/cO8W9LB8x9xDmaNQ3r5xDNGWR448CJax
         k28Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776529940; x=1777134740;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3kxoQx5x6kYpwthdIyOArHGCLCerv98lrw2KVJASpKc=;
        b=ax83qj7LHysbLvxOZGelyyFFuiVSdUFH1QzElF7X6LAdxhs9PZZgi9hZBKEtLqgUCZ
         3Vi+59WRYst7R7w6TlEvnI8oCWpyfkd91SLbQAdLKRTgvkCf1OUeIiMdqZpS/fnx44Th
         tV2qdSSJL16EElLVaEf2ZQFwkYv1X99FX3Y2t7t1qpanCHTs6zMOPHySD52XBRxVImsZ
         M7Q6RMjwxRy+Kq+TGHBpWaOUrLxIoCv9O+481w2PIxBAl8XZyJ8N3GqfPkhsiRxEB2ei
         TqObIhK7/2shrPlTB2EzE4re1OK0akGeImfQf7jEhABpw5WDwen0wl5mbx3sEDhu5izc
         llAQ==
X-Forwarded-Encrypted: i=1; AFNElJ8WEgNoPzZ42icZ14WHPH4b0+iFqr9dL5d9pAoDACARnF539w0ZoQ4oFNLHZMvWjLDI0E30dW53mt/f7hAnkIY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxH8yPyKSYw21ZNODApQYydmLJUh2T49y5JsKOD9Vn3ELWDbDAP
	jeB6HtR44ABagcdWRZeK8dlGmQV8qeOFjGhd2ImsSPbXyaRKdwoynRTC
X-Gm-Gg: AeBDieselSf5Rk2/ENtQGAPg2dYhDIklKuMr2dCVtsLrG5igBRnOxnMf7Bxduy5KnQT
	IXswi2l3xkPkSBEx6//t1UKsahLlQkIbeizGmFEB2QJdPGEpaKohIpx9d2acEAf1jVSO/QINg78
	ZUrmk2Zs9d9MW4/AsinHpWnjEdfGbTcOag8TanZqFUpollAZtwXUii8X4fgH2UZpZQewnDS/Slu
	DP+y3/4FcSkl9TQIbibSyn6oFrN7mUMEjQWQhOukv8pbRBMMMxoImdCaLgE6hxqMpHgcPzYkaMw
	tP7cn6HcI+g2isEWoUOTo60Jnn/zcNSZ5kO+d3b6JAnVcSr34Q3ZwDfKMv6GetjYrRqndzt0kgE
	bkRSY/f18cHrBMzEK9ZZfOUockSjtguOvs2wCL2RbSFPt5RWhXayVrZ7/1k6t6wpnD4iruXN0U1
	wVkTeY/toFwK5yrIjwXBNRySc5XyYZuYZOhjCt0VGAHt2nNnoAQLJN4hYS+7cwMuEL084rE/ZhH
	KmcS1sh9EC+HfsNUa+z
X-Received: by 2002:a05:7301:5784:b0:2de:c5ca:c1f3 with SMTP id 5a478bee46e88-2e465293dfdmr3688244eec.4.1776529939859;
        Sat, 18 Apr 2026 09:32:19 -0700 (PDT)
Received: from efaec68ba852.tailc0aff1.ts.net ([206.206.192.132])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2e536e54562sm6894368eec.0.2026.04.18.09.32.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Apr 2026 09:32:18 -0700 (PDT)
From: Weiming Shi <bestswngs@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: Phil Sutter <phil@nwl.cc>,
	Simon Horman <horms@kernel.org>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>
Subject: [PATCH nf] netfilter: xt_TCPMSS: check skb_dst before path-MTU clamping
Date: Sat, 18 Apr 2026 09:30:58 -0700
Message-ID: <20260418163057.2611503-2-bestswngs@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When TCPMSS with CLAMP_PMTU is used via nft_compat in a non-base
chain, par->hook_mask is set to 0, bypassing the checkentry hook
validation. The target can then run at PRE_ROUTING where skb_dst is
NULL, causing a null-ptr-deref in tcpmss_mangle_packet():

 KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
 RIP: 0010:tcpmss_mangle_packet (include/net/dst.h:219 net/netfilter/xt_TCPMSS.c:105)
  tcpmss_tg4 (net/netfilter/xt_TCPMSS.c:202)
  nft_target_eval_xt (net/netfilter/nft_compat.c:87)
  nft_do_chain (net/netfilter/nf_tables_core.c:287)
  nf_hook_slow (net/netfilter/core.c:623)

Check skb_dst() for NULL before calling dst_mtu().

Fixes: 493618a92c6a ("netfilter: nft_compat: fix hook validation for non-base chains")
Reported-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
---
 net/netfilter/xt_TCPMSS.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/xt_TCPMSS.c b/net/netfilter/xt_TCPMSS.c
index 116a885adb3c..79b5e475e23e 100644
--- a/net/netfilter/xt_TCPMSS.c
+++ b/net/netfilter/xt_TCPMSS.c
@@ -102,7 +102,12 @@ tcpmss_mangle_packet(struct sk_buff *skb,
 	if (info->mss == XT_TCPMSS_CLAMP_PMTU) {
 		struct net *net = xt_net(par);
 		unsigned int in_mtu = tcpmss_reverse_mtu(net, skb, family);
-		unsigned int min_mtu = min(dst_mtu(skb_dst(skb)), in_mtu);
+		unsigned int min_mtu;
+
+		if (!skb_dst(skb))
+			return -1;
+
+		min_mtu = min(dst_mtu(skb_dst(skb)), in_mtu);
 
 		if (min_mtu <= minlen) {
 			net_err_ratelimited("unknown or invalid path-MTU (%u)\n",
-- 
2.43.0

