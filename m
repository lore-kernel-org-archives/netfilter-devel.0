From: Harald Welte <laforge@netfilter.org>
Subject: Re: [RFC] Event Cache per-cpu
Date: Tue, 9 Nov 2004 18:13:19 +0100
Message-ID: <20041109171319.GG22257@sunbeam.de.gnumonks.org>
References: <418FC922.9080004@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0uCeA/GhJk5vQd80"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
Content-Disposition: inline
In-Reply-To: <418FC922.9080004@eurodev.net>
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


--0uCeA/GhJk5vQd80
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 08, 2004 at 08:29:38PM +0100, Pablo Neira wrote:
> Hi all,
> c) per packet cache. I don't see any possible race with this approach at=
=20
> the moment, but I'll need to use the nfcache field in skbuff. I prefer=20
> this than adding a new field to a skbuff, I think that Davem won't like=
=20
> that.

seems fine to me.

> There's 15 bits in nfcache available now (because IPVS guys are using=20
> one in private). My last patch has 11 events.

who authorized IPVS people to use that bit ? It's ours, and we fought
hard for it  ;)  [just kidding, but I didn't know that before].

> enum ip_conntrack_events
> {
>       IPCT_NEW,                       /* New conntrack                */
>       IPCT_RELATED,                   /* Expected connection          */
>       IPCT_DESTROY,                   /* Destroyed conntrack          */
>       IPCT_STATUS,                    /* Status has changed           */
>       IPCT_REFRESH,                   /* Timer has been refreshed     */
>       IPCT_PROTOINFO,                 /* Update of protocol info      */
>       IPCT_PROTOINFO_VOLATILE,        /* Volatile protocol info       */
>       IPCT_HELPER,                    /* New helper for conntrack     */
>       IPCT_HELPINFO,                  /* Update of helper info        */
>       IPCT_HELPINFO_VOLATILE,         /* Volatile helper info         */
>       IPCT_NATINFO,                   /* NAT info                     */
> };
>=20
> Patrick suggests that we could run out of bits soon if events go in=20
> nfcache, that's true. To fix that, could we remove this stuff in=20
> netfilter_ipv4.h, nobody is using it ?

No, I think this can be removed, nobody has ever used nfcache the way it
was originally intended.

> Please, comments welcome.
> Pablo

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--0uCeA/GhJk5vQd80
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFBkPqvXaXGVTD0i/8RAi0pAJ9HPxB21r/tLaNhhsFj/YNbeXNgaACggbZ5
nSyQKB8VS4Fo0WWqBGr8VTs=
=LfoW
-----END PGP SIGNATURE-----

--0uCeA/GhJk5vQd80--
