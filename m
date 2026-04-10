Received: from mail-dl1-f44.google.com (mail-dl1-f44.google.com [74.125.82.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 091FA2F5491
	for <netfilter-devel@vger.kernel.org>; Fri, 10 Apr 2026 20:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775854131; cv=none; b=rNBspOtFlFqV3usIICsIsFvKE9XyHTNynCuUdm9sTyvzyZfC/0C1B6spFsBZ1G+ldijAYUJxP9Ia/OaJess2R5jTUWWQX5LSgd74hKvunSK2Lr8NQTMaDIfYefBzXYWLPem1pFiwFOmd1eRBfXA+xxMnZkVf2ZE4rgE92jkNOvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775854131; c=relaxed/simple;
	bh=7ikf22Yk9gDKjKnQ4vG7L4LBTt9F/m2LDetXkk9Vbcw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tM9Am8wMDDpkCFMViMWFpO6EYXCn6zIvcVdhtX22bjsgv8lT0naeiCReba8nfU1c2ndSBtWlIqCLARfP/VpiROxSTAy1WipyCfk0fyEoj+MY0MQg/r0blYWn1O9tJ4EUb3QeLcpmt/Zi9jEOhyEt6vxufZ3XTlOh//M/xpNJ6dM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu; spf=pass smtp.mailfrom=asu.edu; dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b=HioFDOg8; arc=none smtp.client-ip=74.125.82.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asu.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b="HioFDOg8"
Received: by mail-dl1-f44.google.com with SMTP id a92af1059eb24-12c19d23b19so2572730c88.0
        for <netfilter-devel@vger.kernel.org>; Fri, 10 Apr 2026 13:48:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1775854129; x=1776458929; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=o8Z8RVZ7gmrp+TUiE+Acjq5yoAXHwEewB9LLWN/bJr4=;
        b=HioFDOg88DYUziL3eaKgknZujplVAZLVfZqxF8lAMocSrgJ6MXId9sRgxVEH96yCLT
         8br/Sa1f+42LvO0IGSoB725YYe0ItRnxx0nHlDemqvyOmy0O53FZ44bUm6z/mGqo1k/r
         y/MzgTzLMUL+FAZ5xjpCrRJiHyWgMWQ9jCycpecsrJX+5Ilx23GWaZHx5IvdWsqUUWeu
         oWX3gZ1h8INlydsKui6pTBIz/TqyXEU+HDVbFpNAZosoDeKAxXUlu2cTuRiWFjoFyxIP
         O1VnrFVeEQFcInv2xjPaLyAIizyV5gFHgJKvDWxDEPJOYQ0EcX88nrfBrF4l4INefZwU
         6djg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775854129; x=1776458929;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o8Z8RVZ7gmrp+TUiE+Acjq5yoAXHwEewB9LLWN/bJr4=;
        b=VsbpVlgJm4PLrv6k+N76YqRxeuBvReQt2ys93FO2DtWzoPoJFqOt/5AWXFSEsM/QMA
         P9CaoM6E4pWhjkbLzhuIJ5orBXpLyYRKYDc0nRt9e2dDKEnz5xDcwWdgR5u69Y2GZH7b
         JVETRbu+unRHWJT3+zluIQqZ1y/qx73zzs3ZI8Ao4c45CJaPAtPHkwTdCg+tw2E0qhss
         88aa+laZZxaAysb2VebL37zLm+xZD+RJMs1Aoc2W3RgrtkOjUqE4duP+NRPMNFtxKzCW
         5w1kz/ojadaPHhRl8vw4UrHmMVwAu7Q46KtKh78GVlquGFma3VQdYqYLE57W+bBytcbb
         IEmA==
X-Gm-Message-State: AOJu0Yxcre7fFD5aNNxNVe/q/mbyLb0WjOG0+T4iL6Tz29QC0hSxn0oN
	IBZearScVMZlyMxSsSd94ELzj7PwcWtplxQWzl08hnlZgm7THi7HJGpyJ+Tp40koLRd7ypLI0+c
	Jc4kITw==
X-Gm-Gg: AeBDietWzCwfhKswjFDu1PDVcvHyBoUFf1VqGKR3rv8NI2IBxm3kdaULBbCkqLJTWi7
	GOZdFZqCqisXHHHGy+HOc1TiQCbN/JJNNe5WVIM1IHmLdJ6H4MtEXSYBnW2mHvVm6JnEuMAsE/t
	2OzS0SPYd7sOYUxldcS3ROmJnjYR+Vn/nwEa2A8RNrwIE+V4qXrGP0cZRUAWL86ud/ZyiDHs4Pf
	hCoaL85r3140wMBV18UtEsqeKazNcmAZYWePxTO+bWZBforZB0RK7BlHXQRraC6bvomg2Pwtft9
	RQLdM28Zx37oi0xlQHbMsW3tbHTG+Gf+ARKtGC5zMBgMHHnqedkVGtbT5+svce0uxXJEFKvMmDQ
	nIXAA3Hd/d7ob1EfJTPIQHvRPM7BkqzO0WOreSek8wxDM14oetKkxgGqOrVje8Pvl6asuZQrK5M
	xOJQknD2vmfAyCayo3o9yAkDCUKrrnbOxOKERwht5sNqtp3+cifkmx9A==
X-Received: by 2002:a05:7022:4589:b0:12a:6902:ddce with SMTP id a92af1059eb24-12c34e6012fmr2803898c88.10.1775854128840;
        Fri, 10 Apr 2026 13:48:48 -0700 (PDT)
Received: from p1.scai.dhcp.asu.edu (209-147-138-15.nat.asu.edu. [209.147.138.15])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-12c345a9623sm4796228c88.4.2026.04.10.13.48.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Apr 2026 13:48:48 -0700 (PDT)
From: Xiang Mei <xmei5@asu.edu>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	coreteam@netfilter.org,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>
Subject: [PATCH nf] netfilter: nfnetlink_osf: fix divide-by-zero in OSF_WSS_MODULO
Date: Fri, 10 Apr 2026 13:48:43 -0700
Message-ID: <20260410204843.64259-1-xmei5@asu.edu>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The OSF_WSS_MODULO branch in nf_osf_match_one() performs:

  ctx->window % f->wss.val

without guarding against f->wss.val == 0.  A user with CAP_NET_ADMIN
can add an OSF fingerprint with wss.wc = OSF_WSS_MODULO and wss.val = 0
via nfnetlink.  When a matching TCP SYN packet arrives, the kernel
executes a division by zero and panics.

The OSF_WSS_PLAIN case already treats val == 0 as a wildcard (match
everything).  Apply the same semantics to OSF_WSS_MODULO: if val is 0,
any window value matches rather than dividing by zero.

Crash:
 Oops: divide error: 0000 [#1] SMP KASAN NOPTI
 RIP: 0010:nf_osf_match_one (net/netfilter/nfnetlink_osf.c:98)
 Call Trace:
 <IRQ>
  nf_osf_match (net/netfilter/nfnetlink_osf.c:220 (discriminator 6))
  xt_osf_match_packet (net/netfilter/xt_osf.c:32)
  ipt_do_table (net/ipv4/netfilter/ip_tables.c:348)
  nf_hook_slow (net/netfilter/core.c:622 (discriminator 1))
  ip_local_deliver (net/ipv4/ip_input.c:265)
  ip_rcv (include/linux/skbuff.h:1162)
  __netif_receive_skb_one_core (net/core/dev.c:6181)
  process_backlog (.include/linux/skbuff.h:2502 net/core/dev.c:6642)
  __napi_poll (net/core/dev.c:7710)
  net_rx_action (net/core/dev.c:7945)
  handle_softirqs (kernel/softirq.c:622)

Fixes: 31a9c29210e2 ("netfilter: nf_osf: add struct nf_osf_hdr_ctx")
Reported-by: Weiming Shi <bestswngs@gmail.com>
Signed-off-by: Xiang Mei <xmei5@asu.edu>
---
 net/netfilter/nfnetlink_osf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nfnetlink_osf.c b/net/netfilter/nfnetlink_osf.c
index 45d9ad231..193436aa9 100644
--- a/net/netfilter/nfnetlink_osf.c
+++ b/net/netfilter/nfnetlink_osf.c
@@ -150,7 +150,7 @@ static bool nf_osf_match_one(const struct sk_buff *skb,
 				fmatch = FMATCH_OK;
 			break;
 		case OSF_WSS_MODULO:
-			if ((ctx->window % f->wss.val) == 0)
+			if (f->wss.val == 0 || (ctx->window % f->wss.val) == 0)
 				fmatch = FMATCH_OK;
 			break;
 		}
-- 
2.43.0

