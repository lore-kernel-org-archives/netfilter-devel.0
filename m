From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH 1/4] Fix expectaction mask dumping, take #3
Date: Thu, 16 Feb 2006 11:05:05 +0100
Message-ID: <20060216100504.GI15587@sunbeam.de.gnumonks.org>
References: <43EFF176.3070505@netfilter.org> <43F44794.1080203@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CkAEuVknXa3V+za6"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <43F44794.1080203@trash.net>
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


--CkAEuVknXa3V+za6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 16, 2006 at 10:36:20AM +0100, Patrick McHardy wrote:

> I'm not sure I understand. The new attribute still contains the same
> value as the netlink header, doesn't it? So userspace should currently
> have at least two possibilities to get the correct value:
>=20
> - use the value from the netlink header
> - use the value from the tuple that comes with the mask, as the first
>   part of your patch does. This seems most logically to me since the
>   mask and the tuple belong together.

I still dream about a connection with one end in ipv4 space and the
other in ipv6.  If we ever want to cover such a model, then the tuple
needs to include l3num.
--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--CkAEuVknXa3V+za6
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFD9E5QXaXGVTD0i/8RAqyLAKCzUhCC99Zig/ZXdlC6bkFS3MuItgCeJKeE
m5Ur2Vcca/jTtfHyG/JR22s=
=6dNc
-----END PGP SIGNATURE-----

--CkAEuVknXa3V+za6--
