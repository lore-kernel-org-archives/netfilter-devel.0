Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1861343D72
	for <netfilter-devel@vger.kernel.org>; Mon, 13 Jul 2026 18:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783967778; cv=none; b=bXBIWI5T3FPqP1m/tAhciIGiOAbGT4TqzLqhmcBduGMVuU836hHBk4E74lweMlH/ptUtrzYPZOgamFJwV67vP8V74uZE94HFnmHBDYUxM8jeroeMLvIeYLJHuS+Dj64DjMfWYHOGLdlErCwJfuAGDcpNm3x9qv2RvekfiVlpoyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783967778; c=relaxed/simple;
	bh=d/eeuVxUleGy31a88wNlioaq+/dr9+CAscc3aVXlqtU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aCMKdJV4qFQ8TI44fXJJKdBJp106PbXmg2/9dF/zT72QkQ6M/CrN1t3FYVvZGVaFHhdTGJQcvf21J5YPRieH7qjnyEvVX2HrpP2fG1Ci5EK9jpPTSl8CyjETqhbXgSQxhiPKMnz3SC5FzHyAX2t4cjJYvz92WKMK+rrqZzvLVSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu; spf=pass smtp.mailfrom=asu.edu; dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b=RQO22JJc; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asu.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b="RQO22JJc"
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-c99eaa1f020so118525a12.2
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Jul 2026 11:36:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1783967776; x=1784572576; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=83OFQaO++E4joRubEA/Dmu6J46o8fWIq9Xk8WKWgSek=;
        b=RQO22JJcAOciRBggMdebttFd6CWL9ajvG3P2sX2yJ4HWTzVDEXm4PRsQJ/PhrTgDra
         I6Bx/cJbSQLTS+Sj+77bAlq+XkoCl68ja+wJDzIXRPgriFgG4Hw4iczGt1hINt5NRQbp
         Hec7Z0cMCR1nkapiXP/DnpuqHxdJlJAdkG4lg2Pz4yP/hNs46ntEQEpaHog088ZvpCjr
         EAAKcPXNVKqwIJd5yqLGHG7CuyANC1s9GZ4OJpTIAHjSlbZ6/n6MrQT9xdmvLIkm5umP
         SPYqCO/oSSmpTEPkLX+Tq+rYa1vubcVPw1ZuwUIqARqEeEROLtuRoI1LpgrKwBRK9GML
         ASXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783967776; x=1784572576;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=83OFQaO++E4joRubEA/Dmu6J46o8fWIq9Xk8WKWgSek=;
        b=JU424TcdAnbfBLeTsmQpSePJPv+B9Rsf+P/D3ZeAOClqsk6OrzW6US2IeK/R/IBhDH
         T/SeGyRyYHDoiwHBl18wLhQ9klo4636erVxg/XooOtpV9dWMKWAo36LWeHm8h56O4Ptl
         qev7uw4wNeYbYQ5F8Kdb9Guxek1ewip3WvsfoPSObbph1fh6DgLW5ToA0fH0fyhzGNIe
         OSO62s4Bf+5Jez1LFDYZ3ug9XLVKbvXLUan185e83XdUZQAdjPHTJ5MkJMJ9l2Z4tmdQ
         UOJ3q6omgw29vm7Lv6fNDWYD9XjZ4Gc7tHp+2+Bw6egsrVsTDsx/m0huQSDexsQYxxgk
         1eaQ==
X-Gm-Message-State: AOJu0Yy5yeYkchZqpDG10vxT91z6n2q2BYT/ZhdK14M6aKI5MsLLxhlk
	hVqHIVHiK50zgx3DLqogmhMkTtfe4/NjKAArvPOOvuBwdkN84zpDVUHkEztwTtaRyQ==
