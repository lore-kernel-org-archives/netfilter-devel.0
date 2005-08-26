From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH NF_CONNTRACK 2/2] kill unnecessary ntohs to compare
	tuples
Date: Fri, 26 Aug 2005 13:07:32 +0200
Message-ID: <20050826110732.GR4226@rama.de.gnumonks.org>
References: <200508161011.j7GABxcg028632@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0fZkDq/H4AmqaB8D"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Content-Disposition: inline
In-Reply-To: <200508161011.j7GABxcg028632@toshiba.co.jp>
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


--0fZkDq/H4AmqaB8D
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 16, 2005 at 07:11:58PM +0900, Yasuyuki KOZAKAI wrote:
>=20
> Hi, Harald,
>=20
> This patch kills unnecessary ntohs() in nf_ct_tuple_mask_cmp(). If we nee=
d to
> take care about byte order here, should use ntohl(). This bug was introdu=
ced
> when I changed size of 'all' from 16bits to 32bits. But in the first plac=
e,
> it's not necessary to do that because the byte order of all arguments are
> same.

thanks, applied.

Two comments though:

0) why was it made 32bit?
1) I think some of the debug print macros in nf_conntrack_tuple.h still
   have the '16bit assumption' and use ntohs.
2) I think we could and probably should cleanup the include paths.  The
   general policy seems to be that include/net/* is kernel-only, and
   include/linux/* is stuff that needs to be exposed to userspace.
   Since userspace has no reason to know about lots of the internals, we
   could move files like nf_conntrack_tuple.h to a newly-created
   include/net/netfilter/ directory.  I'm not yet sure whether that's a
   good idea or not.  Anyway, a good intermediate step might be to add=20
   "#ifdef __KERNEL__" sections to all those sections of nf_conntrack
   header files that are never used from userspace.
--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--0fZkDq/H4AmqaB8D
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFDDvf0XaXGVTD0i/8RAg82AKCEqvkdrXzOWUBZflICLAShcKiwbwCggO3A
Zvu0WxF1UJNWWaHgNuz1ApA=
=P0Eh
-----END PGP SIGNATURE-----

--0fZkDq/H4AmqaB8D--
