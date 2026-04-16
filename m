Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC7DF3BED27;
	Thu, 16 Apr 2026 13:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776345306; cv=none; b=V7Vry5o8yUyMU70YQRL+Oku90ZLwB1ApwKBUcrlO9EveA9Uv169j0xsO3qfWCVi0luD1DQ2MGfQXYAcQLEqI9hxDK5SsgBcYU8zJm1CvM8j57UzRffwCx8IM/XKlRE9+xmgghiO8MkQ/sf77mo3ANdVzJuoS05h59AvAzNuMv0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776345306; c=relaxed/simple;
	bh=PawOKsjU/i0MTF68zbUb+VsSAv0gXGWmxITDx7vkR6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Paqk+g05La910l4NFaLs1aFTSEcYzyvo1VKU61Vx8Wa7NhCSZf1OR4pJ/37uiGDMr5lasO3/BF0aVa/Oh9p2Gk7Fcls8gxs/v9va5cssl9yvlQ741MkkdpUZQJLBQwXeTRm5ktEh9J7g58TJabmg1UN5inBZOEWjUw3h9IEzSY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=q/tY4Ymt; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="q/tY4Ymt"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id E8F7160254;
	Thu, 16 Apr 2026 15:15:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1776345303;
	bh=0HS0505hGdVF8P/vAEeHwqgAoOpv+wYp7KMbrpsv3RI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q/tY4YmtWtu3tiAWQgARW4zma2O51HrPHWZ9vjqqRcI6pRX+fI7jC4HmxDRpwnfLv
	 adcgNZZ3MDl+VElE/AjXf1DBPfvpaF5toZofiSrlzdQUNMlXGJBCk30ASXAtAz4MDD
	 SrPvIU83124MQR+gMp0VBKAG10ZKzFABTOSLVOtWpzNhfsP3+hPZLVh/RUCW9j8d1Y
	 w8UkvAbhnWbcAh+v7dW81m+GZluelAt9qL6CtRrpXhVZr6Mr9QtBSZUItZLXLXJf9n
	 adGBngCO+KVrsdASBYC7jfgg6aebxQJwbnk54+NSjglRPBlDupDVnQG9y4D2ChpwiQ
	 VKu36l1yd7Sww==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 02/11] netfilter: nfnetlink_osf: fix divide-by-zero in OSF_WSS_MODULO
Date: Thu, 16 Apr 2026 15:14:44 +0200
Message-ID: <20260416131453.308611-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260416131453.308611-1-pablo@netfilter.org>
References: <20260416131453.308611-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Xiang Mei <xmei5@asu.edu>

nf_osf_match_one() computes ctx->window % f->wss.val in the
OSF_WSS_MODULO branch with no guard for f->wss.val == 0. A
CAP_NET_ADMIN user can add such a fingerprint via nfnetlink; a
subsequent matching TCP SYN divides by zero and panics the kernel.

Reject the bogus fingerprint in nfnl_osf_add_callback() above the
per-option for-loop. f->wss is per-fingerprint, not per-option, so
the check must run regardless of f->opt_num (including 0). Also
reject wss.wc >= OSF_WSS_MAX; nf_osf_match_one() already treats that
as "should not happen".

Crash:
 Oops: divide error: 0000 [#1] SMP KASAN NOPTI
 RIP: 0010:nf_osf_match_one (net/netfilter/nfnetlink_osf.c:98)
 Call Trace:
 <IRQ>
  nf_osf_match (net/netfilter/nfnetlink_osf.c:220)
  xt_osf_match_packet (net/netfilter/xt_osf.c:32)
  ipt_do_table (net/ipv4/netfilter/ip_tables.c:348)
  nf_hook_slow (net/netfilter/core.c:622)
  ip_local_deliver (net/ipv4/ip_input.c:265)
  ip_rcv (include/linux/skbuff.h:1162)
  __netif_receive_skb_one_core (net/core/dev.c:6181)
  process_backlog (net/core/dev.c:6642)
  __napi_poll (net/core/dev.c:7710)
  net_rx_action (net/core/dev.c:7945)
  handle_softirqs (kernel/softirq.c:622)

Fixes: 11eeef41d5f6 ("netfilter: passive OS fingerprint xtables match")
Reported-by: Weiming Shi <bestswngs@gmail.com>
Suggested-by: Florian Westphal <fw@strlen.de>
Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Xiang Mei <xmei5@asu.edu>
Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nfnetlink_osf.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/netfilter/nfnetlink_osf.c b/net/netfilter/nfnetlink_osf.c
index 45d9ad231a92..70172ca07858 100644
--- a/net/netfilter/nfnetlink_osf.c
+++ b/net/netfilter/nfnetlink_osf.c
@@ -320,6 +320,10 @@ static int nfnl_osf_add_callback(struct sk_buff *skb,
 	if (f->opt_num > ARRAY_SIZE(f->opt))
 		return -EINVAL;
 
+	if (f->wss.wc >= OSF_WSS_MAX ||
+	    (f->wss.wc == OSF_WSS_MODULO && f->wss.val == 0))
+		return -EINVAL;
+
 	for (i = 0; i < f->opt_num; i++) {
 		if (!f->opt[i].length || f->opt[i].length > MAX_IPOPTLEN)
 			return -EINVAL;
-- 
2.47.3

