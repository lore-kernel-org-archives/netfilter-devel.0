From: Harald Welte <laforge@gnumonks.org>
Subject: Re: [PATCH][RFC] ipt_REJECT.c - nf_bridge source and
Date: Mon, 4 Nov 2002 09:27:57 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021104092757.C8635@sunbeam.de.gnumonks.org>
References: <20021102153451.N8635@sunbeam.de.gnumonks.org> <200211021530.EREjZ0McAA@gate.tbc.sub.de> <20021102185730.S8635@sunbeam.de.gnumonks.org> <200211022032.46007.bart.de.schuymer@pandora.be>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FgbIzWhBRCyaYU3D"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Bart De Schuymer <bart.de.schuymer@pandora.be>
Content-Disposition: inline
In-Reply-To: <200211022032.46007.bart.de.schuymer@pandora.be>; from bart.de.schuymer@pandora.be on Sat, Nov 02, 2002 at 08:32:45PM +0100
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--FgbIzWhBRCyaYU3D
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 02, 2002 at 08:32:45PM +0100, Bart De Schuymer wrote:
> Hello,
>=20
> A discussion on the Linux bridge mailing list showed the following proble=
ms:
> 1. send_reset() does a skb_copy() and doesn't yet initialize the nf_bridge
> skbuff field.

we can add that to ipt_REJECT, no problem.

> 2. send_unreach() seems to copy the wrong source IP address in the ICMP
> message. Namely, it seems to always use an IP address of the router as
> source IP address. Is that a bug?

no, this is considered to be a feature. IIRC, this has been discussed on the
list before.  The router, after all, has gereated the ICMP packet ;)

In case of NAT, the nat code will take care of replacing the IP address.

> The following patch solves both problems.

I will put the first in my list of pending patches to davem.

> cheers,
> Bart
--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--FgbIzWhBRCyaYU3D
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9xi+NXaXGVTD0i/8RAtuSAJ95j46hdDkNC/nOzsv3lYdPCmxpPQCgkF7C
hA1PO828pZLGFBBBwvqUQSg=
=QMuR
-----END PGP SIGNATURE-----

--FgbIzWhBRCyaYU3D--
