From: Thomas Mader <thezema@gmail.com>
Subject: Throughput test for kernelspace module vs. userspace daemon with
 strange results
Date: Fri, 11 Apr 2008 15:01:48 +0200
Message-ID: <47FF613C.4010701@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070203040904050300030301"
To: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:25618 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625AbYDKNBx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 11 Apr 2008 09:01:53 -0400
Received: by fg-out-1718.google.com with SMTP id l27so397249fgb.17
        for <netfilter-devel@vger.kernel.org>; Fri, 11 Apr 2008 06:01:51 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------070203040904050300030301
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hello,

I have two programs with a similar task. One is implemented as a 
kernelspace module and the other as a userspace daemon using 
libnetfilter_queue.
Bot work with the same algorithm and inspect udp packets, send icmp 
packets on special events and receive icmp replys.
I did a throughput test for both the following way:

On my laptop I start the module/daemon and start a netperf udp stream 
from my laptop to a server on LAN. The module/daemon inspect the udp 
stream and does it's work. When the test is over, netperf shows me the 
throughput which came through to the server.
Without any module/daemon running I get ~95mbit/s for my 100mbit LAN.
The funny thing though is, that I get ~85mbit/s with my kernelspace 
module but ~90mbit/s with my userspace daemon.

I thought about explanations for this but I don't come to reasonable 
explanations for this behaviour. Shouldn't the kernelspace module be 
faster? Why is it slower?
Maybe somebody on the list has answers to this questions.
I attached the code of my implementations.

thanks in advance,
Thomas

--------------070203040904050300030301
Content-Type: text/x-csrc;
 name="queue_daemon.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="queue_daemon.c"

/*
 * queue_daemon.c
 * detects bursts and calculates the round trip time by using ICMP packets
 *
 * Copyright (C) 2007  Thomas Mader <thezema@gmail.com>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */
#include <linux/netfilter.h>
#include <libnetfilter_queue/libnetfilter_queue.h>
#include <netinet/ip.h> 
#include <netinet/ip_icmp.h>
#include <netinet/udp.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/time.h>
#include <sys/socket.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include "list.h"

#define BUFSIZE 4096
#define BURST_LENGTH 5

static                     LIST_HEAD(list);
static float               threshold = 1.0;
static FILE*               logfile = NULL;
static struct 			   nfq_handle *h = NULL;

#define NIPQUAD(addr) \
         ((unsigned char *)&addr)[0], \
         ((unsigned char *)&addr)[1], \
         ((unsigned char *)&addr)[2], \
         ((unsigned char *)&addr)[3]
         
         
struct conn_id {

	int id;
	u_int32_t src_ip, dst_ip;
	u_int16_t src_port, dst_port;

	int blength;

	double tstamp;
	double sum;

	struct list_head elem;

	int echo_request_count;
	int echo_reply_count;

};


u_short
in_cksum(const u_short *addr, register int len, u_short csum)
{
	register int nleft = len;
	const u_short *w = addr;
	register u_short answer;
	register int sum = csum;

	/*
	 *  Our algorithm is simple, using a 32 bit accumulator (sum),
	 *  we add sequential 16 bit words to it, and at the end, fold
	 *  back all the carry bits from the top 16 bits into the lower
	 *  16 bits.
	 */
	while (nleft > 1)  {
		sum += *w++;
		nleft -= 2;
	}

	/* mop up an odd byte, if necessary */
	if (nleft == 1)
		sum += htons(*(u_char *)w << 8);

	/*
	 * add back carry outs from top 16 bits to low 16 bits
	 */
	sum = (sum >> 16) + (sum & 0xffff);	/* add hi 16 to low 16 */
	sum += (sum >> 16);			/* add carry */
	answer = ~sum;				/* truncate to 16 bits */
	return (answer);
}



#define DATALEN sizeof(struct icmphdr)+sizeof(struct timeval)
char outpack[DATALEN];
int ntransmitted = 0;

struct sockaddr_in whereto;	/* who to ping */

static struct {
	struct cmsghdr cm;
	struct in_pktinfo ipi;
} cmsg = { {sizeof(struct cmsghdr) + sizeof(struct in_pktinfo), SOL_IP, IP_PKTINFO},
	   {0, }};
	   
int cmsg_len = sizeof(cmsg);
int icmp_sock;			/* socket file descriptor */
struct sockaddr_in source;

