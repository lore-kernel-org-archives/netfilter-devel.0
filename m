From: Harald Welte <laforge@netfilter.org>
Subject: Re: The latest nf_conntrack
Date: Thu, 11 Nov 2004 08:41:18 +0100
Message-ID: <20041111074118.GI7525@sunbeam.de.gnumonks.org>
References: <200411010827.iA18RJGT024881@toshiba.co.jp>
	<20041108134709.GE12437@sunbeam.de.gnumonks.org>
	<200411102151.iAALpOKa016683@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+sHJum3is6Tsg7/J"
Cc: netfilter-devel@lists.netfilter.org, usagi-core@linux-ipv6.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Content-Disposition: inline
In-Reply-To: <200411102151.iAALpOKa016683@toshiba.co.jp>
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


--+sHJum3is6Tsg7/J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 11, 2004 at 06:51:23AM +0900, Yasuyuki Kozakai wrote:
> > yes.  I think it is even worth to change nf_conntrack_ipv4 to do it the
> > same way as ipv6 now does it.  But let's not change too many things at
> > the same time,
>=20
> Sounds good and it's challenging because we have to consider about IPv4 N=
AT.

Well, in the case of NAT having to enlarge the packet, we could fall
back to modifying the defragmented skb, and fragmenting it at
POST_ROUTING.

But as stated before, that's future extensions/enhancements.

> By the way, could you check copyright and so on ? I have no idea about
> the correct way. At least, nf_conntrack_l3proto_ipv6.c is written from sc=
ratch
> and has no problem, I think.

I've reviewed the copyright headers of each file, and I think they are=20
all fine the way you did them.

> And a lot codes are copied from ip_conntrack, I suspects that we can
> enumerate all Signed-off-by. How we should manage this ?

This is not neccessarry.  If somebody has already submitted a patch with
'signed-off-by' to the mainline kernel (and this patch is even included
in the tree), then we don't need to document this again.  At least from
a copyright point of view it doesn't make sense.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--+sHJum3is6Tsg7/J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFBkxeeXaXGVTD0i/8RAoaHAKCjmWRVCvsVVxbPuHuZEqLQZX7hLQCfeQdc
vUJ6KVbGS2f5PK84Lus9lD0=
=MT76
-----END PGP SIGNATURE-----

--+sHJum3is6Tsg7/J--
