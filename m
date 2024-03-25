Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B69E02609D6
	for <netfilter-devel@vger.kernel.org>; Mon, 25 Mar 2024 02:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711335588; cv=none; b=X5ssvBEHzwfrQZe1S+88U1CD7XW8dMlP2iMiNfGoaD7snYN+QwZGFne8CK8/u2ErKzvhIm5Vkz0n4Jmf0SvGpij1Uc7AncQS3tGqryJ6dT460eHp5Ue8+C1/DOqBjg8GDJ8Wx3FDFXpq+5IiMidHjlCldLzFvpBSnZItZnFpGE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711335588; c=relaxed/simple;
	bh=ucQQZmM7b9hyC+2ANgklO59WSYi72bjbCEXLjqmCTwc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=fJrDa3La6m19gDZXK+Es9HVo94rO0d1qOX4ThR9CPiCH7Ak2TCbqppXivcL9RAwHoDPj6djDOJnOwbbCOgrHyEYeKmEebSCbvj8xXKjCwCe8PMaBggmgY1awZ0/z+N2PaqPpv1y8IM2sSy7fpU0jWBv6bjeqLtHlLySGfKTPxWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Kz/DBTCt; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Kz/DBTCt"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-6ea9a605ca7so597995b3a.0
        for <netfilter-devel@vger.kernel.org>; Sun, 24 Mar 2024 19:59:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1711335585; x=1711940385; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=k7K45euCF/qq3ygGTU+6x9q1sAkdMJRdlnyMBA7AI9Q=;
        b=Kz/DBTCtAHMziNDf7LkKbkUp/JG3pgkzfi9490YKoUZlH5rUVbhyndNmH0DJvVR+96
         BvgbzuNewdeE0jTIfAmkwL210l3YF/81Vd+3WoMfdyjxW5Lzqikrlmxpj4cIKjh1WwDc
         y5VncaKWnX5HzBQuwoLgOE2xjZMhE+phKj0incdr9c/rnHZ7hS0KDyhSQypxUTp/Eq0J
         bViYr0ugYZZhpC5sXyEOR+shr6rd7RqR+Kw5Br6bmwzQZgsy+Y3xXBQXJvobxnEDSAa7
         ii8rSFo7gfSTU3WD1bD4vng9FKnnf9SP636AgPp1b7n8BKwvsqmjBlTQAPaHAyPGrDfy
         bzCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711335585; x=1711940385;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=k7K45euCF/qq3ygGTU+6x9q1sAkdMJRdlnyMBA7AI9Q=;
        b=NxlOLYy1PQypo5fmd3yM/S0kJPDVLse4s50Cgv4ATObqQYMmMiSYLUeZARp6r9ZsXj
         UdmigCz7AZx/iu1mdP7VCBZtdDHp9iCakXz3mWUfYFI8Mo+HjVlODESIdsTj38ETAwvJ
         VY5QSECXKkmFF3v6Jw0OoyE92qbvgcF0IdrW8mFJHkp5sFKYnBdJ37Z8eMC5mw4xqlHo
         sj2oJJtM2Zf7AaIt+sr4GoT+sESFStw4ZIyIIN/KrYAu1atQCGuIABfPQZ9CjNmE+0ZH
         77uI2Ss8/Fr7byFX7W0xzjFt2KmELJ4QTJrEDO+nlsy7rt+fUnNo2uVIi96DJQWpW2m3
         TcvQ==
X-Gm-Message-State: AOJu0YzOks/+LvrIbtjGb2K1XKePeeYuAtjgHhEquTTl//px4lF9cDF0
	aG0b9+Wl2ZhurlZ8mBFWDE7irroL1ezNeBg9w0EwAWerpv0HeCcM
X-Google-Smtp-Source: AGHT+IFQ4+wTLUPo6RG3T0fPXL7Bs5IvaxlyZ6dEtqnuno2xJsRYscF4ePiTM8QTw/Bdgv/FHu4Pog==
X-Received: by 2002:a05:6a00:2347:b0:6ea:7ba2:5003 with SMTP id j7-20020a056a00234700b006ea7ba25003mr7841590pfj.13.1711335584935;
        Sun, 24 Mar 2024 19:59:44 -0700 (PDT)
Received: from KERNELXING-MB0.tencent.com ([43.132.141.25])
        by smtp.gmail.com with ESMTPSA id r16-20020a056a00217000b006ea6d1d3134sm3257151pff.119.2024.03.24.19.59.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Mar 2024 19:59:44 -0700 (PDT)
From: Jason Xing <kerneljasonxing@gmail.com>
To: pablo@netfilter.org,
	kadlec@netfilter.org
Cc: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	kerneljasonxing@gmail.com,
	Jason Xing <kernelxing@tencent.com>
Subject: [PATCH RESEND net-next] netfilter: conntrack: dccp: try not to drop skb in conntrack
Date: Mon, 25 Mar 2024 10:59:38 +0800
Message-Id: <20240325025938.12370-1-kerneljasonxing@gmail.com>
X-Mailer: git-send-email 2.33.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jason Xing <kernelxing@tencent.com>

It would be better not to drop skb in conntrack unless we have good
alternatives. So we can treat the result of testing skb's header
pointer as nf_conntrack_tcp_packet() does.

Signed-off-by: Jason Xing <kernelxing@tencent.com>
---
 net/netfilter/nf_conntrack_proto_dccp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_dccp.c b/net/netfilter/nf_conntrack_proto_dccp.c
index e2db1f4ec2df..ebc4f733bb2e 100644
--- a/net/netfilter/nf_conntrack_proto_dccp.c
+++ b/net/netfilter/nf_conntrack_proto_dccp.c
@@ -525,7 +525,7 @@ int nf_conntrack_dccp_packet(struct nf_conn *ct, struct sk_buff *skb,
 
 	dh = skb_header_pointer(skb, dataoff, sizeof(*dh), &_dh.dh);
 	if (!dh)
-		return NF_DROP;
+		return -NF_ACCEPT;
 
 	if (dccp_error(dh, skb, dataoff, state))
 		return -NF_ACCEPT;
@@ -533,7 +533,7 @@ int nf_conntrack_dccp_packet(struct nf_conn *ct, struct sk_buff *skb,
 	/* pull again, including possible 48 bit sequences and subtype header */
 	dh = dccp_header_pointer(skb, dataoff, dh, &_dh);
 	if (!dh)
-		return NF_DROP;
+		return -NF_ACCEPT;
 
 	type = dh->dccph_type;
 	if (!nf_ct_is_confirmed(ct) && !dccp_new(ct, skb, dh, state))
-- 
2.37.3

