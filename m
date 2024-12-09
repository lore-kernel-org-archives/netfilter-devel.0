Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 372721E515;
	Mon,  9 Dec 2024 20:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733777369; cv=none; b=B88TnrI0TUI95l7hk0Wu3ymgiTJD/gy/fPKhRHj35PVbnA2BNEWfIRUEHOn5IqNTPLeGeORegKbWEgeSnFeL0s4edI1Tb47S87vWIZyvtpRYTZ+wFk6eyey7SrRIiaPMVBeUns1npLpu3trJeoo8ardH+mtXHEZGz8LLDO7XriE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733777369; c=relaxed/simple;
	bh=EVRrlBUan9IJen8L8ZTGEotUSBgDrI7b0HaSIgMYPh8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=IXsmyUwFNVJdvygt5tq811O1fFY2XvKwuqR5GSKuT+9BDv0HDW7hvQ3jqP+ynBdj2GvJygPR5w76jucfETn8lCzzMELV87zE+oqRUtGjrIm/caq+UflLRSMv/ZJqERrpRndpHVBPvBAYrPsvh/ErOdAnpiHy4r2+AEmxpy6xvcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e21RIY1V; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e21RIY1V"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5d3d143376dso4274049a12.3;
        Mon, 09 Dec 2024 12:49:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733777364; x=1734382164; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=LDsdf4awSMe7aA0DWqf+TXfsRJBfTWDAmXcZTcbb9RI=;
        b=e21RIY1VFhScTzIjN/vlZh4gM9Lzxg21vVMtmZF6F0hzKaEU5IdjFFaLF14g9i1pVX
         r7gsOwc8rpK4mw7wT72cimMtxK6pwaOhz9IsJuvDFuS+rA610/2iBln6au6QLKmknUuU
         /Lr6d9gR8Iif3oekfqa5PONaNpyAjbeh5xsFwkwX05PRH2scU4BDt6ptcz980P/t9gZo
         yXEJaUhyS44+NA9zgNfCcCDt57yyYEJzYn4i4wuEZWRxW+4jOOUUkbK209GmjVjtTcsG
         /D7yt4RFaRcngUWH2txSsUcPQSmzAk2AsVjC73iace+ZMc+hiZorkLzLoLlZfn7ugQgD
         X/VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733777364; x=1734382164;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LDsdf4awSMe7aA0DWqf+TXfsRJBfTWDAmXcZTcbb9RI=;
        b=q1u88M8VI6ufO25SopOAKpJT5dVmvZXTwJb7gTOHivZ7mmGYuDrh6HNNSWl2qR1MNf
         yAJxvtjBXR9z7u8WlFAPsdbFob0W8R60HFgJdExPp9sYrtE+rFVXvqg5rBpuyveIuKq9
         GC9s356ejzT1w/ltuAmoFwZD9jTpyLeLHVyqB6FImfqmtMFAtC7hURdaV35QaBJHsSdN
         Ts0eLTC+AGaFetaIZOOQfMqw8qoL+/fajvV6zzjDo4LzK/PNhvWMqaBNqmnwmiRtqw9B
         X1/8felFn+FY6animm9mczgiQWOFIptNvZlwaz/5WFE3KkAyYyMX8qu0hWOMYLkzBihs
         dwAA==
X-Forwarded-Encrypted: i=1; AJvYcCVBHXMh5iIwV3KJwjpIXb5p0CQdJronGVYgjmpCs0v/8s6mOARjOM2p8ICVh/C/iNo6ffivhhL4uJpwS0Q=@vger.kernel.org, AJvYcCW5tfRah6kLlO49W6nh0VTK7Sm3JmZNUVt2YAPB9oSli3OvQqMZEh3hpbPQ0NrU6r+s5oTn6d3k@vger.kernel.org
X-Gm-Message-State: AOJu0YyT7f9k5D+4IdiWmYPmy9Xe/TJlLBvPj3pbi/KEy8dG4/b5Nslh
	xOHH8rmgTyaxOYJHIiNloeefHqodrEP06ALi7AdGP9bOl2B5UnA2
X-Gm-Gg: ASbGncum2OWQNNyVSvd1kXeZQAP70mvwp9kH0SoDxM3aON+YATbh8prlO5w4sU7CUt1
	yJ+CxSVVMgTGLi9lge5gyfLHkrQoVkSBUL2Hkw54uFegUZiEorjBSkuJOVOW6qUan/t13V0dT4N
	HA9M+9wJYGG+Ax/8Bi4ejTbhUtdgsG/hl1o9nZx3vljYrgW19MD7/ARbSTj8vijH9od6CQfyKsL
	oxLpVBrpvsaQoMqz5cruu0hi9F2S5doLR/7zjTrXp9lVCKawV4Rg+feLftg95mY
X-Google-Smtp-Source: AGHT+IGh5VLwEyyN4rrxLprwiJ8QE3yGZmKhKKNw85NDHq9xP13bymyIefM+JbsyFTHJYS+H/wcotw==
X-Received: by 2002:a05:6402:4408:b0:5d3:cf08:d64d with SMTP id 4fb4d7f45d1cf-5d41863c2a7mr2255139a12.32.1733777362658;
        Mon, 09 Dec 2024 12:49:22 -0800 (PST)
Received: from localhost.localdomain ([83.168.79.145])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d3ea09245bsm3323202a12.78.2024.12.09.12.49.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Dec 2024 12:49:21 -0800 (PST)
From: Karol Przybylski <karprzy7@gmail.com>
To: karprzy7@gmail.com,
	pablo@netfilter.org,
	kadlec@netfilter.org,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org
Cc: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	skhan@linuxfoundation.org
Subject: [PATCH] netfilter: nfnetlink_queue: Fix redundant comparison of unsigned value
Date: Mon,  9 Dec 2024 21:49:18 +0100
Message-Id: <20241209204918.56943-1-karprzy7@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The comparison seclen >= 0 in net/netfilter/nfnetlink_queue.c is redundant because seclen is an unsigned value, and such comparisons are always true.

This patch removes the unnecessary comparison replacing it with just 'greater than'

Discovered in coverity, CID 1602243

Signed-off-by: Karol Przybylski <karprzy7@gmail.com>
---
 net/netfilter/nfnetlink_queue.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 5110f29b2..eacb34ffb 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -643,7 +643,7 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 
 	if ((queue->flags & NFQA_CFG_F_SECCTX) && entskb->sk) {
 		seclen = nfqnl_get_sk_secctx(entskb, &ctx);
-		if (seclen >= 0)
+		if (seclen > 0)
 			size += nla_total_size(seclen);
 	}
 
@@ -810,7 +810,7 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	}
 
 	nlh->nlmsg_len = skb->len;
-	if (seclen >= 0)
+	if (seclen > 0)
 		security_release_secctx(&ctx);
 	return skb;
 
@@ -819,7 +819,7 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	kfree_skb(skb);
 	net_err_ratelimited("nf_queue: error creating packet message\n");
 nlmsg_failure:
-	if (seclen >= 0)
+	if (seclen > 0)
 		security_release_secctx(&ctx);
 	return NULL;
 }
-- 
2.34.1

