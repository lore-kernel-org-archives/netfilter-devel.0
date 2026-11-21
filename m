Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.160.45
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795239751;
	b=QLSQhiI/EPKbvny3Ml5ASWUPbDYQmrNVwQvCxCbs9WW/GrGBxQJy1Cg8ClVQFsFuvCxz
	 0D6HRceYDwH6GWNlfrrQvWWjT847zIoSH24GbfxYW4GvajywNrw8vuorswQWe9Tr7qm5b
	 G2Nlo03OMBo6rlEtMAXololVTyslliP/zwie3uCm3MR5h3bHv6Fk7w/q6O9cjWRi0IbRW
	 eS+mfaVKZLmIK3PRGI+MAbVZLjwMl9BDSTVvRszrLvpMw7YpKmZayo/y4oHhywRak1RA1
	 3bNe3dih9Awx+6BzZA6RjeKRc6ZdovGzjDa9tSJLII9Qt+WtA/UIDL0/YbgP1pJquQw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795239751;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:MIME-Version:From:Date:X-Gm-Features:Message-ID:Subject:To:
	 Cc:Content-Type;
	bh=RbxmXHzp4+4SD5LEMa4YwZyPNbSsaEhdyxEWnEydpXg=;
	b=K3KBVRvbUIqVx78+/i/OpsOWGViQTW63edS5bwi6fMqH4jcwwidfTe6jb29Ly+BK7TMg
	 Pis2MvKHhPlaBMsNBGFaye9LTt1oLDVoieeUpKMcrEzatgp8YXooIuOPWoyhk1FN+RNNo
	 qiwGNOXmcUw1Vc6m6fsAYBW9PZCN2wi5+QV1dj3T76aTmt9TuXKv1Vye9WV/HY45owX2r
	 9qF4/ltSkXu3SvcpUCEyC1+8mCnmbyKJk0J7pS8SQfs8z87J02W7e/7epKfPNz2ZXcZ5k
	 r2d5Z5N9qKiNwurNb+Rl6pf5efsUKZC9tRX7UDh7GNpNyRdZabJ6Dhtx5F1nKk6DVZw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=none header.from=ikotaslabs.com;
	spf=pass smtp.mailfrom=ikotaslabs.com;
	dkim=pass header.d=ikotaslabs.com header.i=@ikotaslabs.com header.a=rsa-sha256 header.s=google header.b=eS+gSD+u;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.160.45
Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D1A3606A333
	for <netfilter-devel@vger.kernel.org>; Sat, 21 Nov 2026 05:42:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1D1A3606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ikotaslabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ikotaslabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ikotaslabs.com header.i=@ikotaslabs.com header.a=rsa-sha256 header.s=google header.b=eS+gSD+u
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-4a85c656c58so1111826fac.3
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Nov 2026 21:42:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795239749; cv=none;
        d=google.com; s=arc-20260327;
        b=J3OSWM0yOpFc810o/CWhEGFifeoSD01W8iWI3BGfLU8U7DGCao/Mo4eW5eVsCJRDbO
         mC+MqEEU650gqhQJMNXj2bukPFwNuL40hTVg7791Ui8yH2UNU7zBuwYz5XYfU4w/Q9H8
         5l039HIIJLuqLy+Fu89FYdtLoAP0xiYs1OgRFLNiJSj3gcOxIWIh3Sz2kdnfvVjt2E1H
         aBISR3vXhSaXN+Uq8GjrNYLlpb3rewNIjkfoKX/3GGhdPsQW14fAseEuPhhqUStOzCn1
         VJQI9Juvg1iVMC5ysElScF1D8mmo5fiJKOd/QbxzpG22aqUQU7qmEfrELe6wuK3cXkyo
         FtpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=RbxmXHzp4+4SD5LEMa4YwZyPNbSsaEhdyxEWnEydpXg=;
        fh=0YPz5CgpUsIGoLRzfHVMB4chN0owIiqsbunILpCXqWY=;
        b=iikAajnwOxCf9vZszudRNUPE7TqEhLKZVlg/Ds1dqyOVveAq6HH1xtpAeEshtMZWhk
         buyqjZzMSUA2KvTr8hBPDu5nOzh73AIk4HeuUSNESImRcD42PRu2BdiODEor+s1J7ZiL
         eVzW6Ca4bVnnd23o5opLWiPG8EsAGcYx2sIFbNlsI1AdDtkyjLSUHFSEGeBGPO6CHhi+
         z+/EFW7jxoN/BFcGCsoUgdm2VlBrecSHFrEjbGZSGRdHgNizKEL8ZWOcvohkX5JvFZyZ
         uQ3jOEKnIeyr73BX5mVfFmkYOYaEsmC5o7/ThExAjR1P7sgR78vrc5KdJ1w4e4OAObZu
         eMQg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ikotaslabs.com; s=google; t=1795239749; x=1795844549; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=RbxmXHzp4+4SD5LEMa4YwZyPNbSsaEhdyxEWnEydpXg=;
        b=eS+gSD+uSAACx9JfBqqJSBKbWWWelIquCHcZkcTgKXbPqoG2KOpeBESyScMKL3m7OA
         H1fxR9tf3TM+EraPeIWzcXMVcHafScNwaOKQ8GW712Uky900JYv9GJD7/BXhE+beRCGy
         QxVHtM8fYY23nga48Pc8UAccEOKEK2DEXlOYX+YTjJM1kIUuGHK9/ve+xKjyaGi5Q/Te
         o/zbmr3LZJR5oUX9xM+oLT4u4NCkrv4/nhG37R589naKfT86V55z0zGVEzGVAN1bS1P6
         Rh8jfQVde4k98ERZ/otpJU/7+TXzrNZ0qHCHKlHWYkvv6RG1LIc/RDk1sBU2Kzv98XYj
         KgjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795239749; x=1795844549;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=RbxmXHzp4+4SD5LEMa4YwZyPNbSsaEhdyxEWnEydpXg=;
        b=D5W5x0RAQMAWx66lz5fk/9/LxQa1Xed3KtI1oKMOWNicndrbq3tRL74hpkvfr7ECyk
         cNOrmSdFu+6CQlDMfBjHkjfTpXbMkZXnFtipKtWFyQD0yqFo/gbF9phUWOQqSKuE3+68
         AoJIL5YsLVtYNj1hm3Zs3xgNq4ItChfsx/qbDkwFUTKD9CRnAEbRul4PQ0+EqHtLsqIQ
         tOGfLsNKzOBjh7QvaErsEF/qb+TxsaXSo/cgtq0+oudgBcEY4jM9Fj+Ick7kpOyuGfAr
         /l6C9nVMl4wZPZcSEk5nN+ZBsmWsxtXT115I14NJro/6pJM87ty7l59wMXUect0+1L/t
         uQ1w==
