Received: from mail-yx1-f54.google.com (mail-yx1-f54.google.com [74.125.224.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F9D7479898
	for <netfilter-devel@vger.kernel.org>; Sat, 17 Oct 2026 10:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792233481; cv=pass; b=IoZUZpvNPIMWc8Hm/EjNA5uYgBgBDeA4L7QHaUdQrU3JktHp+gfikCvxYllUNY1IEUbZmnnPecWksNCUF5gC6yWMsM7PtMTwUef4qVglp2NukY8uiFBPbc+Qk2NqBNcEdUuGvh/rIQVemOHOU2JGFHstuDaflCfUcbWsxmB/nvY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792233481; c=relaxed/simple;
	bh=lpQm89oJ+ypIsAu728Xi2E+HeQLkTJDqgEphRq69EuQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ogwElfp6OTJzzTBzZmVS7+aiPWKijja3OQsqjV7zD9oG9Mk4k1B9WJ6ujVU/rC6c/MPWWyz0K4Z5bjmgRGSTv44ndssvvYwA2lVQIMJeKt4IBP4frA1IxbPHIKWN/whr2nTM3Xig10E9B0s6WAJUw1EBXeo+mOVYtGINTjaS1LQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=uSrfBAHd; arc=pass smtp.client-ip=74.125.224.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="uSrfBAHd"
Received: by mail-yx1-f54.google.com with SMTP id 956f58d0204a3-677af43eed4so712388d50.0
        for <netfilter-devel@vger.kernel.org>; Sat, 17 Oct 2026 03:37:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792233478; cv=none;
        d=google.com; s=arc-20260327;
        b=b3a8Uvu2uH3Avb+3YkoEHYH5NzV26nGrDq4+gWSmGkAdtZqFwszfZo9aTS/cs3MT65
         XgCTdc8wI9BK8dQsmAKpgoiOTkMIBmde+tb786dPMcjj/JfTSgXC9h/5T2YrBqcpKl6p
         R3dqdhTzXTdqohyJw3iW38vUKcuZJHEToMGmFDTdocEFVDxjpYrkf8a+YOXXwQwTfNeZ
         ofJ8IurDEjYGJx5vqj1kDQg66xbe83mvUCgMiu4zVAZNtK/fxvDAm3ff6M0Y30Vj66CH
         hfefIUGZv6q7g//rgNzKH6a6g7AqjRHuSprpvw8liYxoF6wgjLsfBh1BaWA+BqkspuQK
         m1Vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=MRmDjnl0l5zRiljfJEoqVKQPlK3YrtzEIxHy6EIjrqI=;
        fh=smm+gLePgRc4O3utR/hrYNMh8ALy6v83+qfCv+np4Sg=;
        b=WrbiD7Hbh4KTfuI1PjsAq2p+rVom7q3wUAsR0fRG4ys2D12SN0JerxfwQkm7LJxug1
         E6KtfiVECQIPxRmIgfupaHLYkun4AOLM7KsQyRo09apKK8we8dpy0MC/iEQax3p5WPJO
         iZczyxTQTb4mbORsvODlAX1E6T4TkZDYjcGQbmeMu1YpIiUZvJlcctzplSTiA4YpZkAP
         MrBuJ1/3e1GYYW1zdFcJ3K3mv2NpHy2Kbs5Ko44gSpO966sNNBDu8Lfj/vo2U/kGByLt
         F0hrcmFCr65wNX6sDCmKKPTKzOPYBCl5S3RYZv2GrgEB7faOrxg0HUkEBVLo2C1QtQ8e
         qDYQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1792233478; x=1792838278; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MRmDjnl0l5zRiljfJEoqVKQPlK3YrtzEIxHy6EIjrqI=;
        b=uSrfBAHdi1kw9pdt1rRTCQCehVBqjUEphMkLAn0rsLnrx+5ggEOimnaLY1KxVWaqt7
         MFA9g3PukgfK3de9suYNHp+wRQhMIdnXuVX8piqOwIdbYoqI2aqQis6r2p672DZUm2gs
         3XwloHvq4YrTg3wNq36EM1Ac+3ovf92RV0JIPE+C+vAtZdA5Q7Xe8XUdEhLA5Q5N1QfF
         shmTiDwC8XYNrOrNQi/qLkSkYM0BcY8Fciu14sFA2gEaD8tz18+6oM3O9/eBUwfYd0Gf
         6B30H42afOEQhvlU/HpurAov8omsrFT8lMItKRtDOtI48x/FfVgxst8Y5MwIW4GG26eG
         jUuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792233478; x=1792838278;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=MRmDjnl0l5zRiljfJEoqVKQPlK3YrtzEIxHy6EIjrqI=;
        b=ZsgBRjDgL9gNrNX33NrSUJPTWkqVwNE0v1fAbhznNOvh9kNvLCPD3Gcaf2I7eN7rGM
         Gqr+C7gBdttJiTHCM9GPOyXDozW3z7Ri4+ry5PnVk8bR768Q35/czWEuQtTB8BS8LRJP
         RnJ2EU7g/dl0qs1DkmOVipkXs6Og6RJvurONBcXm9VYwNg/DAtxJk0NxXlGlTSsRe8Wb
         I0ZQkaQLQ1Br+x2NLiuQTrw7vpFOpWcWlQ0U5zGEPUSDTy35fmvN7G+vjUwxJbDxm6Ru
         W4gBJsj5ptuJnwHG1zsbz3uVrZwywMI6aljTH2nKynXbYcb6vNQ/p73nvv1MqzbwFgkw
         PSSQ==
X-Forwarded-Encrypted: i=1; AKwUvBw+g9yTiKbyqQWyVFWUBjCRMnkZ6YV6qymfSJXm5wJTV/hmsuke9EOmrEQ6bp6deGUwOcu3AA1WcogPPuBWKQU=@vger.kernel.org
X-Gm-Message-State: AFq9FYKPoG81BlMhMfEn1Wro9ussv9So4BY56lGtWZjt2l+hal6BYn92
	tpY3hZxeFnTL7OSP1P4DZ9Zjzf4LHglKgQF8JKAlx7ZFSmGqYOJDKGLoEJUgjwGHXP61d5Ge7RE
	g4FJLrUHOv9wLVEsmEWnqNf60lRtv5CvsAKRSuAWd
X-Gm-Gg: AYBFou3+DFpK561IWktpghs6S4pAzoqQa9Hp104cYn4aHKdBTjpq5/n47/WxDpvMTFy
	/4T7tIFN0virutEYBvsNayVyC33HXsUQlOzSro6G+cNvxh7cZF9ArJiZqCzG3+vdycvlXAUqTU5
	mU7kJBfFCn9RLfm5Q4o9azVMbCAqDEO275VcB43rTko79062HLjnlXA5/Zd+hLc5UPFcZWHVuxI
	Hq8X7+0d/kbbCrlEvQhXCFXhhUog6cCZL8u+MuE+oEB5EmbABxLTdcOqz8aKfuSIqO+sOOVaLN/
	jZRJoLARGTDJWUMDhLFpuSzxdBRiL9CI+tvKRcooGh6xbjOytbNdWA+HnnlhMxU46ZfyTMhTVPj
	pOayiJGCsXaAQOzOttH20/B5xNCxZVQEA8URuh8397fhTz9OE7btndk6fVRgiVU8ohmcaZJt+vM
	LKBcgQiSJhVYX5xNN6EgjErYIlPxFz6U8N+N0/H2gO5iurCMaJ+NrYLyZojP1O1mGsmUm0omKxr
	uXh3d1YpN2lebD8rGeyh6NFWtg7Ri7EGGCrEzOgaO81nv0hqmB2KY+OpA6qWHbAQTuqtf8gnQnW
	fKrJoWzWVvWVHg==
X-Received: by 2002:a05:690e:4812:b0:677:ac49:ebc4 with SMTP id
 956f58d0204a3-679ca883777mr533948d50.67.1792233478237; Sat, 17 Oct 2026
 03:37:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261004171628.3544978-1-julius@bairaktaris.de>
In-Reply-To: <20261004171628.3544978-1-julius@bairaktaris.de>
From: Julius Bairaktaris <julius@bairaktaris.de>
Date: Sat, 17 Oct 2026 10:37:21 +0000
X-Gm-Features: AclHuK82J-XBozK4zoTEoCCy3jbA2RmbzrDB-Adm8RVieBFQXiCNHqYkufTba4U
Message-ID: <CAC1t37JvSaXzbp_spXteQojKL6EvRLLUrwvwSO5e9pcJ4cpaPQ@mail.gmail.com>
Subject: Re: [PATCH nf-next v2 0/4] netfilter: offload a TCP flow whose reply
 is never seen
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org
Cc: kadlec@netfilter.org, fw@strlen.de, coreteam@netfilter.org, 
	netdev@vger.kernel.org, geldot@protonmail.com, shuah@kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Pablo,

gentle ping on v2. Let me know if you'd like anything changed.

Thanks,
Julius


Am So., 4. Okt. 2026 um 17:16 Uhr schrieb Julius Bairaktaris
<julius@bairaktaris.de>:
>
> A router that sees only one direction of a TCP connection, because the
> reply takes another path, cannot offload it: conntrack marks the
> client's ACK after the SYN invalid, and the flowtable only takes assured
> TCP connections. The setup this comes from is two subnets on one L2
> segment, with the server answering over the shared segment.
>
> The series adds no TCP state:
> - patch 1 hands that ACK to the existing loose pickup in tcp_new(),
>   gated by nf_conntrack_tcp_loose, as if the SYN had not been seen
> - patch 2 keeps the reply direction of such a flow on the classic path
>   until the connection is assured, as act_ct does for UDP
> - patch 3 offloads the connection in the original direction and caps
>   the timeout handed back to conntrack at UNACK, as
>   nf_conntrack_tcp_packet() does
> - patch 4 adds a selftest, which fails without patches 1 to 3
>
> Pablo, on v1 you asked how TCP tracking copes without the reply
> direction, and guessed right that the goal is flowtable offload. The
> connection is tracked like a loose mid-stream pickup today: window
> checks are off in both directions, and a FIN or RST still takes the
> flow off the flowtable.
>
> This series was written with the help of an AI coding assistant. I have
> reviewed and tested it.
>
> Changes in v2:
> - patch 2: the XDP flowtable lookup does not return the held reply tuple
> - patch 3: cap the conntrack timeout at UNACK while no reply was seen
> - rebased onto nf-next
>
> v1: https://lore.kernel.org/netfilter-devel/20260910090052.2034970-1-julius@bairaktaris.de/
>
> Gary Dotzler (2):
>   netfilter: conntrack: pick up a TCP flow whose SYN was never answered
>   netfilter: nft_flow_offload: offload a TCP flow that has no reply
>
> Julius Bairaktaris (2):
>   netfilter: flowtable: promote a flow offloaded in one direction only
>   selftests: netfilter: cover a TCP flow whose reply is never seen
>
>  include/net/netfilter/nf_conntrack_l4proto.h  |  9 +++
>  net/netfilter/nf_conntrack_proto_tcp.c        | 16 ++++
>  net/netfilter/nf_flow_table_bpf.c             |  4 +
>  net/netfilter/nf_flow_table_core.c            |  5 ++
>  net/netfilter/nf_flow_table_ip.c              | 26 +++++++
>  net/netfilter/nft_flow_offload.c              |  6 +-
>  .../selftests/net/netfilter/nft_flowtable.sh  | 75 +++++++++++++++++++
>  7 files changed, 139 insertions(+), 2 deletions(-)
>
>
> base-commit: 87b80c2f6b05cad9f0ff9136709c62a0f59923e3
> --
> 2.53.0
>
