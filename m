From: Harald Welte <laforge@netfilter.org>
Subject: Re: How to take over TCP connection from userspace process?
Date: Thu, 23 Oct 2003 10:53:48 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031023085347.GD1418@sunbeam.de.gnumonks.org>
References: <20031021134729.GB12049@sunbeam.de.gnumonks.org> <006f01c3984e$e045fce0$d32f110a@yrhd>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="s9fJI615cBHmzTOP"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: yangrunhua <yangrunhua@njupt.edu.cn>
Content-Disposition: inline
In-Reply-To: <006f01c3984e$e045fce0$d32f110a@yrhd>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--s9fJI615cBHmzTOP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 22, 2003 at 11:44:56AM +0800, yangrunhua wrote:

> What I need is: after I authenticated TCP connection A(host A
> connected to me) and TCP connection B(host B connected to me), then
> let what host A send (through TCP connection A)directly forward to
> host B(through TCP connection B) in the kernel ,meanwhile, what host B
> send directly forward to host A in the kernel.

> That's much like MSN Messenger Server's relaying webcam video stream
> between two peers after authenticated them. I want to do this relay in
> kernel space and auth in the userspace. It's much like NGN
> softswitch's theory: control and auth separate from transfer.

>=20
> That's much useful functionality. Can netfilter/iptables help this?
> done this by writing a new target or something?

no, it doesn't help.  What you are trying is intermixing of
packet-oriented paradigm with connection/stream oriented paradigm.

netfilter/iptables deals with individual packets.  So if you do NAT or
something, every packet that we receive is transmited  as another
packet. =20

If you accept a socket from userspace, than there's no more packets.  At
socket level you have a bidirectional stream of bytes.  So in order to
send the same data oever another socket, you need to re-packetize that
stream. In the end, you will have different packets with different
flags, sequencenumber, and eventually size (depending on mtu), window
scaling, options, ...

so _either_ you authenticate based on layer2 - layer4 addresses, and you
deal with packets, _or_ you authenticate somehow witin the TCP stream,
but than you don't have packets of a single connection, but rather two
seperate connections with each a stream of bytes in each direction.

This is not a limitation by netfitler/iptables.  It's about the
fundamentals of networking protocol layers.

> Thanks,
> 	Runhua Yang

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--s9fJI615cBHmzTOP
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/l5cbXaXGVTD0i/8RAqryAJ9ANabWM13EewqLlCKjCDhZkDx/zwCdF71F
lftls5ErA57dYKrklHcvuac=
=E/I0
-----END PGP SIGNATURE-----

--s9fJI615cBHmzTOP--
