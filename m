From: Harald Welte <laforge@netfilter.org>
Subject: Re: nf_conntrack
Date: Tue, 24 Feb 2004 10:21:37 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040224092137.GU13386@sunbeam.de.gnumonks.org>
References: <200312240144.KAA15346@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Wn0J+vu9+NMIXK57"
Cc: netfilter-devel@lists.netfilter.org,
	Rusty Russell <rusty@rustcorp.com.au>, jozef@sunbeam.gnumonks.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Content-Disposition: inline
In-Reply-To: <200312240144.KAA15346@toshiba.co.jp>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--Wn0J+vu9+NMIXK57
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

[explicitly Cc'ing rusty and jozsef since they did a lot of conntrack
work]

On Wed, Dec 24, 2003 at 10:43:20AM +0900, Yasuyuki Kozakai wrote:
>=20
> Hi, All,
>=20
> This is other version of L3 independent connection tracking.

Thank you very much.  Sorry for this extremely late reply, but I missed
your email from december and just noted it after the current follow-up
on this issue.

> In previous version, the l3 part in tuple is represented by "union" of IP=
v4
> and IPv6 address.
>=20
> And in this version, size of the l3 part in tuple varies with layer 3
> protocol.  Then it's more complex than the previous version, but can
> save memory spaces where many IPv4 connections are created.

Yes, this is definitely something we need.  Although I still don't like
the idea of having to explicitly allocate three pieces of memory
(2*tuple, 1*nf_conntrack) per new connection.  This will hurt connection
setup rate very badly, I expect :(

What I initially had in mind (but don't know if it can be implemented in
any reasonable way) was:

- have a static part of struct np_conntrack without tuples
- this static part contains a bitmask
- this bitmask determines which 'extension structures' are present at
  the end
- possible 'extension structures' might be:
	- ipv4 orig/reply tuple
	- ipv6 orig/reply tuple
	- ipv4 l3 protocol (and helper) data
	- ipv6 l3 protocol (and helper) data

I know it sounds very tricky.  We always guarantee the ordering of such
extension structures.  The nf_conntrack core would maintain a list of
slab caches for every reasonable combination of extensions structures. =20
The extension structures are always allocated in one chunk gogether with
the static nf_conntrack 'header'.

Extension structures would always be accessed via pre-defined macros
(which just add an offset depending on the bitmask)

Even thinking further, this would enable us to put more parts than just
the tuple into those extensions (let's say the nat or helper union).
This in turn means that we can make conntrack structures for the normal
case (ipv4 only, no helper, no nat) even smaller. =20

I'm not sure if it's worth performance-wise.  The benefits of such a
solution would be:

1) still one chunk of memory for any conntrack
	- one allocation at connection setup time
	- conntrack+tuple still physically close in memory instead of
	  having to dereference every tuple=20
2) potentially smaller conntracks even in the current 'normal' case
   (one of our long-term wishes)

As disadvantage I can see
1) difficult implementation with lots of macros/offset calculation
2) we'd have to determine which slab we came from at destroy() time
   [maybe save cachep in nf_contrack?]
3) slightly higher computational cost when we want to access extension
   structures (like tuples), since relative offset has to be calculated
   at runtime.

What do you think? =20

Rusty, Jozsef: Do you think it's worth the effort?
=20
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

--Wn0J+vu9+NMIXK57
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAOxehXaXGVTD0i/8RAh/QAJ9GlFQ5ktYTPOO7nJFENcadbYdFdgCgiib8
ahxu9MtEI4u/KO3stllgcGk=
=iDGJ
-----END PGP SIGNATURE-----

--Wn0J+vu9+NMIXK57--
