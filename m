From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] Fix ip_queue for bridged packets
Date: Tue, 14 Oct 2003 12:58:25 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031014105825.GA3752@obroa-skai.de.gnumonks.org>
References: <200310122243.38551.bdschuym@pandora.be>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="n8g4imXOkfNTN/H1"
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>,
	Stephen Hemminger <shemminger@osdl.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Bart De Schuymer <bdschuym@pandora.be>
Content-Disposition: inline
In-Reply-To: <200310122243.38551.bdschuym@pandora.be>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--n8g4imXOkfNTN/H1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 12, 2003 at 10:43:38PM +0200, Bart De Schuymer wrote:
> Hi Harald,
>=20
> When ip_queue copies an old skbuff to a new one (because the tailroom is
> too small), it uses skb_copy_expand(). This function doesn't copy the
> Ethernet header, which is not needed for normal IP traffic. Normally, the
> Ethernet header is filled in later before doing dev_queue_xmit.
> When ip_queue does this to a bridged IP packet, it has to copy the Ethern=
et
> header, because the Ethernet header was already filled in earlier and won=
't
> be filled in again.

what about ip6_queue.c ?  Would you need a similar fix for ipv6
bridging  If yes, could you please merge your changes with ip6_queue.c
and send me a cumulative patch?

Thanks.

> cheers,
> Bart
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--n8g4imXOkfNTN/H1
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/i9bQXaXGVTD0i/8RAoOxAJwLFrPDth4OTtppu0SY7nWWiVm6OQCggZjC
czCJQqNQTjqwEg+vjztpAcY=
=K17h
-----END PGP SIGNATURE-----

--n8g4imXOkfNTN/H1--