int send_probe(char* target)
{	
	struct icmphdr *icp;
	
	source.sin_family = AF_INET;
	source.sin_addr.s_addr = INADDR_ANY;

	bzero((char *)&whereto, sizeof(whereto));
	whereto.sin_family = AF_INET;


	inet_aton(target, &whereto.sin_addr);

	icp = (struct icmphdr *)outpack;
	icp->type = ICMP_ECHO;
	icp->code = 0;
	icp->checksum = 0;
	icp->un.echo.sequence = htons(ntransmitted++);
	icp->un.echo.id = 0;
	
	struct timeval ts;
	gettimeofday(&ts, NULL);
	memcpy(icp+1, &ts, sizeof(struct timeval));

	/* compute ICMP checksum here */
	icp->checksum = in_cksum((u_short *)icp, DATALEN, 0);
	
	static struct iovec iov = {outpack, 0};
	static struct msghdr m = { &whereto, sizeof(whereto),
						   &iov, 1, &cmsg, 0, 0 };
	m.msg_controllen = cmsg_len;
	iov.iov_len = DATALEN;

	return sendmsg(icmp_sock, &m, 0);
}


static void writeLog(char* message) {

	struct timeval tv;
	gettimeofday(&tv, NULL);
	fprintf(logfile, "[%li.%.9li] %s", tv.tv_sec, tv.tv_usec, message);
	fflush(logfile);
}



static void cleanExit()
{
	if (h) {
		nfq_close(h);
		h = NULL;
	}
	
	if (logfile) {
		fclose(logfile);
		logfile = NULL;
	}
	
	exit(EXIT_FAILURE);
}


static int icmp_echo_request(char* target) {	
	return send_probe(target);
}


static void deal_with_icmp(char* payload) {
	int  id;

	struct iphdr *iph = (struct iphdr*) payload;
	struct icmphdr *icmph = (struct icmphdr*) (payload + (4 * iph->ihl));
	
	// TODO check if ICMP reply is really one of ours (random key?)
	 
	// check if ICMP packet is an echo reply
	if(icmph->type != ICMP_ECHOREPLY) {
		return;
	}

	// retrieve time from ICMP data
	struct timeval *intime = (struct timeval*) (icmph + 1);
	double incoming_time = (double)intime->tv_sec + (double)intime->tv_usec/1000000;

	// retrieve id from ICMP header
	id = icmph->un.echo.id;

	/* compute round-trip-time */
	struct timeval  ctime;
	gettimeofday(&ctime, NULL);
	double current_time = (double)ctime.tv_sec + (double)ctime.tv_usec/1000000;
	double diff = current_time - incoming_time;

	/* check if we have an entry with this id and add echo reply and RTT */
	if(!list_empty(&list)) {
		struct conn_id *p;
		list_for_each_entry(p, &list, elem) {
			
			if( id == p->id) {
				p->echo_reply_count++;
				p->sum += diff;
				fprintf(logfile, "new diff: %lf\n", p->sum);
				break;
			}
		}
	}
}


static int cb(struct nfq_q_handle *qh, struct nfgenmsg *nfmsg,
	      struct nfq_data *nfa, void *data)
{
	struct nfqnl_msg_packet_hdr *ph;
	int id = 0;
	
	ph = nfq_get_msg_packet_hdr(nfa);
	if (ph){
		id = ntohl(ph->packet_id);
	}
	
	char *payload;
	if(nfq_get_payload(nfa, &payload) < 0) {
		writeLog("could not get payload\n");
	}
	
	struct iphdr *iph = (struct iphdr*) payload;

	switch (iph->protocol) {
		case 1:  deal_with_icmp(payload); // ICMP
				 return nfq_set_verdict(qh, id, NF_ACCEPT, 0, NULL);
		case 17: break;  // UDP
		default: return nfq_set_verdict(qh, id, NF_ACCEPT, 0, NULL);
	}
	

	double time = 0.0;
	struct timeval tv;
	if ( nfq_get_timestamp(nfa, &tv) < 0 ) {
		gettimeofday(&tv, NULL);
		time = (double)tv.tv_sec + (double)tv.tv_usec/1000000;
	} else {
		time = (double)tv.tv_sec + (double)tv.tv_usec/1000000;
	}
	
	
	
