From: Harald Welte <laforge@netfilter.org>
Subject: Re: buffer overflow in ip_ct_{ftp,tftp,irc}
Date: Tue, 20 Sep 2005 11:35:10 +0200
Message-ID: <20050920093510.GB31236@sunbeam.de.gnumonks.org>
References: <431F7B26.4040302@netfilter.org> <431F7C38.50206@netfilter.org>
	<432213E5.4000200@trash.net>
	<200509200711.j8K7Bw3x002184@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RnlQjJ0d97Da+TV1"
Cc: netfilter-devel@lists.netfilter.org, sbellabes@mandriva.com,
	kaber@trash.net, pablo@netfilter.org, davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Content-Disposition: inline
In-Reply-To: <200509200711.j8K7Bw3x002184@toshiba.co.jp>
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


--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 20, 2005 at 04:11:57PM +0900, Yasuyuki KOZAKAI wrote:
>=20
> From: Patrick McHardy <kaber@trash.net>
> Date: Sat, 10 Sep 2005 00:59:49 +0200
>=20
> > > -static int ports[MAX_PORTS];
> > > +static short ports[MAX_PORTS];
> > > static int ports_c;
> > > -module_param_array(ports,int, &ports_c, 0400);
> > > +module_param_array(ports, short, &ports_c, 0400);
> >=20
> > I agree, I've applied this patch instead. Thanks.
>=20
> Why don't you use u_int16_t and ushort instead of short ?

I tried this first, but the module_parm_* macros only deal with short.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--RnlQjJ0d97Da+TV1
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFDL9fOXaXGVTD0i/8RAigVAJ0aV7EnQ6VaUbo1dZLXJiMAoUPGzACgjPYf
dOPoIwXEVjn1wGkixw/Juy0=
=+T2/
-----END PGP SIGNATURE-----

--RnlQjJ0d97Da+TV1--
