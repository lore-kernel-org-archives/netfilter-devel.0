Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13DEF33438F
	for <netfilter-devel@vger.kernel.org>; Tue,  4 Aug 2026 06:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785823861; cv=none; b=tS2qJ44oRWUO34OvFDiKNw3c4ganepiZ4OjafhK/MaKesM6R/B2LJTBB23oi7hjAW4j+UVQlidI7Tu1MkwJFKCuANA+zW4ZYKxAY+FQD33xLd/eGhRtzTIgMyuXfxUH4lSAH3ask0ajrwugs8/PbBfY7mxA/G+Q8Zroht24gdnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785823861; c=relaxed/simple;
	bh=6L1PVLST7v1nkRF+r8Iv2XGopCR5emnQnssaQ73pjKE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fRN5VbVetKKvEcJWJH10Q3n7eCkLBKCVscxVEUq/Ihj2CXQJaJDFGIUuptVvjFQy1uKDBVTo21/Ae7Wvl+PnZUWwgWMq45SU5vvaNP/BBy3rk61ApSMKQivZIDPJXTQo2QDFxyEAfQLhu5cQ/98xFhgAYNk+mB8dyNnbIgoG+zA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com; spf=pass smtp.mailfrom=trailofbits.com; dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b=VLfa1xOg; arc=none smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b="VLfa1xOg"
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-8efcfdb2b43so31977446d6.3
        for <netfilter-devel@vger.kernel.org>; Mon, 03 Aug 2026 23:10:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=trailofbits.com; s=google; t=1785823857; x=1786428657; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=DuDYSjJQEMSMyuu+bbvopLn43BBsmPMFs7o1wHmptzs=;
        b=VLfa1xOgk01S0I2L6YD4aRtKIaQinZJQojLMS+83TLQgeFf4npsXh9E93ApIT1LL5/
         hawKrs8rZBJJwKbQsQR8Nnha6DM89JW1ZWX/Uoq0jRO2sVwiT/Pog1WwGuYlV19Sttzp
         XR64xo1TYSz8hSq969/dRX7Z/nrxePk3psYqiIo9eqPvhE7edxq/tVWtKCq6BoRbYVOV
         tvuf+H2uTkJDsf8612X+N6vE9erSzQZ89iWpSelr1UqSlXjiKwNPCVTT2E0bw7YQT/Or
         RBBQwHsAnwF/kMUCpfzfj4zG5aTj8scSOR3dEGkbmr3qIpuoAkGIQxDhhVqusX8BC10J
         0EQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785823857; x=1786428657;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DuDYSjJQEMSMyuu+bbvopLn43BBsmPMFs7o1wHmptzs=;
        b=GKlzG7BYLEs2oXgK2g9ae2FkS2fR7373PHE6EFHczBm6jnp/zRIG1vUHjkZoojicCv
         A6iljX+Ly44edpapRnIwI7mmTwGpL5CYtgr4O+cuH8tGWa4QhtlSqKbFo51ymUL7PgaZ
         dN8VxENX2EE60/qejlrBGV5Rhafgy/EbWb+haWpR0Mee1jDSmzFP/MWkajp+xtkyJBQc
         JmCudLTG2YitPfjRtWfgvWmJ8rPG2HKnYW8ycfDsWOsp2JOwRv95J6Snq8FGeQ3ZoGec
         vcoAfj7Q7f5X7rwLMZtKbregtKqqM6eeNxYqSIJyiEr0yBN/RAdfM65LvUUfOjvT8CYo
         s3CA==
X-Forwarded-Encrypted: i=1; AHgh+RrkObLAxbPA7YfncG8kMlnEUFrqFMIiRzsxMqW++qy2Em0NgXbydhumEFZWraCjh7X/X+Yky2KdoKEGs16iiS8=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywww7Uk901Kr+Pc0zPYBlnMmWejU5Puh8z8XHhBH7+PgWR37u86
	UmQmoAU0eDaHyr25Cb49xpJUyVYiBYmXlwpp3XJ4eY/xGuJWEwL4uBeMcliZYctFsGU=
