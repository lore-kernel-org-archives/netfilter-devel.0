From: Phil Dibowitz <phil@ipom.com>
Subject: Re: mss to pmtu clamping partially broken?
Date: Mon, 2 Jul 2007 11:28:50 -0700
Message-ID: <20070702182850.GB14507@ipom.com>
References: <4684E853.20900@domdv.de>
	<Pine.LNX.4.64.0706301034320.22579@fbirervta.pbzchgretzou.qr>
	<4689300C.9050802@domdv.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="i9LlY+UWpKt15+FH"
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
	netfilter-devel@lists.netfilter.org,
	Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>
To: Andreas Steinmetz <ast@domdv.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <4689300C.9050802@domdv.de>
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


--i9LlY+UWpKt15+FH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 02, 2007 at 07:04:12PM +0200, Andreas Steinmetz wrote:
> Jan Engelhardt wrote:
> > Do you really need clamping? It's a hack, since TCP should do MSS negot=
iation
> > itself. (Of course it may happen that some routers are broken.) But usu=
ally not
> > for incoming packets.
>=20
> You never know when you hit ICMP blackholes, broken routers and other
> evil things. Better safe than sorry so clamping is the way to go for me.

I encourage you to report PMTUD Blackholes to the MSS Initiative at
http://www.phildev.net/mss/

We'll notify them, and if we can't get them to fix it, blacklist them. We h=
ave
more fixed sites than blacklisted sites, so it's at least somewhat successf=
ul.

--=20
Phil Dibowitz                             phil@ipom.com
Open Source software and tech docs        Insanity Palace of Metallica
http://www.phildev.net/                   http://www.ipom.com/

"Never write it in C if you can do it in 'awk';
 Never do it in 'awk' if 'sed' can handle it;
 Never use 'sed' when 'tr' can do the job;
 Never invoke 'tr' when 'cat' is sufficient;
 Avoid using 'cat' whenever possible" -- Taylor's Laws of Programming


--i9LlY+UWpKt15+FH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGiUPiN5XoxaHnMrsRApbyAJ9azJ3vpKJCzJZLxuBYycYa+WxrMQCgpLTz
HGM+fnK1LfH8CmxIk5Nm8fU=
=4LAJ
-----END PGP SIGNATURE-----

--i9LlY+UWpKt15+FH--