	struct udphdr *udph = (struct udphdr*) (payload + (4 * iph->ihl));


	/* search our list of connections for existing connection with this data */
	int found_id = 0;
	if(!list_empty(&list)) {
		struct conn_id *p;
		list_for_each_entry(p, &list, elem) {
			if (   (iph->saddr == p->src_ip)
			    && (iph->daddr == p->dst_ip)
			    && (udph->source == p->src_port)
			    && (udph->dest == p->dst_port) ) {
			    
				float diff = time - p->tstamp;

				found_id = 1;

				if( diff > threshold ) {
					p->blength = 1;
				}
				// diff <= threshold
				else {
					p->blength++;
				}
				
				fprintf(logfile, "new tstamp added to already existing id %d.\n", p->id);

				// the burst reaches the max burst length
				if(p->blength >= BURST_LENGTH) {
					writeLog("Sending ICMP echo request.\n");
					char addy[16];
					snprintf(addy, 15, "%u.%u.%u.%u", NIPQUAD(iph->daddr)); //TODO change to saddr/daddr!!!
					
					if (icmp_echo_request(addy) < 0) {
						writeLog("Failed to send ICMP echo request.\n");
					} else {
						p->echo_request_count++;
					}
					p->blength = 0;
				}						

				p->tstamp = time;
				
				struct timeval tv;
				gettimeofday(&tv, NULL);
				fprintf(logfile, "[%li.%li] new timestamp for %u.%u.%u.%u:%hu, TO: %u.%u.%u.%u:%hu\n", tv.tv_sec, tv.tv_usec, NIPQUAD(iph->saddr), ntohs(udph->source), NIPQUAD(iph->daddr), ntohs(udph->dest));
				fflush(logfile);
				break;
			}
		}
	}

	if(!found_id) {
		struct conn_id* new_id = (struct conn_id*)malloc(sizeof(struct conn_id));
		if(!new_id) {
			writeLog("Could not allocate struct for entry\n");
			cleanExit();
		}

		/* new_id->id = connection_id; */
		INIT_LIST_HEAD(&new_id->elem);
		list_add_tail(&new_id->elem, &list);

		new_id->tstamp = time;
		new_id->sum = 0.0;
		new_id->blength = 1;
		new_id->echo_request_count = 0;
		new_id->echo_reply_count = 0;
		new_id->src_ip = iph->saddr;
		new_id->src_port = udph->source;
		new_id->dst_ip = iph->daddr;
		new_id->dst_port = udph->dest;

		struct timeval tv;
		gettimeofday(&tv, NULL);
		fprintf(logfile, "[%li.%li] new entry for %u.%u.%u.%u:%hu, TO: %u.%u.%u.%u:%hu\n", tv.tv_sec, tv.tv_usec, NIPQUAD(iph->saddr), ntohs(udph->source), NIPQUAD(iph->daddr), ntohs(udph->dest));
	}
	
	
	
	return nfq_set_verdict(qh, id, NF_ACCEPT, 0, NULL);
}



