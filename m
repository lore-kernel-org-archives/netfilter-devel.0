From: Peter Surda <shurdeek@panorama.sth.ac.at>
Subject: Re: 2 problems with my net/conntrack helper for MSN
Date: Sat, 31 May 2003 10:36:05 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030531083605.GB9615@smith.cb.ac.at>
References: <1054342550.961.68.camel@exile>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+HP7ph2BbKc20aGI"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <1054342550.961.68.camel@exile>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--+HP7ph2BbKc20aGI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, May 31, 2003 at 02:55:50AM +0200, Filip Sneppe (Cronos) wrote:
> Hi,
Hi.

>         Microsoft
>        Switchboard
>          Servers
>         (Internet)
>            ^ ^
>            | |
>            | |
>            NAT  (MASQUERADE)=20
>            box =20
>           /   \
>          /     \
>         |       |
>        Host    Host
>         A       B
This problem isn't only relevant for MSN, also for every other nat helper. =
The
solution is acutally quite simple:

iptables -t nat -A POSTROUTING -s local_net -d local_net -j SNAT --to-sourc=
e public_ip

This also helps when you want to porforward from local_net instead from the
outside.

The helper doesn't have to differentiate.

> Filip
Bye,

Peter Surda (Shurdeek) <shurdeek@panorama.sth.ac.at>, ICQ 10236103, +436505=
122023

--=20
              To boldly go where I surely don't belong.

--+HP7ph2BbKc20aGI
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: Weitere Infos: siehe http://www.gnupg.org

iD8DBQE+2Gl1zogxsPZwLzcRAr22AKCDvG8/a2PdASTlgPg7lJiqbxg2LQCcCzYI
mFuOfUB7c0vQMjHdqE6deJI=
=Ds7H
-----END PGP SIGNATURE-----

--+HP7ph2BbKc20aGI--
