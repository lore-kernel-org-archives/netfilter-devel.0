From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] x_tables, take 5 (Final Review)
Date: Thu, 12 Jan 2006 17:58:38 +0100
Message-ID: <20060112165838.GL4430@sunbeam.de.gnumonks.org>
References: <20060108212619.GE24266@sunbeam.de.gnumonks.org>
	<200601090852.k098qjeO004027@toshiba.co.jp>
	<20060109103504.GK24266@sunbeam.de.gnumonks.org>
	<200601100418.k0A4IxhL008706@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dQ2UWBmeJhPxzxhA"
Cc: netfilter-devel@lists.netfilter.org, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Content-Disposition: inline
In-Reply-To: <200601100418.k0A4IxhL008706@toshiba.co.jp>
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


--dQ2UWBmeJhPxzxhA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 10, 2006 at 01:18:59PM +0900, Yasuyuki KOZAKAI wrote:
> From: Harald Welte <laforge@netfilter.org>
> Date: Mon, 9 Jan 2006 11:35:04 +0100
>=20
> > > I have one more comment about need_conntrack(). The kernel with x_tab=
les patch
> > > doesn't load nf_connrack_ipv4 when user types "iptables -A INPUT -m s=
tate...".
> > > Then no packets might be untracked after that. One solution is to try=
 load
> > > nf_conntrack_{ipv4,ipv6} and to ignore error on load, but I'm not sur=
e that
> > > this is the best way.
> >=20
> > Mh.  Can we put this into checkentry()?  Probably there are some issues
> > with regard to locking, but it would be the logical place to do it.  We
> > [can] know whether it's an iptables or an ip6tables rule, and therefore
> > we know which tracking we want to request.
> >=20
> > we should have something like a
> > "need_conntrack(int pf)" function provided by the conntrack core.  Then
> > anyone in the kernel can request something like
> > "need_conntrack(AF_INET)".
>=20
> sounds good idea.

I'll implement this later on.  Today I want to finally submit x_tables,
even with this minor issue left for an incremental patch.

> > Also, my Kconfig magic (originally suggested by Rusty) doesn't seem to
> > work.  It does not automatically select the XT matches/targets based on
> > the previous IPT selections :(
>=20
> How about this ?
> 	- make {IP,IP6,ARP}_NF_IPTABLES select NETFILTER_XTABLES
> 	- make IP_NF_{MATCH,TARGET}_* select NETFILTER_XT_{MATCH,TARGET}_*
> 	- hide the menus for NETFILTER_XTABLES and
> 	  NETFILTER_XT_{MATCH,TARGET}_*
> 	- show the menus for {IP,IP6,ARP}_NF_{MATCH,TARGET}_*

no, I don't like that idea.  It would mean that we'd hide the existance
of x_tables in the long term from the user.  Rather the opposite
direction is the case: less and less {ip,arp,ip6}_tables, and more
functionality moving to the core.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--dQ2UWBmeJhPxzxhA
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDxoq+XaXGVTD0i/8RAlJYAKCtJDcarrADnFMfl4DJmPccYnGhygCgnMkx
cU4HJCDJArUWpxJywVAs/Ko=
=MhyQ
-----END PGP SIGNATURE-----

--dQ2UWBmeJhPxzxhA--
