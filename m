From: Alexander Samad <alex@samad.com.au>
Subject: Re: Floods
Date: Mon, 15 Mar 2004 11:34:40 +1100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040315003440.GO26800@samad.com.au>
References: <200403141930.29602.alchemyx@uznam.net.pl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zxEKvxCKojqA/Afl"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <200403141930.29602.alchemyx@uznam.net.pl>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--zxEKvxCKojqA/Afl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Mar 14, 2004 at 07:30:29PM +0100, Micha? Margula wrote:
> Hello!
>=20
> 	I have problem, quite big one. I don't know how to deal with it. Tried=
=20
> everything i know. I have a 2 x Xeon 2.66 server with 1 Gig ram. Everythi=
ng=20
> based on Intel e100 and e1000 NICs. That server is my firewall and gatewa=
y.
>=20
> I have common problem - viruses, worms and so on. It degrades server=20
> performance quite much. I am using connlimit.
>=20
> -p tcp --syn -m connlimit --connlimit-above 100 -j DROP
>=20
> It was working fine until today. I was hit by UDP flood coming from one o=
f our=20
> 100mbit networks. I found that person and disconnected, but that is not=
=20
> solution. Event "-t raw" didnt' help.
>=20
> Altough after removing ip_conntrack from kernel everything goes fine. But=
 i=20
> can't stop using conntrack, because of SNAT, DNAT and REDIRECT targets.
>=20
> What do you recommend? Unfortunately connlimit does not work with UDP pac=
kets=20
> (no wonder - UDP is conection less). What should I do? I even thought abo=
ut=20
> switch to FreeBSD (sic! :<).
What about using the rate-limit module ?

>=20
> Help, please!
>=20
> --=20
> Micha? Margula, alchemyx@uznam.net.pl, http://alchemyx.uznam.net.pl/
> "W ?yciu pi?kne s? tylko chwile" [Ryszard Riedel]
>=20
>=20

--zxEKvxCKojqA/Afl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAVPogkZz88chpJ2MRArCsAKCIyzwCKOcqFmnZywLY5jNvYbZGtwCfXLkr
dpT0yGMs95y2YxlB5/XQLFI=
=hg41
-----END PGP SIGNATURE-----

--zxEKvxCKojqA/Afl--
