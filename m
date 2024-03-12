Received: from mail-vs1-f54.google.com (mail-vs1-f54.google.com [209.85.217.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD11D79B8E
	for <netfilter-devel@vger.kernel.org>; Tue, 12 Mar 2024 10:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710239109; cv=none; b=GMNRcIAeOApwDuTuABFc6J83jD9CP7sgpNM2eTkHR0ZYJU8RhovuqiNWmuwJcH47ZHK0P1jpvhxU/G1rhZNbgIMoa2dUUmR6WWM2OJQKOXmeT76mMNuH8J337EYTCKiTjUcWOb7cezSqDpmZsNVoaNmsNUqseMlBNF09nNa98tY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710239109; c=relaxed/simple;
	bh=aVqZIS8VxL8g39lmwHd2NXuZbZ9MsVjkzEeJZWgQbZ0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Rue2PccFOHWTaa8AYUUQnVBb9Vc0tSwLlZusJwfNkqEhRSI4tN8cgojILPmSNDZFu6XoSdhzy4fq9ZFrhrGD9y3yQIFOyzFIirZicDupX05xXZvp+EGstWR/vvWG6Dftv67j/nhwHxZdptYdbIHl95THeJEvcp+PiDpfe/f7+so=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Nw78vw0K; arc=none smtp.client-ip=209.85.217.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Nw78vw0K"
Received: by mail-vs1-f54.google.com with SMTP id ada2fe7eead31-47299367f78so1521631137.0
        for <netfilter-devel@vger.kernel.org>; Tue, 12 Mar 2024 03:25:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710239107; x=1710843907; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MllGycdv9k7GsrwSxeclljaUXreiAfVjsbTWlCPWAF8=;
        b=Nw78vw0Ky2eo8stsstPU9zxifOeOL5SaRBGQQ69xKagLAWlDlt+GFz5piA3nhi4rzw
         3kp7FPoly/BJuUDa2fdmFPUsYzECrbjjivrsHYNgb7mvNNxUFXQregWZAW2TinxaL8KU
         6ZUC4NWPR9frj6OIPGNOI1Ln7dTWRCk84zt0L1Qj+ZeF8ErCQ6ng9SjCeffd2s3Q8lxT
         J1O1yzXEjC27oAb3fmj7I/X8p3GxCkoPJ/nyl+MdiPZThGYFSw42UWkmFkRhX4OcZM2o
         kCUSg+J3d+bD4Nyvv4cw+cIq4BUbX7gA3UjosQKkjNJLMAdfdU4J60niMKMvzJcnkted
         WPvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710239107; x=1710843907;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MllGycdv9k7GsrwSxeclljaUXreiAfVjsbTWlCPWAF8=;
        b=RIr7yzHpFlJs8/HICuGXHaWOwlD4G/KTM58bm8SekLZaJS0QDRI/GI8miuZPJDL6yZ
         eEGXA1oCKJamRiTVxNIjD8uDUgznauDLkfiTfAp3zz7ppOZLKB8NEIUkz6H9J60oQnaA
         +q2msPxvQ0B6DnLx6nt+EjIUnV8sVYIavyQGPacXnoHabCtO+LB1xGPsCHAQwU4IbRTw
         aR3bW/RZKiDbjMu0Hmt0z8Hyyoh+dlPejYgY65WT1RAd6OdNXSB8mETAwQSMaNjl6nuy
         OysBd/D9bdze16+vBPopGJZWeA/gJwCDGoOu2rAhWojMRYSlHcae+M71Kj+ZDVkzs3aI
         v6ug==
X-Gm-Message-State: AOJu0Yz6hdZjuS789JXVP41kZx5vrRTn5pdg4DzBRQLLe7zZuFHjVc5N
	p8TnjSR/d94HM0cGDBk8efzTpncyA35wAqQVJ8qADROlJ418iFME9wGzygl2/FQQ8Kl9rgT34sS
	gucUJ9otol21ONyYAvL9iJqW/AnM66Buuf4I=
X-Google-Smtp-Source: AGHT+IFIxW+Ed4LWpFkon8GPbOCgR6OOiDkP9PruJCr6jLmhMEEgeZgMUzBH9d3I9TlxZTbZTGlOe1ZcEPWXuoSp6aw=
X-Received: by 2002:a05:6102:373:b0:474:b648:79e5 with SMTP id
 f19-20020a056102037300b00474b64879e5mr545281vsa.19.1710239106713; Tue, 12 Mar
 2024 03:25:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAPtndGDEJVWXcggRkw66YLjhu3QyUjJ5j4YEbvJLj-qbPkQaPg@mail.gmail.com>
 <20240308133718.GC22451@breakpoint.cc>
In-Reply-To: <20240308133718.GC22451@breakpoint.cc>
From: Sriram Rajagopalan <bglsriram@gmail.com>
Date: Tue, 12 Mar 2024 15:54:54 +0530
Message-ID: <CAPtndGCRdMbE6t8psfdkK=rGyqtYW_t0Q3BPdmSCL_08SQzmmg@mail.gmail.com>
Subject: Re: iptables-nft: Wrong payload merge of rule filter - "! --sport xx
 ! --dport xx"
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 8, 2024 at 7:07=E2=80=AFPM Florian Westphal <fw@strlen.de> wrot=
e:
>
> Sriram Rajagopalan <bglsriram@gmail.com> wrote:
> > diff --git a/src/rule.c b/src/rule.c
> > index 342c43fb..5def185d 100644
> > --- a/src/rule.c
> > +++ b/src/rule.c
> > @@ -2661,8 +2661,13 @@ static void payload_do_merge(struct stmt *sa[],
> > unsigned int n)
> >         for (j =3D 0, i =3D 1; i < n; i++) {
> >                 stmt =3D sa[i];
> >                 this =3D stmt->expr;
> > -
> > -               if (!payload_can_merge(last->left, this->left) ||
> > +               /* We should not be merging two OP_NEQs. For example -
> > +                * tcp sport !=3D 22 tcp dport !=3D 23 should not resul=
t in
> > +                * [ payload load 4b @ transport header + 0 =3D> reg 1 =
]
> > +                * [ cmp neq reg 1 0x17001600 ]
> > +                */
> > +               if (this->op =3D=3D OP_NEQ ||
> > +                   !payload_can_merge(last->left, this->left) ||
> >                     !relational_ops_match(last, this)) {
> >                         last =3D this;
> >                         j =3D i;
> >
> > Please review the patches above and provide your feedback. Please let
> > me know of any questions/clarifications.
>
>
> Probably better to do:
>
> diff --git a/src/rule.c b/src/rule.c
> --- a/src/rule.c
> +++ b/src/rule.c
> @@ -2766,7 +2766,6 @@ static void stmt_reduce(const struct rule *rule)
>                         switch (stmt->expr->op) {
>                         case OP_EQ:
>                         case OP_IMPLICIT:
> -                       case OP_NEQ:
>                                 break;
>                         default:
>                                 continue;
>

Sure, it makes sense to prevent this at the caller of
payload_do_merge(), i.e within stmt_reduce() itself.

Thanks,
Sriram
