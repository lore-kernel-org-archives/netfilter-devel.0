From: Sven Schuster <schuster.sven@gmx.de>
Subject: Re: Discrete packaging of experimental modules
Date: Sun, 19 Sep 2004 00:30:35 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20040918223035.GA31093@zion.homelinux.com>
References: <0D0567C424F9F491BBAACF88@[10.169.6.246]>
	<Pine.LNX.4.61.0409181842420.17139@filer.marasystems.com>
	<BB3C25FF8798E8E693A13041@[10.0.0.4]>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="envbJBWh7q8WU6mo"
Cc: Netfilter Development <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Kenneth Porter <shiva@sewingwitch.com>
Content-Disposition: inline
In-Reply-To: <BB3C25FF8798E8E693A13041@[10.0.0.4]>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--envbJBWh7q8WU6mo
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Hi Kenneth,

On Sat, Sep 18, 2004 at 02:55:42PM -0700, Kenneth Porter told us:
> Expected, hence my question/suggestion about making the extensions=20
> dynamically loadable. For instance, it would be nice if an extension coul=
d=20
> drop its userspace into, say, /usr/libexec/netfilter/xxx.so and be=20
> instantly recognized. One could then release a kernel-matched rpm or deb=
=20
> with the kernel module and the userspace component for the extension.

thats's actually the way it works by default. The userspace extensions for
the iptables command are compiled and linked as shared libraries and loaded
at runtime, the default location is /usr/local/lib/iptables.


Sven

--=20
Linux zion 2.6.9-rc1-mm4 #1 Tue Sep 7 12:57:19 CEST 2004 i686 athlon i386 G=
NU/Linux
 00:26:22  up 6 days,  1:27,  2 users,  load average: 0.04, 0.03, 0.00

--envbJBWh7q8WU6mo
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQFBTLcLo4FAdB2PneQRAtPiAJ9ZkI0KPYfiDFGt2QPmKpNls4V2swCeNIlv
WL+BJZFPtyebRFZ95581rK8=
=RC6P
-----END PGP SIGNATURE-----

--envbJBWh7q8WU6mo--
