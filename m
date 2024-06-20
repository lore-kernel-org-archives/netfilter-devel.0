Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F15AA1ABCC4
	for <netfilter-devel@vger.kernel.org>; Thu, 20 Jun 2024 11:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718883338; cv=none; b=TwJUsZ5EXZrT+HvRCYPZAQgS0/R0uT7sphwObWq+gYrET8w1IUyUnPDEirfdEHkJK/m5gOsSypTpP0WlKlkeyWzzGrVwqADXgaEJAqflz/r9XMUlv6vdCMmXoutUNQrvMxQ5pna8W+FYFNy9187YT9E/yH+A96MYNdS7cG5GaTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718883338; c=relaxed/simple;
	bh=x7omDxUPbZV7/HufJPxDWQarrRBoOigY55WGBtYBibA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JJ0ja3Ob50f03wFYeM6N09WaQt1suSzerqGEgAmOsvOC80SRP6Ge4biixKTGMbfPFBYiQnEJwe4p3T8prX+uL9x6p3EBz882ktqjTZlMMNwKCV6iFb6XgGtik5+VXqMW72yaFbsu4/LetmjOoKkp41PXTA2wTRIWA4mayvUNFfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=smartx.com; spf=none smtp.mailfrom=smartx.com; dkim=pass (2048-bit key) header.d=smartx-com.20230601.gappssmtp.com header.i=@smartx-com.20230601.gappssmtp.com header.b=QKqQ0Je0; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=smartx.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=smartx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=smartx-com.20230601.gappssmtp.com header.i=@smartx-com.20230601.gappssmtp.com header.b="QKqQ0Je0"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-2c2c6b27428so638103a91.3
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Jun 2024 04:35:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smartx-com.20230601.gappssmtp.com; s=20230601; t=1718883335; x=1719488135; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1dVIO9B/gKgBOADV8jO7dDGNIDax+746A0tzxgyv+QQ=;
        b=QKqQ0Je0QBdrTIm8zqLUzlEAZfwYryBBrosrKrNumTWbU2c4RQYEvfuwNdRlN9r+0j
         xJP+tZjJBgDxmloGyr3PS/91c+WIwWnTstxMODex64/Ro5jY+CJm2VdcVPGuzsUPUp/K
         19GBDtOX6vYyZTBSGHX1vgKtXTAwscV+A/o05ZSWh9/hwda+qM91oI26q09SqwFs67s1
         /9lgW/tDvqC93K/Z22g9PxCbfGI61H5HzngcxENS5stf7Y1QdRWerdyGOqkC2rTKX/WE
         usB8dVaE7ATi2L7NTHJFfng2Tn9TfxyYzmeojwkJP9+N+MHWokTrbERGiLpuIH0e0z6J
         4+Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718883335; x=1719488135;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1dVIO9B/gKgBOADV8jO7dDGNIDax+746A0tzxgyv+QQ=;
        b=c67h8v88WtwIL6WgSxe0mKtfgSDMgCs7hMXEM0iTxDxvA4gOPYufnL9bA00AgZN98H
         BMxGQlyyTnPHO1mPb4ls50s6uNr0bEgGnugMz1i3VDd9Q1TvSz5Mn/AZIKesOS2P5PjQ
         1G40NEx5mILDx8oKlWbbGW5TwDKp9JxpX3dRa4OXZ13US7yP1zpeH6vg7susxHupU/KY
         LjFCqWIibWcu5j7uAmemZyOLpwq2es4Bn9NJnuVLC6GLPB278SOcxUN9HV2j3vDExxSC
         6hMWqhkt+d1VUyKMyJaUt0nDHF/bp9OoSw9UGbAmPiwLayqMZfpeeQAsJJE8eIje4qh5
         3LpQ==
X-Gm-Message-State: AOJu0YxusFW9gccSrWfz3d6micyOUnTfUMK8wdMqLFVn10vom+O8RyYV
	DnqGdvTbnIupuztgWiW8OSgX2MmVw6NkQpLzHQrOzbU70Mke6QZIyVmCKB4y3wA=
X-Google-Smtp-Source: AGHT+IFRllndN6Xym3DAVRxuUPeCS0DRq1KGMb2aEJa7kDuGQNYUEeIY8ehUjwujMjdb446BuXz+yg==
X-Received: by 2002:a17:90b:104c:b0:2c7:6305:9905 with SMTP id 98e67ed59e1d1-2c7b57ff1f9mr4863150a91.10.1718883334926;
        Thu, 20 Jun 2024 04:35:34 -0700 (PDT)
Received: from remote.smartx.com ([1.202.18.10])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2c7e5af9db7sm1442885a91.40.2024.06.20.04.35.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jun 2024 04:35:34 -0700 (PDT)
From: Changliang Wu <changliang.wu@smartx.com>
To: pablo@netfilter.org,
	kadlec@netfilter.org,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com
Cc: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Changliang Wu <changliang.wu@smartx.com>
Subject: [PATCH] netfilter: ctnetlink: support CTA_FILTER for flush
Date: Thu, 20 Jun 2024 19:35:27 +0800
Message-ID: <20240620113527.7789-1-changliang.wu@smartx.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From cb8aa9a, we can use kernel side filtering for dump, but
this capability is not available for flush.

This Patch allows advanced filter with CTA_FILTER for flush

Performace
1048576 ct flows in total, delete 50,000 flows by origin src ip
3.06s -> dump all, compare and delete
584ms -> directly flush with filter

Signed-off-by: Changliang Wu <changliang.wu@smartx.com>
---
 net/netfilter/nf_conntrack_netlink.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 3b846cbdc..93afe57d9 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1579,9 +1579,6 @@ static int ctnetlink_flush_conntrack(struct net *net,
 	};
 
 	if (ctnetlink_needs_filter(family, cda)) {
-		if (cda[CTA_FILTER])
-			return -EOPNOTSUPP;
-
 		filter = ctnetlink_alloc_filter(cda, family);
 		if (IS_ERR(filter))
 			return PTR_ERR(filter);
@@ -1610,14 +1607,14 @@ static int ctnetlink_del_conntrack(struct sk_buff *skb,
 	if (err < 0)
 		return err;
 
-	if (cda[CTA_TUPLE_ORIG])
+	if (cda[CTA_TUPLE_ORIG] && !cda[CTA_FILTER])
 		err = ctnetlink_parse_tuple(cda, &tuple, CTA_TUPLE_ORIG,
 					    family, &zone);
-	else if (cda[CTA_TUPLE_REPLY])
+	else if (cda[CTA_TUPLE_REPLY] && !cda[CTA_FILTER])
 		err = ctnetlink_parse_tuple(cda, &tuple, CTA_TUPLE_REPLY,
 					    family, &zone);
 	else {
-		u_int8_t u3 = info->nfmsg->version ? family : AF_UNSPEC;
+		u8 u3 = info->nfmsg->version || cda[CTA_FILTER] ? family : AF_UNSPEC;
 
 		return ctnetlink_flush_conntrack(info->net, cda,
 						 NETLINK_CB(skb).portid,
-- 
2.43.0

