Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20B2125782D
	for <netfilter-devel@vger.kernel.org>; Mon,  6 Jul 2026 23:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783380535; cv=none; b=BzC/PKPETL5Kd/c19BWVoFq2ZMJrqfzsZveV8HYRiQxpN93Ki/7bqjQcNkJG2BnCIkdTeejFmg4SbJddz0O7AxHIl+goMzaQODfxKHqUpIFsHsQJJ3b/BK7TTBfPNwoSqUt+XStEQBPFC2P/AxgyaK0eyNgxWcKshoCriRwCGRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783380535; c=relaxed/simple;
	bh=6aus5nLmpNBQKmu9bkJJrV4DCuNQ/m6YN4CCOKkCwJY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UVC3gJGs2jfV7Ewn/nKHAgwuTXrhs8D/SUcTVV5TEBm0r20sHy1zSrLGSePMxBQo5R3JVe4JMmmMh2JbjXfN1WNp2aNBDcRZwhRFyxz5fAejoru4QwMRd7sbufb+/W1bq6fBuZVdue4qLeijJKZ7MIhCfucoLUkY3lFAllLLpr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu; spf=pass smtp.mailfrom=asu.edu; dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b=E4VO0ivV; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asu.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b="E4VO0ivV"
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-c9e607d81fcso1949244a12.2
        for <netfilter-devel@vger.kernel.org>; Mon, 06 Jul 2026 16:28:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1783380533; x=1783985333; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=gS8hUczw2Rk4FlAnWtfGIWRRQn/NJRGeEyFfNW6rUoY=;
        b=E4VO0ivVx1Yu38a4cyH/8D0ETEtsnfpmrmdkVYT5avmT9SJBb8rszTHjKcAOahOaTR
         Yt4txnNbfIG4GaLOf07PP+yrPUG4bgqPR68ZH9WIjmsAGzYJwo8hfndv7V1k3hl1FUOR
         y7iZWmq472CWW3cDl0RuR8O35r1ZsZ79F8OsRv2ytOVuOpT6jWWj8iDqjFTwk2/inxK6
         xQQQctjyc6SJCuM38ZpOcsd1zAiPrdblMq7otlj/bjEfeWxKq+moGvNhLEDgLHtkhllU
         14QAQhHYZs4vqMvpd2KGZrgSaxJQCxXkKgT4Pxj6SMuYRWjGLmKHyRTzjhMryxhzJ+po
         SOew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783380533; x=1783985333;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gS8hUczw2Rk4FlAnWtfGIWRRQn/NJRGeEyFfNW6rUoY=;
        b=QfP4szgQRQX8P6qR/dEI89cF/OoKAt4xrQRvPzmXA6GuFbDIj2CZ5RpLAhw65xyuc1
         LqtnfBKogMxtsM3MZzeH9Aek4TsYhvIZHa0S35dxJetwsJFlRWImcR4q1Hmw2pG0cAu6
         kUbg0PlXuOLr4nZnTAnvVsdonvHkT84ODvJH4b6WtJBc9f4W4ulPAuur1WQVtzA2gBe9
         J0BULam/jvzQopDlfre5RBE/NuzHLgrN03Rqbwsv1XnmoipxD48sqgYTn4Xc0I4vJUyG
         v0Ny874lw3E6yIBfkPQRModCrKXYXSdMMytH/BWlvkfMHYhy8Q30N/OKmFpH/HeF64Pj
         FXcA==
X-Gm-Message-State: AOJu0YzTxdCD783XIqoHCXo0tJIaXEH+dB032jy50W+b69mOU7xiX4C1
	bbRQ6IlMKn1UnF5AXobSPgHbvvSgHUyjDO0z2/K8w+XKdjr+TRUbtX4JaSkqpJkNAQ==
