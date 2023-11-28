Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ibiBUal3"
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF6BED45;
	Tue, 28 Nov 2023 01:17:58 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id a640c23a62f3a-9fffa4c4f43so709961966b.3;
        Tue, 28 Nov 2023 01:17:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701163077; x=1701767877; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DpPg7FMG+rKUt4Ybz0NCtxRLXikjQ5xiFX/F9vyOPr4=;
        b=ibiBUal3NPyPhsSXiPYtiUBam+yPMmalPz4a8KAoLzTcCPuqdWKBeUt0IV8Rl6FTTq
         0B1RBxfXwiAKM41B2PJTtHYJo97MnvqfTgNt6dEZUPOIt5gDGtqm7nq80uXKo4i40/EP
         gLyfpicYMB5p4jpxZztHAUe+bs5g4SPX62MFozCpsEfADIXM9SSJD3JkGMHdi0saQs93
         n1zMmQgKjzqtNtFY7Yqdx5Lf/omHIkzPUFrXmw+IYzrq/i+HgPb7f3VbmoIj8NhL2/t2
         KtSdg0m9mCqCPIjq9rEQ3iDy5eUoUCp+OD51DA9t4fDS72EY1ppK4/M2eN+9ft5jQa3X
         R6+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701163077; x=1701767877;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DpPg7FMG+rKUt4Ybz0NCtxRLXikjQ5xiFX/F9vyOPr4=;
        b=AbRpq8XJvHZQeEk050FQhY1m0utCs/OT307us6l0J9HoDbabANqoyoFCTeMeepP5hq
         tPIT0t9+4hzzwgioaHOD3P7G6+Ovm5nspUrFZlcvSlPDg3Hs8Vh4Io5F0cRxK0HtRyDn
         S/3PycPPEsHYMze4UTahLygXRlA4q/LKhChDX77iEYhuzvqXFb4qKjgAUssmNmvlCP3v
         e9hdfHK5iJma2mUmw70GBXgh6zT4W6BV4/C3L2uNlVQ57lxBU7sWwUhThBmNGkYkYARk
         DX+7lMeuAYRBG2UAzgzVokWq0yq+om9hxQKzGwHSqCBwsvS1YhW8wLQRaDGrTO9BMf3/
         Dizw==
X-Gm-Message-State: AOJu0YyOYRa6U5qZY2NgT5t9eXtP6eocPc2kBIPFbkSdO3mgIYvJT8Q1
	XVXCXZ7IhCh9gEymdlVDEK4d7Ak48lkzk/fqzu/SZq9X
X-Google-Smtp-Source: AGHT+IG+wWDGew302iyRKA9GEyLPKyp0JuNYtOEpn4tCzqVIji8oQi/oiqjdIbs1TCoJvXXmZqtgYxpfOK2mcCQkH54=
X-Received: by 2002:a17:906:73dc:b0:a0e:d2d:2f1c with SMTP id
 n28-20020a17090673dc00b00a0e0d2d2f1cmr4698210ejl.2.1701163076786; Tue, 28 Nov
 2023 01:17:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAEmTpZH5Kt-uBwU9be-UaS1wi-nJtoYAh78UFio_Op7j3CH6jw@mail.gmail.com>
 <8d4adea5-b337-cf6b-86a1-b8f8c4b410d2@netfilter.org>
In-Reply-To: <8d4adea5-b337-cf6b-86a1-b8f8c4b410d2@netfilter.org>
From: =?UTF-8?B?0JzQsNGA0Log0JrQvtGA0LXQvdCx0LXRgNCz?= <socketpair@gmail.com>
Date: Tue, 28 Nov 2023 11:17:45 +0200
Message-ID: <CAEmTpZE=eaHE5CdFfZysXs9SZWWQqvEn56sb5ErmSjHWCpKB1w@mail.gmail.com>
Subject: Re: ipset hash:net,iface - can not add more than 64 interfaces
To: Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Okay, got it.

Is there any options to store interface indices internally (instead of
names) ? i.e. if I renamed an interface, it would also =E2=80=9Crename=E2=
=80=9D in
ipset (actually just listing it would resolve indices to current
names). This feature would speed up matching ipset in network stack
because it does not require resolving index to name.

=D0=B2=D1=82, 28 =D0=BD=D0=BE=D1=8F=D0=B1. 2023=E2=80=AF=D0=B3. =D0=B2 09:4=
8, Jozsef Kadlecsik <kadlec@netfilter.org>:
>
> Hi,
>
> On Tue, 28 Nov 2023, =D0=9C=D0=B0=D1=80=D0=BA =D0=9A=D0=BE=D1=80=D0=B5=D0=
=BD=D0=B1=D0=B5=D1=80=D0=B3 wrote:
>
> > for i in `seq 0 70`; do ip link del dummy$i; done;
> > for i in `seq 0 70`; do ip link add type dummy; done;
> > for i in `seq 0 70`; do ipset add qwe 0.0.0.0/0,dummy$i; done;
> >
> > Reveals the problem. Only 64 records can be added, but there are no
> > obvious restrictions on that. I s it possible to increase the limit ?
>
> It is intentional. Such elements can be stored in the same hash bucket
> only and 64 is the max size I'm willing to sacrifice for that. Please
> note, that's a huge number and means linear evaluation, i.e. loosing
> performance.
>
> Best regards,
> Jozsef
> --
> E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
> PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
> Address : Wigner Research Centre for Physics
>           H-1525 Budapest 114, POB. 49, Hungary



--=20
Segmentation fault
