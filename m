Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 766DF153575
	for <netfilter-devel@vger.kernel.org>; Fri,  3 May 2024 13:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714741791; cv=none; b=mH1Rw3O+u5SRZo5ItJp9qBl9MqORxaLnHKncMpQZblhg8k+8sYR64THq+coliwqScsjkwvWypzBVeHJRpmIk1T9Ota1wIvyB/5XsTuZs8m+Xci5S/M1CYrZqcbYSRH3w8AlUgmmqzv0I1CPrKWTZt7e/3yk7l+lmgl+Tk4P9V68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714741791; c=relaxed/simple;
	bh=X6C7RF9TKaxSCUyHuqTQxYBHHbzU6Q2pKeHElNp9ing=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XXh5hhqEFw8feSKg/OpWPL1G9MC0WugtGXx6LsSGYrYKYBDrSw/+MJgH8egAAel9D+jEChzkrYqTMPBgBPqXKUDVsKWVeKvzPLCHfo6APEk86xpBjuBpCqQZWQOlnO0B6UL91wjJym/m46AmAXQCw/Wga/fuB9WWI8XXZQA8Xdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gW4SrUty; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gW4SrUty"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-418820e6effso55615e9.0
        for <netfilter-devel@vger.kernel.org>; Fri, 03 May 2024 06:09:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714741787; x=1715346587; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x4NnT8XVbTwzug7JP7Q58haNK5/UZ8F5739iOS26WfA=;
        b=gW4SrUtyIJ7kUzXZ43AGNoY1iMotjjEepos2Xqu77u7cW6VilAzmDOufu0BH4Ei1t2
         kiEIv9m7TPk5RxkL9ImtFKxx/dywmH8Vbog4fO8gSharxf/pJnf6tNCZ1bSg4m8U/au2
         qrlH0HTN4iHJ7/07iasOL+rPu6dscTckVw1ROhxjx+D4VFR2FeScAl7Z+KReWY/qnUSH
         Adb/W31Go/V0G6RRkGVJyJ8LT23Bwrnso5JZCNsZWfcEaAesL7exaGkb1DfMQ9FmwDA2
         gsz2jC7uruIGa2UbMNYjkAEttwIsFZweJ4JoCMDEbYIJUeiSJaxvbh7+15etgN1L0UnW
         336w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714741787; x=1715346587;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x4NnT8XVbTwzug7JP7Q58haNK5/UZ8F5739iOS26WfA=;
        b=fGhkjup9smaUcWNNhiVpk1mQYVD62eHK3wAYoe9KVFfBgpvM/SFa3yKBYTtHSqicaX
         WYSeT5xyL9EdAmtostxVsCvw7aalunJIjJh65Cj5829Hijiwkr1ILn43mWJ3hxGaF0U5
         r7WD/V9+FdNgBhXviuLKfdunS55HiVO/S7LWR0IyFadRdJQu7TOZGfrSTCfX0julzK7j
         gCoffZ2z+pkep0lKUxURI8SCNt+0tj/eB1mK7Uv+QfzTcVUrC+lUpgc5vfSQbc9zhpMR
         cNhA/r9G8zR5Wy3JWv4tyK/RZRPe39aIVgpQlp6sThhKPtVxBSXy7yHE3GhP5lsgJiay
         fGBw==
X-Gm-Message-State: AOJu0YyvJVV50MVm/BbGU4hoU1IDgHd5hiDlpdMGPFohBYX/v6ayTxIW
	Kev9UMVucYm89MZ+pNfBgs6jt/PHbozk24KruDQ5JmEDUUvGi0pRlLpSHje5/+Px7S7hghqD0hC
	C8aivoGECkHTUHEdrAIlS2PN0HviaiWlCebPXB+EgXAGECiRo8A==
X-Google-Smtp-Source: AGHT+IFTnPskT3jJKf+bPB0ajhPGecH3d+2qbqXYaLOimrcdyLpBfxgrr307tZ/o6hSpGpMSz5Nj+bj38rSzqHq1iCc=
X-Received: by 2002:a05:600c:3b8d:b0:41b:4c6a:de6d with SMTP id
 5b1f17b1804b1-41e1cabfeafmr1295305e9.5.1714741787351; Fri, 03 May 2024
 06:09:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240503113456.864063-1-aojea@google.com> <20240503113456.864063-2-aojea@google.com>
 <CAAdXToSN6h9vf8wSA3aQz6wU7pkuWsE5=tQ5qNRX_oQhTxNu=Q@mail.gmail.com>
In-Reply-To: <CAAdXToSN6h9vf8wSA3aQz6wU7pkuWsE5=tQ5qNRX_oQhTxNu=Q@mail.gmail.com>
From: Antonio Ojea <aojea@google.com>
Date: Fri, 3 May 2024 15:09:35 +0200
Message-ID: <CAAdXToSAHk5-h=QXQgn9yQg47=bY+ZjvU+4vfocPexMG=7GEqQ@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] netfilter: nft_queue: compute SCTP checksum
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de, pablo@netfilter.org, willemb@google.com, edumazet@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 3, 2024 at 2:46=E2=80=AFPM Antonio Ojea <aojea@google.com> wrot=
e:
>
> On Fri, May 3, 2024 at 1:35=E2=80=AFPM Antonio Ojea <aojea@google.com> wr=
ote:
> >
> > when the packet is processed with GSO and is SCTP it has to take into
> > account the SCTP checksum.
> >
> > Signed-off-by: Antonio Ojea <aojea@google.com>
> > ---
> >  net/netfilter/nfnetlink_queue.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_=
queue.c
> > index 00f4bd21c59b..428014aea396 100644
> > --- a/net/netfilter/nfnetlink_queue.c
> > +++ b/net/netfilter/nfnetlink_queue.c
> > @@ -600,6 +600,7 @@ nfqnl_build_packet_message(struct net *net, struct =
nfqnl_instance *queue,
> >         case NFQNL_COPY_PACKET:
> >                 if (!(queue->flags & NFQA_CFG_F_GSO) &&
> >                     entskb->ip_summed =3D=3D CHECKSUM_PARTIAL &&
> > +                   (skb_csum_is_sctp(entskb) && skb_crc32c_csum_help(e=
ntskb)) &&
>
> My bad, this is wrong, it should be an OR so skb_checksum_help is
> always evaluated.
> Pablo suggested in the bugzilla to use a helper, so I'm not sure this
> is the right fix, I've tried
> to look for similar solutions to find a more consistent solution but
> I'm completely new to the
> kernel codebase so some guidance will be appreciated.
>
> -                   skb_checksum_help(entskb))
> +                   ((skb_csum_is_sctp(entskb) &&
> skb_crc32c_csum_help(entskb)) ||
> +                   skb_checksum_help(entskb)))
>

... and with this patch the regression test fails, so back to square 0.
It seems I still didn't find the root cause

>                 data_len =3D READ_ONCE(queue->copy_range);
>
> >                     skb_checksum_help(entskb))
> >                         return NULL;
> >
> > --
> > 2.45.0.rc1.225.g2a3ae87e7f-goog
> >
