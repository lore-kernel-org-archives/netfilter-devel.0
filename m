From: Harald Welte <laforge@netfilter.org>
Subject: Re: i wanna know exact difference between NETFILTER and IPTABLES
Date: Thu, 5 Feb 2004 17:53:47 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040205165346.GT25175@obroa-skai.de.gnumonks.org>
References: <Pine.LNX.4.44.0402042317330.19469-100000@filer.marasystems.com> <031901c3eb79$0ccbd140$2601010a@bluereef.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LCbsoPZWBRMqE7TI"
Cc: Henrik Nordstrom <hno@marasystems.com>,
	rohit persaie <persaie@yahoo.co.in>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Andrew Hall <temp02@bluereef.com.au>
Content-Disposition: inline
In-Reply-To: <031901c3eb79$0ccbd140$2601010a@bluereef.local>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--LCbsoPZWBRMqE7TI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 05, 2004 at 10:46:03AM +1100, Andrew Hall wrote:
> I remember reading quite awhile ago about a proposed change to both the
> interface iptables uses and the mechanics of kernel applied rule
> replacement. Something about being able to make singular atomic changes to
> each rule rather than replace whole tables. Can you (Henrik) or anyone el=
se
> shed some light on where this thinking currently stands, whether there's
> been a new specification generated to which the core developers are worki=
ng,
> or whether there is in fact some code. I understand that Harald had done
> some work on the iptables2 interface? Is this part of this new proposed
> interface?

Yes, it's now called pkttables rather than iptables2.  I think there is
some indication about this subject in the summary of the 2003 netfilter
developer workshop (SGML source at
http://cvs.netfilter.org/documentation/conferences/nf-workshop-2003-summary=
=2Esgml)

> I think everyone would be interested in a quick synopses of where things =
are
> broadly at, in the world of Netfilter.

I'm currently busy with the connection tracking synchronization code for
stateful failover, then there is patch-o-matic ng, some bugs in the
homepage generation tool (docbook-website), ...

but I'll pick up pkttables as soon as this is finished.

> Thanks,
> Andrew.
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--LCbsoPZWBRMqE7TI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAInUaXaXGVTD0i/8RAkAgAJ9hfaJTJeEkAgEg/3NEYo0uFCH39QCeP+S5
YwRAnEKkaEvltgNyByRKgH8=
=pr/O
-----END PGP SIGNATURE-----

--LCbsoPZWBRMqE7TI--
