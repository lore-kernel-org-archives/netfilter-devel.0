From: Patrick McHardy <kaber@trash.net>
Subject: Re: compiling libipq example
Date: Thu, 03 Mar 2005 13:54:31 +0100
Message-ID: <42270907.9070200@trash.net>
References: <421EE3A0.7000804@datavibe.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------010807080902010208060806"
Cc: netfilter-devel@lists.netfilter.org
To: Essien Ita Essien <essiene@datavibe.net>
In-Reply-To: <421EE3A0.7000804@datavibe.net>
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

This is a multi-part message in MIME format.
--------------010807080902010208060806
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Essien Ita Essien wrote:
> Hi,
> 
> I'm trying to follow the tutorial in the libipq man page, with just a 
> little modification, and i get a compile error when i try to access the 
> ipq_packet_msg_t structure. I've checked where ipq_packet_msg_t is 
> defined, and found it in <linux/netfilter_ipv4/ip_queue.h>, which i've 
> found is conditionally included in <libipq.h> already. I even tried 
> including straight into the program.
> 
> Any ideas what i'm doing wrong?

I've used the attached code for testing some time ago, maybe it helps.

--------------010807080902010208060806
Content-Type: text/plain;
 name="Makefile"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="Makefile"

CC	= gcc
LD	= ld
CFLAGS	= -Wall -O2
LDFLAGS	= -lipq

all: nfqtest

clean:
	rm -f nfqtest nfqtest.o

nfqtest: nfqtest.o
	$(CC) nfqtest.o -o nfqtest $(LDFLAGS)

--------------010807080902010208060806
Content-Type: text/x-csrc;
 name="nfqtest.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="nfqtest.c"

/* just some testing code for the netfilter packet queuing to userspace
   (C) 2000 by Harald Welte <laforge@sunbeam.franken.de>

   This code is licensed under GPL conditions
*/
#include <stdio.h>
#include <stdlib.h>
#include <libipq/libipq.h>
#include <linux/netfilter.h>
#include <sys/socket.h>
#include <sys/un.h>

#define IPQ_BUF_SIZE 100000

static struct ipq_handle *qh;

static int handle_packet(ipq_packet_msg_t *pkt)
{
	int ret;

	printf("id: %lu, mark: %lu, timestamp: %ld %ld , indev: %s, datalen: %u\n",
	       pkt->packet_id, pkt->mark, pkt->timestamp_sec, pkt->timestamp_usec,
	       pkt->indev_name, (unsigned int)pkt->data_len);

	ret = ipq_set_verdict(qh, pkt->packet_id, NF_ACCEPT, pkt->data_len, pkt->payload);
	if (ret < 0) {
		printf("error setting verdict\n");
		ipq_perror(NULL);
	}
	return ret;
}

int main(int argc, char **argv)
{
	ssize_t len;
	unsigned char *buf;

	qh = ipq_create_handle(0, PF_INET);
	if (!qh) {
		printf("can't create netlink socket\n");
		ipq_perror(NULL);
		exit(1);
	}
	if (ipq_set_mode(qh, IPQ_COPY_PACKET, 0xFFFF) < 0) {
		printf("can't set netlink mode\n");
		ipq_perror(NULL);
		exit(2);
	}

	buf = malloc(IPQ_BUF_SIZE);
	while (1) {
		int ptype, error;
		ipq_packet_msg_t *packet;

		len = ipq_read(qh, buf, IPQ_BUF_SIZE, 0);
		if (len < 0) {
			printf("len < 0\n");
			break;
		} else if (len == 0) {
			printf("timeout exceeded\n");
			continue;
		}
		ptype = ipq_message_type(buf);
		packet = ipq_get_packet(buf);
		printf("received packet, length=%d, type=%d\n", (int)len, ptype);

		switch (ptype) {
		case NLMSG_ERROR:
			error = -ipq_get_msgerr(buf);
			printf("NLMSG_ERROR: %d\n", error);
			exit(3);
			break;

		case IPQM_PACKET:
			handle_packet(packet);
			break;
		}
	}
	ipq_perror(NULL);
	exit(0);
}

--------------010807080902010208060806--
