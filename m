From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] pptp-conntrack for 2.6 from Mandrake
Date: Fri, 22 Oct 2004 16:06:41 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20041022140641.GE3551@sunbeam.de.gnumonks.org>
References: <cgkpp9$30j$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+E165xXSMiO4rFaE"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Laurens Blankers <laurens@blankersfamily.com>
Content-Disposition: inline
In-Reply-To: <cgkpp9$30j$1@sea.gmane.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--+E165xXSMiO4rFaE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 26, 2004 at 03:49:31PM +0200, Laurens Blankers wrote:
> Everything compiles just fine, but I haven't tested whether it works or=
=20
> not, and I am not a kernel developer so I don't know if this patch is=20
> any good.

First of all, thanks for passing on this patch.  I somehow missed your
original posting but was recently pointed at it.

Unfortunately that 'port' is way from being complete.  Thoughout the
ip_conntrack_pptp and ip_nat_pptp code there are assumptions about
linearized skbs :(

Interestingly, the ip_conntrack_proto_gre/ip_nat_proto_gre part is fixed
accordingly, so maybe this was done by two different developers?

I'm in the process of re-working that whole port, but due to it's
extensive nature I'm almost sure I'll introduce new bug(s), and thus it
will need extensive testing before going into 2.6.x mainline.

> Sincerly,
> Laurens
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--+E165xXSMiO4rFaE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFBeRPxXaXGVTD0i/8RArsGAJ91UwqkczZ9066ZKUaE1nOwRm8S3ACgkWeW
+pouzZGB8pNH2eQXDqvsPWA=
=qwOx
-----END PGP SIGNATURE-----

--+E165xXSMiO4rFaE--