int main(int argc, char **argv)
{
	pid_t pid, sid;

	logfile = fopen("log", "w");
	if (!logfile) {
		printf("Could not open logfile\n");
		cleanExit();
	}
	writeLog("logfile opened\n");
	

	/* Fork off the parent process */
	pid = fork();
	if (pid < 0) {
		writeLog("Failed to fork\n");
		cleanExit();
	}
	/* If we got a good PID, then
	 * we can exit the parent process.
	 */
	if (pid > 0) {
		exit(EXIT_SUCCESS);
	}

	/* Create a new SID for the child process */
	sid = setsid();
	if (sid < 0) {
		writeLog("Could not create new SID\n");
		cleanExit();
	}

	/* Close the standard file descriptors */
	close(STDIN_FILENO);
	close(STDOUT_FILENO);
	close(STDERR_FILENO);

	/* Daemon-specific initialization goes here */
	struct nfq_q_handle *qh;
	struct nfnl_handle *nh;
	int fd;
	int rv;
	char buf[BUFSIZE];

	h = nfq_open();
	if (!h) {
		writeLog("error during nfq_open()\n");
		cleanExit();
	}

	// unbinding existing nf_queue handler for AF_INET (if any)
	if (nfq_unbind_pf(h, AF_INET) < 0) {
		writeLog("error during nfq_unbind_pf()\n");
		cleanExit();
	}

	// binding nfnetlink_queue as nf_queue handler for AF_INET
	if (nfq_bind_pf(h, AF_INET) < 0) {
		writeLog("error during nfq_bind_pf()\n");
		cleanExit();
	}

	// binding this socket to queue '0'
	qh = nfq_create_queue(h,  0, &cb, NULL);
	if (!qh) {
		writeLog("error during nfq_create_queue()\n");
		cleanExit();
	}

	// setting copy_packet mode
	if (nfq_set_mode(qh, NFQNL_COPY_PACKET, 0xffff) < 0) {
		writeLog("can't set packet_copy mode\n\n");
		cleanExit();
	}

	nh = nfq_nfnlh(h);
	fd = nfnl_fd(nh);
	
	icmp_sock = socket(AF_INET, SOCK_RAW, IPPROTO_ICMP);
	if (icmp_sock < 0) {
		writeLog("Could not create socket\n");
		cleanExit();
	}
	if (bind(icmp_sock, (struct sockaddr*)&source, sizeof(source)) ) {
		writeLog("Could not bind socket\n");
		cleanExit();	
	}
	
	while ((rv = recv(fd, buf, sizeof(buf), 0)) && rv >= 0) {
		nfq_handle_packet(h, buf, rv);
	}

	
	
	
	
	
	/*do {
		status = ipq_read(h, buf, BUFSIZE, 0);
		if (status < 0) {
			writeLog("Could not read the packet\n");
			cleanExit();
		}
			
		switch (ipq_message_type(buf)) {
			case NLMSG_ERROR:
				fprintf(logfile, "Received error message: %s\n", ipq_errstr() );
				break;
			case IPQM_PACKET: {
				ipq_packet_msg_t *m = ipq_get_packet(buf);

				analysePacket(m);
				
				status = ipq_set_verdict(h, m->packet_id, NF_ACCEPT, 0, NULL);
				if (status < 0) {
					writeLog("Could not set verdict on packet\n");
					cleanExit();
				}
				break;
			}

			default:
				writeLog("Unknown message type!\n");
				break;
		}
	} while (1);*/


	// unbinding from queue 0
	nfq_destroy_queue(qh);

	// closing library handle
	nfq_close(h);
	
	if (logfile) {
		fclose(logfile);
		logfile = NULL;
	}
	
	return EXIT_SUCCESS;
}

--------------070203040904050300030301
Content-Type: text/x-csrc;
 name="ipt_piggyback.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ipt_piggyback.c"

/*
 * ipt_piggyback.c
 * detects bursts and calculates the round trip time by using ICMP packets
 *
 * Copyright (C) 2006  Helmut Duregger <helmutduregger@gmail.com>
 * Copyright (C) 2006  Thomas Mader <thezema@gmail.com>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */
#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/in.h>
#include <linux/udp.h>
#include <linux/icmp.h>
#include <linux/list.h>
#include <linux/slab.h>
#include <linux/time.h>
#include <linux/proc_fs.h>

#include <linux/netfilter_ipv4/ip_tables.h>
#include <linux/netfilter_ipv4/ipt_piggyback.h>

#include <net/ip.h>
#include <net/icmp.h>
#include <net/sock.h>

#include <asm/div64.h>

/* struct holding information about the data streams we watch */
struct ipt_pbc {

	unsigned int id;
	u_int32_t src_ip, dst_ip;        /* src and dst address of this stream */
	u_int16_t src_port, dst_port;    /* src and dst port of this stream */

	int blength;                     /* current burst length for this id */

	struct timespec tstamp;
	struct timespec sum;             /* sum of time differences */

	struct list_head elem;

	int echo_request_count;          /* number of ICMP echo requests sent */
	int echo_reply_count;            /* number of ICMP echo replies received */
};

/* list head of all our stream information structs */
static LIST_HEAD(list); 
/* temporal threshold that two successive packets
 * need to fall short of to add 1 to the blength of
 * that stream
 */          
static struct timespec threshold = { 1, 0 };
static unsigned int burst_length = 5;                             
                                      
static void set_normalized_timespec2(struct timespec *ts, time_t sec, long nsec)
{
        while (nsec >= NSEC_PER_SEC) {
                nsec -= NSEC_PER_SEC;
                ++sec;
        }
        while (nsec < 0) {
                nsec += NSEC_PER_SEC;
                --sec;
        }
        ts->tv_sec = sec;
        ts->tv_nsec = nsec;
}                                      
                                      

