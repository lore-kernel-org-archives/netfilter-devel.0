From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] connbytes match
Date: Thu, 19 Jun 2003 14:13:29 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030619121329.GJ20125@sunbeam.de.gnumonks.org>
References: <3EF05B04.8050608@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qxfKREH7IwbezJ+T"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <3EF05B04.8050608@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--qxfKREH7IwbezJ+T
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 18, 2003 at 02:28:52PM +0200, Patrick McHardy wrote:
> I'm sending this patch on behalf of Martin Devera <devik@cdi.cz>. It adds=
 a
> new match 'connbytes' which matches the transfered bytes of a connection.
> This is mostly useful for reclassifying big downloads. Martins originals=
=20
> patch
> can be found here: http://luxik.cdi.cz/~devik/connbytes (for 2.4.17).
> There have been requests for such a match from time to time, please
> consider for inclusion.

I will include it, but add a warning to the help file - since I suspect
it might affect SMP scalability of conntrack.

> Best regards,
> Patrick

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--qxfKREH7IwbezJ+T
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+8ajpXaXGVTD0i/8RAtG4AJ0ZZ1AOqiDEplK6rBXelMYcPdLMPQCeLj+0
8xfcFf1eQbKaRMRCxSBZcgA=
=0XlA
-----END PGP SIGNATURE-----

--qxfKREH7IwbezJ+T--
