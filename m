From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] New target: DUMP
Date: Tue, 3 Jun 2003 21:10:12 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030603191012.GA12531@sunbeam.de.gnumonks.org>
References: <Pine.LNX.4.51.0306031932430.18676@dns.toxicfilms.tv>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jRHKVT23PllUwdXP"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.51.0306031932430.18676@dns.toxicfilms.tv>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--jRHKVT23PllUwdXP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 03, 2003 at 07:35:43PM +0200, Maciej Soltysiak wrote:
> Hello,

Hi!

> I wrote a target to DUMP packets in a tcpdump -x -X style:
> It supports prefixes (like LOG) and length of the packet to dump.
> This patch introduces both ipv4 and ipv6 versions.

I don't think we should put any further efforts in this direction.  Why
don't use ulogd?  It can even create pcap packet dumps, and you can do
any kind of formatting you want in userspace.  This doesn't belong int
the kernel, IMHO.

> Regards,
> Maciej
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--jRHKVT23PllUwdXP
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+3PKUXaXGVTD0i/8RAtkeAKCx/6ODOwxaSmVDkGfwHBYgTi5x0ACglk4i
nX2aiDRujtVqSoNUJ/0qWkE=
=KdOu
-----END PGP SIGNATURE-----

--jRHKVT23PllUwdXP--
