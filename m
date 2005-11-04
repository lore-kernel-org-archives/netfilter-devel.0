From: Harald Welte <laforge@netfilter.org>
Subject: Re: problem with conntrack-0.81
Date: Fri, 4 Nov 2005 21:39:36 +0100
Message-ID: <20051104203936.GK5594@sunbeam.de.gnumonks.org>
References: <20051026030113.8DA3F42B2@daahman.cosmicfires.com>
	<435F2D12.7050003@eurodev.net>
	<20051026112645.GJ4479@sunbeam.de.gnumonks.org>
	<436BAB3A.2030703@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LQAwcd5tHl0Qlnzi"
Cc: David Walker <david@cosmicfires.com>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
Content-Disposition: inline
In-Reply-To: <436BAB3A.2030703@eurodev.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--LQAwcd5tHl0Qlnzi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 04, 2005 at 07:40:58PM +0100, Pablo Neira wrote:

> pablo@legba:~/SVN-netfilter/trunk/homepage$ make
> make -C xml
> make[1]: Entering directory `/usr/src/SVN/trunk/homepage/xml'
> perl -I../scripts -I../../patch-o-matic-ng ../scripts/pom2docbook.pl
> --xmldir ./patch-o-matic --repository pending
> ../../patch-o-matic-ng/patchlets
> Your linux version  is unknown for patch-o-matic at
> ../scripts/pom2docbook.pl line 119
> make[1]: *** [patch-o-matic/pom-pending.xml] Error 255
> make[1]: Leaving directory `/usr/src/SVN/trunk/homepage/xml'
> make: *** [all] Error 2
>=20
> any clue on what's wrong?

it tries to execute patch-o-matic-ng, but doesn't find a linux kernel in
the default location (don't know where the default is, you'd have to
check the sources).

this is for auto-creating the xml/html pages from the patch-o-matic
tree.


> > The more important issues is, how we're going to handle signing and
> > uploading of the respective files to ftp and http server.  At the
> > moment, only the core team can sign releases (and has the respective
> > upload permissions).
>=20
> During the WS you told me that you needed someone that could do the
> releasing stuff. Well, I don't know if this could help but if you
> consider that I could that such work, what will it consist on?

well, basicaully it would mean that you'd be doing the 'make distrib',
uploading the files to the http/ftp server, updating the homepage xml,
rebuilding html from the xml, and (at least in the iptables case)
manually write the changelog based on the diff to the previous version
and the svn commit messages.

PGP/GPG signign is an issue, and currently we only have one key for the
coreteam.  Maybe we should create a separate 'release signing key' that
would be kept with the releasemaster (e.g. you).

An alternative was to wait for somebody in the netfilter project to send
you the signed released file, and you would just do the
copying/updating/rebuilding/checking/...

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--LQAwcd5tHl0Qlnzi
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDa8cIXaXGVTD0i/8RAmiEAJ94S6bOAplvMWbsymQrOpuaEPxp0ACgqIf+
m7AmnaLvm1z1C18SL1oT8Q4=
=jbWC
-----END PGP SIGNATURE-----

--LQAwcd5tHl0Qlnzi--
