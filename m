From: netfilter@interlinx.bc.ca
Subject: tunable udp timeout (again)
Date: Mon, 9 Sep 2002 14:08:53 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20020909180853.GP7416@pc.ilinx>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Mh8CTEa8Ax54aLHp"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "'netfilter-devel@lists.netfilter.org'" <netfilter-devel@lists.netfilter.org>
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


--Mh8CTEa8Ax54aLHp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Just over a year ago I asked a question
(http://lists.netfilter.org/pipermail/netfilter-devel/2001-May/001217.html)
about whether the UDP (non-streaming -- i.e. session setup) timeout
could be configured on a rule-by-rule basis for protocols that require
more than the (default) 30 seconds to reply to a UDP request.

Daniel Stone replied
(http://lists.netfilter.org/pipermail/netfilter-devel/2001-May/001218.html):

  There was a long discussion about this (see: "[POLICY FLAW] UDP
  connection timeout" or somesuch), and it was decided that it
  wouldn't go in, and we'd all sit around waiting for a better
  solution to arrive :\

And Rusty also replied
(http://lists.netfilter.org/pipermail/netfilter-devel/2001-June/001350.html=
):

  It looks like the next approach to tweaking UDP should be a table
  inside the UDP module which defines behavior and timeouts for
  individual ports.  Of course, with a module param to modify/add to
  the table.

Has anything (more than
/proc/sys/net/ipv4/netfilter/ip_conntrack_udp_timeout) been done about
this problem?  ip_conntrack_udp_timeout is good for the general case
of UDP timeouts, but when 99% of the traffic falls within that timeout
and only 1% needs a longer timeout, it would be better to be able to
configure that 1% as an exception.

I agree that "auto-determination" of the timeout using a table and
port numbers is ideal, but if I were to patch iptables and netfilter
to allow the specification of a timeout on the iptables command line
would it be rejected as not the right solution or would be accepted as
an interim solution to the lookup table?

b.

--=20
Brian J. Murrell

--Mh8CTEa8Ax54aLHp
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.7 (GNU/Linux)

iD8DBQE9fOO0l3EQlGLyuXARAnfxAJwIQZF5L0IWWTfGSAJCjMZ1jKKL5ACfXIYd
HXojUd2WGYHQwQjBBGTcaM8=
=so7y
-----END PGP SIGNATURE-----

--Mh8CTEa8Ax54aLHp--
