Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 665BB43FD2D
	for <netfilter-devel@vger.kernel.org>; Tue,  4 Aug 2026 09:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785837074; cv=none; b=juw+oUoaIKZvGcH8Ti0NmIrPukiY0pNJTJxQsd2KaFLqh4v7YcVmXwxc7KoHhF19zQMFjsuJet2vequ+Fqq3493xGLQSIo3gYU2ly8mC8GdYr6x+Hu4ATQ3k3pClPoK+/H2DD2TAYkV3vhfyPqE6udbAzCg15lG4KUyfad+7hoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785837074; c=relaxed/simple;
	bh=lC/ducdV2H7jnVxT/7JAc5laSsEQNeSS4QDRVHC1kpM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rh32V254mxgRIlooYQGpV6SIaeb6t+/j9k77eNrd1wAsTFj0x+sA6qin8dOEWSjqGrg5rTdgjZdgHZA/b+oFz40uXwHRkv5YI90tcxZgt/53xyKPkw5vajtphb//DRp4kixQGEqUQQHYZUjhcW0c/9PqpRq5XSCstAvbt1MRInU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com; spf=pass smtp.mailfrom=trailofbits.com; dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b=dVsE9+Ky; arc=none smtp.client-ip=209.85.222.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b="dVsE9+Ky"
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-92e53581361so227357985a.1
        for <netfilter-devel@vger.kernel.org>; Tue, 04 Aug 2026 02:51:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=trailofbits.com; s=google; t=1785837068; x=1786441868; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=yj5OkcleFZPhIcxhaAKqjQ7zy2dYnyYbcjjyfgxvOKY=;
        b=dVsE9+Ky2pGjCOAWGNXUPhoYv4/xmYSr6SO6xKO5/UNED+i8cDsVc8075+1wktK77e
         LPxpMoHktevqqg8KZCzdvwDp3lyY2zieJqM0LLrfN8o2UvBeid6lcsi1TFJmXdz8H0du
         KOw3iHisuqEA6UgUxFtTk1Mzax2NMro/R+RnV5DKPyAXLh4QyxT37b2q9SOvblDkOMGZ
         I6yH1al4B03sXT5WmjxsJLzPdp+9cZeFTF5/E7pA7BmPr2KWNbpBB5ET/Qf3LnNLT1mF
         BtcV6taYiwwEqmKm2CYfYlGTQvI08qb0D9ZP96d2zRSQxUMY/jm8UcRFGrG83XyzpX8M
         8ljQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785837068; x=1786441868;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yj5OkcleFZPhIcxhaAKqjQ7zy2dYnyYbcjjyfgxvOKY=;
        b=cOv5r5re+avuQusTt2moTu4Hd7DvTYsQwKq9jlimY2JjJl8LJPajBZyxK8I2id3GtL
         faRmuk3iS18pL9quQyVOscjKoEZcxvhOQG+NwzSaGZZ1fayq3/h03z/tX168SnUumsjp
         2ytzoXUbkJAyavhRjG8wSvyc6z4hMdHXqc9+6SdlvmHtJQYEi3fJxezmZu8NXOK2T49M
         ljVWy4ag+HlLRGkKlu84Z62S8wZDGOldJDDEGJjSNykKgCGautI/nmi774TKeMsB0N9I
         tCu8ETgmsY7d5ceNHpUt2sj5nQi2fsgz5m6p39+WA+V8PUyfKDZpBf5z5Khx4TPIjkXr
         zo8w==
X-Forwarded-Encrypted: i=1; AHgh+RqkB+p0/k7AVIqmdMX5HoZqu1Iq48MuMx4p0CYLbtnVjemvTsPkkAq+ZDYPYfn0tUUsVNuBKzRN4Q9FEd4yZ6E=@vger.kernel.org
X-Gm-Message-State: AOJu0YyZedcSqjOFuOSGV1w8T8C0LaMG5M4dvx1FAkPmSDmkx6sDDLxJ
	OI6Rr3jJIf6BKhQ0kx88IMeJSoMXPKT9wyFjza+BMn5QC5qG5f+VsHnbqXEsM9G+FRY=
