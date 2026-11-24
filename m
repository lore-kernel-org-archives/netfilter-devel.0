Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795538059;
	b=jj80Ht01ZDVP+Kk1I4T7LT5119eYonAbN3qD+V1J/nk2ZiB3DnTBG1cgptqKjbzKCNMF
	 5SDH4SpDwzz7I1jHt4JlTXUVabmFvk4itTpbD/u0S1wTao+X1icp/lT7o/24AxCrwTIdE
	 OaS7/lUr22FzBI+Y7kj+kg235CbI0primYLrWr3n53WSucAPEO4Hgj12PvbSMqmBa2/KB
	 Oz6UOeWfDZgGQxjPKVyJGdTamFk5toioRY4kOY5AkGdDz/eJa1l2cafuqIjzxS6vh+CMP
	 km65oy0OWknZZ6eCP13bgxf6/Kvgg8OOPrGxjd6blLm1PomL+uVwu/eOJ4QG846DX5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795538059;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EClMfCqKxctT9skZzSuSsDAw5vjSAOlPEZZuifK4nb0=;
	b=jhbBt0LosbJl70TkfqN2TZDnd0/793h1g+oG/8H7FZzuNnZMez47nFl0ClAMI4VuKExQ
	 iQwvoCpdPFw376Kt4FqCFM0Xv9IVq7AbEuU8pd+4bOcAkvwvPIy0d5K7mEwTO79qf0Sxb
	 Yk5TbNXeotn0Rd1XqGrNB+QiKLzBCq+UkWhroXAYe1/V49SnibSYD2BtaKOfW7o2cijXA
	 SaNZGdBJU41g2KSR9rg/2Za+STXG4yIiSQJDVvpeN1A+MotvUIofFIUPgQdrMsedPLT0x
	 s2NhmcUyXUQgDF3qBx5a8PkvzgvS+H4+oEOka1feIJGJvG6hRVtRvgC9pjaXLQvrP+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vplGpSjU;
	arc=none smtp.remote-ip=209.85.208.42
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E736606A32C
	for <netfilter-devel@vger.kernel.org>; Tue, 24 Nov 2026 16:34:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8E736606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vplGpSjU
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6b87a1a2babso10436774a12.0
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Nov 2026 08:34:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795538057; x=1796142857; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EClMfCqKxctT9skZzSuSsDAw5vjSAOlPEZZuifK4nb0=;
        b=vplGpSjUzq5nA05ZXtp0+d4qNIGETg5PGo/+jwYBGHLGfxXOE9kuPm1k4bU0n6PGHf
         phySykTltY2tE/ciXeMdFk1u/roMNHJoMSjtqfinSoxbEFvoZBwwJIDSja/0ROaKz3sm
         TOAUzu1bwY35s7C665lv7zdzsEI8rypJi4Rfjdgy4pm8cL5lJrci1DIXatGk8eERpp8H
         jaKA1v33WD5KbpbVjpQL+5H38olWDQPHWE0dmUSLlC9oUwwouDtoM8Olc4Rnska/9lBZ
         8sxfVe5H1k6dtxCPICmkviTq7Taya4m+JGjBhb7Ec5+kqigkF/3r6DLyCWc735M/sD6N
         wFFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795538057; x=1796142857;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=EClMfCqKxctT9skZzSuSsDAw5vjSAOlPEZZuifK4nb0=;
        b=TE4JqSTy4OwTkC6aEWPcUUDG2ihOT4nCkZul/sbj/3uNTLC3vOd2xSXfpSzGsNj642
         UKUzql7yjvAxlMMtTXILA+U5URphDX9P/CZTwdSgQqLLVy1yjjd6Rx/JdWhyNEGHEtlK
         Pvm+N8f/BOte4hOZ9TYiBa5HDgCZRCyuSEo/FdiShtNM1ztmGhHw6VebC4TFYWsD+m9N
         q+DEDk2BQ27SbFnGY+IakV2rop0odXwDdMR8CYj9RcV8EpqCrB3D5GdOb3Bu0CBZUJZv
         /PfulkBNb8hFd0YGIkkNEripEzEdvkAvAuAJX8L2364wBGjnJtnEAr9VEXm2KhP6Q4ML
         kV5A==
X-Forwarded-Encrypted: i=1; AL+hErFypmNunwYo3v+eVS3kcUCt4rwaURA72FrcGwmoNkETqQHYjTls/fJrX48JenCpI89owV/oam6+ShowaD13UZI=@vger.kernel.org
X-Gm-Message-State: APuU4Z/fRxK/2SjmywdNH5toQhEte39LMkd1AujBK4WQL4ieRk6w8vl6
	AA+7fut/q8FO1Q3VVdM29vqt/xpT+nNE1TcWRYeZzFLCilZkQ5AMqujX
