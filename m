From: Thomas Mader <thezema@gmail.com>
Subject: remove connections notification by conntrack?
Date: Fri, 22 Sep 2006 13:59:14 +0200
Message-ID: <200609221359.22676.thezema@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart3371842.R8c0jZYHkP";
	protocol="application/pgp-signature"; micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

--nextPart3371842.R8c0jZYHkP
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hello,

We wrote a netfilter module which is using conntrack to distinguish differe=
nt=20
connections. We only need this for UDP "connections" and we use the followi=
ng=20
functions from conntrack to achieve that.

	proto =3D ip_conntrack_proto_find_get(skb->nh.iph->protocol);
	if (ip_ct_get_tuple(skb->nh.iph, skb, skb->nh.iph->ihl*4, &tuple,proto)) {
		h =3D ip_conntrack_find_get(&tuple, NULL);
		....
	}

We use the connection IDs of conntrack to distinguish between the connectio=
ns=20
within a list.
The problem we are having is that we also need to delete entries out of tha=
t=20
list if a connection is going to be removed but we didn't find a proper=20
solution to that.
We tried to define a function for ip_conntrack_destroyed but this doesn't s=
eem=20
to be called properly because when a UDP connection is removed=20
from /proc/net/ip_conntrack the function will not be called. Nevertheless t=
he=20
function is called but with, for us, unknown connection IDs and to strange=
=20
times.
This method also doesn't seem to be a good solution because NAT seems to be=
=20
using it and this would mean we would get troubles if our module is running=
=20
while NAT is running too.

We also tried the notifier system of conntrack with registering on it.=20
(ip_conntrack_register_notifier(&nb);)
But this doesn't seem to give us the needed information.

Now the question for us is, if we can somehow implement a nice solution for=
=20
this.
Does somebody know of such a solution?

Best regards,
Thomas Mader

--nextPart3371842.R8c0jZYHkP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iQIVAwUARRPQGhjLzKnHCDEhAQLwig/+OGLzfNhqhSmjDD9gG/PInFxkh34aKl5B
Uq0N5zwmAT8D2MExZaCym+gTFdE2YzgiRUzvmOLkXuNBazrSw0eC/e5mv84s5G6r
0YKVWfmInH5/1ouAGSHhaElxSjf7EtiMYq2O3KIGCMYN+T8hWjKAg5j41DJyiPqL
72yjQHpzz1I0HP4TRBLoBmeJtaLx7Ar4ivtS2IXnbuZjU3IMzlFFAb2a2T33KBsg
DvvzEQOb5Z29JAHo/qITbHgpIbmLIBxmngKgG0qkkReW2Qc3x/rexKlzLinOY2E7
0PNw722mub2tY/UN+zNMOOSq9v3Lp+IUijMCI2b5gDe7wrh1TOMk1aAQhyZ+Agu0
Fq94SXfrJrgBMiNtB4s6EfTz5v5URTFxxre6Iz1wx6QHcnBLGvgH6lo+3k6yKF0K
ZQq/i0G+Xf8dKxtJUoNdpWXwxLC8Vj/AU+DJ2z/EqejQx2dg6rFE4PH31+wRs2hm
pzFwLzZF1RYQlWBgesnYwcKl/6piujGVf6qrPv9K7EkI32TC5vkWXzUvXvLTvsVU
wAyuQZLklfgu9kMdAX1eS/Gyt9NXUZUMUoFVocruUaqczUtcm11iFCkodjMgE6ka
WrjIcch4se1X0DKbuk84eN/KH3aeLRwc9Avn6nc7SwhfEKM54PSSnf19bHi42geD
gGKI9J6HnQc=
=cjWK
-----END PGP SIGNATURE-----

--nextPart3371842.R8c0jZYHkP--
