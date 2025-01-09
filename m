Received: from mail-il1-f171.google.com (mail-il1-f171.google.com [209.85.166.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E1EC21639F
	for <netfilter-devel@vger.kernel.org>; Thu,  9 Jan 2025 10:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736418364; cv=none; b=Ip8Tzt5t3vG513WYWBqvKocMxMDZrZ888Ik6C9tWQrejqxlV/ZKGdBDfWVpNydqlaxsmcSn1Svc1vRmH+tasL5eQh8l2aCs26U0QBfAwvaBsY6zeHahJYD4K8/1NaXNxY97qe2BbswNTsZwjiLQFWtdG8PF4CUNA8+Tae2f2uas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736418364; c=relaxed/simple;
	bh=+YLcBAx4i6KECxPl5VH2RYWtwnaxnlCPtuMu5tuJbS8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PH6vZjC4KO4g62Z32NI9YFt56S3dNAEQ8smJDW2YzSnwnSwj+WJ8QCaJTz+eLGmB5rF/vqPzBX426oeGMnLI6VlDcETNalimLB5/BblZOEDFQV6gjGOIQVrLaxxxwStdtdO1s5bnDa2HhWhsGbyDPvjPM9viZWpfS9FxDfBR1EI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HLSyQ4OC; arc=none smtp.client-ip=209.85.166.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HLSyQ4OC"
Received: by mail-il1-f171.google.com with SMTP id e9e14a558f8ab-3a8146a8ddaso1922515ab.1
        for <netfilter-devel@vger.kernel.org>; Thu, 09 Jan 2025 02:26:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736418362; x=1737023162; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+YLcBAx4i6KECxPl5VH2RYWtwnaxnlCPtuMu5tuJbS8=;
        b=HLSyQ4OCko/rOM3Q80oyBuXBUmWB2Su2z4/z+RPSRQa57xwyNfYTy5PF6Gp9wtMthI
         +fdNqnEuYwcNyUw3amcOnjOTeWaU+mPh6+91/AEWoEkpAX7ew2s/QdsXATRgaduBbQcH
         H+oF8TV2Siv581b3YlGds9CCtcj/YIYOGKdA50REK94a5/90xE/8xbk6OqDzRR/9JOzq
         9fWy8WVB99J1oMP23/MylzAxi/JzWZWBE9QKjU5likOGEdGe+deknl76+iLVYa/55S2r
         6kNfdakOk6fG12gBiUvHVVxgQcd80nGsbYJlkJT7GD/4f3jf2H3W52RrZmX0mXXYDIEQ
         6gyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736418362; x=1737023162;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+YLcBAx4i6KECxPl5VH2RYWtwnaxnlCPtuMu5tuJbS8=;
        b=f8X4DG5p5wFNMoSKydnOhAqkiBufe6nKWA84ugQL3k2+LggVLBwfGJpawubdxdpSr3
         WIQFS7hciPTHhsrdLNryLlC2Ibd0QJO1uHMV9Go3jwxNP7kpXXY8s5VPFhnIoQabaiVZ
         MkiFbA6ZsDq60bu4o29Xh8b4LNRy4hB+N0jasMUb7nQp+VPZq8Fq1wPnVW+FVQEoLxaM
         bkqvUKnc497X4EwNcKoUdVadkB5r0IIMf3Jho6dhcMJ/aIPN8yLWYAdXgV9iclpjnS/a
         09W8qWIQ0Zqs5WgmQJ7/xEnOmQ9tZEBJfGZJB8w/elLUB/qgztq2qOxXFJmotBbSEknL
         y1MA==
X-Forwarded-Encrypted: i=1; AJvYcCXpqdDyXB0+k7dS9WUO+TO+Hhl+Pvi9yC7pSFSGaMFeoLSypZbT/nd9U//kmjuypsatQ/DvNmxwqgBW0NOIthc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyeW9C+XKkYsDDtr5JXWM1GM6viK/gqrIJPdyAAKrxIOMhWtQVs
	6oPxv6qs3GLmqG8ZducRP3JvqCnZ4opBugPnRWCxw3Nx+FNU/wDJ4snpCd6VkKhzcryMncwRxpf
	4OyTOEhYuyDehjYaCPqYGDQ2fm7s=
X-Gm-Gg: ASbGncunvhR9Vy/lQgm0QnhtU3GvITtWXnkwiKUHiofnUzxy8ZBk3v4Os3nGwomVPLj
	1ZqMMVlTn/tKAcqqLi2+v3wgBap6Wsm3UyBQPPw==
X-Google-Smtp-Source: AGHT+IGmFx1+u30RhVObxbPWQatRGfRc/vRG9zNERTxuZlPpgUxYeK4nOYualQg3QNiVL1wPR7o2rUwy1Jr8Ql/I7GY=
X-Received: by 2002:a05:6e02:12ef:b0:3a7:8720:9de5 with SMTP id
 e9e14a558f8ab-3ce3a9a50b3mr47976505ab.1.1736418362044; Thu, 09 Jan 2025
 02:26:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241115134612.1333-1-fw@strlen.de> <Z31OB1LLNA5AEDn1@strlen.de>
 <Z38O3LCrBRUDwUMR@calendula> <20250109003141.GA3912@breakpoint.cc>
In-Reply-To: <20250109003141.GA3912@breakpoint.cc>
From: Antonio Ojea <antonio.ojea.garcia@gmail.com>
Date: Thu, 9 Jan 2025 10:25:26 +0000
X-Gm-Features: AbW1kvZMbsp0wCQwCpVuAadIx6kE53D95tfTZKhxAAdFalgHgwM1DmQ8MNq-Ius
Message-ID: <CABhP=tYu_aOVf68x7oTua+e5r9OMmJSFy8yoWCm86=VX0c9How@mail.gmail.com>
Subject: Re: [PATCH nf-next] netfilter: conntrack: add conntrack event timestamp
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, netfilter-devel@vger.kernel.org, 
	Nadia Pinaeva <n.m.pinaeva@gmail.com>
Content-Type: text/plain; charset="UTF-8"

> I see, I did not know it was waiting on such feedback.
>
> AFAIK the patch is ok and works as expected.
>

it does, Nadia has presented the results in last kubecon, really useful feature

Thanks
