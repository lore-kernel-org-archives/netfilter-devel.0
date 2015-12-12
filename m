From: Noel Kuntze <noel@familie-kuntze.de>
Subject: Re: Linux 4.3.1 regression: -m state returns "Protocol wrong type for
 socket"
Date: Sat, 12 Dec 2015 13:09:25 +0100
Message-ID: <566C0E75.6080800@familie-kuntze.de>
References: <n4g4s8$4pr$1@ger.gmane.org> <566BEF33.7090501@gmail.com>
 <alpine.DEB.2.10.1512121116390.13421@blackhole.kfki.hu>
 <566C09F5.6080606@gmail.com>
 <alpine.DEB.2.10.1512121259340.14295@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?UTF-8?Q?D=c3=a2niel_Fraga?= <fragabr@gmail.com>,
	netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	=?UTF-8?Q?Remzi_AKY=c3=9cZ?= <linuxliste@gmail.com>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.10.1512121259340.14295@blackhole.kfki.hu>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Hello,

> > "-m state " could not use without protocol. Therefore we must use w=
itch
> > -p tcp.
> Why should the "state" match be used with protocol? It was never requ=
ired,
> nowhere described and the match always worked without any other param=
eters
> in the rule.

Because that's wrong.
Remzi is wrong.
- -m state just accesses the conntrack states, like -m conntrack does.
It is not protocol specific. All connections, independent of the used p=
rotocol
have connection states assigned to them. They are neither protocol
specific, nor protocol exclusive.

- -m state has been deprecated for some time though.
Please try using -m conntrack instead. It offers more
functionality and is not considered deprecated.
Translation of -m state to --m conntrack:
- -m state --state foo,bar -> -m conntrack --ctstate foo,bar

- --=20

Mit freundlichen Gr=C3=BC=C3=9Fen/Kind Regards,
Noel Kuntze

GPG Key ID: 0x63EC6658
=46ingerprint: 23CA BB60 2146 05E7 7278 6592 3839 298F 63EC 6658

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWbA5zAAoJEDg5KY9j7GZY6LEQAIzah6RLIfu+4qGZTIcSRLqF
+uiAR1Vv8P3oifmoKiSWIvH54wFoJVnZoqXa+ZTLoDB6gwXyw1857Hc6ZQBhKGNh
xgrmB/XVCj+d+FwdQMoXO3ayTK3aiEGIcxqLqlLcSoKYgRHUsd6LuNRXFPVU2l3f
BsaXJefOGM+LTsLrZnLFLIfkMARFV1ihwq7qVTjsAakzzHh3wka2+708py1nBRBm
GYU7mBKKizX6kGOlVuCjDkyo8t/rB5UfAxIfCv0+pdI+oapGgdaDXpz8y836nZm9
StU5WhdW0/2dRP6Lwx8chnSffPGiHDfvWScbPw/0KvigsyrclDHgiW1nWJp+ygPB
ChullV+mdbztDqXXpTxG3lfyL7KfkJNR1lvWNd6TmZew4/2i1F2aw4hyEjuhGBgj
QhkE4bLkllBhvBTz9hNun9SkomIkZU9nDXuNR6LaouNK8TJPt3t7ccUYdxOiTpR0
Yl1kLGAfIcxfnJkMHJoRzGjhHKAULzwYJRgjLqIJvBZ6SkY5TEkIHyxGysEt4sGg
QFZQc+QQZe/LFk2MTQ9OsH/YijolA0sgr3iGZSLERdUdZ7vUF8Ss/H1L+YZU9lF3
dcpb5vrM3tC5D6KT+FIky1lqkQGoe3vsWf2R8WgLt7hO/H3GikRXpFho2+ypKkWz
fCw8TfyINXdY9/N0pSfB
=3DHfZC
-----END PGP SIGNATURE-----

