Received: from mail-pj2-f14.google.com (mail-pj2-f14.google.com [74.125.227.142])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42EB33859D7
	for <netfilter-devel@vger.kernel.org>; Fri, 18 Sep 2026 09:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.142
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789723654; cv=none; b=qX7aktYcKtHjUMOpzWgItpTzh9zrsiuWhD0t8DThcnrED1+DTJXIJ670HwWWLuFn4JpotKLespfxmuP+6aOARi2RxoMimRA0oE+A1Zc2U80klyn8GbFtAHaeHg7K/qRNH5VEHaTsDJpIHq+C9x+HPvt/LMBckFR/PyyJeoVZvI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789723654; c=relaxed/simple;
	bh=2PXsBgcttta8/ln/T+kh5VwFoAg8a4SHHUUDPkGKktA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uPPNALB9DtY7wzpiD12Yytty9UfDdHmvx3eUql8HOr7B4MY4Rtgja0UIeQVcdMSlAgcRhnGDTmJon/1y0LjBQdzzgOgCAi7ugylH+A1a5MxFkE8Tl2ess9VThSFYXY3Qp4waIM53wH5+ISqetLys/P2XVOtPCJJwF23u1FJJULQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=MzmP2juZ; arc=none smtp.client-ip=74.125.227.142
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="MzmP2juZ"
Received: by mail-pj2-f14.google.com with SMTP id d9443c01a7336-2d747f05ffcso3951475ad.0
        for <netfilter-devel@vger.kernel.org>; Fri, 18 Sep 2026 02:27:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1789723652; x=1790328452; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TnR2h6Lhahi1XJAT4chuG9BB2ZebCYMBA16Kb3amT3c=;
        b=MzmP2juZdTTZC0yyBjL+IK5I/rW2wZM20pmJlhWQJDnslailMZCtz0bNEiKp48nl2i
         FuR0Kda3oHAsN7ERC+BExfr3vRRqoZ7iVu4Dj9tZbogXFs899Fgbpi9nd0JcNSMUUfTo
         oyKgSZx8LIjO/8sRwnuIP3f6Vcuk8XpqtgJ68+tgqVC0fdypKSO6IdMetCcar3yHx52G
         U8sBcS3VrX3dWMKmb5V1s0trtzRIW8rHyMthMe9OW9kHbYEqa+LxwVj+pL7ukCU0EEpV
         iOxYc7hNah9mcol9OAHJT5ykFCaY5+ApSfGcnge1iZgaLkJLUpEh4eUFvGNTaOzGmTBZ
         L2sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789723652; x=1790328452;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=TnR2h6Lhahi1XJAT4chuG9BB2ZebCYMBA16Kb3amT3c=;
        b=pJBSD/YyhNjFpBgitXgfCPGS4ppy+Q8dWul2OFiTANi1tXMa75qwGwps7JolRbGhRQ
         n/tP2gjxBiEu+ZZDBYO5RaqyN7QiKbzZ1IpTgRO4WH828eDeGOeklq0bIUNYIqNB76b/
         dnPxf0aJGFsDBrGsKSjyhO7WVWYcahTrSR6HWjx2pr/1usK3JE6SwGDgu8ME+Cw4a9Ut
         9TMbG7tHdzrmJ0kr9Xc0Wgw9nF9ZLCz4Qa4pmud6FS4qpnpA+F08XFk65kCC7jcjFDXy
         AOYnkkETFJZq1DfHoDqMXNxfJd25K7pubR4uR1jHEdDQXd7pQYKGVJjDWLPKaR9z+mIp
         VPxA==
X-Gm-Message-State: AFuF++lWKSR2m+H3IuE4w6etjpEEYdCX6CtUC5nouUUbEQd9kTXNXAYj
	dEGix1TsqeEe38DOANzm+l2HA1NGai7ZzVrWXsvWOoldZZLjz0ExYc/niEDD3nkbZPR4ZBAYQ26
	FJ/6gig==