/*
 * from R. Stevens's Network Programming
 * http://www.koders.com/c/fid257CD7A223E72DDA44DBDD4939BC87F3AEE2098C.aspx?s=cksum
 * NOTE: Some checksum algorithms only work on an even number of bytes.
 *       We have an even number here, so this is not too important.
 */
static __u16 in_cksum(__u16 *buf, int nbytes)
{
	__u32 sum;
	__u16 oddbyte;

	sum = 0;
	while (nbytes > 1) {
		sum += *buf++;
		nbytes -= 2;
	}

	if (nbytes == 1) {
		oddbyte = 0;
		*((__u16 *) &oddbyte) = *(__u16 *) buf;
		sum += oddbyte;
	}

	sum = (sum >> 16) + (sum & 0xffff);
	sum += (sum >> 16);

	return (__u16) ~sum;
}


/* begin -- from iputils_ping tool but heavily modified
 *
 * Our ICMP part consists of the 8 bytes ICMP header plus
 * 2 long int values from the struct timespec (16 bytes)
 * which makes 24 bytes in total for the ICMP header + data.
 */
#define DATA_LEN 24

static struct {
	struct cmsghdr cm;
	struct in_pktinfo ipi;
} cmsg = { { sizeof(struct cmsghdr) + sizeof(struct in_pktinfo),
             SOL_IP, IP_PKTINFO }, { 0, } };
static u_char              outpack[DATA_LEN];
static struct socket       *sock;
static int                 cmsg_len = sizeof(cmsg);
static struct sockaddr_in  source;
static struct sockaddr_in  destination;

static int send_probe(u_int32_t target)
{	
	static struct iovec   iov = {outpack, 0};
	static struct msghdr  m = { &destination, sizeof(destination), &iov, 1,
	                            &cmsg, 0, 0 };
	struct icmphdr      *icp;
	struct timespec     ts;

	memset(&outpack, 0, DATA_LEN);

	if (!sock) {
		printk(KERN_ERR "ipt_piggyback: ICMP socket is NULL!\n");
		return -1;
	}

	memset((char *)&destination,0, sizeof(destination));
	destination.sin_family = AF_INET;
	destination.sin_addr.s_addr = target;
	
	icp = (struct icmphdr *)outpack;
	icp->type = ICMP_ECHO;
	icp->code = 0;
	icp->checksum = 0;
	icp->un.echo.sequence = 0;
	icp->un.echo.id = 0;
	
	/* copy current time to data of packet */
	
	getnstimeofday(&ts);
	printk(KERN_DEBUG "ipt_piggyback: [%li.%.9li] writing tstamp to ICMP echo request.\n",
	       ts.tv_sec, ts.tv_nsec);
	memcpy(icp+1, &ts, sizeof(struct timespec));

	/* compute ICMP checksum here */
	icp->checksum = in_cksum((u_short *)icp, DATA_LEN);

	m.msg_controllen = cmsg_len;
	iov.iov_len = DATA_LEN;
	


	
	return kernel_sendmsg(sock, &m, (struct kvec*)&iov, 1, DATA_LEN);

}
/* end -- from iputils_ping tool but heavily modified */



static void deal_with_icmp(const struct sk_buff *skb) {

	struct timespec  incoming_time, current_time, diff;
	u_int16_t  id;
	u_char     type;
	u_char     code;

	// TODO check if ICMP reply is really one of ours (random key?)

	/* NOTE: we are using skb_copy_bits instead of direct pointer
	 *       reference here because that returned totally random
	 *       values when testing.
	 */
	 
	/* check if ICMP packet is an echo reply */
	skb_copy_bits(skb, sizeof(struct iphdr), &type, 1);
	skb_copy_bits(skb, sizeof(struct iphdr)+1, &code, 1);
	if ( type || code ) {
		return;
	}

	/* retrieve time from ICMP data */
	memset(&incoming_time, 0, sizeof(struct timespec)); 
	skb_copy_bits(skb, sizeof(struct iphdr)+sizeof(struct icmphdr),
	              &incoming_time, sizeof(struct timespec));

	
	/* retrieve id from ICMP header */
	skb_copy_bits(skb, sizeof(struct iphdr)+4, &id, 2);

	/* compute round-trip-time */
	getnstimeofday(&current_time);
	set_normalized_timespec2(&diff, current_time.tv_sec - incoming_time.tv_sec,
	                                current_time.tv_nsec - incoming_time.tv_nsec);

	/* check if we have an entry with this id and add echo reply and RTT */
	if(!list_empty(&list)) {
		struct ipt_pbc *p;
		list_for_each_entry(p, &list, elem) {
			
			if( id == p->id) {
				p->echo_reply_count++;
				set_normalized_timespec2(&p->sum, p->sum.tv_sec + diff.tv_sec,
				                         p->sum.tv_nsec + diff.tv_nsec);
				break;
			}
		}
	}
}



