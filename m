From: Harald Welte <laforge@gnumonks.org>
Subject: Re: [PATCH] big endian patch against netfilter after PPTP NAT patch
Date: Mon, 3 Feb 2003 16:44:26 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030203154426.GG27870@sunbeam.de.gnumonks.org>
References: <771F217D7A4AF84494632457889470A487DCDC@bcmsg011.corp.ads>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oFMCfUPuRwe/HdF5"
Cc: "'netfilter-devel@lists.netfilter.org'" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Chris Poon <Chris.Poon@TELUS.COM>
Content-Disposition: inline
In-Reply-To: <771F217D7A4AF84494632457889470A487DCDC@bcmsg011.corp.ads>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--oFMCfUPuRwe/HdF5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 31, 2003 at 04:53:44PM -0700, Chris Poon wrote:
> This is related to the problems I found with expecting related connections
> on Sparc64 platform. This is really a patch against the PPTP NAT patch,
> which changed the unions in ip_conntrack_manip_proto and
> ip_conntrack_tuple from strictly a 16 bit union to a mixed 16/32 bit and
> 16/32/64 bit union (the later case in ip_conntrack_tuple.dst.u). The patch
> will only apply to ip_conntrack_tuple.h after the PPTP patch is installed,
> and I did the diff right on the file.

first of all, this was a known issue but I didn't yet have the time to
fix it.

> Issue stem from the assumption of little endian platform when the PPTP
> patch changed the unions, and compiler padding basically screw up the
> actual location of various fields. I have added the #ifdef around the
> dummy fields so it should be usable by every platform, and my tests show
> that expectations for related connections will now be found so I am one
> happy man.... other than the long kernel compile on my Ultra 10 (using
> an RedHat like kernel RPM build - PLD for those who are interested), it
> wasn't too hard to track down the problem, and now I wonder how many
> people are using big-endian machines to run iptables, let alone a sparc64.

I don't like this patch because:

1) there are non-64bit big endian machines, that don't need the padding
2) we should be able to have those structures and the respective
   functions working in a portable way, with no #ifdef's all over the place.
   Why is this so difficult? If all empty (padding) space is initialized
   to zero, and the fields addressed only by the member names, the mask
   compare should still work. Or am I missing something?

I have now added this whole issue to the bugtracking system, see
https://bugzilla.netfilter.org/cgi-bin/bugzilla/show_bug.cgi?id=3D41

> Enjoy

--=20
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--oFMCfUPuRwe/HdF5
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+Po5aXaXGVTD0i/8RApPRAJ9QMyg25TpOubL9XdMGvnTcQCLFQACgn4dy
YkAPDGm7GGQdX30a2jrPe/I=
=nYsg
-----END PGP SIGNATURE-----

--oFMCfUPuRwe/HdF5--
