From: Harald Welte <laforge@netfilter.org>
Subject: Re: iptables-xml userland tool and feedback
Date: Thu, 22 Jan 2004 15:40:21 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040122204021.GC10688@obroa-skai.de.gnumonks.org>
References: <400E4214.1070100@googgun.com> <40102E84.3090904@googgun.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0vzXIDBeUiKkjNJl"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Elf King <elf@googgun.com>
Content-Disposition: inline
In-Reply-To: <40102E84.3090904@googgun.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--0vzXIDBeUiKkjNJl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 22, 2004 at 03:11:48PM -0500, Elf King wrote:
> Hello Harald and all netfilter devers:
>=20
> Harald, not sure if you got a chance to see my post about an=20
> iptables-xml utility. If not have a glance at=20
> http://www.googgun.com/iptables-xml/.

yes, I read your email. unfortunately you didn't include a patch in
your email, which I could have read inline without first having to get
internet connectivity (I'm almost always travelling, currently
LinuxWorldExpo NYC) again, downloading/untarring/... something.

> Would there be interest in bundling it into the iptables userland tools?

I'm now reviewing your patch (after deleting lots of bogus CVS/* hunks).

> When you deliberate on whether or not to include a "new feature" like=20
> this into iptables do remember that while it is a _new_ feature, it=20
> isn't modifying any code of any existing tools or libraries, nor does=20
> the tool require any external libraries or components other than those=20
> required by iptables itself, it is quite standalone and production grade=
=20
> and won't interfere with any of the mainline pieces.

To be frank:
I don't think it is of much use to create yet another new format for
saving iptables rules.  This might be of interest for the future
pkttables, however.

Also, given the fact that it doesn't change any existing code, it is
quite easy for you to continue distributing it as a patch... patch hunks
shouldn't break as long as you just add new files.  Please contact
Collin (collin@gnumonks.org), who is currently re-building the links
section of www.netfilter.org.  He would certainly like to include a link
to your iptables-xml project.
=20
I would love to invite you at a later point in the pkttables development
to contribute something like pkttables-xml to the project.  However, at
the moment it is too early for starting with that work.

> Cheers,
> Ahmed.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--0vzXIDBeUiKkjNJl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQFAEDUyXaXGVTD0i/8RAmBZAJ9x8FPkQGpMWh5OMikmYomUr3V20wCfWv0O
yRzQDm4peesfCoPIrbNKIcQ=
=D/au
-----END PGP SIGNATURE-----

--0vzXIDBeUiKkjNJl--
