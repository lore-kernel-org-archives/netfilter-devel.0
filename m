From: Harald Welte <laforge@netfilter.org>
Subject: Re: TCPFLAG <New>
Date: Mon, 30 Jun 2003 14:10:36 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030630121036.GJ2645@sunbeam.de.gnumonks.org>
References: <1056887495.5490.844.camel@teratron>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OwzqIEWRKjusbBA7"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Craig Shelley <craig@microtron.org.uk>
Content-Disposition: inline
In-Reply-To: <1056887495.5490.844.camel@teratron>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--OwzqIEWRKjusbBA7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 29, 2003 at 12:51:35PM +0100, Craig Shelley wrote:
> Hi All,
> 	About a year ago, I made an iptables module/library to manipulate the
> flags on TCP packets. Well... I have tested it on my server, and it has
> been running without any errors for nearly a year. I have enclosed the
> source code (sorry no docs). There is a little script in there to patch
> the kernel source, and make TCPFLAG appear in menuconfig.
>=20
> I use this module to open connections through a packet filter firewall
> that is unfortunately between two of my boxes. The firewall drops all
> inbound packets with the SYN flag set, so I use TCPFLAG masquerade SYN
> packets as RST packets. (A bit crude, but it does the job!)
> At the receiving end, I convert the RST packets that I sent from my host
> back to SYN packets.

Well, I regard this as an interesting 'hack', which may solve your
particular problem.  However, I don't think that it does something
'desired' that lots of users would like to use.

> Since I am only using this code to do a temporary job, I don't
> anticipate maintaining it. This is the reason I have not submitted it
> before.

Since you don't want to maintain it, and the netfiltere coreteam doesn't
have any particular interest in adding such functionality, I will not
put it into the patch-o-matic system.

For anybody who disagrees: Please feel free to convince me of the
opposite :)

> Craig Shelley <craig@microtron.org.uk>

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--OwzqIEWRKjusbBA7
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE/ACi8XaXGVTD0i/8RAhDNAKCglZifaIHkYvbAIDrqqXnMEJS/ZwCfcb9s
Bl5FGGGqOcVfvzJkqkUXmdA=
=X30t
-----END PGP SIGNATURE-----

--OwzqIEWRKjusbBA7--
