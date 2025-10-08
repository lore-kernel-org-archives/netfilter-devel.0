Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C56A92BF3CF
	for <netfilter-devel@vger.kernel.org>; Wed,  8 Oct 2025 08:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759912880; cv=none; b=Z/dHQqVhVg7/Q8HDfw/igGpG+0uyUig7uCeUlP3sd+S4uGE7cnLwHSfXOiXSXolyjRq89D5nf2KlC6FAu4UtgVbulG3P6edlcYvEDB/72RnfnlAq5qJEhsYm5nILUR/Yt7Qxpfp3LYflYLT7gNPSbTnonx4gA/o9+NKeiAKGj6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759912880; c=relaxed/simple;
	bh=TqnqvOzlaBivNMur3ACtXCiOgJtsYHP2xh/TIk97i24=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DwGA/HRGsVQ1uNGzkoC5xLkc49A6kL+rF04XIWlSYtWjlICt2Dd9uG6S57hnOLWjZizIr6i0awX6ehmWmvfoXnwooI9+VUmQhLvDhPcMF+kTKdGcsuq4jkisGiNAE0v3XSQdmTIXcO7II+5nJBoEZxh1Me8DtzAPTOVJdLuSFH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Iw8hcC2B; arc=none smtp.client-ip=209.85.166.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Iw8hcC2B"
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-42f05cbc3d1so3238595ab.0
        for <netfilter-devel@vger.kernel.org>; Wed, 08 Oct 2025 01:41:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759912878; x=1760517678; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TqnqvOzlaBivNMur3ACtXCiOgJtsYHP2xh/TIk97i24=;
        b=Iw8hcC2BOEZaSKCu5K8u6YjXUNhwd5DTkuiWjeIyyVTjnohHgIg0jST8d/6hYBHh8E
         CNYDUzU3kkcmfcy7V2oNZq/tgyg1i3d5FMVuimGXfUZBzo4oBrqeLOJDUpxrrbQU30fj
         pFBgHY+KDwOhFdEv0eZoJavKuqgrWHqm8O2B3CtailyCPhKfO2JZPUv4+uaMhynP4DEl
         ZFRD612YOKLRTGlaFRhK20lm/r9dxPw7DlewSd4vHthd2FkvNhT8hKXrR+0XwEM/Hooa
         es9U1OaXtaUYMm9CplRifxiit6yDFUu3GmH8k40CGBOScu30Bw30Ha+E2yugCix+QCna
         3J+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759912878; x=1760517678;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TqnqvOzlaBivNMur3ACtXCiOgJtsYHP2xh/TIk97i24=;
        b=r9iydSZw/DtpuS7kcnschTiizeDr1NAQ87b7Sjp3NFFQCpTqJoXkoOZqHM65v0WUli
         KEjKPWtWHI5Uz+Y5UHpHLSeolCELWl9O587ggnJMCgTs/yKCoDx8BZ8tEvZi8i2AiPRL
         wWZN30i08LbByTrR0BbCUeTMDHGMypYkvt1MU15cOGD89+RJDMV/Hw7mqU9zsGtF/Svr
         5bcHRpLrwZwRxIhSbbKaW14Pv0ZzyODDiIsW/tbpBWYzYMeEScD4pGvAz69PfdirZQav
         b4BMhMGY+bQG85f4ys6v8dHE0Qu53u6SjyAmiTTPoc+EczT2R5q/lAKRoHZ+3unD1HR1
         zxaA==
X-Gm-Message-State: AOJu0Yx81tyO/teXSgEhe2DKbeLn1Oyf4UEbL7HXK/ztmUH8WpIfSPvu
	p7GymlzHy6Snho+TQ8JPqWhZFkLJeL6p1J3EbYZquR7S6TSKokT6omnUlDA7cb3gMHmAEtbIE9I
	LHk4I7V1z5mV5C9EmPZ4TAxb0y5E0qQCYhFFKUl0=
