From: Harald Welte <laforge@netfilter.org>
Subject: Re: Problem with MASQUERADE of L2TP packets
Date: Mon, 17 Nov 2003 09:38:21 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031117083821.GB22919@sunbeam.de.gnumonks.org>
References: <5.1.0.14.0.20031113162903.01c504b0@172.16.1.10> <5.1.0.14.0.20031113162903.01c504b0@172.16.1.10> <5.1.0.14.0.20031117094700.01b6abf0@172.16.1.10>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6sX45UoQRIJXqkqR"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Rajesh B. V." <rajeshbv@intotoinc.com>
Content-Disposition: inline
In-Reply-To: <5.1.0.14.0.20031117094700.01b6abf0@172.16.1.10>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--6sX45UoQRIJXqkqR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 17, 2003 at 09:52:28AM +0530, Rajesh B. V. wrote:
> Hi Harald Welte,
>=20
> Thankyou very much for the response.
>=20
> The L2TP implementation is ours. It is not free software or open source.

In this case I have to admit that I am very reluctant to assist you with
debugging your problem.  I have never been a fan of kernel binary-only
modules, and I have never given anybody permission to link such modules
with any netfilter/iptables code that is held by my copyright.

> We call " ip_finish_output () " to send the packet out. Till this functio=
n=20
> call the source IP in outer IP header is intact.
> But in this function the POSTROUTING Hook function of IP tables will be=
=20
> called. During this the NAT will happen as the masquerade rule is=20
> configured for POSTROUING.

yes. but what is wrong about that?  If you configured masquerading to
happen, it will happen. =20

> So i am suspecting iptables handling of L2TP packets.

of course, if you use the IPv4 stack, iptables will act according to the
configured ruleset.

> PS:
> I saw some patches for PPTP/IPSec masquerading in net. I guess, it may al=
so=20
> be similar case for L2TP also, but which was not identified.

One of the major design ideas behind l2tp was to encapsulate everything
in UDP - and thus being able to NAT the protocol like any other
udp-based protocol.  This is very different from AH/ESP or PPTP/GRE that
come with their own layer 4 protocol.

> Regards,
> --Rajesh
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--6sX45UoQRIJXqkqR
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/uIj9XaXGVTD0i/8RAoS0AJ96ZR189S5/1EDywgxg7It1HG5IQACgosTV
srcJnEWhQSB8XUvPQNWNV7A=
=7KKm
-----END PGP SIGNATURE-----

--6sX45UoQRIJXqkqR--
