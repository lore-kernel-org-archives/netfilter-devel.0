From: Harald Welte <laforge@netfilter.org>
Subject: Re: About connbytes
Date: Tue, 9 Nov 2004 10:04:22 +0100
Message-ID: <20041109090422.GQ22257@sunbeam.de.gnumonks.org>
References: <419052E5.4080609@koba.com.ar>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wwtQuX191/I956S7"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "koba@koba.com.ar" <koba@koba.com.ar>
Content-Disposition: inline
In-Reply-To: <419052E5.4080609@koba.com.ar>
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


--wwtQuX191/I956S7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 09, 2004 at 02:17:25AM -0300, koba@koba.com.ar wrote:
> Hello,
> 	I've been trying to get the connbytes module working but apparently=20
> 	the CVS/SVN libipt_connbytes.c is outdated (for example it uses sinfo->f=
rom=20
> instead of sinfo->count.from). If you've been mantaining it, can you=20
> send me your latest version?

Which particular version of ipt_connbytes are you talking about?

at least the 2.6.x version from subversion appears to use 'count.from'
consistently.

I don't have anything else than current subversion.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--wwtQuX191/I956S7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD4DBQFBkIgWXaXGVTD0i/8RAgJjAJjfC7gILN7jwTVNsfFP/hIUaKjDAJ9U5Fuf
k8RiN2P4SpqJcbfwoibNLA==
=IrfL
-----END PGP SIGNATURE-----

--wwtQuX191/I956S7--
