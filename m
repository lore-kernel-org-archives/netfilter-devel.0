From: Harald Welte <laforge@netfilter.org>
Subject: Re: invalid packets
Date: Fri, 23 May 2003 22:06:45 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030523200645.GU3077@sunbeam.de.gnumonks.org>
References: <3EC5140F.1030203@Linux.ie>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OwXh6gFRjCd3qPCM"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Padraig@Linux.ie
Content-Disposition: inline
In-Reply-To: <3EC5140F.1030203@Linux.ie>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--OwXh6gFRjCd3qPCM
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 16, 2003 at 05:38:39PM +0100, Padraig@Linux.ie wrote:
> Hi, under what circumstances would iptraf (PF_PACKET)
> be able to recieve packets on an interface, and
> for those same packets to be not registered
> with netfilter at all. I'm setting the filter on
> the PREROUTING chain in the mangle table and no
> packets are registered?

PF_PACKET has no relation to the IP stack.  So PF_PACKET sockets will always
receive copies of all packets on a higher layer (layer2) than
netfilter/iptables.

> Hmm I suppose if the checksum is wrong you can't depend
> on anything, but I'm just surprised iptraf can
> log them which netfilter can't.

packets with wrong checksums are dropped by the higher layers (3/4)

> cheers,
> P=E1draig.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--OwXh6gFRjCd3qPCM
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+zn9VXaXGVTD0i/8RAk6IAKCGCfnBchtl+mfA6BUln/e9NCB1HQCePLPy
n4Sk6OKK4GTBQzQf681TK8w=
=oUKn
-----END PGP SIGNATURE-----

--OwXh6gFRjCd3qPCM--