X-Gm-Gg: AfdE7cn0NPYkavJGligglyqPQf1iMioixBlYGQpEUpxl3uKhskKKi40SJvV2N7c/05u
	+ydMS9td4btAARW7WSCZ4ww8CycRgil7+XoeJDDFI1dDFvsoAK+wlyKftMLzzsfOcZlIsa6sG3C
	FyXxlkUeCjuZAv71+454KQenw88KWVOJIy338Pmr27stk99mcUCW8hGGFyROgGGdPoo5fD1p/JC
	JUg9T89j2s/BfAmQxZhHJF2wxmuYO+3XXsCgMojuEMYQyyB3wQ3ae4Suh4cDSHn2HUf2e1q6cAH
	gNeB9yxJdpMqC/JisYXr8+mjb+1MB40kcm/syKgYsq0XbUCQ5QcEbUULEER5uv09N5Adl1wtPMQ
	HyuZNPOQsRZNAhy2nFyzMYMrssh3Cwqtes6/x3w2vN5o2IrJO06Bn4a+dOnPo41/bHyrkFc6Epg
	pnw0yhq4nx2ptmzcBk0A==
X-Received: by 2002:a05:6a21:1798:b0:3bf:6237:b1b3 with SMTP id adf61e73a8af0-3c110775a71mr10882651637.42.1783967776314;
        Mon, 13 Jul 2026 11:36:16 -0700 (PDT)
Received: from xiang.tailc0aff1.ts.net ([20.171.14.70])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3118389d9bcsm61616034eec.20.2026.07.13.11.36.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2026 11:36:15 -0700 (PDT)
From: "Xiang Mei (Microsoft)" <xmei5@asu.edu>
To: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Phil Sutter <phil@nwl.cc>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>
Cc: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	AutonomousCodeSecurity@microsoft.com,
	tgopinath@linux.microsoft.com,
	kys@microsoft.com,
	"Xiang Mei (Microsoft)" <xmei5@asu.edu>
Subject: [PATCH nf] netfilter: nft_fib: bail out if input device is missing
Date: Mon, 13 Jul 2026 18:36:14 +0000
Message-ID: <20260713183614.2975972-1-xmei5@asu.edu>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nft_fib_can_skip() dereferences the input device (indev->ifindex, and
in->flags via nft_fib_is_loopback()) without a NULL check, assuming the
hook switch only admits PRE_ROUTING/INGRESS/LOCAL_IN. But NF_NETDEV_EGRESS
== NF_INET_LOCAL_IN == 1, so a netdev-family base chain on the egress hook
passes both the switch and nft_fib_validate() (which also keys only on the
hook number). Egress packets have no input device, so nft_fib_can_skip()
dereferences NULL.

  KASAN: null-ptr-deref in range [0x00000000000000b0-0x00000000000000b7]
  RIP: 0010:nft_fib4_eval (net/netfilter/nft_fib.h:19)
   nft_do_chain (net/netfilter/nf_tables_core.c:285)
   nft_do_chain_netdev (net/netfilter/nft_chain_filter.c:307)
   nf_hook_slow (net/netfilter/core.c:619)
   __dev_queue_xmit (net/core/dev.c:4799)
   ...
  Kernel panic - not syncing: Fatal exception in interrupt

The eval path touched the device only via l3mdev_master_ifindex_rcu(),
which tolerates NULL, until
commit eaaff9b6702e ("netfilter: fib: avoid lookup if socket is available")
added the sk/indev dereference. Restore the old behaviour by returning
early when indev is NULL, so the packet takes the regular FIB lookup.
Receive-side hooks always have an input device and are unaffected.

Fixes: eaaff9b6702e ("netfilter: fib: avoid lookup if socket is available")
Reported-by: AutonomousCodeSecurity@microsoft.com
Signed-off-by: Xiang Mei (Microsoft) <xmei5@asu.edu>
---
 include/net/netfilter/nft_fib.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/net/netfilter/nft_fib.h b/include/net/netfilter/nft_fib.h
index e0422456f27b..d53e5a5214fe 100644
--- a/include/net/netfilter/nft_fib.h
+++ b/include/net/netfilter/nft_fib.h
@@ -33,6 +33,9 @@ static inline bool nft_fib_can_skip(const struct nft_pktinfo *pkt)
 		return false;
 	}
 
+	if (!indev)
+		return false;
+
 	sk = pkt->skb->sk;
 	if (sk && sk_fullsock(sk))
 	       return sk->sk_rx_dst_ifindex == indev->ifindex;
-- 
2.43.0

