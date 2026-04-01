Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BAFA3F1664;
	Wed,  1 Apr 2026 10:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775039817; cv=none; b=tPmGM0nPppJVHfzlubpaO94ZijTvr1LmPKtK0qqZcAoGDbHi7dpAR6Vd9kTRykNlcwjVc09BdLX8u4x6vvGupRhIuP60rHm8YfTTkkoYAsY2/p1F2rqF90urAhtB2uUK6nRtc/U+uAHEcCO4aHMY6Ql4LgElZvpsX9AtWjyp+5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775039817; c=relaxed/simple;
	bh=TIPRBsmDWgpEWPOIkz0O+t/8bG/kIFpNFskQcN7BS9I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sBdsanmBFpO0t/CuMMNScWw/ogzUWxqU4F++XBLqcpssGYPqt9unBEx/hcKzDulUa+po/90Mi1TIeXk9BzMrB/kR3FP6M74bOvm5iRcQFXzGBVZ1NYybfLxxlg1ev6Y8mXT7yCXlYxX+1klm0+V1RqlwS/dREDQIdRCHu/tuIq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=c73dq66A; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="c73dq66A"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 1FD9A60275;
	Wed,  1 Apr 2026 12:36:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1775039814;
	bh=EgagfO7mM5kI+3Cl3BBvN59ScY9NmHA0hVtaoaQiXAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c73dq66A3leUZ1aqbUOKmp/kAmQ6mEFLCwAkkS5k3m3UWwZPvHmh+H6oNYvLE7NXX
	 ZHDLm9oeDhc6dWkdqmfO7RpWLXZZoaGQxTLV69WFWF9lW8hl26q5jQm/0o0G0xJscQ
	 Qg1KoJOgydIjq2HNAO8GCHkGR7PSRDtafiOihOWCSVO+DnQ71w4k4WH90a+3YKMx3v
	 7ie3V29Wnr4zUFUV5ye9+WB+r15MD8AHRujL994L+kEYGS8Tcwkrr8RxyCjRZhIw5C
	 M6ka2VS13SXyD2/b+EIYHZZ3MVjTMxiB1NGPcrly7AlcO7n007sMkmMFNNV0DPidmY
	 5Ng4nunHj70ww==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 02/10] netfilter: nfnetlink_log: account for netlink header size
Date: Wed,  1 Apr 2026 12:36:38 +0200
Message-ID: <20260401103646.1015423-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260401103646.1015423-1-pablo@netfilter.org>
References: <20260401103646.1015423-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

This is a followup to an old bug fix: NLMSG_DONE needs to account
for the netlink header size, not just the attribute size.

This can result in a WARN splat + drop of the netlink message,
but other than this there are no ill effects.

Fixes: 9dfa1dfe4d5e ("netfilter: nf_log: account for size of NLMSG_DONE attribute")
Reported-by: Yiming Qian <yimingqian591@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nfnetlink_log.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index fcbe54940b2e..f80978c06fa0 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -726,7 +726,7 @@ nfulnl_log_packet(struct net *net,
 		+ nla_total_size(plen)			/* prefix */
 		+ nla_total_size(sizeof(struct nfulnl_msg_packet_hw))
 		+ nla_total_size(sizeof(struct nfulnl_msg_packet_timestamp))
-		+ nla_total_size(sizeof(struct nfgenmsg));	/* NLMSG_DONE */
+		+ nlmsg_total_size(sizeof(struct nfgenmsg));	/* NLMSG_DONE */
 
 	if (in && skb_mac_header_was_set(skb)) {
 		size += nla_total_size(skb->dev->hard_header_len)
-- 
2.47.3

