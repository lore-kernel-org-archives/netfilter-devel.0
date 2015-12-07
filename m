From: Matthias Gerstner <Matthias.Gerstner@ncp-e.com>
Subject: nf_conntrack_ipv4: UDP packets are spuriously dropped on parallel
 send via loopback device on SMP machines
Date: Mon, 7 Dec 2015 15:14:33 +0100
Message-ID: <20151207141433.GA19205@mgpc.ncp.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="ZfOjI3PrQbgiZnxM"
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.remote-access.de ([62.153.165.35]:50786 "EHLO
	mail.ncp-e.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754693AbbLGOXJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Dec 2015 09:23:09 -0500
Received: from viruswall.ncp.de (viruswall.ncp.de [62.153.165.41])
	by mail.ncp-e.com (Postfix) with ESMTPS id 3B426A1AFE
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Dec 2015 15:07:27 +0100 (CET)
Received: from [172.16.11.201] (port=1596 helo=ex07.ncp.local)
	by viruswall.ncp.de with esmtps (TLSv1:RC4-MD5:128)
	(Exim 4.76)
	(envelope-from <Matthias.Gerstner@ncp-e.com>)
	id 1a5wYj-0001Br-23
	for netfilter-devel@vger.kernel.org; Mon, 07 Dec 2015 15:14:33 +0100
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

--ZfOjI3PrQbgiZnxM
Content-Type: multipart/mixed; boundary="EeQfGwPcQSOJBaQU"
Content-Disposition: inline


--EeQfGwPcQSOJBaQU
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

I've encountered a strange situation while trying to run my software
under Linux. And I boiled it down to what I think is a bug in the
nf_conntrack_ipv4 kernel module. Maybe somebody on this list can help me
with this.

My software implements the following behaviour:

1) a number of listener processes listen for udp packets on a well
  known port on the localhost via recvfrom()
2) at some point in time a broadcast process sends a request via udp
broadcast to this well known port
3) all the listener processes receive this request and reply
individually to the broadcast process via sendto()

What happens to me is that 1) and 2) work as expected, but the replies
in step 3) are randomly dropped and never reach the broadcast process.
The process calling sendto() receives an EPERM return in this case but
in a more complex (real world) scenario I think the packets are also
silently dropped.

This happens under the following circumstances:

- the kernel module nf_conntrack_ipv4 must be loaded
- no actual firewall/iptable rules are configured, so all packets
  should be accepted
- the code needs to run on an SMP machine that allows for real
  parallelization. I couldn't reproduce this from within a qemu virtual
  machine, for example. So it looks like a race condition to me.

I've written isolated test cases for the "listener" and the "broadcast"
part of this scenario. You can find the program source code attached to
this mail. To reproduce the behaviour the following needs to be done:

- start two instances of the listener program
- start / ctrl-c / restart the broadcast program until one or both of
  the listener instances receive an EPERM

I've also managed to trace the location in the kernel code where the
decision to drop the packet in this situation is actually made. But I
don't understand the logic that's implemented there. It's in function
__nf_conntrack_confirm() where the following if clause is matching:

------------------------------------------------------------------------
hlist_nulls_for_each_entry(h, n, &net->ct.hash[hash], hnnode)
	if (nf_ct_tuple_equal(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple,
				&h->tuple) &&
				zone =3D3D=3D3D nf_ct_zone(nf_ct_tuplehash_to_ctrack(h)))
------------------------------------------------------------------------

This is the kernel stacktrace leading to it:

Call Trace:
 [<ffffffff81565a3d>] dump_stack+0x45/0x57
 [<ffffffff814bb7f5>] __nf_conntrack_confirm+0x21d/0x2c9
 [<ffffffff81504265>] ipv4_confirm+0x6a/0xe8
 [<ffffffff814b6912>] nf_iterate+0x52/0x8b
 [<ffffffff814b699e>] nf_hook_slow+0x53/0xde
 [<ffffffff814cec9b>] ip_output+0xaf/0xf5
 [<ffffffff814ce26f>] ? ip_fragment+0x673/0x673
 [<ffffffff814cd721>] ip_local_out_sk+0x49/0x6f
 [<ffffffff814cf631>] ip_send_skb+0x13/0x70
 [<ffffffff814ee83b>] udp_send_skb+0x196/0x219
 [<ffffffff814eee78>] udp_sendmsg+0x569/0x7b6
 [<ffffffff814cece1>] ? ip_output+0xf5/0xf5
 [<ffffffff814ed778>] ? udp_recvmsg+0x176/0x335
 [<ffffffff814f758b>] inet_sendmsg+0x5e/0xb5
 [<ffffffff810ee67e>] ? __fget_light+0x3f/0x51
 [<ffffffff81482356>] sock_sendmsg+0x14/0x39
 [<ffffffff81483437>] SyS_sendto+0x12b/0x184
 [<ffffffff810e7fa2>] ? SyS_select+0x9f/0xb4
 [<ffffffff8156abee>] system_call_fastpath+0x12/0x71

