From: Harald Welte <laforge@netfilter.org>
Subject: Re: ipt_limit module with sun4u architectures
Date: Sat, 14 Feb 2004 21:22:27 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040214202227.GV7756@sunbeam.de.gnumonks.org>
References: <20040210184338.GA3237@primewebs.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MhP8cYafZlTESjGT"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jose Monteiro <jfmonteiro@netvisao.pt>
Content-Disposition: inline
In-Reply-To: <20040210184338.GA3237@primewebs.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--MhP8cYafZlTESjGT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 10, 2004 at 06:43:38PM +0000, Jose Monteiro wrote:
> I'm running iptables-1.2.9 on a debian/sun4u system, and not being
> able to load the limit module has become a real headache.  Is there
> any workaround for this problem?

I'm not aware of any possible workaround that would not make all 32bit
architectures require to recompile their iptables userspace :(

https://bugzilla.netfilter.org/cgi-bin/bugzilla/show_bug.cgi?id=3D94

> tia,
> Jose

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--MhP8cYafZlTESjGT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFALoODXaXGVTD0i/8RAqtDAKCpmkumrl/ZwJdRQQZ1B4FNdwFSfQCfc508
wtymhYKO+OIWw4hRalkwAfg=
=GMLJ
-----END PGP SIGNATURE-----

--MhP8cYafZlTESjGT--
