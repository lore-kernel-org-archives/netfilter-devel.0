Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.48])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2022D4C
	for <netfilter-devel@vger.kernel.org>; Tue, 28 Nov 2023 01:30:01 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
	by smtp2.kfki.hu (Postfix) with ESMTP id DFE62CC0303;
	Tue, 28 Nov 2023 10:29:56 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
	by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP; Tue, 28 Nov 2023 10:29:54 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
	by smtp2.kfki.hu (Postfix) with ESMTP id A7E30CC02FF;
	Tue, 28 Nov 2023 10:29:54 +0100 (CET)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
	id A06053431A9; Tue, 28 Nov 2023 10:29:54 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by blackhole.kfki.hu (Postfix) with ESMTP id 9E0B43431A8;
	Tue, 28 Nov 2023 10:29:54 +0100 (CET)
Date: Tue, 28 Nov 2023 10:29:54 +0100 (CET)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: =?UTF-8?B?0JzQsNGA0Log0JrQvtGA0LXQvdCx0LXRgNCz?= <socketpair@gmail.com>
cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: ipset hash:net,iface - can not add more than 64 interfaces
In-Reply-To: <CAEmTpZE=eaHE5CdFfZysXs9SZWWQqvEn56sb5ErmSjHWCpKB1w@mail.gmail.com>
Message-ID: <597e6941-7fb8-3d5-805f-8f92cbc67bcd@netfilter.org>
References: <CAEmTpZH5Kt-uBwU9be-UaS1wi-nJtoYAh78UFio_Op7j3CH6jw@mail.gmail.com> <8d4adea5-b337-cf6b-86a1-b8f8c4b410d2@netfilter.org> <CAEmTpZE=eaHE5CdFfZysXs9SZWWQqvEn56sb5ErmSjHWCpKB1w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="110363376-1322458383-1701163773=:739764"
Content-ID: <f1841254-58af-add6-18ee-55d12c5a518b@blackhole.kfki.hu>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--110363376-1322458383-1701163773=:739764
Content-Type: text/plain; charset=UTF-8
Content-ID: <e9e356af-5e24-3840-3c48-d554279d918@blackhole.kfki.hu>
Content-Transfer-Encoding: quoted-printable

On Tue, 28 Nov 2023, =D0=9C=D0=B0=D1=80=D0=BA =D0=9A=D0=BE=D1=80=D0=B5=D0=
=BD=D0=B1=D0=B5=D1=80=D0=B3 wrote:

> Is there any options to store interface indices internally (instead of=20
> names) ? i.e. if I renamed an interface, it would also =E2=80=9Crename=E2=
=80=9D in ipset=20
> (actually just listing it would resolve indices to current names). This=
=20
> feature would speed up matching ipset in network stack because it does=20
> not require resolving index to name.

No, ipset does not support storing interface indices instead of names.

Best regards,
Jozsef
=20
> =D0=B2=D1=82, 28 =D0=BD=D0=BE=D1=8F=D0=B1. 2023=E2=80=AF=D0=B3. =D0=B2 =
09:48, Jozsef Kadlecsik <kadlec@netfilter.org>:
> >
> > Hi,
> >
> > On Tue, 28 Nov 2023, =D0=9C=D0=B0=D1=80=D0=BA =D0=9A=D0=BE=D1=80=D0=B5=
=D0=BD=D0=B1=D0=B5=D1=80=D0=B3 wrote:
> >
> > > for i in `seq 0 70`; do ip link del dummy$i; done;
> > > for i in `seq 0 70`; do ip link add type dummy; done;
> > > for i in `seq 0 70`; do ipset add qwe 0.0.0.0/0,dummy$i; done;
> > >
> > > Reveals the problem. Only 64 records can be added, but there are no
> > > obvious restrictions on that. I s it possible to increase the limit=
 ?
> >
> > It is intentional. Such elements can be stored in the same hash bucke=
t
> > only and 64 is the max size I'm willing to sacrifice for that. Please
> > note, that's a huge number and means linear evaluation, i.e. loosing
> > performance.
> >
> > Best regards,
> > Jozsef
> > --
> > E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
> > PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
> > Address : Wigner Research Centre for Physics
> >           H-1525 Budapest 114, POB. 49, Hungary
>=20
>=20
>=20
> --=20
> Segmentation fault
>=20

--=20
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
--110363376-1322458383-1701163773=:739764--
