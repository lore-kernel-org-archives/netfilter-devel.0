From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH]: 1st step to remove skb_linearize() in ip6_tables.c and optimization
Date: Wed, 21 Jul 2004 17:36:54 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040721213653.GR27487@obroa-skai.de.gnumonks.org>
References: <200406250457.NAA07080@toshiba.co.jp> <Pine.LNX.4.33.0406251133230.11001-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WU3I8Do+sziGY3UL"
Cc: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>,
	Patrick McHardy <kaber@trash.net>,
	netfilter-devel@lists.netfilter.org,
	Harald Welte <laforge@netfilter.org>, kisza@securityaudit.hu,
	usagi-core@linux-ipv6.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.33.0406251133230.11001-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--WU3I8Do+sziGY3UL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 25, 2004 at 12:01:37PM +0200, Jozsef Kadlecsik wrote:

> - conntrack requires linearized protocol headers
> 	- with the TCP window tracking code it means the complete
> 	  TCP header, including the options due to the SACK support
> - nat requires writable protocol headers, including the TCP options
>   due to the SACK support
> - raw/filter tables require linearized protocol headers in general (we can
>   safely assume port matching rules :-)
> - mark table requires writable protocol headers if we mangle the packet
>   headers

yes, it's time to implement my old idea of a function like
	skb_linearize_partial(skb, len)

This could then be called by a skb_linearize_l4() function, that would
linearize IP header, ip options, tcp header.

Ideally a hook-registering function should specify what it needs to have
linearized. netfilter.c would then calculate the per-hook maximum and
call the linearize function with that maximum. =20

> So I think when any component of netfilter is enabled, we can assume that
> at least linearized protocol headers are required. Therefore I suggested
> to add such a function to nf_hook_slow.

yes, I agree.  Does anybody want to hack up a patch?  The most
interesting part will be testing of that feature...

> Best regards,
> Jozsef

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--WU3I8Do+sziGY3UL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFA/uH1XaXGVTD0i/8RAjU6AJ93rqrEHCo9d7WHYzyOosgylAc7CACgoSEp
pFaAdrMEtihSXHOkOe7HqLM=
=Yld/
-----END PGP SIGNATURE-----

--WU3I8Do+sziGY3UL--
