Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11622230BD5
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Dec 2025 02:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765850852; cv=none; b=JdDOiZjgeMwIBT3RCX6cShjQWrzgXoH+yyQCnFF8y8uBEb70Zic9anE/1naiKHLggnAM95dyXuLeSHGam6XEpSqV0ESn3tPflIuNg4DKYGUGu+uN94NSn6azeFxZZCi1BRRrAJkqhoFKvmFj+X+94NMuZwmksBMn9E+RqhDM87I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765850852; c=relaxed/simple;
	bh=Ua0saGAbR1O2pEFzYGaytJ4NzKP9073Kd7qDULFz/VQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=T4dpQFrNK9p0sUPqdY3PXazvPTB+RhYwHoBeIY7q8J2Pnnkw/QVtkAUSbVkjJA8HC+fJBkAmREopwBNnJGfLnAxmQrXKGWGMFeRasv7Au2pQ5oUbOJBjZXVwm/DASXlhEEYaN1wV+04P0TaG7Ne57uiEFebHVUDY0IPuhGOye3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=XLgycp6w; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="XLgycp6w"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-34c24f4dfb7so2398596a91.0
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Dec 2025 18:07:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1765850849; x=1766455649; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mPtfQYPqjPdWZ8kVEnwCAJ60ic6AA/rNavnbR5eX01A=;
        b=XLgycp6wQ00Ap4VuSX7TtCfG3AVv/ymnEOzODOEonl+dERCgDTOdJuUjH8ZyzL25Aw
         RuXM3iFjH+cZFl8hA2AgQqT7K/wwdpJ1g/x9YLkEVMMVvMW9z69PBtJGKRcrgUKGdBBo
         g2O/pJZL14RUDXC/zWxevxW0PbXP6TVOA9pigFLseZ+0OiVhtBQWzv2fX8S4wTCL/PPN
         UWpLF0qzcvS9lVC5Ws718BvYrkaqvi3aq04tylYQlOMYOC94cJp/SgAwUvrukZxK6djU
         hSHsJ/PmzCm53xKFNsDhWhxcX1clZSsBSxTedxELwGoE67SPdJTEe06Xpo0DFnJAKCIq
         NyPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765850849; x=1766455649;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mPtfQYPqjPdWZ8kVEnwCAJ60ic6AA/rNavnbR5eX01A=;
        b=i3mj5UhwZzJ6sgBqyXh+1fwxDDI/+JHavnI0Mm/xbi89jwkVDpJGJPVNfciRFQKh2G
         /zVfF+3rPaYaRO0WcEOBTtgnGFvU4kcZIaCLri+rtNknhZjn6eum79xlT6xY8/QRzxTc
         9b8Akmu505avRW/99QcKWJ7bYK256cyh3DtBRtE9bN45QIHAA+OxHVwHp5313mdNTkQt
         /Zn4SnDsr8ZmIejOTicI+x9oWWg7LMKs26qDvjC/U6hGlTOdwKcW9JMHahipTINsziui
         krfhD9LK8Sfc/4FUfHUnTtBNG/9rudd7AxLDclA4FQAx9lohtEX5iG6t8LKGbmJK68y6
         Hm7Q==
X-Forwarded-Encrypted: i=1; AJvYcCWlZxahoPCh8X7vZTrYqb6SZl0wlqHUGPr3MkiytOMXyjT70q6yW7jfWK+/Aba5nRJacaTgOYGP0ithfe+77Rs=@vger.kernel.org
X-Gm-Message-State: AOJu0YxyqMLozMpmUjM29MTvklEEsWblQ1UvuJUdA3EEC+o2+eNa9lD3
	V7rlItRLtu1BzynwiNK2LJenXp1QXvPks5o/hxovWmsi5pzFUdhwLGHZeIkk75ANLUZAwJKaR6j
	lUf3MY+r7h0XG+SsF7+6dThpJ8HlPOgkZLGqDWwxV
X-Gm-Gg: AY/fxX5TIeogZeXVPpyvToH/V2lMlYAjMg/kNpxNj1usy0m8bZz6YBk4GYdLU6zuHol
	Rg/2Rq8cJxFtP9ZmvH1JTHX8nmpzgP5XcFQU6fDynFRPb573xQ65aBwpfZdwWCXv2GC5VT5DQY8
	V+Js9XG+NRPHxd4HeSzUpSjW6lQj2tfnpzzdUYm2zLgaIocgghoYAv2w94NkPv/HXLPBAwgqwF9
	QzlZNRo0YWG2RIVjB5Jz2yKNyLAlQgkVteSYvb+wryTv5i4wgl7ylk7yIhT1HkCm+mQALQ=
X-Google-Smtp-Source: AGHT+IEXIDmB0kW/nB7MYuTz1qepAP7hKunK2rfMPdIN2Tf49FcWBr3AfwpXxP7xHCxLPxE5eckfauYq/yDFH6/gHvw=
X-Received: by 2002:a17:90b:380b:b0:340:bc27:97b8 with SMTP id
 98e67ed59e1d1-34abd7be2cdmr11050478a91.10.1765850849222; Mon, 15 Dec 2025
 18:07:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1763122537.git.rrobaina@redhat.com>
In-Reply-To: <cover.1763122537.git.rrobaina@redhat.com>
From: Paul Moore <paul@paul-moore.com>
Date: Mon, 15 Dec 2025 21:07:17 -0500
X-Gm-Features: AQt7F2qgoMQ9xayHCqwhzYseUUQuroBt3RUlmHlYaVx_WDSL9bac5aMhJ09Md5g
Message-ID: <CAHC9VhR5_wHWpSXVapFhswqnUw1x0M3SCSyD76Kad8AMi8xEeA@mail.gmail.com>
Subject: Re: [PATCH v7 0/2] audit: improve NETFILTER_PKT records
To: Ricardo Robaina <rrobaina@redhat.com>, fw@strlen.de
Cc: audit@vger.kernel.org, linux-kernel@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org, eparis@redhat.com, 
	pablo@netfilter.org, kadlec@netfilter.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 14, 2025 at 7:36=E2=80=AFAM Ricardo Robaina <rrobaina@redhat.co=
m> wrote:
>
> Currently, NETFILTER_PKT records lack source and destination
> port information, which is often valuable for troubleshooting.
> This patch series adds ports numbers, to NETFILTER_PKT records.
>
> The first patch refactors netfilter-related code, by moving
> duplicated code to audit.c, by creating audit_log_nf_skb()
> helper function.
> The second one, improves the NETFILTER_PKT records, by
> including source and destination ports for protocols of
> interest.
>
> Ricardo Robaina (2):
>   audit: add audit_log_nf_skb helper function
>   audit: include source and destination ports to NETFILTER_PKT
>
>  include/linux/audit.h    |   8 ++
>  kernel/audit.c           | 159 +++++++++++++++++++++++++++++++++++++++
>  net/netfilter/nft_log.c  |  58 +-------------
>  net/netfilter/xt_AUDIT.c |  58 +-------------
>  4 files changed, 169 insertions(+), 114 deletions(-)

Thanks Ricardo, both patches look good to me, I'm going to merge them
into audit/dev-staging just to get some very basic testing, but if I
can get an ACK from Florian on the patchset I'll go ahead and move the
patches over to audit/dev (feeds into linux-next and the next merge
window).

--=20
paul-moore.com