X-Forwarded-Encrypted: i=1; AL+hErGNzp1U8FM1cUoIKVLYiGKrHDZTBV58YZSCrGaPUkhKz9fS8f2rSv52rD4Y1UEUcFpw4RuyQXY+n3BTWM6B5Jw=@vger.kernel.org
X-Gm-Message-State: APuU4Z+EiOOhna21fVlPfx8z9qrwu4mL9dkpv1n+XRSWDKLRsW0+xXdP
	CK0h0jAKhO35RqOwioUGxGuiSBocmJacDXZ009+Ck14jqXc+aa3Po+AhB5x2KglT/s+jeVc00S1
	2JrRmN5uu65NZZZSl/6PH2u/lqTzde5z0wMwAFVVmK2o=
X-Gm-Gg: AZFdTZcIuzSXcqwpwiloUpvQB7C+QEUL+djPrXj+dLtanhovQk7hron4myrJbHzpJcY
	k96k7Mrv/GTwrnDIuKzW6GjJyF0wgCZ/DXHKnQ9ob94pblM68d6Uq0rTO3SAWr9vZGGMO4HNrMk
	XXiV5gSzqAX8vXDtsIRQvIuKbQ3fzcKFGh/XpxnDk2+z2K1idDiLY36xoyHwT6mho5epboeDggm
	VgtrxMjmnqYa7LEWmR2CQCRapu9q71kzUviXk5iG7RQN/hMzVz8WzjskBL3aR/9MsgOX3Q1un2K
	Hn5wvhqNL4EiicIcZmYoxp1wXWKKnkIKo00bYeRjwvyKVr1zeqJYNrs8CvNuq3g6ccNyrIMRmY9
	rL7O/h29INF0XrMwpyAjQzu1q+rM+vNDLJweQ8IbDybHYLyAaDJEC2W0tfLCZRtcyoo6HAcayMx
	4rRd1rCHrFUiprS5Ehwgkt7CpmI71WO1OCwjXgQKf53AsO6I2G0HXU
