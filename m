From: Harald Welte <laforge@netfilter.org>
Subject: Re: L2TP protocol source port number changed
Date: Fri, 23 May 2003 22:19:36 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030523201936.GV3077@sunbeam.de.gnumonks.org>
References: <3ECC5A67.5000803@cobra.ee.ntu.edu.tw> <20030522061046.GB24297@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="p6hDAtPN9q+ZnUca"
Cc: ChungLiang <david@cobra.ee.ntu.edu.tw>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick Schaaf <bof@bof.de>
Content-Disposition: inline
In-Reply-To: <20030522061046.GB24297@oknodo.bof.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--p6hDAtPN9q+ZnUca
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 22, 2003 at 08:10:46AM +0200, Patrick Schaaf wrote:
> ChungLiang & all,
>=20
> my previous mail was a bit wrong on the real problem with L2TP:
>=20
> Seeing the initial tunnel establishment packet from LAC to LNS,
> one can NOT infer the IP address and port that the LNS will use
> for the second, acknowledging, packet. The LNS is free to choose
> one, it just has to answer back to the LAC and the port the LAC
> used in the initial packet.
>=20
> Thus, no exact expectation can be set up by inspecting the
> initial packet; you need to capture any UDP traffic flowing
> back to the initial LAC IP/port, and use the source information
> of that captured packet to then set up the expectation.

> Does the current NAT core allow such a partial expectation setup?

you have a tuple and a mask.  you can easily set up an expectation for
any unknown srcip/srcport to a specific dstip/dstport.

This is what ip_conntrack_irc does for DCC, for example.=20

> best regards
>   Patrick

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--p6hDAtPN9q+ZnUca
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+zoJYXaXGVTD0i/8RAjfLAKC0oGH9mabG1yLQWPgjb2KUG7Hh4ACfQooD
nZajLNSTIv4MY9eoqi/Fdqw=
=67xQ
-----END PGP SIGNATURE-----

--p6hDAtPN9q+ZnUca--