X-Gm-Gg: AR+sD13jI359OskHxYwIsYocdguV1O9t0MOeFCnDQduv2PFaS4PHukFQrUYTC9gCgYu
	1h9jey5VxpkkArkPw4iTZX+PQOugXwpWv9xNJEiYLTYr+nBzcpM9tOq/5/y4MyJ6CcQGXnrC7VO
	rvCzOszjTq2DP0UnJ7K9CcO42yKqPPLTVDIBWJBx+LTJkxRuaWlPHojq6TXIYIaA+95wVqDwBgL
	FEbYLlKmzmblY/am6QStfNdRZz0ddYU5lUTVn8RUJi6ZEQswbnzRL++pbGrzqtI4XXRxuY5qZol
	38SzPefUS/xbm9OziboMQA9V2OHDA1ZC2FhKBB1yM3IaUFw/Ky4Td0ZpDsVp1Qfk7mJcB2BqCGH
	73rhsd01tb5qKCCPt+x1MpHB/4VZzb8r+AOAT2L2VUQubxLpVCslJQEhQt/qrnd8dk0/c/AYM8X
	V6WPFdPTi39sYPHxMwrD6d2L1D6AI7jU0Lr6cdrwtswl38UivVqL4exe5oth5sjdgQ2w==
X-Received: by 2002:a05:6214:2f02:b0:8ea:184f:c15a with SMTP id 6a1803df08f44-90849600a6emr294349336d6.17.1785823856908;
        Mon, 03 Aug 2026 23:10:56 -0700 (PDT)
Received: from localhost ([146.190.222.192])
        by smtp.gmail.com with UTF8SMTPSA id 6a1803df08f44-908435eab41sm92617856d6.34.2026.08.03.23.10.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Aug 2026 23:10:56 -0700 (PDT)
From: David Lee <david.lee@trailofbits.com>
To: horms@verge.net.au,
	ja@ssi.bg,
	pablo@netfilter.org,
	fw@strlen.de,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com
Cc: Kyle Zeng <kylebot@openai.com>,
	Dominik 'Disconnect3d' Czarnota <dominik.czarnota@trailofbits.com>,
	Sven Eckelmann <sven@narfation.org>,
	phil@nwl.cc,
	netdev@vger.kernel.org,
	lvs-devel@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	David Lee <david.lee@trailofbits.com>
Subject: [PATCH nf v2] ipvs: clear IPv4 options after rebasing tunnel ICMP errors
Date: Tue,  4 Aug 2026 06:10:55 +0000
Message-ID: <20260804061055.711402-1-david.lee@trailofbits.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Kyle Zeng <kylebot@openai.com>

ip_vs_in_icmp() rebases an skb from the outer ICMP packet to the
quoted original request before passing it to icmp_send(). However,
IPCB(skb)->opt still describes the outer IPv4 header.

A timestamp option in the outer header can therefore leave an offset
that points into the quoted transport header after the rebase.
__ip_options_echo() treats a byte at that stale location as the option
length and copies it into the fixed-size option storage on the
__icmp_send() stack, causing a stack out-of-bounds write.

Clear the stale option metadata after resetting the network header.
Keep the remaining control block fields, including the ingress
interface used by the ICMP response path.

Fixes: f2edb9f7706d ("ipvs: implement passive PMTUD for IPIP packets")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6-sol Codex:gpt-5.5-cyber
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Co-developed-by: David Lee <david.lee@trailofbits.com>
Signed-off-by: David Lee <david.lee@trailofbits.com>
---
Changes in v2:
- Add the nf tree prefix to the subject.
- Restore Kyle Zeng as the patch author and correct the sign-off chain.
- Move the research credit below the commit-message separator.

v1: https://lore.kernel.org/netdev/20260731140822.567128-1-david.lee@trailofbits.com/

Bug found and triaged by OpenAI Security Research and
validated by Trail of Bits.

Trail of Bits has a reproducer for this bug that triggers a
KASAN stack-out-of-bounds write in __ip_options_echo() and can share
if needed.

 net/netfilter/ipvs/ip_vs_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index bafab9345..fe06c380c 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -1951,6 +1951,7 @@ ip_vs_in_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb, int *related,
 		if (pskb_pull(skb, offset2) == NULL)
 			goto ignore_tunnel;
 		skb_reset_network_header(skb);
+		memset(&(IPCB(skb)->opt), 0, sizeof(IPCB(skb)->opt));
 		/* Ensure the IP header is present in headroom */
 		if (!pskb_may_pull(skb, hlen_orig))
 			goto ignore_tunnel;
-- 
2.53.0
