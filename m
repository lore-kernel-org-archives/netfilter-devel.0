From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH]: assorted patches
Date: Sat, 23 Aug 2003 20:37:40 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030823183740.GB10603@obroa-skai.de.gnumonks.org>
References: <Pine.LNX.4.44.0308191202001.28761-800000@gw.localnet>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GRPZ8SYKNexpdSJ7"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0308191202001.28761-800000@gw.localnet>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--GRPZ8SYKNexpdSJ7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 19, 2003 at 12:10:12PM +0200, Patrick McHardy wrote:
> Hi Harald,
> these are the patches we just talked about, everything is compile-tested,
> some are runtime-tested. Hope i didn't break anything by pom-ifying them.
> I decided to drop the skb->len patch for now.

Thanks, I've submitted them to CVS now.=20

Just a minor improvement for the future: please include one more
hirarchy in the patches, so I can cleanly apply them from within the
'netfilter' directory. (this way I cannot erroneously mix 2.4/2.5
patches up).

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--GRPZ8SYKNexpdSJ7
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/R7RhXaXGVTD0i/8RAjIDAKCP5+0yScRfPB7wkevfspSxe/wFzACgo57N
WLbQFPuzR3IUfe6uVvRW67k=
=wZhz
-----END PGP SIGNATURE-----

--GRPZ8SYKNexpdSJ7--