X-Gm-Gg: AR+sD10uk9Vkt3onOJLd38/CkW4y6KZeCw2LbiM9oIfKxdshEf8h/ahJw3LNhIijQa+
	QATSKh2j7jU6g7XdmvTMTTCov+kCALh0zcMNUAiAQ3Pg+0Jl1eR85sNm0FQYWkNdRTMH1mCdbf7
	e8lmrsbVFsV9pYlwQJKWjOKI7UDSWgW5AHYhb/haL3g3iKgsSfkuWMV97vM6eZs/ftF2eYxg3t6
	bcCI/cdvjlu3gu0d0n8kGyGX5M0rvVjEmMWRXS/Pcc0HThSJq0vrynxMezwCPjvw+Mlg1z+REiK
	2dLsgcykxbzPt1rurR8YWoMc2mwIMHj+UVObQD4xsYgz/MxqyUsfcddLlVyO1UhkAqJ/rR+kr+2
	SnKCyQKe1+X/laqetmAtZ5UrrRYTtz7TmrYg9vMXRBnxF+5ZZP56kv9AVNlr5Qa6Xh8gy0Dw0bM
	SXhIMPUFsBVHFDVI2fyhR+D1kRoFysGutdPgEQNVxavGRk17j9UZlbNbjJfQ4loh51Kg==
X-Received: by 2002:a05:620a:1003:b0:92e:9cc7:fa46 with SMTP id af79cd13be357-934a08b94e9mr2103243085a.21.1785837067707;
        Tue, 04 Aug 2026 02:51:07 -0700 (PDT)
Received: from localhost ([146.190.222.192])
        by smtp.gmail.com with UTF8SMTPSA id af79cd13be357-93641756c67sm39269185a.19.2026.08.04.02.51.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Aug 2026 02:51:07 -0700 (PDT)
From: David Lee <david.lee@trailofbits.com>
To: pablo@netfilter.org,
	fw@strlen.de,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com
Cc: Kyle Zeng <kylebot@openai.com>,
	Dominik 'Disconnect3d' Czarnota <dominik.czarnota@trailofbits.com>,
	phil@nwl.cc,
	horms@kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	David Lee <david.lee@trailofbits.com>
Subject: [PATCH nf] netfilter: nf_reject_ipv4: initialize IPCB at inet ingress
Date: Tue,  4 Aug 2026 09:51:05 +0000
Message-ID: <20260804095105.715387-1-david.lee@trailofbits.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Kyle Zeng <kylebot@openai.com>

The inet ingress hook runs before ip_rcv_core(), so IPCB has not been
initialized when nft_reject_inet passes an IPv4 packet to
nf_send_unreach(). skb->cb can therefore retain data from an earlier
protocol layer.

icmp_send() treats IPCB(skb)->opt as parsed IPv4 options. Stale option
offsets can make __ip_options_echo() copy an attacker-controlled length
into its 40-byte reply option buffer and overflow the stack.

Clear IPCB for NF_INET_INGRESS and restore its input interface, matching
the initialization normally performed by ip_rcv_core().

Fixes: 117ca1f8920c ("netfilter: nft_reject_inet: allow to use reject from inet ingress")
Assisted-by: Codex:gpt-5.6-sol Codex:gpt-5.5-cyber
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Co-developed-by: David Lee <david.lee@trailofbits.com>
Signed-off-by: David Lee <david.lee@trailofbits.com>
---
Bug found and triaged by OpenAI Security Research and
validated by Trail of Bits.

Trail of Bits has a reproducer for this bug that triggers a
KASAN stack-out-of-bounds write in __ip_options_echo() and can share
if needed.

 net/ipv4/netfilter/nf_reject_ipv4.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/ipv4/netfilter/nf_reject_ipv4.c b/net/ipv4/netfilter/nf_reject_ipv4.c
index 4626dc468..4933f6513 100644
--- a/net/ipv4/netfilter/nf_reject_ipv4.c
+++ b/net/ipv4/netfilter/nf_reject_ipv4.c
@@ -355,6 +355,12 @@ void nf_send_unreach(struct sk_buff *skb_in, int code, int hook)
 	if (!skb_dst(skb_in) && nf_reject_fill_skb_dst(skb_in) < 0)
 		return;
 
+	/* Inet ingress runs before IPv4 initializes IPCB. */
+	if (hook == NF_INET_INGRESS) {
+		memset(IPCB(skb_in), 0, sizeof(*IPCB(skb_in)));
+		IPCB(skb_in)->iif = skb_in->skb_iif;
+	}
+
 	if (skb_csum_unnecessary(skb_in) ||
 	    !nf_reject_verify_csum(skb_in, dataoff, proto)) {
 		icmp_send(skb_in, ICMP_DEST_UNREACH, code, 0);
-- 
2.53.0
