From: Harald Welte <laforge@netfilter.org>
Subject: Re: Call for testing: patch-o-matic-ng
Date: Thu, 1 Jan 2004 17:36:27 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040101163627.GD3530@obroa-skai.de.gnumonks.org>
References: <20031229154612.GB1417@obroa-skai.de.gnumonks.org> <Pine.LNX.4.33.0312310923090.9991-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MnLPg7ZWsaic7Fhd"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.33.0312310923090.9991-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--MnLPg7ZWsaic7Fhd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 31, 2003 at 09:51:51AM +0100, Jozsef Kadlecsik wrote:
> Unfortunately that's not so uncommon: nf-log, raw, TRACE, TCP window
> tracking patches, conntrack refcounting/locking/etc. patches, all
> conntrack/nat helpers, all targets which modify the packet.

yes, thanks for pointing this out.

> But seriously, when patch-o-matic is used in another project, that would
> be based on some software source code which would have got a version
> number. So 'kernel version' could be replaced by 'software version' above.
> And it could be implemented in Netfilter_POM.pm, without touching 'runme'
> (I think/hope).
>=20
> I believe we should avoid the structure of separated directory trees for
> the different versions of the same patch.

ok, I'll implement multiple-version support, most likely tomorrow.  Have
to think about the ideal naming convention, though.

the 'patch' file should be called 'linux.patch' anyway.  help and info
should remain the same, since the description and information is valid
for for the whole patchlet, independent of how many per-project
directories or patches exist.

a 2.6 specific patch would then be inside a linux-2.6 directory.  The
only remaining question is:

- how to encode the information 'which patch for which version' in the=20
  info file ?  We would need something like
  "if linux >=3D 2.6.0 && linux < 2.7.0, then use linux-2.6 and
  linux-2.6.patch"

- what about patchlets that have the same wholefiles but a different
  'patch' file.  I.e. a new conntrack helper that has the same source
  file, valid for 2.4 and 2.6 - but a different diff for patching
  something into conntrack_core ?

> Best regards,
> Jozsef

Happy new year, too.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--MnLPg7ZWsaic7Fhd
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/9EyKXaXGVTD0i/8RAnMxAJ4qYgDKnb2DY3YUiOvhkCail63rTQCfeQ/a
il/sELEebYUasySz5M3yU1g=
=kXqC
-----END PGP SIGNATURE-----

--MnLPg7ZWsaic7Fhd--
