From: "J Leven" <jleven0@lycos.com>
Subject: 2.6.8 problem when using libipq, test code included
Date: Wed, 01 Sep 2004 15:21:02 -0500
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20040901202102.4B12F86AEC@ws7-1.us4.outblaze.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
To: netfilter-devel@lists.netfilter.org
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hi,

I've posted this problem previously but didn't get a response... I just w=
anted to see if anyone is investigating this and if there is a fix on the=
 horizon.
I'm trying to use libipq to take all outbound packets destined for a part=
icular address (192.168.1.44) and reroute them to the local IP (10.10.0.7=
0).  I have the program below, it works just fine in 2.4.x kernels but pr=
oduces a ip_rt_bug message in the 2.6 series.  The specific error message=
 is
    "ip_rt_bug: 192.168.1.44 -> 10.10.0.70, ?"=20
Is there something I am missing in the iptables configuration for 2.6, or=
 is there a workaround for this? To test this, run setup_iptables.sh, com=
pile and run test_server.c(on port 80) and ipqtest.c.  Then "telnet 192.1=
68.1.44 80".  The expected behavior (that on 2.4 kernel), is a successful=
 connection to test_server.

Thanks in advance,
J

--------------------------------------------------------------
--------------------------- IPQTEST.C ------------------------
--------------------------------------------------------------
/* Compile with cc -lipq */
#include <linux/netfilter.h>
#include <libipq.h>
#include <stdio.h>
#include <netinet/in.h>
#include <netinet/ip.h>
#include <netinet/tcp.h>
#include <arpa/inet.h>

#define BUFSIZE 2048

struct in_addr dot_44;
struct in_addr dot_70;

inline u_int16_t checksum_update_32(
	u_int16_t old_check,
	u_int32_t old,
	u_int32_t new)
{
	u_int32_t l;

	old_check =3D ~old_check;
	old =3D ~old;

	l =3D (u_int32_t)old_check + (old >> 16) + (old & 0xffff)
+ (new >> 16) + (new & 0xffff);
	return ~((u_int16_t)(l >> 16) + (l & 0xffff));
}

static void filter(
	unsigned char *packet)
{
	struct iphdr *ip;
	struct tcphdr *tcp;

	ip =3D (struct iphdr *)packet;
	if (ip->protocol =3D=3D IPPROTO_TCP)
	{
		tcp =3D (struct tcphdr *)(((u_int32_t *)ip) + ip->ihl);

		if (ip->saddr =3D=3D dot_70.s_addr)
		{
			ip->check =3D checksum_update_32(
				ip->check,
				ip->saddr,
				dot_44.s_addr);
			tcp->check =3D checksum_update_32(
				tcp->check,
				ip->saddr,
				dot_44.s_addr);
			ip->saddr =3D dot_44.s_addr;
		}
		if (ip->daddr =3D=3D dot_44.s_addr)
		{
			ip->check =3D checksum_update_32(
				ip->check,
				ip->daddr,
				dot_70.s_addr);
			tcp->check =3D checksum_update_32(
				tcp->check,
				ip->daddr,
				dot_70.s_addr);
			ip->daddr =3D dot_70.s_addr;
		}
	}
}

static void die(struct ipq_handle *h)
{
	ipq_perror("passer");
	// ipq_destroy_handle(h);
	// exit(1);
}