X-Gm-Gg: AYBFou3N5bRNdgbDZggG4oo0dv9ia2ZE84ZUKoXL77Z19OsRR9HvFVn1LNlB68hGBoA
	H/15mEL0zki0dLG9r+dIdxnJ1/AU2/swVL3b841jxcgNbMvtRzxnaULS1xdqXu2LXwDjljnwpUx
	V6nNXAAR73e5UvgWYPxx0Ou6+Zd2qXds2i+/3SzFDlFus4HjyeX2ZckwfT68EAopz5vc6atewsh
	xwNcW3WEPwEloqDSugYoSVrqdz11cJjXwdkm578HRTyOG53xp5CUtL4epQ9n/vT7VGtwk9lBGvx
	zCgFKtI2LyxC7K0ZiJqULVk9Ox3KS7FhLcyblAZZTDGsHam5PXvX4CkP2WzAcGbzLtGaYA3B9L6
	lvpN8tcAb+JT7RXjYvl5SWVShfeR+bucZpvKEnBIU2BzNDllUkIx/ERMsM8cV9gQY1044ODMtpF
	xfIq0IH7xPDSQRUzmvx18D4Hj0w6wNRKN6mzf0VAnmi9xDw+AnqbO9eVkxNVeVIS8HqUJculfIB
	Dng75mDRw==
X-Received: by 2002:a17:90b:518c:b0:39e:4fb:fdcf with SMTP id 98e67ed59e1d1-39e54bc3c40mr4463380a91.14.1789723652609;
        Fri, 18 Sep 2026 02:27:32 -0700 (PDT)
Received: from enjou-Legion-Y7000P-2019 ([167.71.204.91])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e5a3e3dbcsm2285005a91.5.2026.09.18.02.27.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 02:27:32 -0700 (PDT)
From: Ren Wei <weir@nebusec.ai>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	kaber@trash.net,
	vega@nebusec.ai,
	petalzu987@gmail.com,
	weir@nebusec.ai
Subject: [PATCH nf 1/1] netfilter: nf_ip6_checksum: validate checksum offset
Date: Fri, 18 Sep 2026 17:26:52 +0800
Message-ID: <434460e777176900147de4beb73badb34f6b5e11.1789660425.git.petalzu987@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1789660425.git.petalzu987@gmail.com>
References: <cover.1789660425.git.petalzu987@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zixuan Chai <petalzu987@gmail.com>

nf_ip6_checksum() passes dataoff to skb_checksum() as the length
argument without checking that it does not exceed skb->len. A malformed
IPv6 extension header can make ipv6_find_hdr() return an offset past the
end of the packet, causing the SYNPROXY target to hit the BUG_ON(len) in
skb_checksum().

The exported nf_checksum_partial() helper can also receive a range that
extends beyond skb->len. Validate dataoff before checksum traversal and
validate len in the partial path before using dataoff + len for checksum
completion. Return CSUM_MANGLED_0 for invalid input so callers reject
malformed packets before checksum traversal.

Fixes: 422c346fad80 ("[NETFILTER]: Add address family specific checksum helpers")
Fixes: d63a650736f5 ("[NETFILTER]: Add partial checksum validation helper")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: LLM
Signed-off-by: Zixuan Chai <petalzu987@gmail.com>
Signed-off-by: Ren Wei <weir@nebusec.ai>
---
 net/netfilter/utils.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/netfilter/utils.c b/net/netfilter/utils.c
index 29c4dcc362c7..18f12552aa5d 100644
--- a/net/netfilter/utils.c
+++ b/net/netfilter/utils.c
@@ -67,6 +67,9 @@ __sum16 nf_ip6_checksum(struct sk_buff *skb, unsigned int hook,
 	const struct ipv6hdr *ip6h = ipv6_hdr(skb);
 	__sum16 csum = 0;
 
+	if (unlikely(dataoff > skb->len))
+		return CSUM_MANGLED_0;
+
 	switch (skb->ip_summed) {
 	case CHECKSUM_COMPLETE:
 		if (hook != NF_INET_PRE_ROUTING && hook != NF_INET_LOCAL_IN)
@@ -145,6 +148,9 @@ __sum16 nf_checksum_partial(struct sk_buff *skb, unsigned int hook,
 {
 	__sum16 csum = 0;
 
+	if (unlikely(dataoff > skb->len || len > skb->len - dataoff))
+		return CSUM_MANGLED_0;
+
 	switch (family) {
 	case AF_INET:
 		csum = nf_ip_checksum_partial(skb, hook, dataoff, len,
-- 
2.34.1
