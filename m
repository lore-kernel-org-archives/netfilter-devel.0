From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] ownercmd for ip6tables
Date: Sun, 13 Apr 2003 18:27:59 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030413162759.GX1922@sunbeam.de.gnumonks.org>
References: <3E92F3C4.9070908@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OowMmFE4aK71mEhh"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <3E92F3C4.9070908@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--OowMmFE4aK71mEhh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 08, 2003 at 06:07:32PM +0200, Patrick McHardy wrote:
> This patch adds support for the --owner-cmd option to ip6t_owner.
> I have this lying around for about 9 month and i can not remember
> if i ever tested it and i have no ipv6 network available (sorry).

I'm applying it to CVS now, since iptables-1.2.8 has been released now.
There's plenty of time left to test the ownercmd before another
iptables-release.

Please note that I am applying the userspace part immediately.

> Bye,
> Patrick

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--OowMmFE4aK71mEhh
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+mZAPXaXGVTD0i/8RAoXfAJ9yGWqyX9UWZ1OlwBW1gd8wtEew9gCgm2v2
kAVgf20iiVtkV6y+pl+42Wk=
=7DDq
-----END PGP SIGNATURE-----

--OowMmFE4aK71mEhh--
