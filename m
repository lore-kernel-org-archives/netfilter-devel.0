From: Harald Welte <laforge@netfilter.org>
Subject: Re: Any planned work on supporting SIP?
Date: Tue, 4 Mar 2003 20:31:52 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030304193152.GM4880@sunbeam.de.gnumonks.org>
References: <69BCCDDC980B4641BFC908D7BF95F1840463075F@exchsrv-eng>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qLni7iB6Dl8qUSwk"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: William Luk <William.Luk@cosinecom.com>
Content-Disposition: inline
In-Reply-To: <69BCCDDC980B4641BFC908D7BF95F1840463075F@exchsrv-eng>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--qLni7iB6Dl8qUSwk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 04, 2003 at 10:55:49AM -0800, William Luk wrote:
> Harald,
>=20
> Is there any planned work on supporting SIP?  I am chatting with several
> people off line and they seems pretty eager.

There have been plans, yes.  Unfortunately I cannot start a project of
this size in my sparetime... maintainance of netfilter/iptables, fixing
the bugs and doing the stuff pending for 2.5.x ready is already eating
up more time than I can afford.

SIP conntrack/nat is even more complex than H.323 and we will need
several modifications to the conntrack/nat core in order to support it
at least for the most common SIP scenarios...

The company who wanted to sponsor SIP seems to have lost interest, and
without any other [corporate] sponsorship, I myself will not be able to
work on SIP conntrack/nat.

> Thanks,
> William

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--qLni7iB6Dl8qUSwk
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+ZP8oXaXGVTD0i/8RAqOHAJ4kDN8r9Tbk5+LaXZEwGWPMO3KImACfeF1x
UJqZxPKbTmz8HHfdlSD5LC0=
=emcQ
-----END PGP SIGNATURE-----

--qLni7iB6Dl8qUSwk--
