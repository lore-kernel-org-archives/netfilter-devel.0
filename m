From: Harald Welte <laforge@gnumonks.org>
Subject: Re: [RFC] patch for invalid packet time from ULOG target of iptables
Date: Sun, 24 Aug 2003 17:00:24 +0200
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20030824150024.GF10987@sunbeam.de.gnumonks.org>
References: <20030824141600.93849.qmail@web40508.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xkXJwpr35CY/Lc3I"
Cc: linux-kernel@vger.kernel.org, ulogd@lists.gnumonks.org,
	Netfilter Development Mailinglist
	<netfilter-devel@lists.netfilter.org>
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
To: Alex Davis <alex14641@yahoo.com>
Content-Disposition: inline
In-Reply-To: <20030824141600.93849.qmail@web40508.mail.yahoo.com>
List-Id: netfilter-devel.vger.kernel.org


--xkXJwpr35CY/Lc3I
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 24, 2003 at 07:16:00AM -0700, Alex Davis wrote:
> I've just started playing with the ULOG target in
> iptables, and I've noticed that the 'timestamp_sec'
> member of the ulog_packet_msg_t struct paseed to
> the user is always 0 for locally generated packets.

This is a well-known behaviour (see the list archives of
netfilter-devel@lists.netfilter.org or ulogd@lists.gnumonks.org).

This is _NOT_ considered a bug, but a feature.

> I was thinking of patching the ipt_ulog_target
> function in net/ipv4/netfilter/ipt_ULOG.c to
> check if timestamp_sec is 0 and if so, set it
> to the current time by adding code to test
> 'timestamp_sec' after it's been set. E.g;

so how would you then differentiate in userspace between=20

a) a skb receive timestamp
b) a timestamp created within the ULOG target (which can be very
   different, think of async packets via QUEUE, etc.)

We definitely don't want to have one field in the packet that has
different semantics according from which hook it came in.

What ulogd currently does, is _always_ logging the userspace time,
disregarding the skb receive timestamp.  This is way closer to the LOG
target behaviuor anyway, since in this case the time is prepended by
syslogd (which just calls gettimeofday() from userspace).

--=20
- Harald Welte <laforge@gnumonks.org>               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
Programming is like sex: One mistake and you have to support it your lifeti=
me

--xkXJwpr35CY/Lc3I
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/SNMIXaXGVTD0i/8RArILAJ9HgJu2HfpmIdhjlsgn7pgFcXHr2ACgmeiV
42Z+ZcW5aweSJgApdPnfgNE=
=EMB3
-----END PGP SIGNATURE-----

--xkXJwpr35CY/Lc3I--
