From: Harald Welte <laforge@netfilter.org>
Subject: Re: nf_conntrack (l3 independent conntrack)
Date: Tue, 18 Nov 2003 17:51:38 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031118165138.GO5075@sunbeam.de.gnumonks.org>
References: <20031113010159.GD835@mea-ext.zmailer.org> <200311131303.WAA28664@toshiba.co.jp> <20031115105020.GI656@obroa-skai.de.gnumonks.org> <200311180305.MAA20518@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="e5bfZ/T2xnjpUIbw"
Cc: netfilter-devel@lists.netfilter.org, usagi-core@linux-ipv6.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Content-Disposition: inline
In-Reply-To: <200311180305.MAA20518@toshiba.co.jp>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--e5bfZ/T2xnjpUIbw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 18, 2003 at 12:04:49PM +0900, Yasuyuki Kozakai wrote:

> > However, I'll attach the current (icomplete) start of my paper to this
> > email and also put it in CVS. =20
>=20
> I read. It's very usefull to implement nf_conntrack. Thank you.

Well, I doubt it is, but anyway ;)

> >      * Size of Addresses. ip_conntrack keeps two address tuples
>=20
> OK, I understand this problem, but I don't perfectly understand the detai=
l of
> your solution.=20
> Is "The dynamic part" equal to tuple ? or does this part include the priv=
ate
> structures for L3, protocol, and helper ?

There is a static part.  The static part would countain everything that
exists for connections of any protocol.  An (incomplete) list of static
structure members would be:=20
- usage count
- list_head's for the hash table[s]
- pointer to the l4 helper (->proto)
- pointer to the l3 helper (new)

In the first step, the static part would also contain:
- list of expected connections
- union for conntrack helper
- union for nat helper

However, my real idea was some mechanism where the conntrack core can
deal with what I now call 'extensible conntracks'.   The size of the
conntrack would be determined at 'NEW' time, i.e. when we receive the
first packet.  I.e. if it is an ipv4 packet, we only need ipv4-sized
tupels.  If there is no helper registered for that connection, there is
no need to allocate the memory for expect_tuple_list and others.

In the 'perfect world', we would thus have several different sized
kmem_cache's:

- struct ip_conntrack for ipv4, no helper
- struct ip_conntrack for ipv4, with helper
- struct ip_conntrack for ipv6, no helper
- struct ip_conntrack for ipv6, with helper

I think we can save a lot of memory, if we not only seperate the
l3-specific part (tuple), but also the expectation-specific part.  I
guess in most installations, 99.9% of all connections don't have a
helper - and thus no expectations.

And to reply to your question: The tuple is part of the 'dynamic' part,
along with other fields.

> > net/ipv4/netfilter/nf_conntrack_ipv4.c
> > - init()
> >         - register with nf_conntrack core. tell it the size of the l4
>=20
> I think it is not l4 but l3. Is this right ?
yes, sorry.

> Actually, I already started implementing L3 independent conntrack....

that is good news.  Your work is really appreciated.

> I'll send the patches as snapshot when I finish debugging.
> Or should I send them after I finish implementing above items ?

If possible, I think it is good to have the development as open as
possible.  It's not important that the code runs (or even compiles).
But if your current status of development was public, other netfilter
developers could have a look at the code and comment.

If you are interested, we oould also put it in the netfilter.org CVS
repository.

> Regeards,
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

--e5bfZ/T2xnjpUIbw
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/uk4aXaXGVTD0i/8RAmE0AJ0RWeTspvjz3N5JLEGf/c36xeonxwCfZaIv
gHRdBWCJQVMJWILLyFHX7J4=
=TrO0
-----END PGP SIGNATURE-----

--e5bfZ/T2xnjpUIbw--
