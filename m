From: Harald Welte <laforge@netfilter.org>
Subject: Re: Bug 50 in the bugzilla.netfilter.org
Date: Wed, 19 Feb 2003 10:55:37 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030219095537.GD11812@sunbeam.de.gnumonks.org>
References: <3E534D23.BD102A54@alcatel.be>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qa1NXTiqN6KSzHv0"
Cc: laforge@netfilter.org, georg.wild@gmx.de,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Ian.Latter@mq.edu.au
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: erik.duys@alcatel.be
Content-Disposition: inline
In-Reply-To: <3E534D23.BD102A54@alcatel.be>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--qa1NXTiqN6KSzHv0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 19, 2003 at 10:23:47AM +0100, erik.duys@alcatel.be wrote:
> Hi,
>=20
> My name is Erik Duys and I am using Linux for about 3 weeks now; of
> course I know for longer time that it exists.  I don't know the habits
> wrt to bugreports etc for Linux.  That is why I try it via this mail.

less /usr/src/linux/REPORTING-BUGS ;)

> I came across bugzilla.netfilter.org and found bug 50 reported by
> Georg.  I am also busy with the rpc.patch and I also found out that I
> get the same error as Georg.  The only difference is that I use the
> Redhat 8.0 package on a i686 machine.  RH8.0 uses iptables1.2.6 and gcc
> version 3.2 20020903 (Red Hat Linux 8.0 3.2-7) and kernel 2.4.18-14).

ok, could you pleae add a comment with exactly this data to bugzilla?
This way we see that more people are experiencing the same bug.

> By the way I applied the rpc.patch by hand (via patch -p0...) and not
> via the POM-system.  I am new to this.

cd patch-o-matic
=2E/runme extra/rpc.patch

> Sorry again for not knowing the habits.

No problem, everybody has to start at some point.

> Thank you for your time.

As the rpc patch is not something particular important (and very
experimental), please don't expect this bug fixed immediately.

> Kind regards,
> Erik
>=20
> PS: tried to contact the author of this patch but his mail-adress is not
> correct.

oops, which one? Marcelo Barbosa Lima? I think he gave up on this code
two years ago.  Ian Latter seems to have done most recent work, I've
added him to the Cc'

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--qa1NXTiqN6KSzHv0
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+U1SZXaXGVTD0i/8RAimAAJ0UbHoCSzrptwgtLtjKcjcybzCsxACfcfG9
Eaf1dEOqGagbWOwvAY4Krsk=
=h2+4
-----END PGP SIGNATURE-----

--qa1NXTiqN6KSzHv0--
