From: Rennie deGraaf <degraaf@cpsc.ucalgary.ca>
Subject: ip_rt_bug in mangle/OUTPUT
Date: Wed, 23 May 2007 15:12:57 -0600
Message-ID: <4654AE59.3090506@cpsc.ucalgary.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enig37E3995BC471E3F6C7CBC49E"
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig37E3995BC471E3F6C7CBC49E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

I seem to be getting the error message
    ip_rt_bug: 10.1.1.1 -> 10.0.1.2, ?
whenever I attempt to send a packet with a non-local source IP address
(my local IP address is 10.0.1.2) from libipq in mangle/OUTPUT.  I have
observed this behaviour under Linux kernels 2.6.20.7 and
2.6.18-1.2257.fc5smp (Fedora Core 5), and iptables versions 1.3.5 and
1.3.7.

I'm trying to simulate connections with remote hosts by redirecting
packets to servers listening on localhost.  My strategy is to send
packets to IP_QUEUE from rules in the mangle/OUTPUT chain: destination
addresses are re-written on packets that I want to redirect, source
addresses are re-written on packets on responses to redirected packets,
and other packets are passed without modification.  A simplified, highly
stripped down version of my program is attached.

To run my example program, you need rules in your mangle/OUTPUT chain
forwarding packets to 10.1.1.1:123/TCP and from 127.0.0.1:22/TCP to
QUEUE, and something listening on 127.0.0.1:22/TCP.  If it worked
properly, a connection could be successfully established to
127.0.0.1:22/TCP by connecting to 10.1.1.1:123/TCP (using telnet, for
instance).

Do any of the gurus on this list know how I might fix or work around
this issue?

This issue seems to have been discussed before (such as
http://www.ussg.iu.edu/hypermail/linux/kernel/0504.3/0159.html), but
doesn't seem to have been resolved.

Thanks,
Rennie deGraaf


-----------------
#include <linux/netfilter.h>
#include <libipq.h>
#include <stdio.h>
#include <netinet/ip.h>
#include <netinet/tcp.h>
#include <arpa/inet.h>


u_int16_t ip_checksum(u_int32_t init, const u_int8_t* buf, size_t len)
{
    u_int32_t sum =3D init;
    u_int16_t* shorts =3D (u_int16_t*)buf;

    while (len > 1)
    {
        sum +=3D *shorts++;
        len -=3D 2;
    }

    if (len =3D=3D 1)
        sum +=3D *(u_int8_t*)shorts;

    while (sum >> 16)=09
        sum =3D (sum >> 16) + (sum & 0xFFFF);

    return ~sum;
}

u_int16_t tcp_checksum(const struct iphdr* iph, const struct tcphdr*
tcph, size_t len)
{
    u_int32_t cksum =3D 0;

    cksum +=3D (iph->saddr >> 16) & 0x0000ffff;
    cksum +=3D iph->saddr & 0x0000ffff;
    cksum +=3D (iph->daddr >> 16) & 0x0000ffff;
    cksum +=3D iph->daddr & 0x0000ffff;
    cksum +=3D htons(iph->protocol & 0x00ff);
    cksum +=3D htons(len);
    return ip_checksum(cksum, (unsigned char*)tcph, len);
}


void handle_packet(unsigned char* pkt, size_t len)
{
    struct iphdr* iph =3D (struct iphdr*) pkt;
    struct tcphdr* tcph =3D (struct tcphdr*)(pkt+iph->ihl*4);

    if ((iph->daddr =3D=3D htonl(0x0a010101)) && (tcph->dest =3D=3D htons=
(123)))
    {
        printf("forward\n");
        iph->daddr =3D htonl(0x7f000001);
        tcph->dest =3D htons(22);

        iph->check =3D 0;
        iph->check =3D ip_checksum(0, pkt, iph->ihl*4);
        tcph->check =3D 0;
        tcph->check =3D tcp_checksum(iph, tcph, len-(iph->ihl*4));
    }
    else if ((iph->saddr =3D=3D htonl(0x7f000001)) && (tcph->source =3D=3D=

htons(22)))
    {
        printf("reverse\n");
        iph->saddr =3D htonl(0x0a010101);
        tcph->source =3D htons(123);

        iph->check =3D 0;
        iph->check =3D ip_checksum(0, pkt, iph->ihl*4);
        tcph->check =3D 0;
        tcph->check =3D tcp_checksum(iph, tcph, len-(iph->ihl*4));
    }
    else
        printf("wrong packet!\n");
}

int main()
{
    struct ipq_handle* handle;
    unsigned char buf[10000];
    ipq_packet_msg_t* pkt;

    handle =3D ipq_create_handle(0, PF_INET);
    ipq_set_mode(handle, IPQ_COPY_PACKET, 65535);

    while (1)
    {
        ipq_read(handle, buf, 10000, 0);
        pkt =3D ipq_get_packet(buf);
        handle_packet(pkt->payload, pkt->data_len);
        ipq_set_verdict(handle, pkt->packet_id, NF_ACCEPT,
pkt->data_len, pkt->payload);
    }

    ipq_destroy_handle(handle);
    return 0;
}


--------------enig37E3995BC471E3F6C7CBC49E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFGVK5gIvU5mZP08HERAhAZAKCsz8puLclRP5AIafUS21RrfB0A0gCbBMkx
OemU8y5YsYsNh07DrJs2mzE=
=JpEe
-----END PGP SIGNATURE-----

--------------enig37E3995BC471E3F6C7CBC49E--