X-Gm-Gg: AZFdTZfEekgcTFL2gfSFNVKpENEEBwt4XTzovA6gQA+jnQ16ueeSqlg581VjOGe+4Oy
	ZKmmaxRiXdstKfHwR4vBDy5S6fx0iKNZnkMQV8vgW8qT6XoXcOF1R7J2xcwi/DAYhKxqQjIDgH2
	MvqAHyvhhzHdH1LuIYrG5h5LgGUBmDqQRiRDuVXTJSe/3J0hyF4QCq7hNF9BeOm046PUqPJ8+X1
	q6KUyBDr06q25B8zm3rVfSJp1fjuit7zWdLrFYhR1TKa/4DZlVRplOuU2tnYv/M9gkkwDroJc8b
	RW6NAuOg103JnUB/bYsuoFeeyqZkCXsOhJwJ5bd62i6W/cTeNJxiYqHm0ImgCtAu5z69y0ZoP4Y
	2EEFH2ddAIyBTre9U7qKxGtLtvjfzBYeQRjMkMQORWxTrqLo5tfkF/ol/TuTBWKT1bJbNSMPomN
	+wwP0czy/mHB+pyBLzYYQz9W9t+/IfRo7CvPXY47r7kCPRG9XczXyz/EkNI0svp3AJYTwhU1W+B
	v2bZq0XqMYcMF7Xf/i6XzleG2lzyx9pg3SHugL7M8LYVDUXl1behlphsIEgE0hfLVaWdZge3vbP
	yYm0qX4ik4E0Z/Nv2iPEhOFnQRQPT2nMvWDUT+xrm1FJX4o1Dc2sEq0asR+y4WkxwjDZ+15tc0X
	X
X-Received: by 2002:a17:907:1c8f:b0:c50:9412:93f0 with SMTP id a640c23a62f3a-c51317e3208mr1338763266b.8.1795538056751;
        Tue, 24 Nov 2026 08:34:16 -0800 (PST)
Received: from theodors-laptop.dotcomltd.ru ([5.255.118.7])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c513afeca8dsm542032866b.75.2026.11.24.08.34.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 08:34:16 -0800 (PST)
From: Theodor Arsenij Larionov Trichkine <theodorlarionov@gmail.com>
To: "David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	Theodor Arsenij Larionov Trichkine <theodorlarionov@gmail.com>
Subject: [PATCH net v3 1/2] netfilter: nf_dup: do not duplicate packets from br_netfilter
Date: Tue, 24 Nov 2026 19:33:57 +0300
Message-Id: <20261124163358.755345-2-theodorlarionov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261124163358.755345-1-theodorlarionov@gmail.com>
References: <20261124163358.755345-1-theodorlarionov@gmail.com>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nf_dup_ipv4() and nf_dup_ipv6() copy the skb with pskb_copy(). If the
skb came through br_netfilter, the copy keeps the bridge netfilter info,
and its mac header points into headroom that pskb_copy() did not
initialise.

A tcp reset reject of the copy on LOCAL_OUT then takes the bridge path
in nf_send_reset() or nf_send_reset6() and builds the RST's Ethernet
header from those bytes:

  BUG: KMSAN: kernel-infoleak in _copy_to_iter+0x1c9/0x2650
  ...
  Uninit was stored to memory at:
   eth_header+0xbe/0x150
   nf_send_reset+0x15e4/0x1850
   nft_reject_ipv4_eval+0x1b5/0x2b0

Skip skbs that carry bridge netfilter info. br_netfilter only drops the
info when the bridge transmits the skb, so this also disables dup for
packets that came in on a bridge port and are delivered locally or
routed.

Fixes: affe759dbaa9 ("netfilter: ip[6]t_REJECT: tcp-reset using wrong MAC source if bridged")
Suggested-by: Florian Westphal <fw@strlen.de>
Cc: stable@vger.kernel.org
Signed-off-by: Theodor Arsenij Larionov Trichkine <theodorlarionov@gmail.com>
---
 net/ipv4/netfilter/nf_dup_ipv4.c | 6 ++++++
 net/ipv6/netfilter/nf_dup_ipv6.c | 6 ++++++
 2 files changed, 12 insertions(+)

diff --git a/net/ipv4/netfilter/nf_dup_ipv4.c b/net/ipv4/netfilter/nf_dup_ipv4.c
index 9a773502f10a..a4ad26a564a4 100644
--- a/net/ipv4/netfilter/nf_dup_ipv4.c
+++ b/net/ipv4/netfilter/nf_dup_ipv4.c
@@ -11,6 +11,7 @@
 #include <linux/route.h>
 #include <linux/skbuff.h>
 #include <linux/netfilter.h>
+#include <linux/netfilter_bridge.h>
 #include <net/checksum.h>
 #include <net/flow.h>
 #include <net/icmp.h>
@@ -53,6 +54,11 @@ void nf_dup_ipv4(struct net *net, struct sk_buff *skb, unsigned int hooknum,
 {
 	struct iphdr *iph;
 
+#if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
+	if (nf_bridge_info_exists(skb))
+		return;
+#endif
+
 	local_bh_disable();
 	if (current->in_nf_duplicate)
 		goto out;
diff --git a/net/ipv6/netfilter/nf_dup_ipv6.c b/net/ipv6/netfilter/nf_dup_ipv6.c
index 6da3102b7c1b..ba8243bcd56a 100644
--- a/net/ipv6/netfilter/nf_dup_ipv6.c
+++ b/net/ipv6/netfilter/nf_dup_ipv6.c
@@ -9,6 +9,7 @@
 #include <linux/percpu.h>
 #include <linux/skbuff.h>
 #include <linux/netfilter.h>
+#include <linux/netfilter_bridge.h>
 #include <net/ipv6.h>
 #include <net/ip6_route.h>
 #include <net/netfilter/ipv6/nf_dup_ipv6.h>
@@ -47,6 +48,11 @@ static bool nf_dup_ipv6_route(struct net *net, struct sk_buff *skb,
 void nf_dup_ipv6(struct net *net, struct sk_buff *skb, unsigned int hooknum,
 		 const struct in6_addr *gw, int oif)
 {
+#if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
+	if (nf_bridge_info_exists(skb))
+		return;
+#endif
+
 	local_bh_disable();
 	if (current->in_nf_duplicate)
 		goto out;
-- 
2.34.1

