From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] x_tables, take 5 (Final Review)
Date: Mon, 9 Jan 2006 11:35:04 +0100
Message-ID: <20060109103504.GK24266@sunbeam.de.gnumonks.org>
References: <20060108212619.GE24266@sunbeam.de.gnumonks.org>
	<200601090852.k098qjeO004027@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yklP1rR72f9kjNtc"
Cc: netfilter-devel@lists.netfilter.org, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Content-Disposition: inline
In-Reply-To: <200601090852.k098qjeO004027@toshiba.co.jp>
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


--yklP1rR72f9kjNtc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 09, 2006 at 05:52:44PM +0900, Yasuyuki KOZAKAI wrote:
> OK, I'll test it after sending this mail. Before that I have some comments
> about minor issues.

thanks a lot.

> The dependency on NETFILTER_XTABLES is missing at config of
> CLASSIFY and NOTRACK. And according to your Kconfig style, the menu item
> for CLASSIFY should not be shown. Please apply attached patches.

thanks, I'll update.

> I have one more comment about need_conntrack(). The kernel with x_tables =
patch
> doesn't load nf_connrack_ipv4 when user types "iptables -A INPUT -m state=
=2E..".
> Then no packets might be untracked after that. One solution is to try load
> nf_conntrack_{ipv4,ipv6} and to ignore error on load, but I'm not sure th=
at
> this is the best way.

Mh.  Can we put this into checkentry()?  Probably there are some issues
with regard to locking, but it would be the logical place to do it.  We
[can] know whether it's an iptables or an ip6tables rule, and therefore
we know which tracking we want to request.

we should have something like a
"need_conntrack(int pf)" function provided by the conntrack core.  Then
anyone in the kernel can request something like
"need_conntrack(AF_INET)".

Also, my Kconfig magic (originally suggested by Rusty) doesn't seem to
work.  It does not automatically select the XT matches/targets based on
the previous IPT selections :(

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--yklP1rR72f9kjNtc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDwjxYXaXGVTD0i/8RAqMeAKCVnsemiwOU1rN4oxvzUmjpYAxaZgCeN3xk
AlIETc6rY8kMIb3exdj2rR8=
=hg3U
-----END PGP SIGNATURE-----

--yklP1rR72f9kjNtc--
