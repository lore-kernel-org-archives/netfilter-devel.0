From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PTCH 2.5.68] netfilter using Read Copy Update
Date: Sun, 27 Apr 2003 15:24:13 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030427132413.GP990@sunbeam.de.gnumonks.org>
References: <20030424090406.504ada94.shemminger@osdl.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="K0mDTbuGRobClnW5"
Cc: Rusty Russell <rusty@rustcorp.com.au>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Stephen Hemminger <shemminger@osdl.org>
Content-Disposition: inline
In-Reply-To: <20030424090406.504ada94.shemminger@osdl.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--K0mDTbuGRobClnW5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 24, 2003 at 09:04:06AM -0700, Stephen Hemminger wrote:
> This is an update to netfilter core that uses the read-copy-update
> instead of brlock.  The code is similar to my earlier patch but less
> invasive.

I will try to review this patch and eventually push it to David Miller.

> There should be no visible change to the semantics, and the performance
> should be the same or better.
>=20
> Ran a basic test with iptables and NAT, but needs some more through
> usage.=20

We will distribute it with our patch-o-matic system, this should give it
more users.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--K0mDTbuGRobClnW5
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+q9n9XaXGVTD0i/8RAufyAKCWQ2/uCluvi4Qw3XHuPlfBiKCq7QCfSmXq
NK3L+s89J/Bgh/pv6mjPT2U=
=MbVS
-----END PGP SIGNATURE-----

--K0mDTbuGRobClnW5--
