From: Harald Welte <laforge@gnumonks.org>
Subject: Re: bugzilla
Date: Fri, 17 Jan 2003 00:50:04 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030116235004.GI7774@sunbeam.de.gnumonks.org>
References: <1042750169.686.6.camel@tux.rsn.bth.se> <1042752014.688.12.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oLBj+sq0vYjzfsbl"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
Content-Disposition: inline
In-Reply-To: <1042752014.688.12.camel@tux.rsn.bth.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--oLBj+sq0vYjzfsbl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 16, 2003 at 10:20:14PM +0100, Martin Josefsson wrote:
> I should have looked at the 2.4.19->2.4.20 patch first.
> The problem is this: [...]

I see.

> so the problem is quite obvious. But I can't find any discussion about
> this break of backwardscompability anywhere (either it doesn't exist or
> I'm at leat partially blind :)

No, there was no discussion.  This was a patch by Marc Boucher, which
was pending for quite some time now.  And I have to admit that I didn't
think about the compatibility in this case.  Marc just passed it on to
me and asked me to submit it to the kernel.  No, I'm not blaming
anybody, at least not somebody besides me.

> The only solution is to recompile iptables (or atleast libipt_owner.c)
> against the new headers.

:( =20

Well, I guess there's nothing we can do about it now.  Changing it back
to the old format would be even more harmful :(

The real problem with issues like this is: Where do you document them in
a way that it is obvious for people to find out?  Maybe the first step
would be to have this bug (reported, accepted and resolved) in
bugzilla...  So if you could submit it, despite the fact that we have
now resolved it already?

> /Martin
--=20
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--oLBj+sq0vYjzfsbl
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+J0UsXaXGVTD0i/8RAt5HAJ4keiVRkMbZoDzynofpN3OKiYKGeACfXhe3
d7rkcI5XMdMeRfD7ZDyx5zQ=
=ir0O
-----END PGP SIGNATURE-----

--oLBj+sq0vYjzfsbl--
