Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C11C8286891
	for <netfilter-devel@vger.kernel.org>; Mon,  8 Dec 2025 10:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765190294; cv=none; b=oJypQr9OcptUy0HG69WIL3eI/oWD9lvFEcATLXB56hkhQtuiQ5ZrFZuGySW1xvNbhdRicLOTgvT1TsHH3cxWCkhStroTWNAaH/cWTRZEjCGYb1TsUMr/FVtABFIh+6gvhh6WFF0AORKMlTqzeZPRWquEZ9YKLjrsh9552pTcKjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765190294; c=relaxed/simple;
	bh=veqoeCg7pVkorIg9OECr4gZHueRPK5IwXUab5L1yh0s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=q/XM+wrYIG6Db2GCIkeTYHuLkZVZkXWo5y0hQSLPVuurIggqq0OEv2mv7yAkAnJnPA5kiTrL4tYYZb8DzV5mPP7c4zIVLL1j8ZV36bQN4aknmLDXBmWDFITbAuIJKYqf4Gqe24kzRdjJiU8FKUarD/l3aDqn5Las3NKSVSaPmcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com; spf=pass smtp.mailfrom=cloudflare.com; dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b=K1Xpu3+x; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b="K1Xpu3+x"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-640aa1445c3so6252536a12.1
        for <netfilter-devel@vger.kernel.org>; Mon, 08 Dec 2025 02:38:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google09082023; t=1765190291; x=1765795091; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mji8B84md8nQtZ3oth8B3djhu6SmcjWH/vP4wK2iA2U=;
        b=K1Xpu3+xtDb5gRamPSEqTnLAT4gqUwXOYjVxrAoGgais1VLvgDKx/CVQm/yUT/bdIn
         Z3pnCebi6EPcI1GWZgXTm833OX6Bj34ycCGDgMvdYp65qiHgQHq6Svi0aKhsEdNydIQS
         OwVC3npX1mlWXIolz5vpXpLfbwnIgou/jnBu6xLfQ3dNv9IKRz+qzWpEoobUhnhi1T2X
         NfwP69P6I7SW59OX5mSUevQoQ70OixXKbwt/3D4WGGfvPK9UkQhDkxtyTkuVXaDmE5ip
         CdONwPYzUonWVDkmLHrxd/7D4B20+3+GAi3ZA3te8hmuQiiswVMke2X5OtYXiwVWpGZ1
         bhNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765190291; x=1765795091;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mji8B84md8nQtZ3oth8B3djhu6SmcjWH/vP4wK2iA2U=;
        b=Y9k6Ucoes/cBUl9/7E6/YSqzxZwTxJjYlOfQgqqp/0LlqYSgUDkOxwAqM+9WOQWdp8
         VXJymXVqpN0qtenPhAAiALxHDN1J35D0QDHecgKpvM+NvnrR1/NgKdDGJ1kvyHLyWVHb
         SEqe/3NxaWB60/49srMus/hwfM9Ld8otYSWr3T8UhBxTIptWz/jRBL9n8UQI7rJi8d/5
         DfyVwagR9Gp1AEvWLP2vkyASeegtNzpF8dicLbzgWQYPITMxqP8gUN11mnsiyFvoONCT
         g6kBjcuxTg1LZLd4VYKSHbj1oUaP3KlF16o3pbLEspTYSw4s12FAowyADYHD8obxm93g
         7/oA==
X-Forwarded-Encrypted: i=1; AJvYcCVy2/HftN+Nk23vsCjkIRokL5D+XO1I9j0NCodzxrdr2KSBA59ipR7rYTg3qFxkN2LO+/3eCJp+WQsJR0tWWGg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxiImbOnnZaBwWmBCf7H3s88QBNpQWuZ80TtFNpye883+aZ1CpW
	aT6Pv5LoSGMMOLTww22EhJVo1xqrkoxv/s4BpsVWZ+RL/pelIgPGGIsKjJDcUu+7tkFS6WEpWDi
	Jba/WM5shNe6zUvxvjKaEV/gcUxX3geLl1KJLV/upt5uewXQMOWd9dZc=
X-Gm-Gg: ASbGnctipmvTc5mgW9dZhuOesElUyyznU26/CUCEx9EBItBzhtBixeQ/0r6GVqLmZKu
	oAnfu6I3NNnUidIHptGD/NDL1uXSh2UTYLAOXymUBN5b3S8vTUM0l6RQHSJpQ9ZswY6FjeOHYm6
	KGpNZoJCKSpJP8xWx3vzzWIQTxE04sweH9UEPMQrvNYXZ5cq8ajmdvy0/QrU40PFLmfNdXwvHwD
	R38Vf/yFSEp93cuy5dxnP0okmAUiXyh+q/pT59A3XnkTD/N1xOj/o8a8WwD5xTOm/OMFhYaXC9K
	0P3KNWOwQKqtPg==
