From: Harald Welte <laforge@netfilter.org>
Subject: Re: Fw: [Bug 133788] New: ip_conntrack_in: Frag of proto 17
Date: Wed, 29 Sep 2004 00:05:32 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20040928220532.GN29961@sunbeam.de.gnumonks.org>
References: <20040928130512.57479400.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IYV9cRr2u6rjcP4B"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
Content-Disposition: inline
In-Reply-To: <20040928130512.57479400.davem@davemloft.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--IYV9cRr2u6rjcP4B
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 28, 2004 at 01:05:12PM -0700, David S. Miller wrote:
=20
> If this is true, we need to fix this soon.

Agreed. =20

I think I've seen something similar in the past, though it was some
broken code in my experimental tree ;). ip_conntrack on an NFS server
has always had a bad history, I have to admit :(

Big question number 1:
First of all, why would a local loopback nfs mount do any fragmenting
in the first place?  'lo' has a MTU of 16k, so why would any piece of
code in the output path build fragments, even with rsize/wsize=3D8192?

The conntrack message basically means that at NF_IP_PRE_ROUTING we
suddenly see fragmented packets.  This "can never happen" since at the
same PRE_ROUTING hook we defragment just before
via ip_conntrack_defrag() -> ip_ct_gather_frags() -> ip_defrag()

Big question number 2:
How can a fragment survive ip_defrag() ?

Big question number 3:
What is this magic 8k limit?  ip_conntrack doesn't impose any arbitrary
size limitations to packets... and we just use the normal
defragmentation code.

I'm more than puzzled about this, need to do some testing.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--IYV9cRr2u6rjcP4B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFBWeAsXaXGVTD0i/8RAqjGAKCQ4QKUTb72RDu2cm2wo8Pj1BnLOgCePl+8
ClZqRV1ZHl63rHhlY1wDXx8=
=gEWF
-----END PGP SIGNATURE-----

--IYV9cRr2u6rjcP4B--
