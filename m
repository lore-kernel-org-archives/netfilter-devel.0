From: Luca Zini <luca.zini@gmail.com>
Subject: getting process pid with libipq/libnetfilter_queue
Date: Sat, 05 Nov 2005 14:25:33 +0100
Message-ID: <1131197133.4420.30.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-BNtinfSBWwqJlktGxZz9"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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


--=-BNtinfSBWwqJlktGxZz9
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

I'm developing a sort of frontend for iptables to make a user-space
interface that should filter connections in relation to the application
that wants t connect.
To make this I need in user space the pid of the application that wants
to connect (the application that sends or receives the packet that is
filtered by -m state NEW ).

I started developing it using libipq, but i have no pid in
ipq_packet_msg. I proposed my problem in a forum and a moderator
proposed me a temporaney patch to ip_queue to get the pid in
timestamp_usec:


--- linux-2.6.11.4/net/ipv4/netfilter/ip_queue.c.org    2005-06-13
20:56:37.000000000 +0200
+++ linux-2.6.11.4/net/ipv4/netfilter/ip_queue.c        2005-06-13
20:56:28.000000000 +0200
@@ -234,7 +234,9 @@
        pmsg->packet_id       =3D (unsigned long )entry;
        pmsg->data_len        =3D data_len;
        pmsg->timestamp_sec   =3D entry->skb->stamp.tv_sec;
-       pmsg->timestamp_usec  =3D entry->skb->stamp.tv_usec;
+       pmsg->timestamp_usec  =3D entry->skb->sk->sk_socket->file ?
+               entry->skb->sk->sk_socket->file->f_owner.pid : 0;
        pmsg->mark            =3D entry->skb->nfmark;
        pmsg->hook            =3D entry->info->hook;
        pmsg->hw_protocol     =3D entry->skb->protocol;



--- linux-2.6.11.4/net/socket.c.org     2005-06-13 20:51:53.000000000
+0200
+++ linux-2.6.11.4/net/socket.c 2005-06-13 20:39:11.000000000 +0200
@@ -404,6 +404,7 @@
                file->f_mode =3D FMODE_READ | FMODE_WRITE;
                file->f_flags =3D O_RDWR;
                file->f_pos =3D 0;
+               file->f_owner.pid =3D get_current()->pid;
                fd_install(fd, file);
        }

this patch works well if the connection was in OUTPUT chain, otherwise
the system freezes itself.
I've just seen libnetfilter_queue, but, as with libipq, i did not find
any solution to get the correct pid.
Have you any ideas? Can you help me?=20

regards=20
	Luca Zini

--=-BNtinfSBWwqJlktGxZz9
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Questa parte del messaggio =?ISO-8859-1?Q?=E8?= firmata

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQBDbLLNucz8jP9yn/kRAhKAAJ9K+HSRoTfKvceqfP1718fuwO8YawCgujnW
+1m5i1OWDPzRKQZIddJpYA4=
=Qi3t
-----END PGP SIGNATURE-----

--=-BNtinfSBWwqJlktGxZz9--
