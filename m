From: Harald Welte <laforge@netfilter.org>
Subject: Re: NAT for DirectConnect (NeoModus P2P protocol)
Date: Fri, 12 Sep 2003 23:18:01 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030912211801.GE4398@obroa-skai.de.gnumonks.org>
References: <1062896689.3f5a8431e07a6@www2.inbox.lv>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AjmyJqqohANyBN/e"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: jeeecha@inbox.lv
Content-Disposition: inline
In-Reply-To: <1062896689.3f5a8431e07a6@www2.inbox.lv>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--AjmyJqqohANyBN/e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 07, 2003 at 04:04:49AM +0300, jeeecha@inbox.lv wrote:
> I tried to write a conntrack and nat modules for DirectConnect protocol.

great.

> I have a slight problem with this though - DirectConnect uses
> both UDP (for search results) and TCP (for uploads/downloads). I took irc
> modules as an example and I got TCP connections working correctly.
> However with UDP only first returned search result gets past the router.
> I browsed the mailing list archive and only post related to this was about
> how the expectations work stating that only a single expectation is await=
ed.
>=20
> Is there a way to work around this?

There is another helper in patch-o-matic that does exactly the same
thing.  IIRC, it was the talk helper.

> They way DirectConnect performs search:
> IP --> SIP (search request on master TCP connection)
> IP <-- IP1 (search results from client 1 {UDP packet})
> IP <-- IP2 (search results from client 2)
> ... and so on ...
>=20
> Currently my code gets the first search result just fine, however further
> results do not drop into the module and thus do not get NATted.

so what you do is: You register an expectfn (which gets called when your
expected connection gets established).  Inside the expectfn, you re-add
the expectation by calling ip_conntrack_expect_related().

> Besides, I wonder why hasnt anyone written the modules for
> DirectConnect already...it is becoming widely used P2P file sharing
> protocol lately.

Well, I haven't even heared about it [since I'm not doing any p2p
networking].  Is it free?  Is there a free software implementation?  Is
there a free specification of the protocol?

> Jekabs
>=20
> P.S. I am not subscribed to the list, could you please send response
> directly to this mail?

sure.

please keep us posted about your progress with the helper!

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--AjmyJqqohANyBN/e
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/YjgIXaXGVTD0i/8RAoJ7AKCgNXzjRx2neLqJienFetbFq3d5jQCePzHq
jcY+BqpmZ3XFIW2pDkAX01A=
=N5qw
-----END PGP SIGNATURE-----

--AjmyJqqohANyBN/e--
