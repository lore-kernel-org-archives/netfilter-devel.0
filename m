From: Harald Welte <laforge@netfilter.org>
Subject: Re: [bug-reaport] netfilter extentions iplimit mod bugs.
Date: Wed, 16 Jul 2003 18:59:29 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030716165929.GC735@naboo>
References: <20030714112728.24bdb6aa.walteyh@sohu.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hYooF8G/hrfVAmum"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: yh <walteyh@sohu.com>
Content-Disposition: inline
In-Reply-To: <20030714112728.24bdb6aa.walteyh@sohu.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--hYooF8G/hrfVAmum
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 14, 2003 at 11:27:28AM +0800, yh wrote:
> HI guys,
>=20
> I download netfilter extentions via cvs yestoday, the iplimit code has so=
me bug, in 214 lin in linux/net/ipv4/netfilter/ipt_connlimit.c
>=20
> static struct ipt_match connlimit_match
> =3D { { NULL, NULL }, "connlimit", &match, &check, &destroy, THIS_MODULE =
};
>=20
> notic the "connlimit", it's must should be "iplimit", I don't know
> when it was changed, but the userspace tool iptable haven't changed
> yet.  so when you type "iptables -A INPUT -p tcp --syn --dport http -m
> iplimit --iplimit-above 4 -j REJECT" , the result is "Invailid
> command."..:)
>=20
> change the "connlimit" into "iplimit", recompiled kernel, it's OK now.;)

It seems like your userspace iptables is out of date.. (i.e. using an
old iptables version with a very recent patch-o-matic). The solution is
to upgrade your iptables program, rather than patching anything.

> by the way, I wan to know when the netfilter will wok will in kernel
> 2.5.* ? until 2.6 release? ( yestoday, I compiled kernel 2.5.74, build
> netfilter with in, but iptables reaport that "no 'filter' table in
> kernel".)

Well, at least with 2.5.70 and 2.5.72 (the last version I've tried) it
was working.

Did you try to recompile the iptables userspace program?

> thx all guy work for netfilter project..

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--hYooF8G/hrfVAmum
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE/FYRwXaXGVTD0i/8RAuc5AKCqu7UOOanStEpPPvcK4udm6zKKOQCePFNs
nYveuqnhRWIzrGscM5KIre8=
=6CVY
-----END PGP SIGNATURE-----

--hYooF8G/hrfVAmum--
