From: Harald Welte <laforge@netfilter.org>
Subject: Re: Raw Sockets and Netfiter
Date: Wed, 26 Mar 2003 16:32:56 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030326153256.GA21953@sunbeam.de.gnumonks.org>
References: <001701c2f29d$20afe1e0$6b01a8c0@COURVOISIER> <20030325072544.GI18652@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="iytlPraCFSCqrfnM"
Cc: Ethan Dameron <efd@duke.edu>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick Schaaf <bof@bof.de>
Content-Disposition: inline
In-Reply-To: <20030325072544.GI18652@oknodo.bof.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--iytlPraCFSCqrfnM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 25, 2003 at 08:25:44AM +0100, Patrick Schaaf wrote:
> On Tue, Mar 25, 2003 at 02:06:59AM -0500, Ethan Dameron wrote:
> > If I have a an IP datagram in userspace and I send it via a raw socket
> > created with socket(PF_INET, SOCK_RAW, IPPROTO_RAW) using the send()
> > system call, will this packet traverse the netfilter chains?
>=20
> No. Raw sockets bypass the TCP/IP stack. Netfilter hooks, and
> consequently iptables, sit inside the IP stack.

PF_PACKET sockets bypass the TCP/IP stack.

PF_INET/SOCK_RAW sockets still travers the TCP/IP stack.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--iytlPraCFSCqrfnM
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+gcgoXaXGVTD0i/8RAvsjAJ9IkGwUb/khrYUtfSLZ52isJ3G6iACdE6wJ
bVQwOivpIVJIgk8DQnDd3Xk=
=4hxF
-----END PGP SIGNATURE-----

--iytlPraCFSCqrfnM--
