From: Harald Welte <laforge@netfilter.org>
Subject: Re: New match ipt_geoip
Date: Sat, 6 Nov 2004 10:35:32 +0100
Message-ID: <20041106093532.GG12437@sunbeam.de.gnumonks.org>
References: <41899D17.7060800@cookinglinux.org>
	<20041105104217.GD5606@sunbeam.de.gnumonks.org>
	<4427.142.169.215.10.1099677041.squirrel@142.169.215.10>
	<Pine.LNX.4.58.0411052334590.21375@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6v9BRtpmy+umdQlo"
Cc: netfilter-devel@lists.netfilter.org,
	Samuel Jean <sj-netfilter@cookinglinux.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0411052334590.21375@blackhole.kfki.hu>
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


--6v9BRtpmy+umdQlo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 06, 2004 at 12:27:06AM +0100, Jozsef Kadlecsik wrote:
> I fully support the goal to unify related matches/targets in netfilter - I
> share the feeling we have too many similar of them. Probably ipt_geoip
> could be expressed and replaced by appropriate ippool/ipset definitions.

oh, of course.  But one could write a frontend for ipset that configures
the sets accordingly.   I don't suggest to abandon ipt_geoip without
providing a user interface that is equally easy to use.

> However, without peeking into the code of ipt_geoip, the idea seems to be
> quite special. The feature is compact, which can be grasped by the users
> easily, without the need to apply/tune special recipes/rules/settings.
> So it'd worth to add it to pom-ng, I believe.

ok, I agree, we have other way less useful stuff in it.  But it's not
going on 'kernel track'.

> Best regards,
> Jozsef

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--6v9BRtpmy+umdQlo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFBjJrkXaXGVTD0i/8RAgvBAJ9HAISkSZGQV5rm8s/UkFU698zclwCfVidP
UCNp0Mv1WbL7ZSwmyCOI/h4=
=r+ZJ
-----END PGP SIGNATURE-----

--6v9BRtpmy+umdQlo--