X-Received: by 2002:a05:6808:1507:b0:4e7:dc61:f4fe with SMTP id
 5614622812f47-57a0b6538a6mr5765639b6e.55.1795239748663; Fri, 20 Nov 2026
 21:42:28 -0800 (PST)
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Fri, 20 Nov 2026 21:42:28 -0800
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Fri, 20 Nov 2026 21:41:06 -0800
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
From: Ryosuke Iwahashi <ryosuke@ikotaslabs.com>
Date: Fri, 20 Nov 2026 21:42:28 -0800
X-Gm-Features: Aa3M54oJ7RV1UUZLj951bD33F3wFGlK1FrtiRVsmCXl65201QevA1iUR8ajIwV0
Message-ID: <CAN2NGG5YmbkmJ_kncJEaU=OzJQnpi811A_wQsiPw-PhiPCQqeA@mail.gmail.com>
Subject: [PATCH nf] netfilter: ipv6: stop the conntrack fragment search at AH
To: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>
Cc: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

find_prev_fhdr() looks beyond an IPv6 Authentication Header (AH) for a
Fragment header. Reassembly there can change data covered by AH before
IPv6 input processes AH.

Stop the search at AH. Conntrack still reassembles fragments when the
Fragment header precedes AH.

Fixes: 6aafeef03b9d ("netfilter: push reasm skb through instead of
original frag skbs")
Signed-off-by: Ryosuke Iwahashi <ryosuke@ikotaslabs.com>
---
 net/ipv6/netfilter/nf_conntrack_reasm.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c
b/net/ipv6/netfilter/nf_conntrack_reasm.c
index be72c4346f8b..9d49e3f8236b 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -407,9 +407,9 @@ find_prev_fhdr(struct sk_buff *skb, u8 *prevhdrp,
int *prevhoff, int *fhoff)
 		struct ipv6_opt_hdr hdr;
 		int hdrlen;

-		if (!ipv6_ext_hdr(nexthdr)) {
+		/* Leave headers beyond AH for the authenticated input path. */
+		if (!ipv6_ext_hdr(nexthdr) || nexthdr == NEXTHDR_AUTH)
 			return -1;
-		}
 		if (nexthdr == NEXTHDR_NONE) {
 			pr_debug("next header is none\n");
 			return -1;
@@ -420,10 +420,7 @@ find_prev_fhdr(struct sk_buff *skb, u8 *prevhdrp,
int *prevhoff, int *fhoff)
 		}
 		if (skb_copy_bits(skb, start, &hdr, sizeof(hdr)))
 			return -1;
-		if (nexthdr == NEXTHDR_AUTH)
-			hdrlen = ipv6_authlen(&hdr);
-		else
-			hdrlen = ipv6_optlen(&hdr);
+		hdrlen = ipv6_optlen(&hdr);

 		prevhdr = nexthdr;
 		prev_nhoff = start;
