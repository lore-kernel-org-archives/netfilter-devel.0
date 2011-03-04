From: "Fabien C." <7o5fzvj4duxjxzp@jetable.org>
Subject: libnetfilter_queue: Some accepted packets get lost
Date: Sat, 05 Mar 2011 00:04:30 +0100
Message-ID: <4D716FFE.8050503@jetable.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080806010604010101030306"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp4-g21.free.fr ([212.27.42.4]:45685 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932707Ab1CDXEh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Mar 2011 18:04:37 -0500
Received: from [10.3.5.8] (unknown [81.57.168.177])
	by smtp4-g21.free.fr (Postfix) with ESMTP id B8C554C8064
	for <netfilter-devel@vger.kernel.org>; Sat,  5 Mar 2011 00:04:31 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080806010604010101030306
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hello list,

I ran into a strange behavior lately using libnetfilter_queue: in some specific
conditions, accepted queued paquet would in fact be lost. I am having the
problem on a custom 2.6.37.2 kernel, but not on the official Debian Squeeze
kernel (2.6.32-5).

The code I use is very similar to the test code available on the netfilter
website
(http://www.netfilter.org/projects/libnetfilter_queue/doxygen/nfqnl__test_8c_source.html),
accepting every queued packet.

I am queuing outgoing DNS requests with the following rule:
 iptables -A OUTPUT -p udp --dport 53 -j NFQUEUE --queue-num 666

Then, launch a browser (tested with Firefox 3.5 and Chromium 9), type a URL,
the browser hangs for 5 seconds and then displays the webpage. So I ran tcpdump
and the queue program on the same terminal. See what happens with and without
the NFQUEUE rule:


* Normal behavior, iptables are empty (tcpdump - real domain and ip modified):

13:29:21.630530 IP 10.3.5.8.38047 > 10.3.5.1.53: 41247+ A? www.mydomain.net. (35)
13:29:21.630563 IP 10.3.5.8.38047 > 10.3.5.1.53: 12691+ AAAA? www.mydomain.net.(35)
13:29:21.631170 IP 10.3.5.1.53 > 10.3.5.8.38047: 41247 1/3/3 A 12.34.123.210 (157)
13:29:21.774174 IP 10.3.5.1.53 > 10.3.5.8.38047: 12691 0/1/0 (94)


* Using a queue ('tcpdump -ni eth0 udp port 53' and queue manager on the same
terminal):

01) 20:08:00.486366: recv returned 108
02) 20:08:00.486566: setting verdict : accept the packet...
03) 20:08:00.486614 IP 10.3.5.8.46938 > 10.3.5.1.53: 51146+ A? www.mydomain.net. (35)
04) 20:08:00.487193 IP 10.3.5.1.53 > 10.3.5.8.46938: 51146 1/3/3 A 12.34.123.210 (157)
05) 20:08:00.586723: recv returned 108
06) 20:08:00.586789: setting verdict : accept the packet...
 [==> tcpdump doesn't see this one - so browser waits for 5sec, and retries]
07) 20:08:05.490419: recv returned 108
08) 20:08:05.490479: setting verdict : accept the packet...
09) 20:08:05.490518 IP 10.3.5.8.46938 > 10.3.5.1.53: 51146+ A? www.mydomain.net. (35)
10) 20:08:05.490990 IP 10.3.5.1.53 > 10.3.5.8.46938: 51146 1/3/3 A 12.34.123.210 (157)
11) 20:08:05.590742: recv returned 108
12) 20:08:05.590810: setting verdict : accept the packet...
13) 20:08:05.590859 IP 10.3.5.8.46938 > 10.3.5.1.53: 48550+ AAAA? www.mydomain.net. (35)
14) 20:08:05.722533 IP 10.3.5.1.53 > 10.3.5.8.46938: 48550 0/1/0 (94)

I added line numbers. I also added a 100ms sleep after having accepted a packet
to get a nice ordered output according to timings. Of course the very same
problem is still happening without the sleep.

As you can see, the AAAA query is accepted by the queue but tcpdump doesn't see
it passing, and the browser is waiting in vain for an answer. It retries both
queries 5 seconds later, and this time, it works...

I could only reproduce this behavior within a web browser. Flooding the queue
with DNS queries (while true ; do dig www.mydomain.net ; done), even
simultaneously from two terminals (I have a 2 cores CPU) causes no trouble.

Using the queue on the DNS server side (2.6.37.2 too) in the INPUT chain
produces the same behavior: the first AAAA browser DNS query is lost.

I tried libnetfilter_queue 0.0.17 and 1.0.0 without noticing any difference.
When I tried the debian 2.6.32 kernel, it was working ok with the 1.0.0 lib, I
did not try 0.0.17.

Any idea which could explain this behavior?

Thanks
Fabien C.

PS: unrelated question, what should be a correct size of the recv() buffer: max
ip packet size (~65536) + nfnl headers? MTU?

--------------080806010604010101030306
Content-Type: text/x-csrc;
 name="nfq_test.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="nfq_test.c"

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <netinet/in.h>
#include <linux/types.h>
#include <linux/netfilter.h>	/* for NF_ACCEPT */

#include <libnetfilter_queue/libnetfilter_queue.h>

#include <time.h>
#include <errno.h>

#include <unistd.h> /* for usleep() */

