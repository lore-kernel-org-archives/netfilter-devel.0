From: Harald Welte <laforge@gnumonks.org>
Subject: Re: remove usage of __MOD_XXX_USAGE_COUNT and derivatives
Date: Fri, 10 Jan 2003 14:13:15 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030110131315.GS1353@sunbeam.de.gnumonks.org>
References: <3E1DEF2D.4080703@fugmann.dhs.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rQAi4ZBraoACHIeu"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Anders Fugmann <afu@fugmann.dhs.org>
Content-Disposition: inline
In-Reply-To: <3E1DEF2D.4080703@fugmann.dhs.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--rQAi4ZBraoACHIeu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 09, 2003 at 10:52:45PM +0100, Anders Fugmann wrote:
> Hi.
>=20
> Attached is a trivial patch the converts the usage of the macros=20
> __MOD_INC_USAGE_COUNT and __MOD_DEC_USAGE_COUNT to try_modules_get and=20
> module_put.

Ok, this seems to be some new 2.5.x api changes - I first need to get
familiar with this.

> Conversion enables module unloading on 2.5 kernels.
> The patch is against 2.5.55. I have only tested ipv4 functionality, and=
=20
> I see no reason that ipv6 shound not work also.

> Please examine the patch, and if ok I will send it to Linus for kernel=20
> inclusion (Unless someone on the list is the preferred person to do so -=
=20
> maybe Harald Welte?).

Patches are usually submitted to the respective maintainers (see the
MAINTAINERS file in the kernel source.=20

So if the patch is accepted (still need to look at it), I will submit it
for kernel inclusion.=20

> Regards
> Anders Fugmann
--=20
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--rQAi4ZBraoACHIeu
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+HsbrXaXGVTD0i/8RAmUAAJ41XfgseHAgEzINZ1o+crdCCFozQgCePrLS
+wZvWfoZg0VO1057MmVsC8g=
=ulxo
-----END PGP SIGNATURE-----

--rQAi4ZBraoACHIeu--
