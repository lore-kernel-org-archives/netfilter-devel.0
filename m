From: Kuzin Andrey <kuzinandrey@yandex.ru>
Subject: Re: I need help with libnetfilter_queue
Date: Sun, 23 Nov 2008 17:59:57 +0300
Message-ID: <14310596125.20081123175957@yandex.ru>
References: <92770c820811230603p4276d98bnc41df9606f4c6bc8@mail.gmail.com>
Reply-To: Kuzin Andrey <kuzinandrey@yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: ilninno <ilninno@gmail.com>, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.mjkmail.ru ([212.45.5.115]:36302 "HELO mail.mjkmail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758195AbYKWO67 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 23 Nov 2008 09:58:59 -0500
In-Reply-To: <92770c820811230603p4276d98bnc41df9606f4c6bc8@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

i> Hi again! I need help with libnetfilter_queue, I searched examples,
i> but I only found one simple test. My problem is that i need source ip
i> and source port, but i don't know how can i get from struct nfq_data
i> *pkt in the callback function.

#include <netinet/in.h>
#include <arpa/inet.h>
#include <netinet/ip.h>
#include <netinet/tcp.h>

static int ob_netfilter_callback(struct nfq_q_handle *qh, struct nfgenmsg *nfmsg,
              struct nfq_data *nfa, void *data)
{
............
u_int16_t ip_packet_len = 0;
struct ip *ip_packet = NULL;
struct tcphdr *tcp_packet = NULL;

char *payload;
..........

nfq_get_payload(nfa, &payload);

ip_packet = ((struct ip *)payload);
ip_packet_len = ntohs(ip_packet->ip_len);

printf("Source IP %s\n",inet_ntoa(ip_packet->ip_src));

if (ip_packet->ip_p == IPPROTO_TCP) {
   tcp_packet = (struct tcphdr *)(payload + sizeof(struct ip));
   if (ntohs(tcp_packet->dest) == 25) { // SMTP PORT
      printf("this is SMTP");
   };
};

