From: Alexander Samad <alex@samad.com.au>
Subject: Re: Interesting problem with conntrack and ftp
Date: Sun, 19 Mar 2006 15:38:43 +1100
Message-ID: <20060319043843.GA31012@hufpuf.lan1.hme1.samad.com.au>
References: <20060316235511.GA18440@hufpuf.lan1.hme1.samad.com.au>
	<Pine.LNX.4.64.0603190134110.16079@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mYCpIKhGyMATD0i+"
Cc: Alexander Samad <alex@samad.com.au>, netfilter-devel@lists.netfilter.org,
	netfilter@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Krzysztof Oledzki <olenf@ans.pl>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0603190134110.16079@bizon.gios.gov.pl>
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


--mYCpIKhGyMATD0i+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Mar 19, 2006 at 01:37:39AM +0100, Krzysztof Oledzki wrote:
>=20
>=20
> On Fri, 17 Mar 2006, Alexander Samad wrote:
>=20
> >Hi
> >
> >I was resently setting up my new firewall usimng openwrt on a linksys.
> >
> >I got around to setting up my adsl connection and added into my iptables
> >these commands
> >
> >
> >
> >$IPT -t filter -A FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT
> >$IPT -t filter -A FORWARD -o $WANADSL -p tcp --tcp-flags SYN,RST SYN -j=
=20
> >TCPMSS --clamp-mss-to-pmtu
> >$IPT -t nat -A POSTROUTING -o $WANADSL -j MASQUERADE
> >
> >which is what I have normally done.
> >
> >http traffic worked well, but ftp of large files, timed out, sign of a
> >mtu problem. It worked when I ftp'ed from the firewall, but not when I
> >did it from behind the firewall.
> >
> >When I did some tcpdumps, I noticed that the second connection created
> >by the client wasn't being clamp'ed.
> >
> >The way I figure it was that the second connection was related to the
> >first one, and thus being consumed by the first line in iptables (above)
> >
> >Once I changed the order of line 1 and 2 every thing worked fine.
> >
> >Now openwrt uses 2.4.30, and my previous firewall used 2.6 and I believe
> >it was setup as shown above and it worked fine.
> >
> >The other difference is that conntrack_ftp is compiled into the kernel.
> >
> >Is this a know feature/bug ? why has it worked in 2.6 and not in 2.4 or
> >is the problem in compiled in and as a module
>=20
> The solution is simple: TCPMSS should be used only in mangle table.=20
> Anyway, if you didn't change the configuration I have no idea why it=20
> worked in 2.6 and does not work in 2.4.

makes sense, ran foul of the man page=20

       Workaround: activate this option and add a rule to your firewall
configuration like:
        iptables -A FORWARD -p tcp --tcp-flags SYN,RST SYN \
                    -j TCPMSS --clamp-mss-to-pmtu


>=20
> Best regards,
>=20
> 				Krzysztof Ol?dzki


--mYCpIKhGyMATD0i+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)

iD8DBQFEHOBTkZz88chpJ2MRAorvAKC9LZQnUzXW/kuLzsaWiRih5TtatACdH4cX
rWe5YM7qsNjP458ypqbkVa4=
=2XdF
-----END PGP SIGNATURE-----

--mYCpIKhGyMATD0i+--