int main(int argc, char **argv)
{
	int status;
	unsigned char buf[BUFSIZE];
	struct ipq_handle *h;

	inet_aton("192.168.1.44", &(dot_44));
	inet_aton("10.10.0.70", &(dot_70));

	h =3D ipq_create_handle(0, PF_INET);
	if (!h)
		die(h);

	status =3D ipq_set_mode(h, IPQ_COPY_PACKET, BUFSIZE);
	if (status < 0)
		die(h);

	do{
		status =3D ipq_read(h, buf, BUFSIZE, 0);
		if (status < 0)
			die(h);

		switch (ipq_message_type(buf)) {
		case NLMSG_ERROR:
			fprintf(stderr, "Received error message %d\n",
					ipq_get_msgerr(buf));
			break;

		case IPQM_PACKET: {
			ipq_packet_msg_t *m =3D ipq_get_packet(buf);

			fprintf(stderr, "----------------
Accepting packet ----------------\n");
			if (m->data_len < sizeof(struct iphdr))=20
			{
				fprintf(
					stderr,
					"XXX BUG: %d < %d\n",
					m->data_len,
					sizeof(struct iphdr));
			}
			filter(m->payload);
			status =3D ipq_set_verdict(
				h,
				m->packet_id,
				NF_ACCEPT,
				m->data_len,
				m->payload);
			if (status < 0)
				die(h);
			break;
		}

		default:
			fprintf(stderr, "Unknown message type!\n");
			break;
		}
	} while (1);

	ipq_destroy_handle(h);
	return 0;
}
--------------------------------------------------------------
------------------------- TEST_SERVER.C ----------------------
--------------------------------------------------------------
#include <string.h>
#include <stdio.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netinet/tcp.h>
#include <unistd.h>
#include <sys/select.h>
#include <errno.h>
#include <fcntl.h>
#include <stdlib.h>

int my_recv(
	int csock,
	char *bufptr,
	int read_len)
{
	fd_set fds;
	int rval;

	FD_ZERO(&fds);
	FD_SET(csock, &fds);
	do {
		select(csock + 1, &fds, NULL, NULL, NULL);

		rval =3D recv(csock, bufptr, read_len, 0); /* req1 */
		if (rval > 0)
		{
			bufptr +=3D rval;
			read_len -=3D rval;
		}
		else if (rval < 0
				 && (errno =3D=3D EAGAIN
					 || errno =3D=3D EINTR
					 || errno =3D=3D EWOULDBLOCK))
		{
			continue;
		}
		else
		{
			return -1;
		}
	} while (read_len);

	return 0;
}

int my_send(
	int csock,
	char *bufptr,
	int send_len)
{
	fd_set fds;
	int rval;

	FD_ZERO(&fds);
	FD_SET(csock, &fds);
	do {
		select(csock + 1, NULL, &fds, NULL, NULL);

		rval =3D send(csock, bufptr, send_len, 0); /* req1 */
		if (rval > 0)
		{
			bufptr +=3D rval;
			send_len -=3D rval;
		}
		else if (rval < 0
				 && (errno =3D=3D EAGAIN
					 || errno =3D=3D EINTR
					 || errno =3D=3D EWOULDBLOCK))
		{
			continue;
		}
		else
		{
			return -1;
		}
	} while (send_len);

	return 0;
}

static void usage()=20
{
	fprintf(stderr, "\nusage : test_server -p port\n");
	exit(-1);
}=20

int main(int argc, char **argv) {
	int ssock, csock[2000];
	struct sockaddr_in saddr;
	char res1[2048];
	char buf[204800];
	int sz, on, rval, i=3D0;
	int c, port;
	fd_set fds;
=09
    /* get command line params */
    while ((c =3D getopt(argc, argv, "p:")) !=3D -1) {
		switch(c) {
		  case 'p':
			  port =3D atoi(optarg); i++;
			  break;
	      default:
			  usage();
		}  /* switch end */
    }  /* while end */

	if (i < 1 )
	{
		usage();
	}=20

	i=3D0;

	saddr.sin_family =3D AF_INET;
	saddr.sin_port =3D htons(port);
	saddr.sin_addr.s_addr =3D INADDR_ANY;

	ssock =3D socket(PF_INET, SOCK_STREAM, 0);
	on =3D 1;
	sz =3D 512 * 1024;
	setsockopt(ssock, SOL_SOCKET, SO_REUSEADDR, &on, sizeof(on));
	setsockopt(ssock, SOL_SOCKET, SO_KEEPALIVE, &on, sizeof(on));
	setsockopt(ssock, SOL_SOCKET, SO_SNDBUF, &sz, sizeof(sz));
	setsockopt(ssock, IPPROTO_TCP, TCP_NODELAY, &on, sizeof(on));
	fcntl(ssock, F_SETFL, O_NONBLOCK | O_ASYNC);
	bind(ssock, (struct sockaddr *)&saddr, sizeof(struct sockaddr_in));
	listen(ssock, 100);

	FD_ZERO(&fds);
	FD_SET(ssock, &fds);
=09
	while (1)
	{
		select(ssock + 1, &fds, NULL, NULL, NULL);
		csock[i] =3D accept(ssock, NULL, NULL);
		snprintf(res1,sizeof(res1),"[%d] Connected To
Test Server...",i);
		printf("%s\n",res1);
		my_send(csock[i], res1, strlen(res1));=20
		i++;
	}

	return 0;
}
--------------------------------------------------------------
------------------------- IPTABLES.SH ------------------------
--------------------------------------------------------------
#!/bin/sh
/sbin/iptables --flush
/sbin/iptables -A OUTPUT -j QUEUE
/sbin/iptables -A INPUT -j QUEUE
/sbin/iptables -A FORWARD -j QUEUE
/sbin/modprobe ip_queue
--=20
_______________________________________________
Find what you are looking for with the Lycos Yellow Pages
http://r.lycos.com/r/yp_emailfooter/http://yellowpages.lycos.com/default.=
asp?SRC=3Dlycos10
