From: Harald Welte <laforge@gnumonks.org>
Subject: Re: [BUG] yet another icmp reply transition bug
Date: Thu, 31 Oct 2002 10:13:29 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021031101329.K8635@sunbeam.de.gnumonks.org>
References: <20021029211506.A26147@sunbeam.de.gnumonks.org> <20021030184457.GA7720@balabit.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="iQubofM0ARSW16RL"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Balazs Scheidler <bazsi@balabit.hu>
Content-Disposition: inline
In-Reply-To: <20021030184457.GA7720@balabit.hu>; from bazsi@balabit.hu on Wed, Oct 30, 2002 at 07:44:58PM +0100
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--iQubofM0ARSW16RL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 30, 2002 at 07:44:58PM +0100, Balazs Scheidler wrote:

> This is exactly the problem I have posted several times now. (I found it
> during my tproxy development). I have modified ICMP nat so that the inner
> packet is translated at the same time the outer packet is. I saw no real
> reasons to NAT ICMP packets in two phases (other than simmetricity).=20

Mh.  Somehow I never really understdood the implications and the significan=
ce
of your findings.  I'm sorry for my ignorance.

> When fixing the problem I came up with two solutions:
>=20
> 1) fix opposite_hook, and allow many possible points of inner header
>    translation (e.g. a manip in PREROUTING may mean ICMP reply in
>    POSTROUTING _or_ LOCAL_IN _or_ LOCAL_OUT)

This was my initial idea as well.  But it becomes horribly complex and
looks more like a hack - the kind of code where you need more comments
than code in order to make it half-way understandable :(

> 2) as the first one doesn't seem too robust to me, I fixed the translation
>    and did the whole thing in one step. The inner header is translated at
>    the same time the outer header is translated. I have seen no real use =
in
>    having the inconsistent (translated outer, and untranslated inner head=
er)
>    packet traverse the IP stack.

This sounds reasonable.  The question is: Do we ever have a case where we
cannot translate both, but still want the packet to be passed on?  But
in case of uncertainty, passing less information is preferred than yet anot=
her
information leak (about internal addresses, ...).

> I've posted my fix several times, I'll post it again if you like.

I'll pick it from the archives, thanks.

Expect more comments soon.

> Bazsi

--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--iQubofM0ARSW16RL
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9wPQ5XaXGVTD0i/8RAll5AKCz92BvICwnlIUfvhXOm19AGogULACcD2T/
NNT4X/zD6ByLiu9KBAbYrBg=
=j93W
-----END PGP SIGNATURE-----

--iQubofM0ARSW16RL--