X-Gm-Gg: ASbGncuCtqEZXdrihzDaZAEyW721FGju8MhANpbGNk4pxNjWhnMZK+itcyvKsfUcDSD
	g3qz7t23GTdc7+qs+9XNuyB4+RgNIVLD07ic1mslES8HKfnq9GpZyBYnpMvHGSZXb/G5xET0wY9
	rQCwLX4tdXdnTQ9zujTgfxskdxQ8I+kfGs+fB2c7PRuGYnw73MKQk4XwsC5Ec6pafc0pMZ6ahQ4
	jtHeDZZxb5jzf/JdRrL5E5JZv7KlDPbJ856hcK0G0YnNsHVoIza+oLKZP7eTZ+EOgUvpJNFq/8g
	xrrDKT+rET6urNzo
X-Google-Smtp-Source: AGHT+IH3B8d+7wyXHVoZm1uFs7JUfers1k4lam8qpYmyD7zAP6tWfcr8xaG5lAtgQnox+KZcdTVacun2UIt72RD5Ia8=
X-Received: by 2002:a05:6e02:12c1:b0:427:215a:93fa with SMTP id
 e9e14a558f8ab-42f7c349cd6mr82363695ab.2.1759912877649; Wed, 08 Oct 2025
 01:41:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251001211503.2120993-1-nickgarlis@gmail.com> <aOV47lZj6Quc3P0o@calendula>
In-Reply-To: <aOV47lZj6Quc3P0o@calendula>
From: Nikolaos Gkarlis <nickgarlis@gmail.com>
Date: Wed, 8 Oct 2025 10:41:05 +0200
X-Gm-Features: AS18NWCLZX_-kPhphENhQEti8MvMsWuW7HtUla9-Y1F6wjbqJM4lMu6ZC4LhztY
Message-ID: <CA+jwDR=hSYD76Z_3tdJTn6ZKkU+U9ZKESh3YUXDNHkvcDbJHsw@mail.gmail.com>
Subject: Re: [PATCH] netfilter: nfnetlink: always ACK batch end if requested
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Regarding bf2ac490d28c, I don't understand why one needs an ack for
> _BEGIN message. Maybe, an ack for END message might make sense when
> BATCH_DONE is reached so you get a confirmation that the batch has
> been fully processed, however...

_BEGIN might be excessive, but as you said, I do think _END could be
useful in the way you describe.

My assumption is that the author of 1bf2ac490d28c aims to standardize
the behavior while also allowing some flexibility in what flags are
sent. If someone tried to use those flags in a creative way that
deviates from what nft userspace expects, they might run into
difficulties handling the responses correctly.

> I suspect the author of bf2ac490d28c is making wrong assumptions on
> the number of acknowledgements that are going to be received by
> userspace.

That could very well be the case. As you said, you=E2=80=99re not always
guaranteed to receive the same number of ACKs.

I=E2=80=99m aware of the ENOBUFS error. Personally, I see it as a =E2=80=9C=
fatal=E2=80=9D or
=E2=80=9Cdelivery=E2=80=9D error, which should tell userspace that no more =
messages
are coming. Similar to EPERM which I have a test case for. It might
not be the best approach, since one could argue such errors might
also occur for individual batch commands. Still, now that I think
about it, not receiving a _BEGIN message could indicate that
the error is indeed fatal.

Receiving an error about an invalid command isn=E2=80=99t necessarily a
delivery failure (unlike ENOBUFS), and I=E2=80=99d still expect to get the
entire message back, including the ACK. Otherwise, how would userspace
know that it has read all messages and drained the buffer?

You could argue that userspace should bail on the first error it
receives, but if I=E2=80=99m not mistaken, the kernel will still send an er=
ror
for any subsequent invalid command, meaning the buffer isn=E2=80=99t being
drained again.

> Netlink is a unreliable transport protocol, there are mechanisms to
> make it "more reliable" but message loss (particularly in the
> kernel -> userspace direction) is still possible.

Is it unreliable mainly because of those corner cases, or are there
other factors to consider as well?
