From: Alexander Samad <alex@samad.com.au>
Subject: Re: [PATCH]: latest netfilter+ipsec patches
Date: Fri, 5 Mar 2004 13:13:34 +1100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040305021334.GF6414@samad.com.au>
References: <20040128103000.GP11761@sunbeam.de.gnumonks.org> <401D12B6.5030707@trash.net> <40301AB2.2030103@trash.net> <40337D63.6080602@trash.net> <20040218220337.GA3193@alpha.home.local> <40356624.6050209@trash.net> <4047AE0E.1080003@trash.net> <20040304231141.GA1782@alpha.home.local> <20040304234236.GB4995@samad.com.au> <4047DF27.6090904@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3yNHWXBV/QO9xKNm"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <4047DF27.6090904@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--3yNHWXBV/QO9xKNm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 05, 2004 at 03:00:07AM +0100, Patrick McHardy wrote:
> Alexander Samad wrote:
> >Q do I understand right that encrypted packets can or can't be acted
> >upon by the hooks in LOCAL_IN.
> >
> >Or another way of putting it does a packet travel the tables twice once
> >as an encrypted packet and once as a de crypted packet ?
>=20
> Exactly, input looks like this:
>=20
> (encrypted) PRE_ROUTING -> LOCAL_IN ->
> (plain) PRE_ROUTING -> LOCAL_IN/FORWARD
>=20
> output looks like this:
>=20
> (plain) FORWARD/LOCAL_OUT -> POST_ROUTING ->
> (encrypted) LOCAL_OUT -> POST_ROUTING
>=20
> This is the same as with freeswan, only without the ipsec
> devices, the policy match can be used as a easy replacement
> for them (-m policy --pol ipsec).
>=20
> Regards,
> Patrick

Great, i also presume this means that NAT + IPSEC is now working, will
give it a try tonight.

Thanks

>=20
> >
> >Alex
> >
> >

--3yNHWXBV/QO9xKNm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAR+JOkZz88chpJ2MRAnMcAKDMf2A0IYzOgrYl8F4mR3JM68gRGgCgrnhd
zTzOKXZgqJLQUvNeHDt18j4=
=5Qei
-----END PGP SIGNATURE-----

--3yNHWXBV/QO9xKNm--
