From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH]: Fix ip_conntrack_core arguments to macros
Date: Mon, 14 Jul 2003 10:12:14 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030714081214.GH6538@naboo>
References: <Pine.LNX.4.44.0307121230550.30873-200000@gw.localnet>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gKijDXBCEH69PxaN"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0307121230550.30873-200000@gw.localnet>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--gKijDXBCEH69PxaN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jul 12, 2003 at 12:40:47PM +0200, Patrick McHardy wrote:
> Hi Harald,
> this patch fixes some places in ip_conntrack where LIST_FIND and
> LIST_DELETE are passed functions with their arguments (like
> LIST_FIND(ip_conntrack_hash[hash_conntrack(...)], ...). The argument is
> expanded twice, this leads to two calls to hash_conntrack.

ouch, now this is interesting.  I need to look into that further.

Thanks for the patch, give me another day to investigate (and apply)
this and your other patches.

> Best regards,
> Patrick

> BTW: nice talk yesterday, i've seen the slides before but it still was
> alot more interesting to here it directly from you. Sorry i didn't showed
> up anymore, i had to get some sleep fast after getting up at 7 in the
> morning (and drinking too much beer) ;) Are you still at linuxtag ?

Yes, a real pity.  I was expecting to have some chat with you.
Unfortunately I needed to cut down my linuxtag visit to a single day
(just friday to give my presentation) due to a personal issue :(

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--gKijDXBCEH69PxaN
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE/EmXdXaXGVTD0i/8RAikeAJ9Q5K2bNsZFzO8NEazaLVHh0PoMUQCgqIZO
m9UcjOH/bQi1aJ10l8XPQJs=
=Boao
-----END PGP SIGNATURE-----

--gKijDXBCEH69PxaN--
