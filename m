Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 483F8177AB4
	for <netfilter-devel@vger.kernel.org>; Mon, 25 Mar 2024 03:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711336801; cv=none; b=KFTQKvAuW6InfCCXn84GYeJfTbQ8eE8d5Bs/dlKSxzPmTfJPBO3MqskAoQ3/uyCOt9lloDK3T7lybFnabXaR4erx71dZZEUD/qhk5w98QQIgMriVyF08D1zkDiFMlfcrnqJufqdmQrKbAs9l51+8N6Bscz7UdTJvcCTlxVJh/9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711336801; c=relaxed/simple;
	bh=Q2stLWiHzql8MVpPJvMXrTk49sM7hixiBZhPJKFy9NA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=I0WM0ucsYQ7rKBzvlqPPPKGkBpoGlSUuiN6/JkZfMcNz/LHHSCaK+w5OrxD9PYfGYBAwps5L2T+lcT8Vc8d9rXg7bu2xBnCbdXQfT3Olr11KFwJmGDz/57q4sXYhVvACp8KrGmiRNGf3oihUTSGuQSHTRJJdnq4EJnI8+tBU8kU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Iun5Bq2t; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Iun5Bq2t"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-6e703e0e5deso2707676b3a.3
        for <netfilter-devel@vger.kernel.org>; Sun, 24 Mar 2024 20:20:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1711336799; x=1711941599; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EpBS5KNG4auxEVPo/hANBY69uPpmtUhZe7khSS71rUQ=;
        b=Iun5Bq2t58y+BK+7+DMiTpxiuGdp/Ia2ToAmWXlXybmgo9QrCe8H5AutPSDsgGNg70
         4TbD3+L6ibyDuZ9Hgm9ek00GzPCAr+zY3TYuIoHQnwzeSnB9uc7PQ7ue53CuYOYPMG6h
         XAPkxiUjfOU3IjnOwon0+DbzBTeKAyxXdML0zANgi2w9TORRf/8/AJFqQv+HZIvoNCW9
         PNYrqGmlBCprazQEstSVDqWoyISTaOilv9vt7n+F5nR1NIrMGLKgNrGCUahncuDUVb4V
         GQ3K9ybpweFIXtC5Z23FE8BCDMamHzDbKSUYLwe4mhdmnuaB+92NF8VGuSHKpRr2DmVr
         el3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711336799; x=1711941599;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EpBS5KNG4auxEVPo/hANBY69uPpmtUhZe7khSS71rUQ=;
        b=rkHfhR5kUF8T5BHq4wTldMpePIdwGbwcYb94lSUTdpEXEdPbTn8OQntFbB5EvuB9VG
         JzNGYrfqiKS8HxoMOb4aXSSUK47cZnUdicdIoEYBaqleJCFW2RG8V6T1iYug0EtuUu1O
         n9utBS4A2UKJ/OSMGREnCC99rWHqcR285pA8B1BHZ6WbZ+D3Bhmn3QMvRhICmNjHbJ3v
         gbcVMfQlXrHDHDzhzOs9JpNoYnq799XbkfsdOHuwsnifYQ5yFCKKt2EBeH64JwwnsDNt
         uqOE1x9pRhv2/J6FFbHPuP7liKVU2bf5iKOtTaufIUyLu938XQ8WYjuonxYdZ/RTTozE
         MREw==
X-Gm-Message-State: AOJu0Yw6z+ZVjsjxvsjmrUdxzQrK+1hlIiXQbKmQpYbVE8hjLUo2jKiV
	Dgi396RpPm4HJ+l8VbFEg3/wSTpFwCXsVmVxemurE0p+DcTXeuPJ
X-Google-Smtp-Source: AGHT+IEXpiEPBciXWBdrhshaAOnzTBEtnuflyl88DMxULbjALnILxuev+h2ILSx4v7nLwoXwjCDopQ==
X-Received: by 2002:a05:6a20:3947:b0:1a3:32e5:f38a with SMTP id r7-20020a056a20394700b001a332e5f38amr5590451pzg.45.1711336799485;
        Sun, 24 Mar 2024 20:19:59 -0700 (PDT)
Received: from KERNELXING-MB0.tencent.com ([43.132.141.24])
        by smtp.gmail.com with ESMTPSA id b15-20020a170902d50f00b001e0bae4490fsm1254080plg.154.2024.03.24.20.19.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Mar 2024 20:19:58 -0700 (PDT)
From: Jason Xing <kerneljasonxing@gmail.com>
To: pablo@netfilter.org,
	kadlec@netfilter.org
Cc: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	kerneljasonxing@gmail.com,
	Jason Xing <kernelxing@tencent.com>
Subject: [PATCH net-next 3/3] netfilter: use NF_DROP in ip6table_filter_table_init()
Date: Mon, 25 Mar 2024 11:19:45 +0800
Message-Id: <20240325031945.15760-4-kerneljasonxing@gmail.com>
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

There is no need to use the negative -NF_DROP because the definition
is just zero.

Signed-off-by: Jason Xing <kernelxing@tencent.com>
---
 net/ipv6/netfilter/ip6table_filter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/netfilter/ip6table_filter.c b/net/ipv6/netfilter/ip6table_filter.c
index df785ebda0ca..e8992693e14a 100644
--- a/net/ipv6/netfilter/ip6table_filter.c
+++ b/net/ipv6/netfilter/ip6table_filter.c
@@ -43,7 +43,7 @@ static int ip6table_filter_table_init(struct net *net)
 		return -ENOMEM;
 	/* Entry 1 is the FORWARD hook */
 	((struct ip6t_standard *)repl->entries)[1].target.verdict =
-		forward ? -NF_ACCEPT - 1 : -NF_DROP - 1;
+		forward ? -NF_ACCEPT - 1 : NF_DROP - 1;
 
 	err = ip6t_register_table(net, &packet_filter, repl, filter_ops);
 	kfree(repl);
-- 
2.37.3

