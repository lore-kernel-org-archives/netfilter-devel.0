Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B074B177AAE
	for <netfilter-devel@vger.kernel.org>; Mon, 25 Mar 2024 03:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711336799; cv=none; b=un6l8hUNVAy19kZV2nY/s7cYBPEZBiaKp+j9Z4rQG7do4YbQ2CiVCHSXaDfBf/mtxATPAttTD+xKreZvqm9tjvoe92TFjgOnqUw3HwnM+5iCI/7QxsOLRvOaVDXo77XtZj0VIvJcYzp8mghs60AnBQ23TvEjjek/0l2/l06VT7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711336799; c=relaxed/simple;
	bh=TRwrCO+3DCIyVVfea+eLKtT9WjLC84GKjzXappPS9MY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=e4anmFlWld5BFGXWWnFa/dT8hUow5F2j5mGhUbhwPm0qbmpMxxWMcQyha1ttiorfBNrF2ePUqgDqXTMCLPKizqYgwCUd+xnwf+mi99/I9+XRHEcyDdIDIa0uuCicTsQQxixZ5MJsEOMAiKwOrVxBREq+LHIZah5UvRNEd2ALtyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LIh64N43; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LIh64N43"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1dddad37712so35566395ad.3
        for <netfilter-devel@vger.kernel.org>; Sun, 24 Mar 2024 20:19:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1711336797; x=1711941597; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BEP8hVJmU+MKJLVx6LPlnR4Ie2GKCzGRQJvq5u8S/xU=;
        b=LIh64N43zVI0Uc67FI1qPfS9NnKfvzsc4EL6e55Xv3XMhZV6BnK5Vyt9qU5oqy9A/N
         n3u8VVh+cVrVZXNIotgl77GUeTYNdf+6vHl82r36y0gqTGiMX3ugMygMfjuTW4sp7lTt
         D32heZ41mik5vHuqa3EBgKiqmdDq1F81k1O5ViAMQopblwvpHS3gV+jO33CFIFLyr4vW
         hJyiHXTcxTPOG+UDnb8Fj2Um7nIkSoB0c79uAaVcSCf1g+yHvDfK5+lNd/1MKIEyWY10
         OgzTYfq5z5VifpeEI31cYZn+VZteW7iAUjJZWGRnntQmKP4TtsYU+siz1NBvLUw6bQlm
         8icA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711336797; x=1711941597;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BEP8hVJmU+MKJLVx6LPlnR4Ie2GKCzGRQJvq5u8S/xU=;
        b=nckfp4dOGRKoRvjFXZjZi1UykfuuXbattToeQqrH+jOeDUqkPFDtIRQfZHTrh+vxz1
         PbUA0+kFCazXlHVmw7EpUJRWHPOVZL6clWrJqgTShb2GOFSl9dbT5/26H/VkO7ce1pIh
         zZsB3ZcdselylGd51e7KyMdQw2U9PVJ9qxGG0fBGpTXQPpNdfWUph9UuCk6tiHJ0mn5O
         V5ElpXbw5eCsxWV14MhYuo+CDZfAdmgT4PVeD6hnEwgeWJkCSWAUHF/OUBUF2cmDtwvN
         0x9ns4EXgn4mSa6ClisQxjohXDnbiYrO16fYXtmbi6iWnY4URI49JVfv7aM1CAAxOfXm
         TIpg==
X-Gm-Message-State: AOJu0YwDwRXW/yE/kM57kv4KZdmZwp143CHCxzd06Lka9OMkprXHO7RY
	stltIZdGSVPyRfTKUyRTuRvuo5CvdOkfJ457imP3OKUttY/Cg+FM9Ol9GTZy
X-Google-Smtp-Source: AGHT+IE9DbFhkWyZ/gmAcpvX30GhzYvECwI0e1wZ1aL7a/iFCx4CHpecRi0NwUSYKJ5Us5zdWjMS4A==
X-Received: by 2002:a17:902:9008:b0:1e0:9928:5fbe with SMTP id a8-20020a170902900800b001e099285fbemr5788229plp.67.1711336797049;
        Sun, 24 Mar 2024 20:19:57 -0700 (PDT)
Received: from KERNELXING-MB0.tencent.com ([43.132.141.24])
        by smtp.gmail.com with ESMTPSA id b15-20020a170902d50f00b001e0bae4490fsm1254080plg.154.2024.03.24.20.19.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Mar 2024 20:19:55 -0700 (PDT)
From: Jason Xing <kerneljasonxing@gmail.com>
To: pablo@netfilter.org,
	kadlec@netfilter.org
Cc: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	kerneljasonxing@gmail.com,
	Jason Xing <kernelxing@tencent.com>
Subject: [PATCH net-next 2/3] netfilter: use NF_DROP in iptable_filter_table_init()
Date: Mon, 25 Mar 2024 11:19:44 +0800
Message-Id: <20240325031945.15760-3-kerneljasonxing@gmail.com>
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
 net/ipv4/netfilter/iptable_filter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/netfilter/iptable_filter.c b/net/ipv4/netfilter/iptable_filter.c
index b9062f4552ac..3ab908b74795 100644
--- a/net/ipv4/netfilter/iptable_filter.c
+++ b/net/ipv4/netfilter/iptable_filter.c
@@ -44,7 +44,7 @@ static int iptable_filter_table_init(struct net *net)
 		return -ENOMEM;
 	/* Entry 1 is the FORWARD hook */
 	((struct ipt_standard *)repl->entries)[1].target.verdict =
-		forward ? -NF_ACCEPT - 1 : -NF_DROP - 1;
+		forward ? -NF_ACCEPT - 1 : NF_DROP - 1;
 
 	err = ipt_register_table(net, &packet_filter, repl, filter_ops);
 	kfree(repl);
-- 
2.37.3

