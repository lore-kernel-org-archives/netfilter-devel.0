From: Harald Welte <laforge@netfilter.org>
Subject: Re: [NETFILTER] Some more informations
Date: Sun, 2 Nov 2003 16:42:28 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031102154228.GD1536@sunbeam.de.gnumonks.org>
References: <mnet1.1066738475.26722.florian.pouradier@netcourrier.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="snImcH6YoPvXmXT+"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: florian.pouradier@netcourrier.com
Content-Disposition: inline
In-Reply-To: <mnet1.1066738475.26722.florian.pouradier@netcourrier.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--snImcH6YoPvXmXT+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 21, 2003 at 02:14:35PM +0200, florian.pouradier@netcourrier.com=
 wrote:
> Hi,
>=20
> these last days, I'm interested in coding in netfilter. I read a few
> (good) papers from you on this topic.

Thanks, you're welcome !

> I have a good experience in C programming, but never in kernel nor in
> advanced network.

that's not a problem in general.

> I would like to develop a netfilter module to change "on the fly" data
> from protocols, like NNTP.

I doubt that netfilter (or any other packet filter) is the right way to
do that.   The major problem is that you don't have stream reassembly,
but just the packets themselves.  So somebody could send the data in one
byte packets, and you'd never be able to match [and replace] data in the
stream.

> I can't really see whether the NAT helper modules architecture is
> suitable for this kind of manipulation. I can see it changing some
> data (for the FTP PORT command as an example), but always for related
> connections. The module I would like to write won't imply a new
> connection, so I would like to know your opinion about this.

You can perfectly implement it as a  NAT helper module.  Nobody forces a
nat helper to raise expectations. see the SNMP helper as an example.

> Thanks in advance,
> Florian Pouradier.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--snImcH6YoPvXmXT+
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/pSXkXaXGVTD0i/8RAlTTAKCjIpgNdbFBQPj4ossfRoMjx8nnvgCeLuPy
mpKFkJ+39VU2//mdCX7J1zY=
=V5l/
-----END PGP SIGNATURE-----

--snImcH6YoPvXmXT+--
