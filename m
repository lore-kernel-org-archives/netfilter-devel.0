From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH 2/2] ipt_hashlimit.c: hash only once
Date: Tue, 22 Feb 2005 12:08:01 +0100
Message-ID: <20050222110800.GL29256@sunbeam.de.gnumonks.org>
References: <421428F2.4030404@cookinglinux.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Dy3pjCZLf6+6NySR"
Cc: netfilter-devel@lists.netfilter.org
To: sjean@cookinglinux.org
Content-Disposition: inline
In-Reply-To: <421428F2.4030404@cookinglinux.org>
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


--Dy3pjCZLf6+6NySR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 17, 2005 at 12:17:38AM -0500, Samuel Jean wrote:
> Name: hash only once
> Status: Tested on Linux 2.6.10.
>          Patch against 2.6.11-rc4-bk2
>          Incremental to previous hlist_head patch [1/2]
> Signed-off-by: Samuel Jean <sjean@cookinglinux.org>
>=20
> Harald: this patch might be crap.
>=20
> I couldn't find the reason on why we initialize random seed only on first=
=20
> entry.

my reasoning is the same like for the ip_conntrack hash:  We don't have
random seed at immediate system startup.  However, at the point we see
the first packets, we have a higher probability of having collected
entropy.

Not sure whether it can be compared to ip_conntrack, which will create
it's hashtable definitely before any entropy is available when the
module is statically linked.

With ipt_hashlimit, we create the hash table at iptables rule loadtime,
which ideally should be after the rng has gathered some entropy.

On a side note:
The wohle entropy issue in embedded networking is a real problem.  A lot
of devices don't want to limit flash lifetime by writing the random seed
at shutdown into flash and re-read it at startup.  Also, a number of
network drivers doesn't set the SA_RANDOM (or whatever it's called) flag
for the netork interrupts.=20

> This patch move the seed initializing at hashtable creation. So we can ha=
sh=20
> only once to find and create.

I like the optimization, but am still undecided.  Let me first integrate
your hlist changes ;)

> Patch is inlined and attached as I'm dumb and dunno how to inline the=20
> attachement.

I personally prefer attachments, and I think it's pretty standard these
days.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--Dy3pjCZLf6+6NySR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFCGxKQXaXGVTD0i/8RAvnCAJ4vH/hXzW8RAT9IJMJLH6h4I+3TQgCeKDiX
LgU8vpmC/o/Ehq3cDOxV8dE=
=XpgF
-----END PGP SIGNATURE-----

--Dy3pjCZLf6+6NySR--
