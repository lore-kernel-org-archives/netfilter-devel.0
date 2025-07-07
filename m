Received: from mail-qv1-f74.google.com (mail-qv1-f74.google.com [209.85.219.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91E44194094
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Jul 2025 12:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751892322; cv=none; b=HL9eZoHZ+/r1wql0cTMuiWXLe1S3OPW/dHw6XQUfyjIQL84Q+qT8wXvz8ZtzleP+QsIEBXPqZk9MpS2y9MemUYtWV0GvwnBrZjseQv9qSudbo8Y+kpAjAcrLl4cGuWxqTETn1uXof0XWe3uX6d/eZvMmdyKnnNQBNegCGG7SBPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751892322; c=relaxed/simple;
	bh=mAb87fXBGDVXDZ0JPirJNsxeZkkIXHxmpepCDDLlLls=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=iDpfLgeZkd7lF5v8JZAxXwDNo71tKaarEO7glEeqxglmtkvNQZs5/TtScGLET/PFy+a/Nm/5E1YQ2gOtUTMriIyAaj9ybJaFDS/Gnr2/JjyVPpzT5mfcRx57Z+yQ/pJfzlOFe9zXYm8oqcDMeev8AKT7VLRC7+pZIl3Prdj0vAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--edumazet.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VewM37dd; arc=none smtp.client-ip=209.85.219.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--edumazet.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VewM37dd"
Received: by mail-qv1-f74.google.com with SMTP id 6a1803df08f44-6fb3bb94b5cso56688876d6.2
        for <netfilter-devel@vger.kernel.org>; Mon, 07 Jul 2025 05:45:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1751892319; x=1752497119; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Mx/au/ucpX1Q+GazmfVIyz7+AbuT93/bgT+tTi6UiYM=;
        b=VewM37dd0vv6DdBU1I8mrXgS/1sEObB4vBJKV7Yxuy2mpbxf3Lm6MQzk8DKHLXnSrG
         LWF35I+cca67QYk6QDEu4G81CLKDkkVZTvELwYDD+sCvuTdWM9sGMqhGrUwQlAUA/JHo
         lsncmqCfXgF89ozcuSTZZSkzO1164bdZ6UW3uowc81Nl/v2/OaeQVdIYYECCHs6550Pc
         F2nZqyNeEpr49gjUQFKzpg3WVD6xl9yO0UVs6uFMaZUSDRcdeOIRrgUEAjP1YxfOP0/O
         cneFX8lbYT1QQlQxLIsFZJiwYTxST8j4P+vChIlGM/BOI7nKRX/VnI4vMiMNRWCi3YRW
         xR2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751892319; x=1752497119;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Mx/au/ucpX1Q+GazmfVIyz7+AbuT93/bgT+tTi6UiYM=;
        b=BadW9Sq69aspatCRS3s5jqTBgudQEzetyP1uUti/MUp2BYK0t7Vunz9m2BAeAEeOKw
         bIJ0G7YZ0mgpWNp5edKxNEaDd/09/TkxM36Q3sYDTnSPgUf1XKelEMC3l/6DPokN3kPb
         xepaHycRsNf5IpOyW/vwj8SbIQzCTQ88KxDFS7QUJWYeyP20qr/CnaZ+TrGaWSMI4KmA
         cSb3VX8krGHvUQARZ2RdrCfOJC8Yodg0nP6LMXEs4Tvnsf8JecS7RtEUs6WRduklIjU2
         nNgX39XlpkPK6LRhKDz8IV0fP0iAVRdnbOiErFtPLQvmfLz9dN5u1NJQLBqNeRAqDupF
         Bqfw==
X-Forwarded-Encrypted: i=1; AJvYcCXLCFS5SIUT/6r5weS8yt//PRPXQ7tWh/43E7PIFQS/MSshY7g0vcjyRVC6hBGW6S6AUI4Y4vvUCKuiA8T0bHo=@vger.kernel.org
X-Gm-Message-State: AOJu0YyYRTg08GWB+ruDwwpw6jSvBrr4l7w750q44v6Acy1vrVupp7QL
	MzFRalaDDZJc1XvmsN/B4TbQ6vZEewwxw1+BbrsjWJdEWTent0J4hmUNy5NMhbaHmNVxKhxPIHZ
	1MGlGac0Xc/fszw==
X-Google-Smtp-Source: AGHT+IGbAx51UxKP3h0/ZliZVJ6ft5RP8SjqFxTr0zzXn/91aFTd+6YP5jLXtKyBp3vrcziylQJL0dHHNladxw==
X-Received: from qvbmw8.prod.google.com ([2002:a05:6214:33c8:b0:6fd:74e5:26b1])
 (user=edumazet job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6214:5d0f:b0:6fd:609d:e924 with SMTP id 6a1803df08f44-702d16b5b13mr153633826d6.36.1751892319483;
 Mon, 07 Jul 2025 05:45:19 -0700 (PDT)
Date: Mon,  7 Jul 2025 12:45:17 +0000
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250707124517.614489-1-edumazet@google.com>
Subject: [PATCH net] netfilter: flowtable: account for Ethernet header in nf_flow_pppoe_proto()
From: Eric Dumazet <edumazet@google.com>
To: "David S . Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Pablo Neira Ayuso <pablo@netfilter.org>, 
	Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, 
	coreteam@netfilter.org, eric.dumazet@gmail.com, 
	Eric Dumazet <edumazet@google.com>, syzbot+bf6ed459397e307c3ad2@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"

syzbot found a potential access to uninit-value in nf_flow_pppoe_proto()

Blamed commit forgot the Ethernet header.

BUG: KMSAN: uninit-value in nf_flow_offload_inet_hook+0x7e4/0x940 net/netfilter/nf_flow_table_inet.c:27
  nf_flow_offload_inet_hook+0x7e4/0x940 net/netfilter/nf_flow_table_inet.c:27
  nf_hook_entry_hookfn include/linux/netfilter.h:157 [inline]
  nf_hook_slow+0xe1/0x3d0 net/netfilter/core.c:623
  nf_hook_ingress include/linux/netfilter_netdev.h:34 [inline]
  nf_ingress net/core/dev.c:5742 [inline]
  __netif_receive_skb_core+0x4aff/0x70c0 net/core/dev.c:5837
  __netif_receive_skb_one_core net/core/dev.c:5975 [inline]
  __netif_receive_skb+0xcc/0xac0 net/core/dev.c:6090
  netif_receive_skb_internal net/core/dev.c:6176 [inline]
  netif_receive_skb+0x57/0x630 net/core/dev.c:6235
  tun_rx_batched+0x1df/0x980 drivers/net/tun.c:1485
  tun_get_user+0x4ee0/0x6b40 drivers/net/tun.c:1938
  tun_chr_write_iter+0x3e9/0x5c0 drivers/net/tun.c:1984
  new_sync_write fs/read_write.c:593 [inline]
  vfs_write+0xb4b/0x1580 fs/read_write.c:686
  ksys_write fs/read_write.c:738 [inline]
  __do_sys_write fs/read_write.c:749 [inline]

Reported-by: syzbot+bf6ed459397e307c3ad2@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/686bc073.a00a0220.c7b3.0086.GAE@google.com/T/#u
Fixes: 87b3593bed18 ("netfilter: flowtable: validate pppoe header")
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/netfilter/nf_flow_table.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index d711642e78b57c75043e94bf00b782398e5f3621..c003cd194fa2ae40545a196fcc74e83c2868b113 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -370,7 +370,7 @@ static inline __be16 __nf_flow_pppoe_proto(const struct sk_buff *skb)
 
 static inline bool nf_flow_pppoe_proto(struct sk_buff *skb, __be16 *inner_proto)
 {
-	if (!pskb_may_pull(skb, PPPOE_SES_HLEN))
+	if (!pskb_may_pull(skb, ETH_HLEN + PPPOE_SES_HLEN))
 		return false;
 
 	*inner_proto = __nf_flow_pppoe_proto(skb);
-- 
2.50.0.727.gbf7dc18ff4-goog

