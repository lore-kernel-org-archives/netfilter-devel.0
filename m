From: Harald Welte <laforge@netfilter.org>
Subject: Re: Documentation for the u32 module
Date: Thu, 13 Nov 2003 10:05:30 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031113090530.GB2301@obroa-skai.de.gnumonks.org>
References: <Pine.LNX.4.44.0311122329290.22726-100000@sparrow>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gatW/ieO32f1wygP"
Cc: ML-netfilter <netfilter@lists.netfilter.org>,
	ML-netfilter-devel <netfilter-devel@lists.netfilter.org>,
	webmaster@netfilter.org, Don Cohen <don-nfil@isis.cs3-inc.com>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: William Stearns <wstearns@pobox.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0311122329290.22726-100000@sparrow>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--gatW/ieO32f1wygP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 12, 2003 at 11:37:39PM -0500, William Stearns wrote:
> 	I had some initial difficulty understanding the u32 kernel module.
> I thought I'd write up a combination tutorial and set of examples for
> people hoping to give the module a try.
> 	The article can be found at
> http://www.stearns.org/doc/iptables-u32.current.html .  I'll gladly accept
> corrections, suggestions, and submissions of additional examples of tests
> that can be performed with u32.
> 	Don has had a chance to review the article and has indicated that
> he's OK with having a pointer to this article in patch-o-matic.  Is that
> OK with the core team, and if so, what's the easiest way to add a link to
> it?  Could this also be added to the documentation "tutorials" section?

sure, I'd be happy to add it to the homepage and patch-o-matic.
However, I'd actually prefer if it could be added to the
netfilter-extensions HOWTO.  This would give people a chance to learn
about all the different targets/matches at a single location.

Bill, in case you don't know the extensions HOWTO:
http://www.netfilter.org/documentation/HOWTO//netfilter-extensions-HOWTO.ht=
ml

Would you be willing to merge your u32 documentation with that?

> 	Cheers,
> 	- Bill

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--gatW/ieO32f1wygP
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/s0laXaXGVTD0i/8RAmqnAJ9RgVVgdVMwaQAtHAIlSaT6NHaeTACggeK8
+sWy2vsLmO49XPGuFzwvaQs=
=r/Es
-----END PGP SIGNATURE-----

--gatW/ieO32f1wygP--
