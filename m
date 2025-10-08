Received: from mail-oa1-f51.google.com (mail-oa1-f51.google.com [209.85.160.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2313921B185
	for <netfilter-devel@vger.kernel.org>; Wed,  8 Oct 2025 13:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759930516; cv=none; b=lXrwXYvi1awD5r0XpwP1b2s7FhoxWe8eRHjW6o/w59Li1IlbzcDbSEMfBc8iB5k2LJu7f20qndRwZ2IRs1ZssesE3tHieGh/ptGsvf5f2ACmGUMl/9u711j9E6pLLgpy8eQUYYGol5wo0OAgyfVP9s2/a3gRZ8oEG1WLiubG08Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759930516; c=relaxed/simple;
	bh=h2e/veZ8XlPLbqDFk08JO8fyqDN0nnrpP8kFjHDK5mY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NJGYyIIr8bEt+bAxfPdcKL9mLvD5HDKOjKf/Ovh5bsXmKqQzktbPklX3FtXWOfUgZ4OGC2CUzJoWTM/CP8rPYSvFP7XdVL7sryE8pdXFFddG77i+zfIZ5OB/Wd5pABpg9VqSievfmMK76ulZ6rR+BGyj9zojZO0DhQlz6FvJtBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ksAU4ZUp; arc=none smtp.client-ip=209.85.160.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ksAU4ZUp"
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-36e4d00ebfdso2353066fac.1
        for <netfilter-devel@vger.kernel.org>; Wed, 08 Oct 2025 06:35:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759930514; x=1760535314; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Dvr21HnLDpds+rOdNJtZ3E9YZo9TWfzq3yP5tU4DZ0E=;
        b=ksAU4ZUpoBtpk1JTWEaU9/io6QFI/kZf/pjgIRdnbT44eIeLeF/gHS6ckOr/nNxuy9
         YlK3X/iisQN3EEcpPTCnmJZrGChvzc3Yl+t2s15kgX2X/VFf6juiAJSmikN/z9IAnwgh
         0PeluX5otEKiGDt+GERygUjXPA7vqDbRLfuzsuki0BWFB3plT01s2SiJY5eTbk5aWlA7
         +ykRrZxKuqGnFWnyxX0XIxgx8mGtOWYa0zPgNRTyrcOvNjIYPisSL6XWVVLCzvvEHSkE
         TDaEfzFUSJ8uLem/0tfJz/TQFKzhgRzF2ZGsJEJ8eU26a0Hj2kk5yhyMO3FEjeBAh2Lm
         Du+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759930514; x=1760535314;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Dvr21HnLDpds+rOdNJtZ3E9YZo9TWfzq3yP5tU4DZ0E=;
        b=T95S+CsmPMYkJ8cmUTqzwRww6CV9IFNVBMjH+QN7BkkfSyiIcij0DTyTtlaBGkr3kZ
         D7OefnuI4P9dG82fF+m3LbPXjuhGMcGIunaRsPfmz3SgH6r2LSBfAaJqwUU7Z1cMgA0P
         Xs3i/BTvQNVe+Yja1SSmZXCpv1lHmMahOwFhRZWVfAI7Ni57aHdvg23NHDwvBAqbMadD
         +pnea+e6w5JKbc5yopaXNfp0ezK0GYgzjMSaVuxIt1NutrluJp/pzHgjfuL7RdA2qa0Y
         qMisRr5llfyfbY8VQfQ7sQTsp58C/2JbFOs0xNtg0tPjhRw5AP/BFtYan2prToPKphS5
         pVzw==
X-Forwarded-Encrypted: i=1; AJvYcCUDERFFACSeEBROvZ/e0ZQVVISAopyVOVLgrXd4rSz66L/5uBrwWU9y2ZzaYJ8fKaPwRKzckzgYXR1dcg0lCw4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxglx4LeEcyumLbKFN5Qnkb1ORJmDpKtXHMcBRbB9zZdFN4O0AE
	pHdHt6G3GHmdUgpd+8oZxy4/SVFsDDB9xAuxMUDNnLWbFcbCKiN0md229uYGL8n9HEVhDY/eBGy
	jnenZWJE/G+kTHKVPTVCFXV4hoeUDuZniTqOz
X-Gm-Gg: ASbGncu5FSlpjU9RWhWmkSucA/f9YsTd4ouExKGcj0Ei0L6Va+2qpmz4XeXluQ/7B/8
	SpsR6dQrV+dzb+vMk7wTNLzDeIzuq2eyH9Znx/JYv7Ait/+NPMMGCR9pZyJWshfhKDD1QRgGniJ
	EUvXdOkrUldBpEBXTQrLJ18uF7oIdLfPafquLCODUN//M7XCwq9+MudC62vQTSCVgQ2qCkV7aza
	ZORjECDbyEDyHSVT5hkoTDcKlVL7EoaSf7P43x5LUlXEjy9ylmOO9paoul3
X-Google-Smtp-Source: AGHT+IGja9sTJAWV8W+gEMqCHCMDEOZC3EaghTOZDOaXCyto1Swka51ItHwS950VqLahnrRXGLF1JQD3+Q5HTCan2Yk=
X-Received: by 2002:a05:6870:d293:b0:344:d813:6d4c with SMTP id
 586e51a60fabf-3c0f51a3c86mr2049680fac.6.1759930513954; Wed, 08 Oct 2025
 06:35:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251001211503.2120993-1-nickgarlis@gmail.com>
 <aOV47lZj6Quc3P0o@calendula> <aOYSmp_RQcnfXGDw@strlen.de> <aOZMEsspSF3HBBpx@calendula>
In-Reply-To: <aOZMEsspSF3HBBpx@calendula>
From: Donald Hunter <donald.hunter@gmail.com>
Date: Wed, 8 Oct 2025 14:35:02 +0100
X-Gm-Features: AS18NWBwLDG5LAb9TtNRgVlYPcg1tsmS7jAbFDTYWG3xzqBvWSzj8B5vhhoOBNc
Message-ID: <CAD4GDZxhOZOp1uJ=V-oEnjfU2B7B4NaTSYJBj7mr=ogfPb68Jg@mail.gmail.com>
Subject: Re: [PATCH] netfilter: nfnetlink: always ACK batch end if requested
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, Nikolaos Gkarlis <nickgarlis@gmail.com>, netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 8 Oct 2025 at 12:33, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> On Wed, Oct 08, 2025 at 09:28:26AM +0200, Florian Westphal wrote:
> > [ Cc Donald Hunter ]

Thanks for the cc. I'm having difficulty catching up with the thread
of conversation, so forgive me if I miss something.

> Yes, I am inclined not to add more features to bf2ac490d28c (and
> follow up fixes patches that came with it).

Is there a problem with bf2ac490d28c or just with things that have
come after it?

> > > I suspect the author of bf2ac490d28c is making wrong assumptions on
> > > the number of acknowledgements that are going to be received by
> > > userspace.

Hopefully not. In the success case, ask for an ack, get an ack.
Without that guarantee to userspace, we'd need to extend the YNL spec
to say which messages don't honour acks.

> > > Let's just forget about this bf2ac490d28c for a moment, a quick summary:
> > >
> > > #1 If you don't set NLM_F_ACK in your netlink messages in the batch
> > >    (this is what netfilter's userspace does): then errors result in
> > >    acknowledgement. But ENOBUFS is still possible: this means your batch
> > >    has resulted in too many acknowledment messages (errors) filling up
> > >    the userspace netlink socket buffer.
> > > #2 If you set NLM_F_ACK in your netlink messages in the batch:
> > >    You get one acknowledgement for each message in the batch, with a
> > >    sufficiently large batch, this may overrun the userspace socket
> > >    buffer (ENOBUFS), then maybe the kernel was successful to fully
> > >    process the transaction but some of those acks get lost.

Are people reporting ENOBUFS because of ACKs in practice or is this theoretical?

> > Right, 1:1 relationship between messages and ACKs is only there for
> > theoretical infinite receive buffer which makes this feature rather limited
> > for batched case.
>
> Exactly.
>
> > > In this particular case, where batching several netlink messages in
> > > one single send(), userspace will not process the acknowledments
> > > messages in the userspace socket buffer until the batch is complete.
> >
> > OK, from what I gather you'd like for
> > "netfilter: nfnetlink: always ACK batch end if requested"
> > to not be applied.
>
> I think this at least needs more discussion, I think we are now
> understanding the implications of bf2ac490d28c.

Is the problem due to interplay between ACKs and ERRORs ?

I don't think anyone has successfully specified the expected behaviour
when errors get reported, namely how many acks versus how many errors
could be expected. I know that the YNL python library reports the
first error received and terminates, regardless of how many ACKs were
received.

My guess is that it should be possible to report as many errors as
were received within the receive message length before exiting but I
have not tried to implement that.

> > So, what is the 'more useful' behaviour?  Choices are all equally bad:
> >
> > 1. If we want to always include it, it might not be there due to
> >    -ENOBUFS, which will always happen if the batch was large (triggers
> >    too many acks).
>
> Yes.
>
> > 2. If we only include it on success, it might not be there for the
> >    same reason, so absence doesn't imply failure.
>
> Yes.
>
> > HOWEVER, if the batch was small enough then 2) gives slightly more
> > useable feedback in the sense that the entire batch was processed.
>
> Yes.
>
> I think Nikolaos pointed out that _BEGIN+NLM_F_ACK could actually
> provide an indication, with the assumption that the netlink userspace
> queue is going to be empty because it will be the first
> acknowledgement...
>
> > So I am leaning towards not applying the nfnetlink patch but applying
> > the (adjusted) test case.
> >
> > Other takes?

I think we should try to specify the behaviour and see if it makes
sense before layering more functionality onto what is there.

I can describe how the YNL python code sees the world, when it asks for ACKs:

1. An ack for BEGIN, cmd, cmd, ... , END in the success scenario.
2. An ack for BEGIN, cmd, cmd, ... up to the first ERROR in a failure scenario.

> Yes, I would start with this approach you propose, then keep
> discussing if it makes sense to keep extending bf2ac490d28c or leave
> it as is.