static int find_id_set_values_send_icmp(struct timespec time, const struct sk_buff *skb)
{
	int found_id = 0;

	if(!list_empty(&list)) {
		struct ipt_pbc *p;

		list_for_each_entry(p, &list, elem) {
			/* found the id */
			if (   (skb->nh.iph->saddr == p->src_ip)
			    && (skb->nh.iph->daddr == p->dst_ip)
			    && (skb->h.uh->source == p->src_port)
			    && (skb->h.uh->dest == p->dst_port) ) {
				struct timespec diff;
				
				found_id = 1;
				set_normalized_timespec2(&diff,
				                         time.tv_sec - p->tstamp.tv_sec,
				                         time.tv_nsec - p->tstamp.tv_nsec);
				
				/* diff > threshold */
				if ( timespec_compare(&diff, &threshold) > 0 ) {
					p->blength = 1;
				}
				/* diff <= threshold */
				else {
					p->blength++;
				}

				printk(KERN_DEBUG "ipt_piggyback: new tstamp added to already existing id %d.\n", p->id);

				/* the burst reaches the max burst length */
				if(p->blength >= burst_length) {

					printk(KERN_DEBUG "ipt_piggyback: Sending ICMP echo request.\n");
					if (send_probe(skb->nh.iph->daddr) < 0) {
						printk(KERN_WARNING "ipt_piggyback: Failed to send ICMP echo request.\n");
					} else {
						p->echo_request_count++;
					}
					p->blength = 0;
				}						

				p->tstamp = time;

				break;
			}
		}
	}
	return found_id;	
}



static int allocate_add_pbc(struct timespec time,
                            const struct sk_buff *skb)
{
	struct ipt_pbc* new = (struct ipt_pbc*)kmalloc(sizeof(struct ipt_pbc),
	                                               GFP_ATOMIC);
	
	if(!new) {
		return -1;
	}
	
	new->id = 0;
	INIT_LIST_HEAD(&new->elem);
	list_add_tail(&new->elem, &list);
	
	new->tstamp = time;
	new->sum.tv_sec = 0;
	new->sum.tv_nsec = 0;
	new->blength = 1;
	new->echo_request_count = 0;
	new->echo_reply_count = 0;
	new->src_ip = skb->nh.iph->saddr;
	new->src_port = skb->h.uh->source;
	new->dst_ip = skb->nh.iph->daddr;
	new->dst_port = skb->h.uh->dest;
	return 0;
}


static int match(const struct sk_buff     *skb,
                 const struct net_device  *in,
                 const struct net_device  *out,
                 const struct xt_match    *match,
                 const void               *matchinfo,
                 int                      offset,
                 unsigned int             protoff,
                 int                      *hotdrop)
{
	int found_id = 0;
	struct timeval                  stamp;
	struct timespec                 time;

	/* Skip protocols we do not deal with */
	if (skb->nh.iph->protocol != IPPROTO_UDP
	    && skb->nh.iph->protocol != IPPROTO_ICMP)
	{
		return 0;
	/* Deal with ICMP */
	} else if (skb->nh.iph->protocol == IPPROTO_ICMP) {
		deal_with_icmp(skb);
		return 0;
	}

	/*
	 * Deal with UDP packets
	 */

	/* if timestamp is not set, set it */
    if (skb->tstamp.off_sec == 0) {
      	__net_timestamp((struct sk_buff *)skb);
	}

	/* retrieve the time stamp from the sk_buff */
	skb_get_timestamp(skb, &stamp);
	time.tv_sec = stamp.tv_sec;
	time.tv_nsec = stamp.tv_usec * NSEC_PER_USEC;
	find_id_set_values_send_icmp(time, skb);

	/* create a new connection if not found */
	if(!found_id) {
		if (allocate_add_pbc(time, skb) < 0)
		{
			printk(KERN_WARNING "ipt_piggyback: Could not create new connection entry for id.\n");
		} else {
			printk(KERN_DEBUG "ipt_piggyback: New tstamp added to new created id.\n");
		}
	}

   	return 0;
}


