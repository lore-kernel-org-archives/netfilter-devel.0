From: Harald Welte <laforge@netfilter.org>
Subject: [ANNOUNCE] ulogd-2.x reaches beta state
Date: Sat, 5 Nov 2005 18:03:30 +0100
Message-ID: <20051105170330.GF16000@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aZoGpuMECXJckB41"
Cc: ulogd@lists.gnumonks.org,
	Netfilter Mailinglist <netfilter@lists.netfilter.org>
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


--aZoGpuMECXJckB41
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

For those of you who are adventurous and willing to help:

ulogd-2.x (svn http://svn.gnumonks.org/branches/ulog/ulogd2/) has
actually reached a state where it produces useful logs ;)

If you want to tune in and help me with some contributions, don't
hesitate, download and build the latest svn version...

Currently working:

ULOG input plugin (like ulogd-1.x)
NFLOG input plugin (for nfnetlink_log via libnetfilter_log)
NFCT input plugin (for flow-based logging via libnetfilter_conntrack)

BASE filter plugin (interpretation of packet headers, ...)
PWSNIFF filter plugin (sniffing of POP3/FTP logins/passwords)
IFINDEX filter (ifnidex -> devicename resolval)

OPRINT output plugin (just prints all keys/values)
LOGEMU output plugin (print syslog-like file)
SYSLOG output plugin (really log via syslog(3))
PCAP output plugin (saves packets in pcap format)

TODO

- Port all the SQL plugins (mysql, pgsql, sqlite3) from ulogd-1.x
- Autoconf/automake detection of required libraries, only conditionally
  build NFLOG, NFCT, PCAP and sql
- Clean up dynamically allocated keys after plugin stack iteration
- Documentation
- Testing

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--aZoGpuMECXJckB41
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDbOXiXaXGVTD0i/8RAsI+AJ45CByx5j4iNg2HyUqAsrJlFJnAtACgqJHW
SLwgTHilbSQYkOpRp/+bBEg=
=P2aq
-----END PGP SIGNATURE-----

--aZoGpuMECXJckB41--