/* returns packet id */
/*
static u_int32_t print_pkt (struct nfq_data *tb) {
	int id = 0;
	struct nfqnl_msg_packet_hdr *ph;
	struct nfqnl_msg_packet_hw *hwph;
	u_int32_t mark,ifi; 
	int ret;
	unsigned char *data;
	//char *data;

	ph = nfq_get_msg_packet_hdr(tb);
	if (ph) {
		id = ntohl(ph->packet_id); 
		printf("hw_protocol=0x%04x hook=%u id=%u ",
		ntohs(ph->hw_protocol), ph->hook, id);
	}

	hwph = nfq_get_packet_hw(tb);
	if (hwph) {
		int i, hlen = ntohs(hwph->hw_addrlen);

		printf("hw_src_addr=");
		for (i = 0; i < hlen-1; i++)
			printf("%02x:", hwph->hw_addr[i]);
		printf("%02x ", hwph->hw_addr[hlen-1]);
	}

	mark = nfq_get_nfmark(tb);
	if (mark)
		printf("mark=%u ", mark);

	ifi = nfq_get_indev(tb);
	if (ifi)
		printf("indev=%u ", ifi);

	ifi = nfq_get_outdev(tb);
	if (ifi)
		printf("outdev=%u ", ifi);
	ifi = nfq_get_physindev(tb);
	if (ifi)
		printf("physindev=%u ", ifi);

	ifi = nfq_get_physoutdev(tb);
	if (ifi)
		printf("physoutdev=%u ", ifi);

	ret = nfq_get_payload(tb, &data);
	if (ret >= 0)
		printf("payload_len=%d ", ret);

	fputc('\n', stdout);

	return id;
}
*/

/* From doc: 
 * - qh The queue handle returned by nfq_create_queue
 * - nfmsg message object that contains the packet
 * - nfad Netlink packet data handle
 * - data the value passed to the data parameter of nfq_create_queue
 */
static int cb(struct nfq_q_handle *qh, struct nfgenmsg *nfmsg,
		struct nfq_data *nfa, void *data) {

	//fprintf(stderr, "entering callback\n");
	//u_int32_t id = print_pkt(nfa);
	struct nfqnl_msg_packet_hdr *ph;	
	ph = nfq_get_msg_packet_hdr(nfa);
	u_int32_t id = ntohl(ph->packet_id); 

	struct timespec tp; 
	struct tm* lt; 
	if ( clock_gettime(0, &tp) == 0 ) {
		lt = localtime(&tp.tv_sec); 
		printf("%02d:%02d:%02d.%.6ld: setting verdict : accept the packet...\n", lt->tm_hour, lt->tm_min, lt->tm_sec, tp.tv_nsec/1000); 
	}
	return nfq_set_verdict(qh, id, NF_ACCEPT, 0, NULL);
}

int main(int argc, char* argv[]) {
	struct nfq_handle *h;
	struct nfq_q_handle *qh;
	int fd;
	int rv;
	char buf[4096] __attribute__ ((aligned));

	h = nfq_open();
	if (!h) {
		fprintf(stderr, "error during nfq_open()\n");
		exit(1);
	}

	printf("unbinding existing nf_queue handler for AF_INET (if any)\n");
	if (nfq_unbind_pf(h, AF_INET) < 0) {
		fprintf(stderr, "error during nfq_unbind_pf()\n");
		exit(1);
	}

	printf("binding nfnetlink_queue as nf_queue handler for AF_INET\n");
	if (nfq_bind_pf(h, AF_INET) < 0) {
		fprintf(stderr, "error during nfq_bind_pf()\n");
		exit(1);
	}

	printf("binding this socket to queue\n");
	qh = nfq_create_queue(h, 666, &cb, NULL);
	if (!qh) {
		fprintf(stderr, "error during nfq_create_queue()\n");
		exit(1);
	}

	printf("setting copy_packet mode\n");
	if (nfq_set_mode(qh, NFQNL_COPY_PACKET, 0xffff) < 0) {
		fprintf(stderr, "can't set packet_copy mode\n");
		exit(1);
	}

	fd = nfq_fd(h);
	fprintf(stderr, "waiting for input...\n");
//	while ((rv = recv(fd, buf, sizeof(buf), 0)) >= 0) {
//		printf("pkt received\n");
//		nfq_handle_packet(h, buf, rv);
//		printf("after handle_packet\n\n"); 
//	}
	struct timespec tp; 
	struct tm* lt; 
	while ( (rv = recv(fd, buf, sizeof(buf), 0)) >= 0 ) {

		if ( clock_gettime(0, &tp) == 0 ) {
			lt = localtime(&tp.tv_sec); 
			printf("%02d:%02d:%02d.%.6ld: recv returned %d\n", lt->tm_hour, lt->tm_min, lt->tm_sec, tp.tv_nsec/1000, rv); 
		}

		/*
		if( rv < 0 )
			perror("error during with recv()"); 
		else if( rv == 0 ) 
			printf("recv() returned 0\n"); 
		else {
			nfq_handle_packet(h, buf, rv);
			//printf("after handle_packet\n\n"); 
		}
		*/

		nfq_handle_packet(h, buf, rv); 
		//usleep(100000); 
	}


	printf("unbinding from queue\n");
	nfq_destroy_queue(qh);

#ifdef INSANE
	/* normally, applications SHOULD NOT issue this command, since
	* it detaches other programs/sockets from AF_INET, too ! */
	printf("unbinding from AF_INET\n");
	if( nfq_unbind_pf(h, AF_INET) != 0 ) {
		fprintf(stderr, "error during nfq_unbind_pf()\n");
	}
#endif

	printf("closing library handle\n");
	if( nfq_close(h) != 0 ) {
		fprintf(stderr, "error during nfq_close()\n");
	}

	return 0; 
}



--------------080806010604010101030306--
