From: Harald Welte <laforge@gnumonks.org>
Subject: Re: PPTP connection tracker
Date: Sat, 26 Jul 2003 18:37:43 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030726163743.GI14321@naboo>
References: <200307211915.23035.jjackson@vortech.net> <20030725224010.GG14321@naboo> <200307251959.28157.jjackson@vortech.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JSkcQAAxhB1h8DcT"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Joshua Jackson <jjackson@vortech.net>
Content-Disposition: inline
In-Reply-To: <200307251959.28157.jjackson@vortech.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--JSkcQAAxhB1h8DcT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 25, 2003 at 07:59:28PM -0400, Joshua Jackson wrote:
> While I can sympathize with the "it must be your problem" response,
> you didn't actually answer the question...=20

I did not mean to imply that it is your problem.  I was meaning: Please
provide me with more information so I can debug it.

> I was just curious if you had any feedback about it not working and if
> it was a known problem with the Jan 07 POM. If ANYONE has gotten it
> working, then I would know that it was something I needed to debug
> myself. I have a whole lot of other patches, many of which are network
> related, that go into the Wolverine kernel and just want to confirm
> wether the module is known to work or not.

Astaro Inc. (http://www.astaro.com/) is shipping the code in
patch-o-matic CVS to thousands of customers.  Only very occasionally, I
get problem reports.

> -The server version is Wolverine v1.1 from http://www.coyotelinux.com.

So it's poptop.

> -Nobody has submitted a log/conntrack output to me as the solution most o=
f=20
> them took was to simply unload the PPTP connection tracker so they could =
at=20
> least get a single connection

> If the POM code is known to work, I will probably work a little more at=
=20
> debugging it, otherwise I will focus on the CVS code. If all else fails w=
ill=20
> try to round up some log/packet dumps to send you. This is a commercial=
=20
> product and getting customers to modify and bring down production firewal=
ls=20
> is roughly equivalent to asking them to pull out a tooth and send it to m=
e.

To be honest, I don't remember about the bugs/status/issues of the
version contained in a version from more than six months ago.

Well, if you cannot reproduce yourself it in some known setup/scenario, I d=
oubt
I can start reproducing it at my site.

> > - probably also packet dumps/traces (tcpdump, ethereal) needed.
>=20
> tcpdump, maybe... it is an embedded application that is typically install=
ed=20
> onto small flash drives - not a whole lot of flexibility for utility=20
> installations and space for packet dumps. If need be I'll see if I can fi=
nd=20
> someone with it installed in a hard drive that is having the problems.

I'm sorry, but you sound a bit like a customer who has bought a certain
product with guaranteed features that are now not fullfilled.  Please be
aware there is a reason the code in patch-o-matic is in the 'extra'
repository, marked as status 'Beta' and still receives updates.

> As for the CVS POM, the web interface lists the pptp-conntrack stuff as=
=20
> predating the 01/07 release,=20

Where did you get that information from?
http://cvs.netfilter.org/netfilter/patch-o-matic/extra/pptp-conntrack-nat.p=
atch
lists the changelog, and clearly indicates that pom-20030107 contains
version 1.11, whereas CVS contains version 1.12

> grabbed the /netfilter-extensions/helpers/pptp/ stuff and manually wedged=
 it=20
> into 2.4.21, but can not push that out to production customers until I ha=
ve=20
> done enough testing to be certain I didn't break anything else in the=20
> netfilter code during the process.

sure.  But in order to know if your particular bug/problem was solved,
you would need a known-to-fail-with-the-old-code setup against which you
can verify.

> Joshua Jackson
> Vortech Consulting
> http://www.vortech.net

--=20
- Harald Welte <laforge@gnumonks.org>               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
Programming is like sex: One mistake and you have to support it your lifeti=
me

--JSkcQAAxhB1h8DcT
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE/Iq5WXaXGVTD0i/8RAs95AJ0YZysy3LjuqY1xMdegZ8l4wyD9qQCdEzMk
YP9xdXowaresKk8paTpg4to=
=GINS
-----END PGP SIGNATURE-----

--JSkcQAAxhB1h8DcT--
