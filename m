From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: [ANNOUNCE] Release of iptables-1.3.0rc1
Date: Wed, 02 Feb 2005 20:20:26 +0100
Message-ID: <1107372027.17789.12.camel@tux.rsn.bth.se>
References: <20050202154449.GA30465@linuxace.com>
	<20050202160444.GC30465@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-tc9t3fRs6TVlw1BjuPF4"
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
To: Phil Oester <kernel@linuxace.com>
In-Reply-To: <20050202160444.GC30465@linuxace.com>
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


--=-tc9t3fRs6TVlw1BjuPF4
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2005-02-02 at 08:04 -0800, Phil Oester wrote:
> On Wed, Feb 02, 2005 at 07:44:49AM -0800, Phil Oester wrote:
> > > The netfilter coreteam proudly presents:
> > >	iptables version 1.3.0rc1
> >=20
> > One note: the userspace side of multiport inversion has not yet
> > been merged (while the kernel side has).
> >=20
> > Phil
>=20
> Err...included again here for easy patching :)

Sorry for forgetting, will be in 1.3.0

Sending        iptables/extensions/libipt_multiport.c
Sending        iptables/include/linux/netfilter_ipv4/ipt_multiport.h
Transmitting file data ..
Committed revision 3651.

--=20
/Martin

--=-tc9t3fRs6TVlw1BjuPF4
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQBCASf6Wm2vlfa207ERAlR1AKCDCcDDitnhaPaoWPI0vKmA7syM5QCeKKc/
VsIGjWhtQzx1byCIUlmMIrM=
=pCx9
-----END PGP SIGNATURE-----

--=-tc9t3fRs6TVlw1BjuPF4--
