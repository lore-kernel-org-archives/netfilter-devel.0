From: Harald Welte <laforge@netfilter.org>
Subject: do_path() bug is not remotely or local non-root exploitable
Date: Wed, 22 Mar 2006 11:59:34 +0100
Message-ID: <20060322105934.GO21238@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Ca5z/wkVxIQXz1GF"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Netfilter Mailinglist <netfilter@lists.netfilter.org>,
	Netfilter Announcement List <netfilter-announce@lists.netfilter.org>
Content-Disposition: inline
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


--Ca5z/wkVxIQXz1GF
Content-Type: multipart/mixed; boundary="pTYhUwqpXRR/mkN7"
Content-Disposition: inline


--pTYhUwqpXRR/mkN7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

JFYI, see the attachment.

Securityfocus and some other news sites have spread rumour that the
do_path() bug fixed with 2.6.16 is remotely exploitable.

It is not.

Unless you are using virtualization techniques like Virtuozzo or
Vserver (where 'root' cannot neccessarily be trusted), there is not
really any security risk caused by this bug.  Stay cool.

Cheers,
	Harald (for the netfilter core team)

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--pTYhUwqpXRR/mkN7
Content-Type: message/rfc822
Content-Disposition: inline

Date: Wed, 22 Mar 2006 11:57:17 +0100
From: Harald Welte <laforge@netfilter.org>
To: vuldb@securityfocus.com
Cc: coreteam@netfilter.org
Subject: Wrong information on http://www.securityfocus.com/bid/17178/discuss
Message-ID: <20060322105717.GN21238@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="C6GqtNjDdnDsBy9k"
Content-Disposition: inline
User-Agent: mutt-ng devel-20050619 (Debian)


--C6GqtNjDdnDsBy9k
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

As a member of the netfilter core team, I would like to ask you to
immediately stop spreading false information about an allegeldy remotely
exploitable vulnerability that simply doesn't exist.

I don't know how you come to the conclusion at
http://www.securityfocus.com/bid/17178/discuss, that "This issue allows
remote attackers to overwrite kernel memory with arbitrary data,
potentially allowing them to execute malicious machine code in the
context of affected kernels."

The respective bug [called do_replace() bug] is in a code path that can
ONLY be executed by a local root user.  In fact, it is a bug in the
codepath for ruleset changes.

So unless you have a locally malicious root user (which could change the
ruleset anyway, and very likely load arbitrary code via kernel modules
or patch /proc/kmem), there is nothing that can be exploited.

Neither for local non-root users, not for any remote party.

Please correct information in your vulnerability data base as soon as
possible!  Your wrong assessment has already been picked up by some
other news sites, and users are starting to inquire the project about a
security threat that doesn't even exist.

Thanks in advance,
	Harald

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--C6GqtNjDdnDsBy9k
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)

iD8DBQFEIS2NXaXGVTD0i/8RAiAmAJ4lfd9v6nayxmxPoBCY3xiB/v99/gCaAvC2
qCMwcedXcDrwK+mshaE0TjI=
=K7I5
-----END PGP SIGNATURE-----

--C6GqtNjDdnDsBy9k--

--pTYhUwqpXRR/mkN7--

--Ca5z/wkVxIQXz1GF
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)

iD8DBQFEIS4WXaXGVTD0i/8RAtZAAJ47tzbsee984mJHVVGrWQqGWVtXUACfQSSW
Ugk9ha5fzg+MPticFko8thg=
=hrfX
-----END PGP SIGNATURE-----

--Ca5z/wkVxIQXz1GF--