The stacktrace is from Linux kernel 4.1.12 but I've also managed to
reproduce this using the current kernel version 4.3.

Any help is appreciated.

Regards

Matthias

--=20
Matthias Gerstner, Dipl.-Wirtsch.-Inf. (FH)
Entwicklung
=20
NCP engineering GmbH
Domb=FChler Stra=DFe 2, D-90449, N=FCrnberg
Gesch=E4ftsf=FChrer Peter S=F6ll, HRB-Nr: 77 86 N=FCrnberg
=20
Telefon: +49 911 9968-153, Fax: +49 911 9968-229
E-Mail: Matthias.Gerstner@ncp-e.com
Internet: http://www.ncp-e.com


--EeQfGwPcQSOJBaQU
Content-Type: text/x-c; charset=us-ascii
Content-Disposition: attachment; filename="listener.c"
Content-Transfer-Encoding: quoted-printable

#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netinet/ip.h>
#include <netinet/udp.h>
#include <arpa/inet.h>

#include <string.h>
#include <stdio.h>
#include <stdint.h>
#include <errno.h>

int main(int argc, const char **argv)
{
	int udp_sock =3D socket(AF_INET, SOCK_DGRAM, 0);
	struct sockaddr_in udp_addr, peer_addr;
	const int sock_bool =3D 1;
	const size_t MAX_MSG =3D 1024;
	uint8_t message[MAX_MSG];
	socklen_t ip_len =3D sizeof(struct sockaddr_in);
	int res =3D 0;

	/*
	 * bind to a fixed udp port on localhost
	 */
	memset(&udp_addr, 0, sizeof(struct sockaddr_in));
	udp_addr.sin_family =3D AF_INET;
	// some fixed port number for finding each other
	udp_addr.sin_port =3D htons(30451);
	// listen on the localhost for broadcasts
	if( inet_aton("127.255.255.255", &udp_addr.sin_addr) =3D=3D 0 )
	{
		printf("Failed to set addr\n");
		return 1;
	}

	if( setsockopt(udp_sock, SOL_SOCKET, SO_BROADCAST, &sock_bool, sizeof(sock=
_bool)) !=3D 0 )
	{
		printf("Failed to set broadcast option\n");
		return 1;
	}

	if( setsockopt(udp_sock, SOL_SOCKET, SO_REUSEADDR, &sock_bool, sizeof(sock=
_bool)) !=3D 0 )
	{
		printf("Failed to set reuse option\n");
		return 1;
	}

	if( bind(udp_sock, (struct sockaddr*)&udp_addr, sizeof(udp_addr)) !=3D 0 )
	{
		printf("Failed to bind to addr\n");
		return 1;
	}
	=09
	while( 1 )
	{
		res =3D recvfrom( udp_sock, message, MAX_MSG, 0, (struct sockaddr*)&peer_=
addr, &ip_len );
=09
		if( res =3D=3D -1 )
		{
			printf("Failed to receive message\n");
			return 1;
		}

		if( ip_len !=3D sizeof(struct sockaddr_in) )
		{
			printf("Wrong addr len\n");
			return 1;
		}

		printf("Received message of %d bytes from %s:%d\n",
			res,
			inet_ntoa(peer_addr.sin_addr),
			peer_addr.sin_port
		);

		// ignore actual message content, we just want to reply.
		//
		// use the same message for this purpose
	=09
		res =3D sendto( udp_sock, message, res, 0, (struct sockaddr*)&peer_addr, =
ip_len);

		if( res =3D=3D -1 )
		{
			perror("Failed to reply");
		}
	}

	return 0;
}

--EeQfGwPcQSOJBaQU
Content-Type: text/x-c; charset=us-ascii
Content-Disposition: attachment; filename="broadcast.c"
Content-Transfer-Encoding: quoted-printable

#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netinet/ip.h>
#include <netinet/udp.h>
#include <arpa/inet.h>

#include <string.h>
#include <stdio.h>
#include <stdint.h>
#include <errno.h>

