From: Harald Welte <laforge@netfilter.org>
Subject: Re: IPtables performance (fwd)
Date: Sun, 27 Apr 2003 15:02:29 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030427130229.GG990@sunbeam.de.gnumonks.org>
References: <Pine.LNX.4.44.0304221149430.24242-300000@localhost>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4fo3mGi7Q6pk/+I3"
Cc: netfilter-devel@lists.netfilter.org, Robert Olsson <robban@robtex.com>,
	John McEleney <john@netservers.co.uk>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Chris Wilson <chris@netservers.co.uk>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0304221149430.24242-300000@localhost>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--4fo3mGi7Q6pk/+I3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 22, 2003 at 12:04:26PM +0100, Chris Wilson wrote:
> Dear Sirs,
>=20
> We have been having a problem with the performance of iptables in loading
> large and complex rulesets for a long time. We have tracked it down to the
> mark_source_chains kernel function, which takes about 15 seconds to
> execute with a fairly large and complex ruleset on decent hardware.

yup, we are aware of this problem.  However, most people tend to execute
iptables 1000 times for inserting 1000 rules, which is obviously the
wrong way to do it.  This way you end up doing 1000 ruleset-loads and
1000 loop checks.  iptables-restore takes away that burden.

> We discovered Robert Olsson's patch which greatly improves the efficiency
> of this function (he claims up to 1000x, we have seen around 80x with our
> rulesets). This was last submitted to this list on 6th March 2002
> (http://lists.netfilter.org/pipermail/netfilter-devel/2002-March/006994.h=
tml).

I didn't accept his previous patches, because it didn't cover all cases,
i.e. there are loops that wouldn't have been detected by his patch.

However, the last patch seems to have changed, so I need to do some
analysis whether it would still detect all loops or not.

> Please could you let me know whether you would consider including this=20
> patch in Netfilter.

I will consider any optimization as soon as anybody can guarantee me
that it still detects all cases of loops ;)

I'll put your patch into patch-o-matic 'extra' and add a Status:
Experimental line.

> [P.S. Harald: Robert sends his regards =3D)]

thanks.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--4fo3mGi7Q6pk/+I3
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+q9TlXaXGVTD0i/8RAoJ3AJ996JAEYNNHW+6EkoLuxu1e45UhNQCfchjV
MMoFlELyeeBzeKshUwa4GgU=
=H96y
-----END PGP SIGNATURE-----

--4fo3mGi7Q6pk/+I3--