/*
static int piggyback_checkentry(const char *tablename,
                                const void *ip,
                                const struct xt_match *match,
                                void *matchinfo,
                                unsigned int matchsize,
                                unsigned int hook_mask)
{
	if (matchsize != IPT_ALIGN(sizeof(struct ipt_piggyback_info))) {
		printk(KERN_ERR "ipt_piggyback: Matchsize differs! Have you forgotten to recompile me? Aborting.\n");
		return 0;
	}
	

	printk(KERN_INFO "ipt_piggyback: Registered with hook mask 0x%x into the %s table.\n",
	       hook_mask, tablename);
	return 1;
}
*/

static struct ipt_match ipt_piggyback_match = {
	.list       = { NULL, NULL },
	.name       = "piggyback",
	.match      = match,
	.checkentry	= NULL, // piggyback_checkentry,
	.destroy    = NULL,
	.me         = THIS_MODULE,
	.matchsize  = sizeof(struct ipt_piggyback_info)
};



#ifdef CONFIG_PROC_FS
static int show_piggyback(char* buffer, char** start,
                          off_t offset, int length)
{
	int size;
	s64 tmp;
	unsigned long mod;
	struct ipt_pbc *p = NULL;

	memset(buffer, 0, length);

	if(!list_empty(&list)) {
		list_for_each_entry(p, &list, elem) {
			tmp = timespec_to_ns(&p->sum);
			/* mod is remainder and the result is in tmp */
			if(p->echo_reply_count > 0)
				mod = do_div(tmp, p->echo_reply_count);
			else
				tmp = 0;

			sprintf(buffer,
			        "%s[%d] %u.%u.%u.%u:%hu -> %u.%u.%u.%u:%hu reqs:%d reps:%d mean:%lldns\n",
			        buffer,
			        p->id,
			        NIPQUAD(p->src_ip), ntohs(p->src_port),
			        NIPQUAD(p->dst_ip), ntohs(p->dst_port),
			        p->echo_request_count,
			        p->echo_reply_count,
			        tmp);
		}
	}
	size = sprintf(buffer, "%s\n", buffer);
	*start = buffer + offset;
	size -= offset;
	return (size > length) ? length : (size > 0) ? size : 0;
}



static int show_piggyback_threshold(char* buffer, char** start,
                                    off_t offset, int length)
{
	int size;
	
	size = sprintf(buffer, "threshold (in nanoseconds): %lu\n",
	               threshold.tv_sec*NSEC_PER_SEC + threshold.tv_nsec);
	*start = buffer + offset;
	size -= offset;
	return (size > length) ? length : (size > 0) ? size : 0;
}



static int show_piggyback_burst_length(char* buffer, char** start,
                                       off_t offset, int length)
{
	int size;
	
	size = sprintf(buffer, "burst_length: %u\n", burst_length);
	*start = buffer + offset;
	size -= offset;
	return (size > length) ? length : (size > 0) ? size : 0;
}



static int write_piggyback_threshold(struct file *file, const char *buffer,
                                     unsigned long count, void *data)
{
	long val = 0;
	char buf[21];  /* expecting at most 19 digits (signed long) + '-' + '\n' */
	char *endp;

	if (count > sizeof(buf)) {
		return -EINVAL;
	}
	if (copy_from_user(buf, buffer, count)) {
		return -EFAULT;
	}
	val = simple_strtol(buf, &endp, 10);
	if (*endp != '\n') {
		return -EINVAL;
	}
	if (val <= 0) {
		return -EINVAL;
	}
	set_normalized_timespec2(&threshold, 0, val); 
	return count;
}



