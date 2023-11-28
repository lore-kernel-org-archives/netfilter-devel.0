Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JrmJCnf8"
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FB1F10C3;
	Tue, 28 Nov 2023 01:18:54 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id a640c23a62f3a-a00191363c1so757118166b.0;
        Tue, 28 Nov 2023 01:18:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701163133; x=1701767933; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Do6m2izGnW5/GU09Tn/4/STOWmkE239xh/V8V1ufaD8=;
        b=JrmJCnf8fN/fmezOQEhiYUlghDUwIAp4+Q2XY/m+7z4zQhuvPIGNRQ7nLu1gZHM0cw
         R9iQFmDc2KW3RBSeyK3AR1njv4KFWScoIEpVWrhvFHkwYywPEG9JYOPh+BM7vaWtRvl3
         y+qj4eFJinxy8lshUUq4PXfigq0bZjfaxGHAKuIPZr47krTla0VQaguLxO0VY6YoKFLa
         LdHOyCT1Joi0DYSTgb1Z11aaTYx47tWLKngG9/oJpVJpgzPPR/qJi0NOtUqI2mmMxn3N
         +HLsx9jfJySF1WMRJp26b0X8tisEMqZPHL6n+bld+TU87DcFz3pSsOvV12rAARWIrSzW
         eUyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701163133; x=1701767933;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Do6m2izGnW5/GU09Tn/4/STOWmkE239xh/V8V1ufaD8=;
        b=XauhvIdksjeChK6yAwSQm3u8CbL/NMIG+BK3hVyAyYzT4t5Im1yseYRNqM5vn2zhUN
         6YiAXVZu2nPrMZxvWiQxNM08WJqFyGU4PPWqoZ/tgq+e8hZngQDMoNJ2ZYo4poho7zmd
         r5cBBHXn2+EMcegBMkQfBSI0URCdXDcIqHcZ+5/763q7ptDKQbbs8apJuSgvKJz5LTJn
         q/NIWL2QObK0DIbqqeMActQ/+ZqZLE2RW44MhKwDJAosgW9n4g5BaytaEEYnpzijoiLf
         WfRmrtq/b1EZtd0qHPo2keJfnfhaw8DQQPrPlfP9TY/VIUJZHjOHUm953GA6mU9Tmtry
         iVDQ==
X-Gm-Message-State: AOJu0Yx/sb+kdJJ53dbZRobW/j6xEQXtshfzLbsy0KAg9mEfTfPEmCCZ
	AIAgfVuSs5jfaR+rjA3p3XUKmwv12/IPhjbwR7/a+17A
X-Google-Smtp-Source: AGHT+IGotzCaahQa0MWh/QYREySy/OEVzArA54Ruexx/EalrRTK2mMdklmon0PsOxGq1WZPSW1Cn66PoIpz/rB3Hx3c=
X-Received: by 2002:a17:906:51cd:b0:9ba:a38:531e with SMTP id
 v13-20020a17090651cd00b009ba0a38531emr9193142ejk.52.1701163132775; Tue, 28
 Nov 2023 01:18:52 -0800 (PST)
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
Date: Tue, 28 Nov 2023 11:18:41 +0200
Message-ID: <CAEmTpZFTumZV_mbDtJP3hVaH4J2KW+vJWuFZcr4q8vsVahYf7g@mail.gmail.com>
Subject: Re: ipset hash:net,iface - can not add more than 64 interfaces
To: Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Actually, I need an ipset that matches against list of interfaces
(without networks associated). Are there any ways ?

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
