From: Netfilter Core Team <coreteam@netfilter.org>
Subject: [ANNOUNCE] Release of iptables-1.3.2
Date: Sun, 10 Jul 2005 17:05:48 +0200
Message-ID: <20050710150548.GK20465@sunbeam.de.gnumonks.org>
Reply-To: coreteam@netfilter.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7w6n1xPQJploaIC9"
Cc: lwn@lwn.net
Return-path: <netfilter-bounces@lists.netfilter.org>
To: Netfilter Announcement List <netfilter-announce@lists.netfilter.org>,
	Netfilter Mailinglist <netfilter@lists.netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-bounces@lists.netfilter.org
Errors-To: netfilter-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--7w6n1xPQJploaIC9
Content-Type: multipart/mixed; boundary="PeSRYlKeL81PHMwc"
Content-Disposition: inline


--PeSRYlKeL81PHMwc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

The netfilter coreteam proudly presents:

	iptables version 1.3.2

The final 1.3.2 version contains accumulated bugfixes to the
last 1.3.1 version.  No new targets/matches have been added.

The ChangeLog is attached to this mail.

Version 1.3.2 can be obtained from:

	http://www.netfilter.org/files/iptables-1.3.2.tar.bz2
	ftp://ftp.netfilter.org/pub/iptables/iptables-1.3.2.tar.bz2

Please also note: patch-o-matic-ng is Distributed as seperate package:=20
	ftp://ftp.netfilter.org/pub/patch-o-matic-ng/snapshot/
=09
More information can be found at the netfilter/iptables project homepage,
available at:

	http://www.netfilter.org/
	http://www.iptables.org/

Happy firewalling,

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--PeSRYlKeL81PHMwc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="changes-iptables-1.3.2.txt"
Content-Transfer-Encoding: quoted-printable

iptables v1.3.2 Changelog
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
This version requires kernel >=3D 2.4.0
This version recommends kernel >=3D 2.4.18

Bugs fixed from 1.3.1:

- Fix TCPLAG version
	[ Torsten Luettgert ]

- More error checking in SET target
	[ Michal Pokrywka ]

- Fix optflags value for OPT_LINENUMBERS
	[ Jonas Berlin ]

- Allow NULL init function in ip6tables plugins
	[ Jonas Berlin ]

- Don't allow newlines in LOG prefix
	[ Phil Oester ]

- Introduce ip_conntrack_old_tuple to userspace header copy
	[ Pablo Neira ]

- Fix connbytes command line parsing bug
	[ Piotrek Kaczmarek ]

- Ignore unknown arguments in libipt_ULOG=20
	[ Patrick McHardy ]

- Correct error in multiport manpage wrt. "--ports"
	[ Rusty Russell ]

- Fix CONNMARK save/restore=20
	[ Tom Eastep, Pawel Sikora ]

- Make sure chain name doesn't start with '!'=20
	[ Yasuyuki Kozakai ]

- Prevent user to specify negative ports in SNAT/DNAT
	[ Yasuyuki Kozakai ]

- Fix deletion of targets where kernel size !=3D userspace size=20
	[ Pablo Neira ]

- Fix save/restore of '! --uid-owner squid' problem in ip6t_owner
	[ Harald Welte ]

Changes from 1.3.1:

- Add ``--log-uid'' option to ip6t_LOG target
	[ Patrick McHardy ]

- Improve REDIRECT manpage
	[ Jonas Berlin ]

- Add a number of missing manpage snippets
	[ Jonas Berlin ]

- Include FIN bit in mask of "--syn" bits
	[ Harald Welte ]

- Release previously merged options from merge_opts(), reduces memory-usage=
 of
  ipt ables-restore dramatically=20
  	[ Pablo Neira ]

- OSF: changes to support connector notifications
	[ Evgeniy Polyakov ]

- Reduce code replication of parse_interface()=20
	[ Yasuyuki Kozakai ]

Please note: Since version 1.2.7a, patch-o-matic is now no longer part of
iptables but rather distributed as a seperate package
(ftp://ftp.netfilter.org/pub/patch-o-matic-ng/snapshot)


--PeSRYlKeL81PHMwc--

--7w6n1xPQJploaIC9
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFC0TlMNfqJzMqajVsRArdPAJ9vf3WsltceZPb0Y3ePf/tiCt6EAwCgjAhN
y4WY2mygeM9IEyNWnzRsyzQ=
=kFWd
-----END PGP SIGNATURE-----

--7w6n1xPQJploaIC9--
