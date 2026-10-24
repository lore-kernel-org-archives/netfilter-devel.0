Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792861404;
	b=DMFk6ukL+yEfMDiaJT8JMwvZwPhQIpQ4dHd/KjJqHSEYZWqJkGmHnbf+ky7CxIFxbpph
	 8JN2f+yGW0xHN4Nd6QIigIAHEYrapeYxQesNbY7B2cgcjnaSKtVAa4jSxub7+hCQEsgEg
	 kdz/PfllQ4utqrjL2LS7t6TCTHudKSM+a0wXjLrdMjWI/dY4kdfxh2jW7KEdghtvynEz/
	 sMfU9ZQOz2UxXT2SQoqvA3IMDMD+ijp9FlqTpeLDqCLE5TCwx7CGPHmiW5NhryC1q5GG1
	 FPJCN/l3F4b2JpTXxdYWqpwFM5popATn6jhmVG7HL/2HmSR6AENEngSZGT5clledtJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792861404;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=jo8gmaFEhKj3JngpBjGb7fjIKG8buSADfQD1SD8Q+M4=;
	b=edj70GChqGpmwN7g+MhNBRbFEchhiUkTkt7lempZtsOM6DgTxUekJTYEVYwgFAo5oOmY
	 PnHa6NKkre0brQ3jhQdf2FJmE4p5ozTSHQmK0pb+m53+O7k8fTmC6obqZ2/Rrj5Y//ErN
	 qFdsm3BRmAC4sbtI8jZ0f3xErfdwBt7aE8j/OSxxQK/7tJLWUOCxrr4iql1MKROgs5/aS
	 3357SiQhK8B22aA+YNHz8/LJijDOnikKFkOAmKVzv76ZZiDST3vQbyn0tPqjej8dIX6Go
	 sc2EyNcCDoVGqKiwEko1DlAO03pBcGZVUsC+g1S9s/2gA/pMg6GqZ/1H4lI6XhJEDpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=bLV5+rK3;
	arc=none smtp.remote-ip=209.85.222.43
