From: Stephen Frost <sfrost@snowman.net>
Subject: Re: Netfilter+IPsec patches
Date: Tue, 17 Aug 2004 22:48:52 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040818024852.GD21419@ns.snowman.net>
References: <20040526033537.GH4402@samad.com.au> <40B53CCE.40704@trash.net> <20040527044613.GC24464@samad.com.au> <20040818024025.GC21419@ns.snowman.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SdoyoXCIx8sI4ZrW"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>,
        Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <20040818024025.GC21419@ns.snowman.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--SdoyoXCIx8sI4ZrW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Stephen Frost (sfrost@snowman.net) wrote:
> I've got a bunch of network cards in my gateway, in this example we're
> concerned w/ 3 of them- two connections to the internet, one internal.
> For this to work I have to have source-based routing working (which it
> used to, back when I was using 2.4).  It appears to still work fine for
> connections which are *not* NAT'd.  For connections which are NAT'd it
> goes like this:

Alright, so, tried something funny-  If I add a source-route rule for=20
the *internal* address of the machine then the source routing works (but,
unfortunately, this breaks things since that machine needs to be able to
accept connections from both internet connections).

I'm guessing this is done because of the packets are going through the=20
stack twice, but only going through the routing code once, and that's
happening prior to the NAT'ing?

Please note, these packets aren't IPSEC'd and don't have anything to do
w/ IPSEC stuff.  I'm doing some other IPSEC stuff on one of the
connections at the moment, but that's all working fine (it's on
internet1, so that may help...).

	Stephen

--SdoyoXCIx8sI4ZrW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFBIsOUrzgMPqB3kigRAiHBAJ916WmVc/JJwOmTE1HzltROQsd0rgCfQwEB
10Jl8wbJuxNFd4Gkz6hgRac=
=GrXb
-----END PGP SIGNATURE-----

--SdoyoXCIx8sI4ZrW--
