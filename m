From: netfilter@interlinx.bc.ca
Subject: separation of sysctl and tcp-window-tracking patch?
Date: Thu, 31 Oct 2002 21:12:36 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021101021236.GA16306@pc.ilinx>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/04w6evG8XlLl3ft"
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


--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

There seems to be varied needs for netfilter specific /proc entries.
The tcp-window-tracking patch seems to me to have placed a /proc entry
point for netfilter most sanely at /proc/sys/net/ipv4/netfilter/.  I
would also like to have a sysctl/proc node to diddle with tunables in
my Amanda conntracking module.

Specifically the default of 180 seconds for a UDP stream is not long
enough on the control (master in netfilter parlance) connection of an
Amanda session, so I would like to override the master's timeout value
in my conntrack helper.  I have tested my theory with a hard coded
value and it work.  Now I would like to make it tunable by the
user/administrator.

I suppose I could pass an argument while loading the module, but using
sysctl (and/or /proc) just seems so much more sane.  But I digress,
greatly.

I am wondering if Jozsef and/or Harald would like to separate out the
creation of the /proc/sys/net/ipv4/netfilter/ node into a separate
patch for the rest of us to use, rather than having to make
tcp-window-tracking a prerequisite just to get a proc entry to use.

Thots?
b.

--=20
Brian J. Murrell

--/04w6evG8XlLl3ft
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.7 (GNU/Linux)

iD8DBQE9weMUl3EQlGLyuXARAo7EAJ9zcQn7p3684pdJlsyZa5OUsVMXrwCeNtgW
zVrMEcCoqQzksf+1tv3C5Bc=
=kiTF
-----END PGP SIGNATURE-----

--/04w6evG8XlLl3ft--
