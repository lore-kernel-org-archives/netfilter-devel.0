From: Eric Leblond <eric@inl.fr>
Subject: Re: getting process pid with libipq/libnetfilter_queue
Date: Sat, 05 Nov 2005 16:33:27 +0100
Message-ID: <1131204807.11473.18.camel@localhost.localdomain>
References: <1131197133.4420.30.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-i5ZPiPyOi1qdBTQhDPGf"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Luca Zini <luca.zini@gmail.com>
In-Reply-To: <1131197133.4420.30.camel@localhost.localdomain>
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


--=-i5ZPiPyOi1qdBTQhDPGf
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Le samedi 05 novembre 2005 =E0 14:25 +0100, Luca Zini a =E9crit :
> I'm developing a sort of frontend for iptables to make a user-space
> interface that should filter connections in relation to the application
> that wants t connect.
> To make this I need in user space the pid of the application that wants
> to connect (the application that sends or receives the packet that is
> filtered by -m state NEW ).
>=20
> I started developing it using libipq, but i have no pid in
> ipq_packet_msg. I proposed my problem in a forum and a moderator
> proposed me a temporaney patch to ip_queue to get the pid in
> timestamp_usec:
>=20

Why not simply use /proc interface :

     1. you receive the packet from QUEUE|NFQUEUE and extract ipv4
        header
     2. you parse /proc/net/udp ou /proc/net/tcp to find the
        corresponding connection (search on the ipv4 header of the
        packet).
     3. you get inode number which give you the process by lookng again
        in /proc

You can use netstat code or libnuclient code in the nufw project
(http://www.nufw.org) to get exemple of the code needed for step 3.

By the way, nufw is able to do this sort of filtering at the network
level ;-)

BR,
--=20
Eric Leblond <eric@inl.fr>

--=-i5ZPiPyOi1qdBTQhDPGf
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQBDbNDHnxA7CdMWjzIRAvxlAJ0YPleLd4mPfVoHEXYUsnxoSxGl4wCgjXp/
eyHYwXucFr5Kb1sC5+bmoZk=
=Rd5t
-----END PGP SIGNATURE-----

--=-i5ZPiPyOi1qdBTQhDPGf--
