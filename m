From: Harald Welte <laforge@netfilter.org>
Subject: Re: ip_nat_irc
Date: Tue, 17 Jun 2003 18:35:33 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030617163533.GM936@naboo>
References: <20030603183843.GA16612@tron.yok.utu.fi>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="m+utxuhC6KVTvgNz"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Tero =?iso-8859-1?B?SuRua+Q=?= <tesaja@utu.fi>
Content-Disposition: inline
In-Reply-To: <20030603183843.GA16612@tron.yok.utu.fi>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--m+utxuhC6KVTvgNz
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 03, 2003 at 09:38:43PM +0300, Tero J=E4nk=E4 wrote:
> Hello there.
>=20
> Could you tell me how ip_nat_irc works? For the last two days I've been
> reading different HOWTOs, asking people on IRC etc. and I just can't get =
it
> work.

Well, certainly I can tell you how it is implemented - but I don't see
how this would help you...

> My situation is this. An external firewall, not controlled by me, is
> blocking all connections to my machine's tcp ports, except port 993.

ok.

> Therefore I would like to use ip_nat_irc to translate my DCC send and
> CHAT offers to use port 993. Is it possible with ip_nat_irc and SNAT?

No, at leat not without modifying the code.  And you can most likely
only do it on an intermediate router/firewall, not on the IRC client
machine itself.

> I added an iptables rule "/sbin/iptables -t nat -I POSTROUTING 1 -p tcp
> -s 130.232.130.88 -j SNAT --to-source 130.232.130.88:1024-2048".
> 130.232.130.88 is the machine's own IP. Then I did "/sbin/modprobe
> ip_conntrack_irc" and "/sbin/modprobe ip_nat_irc", connected
> to an irc-server port 6667 and sent a dcc send offer to myself, yet the
> port in the received dcc send offer was beyond the range of 1024-2048.
> What am i doing wrong here? (How does ip_nat_irc work?)

It works just like any other NAT helper module we have in netfilter.
Please see the netfilter hacking HOWTO about some information on this
topic.

The piece of code you might want to modify is about line 125 in
ip_nat_irc.c, the function is irc_data_fixup().  It basically tries to
find an unused port number.  If you hardcode this to port 993 and fail
if this port is unavailable, you end up with what you wanted to do.

If you are talking about a single irc client on a single machine, it
might sound way better to hack the irc client instead of the kernel
firwealling code, however.

> Tero J=E4nk=E4

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--m+utxuhC6KVTvgNz
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+70NUXaXGVTD0i/8RApAlAKCOKMwnHnAJQLW5BL/TVytM9IhahgCdHXbu
E8bnBkNTebRrCbsC6zzIJtY=
=xoIo
-----END PGP SIGNATURE-----

--m+utxuhC6KVTvgNz--
