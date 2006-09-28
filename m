From: Netfilter Core Team <coreteam@netfilter.org>
Subject: Release of iptables-1.3.6
Date: Thu, 28 Sep 2006 19:21:09 +0200
Message-ID: <20060928172109.GN13764@sunbeam.de.gnumonks.org>
Reply-To: coreteam@netfilter.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MsEL38XAg4rx1uDx"
Cc: lwn@lwn.net
Return-path: <netfilter-announce-bounces@lists.netfilter.org>
To: Netfilter Announcement List <netfilter-announce@lists.netfilter.org>,
	Netfilter Mailinglist <netfilter@lists.netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-announce>,
	<mailto:netfilter-announce-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-announce>
List-Post: <mailto:netfilter-announce@lists.netfilter.org>
List-Help: <mailto:netfilter-announce-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-announce>,
	<mailto:netfilter-announce-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-announce-bounces@lists.netfilter.org
Errors-To: netfilter-announce-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--MsEL38XAg4rx1uDx
Content-Type: multipart/mixed; boundary="9/GiYV45wF7IL3Iq"
Content-Disposition: inline


--9/GiYV45wF7IL3Iq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

The netfilter coreteam proudly presents:

	iptables version 1.3.6

The 1.3.6 version contains accumulated bugfixes to the last 1.3.5
version.=20

The ChangeLog is attached to this mail.

Version 1.3.6 can be obtained from:

	http://www.netfilter.org/files/iptables-1.3.6.tar.bz2
	ftp://ftp.netfilter.org/pub/iptables/iptables-1.3.6.tar.bz2

More information can be found at the netfilter/iptables project homepage,
available at:

	http://www.netfilter.org/

Happy firewalling,

[As a personal side note, I'd like to add that even though I'm sending
 off this announcement, I haven't really been very active at
 netfilter.org for the last months.  This release really should be
 attributed to Patrick McHardy and all our contributors]

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--9/GiYV45wF7IL3Iq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="changes-iptables-1.3.6.txt"
Content-Transfer-Encoding: quoted-printable

Bugs fixed since 1.3.5:

- Fix segfault on loading of invalid counters in ip[6]tables-restore
  [ Bugzilla #437, Olaf Rempel ]

- Fix double-free if a single match is used multiple times within a single =
rule
  [ Bugzilla #440, Harald Welte ]

- Don't try to resolve "-p all" using getprotoent()
  [ Bugzilla #446, Harald Welte ]

- Refuse never matching protocol specifications for ip6tables
  [ Yasuyuki Kozakai ]

- Fix iptables-save output of osf match
  [ Daniel De Graaf ]

- Fix esp/connbytes detection with newer kernels (x_tables)
  [ Harald Welte ]

- Fix loading of IPCMv6 match shared library
  [ Yasuyuki Kozakai ]

- Refuse invalid esp match SPI ranges=20
  [ Yasuyuki Kozakai ]

- Fix out-of-bounds memory access when the unsupported "check" command was =
used
  [ Bugzilla #463, Larry Stefani, Harald Welte ]

- Fix out-of-bounds memory access when the "-c" option was used
  [ Bugzilla #462, Larry Stefani, Harald Welte ]

- Fix "Unknown error 4294967295" message
  [ Bugzilla #460, Patrick McHardy ]

- Use lower-case letters for realm match output
  [ Simon Lodal ]

- Fix example in connlimit manpage
  [ Phil Oester ]

- Refuse IP addresses as arguments to REDIRECT target
  [ Bugzilla #482, Phil Oester ]

- Fix set match negation
  [ Jozsef Kadlecsik ]

- Fix some compiler warnings
  [ Bugzilla #457, Phil Oester ]

- Refuse port ranges in ip6tables multiport match
  [ Bugzilla #451, Phil Oester ]

- Force user to specify --ipcmv6-type if ipcmv6 match is used
  [ Bugzilla #461, Yasuyuki Kozakai ]

- Fix libiptc symbol clash
  [ Bugzilla #456, Phil Oester ]

- Remove "hoho" message
  [ Pierre-Yves Ritschard ]

- Handle CIDR notation more sanely
  [ Bugzilla #422, Phil Oester ]

- Fix chain reference increment bug
  [ Jesper Brouer ]

- Fix counter clearing for policy counters
  [ Bugzilla #502, Andy Gay ]

- Remove warnings about interface names with non-alphanumeric characters
  [ Patrick McHardy ]

New features since 1.3.5:

- Support multiple matches of the same type within a single rule
  [ Jozsef Kadlecsik ]

- DCCP/SCTP support for multiport match (needs kernel >=3D 2.6.18)
  [ Patrick McHardy ]

- SELinux SECMARK target (needs kernel >=3D 2.6.18)
  [ James Morris ]

- SELinux CONNSECMARK target (needs kernel >=3D 2.6.18)
  [ James Morris ]

- Add documentation for DNAT target :<port> syntax
  [ Evan Miller ]

- Add new exit value to indicate concurrency issues
  [ Jesper Dangaard Brouer ]

- Use gcc to build shared objects
  [ Bugzilla #454, Phil Oester ]

- Update quota match for version in current kernel, fix -D (needs kernel >=
=3D 2.6.18)
  [ Phil Oester ]

- Update MARK target documentation to include --and-mask/--or-mask
  [ Eric Leblond ]

- Add support for statistic match (needs kernel >=3D 2.6.18)
  [ Patrick McHardy ]

- Optionally read realm values from /etc/iproute2/rt_realms
  [ Simon Lodal ]


--9/GiYV45wF7IL3Iq--

--MsEL38XAg4rx1uDx
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFFHASFXaXGVTD0i/8RAmauAJ42WXbDlqy59fhhvb7lW0coaHUb5ACfRcaK
x0RaHQ1Nq/bXi0ueKMvMBgU=
=klHg
-----END PGP SIGNATURE-----

--MsEL38XAg4rx1uDx--
