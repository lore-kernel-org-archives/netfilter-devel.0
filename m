From: Harald Welte <laforge@netfilter.org>
Subject: Re: nf_conntrack (l3 independent conntrack)
Date: Sat, 29 Nov 2003 18:56:22 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031129175622.GN3181@obroa-skai.de.gnumonks.org>
References: <20031119132444.GW5075@sunbeam.de.gnumonks.org> <200311261126.UAA26305@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wKTlTxfx0Fr6BT7S"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Content-Disposition: inline
In-Reply-To: <200311261126.UAA26305@toshiba.co.jp>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--wKTlTxfx0Fr6BT7S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 26, 2003 at 08:25:18PM +0900, Yasuyuki Kozakai wrote:
>=20
> Hi, Harald and all,

Hi Yasuyki, sorry for my delayed reply.

> -------------------------------------------------------------------------=
----
> 1. I think one of benefits of L3 indepedent conntrack is that the various
> L3 connection can be represented with only one structure -- tuple.

indeed.

> For example, we can represent IPv4-IPv6 translated packet with
>=20
>     Original: ipv4_addr1, port1 -> ipv4_addr2, port2
>     Reply   : ipv6_addr2, port2 -> ipv6_addr1, port1
>=20
> Probably, we need to reallocate tuple somewhere to create this tuple.
> Because when received initial packet in this connection, the core module
> create:
>=20
>     Original: ipv4_addr1, port1 -> ipv4_addr2, port2
>     Reply   : ipv4_addr2, port2 -> ipv4_addr1, port1
>=20
> so the size of tuple "Reply" need to be changes. But if we adopt the way =
in
> white paper, this mean that we have to reallocate nf_conntrack.
> Moreover, the size of nf_conntrack is different from ip_conntracck and
> ip6_conntrack. So slab caches for all case of Original-Reply are needed.

well, yes.  But I don't think we should care too much about the corner
cases.  In a realistic setup, we would mainly have two sizes:

1) nf_conntrack + 2*tuple_ipv4
2) nf_conntrack + 2*tuple_ipv6

In case of an ipv4-ipv6 connection, I would just use tuple number two
and represent the ipv4 end as ipv6-mapped-ipv4 address.

> Then I suggest that
> 	- nf_conntrack has only static part and tuple_hash, and
> 	  tuple_hash include the pointer to tuple
> 	- tuple is allocated from different slab caches.
>=20
> We can save memory spaces and utilize slab cache in this way. The
> disadvantages are that
> 	- The management of nf_coonntrack become more complex.
> 	- If L4 part in tuple should be handled as dynamic part, we can't
> 	  adopt this approach.

one problem is also that we would have to allocate three items for every
new connections, which is bad.  I think we should have two slab caches,
one with v4 tuples, one with v6 tuples.  Depending on the type of
connection, we chose either.

> ... or, shouldn't we assume such a above connection ?

In that case, we might have to reallocate the connection.  but ipv4-ipv6
nat should be the corner case, and in that case we can afford a second
allocation.  two allocations in that rare case is still less than three
in every case.

> 2. Do you think which is better ? Or do you have other idea ?
>=20
> 	a. define ip_conntrack_tuple and ip6_conntrack_tuple.
> 	b. define only nf_conntrack which has "size" and "data[0]" in L3 part.
>=20
> If we choose a., we have to make L3 module operate tuple, so have to sear=
ch L3
> module every operations.=20

I think we should have something like

struct nf_conntrack {
	struct list_head;
	int foo;
	int bar;

	union {
		struct nf_conntrack_ipv4 ipv4[0];
		struct nf_conntrack_ipv6 ipv6[0];
	} l3;
};

this way we can dereference all fields without any typacasting or manual
pointer calculations..

> And BTW, the name "nf_conntrack" is already used in sk_buff.h . I use
> "nf_conn" in my code for now...

mh.  I'd rather rename nf_conntrack in sk_buff.h ;) but that's a minor
case.

> Yasuyuki KOZAKAI

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--wKTlTxfx0Fr6BT7S
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/yN3FXaXGVTD0i/8RAr8CAKClq+KLotarEBdUACFnRHNqRcWMiQCeKLkV
3EsneNmZNBceAuI7XmlRGWo=
=vWoB
-----END PGP SIGNATURE-----

--wKTlTxfx0Fr6BT7S--