Received: from mail-ua1-f43.google.com (mail-ua1-f43.google.com [209.85.222.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F140606A31A
	for <netfilter-devel@vger.kernel.org>; Sat, 24 Oct 2026 17:03:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0F140606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=bLV5+rK3
Received: by mail-ua1-f43.google.com with SMTP id a1e0cc1a2514c-97ccbba8e86so529991241.3
        for <netfilter-devel@vger.kernel.org>; Sat, 24 Oct 2026 10:03:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792861403; x=1793466203; darn=vger.kernel.org;
        h=mime-version:content-transfer-encoding:content-type:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jo8gmaFEhKj3JngpBjGb7fjIKG8buSADfQD1SD8Q+M4=;
        b=bLV5+rK3XK4YT3V2W+IonkQsuEwFvajZnI4HZcQTFPYUff3uvQA3FjTu9QJd59qLLu
         Qt6p8wJbbIQfurLx0x7pNWMLGcwEGCnmcpl97UkPjDLgiIYPQWXVGeifujDTKCxGnAFN
         2Bbh6ANBdrNtIovjYSp2qgEJs09rnSsCLX9Sm1iIrTHRmbX3apzk4SDxqBCgnA235r9L
         +1xyXQ9J24YbQryNaMTeU97ew2Z5eVwIY4vOCNnjqEoTgqhR+r2n0z019QyRGv/+I/cK
         SYj5cOsMPjf5QMBab3y27Aygy4xhW5Y/i4+wLPPLaJhrSZplIsGPp2hAyVd4Hdt3n4La
         RKxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792861403; x=1793466203;
        h=mime-version:content-transfer-encoding:content-type:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=jo8gmaFEhKj3JngpBjGb7fjIKG8buSADfQD1SD8Q+M4=;
        b=EONXle+UhM0wlgevScfmOmeGGt+I9BayRYHJA2La/6wXnUZji1bvSjrf7BjMow275a
         Eel04rpE7fMgozBLNgCnjyZoX/NcNn6RMLsFxaVJ5FK4jECT4VlKWSLpvmLi2fkM/CH2
         yWGbaMKKncJ9XOsZqi4wo8Zn0dMwuVOPfkluJr19n7hH2EhFg23v/v7lgqofuBcLoQpe
         pwztOJ/ctrlbSXsFoUNZ5bwEDXztIWkp7P0JZijTsSZdEaihrhn1jzhtwT9zhrkjZzqU
         NQQdYtyzLITaoeHMGbioJquSjH//dp4MKQxWHogoj7cTNvzScFx46g+xXreipqIs57+a
         OEww==
X-Forwarded-Encrypted: i=1; AKwUvBxP+y1efSDFaB59qDUz8DQiE8FBvm2ovXzxsFZ0lFDEGh248RP8ZoftQHTdOt1/smhpD8OecThOHs/cCkvI9Jw=@vger.kernel.org
X-Gm-Message-State: AFq9FYKWGcL8b6RAJE1Es6LhycYmP7fv0Rvid3UsG8LTX8sP0aw2//L/
	eEKYoUUJHVcBa+NZhI5pzmUrRZO7LbM3exTiQGDOI2bTGkTe5CrP2azu
X-Gm-Gg: AYBFou0UPHXmpkifaKSGa3E9WJoAZTq5WCNvyjbaPqbWJU9l+3YHlHAPZZyGsNXALAv
	4tgHAowooqRWzno9EMsU1DTpFAXhgv0//Cnwmx7v4sIbZznhNy5ctkd0jX3dr402dGI84h6yiYE
	rtIZg3553XHVYkGkRnOxizWa0pkSfVMyRslBYri37TGEutuAckTk6Crc0mJo8gdwL51EDiza78w
	JFDuVwYInyeAnYSbC/E3TQsqkUtmt7I8EGyZkTIVsH6q4FIr97WUDRGANHtWpfYhEwM+ledUF9l
	kNFi5C4jvdYgeuY2RXaIRzc8+nq/2BD7AUQcGbfmYgoFknqIeb/Jz8QUinf6NpmGJLXYidSmUBw
	4Lf6lOy0VHGT8KImgu7N7y7r1bBjv8C5D6Zy1Qadjra19NydcbVysDFvSu3p32wP7npdvPqzShj
	554WoDmMOHAf3wiArf1IIPeS3CbbukvtxWALd0wnQcby3ltiFsVkMo3j+/zBJpTgldJuDFVmkaK
	98eF7wb04n66s5lUnrCT9Sl+yFh8rj/MmUlfrSFzTrKUHW1Gq3c6ldAIYzmtPJcecN0x+fMucYv
	losVyDC+/GcEh+vVl23YjQR8vw8IPWeMvjoVxkn4DXSJ+C5kUCwf1cnaj28C5gd1cqCuaM0g
X-Received: by 2002:a05:6102:c46:b0:7cc:c7aa:106 with SMTP id ada2fe7eead31-7ce5cd91867mr658536137.18.1792861402974;
        Sat, 24 Oct 2026 10:03:22 -0700 (PDT)
Received: from 1.0.0.127.in-addr.arpa ([2804:7f0:b101:277b:c08d:c9f9:7c08:79c4])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-7ce5df73970sm2525746137.1.2026.10.24.10.03.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Oct 2026 10:03:22 -0700 (PDT)
From: Joas Antonio dos Santos <joasantonio108@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>
Cc: Phil Sutter <phil@nwl.cc>, Duc Anh Luu <luuducanh05051995@gmail.com>,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH nf v2] netfilter: nf_conntrack_sip: fix OOB read in
 ct_sip_parse_transport()
Date: Sat, 24 Oct 2026 14:03:17 -0300
Message-ID: <179286139765.93379.986858959213810476@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

ct_sip_parse_transport() compares the value of the "transport=" header
parameter against "TCP"/"UDP" with strncasecmp(..., 3), but it never
checks that the parsed value is at least 3 bytes long.

ct_sip_parse_param() returns matchlen = end - start, where end is the
next ';' or, when there is no ';', the end of the payload buffer
(limit = dptr + datalen).  If the "transport=" value is only 1 or 2
bytes long and runs exactly to the end of the payload (e.g. a REGISTER
request whose Contact header ends in ";transport=T" with no trailing
CRLF), matchlen is less than 3 while strncasecmp() still reads up to 3
bytes, reading 1-2 bytes past the end of the linearized skb data.

Add a matchlen check before the comparison, mirroring the
sdp_media_type() pattern a few lines below, so short values cannot reach
strncasecmp().

The bug was found by LLM-assisted manual review of the SIP helper's
parsers and confirmed with a userspace ASan harness built from the
verbatim parser functions, which reports a heap-buffer-overflow read of
size 2 in strncasecmp() called from ct_sip_parse_transport().

Fixes: ea45f12a2766d ("[NETFILTER]: nf_conntrack_sip: parse SIP headers properly")
Link: https://lore.kernel.org/netfilter-devel/20260815133104.50369-1-joasantonio108@gmail.com/
Signed-off-by: Joas Antonio dos Santos <joasantonio108@gmail.com>
Assisted-by: Claude:claude-opus-5-5
---
v2:
- Retarget to nf, rebase on current mainline (no code change).
- Say how the bug was found, add Link: to v1 and Assisted-by:.

v1 (2026-08-15) got no review comments on the list. An equivalent fix
was posted on 2026-10-22 by Duc Anh Luu (Cc'd):
https://lore.kernel.org/netfilter-devel/20261022172248.554687-1-luuducanh05051995@gmail.com/

 net/netfilter/nf_conntrack_sip.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 64bc440b1..b05dc8858 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -701,9 +701,9 @@ static int ct_sip_parse_transport(struct nf_conn *ct, const char *dptr,
 
 	if (ct_sip_parse_param(ct, dptr, dataoff, datalen, "transport=",
 			       &matchoff, &matchlen)) {
-		if (!strncasecmp(dptr + matchoff, "TCP", strlen("TCP")))
+		if (matchlen >= 3 && !strncasecmp(dptr + matchoff, "TCP", 3))
 			*proto = IPPROTO_TCP;
-		else if (!strncasecmp(dptr + matchoff, "UDP", strlen("UDP")))
+		else if (matchlen >= 3 && !strncasecmp(dptr + matchoff, "UDP", 3))
 			*proto = IPPROTO_UDP;
 		else
 			return 0;
