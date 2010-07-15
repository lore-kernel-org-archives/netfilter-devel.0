From: "MAI JIN" <Jin.Mai@alcatel-sbell.com.cn>
Subject: 'HELP ME PLEASE.  libnetfilter_queue issue
Date: Thu, 15 Jul 2010 16:08:31 +0800
Message-ID: <1DB91DF937A4544C81E636468B91C21C06F1ECAF@CNSHGSMBS03.ad4.ad.alcatel.com>
References: <1DB91DF937A4544C81E636468B91C21C06F1EC28@CNSHGSMBS03.ad4.ad.alcatel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
To: <netfilter-devel@vger.kernel.org>, <netfilter@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cnshjsmin03.alcatel-sbell.com.cn ([211.144.215.47]:42302 "EHLO
	cnshjsmin03.alcatel-sbell.com.cn" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932641Ab0GOIIc convert rfc822-to-8bit
	(ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Jul 2010 04:08:32 -0400
Content-class: urn:content-classes:message
In-Reply-To: <1DB91DF937A4544C81E636468B91C21C06F1EC28@CNSHGSMBS03.ad4.ad.alcatel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


 Hi, 

I'm a new user to libnetfilter_queue. I ran the test example of
libnetfilter_queue-1.0.0 on a Debian x86 (Linux debian 2.6.26-1-686)
host but I found that the pakcets queue in NFQUEUE were not dequeued
after recv() was invoked. I ran the iptables command on the debain host:
iptables -A INPUT -p udp --dport 8192:32000 -j NFQUEUE --queue-num 0

Then I send UDP packets from another machine with destination port in
the range. By default, the libnetfilter_queue received 1000 packets on
Debian host and stopped (blocked in recv()). Then I set the queue length
to 12000 nfq_set_queue_maxlen(qh, 1200) . This time, the
libnetfilter_queue received 1200 packets and stopped (blocked in
recv()). 

Looks like the pakcets were not dequeued from NFQUEUE? How can I fix
this problem? 

int main(int argc, char **argv) 
{ 
        struct nfq_handle *h; 
        struct nfq_q_handle *qh; 
        struct nfnl_handle *nh; 
        int fd; 
        int rv; 
        char buf[4096] __attribute__ ((aligned)); 

        printf("opening library handle\n"); 
        h = nfq_open(); 
        if (!h) { 
                fprintf(stderr, "error during nfq_open()\n"); 
                exit(1); 
        } 

        printf("unbinding existing nf_queue handler for AF_INET (if
any)\n"); 
        if (nfq_unbind_pf(h, AF_INET) < 0) { 
                fprintf(stderr, "error during nfq_unbind_pf()\n"); 
                exit(1); 
        } 

        printf("binding nfnetlink_queue as nf_queue handler for
AF_INET\n"); 
        if (nfq_bind_pf(h, AF_INET) < 0) { 
                fprintf(stderr, "error during nfq_bind_pf()\n"); 
                exit(1); 
        } 

        printf("binding this socket to queue '0'\n"); 
        qh = nfq_create_queue(h,  0, &cb, NULL); 
        if (!qh) { 
                fprintf(stderr, "error during nfq_create_queue()\n"); 
                exit(1); 
        } 

        printf("setting copy_packet mode\n"); 
        if (nfq_set_mode(qh, NFQNL_COPY_PACKET, 0xffff) < 0) { 
                fprintf(stderr, "can't set packet_copy mode\n"); 
                exit(1); 
        } 

        if (nfq_set_queue_maxlen(qh, 1200) < 0) { 
                fprintf(stderr, "can't set queue_maxlen\n"); 
                exit(1); 
        } 

        fd = nfq_fd(h); 

        while ((rv = recv(fd, buf, sizeof(buf), 0)) && rv >= 0) { 
                nfq_handle_packet(h, buf, rv); 
        } 

        printf("unbinding from queue 0\n"); 
        nfq_destroy_queue(qh); 

#ifdef INSANE 
        /* normally, applications SHOULD NOT issue this command, since 
         * it detaches other programs/sockets from AF_INET, too ! */ 
        printf("unbinding from AF_INET\n"); 
        nfq_unbind_pf(h, AF_INET); 
#endif 

        printf("closing library handle\n"); 
        nfq_close(h); 

        exit(0); 
} 


Best regards 
=========================== 
Mai Jin 
Alcatel Shanghai Bell (Nanjing) Co. Ltd. 
Alcatel-Net: 2735-5011 
Tel: (+86)-25-8473 1240-5011 
Addr: 11F, Yangtse River Tech Park. 
           Building No.40 of Nanchang Road, 
           Gulou District, Nanjing, China 
Zip: 210037 
jin.mai@Alcatel-sbell.com.cn 
ASB/MoAD/RDR/BSR APL 
  