X-Gm-Gg: AfdE7cmqgENgNSIT9ZniY5lYXIk+Dl2FeLxUTHNruZj22gBaawwfS2E47lPPmtyQuFC
	dzoeca66U9N5vxJt5MXLrsul68Iyr3oDI2fBnVqCBC4wvDeeXEzLL5WVd+o8H/+BfGYCi0wHJUc
	SmLC9rvUI4ccTzdUfr3FBSS8/aEUpSxQuFJFjDPMdqTFzKvCYC41mv+loz+el1JxOglREbyT07d
	V4i0koQBDQEFJ4XaiCRre2OezDXrd0tbQjwdW+ypIYy52nJTxvgsk6kLAUXFMiknVeIiW1aTzXI
	XMUG48Ro+XGgoquTp7OVFA2wrtYHfqZInkfmh4y7CY+LLgI5ZDW7NQBM7jbjkIMYDOjT73E4iUX
	X9P5iH17vQH7i1eJEnT10HZcbY6lwO9B7onWrWmw6RJN9mp4JP/+sqORpnH9baRr/xNWFGd186X
	DVyGLpUF/jpQr7L1r0dQ==
X-Received: by 2002:a05:6a21:7104:b0:3bf:7ab7:98a4 with SMTP id adf61e73a8af0-3c08edbbbafmr3058208637.27.1783380533372;
        Mon, 06 Jul 2026 16:28:53 -0700 (PDT)
Received: from xiang.tailc0aff1.ts.net ([20.171.14.70])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31174a56d64sm1228725eec.17.2026.07.06.16.28.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2026 16:28:53 -0700 (PDT)
From: "Xiang Mei (Microsoft)" <xmei5@asu.edu>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
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
Subject: [PATCH net] netfilter: bridge: fix stale prevhdr pointer in br_ip6_fragment()
Date: Mon,  6 Jul 2026 23:28:50 +0000
Message-ID: <20260706232850.3333016-1-xmei5@asu.edu>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

br_ip6_fragment() gets prevhdr, a pointer into the skb head, from
ip6_find_1stfragopt(), then calls skb_checksum_help().  For a cloned skb
skb_checksum_help() reallocates the head via pskb_expand_head(), leaving
prevhdr dangling.  It is later dereferenced in ip6_frag_next(), causing a
use-after-free write.

Re-find prevhdr after skb_checksum_help() so it points into the current
head.

  BUG: KASAN: slab-use-after-free in ip6_frag_next (net/ipv6/ip6_output.c:857)
  Write of size 1 at addr ffff888013ff5016 by task exploit/141
  Call Trace:
   ...
   kasan_report (mm/kasan/report.c:595)
   ip6_frag_next (net/ipv6/ip6_output.c:857)
   br_ip6_fragment (net/ipv6/netfilter.c:212)
   nf_ct_bridge_post (net/bridge/netfilter/nf_conntrack_bridge.c:407)
   nf_hook_slow (net/netfilter/core.c:619)
   br_forward_finish (net/bridge/br_forward.c:66)
   __br_forward (net/bridge/br_forward.c:115)
   maybe_deliver (net/bridge/br_forward.c:191)
   br_flood (net/bridge/br_forward.c:245)
   br_handle_frame_finish (net/bridge/br_input.c:229)
   br_handle_frame (net/bridge/br_input.c:442)
   ...
   packet_sendmsg (net/packet/af_packet.c:3114)
   ...
   do_syscall_64 (arch/x86/entry/syscall_64.c:94)
   entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)
  Kernel panic - not syncing: Fatal exception in interrupt

Fixes: 764dd163ac92 ("netfilter: nf_conntrack_bridge: add support for IPv6")
Reported-by: AutonomousCodeSecurity@microsoft.com
Signed-off-by: Xiang Mei (Microsoft) <xmei5@asu.edu>
---
 net/ipv6/netfilter.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
index 6d80f85e55fa..547879da9532 100644
--- a/net/ipv6/netfilter.c
+++ b/net/ipv6/netfilter.c
@@ -147,6 +147,10 @@ int br_ip6_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
 	    (err = skb_checksum_help(skb)))
 		goto blackhole;
 
+	err = ip6_find_1stfragopt(skb, &prevhdr);
+	if (err < 0)
+		goto blackhole;
+
 	hroom = LL_RESERVED_SPACE(skb->dev);
 	if (skb_has_frag_list(skb)) {
 		unsigned int first_len = skb_pagelen(skb);
-- 
2.43.0

