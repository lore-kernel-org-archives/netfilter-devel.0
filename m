From: Nigel Kukard <nkukard@lbsd.net>
Subject: ip_queue & QUEUE target
Date: Sun, 15 Jun 2003 17:53:52 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030615155352.GD2103@lbsd.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IDYEmSnFhs3mNXr+"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--IDYEmSnFhs3mNXr+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi all,

I have a very interesting problem, I have all packets passing through my
firewall being thrown to userspace with -j QUEUE, I them pick certain
packets and generate statistics.

My problem comes when I do a ping -f, at random times will my small
program just not receive any packets. I'm using ipq_read with a timeout
of 250000ms. I also get "Timeout" error messages when using ping -f.

I've tried to re-open the IPQ handle each time it fails, to no avail.


does anyone know how i can solve this problem?

Regars

Nigel Kukard


--IDYEmSnFhs3mNXr+
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+7JaQKoUGSidwLE4RAksWAJ4lpOtglzkuCezNH43eEZ3R5Ia12wCghKWM
MPlOI1NQelSpnVF3mBAXXY8=
=iVhx
-----END PGP SIGNATURE-----

--IDYEmSnFhs3mNXr+--
