From: Harald Welte <laforge@netfilter.org>
Subject: Re: [netfilter-core] linux-2.6.0-testX ipchains oops in NAT
Date: Thu, 23 Oct 2003 11:02:38 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031023090238.GE1418@sunbeam.de.gnumonks.org>
References: <3F964F9D.D5C69498@fy.chalmers.se>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MAH+hnPXVZWQ5cD/"
Cc: coreteam@netfilter.org,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Andy Polyakov <appro@fy.chalmers.se>
Content-Disposition: inline
In-Reply-To: <3F964F9D.D5C69498@fy.chalmers.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--MAH+hnPXVZWQ5cD/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 22, 2003 at 11:36:29AM +0200, Andy Polyakov wrote:
> Hi,
>=20
> This is a preliminary report:-)

ok, thanks.

> - VMware "host-only" network is NAT-ed by ipchains;

Just a quick unrelated question: Why would somebody be using ipchains on
a 2.6 kernel?=20

> What the heck with rebooting guest and connecting to same URL? Guest OS
> will use very same port numbers at second boot and NAT layer will use
> same port translations, which appears as the triggering factor itself.
>=20
> Reloading ipchains module in between guest OS boots makes it possible to
> avoid lock-ups/oopses.

As I have no idea about vmware: does it destroy the virtual interface on
the host at time of the reboot in your guest os?

What about using iptables?  Does it produce a similar behaviour?  I
think this is the first time within at least a year that we've had any
report of somebody using (or finding bugs) in the ipfwadm/ipchains
compat layer... it wasn't even frequently used with 2.4.x

> Question. Should I pursue the issue further?

yes, please.  Especially a means of reproduction without running
proprietary software (and thus being repruducable for me) would be very
helpful.

> Cheers. A.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--MAH+hnPXVZWQ5cD/
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/l5ktXaXGVTD0i/8RAoDYAJ4ngIZp1DoqkOjR2psQe4S6Qr33UQCfT7gq
7eCeKww6AYgaXniK5UrDYXU=
=xcVN
-----END PGP SIGNATURE-----

--MAH+hnPXVZWQ5cD/--