static int write_piggyback_burst_length(struct file *file, const char *buffer,
                                        unsigned long count, void *data)
{
	unsigned int val = 0;
	char buf[11];  /* expecting at most 10 digits + '\n' */
	char *endp;

	if (count > sizeof(buf)) {
		return -EINVAL;
	}
	if (copy_from_user(buf, buffer, count)) {
		return -EFAULT;
	}
	val = (unsigned int)simple_strtoul(buf, &endp, 10);
	if (*endp != '\n') {
		return -EINVAL;
	}
	if (val == 0) {
		return -EINVAL;
	}
	burst_length = val;
	return count;
}
#endif /* CONFIG_PROC_FS */



static int __init init(void) {
	int ret, error;
#ifdef CONFIG_PROC_FS
	/* prepare proc entries */
	struct proc_dir_entry* proc_piggyback;
	struct proc_dir_entry* proc_piggyback_t;
	struct proc_dir_entry* proc_piggyback_b;
	//volatile int dummy;

	proc_piggyback = create_proc_info_entry("net/ipt_piggyback",
	                                        0, 0, show_piggyback);
	if (!proc_piggyback) {
		printk(KERN_ERR "ipt_piggyback: Cannot create /proc/net/ipt_piggyback!\n");
		goto err_proc_piggyback;
	}
	
	proc_piggyback_t = create_proc_info_entry("net/ipt_piggyback_threshold",
	                                          0, 0, show_piggyback_threshold);
	if (!proc_piggyback_t) {
		printk(KERN_ERR "ipt_piggyback: Cannot create /proc/net/ipt_piggyback_threshold!\n");
		goto err_proc_threshold;
	}

	proc_piggyback_b = create_proc_info_entry("net/ipt_piggyback_burst_length",
	                                          0, 0, show_piggyback_burst_length);
	if (!proc_piggyback_b) {
		printk(KERN_ERR "ipt_piggyback: Cannot create /proc/net/ipt_piggyback_burst_length!\n");
		goto err_proc_burst_length;
	}
	
	proc_piggyback_t->write_proc = write_piggyback_threshold;
	proc_piggyback_b->write_proc = write_piggyback_burst_length;
#endif /* CONFIG_PROC_FS */
	
	/* create and bind socket for sending ICMP echo requests */
	error = sock_create_kern(PF_INET, SOCK_RAW, IPPROTO_ICMP, &sock);
	if (error) {
		printk(KERN_ERR "ipt_piggyback: Could not create socket!\n");
		goto err_sock;
	}
	memset(&source, 0, sizeof(source));
	source.sin_family = AF_INET;
	source.sin_addr.s_addr = INADDR_ANY;

	error = sock->ops->bind(sock, (struct sockaddr*)&source,
	                        sizeof(struct sockaddr_in));
	if (error) {
		printk(KERN_ERR "ipt_piggyback: Could not bind socket!\n");
		goto err_bind;
	}

	ret = ipt_register_match(&ipt_piggyback_match);
	if (ret) {
		printk(KERN_ERR "ipt_piggyback: Error registering match module!\n");
		goto err_match;
	}
	
	return ret;
	
err_match:
err_bind:
	sock_release(sock);
err_sock:
#ifdef CONFIG_PROC_FS	
	remove_proc_entry("net/ipt_piggyback_burst_length", 0);
err_proc_burst_length:
	remove_proc_entry("net/ipt_piggyback_threshold", 0);
err_proc_threshold:
	remove_proc_entry("net/ipt_piggyback", 0);
err_proc_piggyback:
#endif /* CONFIG_PROC_FS */
	return -EINVAL;
}



static void __exit fini(void) {
	struct ipt_pbc *p, *n;
	
	/* clean up memory */
	list_for_each_entry_safe(p, n, &list, elem) {
		kfree(p);
	}

#ifdef CONFIG_PROC_FS
	remove_proc_entry("net/ipt_piggyback_burst_length", 0);	
	remove_proc_entry("net/ipt_piggyback_threshold", 0);
	remove_proc_entry("net/ipt_piggyback", 0);
#endif /* CONFIG_PROC_FS */

	if (sock) {
		sock_release(sock);
	}

	ipt_unregister_match(&ipt_piggyback_match);
	
	printk(KERN_INFO "ipt_piggyback: Module removed.\n");
}

module_init(init);
module_exit(fini);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Helmut Duregger && Thomas Mader");
MODULE_DESCRIPTION("iptables Burst-PiggyBack match module");

--------------070203040904050300030301--
