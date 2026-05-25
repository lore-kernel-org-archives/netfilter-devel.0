Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B64533264E6
	for <netfilter-devel@vger.kernel.org>; Mon, 25 May 2026 21:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779746339; cv=none; b=c+P5fxdK39bnKroeUABfUkgqgU1S8hUCr0yOZPXZEpZVpdD4uSE6GO5QS+lrklVHGgo9dGWL2/L/xiuuZYx5KznBvjndWH0ejgHkL63AnIGh0U9APXb7JGNKUGf+60Bg8MG/5oaHrYAW9RTTYwWKXj6/hSskwfJh+e/9Kiwbblc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779746339; c=relaxed/simple;
	bh=CrEqzrWNX5i9EDnlY0vi2gqf/6FcRMTl54dk6duo848=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qcPh2aUs37tyDYEcXB1z6Bq7ECxHLjSmdKCXwc786+vQyICB9MIniHwcegGMrDXmVBP82Bs2NXdVBcjtgG5eq8WYRLth/jeQW3kJdRjQS0imrnvdDlY+pGIalTb30EPdKD9PyXHIhhJ9MWnhXyIsWUS15gy1YIZjVzyxlNcf85g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RYhwx7AA; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RYhwx7AA"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-36931e4f5e8so9251151a91.2
        for <netfilter-devel@vger.kernel.org>; Mon, 25 May 2026 14:58:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779746338; x=1780351138; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=3K1QSVKO4xxnbI4UIG0vqZ1FFpQ1DWBA52T8EZUsAFE=;
        b=RYhwx7AAWTMK1flituky02TvetZupOX2fByR8+cIoa36cF2i6ozHKSfQtmDVer4NPd
         FeOsw0rvrx+xsKy6OtUS2jgY40VYq0eP5hiOqeJTAVPtsddls6ItKDWMeEc9UCM0MWAw
         A7VUOud/hUrm0U+tA8ZXTfga+xASs+94mjWGCmiDh3NnT0fg+uhHxxT7Fmw4iPSVTZUH
         Ahl2Fhm0iWyFR6qy0F3BSO75hEdVEjm+5d+gZWvBJmjLBuN9e/w/GVehYrKEgMrbK6uK
         jJOWjMuuAA/LHRd/t11d/7MIL+m/8zUv2z8BnCNeBR5MClnXd+TAyBjV75th9iDEw0ZG
         EPng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779746338; x=1780351138;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3K1QSVKO4xxnbI4UIG0vqZ1FFpQ1DWBA52T8EZUsAFE=;
        b=Gi/hceC9kilR9yATDoLkeQ40JznqaFCtnc+qJPrEbAXXLwH4yiMG9ueCxjnKINxUCF
         qo54bYgIyfw0CwUA/C8QdDiSFz5MzNcIA+rj/uu4QH5PxcB59799VbC4x8PZfJP0JYl6
         w0QXi0EnN9x6N85ZQAsBVQyYNy2f/jHqqZlodvi0tkzGzGs9UjQgKnLHmivSEJUTN+AP
         rIq6KU2BUTjHuHVX/kXrK8un6w5QwXpX+E8xiYOobD1Y3xCIC+D8m3GBFtawnC1Y725J
         ylNWOPtRvGdp16ulu1luU3U4yqGgX8Lsn6PfXtPbXOj5TBg1zinWV6zrvw4PngA25maI
         h32g==
X-Gm-Message-State: AOJu0YyHZWWGO/kGFPUprAq4e5Q1fTq/chYrwRaVtmQj0PjYDYjbK5zU
	oKkCOEltF9stWQQwCT4Cm7qCbT6mdTx5hWcoh8qf/+AL921IA6leH+dJVvRTDg==
X-Gm-Gg: Acq92OG6oCyCJuzD4aTWQGkiuJ+ZBqTLu625HSQ3/NQPEz7moEZ6DrRB6yI95LJHha0
	HNFVxVXrv224ap1gc0UbocMrHIExjQHIMiSbhLQuCUu0VogbCsGH0jIlLP24JlEAY87sqmNHmz9
	Wrs7KFIsbGGmvL5l9Psc4xvANkyw/GnIZ+TYPBfJpIy+J1Jnyk8SLLD28UPykE7xkVgu0FfBSAF
	aOtsfSWi7eIouWWrUR7oDlGKU+1OLlF/wdWysf8+lj+Tj8GJgJX6OERnfdXlJjJJWKCU6o+gXHa
	Il2JfvasGNyeSa1RZ6MGQDG1vSwrVXZdX8GLIPyLA2mreZEqtIBwPeGULF7HDQfMuSWLBPHYz7w
	sCdMWsSoJwOnzjkwO128pxrUP2xy2ARTepR+HiI+EKRu4O/pwGr1ttYLmE2baoDJ0u7NWKZM13G
	XYtxb3zezckuYk3OqWoY4Z32xwZZMQUdzqZ6bjyip8BHq4mhEhWfwsni6QCy57/5hg9Pys8Tu0y
	IrQxdMC/h1QZ3o+Lruk7DIqC8w4XcdFYZiUOATagC1H+w==
X-Received: by 2002:a17:903:15cf:b0:2b0:7531:b61e with SMTP id d9443c01a7336-2beb06920femr168393165ad.41.1779746338054;
        Mon, 25 May 2026 14:58:58 -0700 (PDT)
Received: from ryzen ([2601:644:8000:5b5d:7285:c2ff:fe45:8a32])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2beb56b9fabsm131699335ad.23.2026.05.25.14.58.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2026 14:58:57 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	linusw@kernel.org,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	coreteam@netfilter.org (open list:NETFILTER),
	netdev@vger.kernel.org (open list:NETWORKING [GENERAL]),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] netfilter: nf_conntrack: use get_unaligned_be32() in tcp_sack()
Date: Mon, 25 May 2026 14:58:40 -0700
Message-ID: <20260525215840.93217-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The timestamp-only fast path dereferences the option stream as
*(__be32 *)ptr, which assumes 4-byte alignment that the TCP option
stream does not guarantee. Use get_unaligned_be32() instead, which
reads the value safely and already returns host byte order, so the
htonl() on the comparison constant can be dropped.

This matches the existing get_unaligned_be32() use later in the same
function.

Assisted-by: Claude:Opus-4.7
Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 net/netfilter/nf_conntrack_proto_tcp.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index b67426c2189b..8993374c9df2 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -405,11 +405,11 @@ static void tcp_sack(const struct sk_buff *skb, unsigned int dataoff,
 		return;
 
 	/* Fast path for timestamp-only option */
-	if (length == TCPOLEN_TSTAMP_ALIGNED
-	    && *(__be32 *)ptr == htonl((TCPOPT_NOP << 24)
-				       | (TCPOPT_NOP << 16)
-				       | (TCPOPT_TIMESTAMP << 8)
-				       | TCPOLEN_TIMESTAMP))
+	if (length == TCPOLEN_TSTAMP_ALIGNED &&
+	    get_unaligned_be32(ptr) == ((TCPOPT_NOP << 24) |
+					(TCPOPT_NOP << 16) |
+					(TCPOPT_TIMESTAMP << 8) |
+					TCPOLEN_TIMESTAMP))
 		return;
 
 	while (length > 0) {
-- 
2.54.0

