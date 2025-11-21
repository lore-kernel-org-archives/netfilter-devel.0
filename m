Received: from mail-pl1-f196.google.com (mail-pl1-f196.google.com [209.85.214.196])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ADD02FFF9D
	for <netfilter-devel@vger.kernel.org>; Fri, 21 Nov 2025 08:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.196
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763715245; cv=none; b=jFWtmTc9nwmLhlLuc6cvG+1rUItzGTiyJkC+2VjMk/dhjHdfsxxMH1++eQ9CCf5aQYbxSc5k+QjLu8u8jcRtk4cngLGbSylMKvFK8JXfTjikQbbhwRXV1gE/TGFlcpAkkHL/u+Szaa/vlOvtjPGjigjKPeQyp1UqtkhIIwQwuKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763715245; c=relaxed/simple;
	bh=5ONFbsYgwaxvG2oaqCIQcvL9nC4rsYPLT1nLoZ6TTT4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KG7bNjQk++PlIU1nuFmqomjjrfma83AfnQdKj/13Z7QDQjU09GSJc6aBvYAmBmRs1ERFX+2paip1UAq7LdstCeuji1Jj587XigRyM/5ZrfscglkM4IqmFbNqVIx8rJnXYqqr0GzuJ6YDVC4ZQEau7cUq1qlKS2GgpYDzqz0bCnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Zbx1jdKw; arc=none smtp.client-ip=209.85.214.196
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Zbx1jdKw"
Received: by mail-pl1-f196.google.com with SMTP id d9443c01a7336-2955623e6faso21813995ad.1
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Nov 2025 00:54:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763715242; x=1764320042; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/YTlngMcqbvauGZMeP16vkAvJ48G9EBdsHd/OECzaso=;
        b=Zbx1jdKwIcRoCdE0lCiPAlzIxMwtVnqGA1uuPrjedx2+/x7ndIQu86pRiosD9kOvxE
         +dq6VGNfahgvlJy9im/oeQnO04JQaJQA22nSfqlBW3EM8N4MBqlhtqv4LueaqR4aeazO
         MtxUqbUqNY6bVsWHBeDK1k6uVC4ptlvxt6kn7PDGKfOYpoonec7kvN3+6SRaJ8t9uJFQ
         S+vm3y5DnqoJHijA1osQrl0/KI5oVY/o2XR6rDiIZ1E3eRWyyhy0PIlderEbD4JuEuod
         uoBV9i30RJDhmxc7+5hu/Dj6kXQqHO9G3Fpni6G1Bv3V0Vr2v5KvYUETlC9bG22LRBD5
         ghfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763715242; x=1764320042;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/YTlngMcqbvauGZMeP16vkAvJ48G9EBdsHd/OECzaso=;
        b=ilmRDQDFwSsS/MWcr4Kz6eUFZPTIzZm6ou5flt3GIKiDB2MTpDN2Myy416s62aDM+5
         NDc4TesBRfz6ETnMLMJunFDQe+HwV88YjNKBHUFp1F8U43zh+jtix8X5a2bUpaQLkFWn
         F6I81IYC2RoC1bM2YGuuHusYiDKz0ITNvTspW/IoTBP4aLpetBYhViiGlG8zZqQAOFPl
         0Gk8MBXYQCXqtm1ZDI0lgLvAFZdee0HFR2lFteW6QQ7cYnhREOpzV1DV/opy02DR287W
         P9+AD4UsxvqUnU3J1gyQRAe+4/xUMAg+DglDF73IBp9T4xfkaw3BFWqcVKPTtW+F1HZD
         y+HA==
X-Forwarded-Encrypted: i=1; AJvYcCX4o002h39IZUsHKRycGWoMwoJoqw1q+o2Dj9ZqJ7J5yb0RwPvBKkD65P0at14MCZJiTR6qt9YIVbafTYpRezc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxTnnpvImppgnsSR82Xdb7/5b7nuCNIm6BPiivwGY9cq0hqmPVA
	/N9KsZksuegvxZaT3O3qSZECApENNAFBew+Cq/bZlQsDiD8AdrAKznwL
X-Gm-Gg: ASbGncujOR7pGUsFlV9MkpC/6hkvGfiwMnMBGwH85oJgx/fLmRL80wQjPV4KQaKG6mU
	Sjc8zEZobTmZkU3obDMZbWxB1tch6IXu0YkD0a5VzPgbmzyG7XEoGmV1/JrIysUK9qrXVC1tfUk
	gEkBNHdgbbXY3Uzzxo+KbdRzwgRJhitfSdOCgtkO349QvZCT7DUpHyAn5bQZ70psOfg9J04ZzcW
	iq3GnDTN3r6MANqrzIsNAMU9OqvYDxPW24vkc6BkXPbHMTaOuJkLs4vyT6CtiPXdUzN5qI5d9zd
	kBoQMaoT+tpat/39rdb/3dr4DkGKCvPOCKOB3Q5J5RfghxYVapr4D0KG+jhNdfkohEA5AYq+dZY
	D+PlbX1rP0HVzAIM92LzfW6Ccstj8E80IEAG/MJL3CQXNrEK3VqbMjG5diwt9jlbe2h6VfR0XNQ
	slxDwi44Rp3KqvSGaVX+Pr6pKzWC9wAMxzvKdL90K82g==
