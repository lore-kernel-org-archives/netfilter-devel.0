From: aton <aton@packetdropped.org>
Subject: netfilter_queue reinjecting packets
Date: Sun, 12 Mar 2006 15:10:54 +0100
Message-ID: <20060312151054.5a2020ad.aton@packetdropped.org>
References: <1142119489.2987.61.camel@localhost>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
	micalg="PGP-SHA1";
	boundary="Signature=_Sun__12_Mar_2006_15_10_55_+0100_wbCep=FW/70d9bX8"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <1142119489.2987.61.camel@localhost>
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

--Signature=_Sun__12_Mar_2006_15_10_55_+0100_wbCep=FW/70d9bX8
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

has anyone used netfilter_queue and successfully re-injected packets into t=
he net?

i want to write sort of a userspace routing application.=20

host A is my workstation, it has host B as default gateway.

on host B my routing application runs.=20
it receives packets from netfilter_queue using libnetfilter_queue.
this works very well and i can display the whole packets.

now i just want to send them back into the net, so that they reach their de=
stination.

i modified the main loop in the source of nfqnl_test.c in the libnetfilter_=
queue package:

	while ((rv=3Drecv(fd, buf, sizeof(buf), 0)) >=3D 0)
	{
		printf("pkt received:\n");
	=09
		printf("sending packet back\n");
	=09
		if ((sv=3Dsend(fd, buf, sizeof(buf), 0))=3D=3D-1)
		{
			perror("send");
			exit(EXIT_FAILURE);
		}
		printf("done\n");
	}

this should send every packet back to... where?=20
it seems the packets are just sent into nirvana, i cannot sniff them, and i=
 dont get an error from send().

is this the way to go, or should i make two raw sockets, one for tcp and on=
e for udp packets and send the incoming packets on these?

greetings, aton

--Signature=_Sun__12_Mar_2006_15_10_55_+0100_wbCep=FW/70d9bX8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFEFCv03tb8MHRI6dcRAra8AKCVHJOVTQndvVC/FRt7qnWjR0lTWgCgmkWR
iaWJTt+FahhUyFskQvaVTV0=
=B2Lb
-----END PGP SIGNATURE-----

--Signature=_Sun__12_Mar_2006_15_10_55_+0100_wbCep=FW/70d9bX8--
