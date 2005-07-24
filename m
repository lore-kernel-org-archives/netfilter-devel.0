From: Harald Welte <laforge@netfilter.org>
Subject: Re: [NETFILTER]: Kill ebt_ulog
Date: Sun, 24 Jul 2005 13:25:39 -0400
Message-ID: <20050724172539.GB3873@rama>
References: <42E1ADB2.1080109@trash.net>
	<1122119412.4484.5.camel@localhost.localdomain>
	<42E267C8.9090005@trash.net>
	<1122148193.3382.16.camel@localhost.localdomain>
	<42E2A2E9.8050800@trash.net> <42E2C2E8.8010900@gmx.net>
	<42E2D0C9.7080808@trash.net>
	<1122196971.3382.6.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DBIVS5p969aUjpLe"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Bart De Schuymer <bdschuym@pandora.be>
Content-Disposition: inline
In-Reply-To: <1122196971.3382.6.camel@localhost.localdomain>
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


--DBIVS5p969aUjpLe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 24, 2005 at 09:22:51AM +0000, Bart De Schuymer wrote:
> Op zo, 24-07-2005 te 01:20 +0200, schreef Patrick McHardy:
> > > Please add ebt_ulog to Documentation/feature-removal-schedule.txt
> > > and give people the usual 6 month grace period to transition to
> > > the proposed feature-equivalent alternatives.
> >=20
> > It is _broken_ right now and conflicts with ipt_ULOG. There is no
> > point in keeping it broken for 6 month.
>=20
> Removing ebt_ulog would be stupid. So what if it conflicts with
> ipt_ULOG, there is no kernel panic, they just can't be used together
> currently.=20

Yes, you 'just' don't get logs of your security policy violations
anymore.  I think a lot of people would consider this a _serious_
security issue, one that even rectifies a security advisory.

So the code isn't broken _if_ it was using a different netlink family
number.  I'm not in a position to decide on whether to assign you one, I
can just tell you that reusing the number used by ipt_ULOG is causing
security problems and therefore is a bug. =20

If no new number can be assigned, I recommend putting in some KConfig
rule to prevent enabling both ebt_ulog and ipt_ULOG at the same time.

> That problem should be solved by the generic replacement.=20

yes, it is solved by it.  Patch will be posted any day.

> If the "generic" replacement is such that it can only be used by
> iptables modules then it is not generic at all.

The 'generic' replacement can be used by anyone in the kernel who wants
to log an skb.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--DBIVS5p969aUjpLe
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFC488SXaXGVTD0i/8RAuJ2AJ9bR2ZL8FOpDNetXx52SO6t4SKIFgCcC/+h
lhnYFRObmNw/pyh9O4sVXIE=
=sdUm
-----END PGP SIGNATURE-----

--DBIVS5p969aUjpLe--
