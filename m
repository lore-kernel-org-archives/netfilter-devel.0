From: "Brian J. Murrell" <netfilter@interlinx.bc.ca>
Subject: Re: separation of sysctl and tcp-window-tracking patch?
Date: 13 Dec 2002 16:45:02 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1039815902.6247.8.camel@pc>
References: <1039702486.2373.17.camel@pc>
	 <Pine.LNX.4.44.0212130314131.2834-100000@shieldbreaker.l33tskillz.org>
	 <20021213120625.GA21253@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-0K8nv8fp5ETNxv/vII6k"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20021213120625.GA21253@oknodo.bof.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-0K8nv8fp5ETNxv/vII6k
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2002-12-13 at 07:06, Patrick Schaaf wrote:
> > Failing a helper, I'm unable to come up with anything better than
> > adjusting timeouts on a per-port basis...
>=20
> What about a single new target, CTTIMEOUT or something, having a single
> parameter, a relative timeout in seconds. Whenever that target hits,
> and we have a connection hanging off our skb, the connection's timeout
> will be refreshed to now+the_given_timeout.

I guess because the idea of a parameter to set the timeout has been
floated before (by me and by others before me) and turned down (by
Rusty) in favour of a (tunable) table in the UDP conntracker.  This
would be to further autoconfiguration which Rusty is a great fan of.


> I have not thought about the interplay with the current automatic
> timeout selection. Anybody?

Which is probably why doing it in the udp conntracker, in a tunable
table is the current way of thinking.  Should not be too difficult in
fact.  I would attempt it myself if I could get a decent stretch of
hacking time.

b.

--=20
Brian J. Murrell <netfilter@interlinx.bc.ca>

--=-0K8nv8fp5ETNxv/vII6k
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQA9+lTdl3EQlGLyuXARAuorAKCxXf8Lc0HXGDu+ut7vF1mUJm1fVwCfR1oC
zXJqfP3yiMHnAjkXbtzrmwg=
=2njc
-----END PGP SIGNATURE-----

--=-0K8nv8fp5ETNxv/vII6k--
