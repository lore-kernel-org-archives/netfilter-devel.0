From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] ip_conntrack_pptp: fix endian sparse warnings
Date: Thu, 22 Sep 2005 15:03:12 +0200
Message-ID: <20050922130312.GL26520@sunbeam.de.gnumonks.org>
References: <20050921170539.GA10537@mipter.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OX2aLCKeO1apYW07"
Cc: netfilter-devel@lists.netfilter.org, Al Viro <viro@zeniv.linux.org.uk>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Content-Disposition: inline
In-Reply-To: <20050921170539.GA10537@mipter.zuzino.mipt.ru>
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


--OX2aLCKeO1apYW07
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 21, 2005 at 09:05:39PM +0400, Alexey Dobriyan wrote:
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>

Thanks.

> net/ipv4/netfilter/ip_conntrack_helper_pptp.c:
>=20
>    485		=3D=3D=3D>	cid =3D &info->pac_call_id;	<=3D=3D=3D
>    486=09
>    487			if (info->pns_call_id !=3D ntohs(*pcid)) {
>    488				DEBUGP("%s for unknown CallID %u\n",=20
>    489					pptp_msg_name[msg], ntohs(*cid));
> 							    ^^^^^^^^^^^
> However, comment at struct ip_ct_pptp_master::pac_call_id says "call id
> of PAC, host byte order". Is this a bug?

the bug is the DEBUGP statement.  it should be "ntohs(*pcid)".   I'll
fix it in my local tree.  I hope this addresses your concern.

I'll merge your patch and submit it via Davem later today.
--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--OX2aLCKeO1apYW07
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFDMquQXaXGVTD0i/8RAob4AJ0el92C0caCkmuCRn+hAC1S9nzjAwCgsgbO
EqVWpbN8tEJcnhRRVANqy60=
=zfU8
-----END PGP SIGNATURE-----

--OX2aLCKeO1apYW07--
