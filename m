From: Harald Welte <laforge@netfilter.org>
Subject: [ANNOUNCE] netfilter-2.6.14 git tree / TODO
Date: Sun, 31 Jul 2005 10:01:43 +0200
Message-ID: <20050731080143.GA10374@rama.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YZ5djTAD1cGYuMQK"
Cc: Netfilter Mailinglist <netfilter@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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


--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

As you might have noticed, the pace of netfilter development has
_slightly_ changed over the last two weeks.  For those of you who are
intrested in joining the current development efforts (or even only
testing, which is definitely required), I suggest pulling the git tree
=66rom=20

rsync://people.netfilter.org/users/laforge/scm/netfilter-2.6.14.git

It is based on David Miller's net-2.6.14.git, and only contains those
new features and fixes that I intend to push to him soon (or have
already submitted but have not yet been included).

The areas of most work are currently nfnetlink, nfnetlink_log,
nfnetlink_queue and ip_conntrack_netlink (previously called ctnetlink).
Work in the kernel should be mostly finished, but the respective
userspace counterparts definitely need some work.

I've put together a quick TODO list at=20
	http://people.netfilter.org/laforge/TODO

Your help is greatly appreciated. Please contact me if you want to work
on any of these issues.

Thanks,
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

--YZ5djTAD1cGYuMQK
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFC7IVnXaXGVTD0i/8RAjyRAKCqmyUC7iawcZckAfl92vTQpoCr9gCgrpSO
3EZIRLL5KSzJEIn370duXWs=
=V/F/
-----END PGP SIGNATURE-----

--YZ5djTAD1cGYuMQK--
