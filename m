From: Harald Welte <laforge@netfilter.org>
Subject: Re: [netfilter-core] Questions
Date: Wed, 4 Jun 2003 12:25:31 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030604102531.GE14268@sunbeam.de.gnumonks.org>
References: <20030604084744.8B1F02FEAC@mta5.x263.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HCdXmnRlPgeNBad2"
Cc: "coreteam@netfilter.org" <coreteam@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: ???? <lambert@263.net>
Content-Disposition: inline
In-Reply-To: <20030604084744.8B1F02FEAC@mta5.x263.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--HCdXmnRlPgeNBad2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 04, 2003 at 04:43:26PM +0800, ???? wrote:
> My friends,
>   I have seen your document that packet filtering how-to, but I want to k=
now how to make my own filter and build it in the kernel. I know manage rul=
es using iptables tools. But how to achieve it in the kernel?=20
>   How to setup my own ipt_entry, ipt_match and ipt_target in the kernel?

Please read the list archive, this question has been asked a number of
times before.  iptables has no support for in-kernel ruleset changes. =20

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--HCdXmnRlPgeNBad2
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+3ckbXaXGVTD0i/8RAkpGAKCLS1+pM+RBGszrFTAn+GmyfaffrgCfZEMb
zuESG5JtysxTV5EsWePY4FA=
=68sJ
-----END PGP SIGNATURE-----

--HCdXmnRlPgeNBad2--
