From: Harald Welte <laforge@netfilter.org>
Subject: Re: IPtables performance (fwd)
Date: Fri, 2 May 2003 22:14:25 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030502201425.GP26924@sunbeam.de.gnumonks.org>
References: <20030429143442.GD684@naboo.intranet.astaro.de> <Pine.LNX.4.44.0305021921030.14737-100000@localhost>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mvuFargmsA+C2jC8"
Cc: netfilter-devel@lists.netfilter.org, Robert Olsson <robban@robtex.com>,
	John McEleney <john@netservers.co.uk>,
	Ben McKeegan <ben@netservers.co.uk>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Chris Wilson <chris@netservers.co.uk>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0305021921030.14737-100000@localhost>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--mvuFargmsA+C2jC8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 02, 2003 at 07:32:29PM +0100, Chris Wilson wrote:

> I agree completely that it's important for the kernel to verify that the=
=20
> ruleset does not break this condition by calling rules which are not=20
> valid from a given hook.

great :)

> However, it seems to me that it's only necessary to visit each rule once=
=20
> _and_ set the appropriate bit in the 'comefrom' bitmask. Once the bit is=
=20
> set, there's no use setting it again.

true.

> So it's only necessary to visit each rule once per hook, in order both to=
=20
> detect loops and mark the valid source chains (hooks).

also true.  (given that loops could be detected while still only visiting
every rule once)

> Therefore, if the patched code does actually succeed in visiting each rul=
e=20
> once, and detecting loops, and setting the appropriate bit in comefrom,=
=20
> then it's functionally equivalent to the original code, right?

yes. Are you claiming that it does so?

> Cheers, Chris.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--mvuFargmsA+C2jC8
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+stGhXaXGVTD0i/8RAn3xAJ9vyyOZSLo+YiZK3bdRzcHZADvd4ACeMuQc
nvFpMl7Z9xcd5/Xg5khZyIY=
=oP+d
-----END PGP SIGNATURE-----

--mvuFargmsA+C2jC8--
