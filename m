From: Harald Welte <laforge@netfilter.org>
Subject: [ANNOUNCE] netfilter.org systems downtime
Date: Fri, 22 Aug 2003 16:41:05 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030822144105.GE11901@sunbeam.de.gnumonks.org>
Reply-To: coreteam@netfilter.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GYkYyJI7bObpCn+O"
Cc: Netfilter Mailinglist <netfilter@lists.netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	netfilter-workshop@lists.netfilter.org, coreteam@netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Announcement List <netfilter-announce@lists.netfilter.org>
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


--GYkYyJI7bObpCn+O
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

Due to an unfortunate event [*] the main netfilter.org system had become
unavailable from Aug 19 to Aug 22.  =20

The long downtime was caused by the netfilter developer workshop, which
distracted the netfilter developers from doing any system
administration.

This caused all @netfilter.org mail addresses, the mailinglist, CVS,
rsync, ftp and www access to be unavailable.

I have now migrated the www, ftp, rsync, anoncvs and mail services to
different machines.  However, bugzilla.netfilter.org and CVSweb as well
as the list archives will remain unavailable until the replacement
server is activated.

The replacement server will be in place at some point this evening/night
and should be up by midnight GMT.

All your pending emails will be delivered, since we have plenty of backup=
=20
MX'es.

We are sorry for the inconvenience, but assure you that we are doing
everything we can to minimize downtime.

Special thanks to Florian Sippel <fun@noris.net> and Alexander Ruff
<ruff@exodus.franken.de>, who are taking care of physically replacing
the servers (hosted 500km away from my current location).

[*] We will provide more details about the exact type of event soon

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--GYkYyJI7bObpCn+O
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/RiuBNfqJzMqajVsRApZNAJ9qXFyDVyOA+kWGZIMBY5t8xmWhGQCgpKdz
mYw4QDzgAqHgD61JRX5i2W4=
=yBsE
-----END PGP SIGNATURE-----

--GYkYyJI7bObpCn+O--