X-Google-Smtp-Source: AGHT+IGxwvSUGmJHPUxT24x5fgUZGSwKKUkn5y3lOfJpm21ddF9v4ZhjA7/iaoybt5YY+uNYMcEqFB7V2eYmkQDhn0c=
X-Received: by 2002:a05:6402:518b:b0:641:3492:723d with SMTP id
 4fb4d7f45d1cf-6491a3f1ca9mr5638006a12.11.1765190284264; Mon, 08 Dec 2025
 02:38:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <176424680115.194326.6611149743733067162.stgit@firesoul>
 <176424683595.194326.16910514346485415528.stgit@firesoul> <aShi608hEPxDLvsr@strlen.de>
 <c38966ab-4a3c-4a72-a3c1-5c0301408609@kernel.org>
In-Reply-To: <c38966ab-4a3c-4a72-a3c1-5c0301408609@kernel.org>
From: Nick Wood <nwood@cloudflare.com>
Date: Mon, 8 Dec 2025 10:37:48 +0000
X-Gm-Features: AQt7F2rlo4k5DLNhf8oqS3gglGN7Mr-5s6gZckXxXt0yQO5Qc7Cgj73Tf-EJfGI
Message-ID: <CACrpuLQGj70xCi8wDH4HeKzkA=d-9+eOYkkQ47M2Tw8MA65kzQ@mail.gmail.com>
Subject: Re: [PATCH nf-next RFC 1/3] xt_statistic: taking GRO/GSO into account
 for nth-match
To: Jesper Dangaard Brouer <hawk@kernel.org>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org, 
	Pablo Neira Ayuso <pablo@netfilter.org>, netdev@vger.kernel.org, phil@nwl.cc, 
	Eric Dumazet <eric.dumazet@gmail.com>, "David S. Miller" <davem@davemloft.net>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, kernel-team@cloudflare.com, 
	mfleming@cloudflare.com, matt@readmodwrite.com, aforster@cloudflare.com
Content-Type: text/plain; charset="UTF-8"

On Fri, 5 Dec 2025 at 16:23, Jesper Dangaard Brouer <hawk@kernel.org> wrote:

> > So the existing algorithm works correctly even when considering
> > aggregation because on average the correct amount of segments gets
> > matched (logged).
> >
>
> No, this is where the "on average" assumption fails.  Packets with many
> segments gets statistically under-represented. As far as I'm told people
> noticed that the bandwidth estimate based on sampled packets were too
> far off (from other correlating stats like interface stats).

On-average is technically correct here; the issue is more subtle than
simple undercounting. To understand, consider a 50pps flow (without
GRO/GSO) with a sampling rate of 1/100. With 1 in k sampling we take a
sample every other second, and to estimate total flow we multiply by
the sample rate so we get a sawtooth looking wave that alternates
between 100pps and 0 every second. This is not 'correct', it's an
estimate as we'd expect, the absolute error here alternates between
+/-50 with the same frequency.

Now let's encapsulate these 50pps in a single GSO packet every second,
with 1-in-k is sampling on an all or nothing basis. For 99 seconds out
of every hundred we sample no packets -this is the under-sampling
you're referencing. But, for 1 second in 100 we sample the whole
GRO/GSO, and capture 50 samples. Causing our pps estimate for that
instant spikes to 5,000pps - so for an instant our absolute error
spikes by 2 orders of magnitude ('true' pps is 50 remember).

If you average the single spike into the 99 seconds of undersampling,
the figures do 'average out', but for very short flows this
amplification of error makes it impossible to accurately estimate the
true packet rate.
>
> I'm told (Cc Nick Wood) the statistically correct way with --probability
> setting would be doing a Bernoulli trial[1] or a "binomial experiment".
>   This is how our userspace code (that gets all GRO/GSO packets) does
> statistical sampling based on the number of segments (to get the correct
> statistical probability):
>
> The Rust code does this:
>   let probability = 1.0 / sample_interval as f64;
>   let adjusted_probability = nr_packets * probability * (1.0 -
> probability).powf(nr_packets - 1.0);
>
>   [1] https://en.wikipedia.org/wiki/Bernoulli_trial
>
> We could (also) update the kernel code for --probability to do this, but
> as you can see the Rust code uses floating point calculations.
>
> It was easier to change the nth code (and easier for me to reason about)
> than dealing with converting the the formula to use an integer
> approximation (given we don't have floating point calc in kernel).

with s = integer sample rate (i.e s=100 if we're sampling 1/100)
and n = nr_packets:

sample_threshold = [ 2**32 //s //s ] * [n*(s - (n-1))] ;

if get_random_u32 < sample_threshold {
    sample_single_subpacket
}*

Is an equivalent integer calculation for a Bernoulli trial treatment.
It undersamples by about 1 in 1/100k for s=100 and n=50 which is good
enough for most purposes. Error is smaller for smaller n. For smaller
s it may warrant an additional (cubic) term in n
*I'm a mathematician, not a kernel developer


> > With this proposed new algo, we can now match 100% of skbs / aggregated
> > segments, even for something like '--every 10'.  And that seems fishy to
> > me.
> >
> > As far as I understood its only 'more correct' in your case because the
> > logging backend picks one individual segment out from the NFLOG'd
> > superpacket.
> >
> > But if it would NOT do that, then you now sample (almost) all segments
> > seen on wire.  Did I misunderstand something here?
>
> See above explanation about Bernoulli trial[1].
>
> --Jesper
>
