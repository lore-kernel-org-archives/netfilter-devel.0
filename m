From: Harald Welte <laforge@netfilter.org>
Subject: Re: the performance of big packets on Giga system
Date: Mon, 22 Dec 2003 11:54:25 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031222105425.GI5058@obroa-skai.de.gnumonks.org>
References: <200312221309281.SM00864@zhengcb>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ik0NlRzMGhMnxrMX"
Cc: "netfilter-devel@lists.netfilter.org" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: zhengchuanbo <zhengcb@netpower.com.cn>
Content-Disposition: inline
In-Reply-To: <200312221309281.SM00864@zhengcb>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--ik0NlRzMGhMnxrMX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 22, 2003 at 01:21:06PM +0800, zhengchuanbo wrote:
>=20
> I'm curious on the performance of big packets forwarding on Giga system.
> Our system could forward 580kpps for 64byte packets. As the line rate of=
=20
> 1518byte packets is similar to 80kpps,I supposed we could get line rate
> forwarding for 1518byte packets.

first, this does seem to be a question about packet forwarding
(routing), not about packet filtering.  Thus you are on the wrong
mailinglist, please ask the netdev list instead.

second, you don't mention a single detail about your setup.  No
indication of kernel version, which hardware (cpu, memory, what kind of
pci bus, which ethernet chips), which drivers, etc.

I can assure you that there is quite a number of people doing 400kpps on
less-than-modern hardware.

> regards,
> Jack Zheng
> zhengcb@netpower.com.cn

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--ik0NlRzMGhMnxrMX
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/5s1hXaXGVTD0i/8RAvveAJ9eI72vgj8O5OH7kPpEMHnElTJdEQCfY6jw
Cz/XkACxMHlwDO2PnLIVH2g=
=20WP
-----END PGP SIGNATURE-----

--ik0NlRzMGhMnxrMX--
