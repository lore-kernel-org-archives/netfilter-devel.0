Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACF22177AA9
	for <netfilter-devel@vger.kernel.org>; Mon, 25 Mar 2024 03:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711336796; cv=none; b=qDwCMiHIbPiv0NoNYNtELrQnhwlE/hQYSUMy4n3xwlCfbWMLGOTyJ4UTdAdFj0eJAfwd77cWrOjfRhaZw6o/IcDtnaQRAtWTrUfNDWqjh53sBHAd55lKRDjUj2gYWGkhliJTgjdiuz7Ld7GA+iSKdBtrStIfeJwGY1Fca8/+67U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711336796; c=relaxed/simple;
	bh=uWIbQbhTo1k5Hm2P3NjS7IiGjLT923Fdb/LEytpCR3M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cvhARhWbFPgQPb1bBCOtBGcQNXLb+xPacSPXGsWvl6zca6DMA+miUmWNnfTH2SartR9yNIoFn4NETmmd/E2+wq+2y6ZAo37kynBcrdzqR5bCDNQqA5xXy2Vqs9oiTKTY5hfgIRcGw6OemQ3rnjhX/BxXeJsxRUF5QRWCRFmcG6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TgleY1H9; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TgleY1H9"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1dddad37712so35566165ad.3
        for <netfilter-devel@vger.kernel.org>; Sun, 24 Mar 2024 20:19:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1711336794; x=1711941594; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6auhInn5rzDEYzHLqWOU0+st73Pngssi19sn4m6uy20=;
        b=TgleY1H9ftovaKPPpqfDiFOd5sArOM0hsf9D4S8+yQoxBTeDlzRF1VT0uKax7ZIVoM
         qupSJNimORnL+h6ddM1sKYWhs+oSbk4ViGuFQ1jsDdQbAENJnRdClvoRQCO8zFIoEIOg
         GAGk/CqGB4biyvGKkXmDlIXpH5MhfxiJfn6wnxChRPH8NbuDRyfd/RFy09GG/w6xV7Cs
         y8fH4R5WF63DlCoModZEtdqIfjkFcPqUyG9la3F5YDKkrTp575s4vl+iuflJwyH/x0Hs
         0BMx5DEGRzjEhnMSt9mT3fw5OcEdpx6l0Xp28UdUak5B5MwUpfJXfozA8Q7PF0gCB/xS
         L3nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711336794; x=1711941594;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6auhInn5rzDEYzHLqWOU0+st73Pngssi19sn4m6uy20=;
        b=KzV8nGHsK50yjQJyu9J280O+7M5uc4SxbsQ5liiC8YZwaQEYkHIZARkVxOsJTU0Hvb
         99bf8ve+vqReLvlyvVci7cnOzwnD3Q7Fiwle7HUxwubjUy4bhoRbpUeSvakKcfYInFKT
         4z9MLvkiG42i/Kzt1PqN43nAusgmnfD4f5jJQe+UVnA8G34DgJNgEXBhjuHYv6gJIPb8
         T1Zv6PM48ODzaaoTuoErDqbnRYLkYF7wzTLbvczMbmFv6v/Z/vD3QosLmDzjtoo0XZ0q
         Yv8sc63Bwp+FoRdwPIvCdvnQa89MlyySI/AIYi0SQnos9s0DQ2zh7jeL6unKZEUNS03o
         R2cg==
X-Gm-Message-State: AOJu0YxGdTSPNTDVmRZS8rld/mef2rDUg1yUBTKmBTCXbsrY75o8sOJt
	wE4aArz1OG2ksmnR3jN1kthIRhF6+HnRu/QREyeBSO+Ct/QyHEcD
X-Google-Smtp-Source: AGHT+IFz9lr7vlHmCPYlxETrT6SnL2XPeBeG16d5qvkaksdLbFEuOdr2rXM34N5uTufwm2gPh4LFeg==
X-Received: by 2002:a17:903:110f:b0:1e0:2685:8fd4 with SMTP id n15-20020a170903110f00b001e026858fd4mr7117786plh.58.1711336793948;
        Sun, 24 Mar 2024 20:19:53 -0700 (PDT)
Received: from KERNELXING-MB0.tencent.com ([43.132.141.24])
        by smtp.gmail.com with ESMTPSA id b15-20020a170902d50f00b001e0bae4490fsm1254080plg.154.2024.03.24.20.19.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Mar 2024 20:19:53 -0700 (PDT)
From: Jason Xing <kerneljasonxing@gmail.com>
To: pablo@netfilter.org,
	kadlec@netfilter.org
Cc: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	kerneljasonxing@gmail.com,
	Jason Xing <kernelxing@tencent.com>
Subject: [PATCH net-next 1/3] netfilter: using NF_DROP in test statement in nf_conntrack_in()
Date: Mon, 25 Mar 2024 11:19:43 +0800
Message-Id: <20240325031945.15760-2-kerneljasonxing@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20240325031945.15760-1-kerneljasonxing@gmail.com>
References: <20240325031945.15760-1-kerneljasonxing@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jason Xing <kernelxing@tencent.com>

At the beginning in 2009 one patch [1] introduced collecting drop
counter in nf_conntrack_in() by returning -NF_DROP. Later, another
patch [2] changed the return value of tcp_packet() which now is
renamed to nf_conntrack_tcp_packet() from -NF_DROP to NF_DROP.

Well, as NF_DROP is equal to 0, inverting NF_DROP makes no sense
as patch [2] did many years ago.

[1]
commit 7d1e04598e5e ("netfilter: nf_conntrack: account packets drop by tcp_packet()")
[2]
commit ec8d540969da ("netfilter: conntrack: fix dropping packet after l4proto->packet()")

Signed-off-by: Jason Xing <kernelxing@tencent.com>
---
 net/netfilter/nf_conntrack_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index c63868666bd9..6102dc09cdd3 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -2024,7 +2024,7 @@ nf_conntrack_in(struct sk_buff *skb, const struct nf_hook_state *state)
 			goto repeat;
 
 		NF_CT_STAT_INC_ATOMIC(state->net, invalid);
-		if (ret == -NF_DROP)
+		if (ret == NF_DROP)
 			NF_CT_STAT_INC_ATOMIC(state->net, drop);
 
 		ret = -ret;
-- 
2.37.3

