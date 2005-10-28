From: Alexander Samad <alex@samad.com.au>
Subject: IPMARK nfcache
Date: Sat, 29 Oct 2005 08:17:28 +1000
Message-ID: <20051028221728.GC10248@samad.com.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QRj9sO5tAVLaXnSD"
Cc: Grzegorz Janoszka <Grzegorz.Janoszka@pro.onet.pl>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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


--QRj9sO5tAVLaXnSD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi

Recently went to path IPMARK (Patchlet from patch o matic) to a 2.6.14
source tree and I have noticed this compilation error

net/ipv4/netfilter/ipt_IPMARK.c: In function 'target':
net/ipv4/netfilter/ipt_IPMARK.c:36: error: 'struct sk_buff' has no
member named 'nfcache'
net/ipv4/netfilter/ipt_IPMARK.c:36: error: 'NFC_ALTERED' undeclared
(first use in this function)
net/ipv4/netfilter/ipt_IPMARK.c:36: error: (Each undeclared identifier
is reported only once
net/ipv4/netfilter/ipt_IPMARK.c:36: error: for each function it appears
in.)

on investigation the nfcache field from sk_buff has been removed, having
a look on the net as to why

I was wondering what mechanism is need to replace the 'ncfcache |
NFC_ALTERED' statement


Seem like it has been killed - gives me the impression I can remove this
line with no bad side effects ?

commit 6869c4d8e066e21623c812c448a05f1ed931c9c6
Author: Harald Welte <laforge@netfilter.org>
Date:   Tue Aug 9 19:24:19 2005 -0700

    [NETFILTER]: reduce netfilter sk_buff enlargement
   =20
    As discussed at netconf'05, we're trying to save every bit in
sk_buff.
    The patch below makes sk_buff 8 bytes smaller.  I did some basic
    testing on my notebook and it seems to work.
   =20
    The only real in-tree user of nfcache was IPVS, who only needs a
    single bit.  Unfortunately I couldn't find some other free bit in
    sk_buff to stuff that bit into, so I introduced a separate field for
    them.  Maybe the IPVS guys can resolve that to further save space.
   =20
    Initially I wanted to shrink pkt_type to three bits (PACKET_HOST and
    alike are only 6 values defined), but unfortunately the bluetooth
code
    overloads pkt_type :(
   =20
    The conntrack-event-api (out-of-tree) uses nfcache, but Rusty just
    came up with a way how to do it without any skb fields, so it's safe
    to remove it.
   =20
    - remove all never-implemented 'nfcache' code
    - don't have ipvs code abuse 'nfcache' field. currently get's their
      own
      compile-conditional skb->ipvs_property field.  IPVS maintainers
can
      decide to move this bit elswhere, but nfcache needs to die.
    - remove skb->nfcache field to save 4 bytes
    - move skb->nfctinfo into three unused bits to save further 4 bytes
   =20
    Signed-off-by: Harald Welte <laforge@netfilter.org>
    Signed-off-by: David S. Miller <davem@davemloft.net>



Thanks
Alex

--QRj9sO5tAVLaXnSD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFDYqN4kZz88chpJ2MRAu5YAKCoV6So6G2UNd/i7tCwyhse8YhIJACfVmFX
miP8fUiZt4s6P1Roz9bHDUM=
=x3GB
-----END PGP SIGNATURE-----

--QRj9sO5tAVLaXnSD--
