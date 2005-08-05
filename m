From: Harald Welte <laforge@netfilter.org>
Subject: Re: Managing netfilter/iptables via netlink
Date: Fri, 5 Aug 2005 20:31:20 +0200
Message-ID: <20050805183120.GE13345@rama.de.gnumonks.org>
References: <1123080095.30594.239892161@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MAH+hnPXVZWQ5cD/"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Adam <netfilter@irotas.net>
Content-Disposition: inline
In-Reply-To: <1123080095.30594.239892161@webmail.messagingengine.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--MAH+hnPXVZWQ5cD/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 03, 2005 at 10:41:35AM -0400, Adam wrote:
> However, looking into the iptables userspace code, it seems that it
> sends directives to the kernel using setsockopt().

yes.

> My question is this: Is it possible to manage netfilter/iptables from
> userspace using netlink?=20

no.  the successor of iptables (called pkttables) will hve that
feature, but it's not there yet.

> Currently my software uses system("/sbin/iptables ...") for configuring
> the firewall, but unfortunately this is no longer an option.

please read the list archives.  piping into stdin of iptables-restore
--noflush is the best you can do for now.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
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
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFC87B4XaXGVTD0i/8RArRRAJ9cYSRmc315X27HjZttKGClmJ7gmgCfdRDX
Kq/q+HtLqE72SwdtkuLtt7c=
=cN3K
-----END PGP SIGNATURE-----

--MAH+hnPXVZWQ5cD/--
