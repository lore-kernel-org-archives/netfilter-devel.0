From: Sven Schuster <schuster.sven@gmx.de>
Subject: Re: NF_QUEUE examples
Date: Thu, 15 Apr 2004 19:25:08 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040415172508.GA6700@zion.homelinux.com>
References: <20040415162220.GA5747@maluco.com.br>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nFreZHaLTZJo0R7j"
Cc: Netfilter Devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Ulysses Almeida <munky@maluco.com.br>
Content-Disposition: inline
In-Reply-To: <20040415162220.GA5747@maluco.com.br>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--nFreZHaLTZJo0R7j
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 15, 2004 at 12:22:20PM -0400, Ulysses Almeida told us:
>   I alredy googled for this topic, but couldn't find any nice text
> about.
>=20
>   I want to understand more about NF_QUEUE return, and possibly use
> it. So, where can i find simple examples of using it? Or a text
> explaining about it.
>=20
>   What I understand, is: with NF_QUEUE, I can queue some packet to be
> manipulated on userspace. After this, can this packet be dequeued back
> to kernel space, and continue with it's journey? How can I write a
> userspace code, to handle with packetd queued bu NF_QUEUE? Or I didn't
> understand nothing about it?

You might want to take a look at net/ipv4/netfilter/ip_queue.c. This
registers a queue handler, delivers packets to user space via netlink
and reinjects them into netfilter when the packet is send back from
userspace.


HTH

Sven

>=20
>   Thanks for any help in advance!
>=20
> --=20
>     .~.  Ulysses Almeida
>    / V \  munky@maluco.com.br
>  / (   ) \  Seja livre, use GNU/Linux!=20
>    ^^-^^

--=20
Linux zion 2.6.5 #1 Sun Apr 4 19:56:55 CEST 2004 i686 athlon i386 GNU/Linux
 19:20:35  up 10 days, 20:04,  2 users,  load average: 0.06, 0.03, 0.00

--nFreZHaLTZJo0R7j
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQFAfsV0o4FAdB2PneQRAn9oAJ9tNkdNCOstMGQM879H4tt+WrAPKgCfXqI9
jE7wNPzrAb9j2+UhtyaTgUU=
=aKQk
-----END PGP SIGNATURE-----

--nFreZHaLTZJo0R7j--
