From: Wilson Padovani =?ISO-8859-1?Q?J=FAnior?= <admin@netsun.com.br>
Subject: Problem using REDIRECT and SO_ORIGINAL_DST
Date: Wed, 06 Nov 2002 15:22:29 GMT
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021106.15222917@w-laptop.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi.

    I trying to write a transparent proxy program, but I having=20
trouble to retrieve the original destination address of the redirected=20=

connections.
    I using the Linux Slackware 7.0 distribution with the glibc-2.1.2=20=

installed and running the kernel-2.4.17 and iptables-1.2.6a. To test=20=

the packet redirection, I wrote the following test program, based on=20=

the explanations found in this mailinglist and the code of the squid=20=

2.4 source:

######################################################

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <sys/ioctl.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <errno.h>
#include <dlfcn.h>
#include <linux/netfilter_ipv4.h>

#define SD_BOTH             2
#define SOCKET              int
#define INVALID_SOCKET      (SOCKET)(~0)
#define SOCKET_ERROR        (-1)

int main(void)
{
    SOCKET listen_sock, new_sock;
    struct sockaddr_in client;
    struct sockaddr_in me;
    struct sockaddr_in peer;

    unsigned long sockmode =3D 0;
    socklen_t SLen =3D sizeof(client);

    if ((listen_sock =3D socket(AF_INET, SOCK_STREAM, 0))=3D=3D=20
INVALID_SOCKET) {
        exit(1);
    }

    /* Local address and port */
    me.sin_family =3D AF_INET;
    me.sin_port =3D htons(10101);
    inet_aton("10.0.0.1", &me.sin_addr);

    if (ioctl(listen_sock, FIONBIO, &sockmode) =3D=3D SOCKET_ERROR) {
        close(listen_sock);
        exit(1);
    }

    if (bind(listen_sock, (struct sockaddr *)&me, sizeof(me)) =3D=3D=20=

SOCKET_ERROR) {
        close(listen_sock);
        exit(1);
    }

    if (listen(listen_sock, SOMAXCONN) =3D=3D SOCKET_ERROR) {
        shutdown(listen_sock, SD_BOTH);
        close(listen_sock);
        exit(1);
    }

    while ((new_sock =3D accept(listen_sock, (struct sockaddr *)&client,=
=20
&SLen))
            !=3D INVALID_SOCKET)
    {
        SLen =3D sizeof(peer);
        memset(&peer, 0, SLen);
        getsockopt(new_sock, SOL_IP, SO_ORIGINAL_DST, &peer, &SLen);
        printf( "Client: %s:%hu\nMe: %s:%hu\nPeer: %s:%hu\n",
                inet_ntoa(client.sin_addr), ntohs(client.sin_port),
                inet_ntoa(me.sin_addr), ntohs(me.sin_port),
                inet_ntoa(peer.sin_addr), ntohs(peer.sin_port) );

        if ( shutdown(new_sock, SD_BOTH) =3D=3D SOCKET_ERROR ||
             close(new_sock) =3D=3D SOCKET_ERROR )
        {
            shutdown(listen_sock, SD_BOTH);
            close(listen_sock);
            exit(1);
        }
    }
    if(new_sock =3D=3D INVALID_SOCKET) {
        shutdown(listen_sock, SD_BOTH);
        close(listen_sock);
        exit(1);
    }

    if (shutdown(listen_sock, SD_BOTH) =3D=3D SOCKET_ERROR ||
        close(listen_sock) =3D=3D SOCKET_ERROR)
    {
        exit(1);
    }

    exit(0);
}

######################################################

    And I create the iptables rules to make the NAT of my intranet=20
network addresses and the redirection of the outgoing connections, as=20=

follow :

iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 1234 -j REDIRECT=20=

--to-port 10101
iptables -t nat -A POSTROUTING -o eth1 -s 10.0.0.0/24 -j SNAT --to=20
1.2.3.4

    When I run the program and make the test opening a telnet session=20=

to any external IP on port 1234, the test program even show the result=20=

:

Client: 10.0.0.100:<anyport>
Me: 10.0.0.100:10101
Peer: 10.0.0.100:1234

    This tells me the redirected port and the original port, but all=20=

IP addresses always points to the client's address!! What's wrong in thi=
s?

Any help is welcome.

Wilson.
