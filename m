Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Anrk3u4w"
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 169021B6;
	Tue, 28 Nov 2023 03:09:17 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id a640c23a62f3a-a00191363c1so773599466b.0;
        Tue, 28 Nov 2023 03:09:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701169756; x=1701774556; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0EI3WBxTSDNm/I0nNAceEa2Wv4W6mf89sMME+SGLXUU=;
        b=Anrk3u4wOzgf0boODrC3IctdoXjzyIoQ8jZrh7NTl9n9rfAAOwROYAEMzydfxpG2Rx
         aH8FywVKRK9DvWux6bEPMeZzB1MVBB4w8skmGxrNsM9Nls5FlU81klXrHTnepTuuCK+g
         cbRSCWnC/+J8z46wfZEIS53crHXHXhBVgYEOP++xEf8MWP3Qbdc2CfgHIQSCNsCEgVKM
         GllH5ixwJCId9musLkicsqrIMqLk8Gey4s9UG0AY+JSrF7J7JgUZR7Akac4JvNpuuJtd
         9qoksjuhrbUZ6w7O2PF9qkVtBP0kAUVzvjvWN4cDjJrYx1OmioYLdM2S78LmavSAtSGQ
         vMyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701169756; x=1701774556;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0EI3WBxTSDNm/I0nNAceEa2Wv4W6mf89sMME+SGLXUU=;
        b=Od9laNsDyMS+p35NkoDZ45DgzdtzzsynyigLYFDhBz34aOODQtfuvGFa4kMGW5dHWC
         wFKRBB6drgnkk3w64zb740tvdeoLzoI/+Lh0L9TkrmdHdSuZsRjIgDWQ1YcMv0TuVsyw
         mklqHpGQV4tnIF+Ki5fqJMk6uroU9G1ShJo4B5lbkIS08DVR6GnEGoKDqjaI4x9aVzN8
         vYfroeFm1BvLmdtMA5i7dB2oi5FQLL+L80oH7u0q08E1G4y7eulxpwGDh5ZvUzIs+KEL
         N2MV9vY2YvP3D93RC1wl78BxMnuwf2aXnXsYGw8LyiPY+ftAOUa4/+IytfFWKzWNY9hU
         jjiw==
X-Gm-Message-State: AOJu0YyRnFECq3YqH2xV2ctLvsewW3niIM4DJCcWuhF8f2JBszzu+fkj
	y1e3byMrqKKUjeOGXIqTDkBtyjETWBqsVP/TIBY=
X-Google-Smtp-Source: AGHT+IE5qzSQxu69SxC1mQML6GclaMWfkj5jWm8cXqJRi0t04gapBVoflW2woW3V5fpL8hePLtmHMfVyNB/XFPlT9Yk=
X-Received: by 2002:a17:906:1019:b0:9ff:dad:de15 with SMTP id
 25-20020a170906101900b009ff0dadde15mr9900507ejm.50.1701169755827; Tue, 28 Nov
 2023 03:09:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAEmTpZH5Kt-uBwU9be-UaS1wi-nJtoYAh78UFio_Op7j3CH6jw@mail.gmail.com>
 <8d4adea5-b337-cf6b-86a1-b8f8c4b410d2@netfilter.org> <CAEmTpZFTumZV_mbDtJP3hVaH4J2KW+vJWuFZcr4q8vsVahYf7g@mail.gmail.com>
 <1abbb38-1084-346b-d5bf-54b8164163a@netfilter.org> <CAN_K0LQJfH9D9TBMWBxnbUbgWrG5C9YYENU4tkP=WfxRGyAUMA@mail.gmail.com>
In-Reply-To: <CAN_K0LQJfH9D9TBMWBxnbUbgWrG5C9YYENU4tkP=WfxRGyAUMA@mail.gmail.com>
From: =?UTF-8?B?0JzQsNGA0Log0JrQvtGA0LXQvdCx0LXRgNCz?= <socketpair@gmail.com>
Date: Tue, 28 Nov 2023 13:09:04 +0200
Message-ID: <CAEmTpZHY61sOq+kmOwPb_kaN5_XpsCMxGeP2uzh=oPi0FaASSA@mail.gmail.com>
Subject: Re: ipset hash:net,iface - can not add more than 64 interfaces
To: Fatih USTA <fatihusta86@gmail.com>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>, 
	Netfilter Users Mailing list <netfilter@vger.kernel.org>, netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thank you for the suggestion. Will benchmark in my conditions.

=D0=B2=D1=82, 28 =D0=BD=D0=BE=D1=8F=D0=B1. 2023=E2=80=AF=D0=B3. =D0=B2 12:0=
6, Fatih USTA <fatihusta86@gmail.com>:
>
> You can use type of list. Separate 64 elements per set. After that append=
 into list.
>
> ipset create dummy_ifaces list:set
>
> ipset create dummy0_0 hash:net,iface
> ipset create dummy0_1 hash:net,iface
> ipset create dummy0_2 hash:net,iface
>
> ipset add dummy_ifaces dummy0_0
> ipset add dummy_ifaces dummy0_1
> ipset add dummy_ifaces dummy0_2
>
>
> On Tue, Nov 28, 2023, 12:34 Jozsef Kadlecsik <kadlec@netfilter.org> wrote=
:
>>
>> On Tue, 28 Nov 2023, =D0=9C=D0=B0=D1=80=D0=BA =D0=9A=D0=BE=D1=80=D0=B5=
=D0=BD=D0=B1=D0=B5=D1=80=D0=B3 wrote:
>>
>> > Actually, I need an ipset that matches against list of interfaces
>> > (without networks associated). Are there any ways ?
>>
>> No, that's not possible in ipset either.
>>
>> However, I'd suggest you to explore nftables where there are no such
>> internal limitation than in ipset, supports matching interface indices o=
r
>> names and can store just interface names/indices in an nftables set too.
>>
>> Best regards,
>> Jozsef
>> > =D0=B2=D1=82, 28 =D0=BD=D0=BE=D1=8F=D0=B1. 2023=E2=80=AF=D0=B3. =D0=B2=
 09:48, Jozsef Kadlecsik <kadlec@netfilter.org>:
>> > >
>> > > Hi,
>> > >
>> > > On Tue, 28 Nov 2023, =D0=9C=D0=B0=D1=80=D0=BA =D0=9A=D0=BE=D1=80=D0=
=B5=D0=BD=D0=B1=D0=B5=D1=80=D0=B3 wrote:
>> > >
>> > > > for i in `seq 0 70`; do ip link del dummy$i; done;
>> > > > for i in `seq 0 70`; do ip link add type dummy; done;
>> > > > for i in `seq 0 70`; do ipset add qwe 0.0.0.0/0,dummy$i; done;
>> > > >
>> > > > Reveals the problem. Only 64 records can be added, but there are n=
o
>> > > > obvious restrictions on that. I s it possible to increase the limi=
t ?
>> > >
>> > > It is intentional. Such elements can be stored in the same hash buck=
et
>> > > only and 64 is the max size I'm willing to sacrifice for that. Pleas=
e
>> > > note, that's a huge number and means linear evaluation, i.e. loosing
>> > > performance.
>> > >
>> > > Best regards,
>> > > Jozsef
>> > > --
>> > > E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
>> > > PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
>> > > Address : Wigner Research Centre for Physics
>> > >           H-1525 Budapest 114, POB. 49, Hungary
>> >
>> >
>> >
>> > --
>> > Segmentation fault
>> >
>>
>> --
>> E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
>> PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
>> Address : Wigner Research Centre for Physics
>>           H-1525 Budapest 114, POB. 49, Hungary



--=20
Segmentation fault
