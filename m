From: Netfilter Core Team <coreteam@netfilter.org>
Subject: [ANNOUNCE] Release of iptables-1.2.8
Date: Sun, 13 Apr 2003 17:43:20 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030413154320.GS1922@sunbeam.de.gnumonks.org>
Reply-To: coreteam@netfilter.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Vy1A5eXR7jld12ZH"
Cc: lwn@lwn.net
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Announcement List <netfilter-announce@lists.netfilter.org>,
	Netfilter Mailinglist <netfilter@lists.netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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


--Vy1A5eXR7jld12ZH
Content-Type: multipart/mixed; boundary="N/GrjenRD+RJfyz+"
Content-Disposition: inline


--N/GrjenRD+RJfyz+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

The netfilter coreteam proudly presents:

	iptables version 1.2.8:

Version 1.2.8 is a maintainance release, containing dozens of small
bugfixes that have accumulated over the last months since 1.2.7a was
released in August 2002.

The ChangeLog is attached to this mail.

Version 1.2.8 can be obtained from:

	http://www.netfilter.org/files/iptables-1.2.8.tar.bz2
	ftp://ftp.netfilter.org/pub/iptables/iptables-1.2.8.tar.bz2

Please note that since iptables-1.2.7 patch-o-matic is no longer part of
iptables, but distributed as a seperate package.  You can obtain the
latest release and daily CVS snapshots from:

	ftp://ftp.netfilter.org/pub/patch-o-matic/
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

--N/GrjenRD+RJfyz+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="changes-iptables-1.2.8.txt"

iptables v1.2.8 Changelog
======================================================================
This version requires kernel >= 2.4.4
This version recommends kernel >= 2.4.18

Bugs Fixed from 1.2.7a:

- fix ip6tables-save function of 'length' match
	[ Gerry Skerbitz ]
- fix ip6tables-save function of 'mac' match
	[ Kristian Gronfeldt Sorensen ]
- fix iptables-save function of 'ULOG' target
	[ Jimmy Hedman ]
- fix iptables-save function of 'conntrack' match
	[ Lutz Pressler ]
- fix iptables-save function of 'length' match
	[ Gerry Skerbitz ]
- fix iptables-save function of 'mac' match
	[ Kristian Gronfeldt Sorense ]
- fix iptables-save function of 'mark' match
	[ Harald Welte ]
- fix iptables-save function of 'owner' match
	[ Costa Tsaousis ]
- fix iptables-save function of 'pool' match
	[ Oskar Berggren ]
- fix iptables-save function of 'tcpmss' match
	[ Michael Schwendt ]
- fix iptables-save function of 'tos' match
	[ Harald Welte ]
- fix save/print function of 'connmark' match
	[ Harald Welte ]
- fix error message when invalid TCP flag is specified with 'tcp' match
	[ Aaron Sethman ]

Changes from 1.2.7a:

- updated version of the ROUTE target
	[ Cedric de Launois ]
- updated version of the 'recent' match
	[ Stephen Frost ]
- update the RPC conntrack match, extend it to support filtering on procedures
	[ Ian (Larry) Latter ]
- add support for hexstrings to the 'string' match
	[ Michael Rash ]
- have iptables-restore print the line number in case of an error
	[ Illes Marci ]
- big iptables.8 manpage update
	[ Herve Eychenne ]
- print loglevel human-readable in ip6tables 'LOG' target
	[ Michael Schwendt ]
- print loglevel human-readable in 'LOG' target
	[ Michael Schwendt ]
- remove bogus code from 'ecn' match
	[ Stephane Ouellette ]
- be more specific in help message of 'helper' match
	[ Herve Eychenne ]
- fix semantic problem that '-p icmp -m icmp' was matching icmp type 0 instead
  of 'any'
	[ Harald Welte ]
- fix iptables rename-chain option
	[ Maciej Soltysiak ]
- remove libipulog from iptables since it is distributed with ulogd
	[ Harald Welte ]
- support new ip6tables 'HL' target
	[ Maciej Soltysiak ]
- support new ip6tables 'condition' match
	[ Stephane Ouellette ]
- support new ip6tables 'fuzzy' match
	[ Maciej Soltysiak ]
- support new ip6tables 'hoplimit' match
	[ Maciej Soltysiak ]
- support new iptables 'CLASSIFY' target
	[ unknown ]
- support new iptables TARPIT target
	[ Aaron Hopkins ]
- support new iptables 'condition' match
	[ Stephane Ouellette ]
- support new iptables 'fuzzy' match
	[ Hime Junior ]
- support new iptables 'physdev' match (for 2.5.x bridging)
	[ Bart de Schumyer ]
- support new iptables 'u32' match (based on u32 tc filter)
	[ Don Cohen ]

Please note: As of version 1.2.7a, patch-o-matic is now no longer part of
iptables but rather distributed as a seperate package
(ftp://ftp.netfilter.org/pub/patch-o-matic/)


--N/GrjenRD+RJfyz+--

--Vy1A5eXR7jld12ZH
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+mYWYNfqJzMqajVsRAk+dAJ40Vlu/EeyM52FE7pwTQ+AXKbEDzwCfXrIJ
uG+24Hhs6NsN8GMUqgWE81A=
=V5QA
-----END PGP SIGNATURE-----

--Vy1A5eXR7jld12ZH--
