From: Harald Welte <laforge@netfilter.org>
Subject: Re: Is this an ULOG error?
Date: Tue, 1 Feb 2005 14:46:07 +0100
Message-ID: <20050201134607.GN6878@sunbeam.de.gnumonks.org>
References: <41FF2188.3040300@tajik.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="X970w0TH+RQTigba"
Cc: netfilter-devel@lists.netfilter.org
To: serjio <serjio@tajik.net>
Content-Disposition: inline
In-Reply-To: <41FF2188.3040300@tajik.net>
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


--X970w0TH+RQTigba
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 01, 2005 at 11:28:24AM +0500, serjio wrote:
> Hello All,
>=20
> I would like to use ULOG and ULOGD for traffic accounting.=20

This is not what ULOG is meant for.

> But after I have installed these tools on my router I was surprised
> that I cannot check my traffic with 100% accuracy.

Please give more information, such as exact kernel version, exact ulogd
version, any patches you might be using, ...

> I think that there are some problems in transmit data via kernel socket=
=20
> to userspace.

probably.  even if your buffers are large enough - if the system
forwards more packets than it is able to ULOG, then you will have holes
in your logs.  ULOG is best-effort.

> Changing a socket network buffer size up to 4M didn't help me.
> sysctl -w net.core.rmem_max=3D8388608
> sysctl -w net.core.rmem_default=3D4194304
> sysctl -w net.core.wmem_max=3D8388608
> sysctl -w net.core.wmem_default=3D4194304

there are multiple buffers involved, please see the ulogd documentation.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--X970w0TH+RQTigba
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFB/4gfXaXGVTD0i/8RAlw3AKCE+crVtCwVpDO3Ickvf147IOoDVACePdgV
eJaJB6NjwL3QJOQQGrLhrGA=
=d3vx
-----END PGP SIGNATURE-----

--X970w0TH+RQTigba--
