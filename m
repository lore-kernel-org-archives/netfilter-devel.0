From: Harald Welte <laforge@netfilter.org>
Subject: Re: Rule optimization scheme openbsd-like
Date: Fri, 31 Oct 2003 08:59:20 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031031075920.GX7095@sunbeam.de.gnumonks.org>
References: <Pine.LNX.4.51.0310131004000.17633@dns.toxicfilms.tv> <20031014112305.GD3752@obroa-skai.de.gnumonks.org> <Pine.LNX.4.51.0310301350260.25629@dns.toxicfilms.tv>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KqBSqvdnnccM6+Kg"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.51.0310301350260.25629@dns.toxicfilms.tv>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--KqBSqvdnnccM6+Kg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 30, 2003 at 01:57:44PM +0100, Maciej Soltysiak wrote:
> > yes, that was something I always wanted to do but never got around
> > doing.  Actually I started it once, but didn't get very far.
> >
> > When I'm back home next weekend, I'll see if I can find that old piece
> > of document and send it to you.
> A long weekend :)
> Could you send me the document in free time ?

I didn't find it, unfortunately :(

but it would be great if you'd write one. the general rules are simple.
You major goal is:

- reduce number of rule iterations necessarry for every packet

everything else is just explaining the practical consequences of this to
the user, giving examples, ...

so you should try to branch into userdefined chains whenever possible
(usually one for every host in your dmz, one for related packets, etc.)

another good advice is:  don't replicate unneccessary matches. something
like:

iptables -A FORWARD -m state --state ESTABLISHED -j my_estab_chain
iptables -A my_estab_chain -m state --state ESTABLISHED -p tcp -j ACCEPT

in this case you have already matched against 'ESTABLISHED' before
jumping to the chain.  So every rule in the chain should _not_ have that
match replicated.

thanks!

> Maciej

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--KqBSqvdnnccM6+Kg
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/ohZYXaXGVTD0i/8RAvpHAKCyYvgyNt9i19slCyrUF89uK1tEBwCfQIEk
Rq3I+a4Ob6OBnJtVREqUTW0=
=Z75z
-----END PGP SIGNATURE-----

--KqBSqvdnnccM6+Kg--
