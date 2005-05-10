From: Harald Welte <laforge@netfilter.org>
Subject: Re: [RFC] alternative to conntrack ID
Date: Tue, 10 May 2005 08:49:36 +0200
Message-ID: <20050510064936.GQ30482@sunbeam.de.gnumonks.org>
References: <20050429080242.GJ9735@sunbeam.de.gnumonks.org>
	<42789366.20702@ufomechanic.net> <4278B23A.7050406@trash.net>
	<4278B98E.7090707@ufomechanic.net> <427B8A46.8090006@trash.net>
	<427D26E7.8060701@ingate.com> <427D3EAF.3020200@trash.net>
	<427D41FA.5080506@ingate.com>
	<1115648236.25627.17.camel@nienna.balabit>
	<427F7D01.1090206@ufomechanic.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SZWGMWEqiICyNBuC"
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Pablo Neira <pablo@eurodev.net>, Marcus Sundberg <marcus@ingate.com>,
	KOVACS Krisztian <hidden@balabit.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Amin Azez <azez@ufomechanic.net>
Content-Disposition: inline
In-Reply-To: <427F7D01.1090206@ufomechanic.net>
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


--SZWGMWEqiICyNBuC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 09, 2005 at 04:08:49PM +0100, Amin Azez wrote:

> The time struct used in skb's has time and microtime.

If you're referring to the skb receive timestamp:  That doesn't exist
for locally-generated packet, and on 'real' incoming pcakets from the
network it doesn't exist by default unless some application (such as
tcpdump) requests it.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--SZWGMWEqiICyNBuC
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (GNU/Linux)

iD8DBQFCgFmAXaXGVTD0i/8RAmrZAJ9lnfxXIoYyq3rA4OhKa4x9i/xJ9ACgsZDZ
4KJIZYEU1/Ah3lAFq9sV3IA=
=S/xm
-----END PGP SIGNATURE-----

--SZWGMWEqiICyNBuC--
