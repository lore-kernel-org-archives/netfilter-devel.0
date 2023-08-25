Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1436C3DA6F
	for <netfilter-devel@archiver.kernel.org>; Fri, 25 Aug 2023 05:34:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234127AbjHYFeS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 25 Aug 2023 01:34:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232159AbjHYFds (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 25 Aug 2023 01:33:48 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D829F1BC2
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Aug 2023 22:33:45 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id d2e1a72fcca58-68a42d06d02so501770b3a.0
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Aug 2023 22:33:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692941625; x=1693546425;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=/AkFGltIaPaHhWpT4OGgFZ8CptseLIMA1vrgYgGb2yE=;
        b=c0Z6JfP1rPyXRuGgmp0pSv31qGG3TAmpsnsv78vckzvSYI8NjlZ/KoQDuEfINkMFm7
         INgRsrantyIujJhLlvH9GoQ7wHDkHx8nlnqPjb/i5wCzwCU9QNFEQQ+iwGHiIl6nmK8a
         aOa/p9zu4Ka2qQOav1M5ULxUHKZMH7BrOMdwXPXDNvKsIy9uSw3UtRLGhX0jLhAYhJhb
         KdB94cg3GTEykzWj7a5eYXXFmepaMLeg02TfmML8q3B4qCwYj8l22IDmgxdfGZnLYPX1
         O5kvsrVdJ03+1sALMQET75mb09noJtAD9XFOCrO/kOEXxzAR/15VC+nlsjsnLtJlLVJP
         JWtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692941625; x=1693546425;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/AkFGltIaPaHhWpT4OGgFZ8CptseLIMA1vrgYgGb2yE=;
        b=ipgpEl1Afy2yOSVWdU560s2zFEw4Fgs++2mMioIyzAE0vDjxmldaJu+JSwVpQWVKFw
         SSgtUKPtoz28lrICwB4nvTmLlCgjf0tHPoTrp5MJkL5kHauMs4cxwiZNsTgrQLoDWWpJ
         ZjBcFteiDjejHJcPzU9zMPq3CdQuyyZWmZzcWVOujZT0A8s9YV4iRh+jPvdCsiayk4oZ
         NnN0I0yYEU6b8A4fiedaijNBIV6O39g1ROEBa/p1G2v/wDNHfFVEZCuPZGWP3VKZk9DC
         B1aFEfvXLwGXwq4FTIuvlfJJeNm8WxkoGZp4tLSlZjBIstiAlSvNKUX5q5Ewhe+YDelJ
         Fdfg==
X-Gm-Message-State: AOJu0YztcFuaSzh8PP0yKbZYNrXAlGfLwOIKKzlOaLlPgBUeK0FQ6i/9
        B2xNnvDGi1jnfbL0cqmQaOleea2MumXZlg==
X-Google-Smtp-Source: AGHT+IEDdJ0Jsz1Z/B5grswkvXwkTV/VT5gByimNdJYEHlsg6iCZqUSVRFcwIDbsoXQ5zavoPM2V2A==
X-Received: by 2002:a05:6a00:2395:b0:68a:5cf8:dad5 with SMTP id f21-20020a056a00239500b0068a5cf8dad5mr12144578pfc.2.1692941625055;
        Thu, 24 Aug 2023 22:33:45 -0700 (PDT)
Received: from nova-ws.. ([103.167.140.11])
        by smtp.gmail.com with ESMTPSA id x22-20020a62fb16000000b0064fd4a6b306sm654596pfm.76.2023.08.24.22.33.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Aug 2023 22:33:44 -0700 (PDT)
From:   Xiao Liang <shaw.leon@gmail.com>
To:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: [PATCH nf v2] netfilter: nft_exthdr: Fix non-linear header modification
Date:   Fri, 25 Aug 2023 13:33:27 +0800
Message-ID: <20230825053330.7838-1-shaw.leon@gmail.com>
X-Mailer: git-send-email 2.42.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Fix skb_ensure_writable() size. Don't use nft_tcp_header_pointer() to
make it explicit that pointers point to the packet (not local buffer).

Fixes: 99d1712bc41c ("netfilter: exthdr: tcp option set support")
Fixes: 7890cbea66e7 ("netfilter: exthdr: add support for tcp option removal")
Signed-off-by: Xiao Liang <shaw.leon@gmail.com>
---
 net/netfilter/nft_exthdr.c | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
index 7f856ceb3a66..a9844eefedeb 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -238,7 +238,12 @@ static void nft_exthdr_tcp_set_eval(const struct nft_expr *expr,
 	if (!tcph)
 		goto err;
 
+	if (skb_ensure_writable(pkt->skb, nft_thoff(pkt) + tcphdr_len))
+		goto err;
+
+	tcph = (struct tcphdr *)(pkt->skb->data + nft_thoff(pkt));
 	opt = (u8 *)tcph;
+
 	for (i = sizeof(*tcph); i < tcphdr_len - 1; i += optl) {
 		union {
 			__be16 v16;
@@ -253,15 +258,6 @@ static void nft_exthdr_tcp_set_eval(const struct nft_expr *expr,
 		if (i + optl > tcphdr_len || priv->len + priv->offset > optl)
 			goto err;
 
-		if (skb_ensure_writable(pkt->skb,
-					nft_thoff(pkt) + i + priv->len))
-			goto err;
-
-		tcph = nft_tcp_header_pointer(pkt, sizeof(buff), buff,
-					      &tcphdr_len);
-		if (!tcph)
-			goto err;
-
 		offset = i + priv->offset;
 
 		switch (priv->len) {
@@ -325,9 +321,9 @@ static void nft_exthdr_tcp_strip_eval(const struct nft_expr *expr,
 	if (skb_ensure_writable(pkt->skb, nft_thoff(pkt) + tcphdr_len))
 		goto drop;
 
-	opt = (u8 *)nft_tcp_header_pointer(pkt, sizeof(buff), buff, &tcphdr_len);
-	if (!opt)
-		goto err;
+	tcph = (struct tcphdr *)(pkt->skb->data + nft_thoff(pkt));
+	opt = (u8 *)tcph;
+
 	for (i = sizeof(*tcph); i < tcphdr_len - 1; i += optl) {
 		unsigned int j;
 
-- 
2.42.0

