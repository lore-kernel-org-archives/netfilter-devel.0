From: Christophe Saout <christophe@saout.de>
Subject: Weird DNAT + passive FTP bug
Date: Sun, 17 Sep 2006 14:55:05 +0200
Message-ID: <1158497705.9509.30.camel@leto.intern.saout.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-zz27d1kFhQRjydr/8R49"
Cc: xen-users@xensource.com
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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


--=-zz27d1kFhQRjydr/8R49
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hello,

I'm observing a weird bug with ip_nat_ftp in a somewhat more complicated
constellation. It's possible that XEN is also involved in this, but I'm
not sure.

What I'm trying to do is have XEN guest domains on a host, connected via
a bridge into a private network. The the privileged domain attaches to
this private network and acts as a NAT router to connect the internal
domains to the internet.

=46rom the internet, several ports are forwarded via DNAT to the internal
domains, like, among others, FTP.

Now everything works fine, just passive FTP is broken.

Between the internal host and the external network card the flow looks
like this.

  [ internal domain eth0 172.31.2.3 ]
                     |
      ... ...        |
  .----|---|----- vif3.0 ----.
  |    |   |        |        |
  |...-+---+----- xenbr0     |
  |                 |        |
  |               vif0.0     |
  |    172.31.1.1  int0      |
  |                 |        |
  | privil. domain NAT/route |
  |                 |        |
  | 213.xxx.xxx.xxx |        |
  `--------------- eth0 -----'

For some reason (deadlocks), XEN doesn't connect to xenbr0 directly but
via a loopback device (here vif0.0/int0), that just passes packets
through.

The only two devices carrying IP addresses and attaching to the IP stack
in the privileged domain are int0 (172.31.1.1) and eth0
(213.xxx.xxx.xxx). Filters allow Port 21 and ESTABLISHED,RELATED to
pass.

What's happening now, is that incoming packets on the FTP port on
213.xxx.xxx.xxx are DNATted to 172.31.2.3, and routed to the internal
domain. The FTP server responds, and the control connection works fine.
Active FTP also works. But for some reasons passive FTP fails. The
rewritten answer from the FTP server that contains the rewritten IP and
port number to connect arrives at the FTP client with a broken TCP
checksum.

The kernel is based on 2.6.18-rc7 (+ the latest Fedora XEN patch).

Note that I had to add a nf_reset() call to the loopback driver between
vif0.0 and int0 or conntrack would miserably fail due to the conntrack
stated being held between bridging netfilter and IPv4 netfilter. The
bridging netfilter has a NOTRACK in the mangle table, so that
effectively conntrack is only done between int0 and eth0. Except for
that passive FTP problem, everything else works just fine.


--=-zz27d1kFhQRjydr/8R49
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Dies ist ein digital signierter Nachrichtenteil

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBFDUWoZCYBcts5dM0RAlOjAJ9J0YXtnSmUkbPahT/89/z3ZW5iYACgh3No
p0oiyshj/62mLCogplyqkQc=
=TBo0
-----END PGP SIGNATURE-----

--=-zz27d1kFhQRjydr/8R49--
