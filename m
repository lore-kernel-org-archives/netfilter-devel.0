From: Harald Welte <laforge@netfilter.org>
Subject: Re: Is there any document for "Packet Handling in Userspace"?
Date: Mon, 20 Jun 2005 09:27:15 +0200
Message-ID: <20050620072715.GN9491@obroa-skai.de.gnumonks.org>
References: <1119247514.5499.1.camel@cocteau.hellwolf-misty.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TN8pJM9vJMHHFgJc"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Hellwolf Misty <hellwolf@seu.edu.cn>
Content-Disposition: inline
In-Reply-To: <1119247514.5499.1.camel@cocteau.hellwolf-misty.org>
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


--TN8pJM9vJMHHFgJc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 20, 2005 at 02:05:13PM +0800, Hellwolf Misty wrote:
> netfilter-hacking-HOWTO only mentioned a little about this COOL future.

'man libipq'

NAME
       libipq - iptables userspace packet queuing library.

SYNOPSIS
	#include <linux/netfilter.h>
	#include <libipq.h>

DESCRIPTION
        libipq  is a development library for iptables userspace packet queu=
ing.


--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--TN8pJM9vJMHHFgJc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFCtm/TXaXGVTD0i/8RAhjUAKCQQYZIYQ+MKDjwKiErzZ5EacyfyACeIj/P
I3zWd204kOgVPoeDNaL27iY=
=JDKN
-----END PGP SIGNATURE-----

--TN8pJM9vJMHHFgJc--
