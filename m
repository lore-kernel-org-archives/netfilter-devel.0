From: Harald Welte <laforge@netfilter.org>
Subject: Re: problem with conntrack-0.81
Date: Wed, 26 Oct 2005 13:26:45 +0200
Message-ID: <20051026112645.GJ4479@sunbeam.de.gnumonks.org>
References: <20051026030113.8DA3F42B2@daahman.cosmicfires.com>
	<435F2D12.7050003@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Enx9fNJ0XV5HaWRu"
Cc: David Walker <david@cosmicfires.com>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
Content-Disposition: inline
In-Reply-To: <435F2D12.7050003@eurodev.net>
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


--Enx9fNJ0XV5HaWRu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 26, 2005 at 09:15:30AM +0200, Pablo Neira wrote:

> I still have some things that I want to do before the first 1.0
> release, among them learning how to add new releases to the
> netfilter.org webpage, Harald? any help?

just check out the 'trunk/homepage' directory and try whether a 'make'
does in fact generate a working copy of the homepage.   The build system
works on Debian systems quite fine, you'll need xsltproc and
docbook-website.

Once that works, I suggest looking at
http://svn.netfilter.org/netfilter/trunk/homepage/xml/projects/conntrack/do=
wnloads.xml
and adding the release to the xml code.  then rebuild the page.  if
everything works fine, send me a patch, I'll apply it, rebuild and
upload the homepage.

The more important issues is, how we're going to handle signing and
uploading of the respective files to ftp and http server.  At the
moment, only the core team can sign releases (and has the respective
upload permissions).

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--Enx9fNJ0XV5HaWRu
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDX2f1XaXGVTD0i/8RAiPRAJ92ldtEUIUrI28CfOdoSo9Tfj8JmwCgo3sZ
lMjyWFPhXZSOd7H3yYmZU2c=
=BsnJ
-----END PGP SIGNATURE-----

--Enx9fNJ0XV5HaWRu--
