From: Harald Welte <laforge@netfilter.org>
Subject: [ANNOUNCE] New netfilter/iptables patch-o-matic release
Date: Wed, 1 Oct 2003 09:55:58 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031001075558.GR5758@sunbeam.de.gnumonks.org>
Reply-To: coreteam@netfilter.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BU7+kJFeeDlNltZg"
Cc: Netfilter Mailinglist <netfilter@lists.netfilter.org>,
	Netfilter Announcement List <netfilter-announce@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--BU7+kJFeeDlNltZg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Good news, Everyone! (TM)

The netfilter core team announces a new release of the netfilter
patch-o-matic suite:

	patch-o-matic-20030912

This release contains the most up-to-date bugfixes and new features for=20
the netfilter/iptables subsystem of the 2.4.x Linux kernel.  It supports
kernels >=3D 2.4.18

The patches are devided into several repositories.  Which ones are to be
used, depends on how conservative or adventurous the user is ;)

'submitted':
	Patches which have been submitted for kernel inclusion, most of
	which have already appeared in 2.4.22.  It's really recommended
	to always apply these. =20

'pending':
	Patches currently pending for kernel inclusion.  They will
	almost certainly appear in 2.4.23 or one of the next official
	kernel releases.

'base':
	New features which are self-contained enough so it's sure they
	don't clash with each other.  Those are safe in the way that they
	don't harm already existing functionality.  Playing with them
	might discover one or the other remaining bug... you've been
	warned.

'extra':
	New features which might cause other patches from 'extra' to
	clash with each other.  Most interestingly, you will find here
	conntrack/nat helpers for H.323, PPTP, talk/ntalk, rsh, tftp,
	mms and amanda.


Read more about the individual patches of this new patch-o-matic release
at: http://www.netfilter.org/documentation/pomlist/pom-summary.html

The new patch-o-matic release including a cryptographic GPG signature
is available for download at

	http://www.netfilter.org/downloads.html#pom-20030912


Enjoy,
	Harald (for the netfilter core team)

--=20
- Harald Welte / laforge@netfilter.org             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--BU7+kJFeeDlNltZg
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/eoiONfqJzMqajVsRAkF+AJ9QLClnvGOaM+Ei6OhGRlM+4EZZwgCgoxSg
DZJfLDow3E99aXajzJzeEfo=
=+XFb
-----END PGP SIGNATURE-----

--BU7+kJFeeDlNltZg--
