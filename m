Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.48])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE4C4C1
	for <netfilter-devel@vger.kernel.org>; Mon, 27 Nov 2023 23:48:57 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
	by smtp2.kfki.hu (Postfix) with ESMTP id D2011CC02D8;
	Tue, 28 Nov 2023 08:48:54 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
	by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP; Tue, 28 Nov 2023 08:48:52 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
	by smtp2.kfki.hu (Postfix) with ESMTP id 7D331CC02D7;
	Tue, 28 Nov 2023 08:48:52 +0100 (CET)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
	id 7629B3431A9; Tue, 28 Nov 2023 08:48:52 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by blackhole.kfki.hu (Postfix) with ESMTP id 742C33431A8;
	Tue, 28 Nov 2023 08:48:52 +0100 (CET)
Date: Tue, 28 Nov 2023 08:48:52 +0100 (CET)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: =?UTF-8?B?0JzQsNGA0Log0JrQvtGA0LXQvdCx0LXRgNCz?= <socketpair@gmail.com>
cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: ipset hash:net,iface - can not add more than 64 interfaces
In-Reply-To: <CAEmTpZH5Kt-uBwU9be-UaS1wi-nJtoYAh78UFio_Op7j3CH6jw@mail.gmail.com>
Message-ID: <8d4adea5-b337-cf6b-86a1-b8f8c4b410d2@netfilter.org>
References: <CAEmTpZH5Kt-uBwU9be-UaS1wi-nJtoYAh78UFio_Op7j3CH6jw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="110363376-1591870654-1701157567=:739764"
Content-ID: <8578253-4a4b-add7-958c-7d49c34cb449@blackhole.kfki.hu>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--110363376-1591870654-1701157567=:739764
Content-Type: text/plain; charset=UTF-8
Content-ID: <ed6d41b1-2151-83e-f6aa-cde714ffc86@blackhole.kfki.hu>
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, 28 Nov 2023, =D0=9C=D0=B0=D1=80=D0=BA =D0=9A=D0=BE=D1=80=D0=B5=D0=
=BD=D0=B1=D0=B5=D1=80=D0=B3 wrote:

> for i in `seq 0 70`; do ip link del dummy$i; done;
> for i in `seq 0 70`; do ip link add type dummy; done;
> for i in `seq 0 70`; do ipset add qwe 0.0.0.0/0,dummy$i; done;
>=20
> Reveals the problem. Only 64 records can be added, but there are no
> obvious restrictions on that. I s it possible to increase the limit ?

It is intentional. Such elements can be stored in the same hash bucket=20
only and 64 is the max size I'm willing to sacrifice for that. Please=20
note, that's a huge number and means linear evaluation, i.e. loosing=20
performance.

Best regards,
Jozsef
--=20
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
--110363376-1591870654-1701157567=:739764--
