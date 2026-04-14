Received: from mail-dl1-f46.google.com (mail-dl1-f46.google.com [74.125.82.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9D7B389472
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Apr 2026 22:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776204854; cv=none; b=NqYVKqUy8OBz0HBDc4CUZeCKoK6V0rYYxYGbmQWz+iAXnc7D9JFZzaRAa+Z2IwqY0fAxtVLXRRBAR2vSMN0k4xGzBrfAL11ng4KF6WhMtAeM6FhHSE/jjCffV28SiJDNVKW26Mx2W7zgamagGmXkd++oYyd060efJ8aAhzl8PNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776204854; c=relaxed/simple;
	bh=/CumOeAjJXXsmb/6L/suQapO1UW2/F8scULcYprsNlI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bCExhRF5TgiveryQsr4Mf4KKpqlg4dBRtSEOvLf8tP1hjSfFCN5+LdDLxg8ULCvLmVIbH25Aesp8/6MQiZu2hUy92wln+ik77V6/exfa8RPA196ZB8aFu2PS5JpFrRpZ0Vg/aGf0s12iHy3ywykaFNary+XfmVpM8VUJvnICX6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu; spf=pass smtp.mailfrom=asu.edu; dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b=qboAuy7t; arc=none smtp.client-ip=74.125.82.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asu.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b="qboAuy7t"
Received: by mail-dl1-f46.google.com with SMTP id a92af1059eb24-126ea4b77adso15187139c88.1
        for <netfilter-devel@vger.kernel.org>; Tue, 14 Apr 2026 15:14:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1776204852; x=1776809652; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/8oDk6Bv3/p8vkApYwMdU44Wt3x0ddwL222gIoY0s4w=;
        b=qboAuy7tnwO0jvVNjO9eA86rTj/BEHhJ3THfVZ6aLU60f7La0Jz3hU2XqV65z0v8Re
         l53Cp0PCtfRll7h0BeOUWkVx/u1ILtHG/D/sLAkC1XdYCp92l+iYTr3xE3pBwPpbBafM
         cPYzJnB/udl4meL4EMdqMtHdwHxNL30M8XlsK18BIe4mfbQILklY68yg2LqBg19ueYJ/
         50qWpuS4wJOqgymQhvCgRnPlNAN5sStJtbVIgWQ7PzAefpAYWfrqWlI2C9DcDlzwyhcs
         pYIPqBUzsFg9y8rwnMVs4EsqYr9NNekeVIgGZ04tGRutOEQdPoKTXr2FxBpfJMZPHMCj
         ix8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776204852; x=1776809652;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/8oDk6Bv3/p8vkApYwMdU44Wt3x0ddwL222gIoY0s4w=;
        b=G6EnW+B3VzRYMX8JlFbG662q2JkR4wKv247DVA2xsa86M8tpdXC3zr2MNmm6H1ULKb
         Sgj2POEk73WroINBcnHQ5bRLZJU25lW7kAvwF6uD3BsnceEok1C/X3nYUqqfjZyU4ldb
         xPb0/0F/lYRkF0k5pDRAVjl0+UOUsE8qonabyjAlN0AQT80551Z1hvkF/FPufL8GhlLR
         AJioY5QsHnR4aPLpBsGIACkiUS7Z43fLItyJjYge6bsPQ5LhMedDywJ+eECe+bOZexfR
         cQ7EotfpaoOCDGkGLzmxfsltF1y7SZVaMmd1CK/IvVId1ETOyFiuSWZMWU6B9YCRcbPH
         kDuw==
X-Gm-Message-State: AOJu0Ywd0l89xkpOyZvV0iHOjUUzC9Kj2jCElXyJS64Y8XpiZ5l0v55W
	CNC/yDrT/+v6wGQFW2wrH1C1gDHwPY0Wu5tLLQYDnlHMkrxJ5QQtgkzUrHHlLRca/BhMTWj3cWZ
	1HKxJiw==
X-Gm-Gg: AeBDiesUb2Gypy9b+Y4K+jekjh83LpsJ1iYy485Hi5lA2/f3unTJUfJoYVkzwsZiRcw
	xdgcX3/kjNplxJwBz+OJw1LNWyf/mBbyormYLhNeDFzABUsZpTr7U1YyzNUB8L9BS0+O/e7neM8
	QfI/4VypP+H5Bgjh9J4Ygrk6ULsaJhNGSWOytME7S7uc14hmgkZuZGYcdOjev2KfrkQ5ljCNFud
	zH4cwPcWzPrranYhazpEp0l9ajhnBJAcYSr5ILq8IupY02I8zS+vT6ykYaZm9mdE7BgXJq12DwG
	Tm6VleqKYRpQvIlLFgPFvmvyRAJTzvVL3AbrDwUdJi+97JJwa8p31O6Qi+PLpk9GGRW/HRN56yI
	adWdRmPPpMCIEvsjm0xB7K06xxY6wyxeGcR3kRRYMZ0BbQv6nxE6Qc+L5vFRZ2D7k7uhN/roHKU
	5u4yo61nVVv4mIgxrK3B+24qvbhQLVLaJReCtpGRVs8kQVqGkEvEOjxQby7R3mcvys
X-Received: by 2002:a05:7022:6726:b0:119:e56c:18ae with SMTP id a92af1059eb24-12c34ede8e2mr10335876c88.22.1776204851535;
        Tue, 14 Apr 2026 15:14:11 -0700 (PDT)
Received: from p1.scai.dhcp.asu.edu (209-147-138-15.nat.asu.edu. [209.147.138.15])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-12c4b323428sm13517785c88.4.2026.04.14.15.14.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2026 15:14:11 -0700 (PDT)
From: Xiang Mei <xmei5@asu.edu>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	coreteam@netfilter.org,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>
Subject: [PATCH nf v2] netfilter: nfnetlink_osf: fix divide-by-zero in OSF_WSS_MODULO
Date: Tue, 14 Apr 2026 15:14:01 -0700
Message-ID: <20260414221401.2809350-1-xmei5@asu.edu>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
---
v2: Fix the bug in configure path and correct the fix tag

 net/netfilter/nfnetlink_osf.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/netfilter/nfnetlink_osf.c b/net/netfilter/nfnetlink_osf.c
index 45d9ad231..70172ca07 100644
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
2.43.0

