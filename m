From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: [PATCH] Resend: Add inversion to multiport match
Date: Sat, 22 Jan 2005 20:25:39 +0100
Message-ID: <1106421939.20995.28.camel@tux.rsn.bth.se>
References: <20050122174123.GA9269@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-ACwAOw4Mlor3udFPK4mI"
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Phil Oester <kernel@linuxace.com>
In-Reply-To: <20050122174123.GA9269@linuxace.com>
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


--=-ACwAOw4Mlor3udFPK4mI
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2005-01-22 at 09:41 -0800, Phil Oester wrote:
> 2.6.11 is theoretically around the corner, and I'd
> like to get inversion added to multiport rev1.  Could
> I get an ack/nack/i'm an idiot regarding the patch below?

Patrick, could you add the kernelpart to your tree together with the
other changes that need to go into 2.6.11 ?

Phil, the userspace part only adds inverted printout to print_v1() not
to save_v1()
Either send an updated patch or I'll fix that up when applying it after
Patrick has submitted the kernel part.

--=20
/Martin

--=-ACwAOw4Mlor3udFPK4mI
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQBB8qizWm2vlfa207ERAgnnAKCk/k+Fl+Zyxd3uE3cDJjS5e4ecpACgksPJ
e1ZcLnmYcL9SneuvWFK9cFE=
=qRNE
-----END PGP SIGNATURE-----

--=-ACwAOw4Mlor3udFPK4mI--
