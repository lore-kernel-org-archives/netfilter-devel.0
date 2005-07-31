From: Harald Welte <laforge@netfilter.org>
Subject: Re: [ANNOUNCE] netfilter-2.6.14 git tree / TODO
Date: Sun, 31 Jul 2005 12:27:45 +0200
Message-ID: <20050731102745.GE14874@rama.de.gnumonks.org>
References: <20050731080143.GA10374@rama.de.gnumonks.org>
	<1122798262.18329.16.camel@www.l-chr.com.ar>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9crTWz/Z+Zyzu20v"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Christian Hentschel <chentschel@people.netfilter.org>
Content-Disposition: inline
In-Reply-To: <1122798262.18329.16.camel@www.l-chr.com.ar>
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


--9crTWz/Z+Zyzu20v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Christian, I'm cc'ing the list so others don't miss the explanations
below:

On Sun, Jul 31, 2005 at 05:24:22AM -0300, Christian Hentschel wrote:

> I'd like to help with some of these stuff.
> I'm thinking about the conntrack part of the TODO list.

great.  I'm currently working on libnfnetlink_{queue,log} and later
probably ulogd2, so there is no overlap.

> Anyways, i'll need some detail of what's needing to be done =3D).

well, when you want to do the 'conntrack' part, you first need to fix up
'libnfnetlink_conntrack' (and libct, which is part of 'conntrack'
itself).

The main changes on the kernel side have been:

1) everything inside a 'struct nfattr' (But not itself!) is now always
   int network byte order.  So the userspace code needs ntohl(),
   ntohs(), .. all over the place.  Special care needs to be taken for
   64bit values, since at least I am not aware of any standard/portable
   'ntohll' like functions.  So my idea was to implement them once and
   put them into libnfnetlink.

2) the _FLUSH messages have been removed.  sending a _DEL message with
   no further specification will match all entries and  therefore _is_ a
   flush.

3) the tuples are now built by nested attributes.  This means that we
   don't pass any kernel structures to userspace, but rather encapsulate
   every value in it's own attribute.  userspace needs to correctly
   parse this and put it into some userspace structures.  None of the=20
   library and application code should include anything from the kernel
   but include/linux/netfilter/nfnetlink*.h

4) some other messages have been renamed (RPLY -> REPLY). Mostly
   cosmetic.

After all this has been implemented, we can think of cleaning up the
layering between conntrack/libct/libnfnetlink_conntrack, but that's more
of a cleanup issue.  Let's make it functional first.

TIA,
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

--9crTWz/Z+Zyzu20v
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFC7KehXaXGVTD0i/8RAmHAAJ4vp5DfTMs10+NskyZgEO8g+NenTwCfXsSz
pvQJo4TndvduCeCe0hGtVg0=
=ojVX
-----END PGP SIGNATURE-----

--9crTWz/Z+Zyzu20v--