X-Google-Smtp-Source: AGHT+IHuu7fePZOfFm1BwV5Mds9oUo/keOxc859jpBRxZdakp53XXkD9VJ9ewpv9IfRTXvYaNE2Pnw==
X-Received: by 2002:a17:903:98f:b0:298:b4f1:37eb with SMTP id d9443c01a7336-29b6be9364fmr21213895ad.10.1763715242052;
        Fri, 21 Nov 2025 00:54:02 -0800 (PST)
Received: from LAPTOP-PN4ROLEJ.localdomain ([221.228.238.82])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29b5b274d39sm49938125ad.77.2025.11.21.00.53.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Nov 2025 00:54:01 -0800 (PST)
From: Slavin Liu <slavin452@gmail.com>
To: horms@verge.net.au,
	ja@ssi.bg
Cc: pablo@netfilter.org,
	kadlec@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	lvs-devel@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org
Subject: [PATCH net v2] ipvs: fix ipv4 null-ptr-deref in route error path
Date: Fri, 21 Nov 2025 16:52:13 +0800
Message-Id: <20251121085213.1660-1-slavin452@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251120190313.1051-1-slavin452@gmail.com>
References: <20251120190313.1051-1-slavin452@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The IPv4 code path in __ip_vs_get_out_rt() calls dst_link_failure()
without ensuring skb->dev is set, leading to a NULL pointer dereference
in fib_compute_spec_dst() when ipv4_link_failure() attempts to send
ICMP destination unreachable messages.

The issue emerged after commit ed0de45a1008 ("ipv4: recompile ip options
in ipv4_link_failure") started calling __ip_options_compile() from
ipv4_link_failure(). This code path eventually calls fib_compute_spec_dst()
which dereferences skb->dev. An attempt was made to fix the NULL skb->dev
dereference in commit 0113d9c9d1cc ("ipv4: fix null-deref in
ipv4_link_failure"), but it only addressed the immediate dev_net(skb->dev)
dereference by using a fallback device. The fix was incomplete because
fib_compute_spec_dst() later in the call chain still accesses skb->dev
directly, which remains NULL when IPVS calls dst_link_failure().

The crash occurs when:
1. IPVS processes a packet in NAT mode with a misconfigured destination
2. Route lookup fails in __ip_vs_get_out_rt() before establishing a route
3. The error path calls dst_link_failure(skb) with skb->dev == NULL
4. ipv4_link_failure() → ipv4_send_dest_unreach() →
   __ip_options_compile() → fib_compute_spec_dst()
5. fib_compute_spec_dst() dereferences NULL skb->dev

Apply the same fix used for IPv6 in commit 326bf17ea5d4 ("ipvs: fix
ipv6 route unreach panic"): set skb->dev from skb_dst(skb)->dev before
calling dst_link_failure().

KASAN: null-ptr-deref in range [0x0000000000000328-0x000000000000032f]
CPU: 1 PID: 12732 Comm: syz.1.3469 Not tainted 6.6.114 #2
RIP: 0010:__in_dev_get_rcu include/linux/inetdevice.h:233
RIP: 0010:fib_compute_spec_dst+0x17a/0x9f0 net/ipv4/fib_frontend.c:285
Call Trace:
  <TASK>
  spec_dst_fill net/ipv4/ip_options.c:232
  spec_dst_fill net/ipv4/ip_options.c:229
  __ip_options_compile+0x13a1/0x17d0 net/ipv4/ip_options.c:330
  ipv4_send_dest_unreach net/ipv4/route.c:1252
  ipv4_link_failure+0x702/0xb80 net/ipv4/route.c:1265
  dst_link_failure include/net/dst.h:437
  __ip_vs_get_out_rt+0x15fd/0x19e0 net/netfilter/ipvs/ip_vs_xmit.c:412
  ip_vs_nat_xmit+0x1d8/0xc80 net/netfilter/ipvs/ip_vs_xmit.c:764

Fixes: ed0de45a1008 ("ipv4: recompile ip options in ipv4_link_failure")
Signed-off-by: Slavin Liu <slavin452@gmail.com>
---
 net/netfilter/ipvs/ip_vs_xmit.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/ipvs/ip_vs_xmit.c b/net/netfilter/ipvs/ip_vs_xmit.c
index 95af252b2939..618fbe1240b5 100644
--- a/net/netfilter/ipvs/ip_vs_xmit.c
+++ b/net/netfilter/ipvs/ip_vs_xmit.c
@@ -409,6 +409,9 @@ __ip_vs_get_out_rt(struct netns_ipvs *ipvs, int skb_af, struct sk_buff *skb,
 	return -1;
 
 err_unreach:
+	if (!skb->dev)
+		skb->dev = skb_dst(skb)->dev;
+
 	dst_link_failure(skb);
 	return -1;
 }
-- 
2.43.0