int main(int argc, const char **argv)
{
	int udp_sock =3D socket(AF_INET, SOCK_DGRAM, 0);
	struct sockaddr_in local_addr, peer_addr;
	const int sock_bool =3D 1;
	socklen_t ip_len =3D sizeof(struct sockaddr_in);
	const size_t MAX_MSG =3D 1024;
	uint8_t message[MAX_MSG];
	int res =3D 0;

	/*
	 * bind to some arbitrary UDP port on localhost
	 */
	memset(&local_addr, 0, sizeof(struct sockaddr_in));
	local_addr.sin_family =3D AF_INET;
	local_addr.sin_port =3D 0;

	// listen on the localhost for broadcasts
	if( inet_aton("127.0.0.1", &local_addr.sin_addr) =3D=3D 0 )
	{
		printf("Failed to set addr\n");
		return 1;
	}

	/*
	 * setup he broadcast target address
	 */
=09
	memset(&peer_addr, 0, sizeof(struct sockaddr_in));
	peer_addr.sin_family =3D AF_INET;
	// fixed port number for broadcasting
	peer_addr.sin_port =3D htons(30451);
	if( inet_aton("127.255.255.255", &peer_addr.sin_addr) =3D=3D 0 )
	{
		printf("Failed to set broadcast addr\n");
		return 1;
	}

	/*
	 * setup the socket
	 */
=09
	if( setsockopt(udp_sock, SOL_SOCKET, SO_BROADCAST, &sock_bool, sizeof(sock=
_bool)) !=3D 0 )
	{
		printf("Failed to set broadcast option\n");
		return 1;
	}
=09
	if( bind(udp_sock, (struct sockaddr*)&local_addr, sizeof(local_addr)) !=3D=
 0 )
	{
		printf("Failed to bind to addr\n");
		return 1;
	}

	if( getsockname( udp_sock, (struct sockaddr*)&local_addr, &ip_len) !=3D 0 )
	{
		printf("Failed to get sockname\n");
		return 1;
	}

	printf("Bound to %s:%d for replies\n",
		inet_ntoa(local_addr.sin_addr),
		local_addr.sin_port
	);

	/* send some arbitrary data */
	if( sendto( udp_sock, message, 17, 0, (struct sockaddr*)&peer_addr, ip_len=
 ) =3D=3D -1 )
	{
		perror("Failed to send broadcast");
		return 1;
	}

	printf("Sent broadcast to %s:%d\n",
		inet_ntoa(peer_addr.sin_addr),
		local_addr.sin_port
	);

	while ( 1 )
	{
		res =3D recvfrom( udp_sock, message, MAX_MSG, 0, (struct sockaddr*)&peer_=
addr, &ip_len );

		if( res =3D=3D -1 )
		{
			printf("Failed to receive message\n");
			return 1;
		}

		if( ip_len !=3D sizeof(struct sockaddr_in) )
		{
			printf("Wrong addr len\n");
			return 1;
		}

		printf("Received broadcast reply of %d bytes from %s:%d\n",
			res,
			inet_ntoa(peer_addr.sin_addr),
			peer_addr.sin_port
		);

		/*
		 * ignore actual message content
		 */
	}
}

--EeQfGwPcQSOJBaQU--

--ZfOjI3PrQbgiZnxM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWZZRJAAoJEEOOx8hIrs/bJrIQAKzoumgQzxZOw3f142FKxerN
B9uSowUfIAmspo2JjVcl+w2bYKWgOVBGxPGtA79YGptYBzRs/5loco51pzogOIwf
imBZ4PTdT4FfY7MXEbO39l5xCrpmt/mf4WSaX9mozLFMHTtR4FtGZduT0gPdrAMz
h5J8nhojRLzWExM66IS1BCpGEe+CjrWRUIbzvNlni14u2HQHoUIi2CgvOc5LR2gf
Xns+ClWPGuOyUhFJrG3R3pTdHpX+RTvKKNsNp1yBABpj7LPk7HqZHmNgFK5vJQ3/
dXQJZ2pC5LoGEyHuOMS4BVRvz0nTGO7E+LnZamdiv/i2McbGO+Z56jmku2Q160ok
kc4hRe3nXE4vkrY04qum/HSBWFmKD4VhtSb7kfuBkfphbNAKDomLaiiwVhrB2Ehh
vCo4AwLxYCiri2FB/ScRxVYeZTtdAOARzwNk/zumQULALvjmI053HFCJEQ5ahgrz
u7AwMx8yjQHjel5buJbyBsYDSCdax+fe7AKfRul/KGnvl6VGK7R9aidm2sR38nXD
YpT8El+Li4ii/1k2AS7gltnZ0DE7wXESeD869bflpu64hsQ3rO9lJIFq9WmAOGne
JaynQHhWWPfvznEYFjRDUowOhbiJSu6i2QU9fEVtX3bMY4INuv5Rz6rBXZGXoj+h
AqeUMTS2D3tDwyh5lNUd
=KJZD
-----END PGP SIGNATURE-----

--ZfOjI3PrQbgiZnxM--
