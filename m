From: Harald Welte <laforge@netfilter.org>
Subject: Re: CLUSTERIP and ProxyARP?
Date: Mon, 27 Jun 2005 13:40:26 +0200
Message-ID: <20050627114026.GJ19928@sunbeam.de.gnumonks.org>
References: <876ef97a0506231536656b269b@mail.gmail.com>
	<20050627090959.GE19928@sunbeam.de.gnumonks.org>
	<876ef97a050627035063f5d929@mail.gmail.com>
	<876ef97a0506270411795a4c62@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8sQsHfNlXZNubEnG"
Cc: nf-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Tobias DiPasquale <codeslinger@gmail.com>
Content-Disposition: inline
In-Reply-To: <876ef97a0506270411795a4c62@mail.gmail.com>
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


--8sQsHfNlXZNubEnG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 27, 2005 at 07:11:24AM -0400, Tobias DiPasquale wrote:
> On 6/27/05, Tobias DiPasquale <codeslinger@gmail.com> wrote:
> > On 6/27/05, Harald Welte <laforge@netfilter.org> wrote:
> > > 1. all current linux kernel up to (and including 2.6.12) has a CLUSTE=
RIP bug
> > >    anyway
> >=20
> > What bug? Was it mentioned on this list earlier? I don't remember seein=
g it...
>=20
> Were you referring to the fact that, without a patch from earlier on
> this list (from Alex somebody?), CLUSTERIP won't mangle ARP requests?
> I can see that this patch didn't make it into 2.6.12.

yes, that's the bug i'm referring to.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--8sQsHfNlXZNubEnG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFCv+WqXaXGVTD0i/8RAl7TAJ0eKwsL3McfEEe897fLPbxwOfDfCACfcgP7
pgkQecdOy6bUyAmAukC4g94=
=94Pv
-----END PGP SIGNATURE-----

--8sQsHfNlXZNubEnG--
