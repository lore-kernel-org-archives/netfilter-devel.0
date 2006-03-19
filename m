From: Alexander Samad <alex@samad.com.au>
Subject: Re: Interesting problem with conntrack and ftp
Date: Mon, 20 Mar 2006 00:14:34 +1100
Message-ID: <20060319131434.GA14521@hufpuf.lan1.hme1.samad.com.au>
References: <20060316235511.GA18440@hufpuf.lan1.hme1.samad.com.au>
	<Pine.LNX.4.64.0603190134110.16079@bizon.gios.gov.pl>
	<20060319043843.GA31012@hufpuf.lan1.hme1.samad.com.au>
	<Pine.LNX.4.64.0603191306580.4011@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6TrnltStXW4iwmi0"
Cc: Alexander Samad <alex@samad.com.au>, netfilter-devel@lists.netfilter.org,
	netfilter@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Krzysztof Oledzki <olenf@ans.pl>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0603191306580.4011@bizon.gios.gov.pl>
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


--6TrnltStXW4iwmi0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Mar 19, 2006 at 01:09:54PM +0100, Krzysztof Oledzki wrote:
>=20
>=20
> On Sun, 19 Mar 2006, Alexander Samad wrote:
>=20
> >On Sun, Mar 19, 2006 at 01:37:39AM +0100, Krzysztof Oledzki wrote:
> >>
> >>
> >>On Fri, 17 Mar 2006, Alexander Samad wrote:
> >>
> >>>Hi
> >>>
> >>>I was resently setting up my new firewall usimng openwrt on a linksys.
> >>>
> >>>I got around to setting up my adsl connection and added into my iptabl=
es
> >>>these commands
 ... snip
> >
> >makes sense, ran foul of the man page
> >
> >      Workaround: activate this option and add a rule to your firewall
> >configuration like:
> >       iptables -A FORWARD -p tcp --tcp-flags SYN,RST SYN \
> >                   -j TCPMSS --clamp-mss-to-pmtu
>=20
> You must have some old version of this man page (and probaby iptables).
>=20
> Current version contains:
>=20
> Workaround: activate this option and add a rule to your firewall=20
> configuration like:
>=20
>  iptables -t mangle -A FORWARD -p tcp --tcp-flags SYN,RST SYN \
>              -j TCPMSS --clamp-mss-to-pmtu


using etch debian amd64 port.... Thanks again

>=20
> Best regards,
>=20
> 				Krzysztof Ol?dzki


--6TrnltStXW4iwmi0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)

iD8DBQFEHVk6kZz88chpJ2MRAhfkAKD2qxQ//YEv6xw1IjIh2eu151ZkVACg3N25
Hci6LcV+51SNxWrkQBc4nj0=
=9Opk
-----END PGP SIGNATURE-----

--6TrnltStXW4iwmi0--
