From: Harald Welte <laforge@netfilter.org>
Subject: Re: PPTP connection tracking
Date: Mon, 17 Feb 2003 20:00:23 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030217190023.GF11812@sunbeam.de.gnumonks.org>
References: <4.2.0.58.20030119145120.00b1c6f0@avocetgw>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="R+My9LyyhiUvIEro"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Paul Mielke <paulm@routefree.com>
Content-Disposition: inline
In-Reply-To: <4.2.0.58.20030119145120.00b1c6f0@avocetgw>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--R+My9LyyhiUvIEro
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 19, 2003 at 03:01:09PM -0800, Paul Mielke wrote:

> The thing that prevented case 1) from working is the following
> fragment in the routine ip_nat_fn() in ip_nat_standalone.c starting
> around line 111:
>=20
>          case IP_CT_NEW:
> #ifdef CONFIG_IP_NF_NAT_LOCAL
>                  /* LOCAL_IN hook doesn't have a chain and thus doesn't c=
are
>                   * about new packets -HW */
>                  if (hooknum =3D=3D NF_IP_LOCAL_IN)
>                          return NF_ACCEPT;
> #endif

you are definitely correct, althought your solution is problematic.  In
the case NAT_LOCAL is enabled, we are still not allowed to call
ip_nat_rule_find, because this in turn calls ipt_do_table()... but
there is no chain attached to the LOCAL_IN hook of the 'nat' table, and
bad things start to happen.

I have put a proposed patch into CVS:
(patch-o-matic/pending/10_local-nat-expectfn.patch)

This patch rather moves the particular piece of code a couple of lines
down, so we assure that an expectfn (if it exists) gets called.

Can you please test if your setup works with this patch?

> Paul Mielke                        paulm@routefree.com
> RouteFree, Inc.                   (650) 739-5377

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--R+My9LyyhiUvIEro
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+UTFGXaXGVTD0i/8RAhZ2AJoDmiKdwStZFFyCAuAqfWxARfx5WQCgi5IY
d437pREI5lmWhhSSFGDp9Bw=
=yj0M
-----END PGP SIGNATURE-----

--R+My9LyyhiUvIEro--
