From: Harald Welte <laforge@netfilter.org>
Subject: Re: Sparc64, Kernel 2.6 and iptables
Date: Sun, 5 Oct 2003 13:51:06 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031005115106.GY5758@sunbeam.de.gnumonks.org>
References: <3F729BFE.7040702@triaton-webhosting.com> <20031002195500.GC5758@sunbeam.de.gnumonks.org> <3F7EF645.5080806@triaton-webhosting.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="r3ueNplNBnzMaJE3"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Georg Chini <georg.chini@triaton-webhosting.com>
Content-Disposition: inline
In-Reply-To: <3F7EF645.5080806@triaton-webhosting.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--r3ueNplNBnzMaJE3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 04, 2003 at 06:33:09PM +0200, Georg Chini wrote:
> Hello,
>=20
> thanks for your reply. Would it help if I give you
> access to a sparc64 box? Or do you have any idea what
> I could do to track down the problem? Including netfilter debug
> in the configuration did not change anything, I still do
> not get any messages. I tested it with 2.6.0-test6-bk6.

mh.  Since you don't even get an Oops message, it's hard to track... and
remote debugging (even with a serial console) is very inconvenient due
to the latency, etc.

I've just bought another Ultra5, I expect it to arrive within the next
week.

> Regards
>        Georg Chini

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--r3ueNplNBnzMaJE3
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/gAWqXaXGVTD0i/8RAgsvAJ9x5705RpGw+SMx8gGa5NLjif6KAQCfdN+k
iu8KfEEbCI2nIydXL39b0Rk=
=PVkB
-----END PGP SIGNATURE-----

--r3ueNplNBnzMaJE3--
