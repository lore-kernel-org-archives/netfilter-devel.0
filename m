From: Harald Welte <laforge@gnumonks.org>
Subject: Re: Question
Date: Sun, 1 Jun 2003 10:22:20 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030601082220.GH29312@sunbeam.de.gnumonks.org>
References: <1054404695.3ed8f057467a1@unlp.unlp.edu.ar> <20030531195305.GA6917@sunbeam.de.gnumonks.org> <1054429282.3ed95062b0c41@unlp.unlp.edu.ar>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BeiMt4EphvRJ5ehf"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: mluengo@unlp.edu.ar
Content-Disposition: inline
In-Reply-To: <1054429282.3ed95062b0c41@unlp.unlp.edu.ar>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--BeiMt4EphvRJ5ehf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, May 31, 2003 at 10:01:22PM -0300, mluengo@unlp.edu.ar wrote:
> I have a Kernel 2.4.20 patched with patch-o-matic . I have the modules lo=
aded=20
> (ip_conntrack_pptp, ip_nat_pptp, ip_nat_prot_gre, and so) but my server p=
ptpd=20
> is logging:=20
> "pptpd[6249]: GRE: Discarding out of order packet" if two client is conne=
cted=20
> (not if only one)

Are you aware that the linux pptpd doesn't even support multiple clients
=66rom a single ip?  This is a severe bug in pptpd, not in the netfilter
nat helper module.

Try it for yourself... make two pptp connections  from one client to the
same server, and you will end up with the same error.

You need to use a pptp server that supports multiple connections from
one IP.

> Thank you in advance.
> Miguel
--=20
- Harald Welte <laforge@gnumonks.org>               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
Programming is like sex: One mistake and you have to support it your lifeti=
me

--BeiMt4EphvRJ5ehf
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+2be8XaXGVTD0i/8RAhGsAJ9XeekyxuUhBdkoxDtzrsGbpYIOtgCcD2/S
hRSjs3EjWjRxux0zeJggmXU=
=kQjS
-----END PGP SIGNATURE-----

--BeiMt4EphvRJ5ehf--
