From: Harald Welte <laforge@netfilter.org>
Subject: Re: SIP ALG and netfilter
Date: Tue, 27 Jan 2004 11:45:43 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040127104543.GE11761@sunbeam.de.gnumonks.org>
References: <20040122212258.17112.qmail@web20805.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hwvH6HDNit2nSK4j"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Siddhartha Gavirneni <siddh_g2@yahoo.com>
Content-Disposition: inline
In-Reply-To: <20040122212258.17112.qmail@web20805.mail.yahoo.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--hwvH6HDNit2nSK4j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 22, 2004 at 01:22:58PM -0800, Siddhartha Gavirneni wrote:
> Hi,
>   I am new to this list, and I am here because I would
> like to develop a SIP ALG for netfilter. And for this
> purpose, I need help from you guys.

Great.  I suppose you are talking about free software development?
=20
> Firstly, I tried searching for the SNMP ALG's source
> code, but could not find it. I would like to use that
> to understand the ALG approach for netfilter.

ip_nat_snmp.c

SNMP might not be the best example, since it only is a NAT helper, but
no conntrack helper.  Please look for ip_{conntrack,nat}_ftp.c for an
easy example... and ip_{conntrack,nat}_h323.c for a more sophisticated
one.

> Second, is there anyone else working on this? If yes,
> who is it, and can I contact those developers?

Please talk to Nikolai Dahlem <listuser@epygi.de>, he was working on
such a solution.=20

> Thank you,
> Siddharth.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--hwvH6HDNit2nSK4j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQFAFkFXXaXGVTD0i/8RAn/YAJ4zkwhBtTd+5U8CpnkmXAI5bRhqeACfbeSl
4oEwNQD4ek4nt/tvnkQaGDQ=
=mpFS
-----END PGP SIGNATURE-----

--hwvH6HDNit2nSK4j--
