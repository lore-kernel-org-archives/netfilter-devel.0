From: Harald Welte <laforge@netfilter.org>
Subject: Re: bug: -j REDIRECT broken with bridge in 2.6.0-test3
Date: Tue, 7 Oct 2003 12:00:15 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031007100015.GO18246@sunbeam.de.gnumonks.org>
References: <3F3AEDEF.2000108@metavize.com> <3F4A9AA7.2070604@metavize.com> <3F81E91F.5090304@metavize.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yQDbd2FCF2Yhw41T"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Dirk Morris <dmorris@metavize.com>
Content-Disposition: inline
In-Reply-To: <3F81E91F.5090304@metavize.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--yQDbd2FCF2Yhw41T
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 06, 2003 at 03:13:51PM -0700, Dirk Morris wrote:
> This is still present in 2.6.0-test6.
> I'm more than willing to help find this issue if someone gives me a=20
> pointer to go on.
> Narrowing it down to the changes in kernel versions is impossible due to
> the fact that the bridge wasnt working at all for quite a while.

I'm really sorry, but I don't have any 'easy' instructions on how to
hunt this down.  I've now added it to my TODO list, but I'm not sure
when I'll be able to dig into that problem.

Could you _pleae_ open a bugzilla.netfilter.org bug about this (if there
is none yet) to make sure this issue doesn't get lost?

> -dirk morris
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--yQDbd2FCF2Yhw41T
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/go6vXaXGVTD0i/8RAggcAJ0WNGnXiufodY0JSQ/sy3+HniBBVwCgkHNs
PrajsXxUxF78afcba0nbDws=
=L1Cx
-----END PGP SIGNATURE-----

--yQDbd2FCF2Yhw41T--
