From: Harald Welte <laforge@netfilter.org>
Subject: Re: nf_conntrack & NAT
Date: Tue, 6 Dec 2005 21:13:21 +0530
Message-ID: <20051206154320.GG4038@rama.exocore.com>
References: <Pine.LNX.4.64.0511231214590.11295@bizon.gios.gov.pl>
	<200511231225.jANCPmYd015427@toshiba.co.jp>
	<20051123132044.GZ3249@eychenne.org>
	<20051123132419.GJ24091@fi.muni.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kHRd/tpU31Zn62xO"
Cc: netfilter-devel@lists.netfilter.org,
	Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>,
	Herve Eychenne <rv@wallfire.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jan Kasprzak <kas@fi.muni.cz>
Content-Disposition: inline
In-Reply-To: <20051123132419.GJ24091@fi.muni.cz>
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


--kHRd/tpU31Zn62xO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 23, 2005 at 02:24:19PM +0100, Jan Kasprzak wrote:
> Herve Eychenne wrote:
> : On Wed, Nov 23, 2005 at 09:25:47PM +0900, Yasuyuki KOZAKAI wrote:
> :=20
> :  Hi,
> :=20
> : > >                                                      and adding NAT=
=20
> : > > support for IPv6?
> :=20
> : > Never ever. You can learn why people don't want to do it from many so=
urces.
> : > For example, You can use many addresses in IPv6 world. And I don't wa=
nt people
> : > get troubles due to NAT traversal issues in IPv6 world.
> :=20
> : And what if you want your firewall to transparently redirect some traff=
ic
> : to another host, for example?
> :=20
> 	... or IPVS-based clusters. NAT functionality is definitely
> wanted (even though full NAT in the IPv6 world is evil :-).

guys, we have to differentiate here.

I often stated "nf_conntrack based ipv6 nat only over my dead body".
This refers to something similar to the current IPv4 NAT code as a
stateful, fully symmetric, port overloading NAPT attached to the
connection tracking code.

for stuff like redirecting traffic, all you really need is stateless
rewriting of the destination address.  If people want that, the entire
implementation fits in a single ip6tables target.  no relation to
nf_conntrack at all.

also, IPVS doesn't need any ip_conntrack/iptable_nat today, why would it
need that for ipv6?
--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--kHRd/tpU31Zn62xO
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDlbGYXaXGVTD0i/8RAqI5AJ9ZDm32c2AcVSrwdATmKQnwzlOyOgCgpl9i
lNNDpBvi1wEOpXzEUsjfSY0=
=rg0l
-----END PGP SIGNATURE-----

--kHRd/tpU31Zn62xO--
