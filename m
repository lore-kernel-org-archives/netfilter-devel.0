From: Harald Welte <laforge@gnumonks.org>
Subject: [gpel@mpex.net: multiple ports in ip_nat_irc]
Date: Sat, 12 Oct 2002 14:41:15 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021012144115.Z13233@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="s8GAKpHVZTOrGbze"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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


--s8GAKpHVZTOrGbze
Content-Type: multipart/mixed; boundary="yLCsp91D2sDKcV7m"
Content-Disposition: inline


--yLCsp91D2sDKcV7m
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Just forwarding it to here so it doesn't get lost...

--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--yLCsp91D2sDKcV7m
Content-Type: message/rfc822
Content-Disposition: inline

Return-Path: X-Sieve: cmu-sieve 2.0
Received: from mail by coruscant.gnumonks.org with spam-scanned (Exim 3.34 #1)
	id 17z62N-0005iY-00
	for laforge@gnumonks.org; Wed, 09 Oct 2002 03:53:23 +0200
Received: from endo.mpex.net ([80.239.136.137])
	by coruscant.gnumonks.org with smtp (Exim 3.34 #1)
	id 17z62N-0005iV-00
	for laforge@gnumonks.org; Wed, 09 Oct 2002 03:53:23 +0200
Received: (qmail 12213 invoked by uid 509); 9 Oct 2002 01:53:07 -0000
Received: from unknown (HELO etm.mpex.net) (gpel@mpex.net@80.239.136.130)
  by 0 with SMTP; 9 Oct 2002 01:53:07 -0000
Message-Id: <5.1.1.5.2.20021009024433.01e3d190@localhost>
X-Sender: gpel@mpex.net@localhost
X-Mailer: QUALCOMM Windows Eudora Version 5.1.1
Date: Wed, 09 Oct 2002 02:53:21 +0100
To: laforge@gnumonks.org
From: Gregor Lawatscheck <gpel@mpex.net>
Subject: multiple ports in ip_nat_irc
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed

Hi Harald,
I've noticed a problem concerning multiple ports with ip_nat_irc which I 
believe you maintain. It relates to ip_nat_irc 1.16 and ip_conntrack_irc 
1.20 but I can't see any changes addressing this in current CVS (which I 
don't manage to compile against my 2.4.19 kernel). I couldn't find anything 
on newsgroups or the web relating to this specific problem, so no 
unofficial patches appear to exist.

Whenever I enter the ports command say ports=6666 it will fail saying it 
can't register the port, however I input it as part of an array port
ports[0] = 6666; ports[1] = 6667; etc. it works. So something appears to go 
wrong converting the ports= from the command line to the ports array? 
Unfortunately my knowledge of C isn't good enough to debug this completely 
to just send a patch in, so I'm kindly asking to pass this on to you.

Other than that, thanks, great work with the module!

- Gregor

  



--yLCsp91D2sDKcV7m--

--s8GAKpHVZTOrGbze
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9qBhrXaXGVTD0i/8RAkAjAJ0clJiUS0vOCNqHrhUL5aoH/YqemQCfStG2
Ugi4gzSW3JdWPC6QiAdVp4Q=
=KMbx
-----END PGP SIGNATURE-----

--s8GAKpHVZTOrGbze--
