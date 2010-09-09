From: Pete Kay <petedao@gmail.com>
Subject: need help with capturing packet and bytes count from conntrack
Date: Thu, 9 Sep 2010 21:19:51 +0800
Message-ID: <AANLkTimVxDP9PMOcA2bAXqcxiXj+J1Yx1n3Jfvferntr@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:65284 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080Ab0IINTw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Sep 2010 09:19:52 -0400
Received: by gyd8 with SMTP id 8so610022gyd.19
        for <netfilter-devel@vger.kernel.org>; Thu, 09 Sep 2010 06:19:52 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I am trying to write a small piece of code to obtain the packet count
and bytes count for a connection.

Here is what I get from conntrack -L

[root@linux]# conntrack -L -p udp -s 192.168.1.179 -d 192.168.1.115
--sport 10374
udp      17 88 src=192.168.1.179 dst=192.168.1.115 sport=10374
dport=26926 packets=850 bytes=170000 src=192.168.1.56
dst=192.168.1.115 sport=16395 dport=26924 packets=571 bytes=159880
[ASSURED] mark=0 use=1

=============
When I run the following source code, I get 0 for all caller_bytes,
callee_bytes, caller_packets, callee_packets, does anyone know what is
wrong with my code here?


 uint32_t caller_bytes, callee_bytes, caller_packets, callee_packets;
        int ret = 0;
        struct nfct_handle *h;
        struct nf_conntrack *ct;
        ct = nfct_new();
        if (!ct) {
                perror("nfct_new");

        }

        switch_log_printf(SWITCH_CHANNEL_CHANNEL_LOG(channel),
SWITCH_LOG_DEBUG, "end_point_media_ip=[%s] end_point_media_port=[%s]
server_media_ip=[%s] se$

        nfct_set_attr_u8(ct, ATTR_L3PROTO, AF_INET);
        nfct_set_attr_u32(ct, ATTR_IPV4_SRC, inet_addr("192.168.1.179"));
        nfct_set_attr_u32(ct, ATTR_IPV4_DST, inet_addr("192.168.1.115"));
        nfct_set_attr_u8(ct, ATTR_L4PROTO, IPPROTO_UDP);
        nfct_set_attr_u16(ct, ATTR_PORT_SRC, htons(10374);
        nfct_set_attr_u16(ct, ATTR_PORT_DST, htons(26926);

        h = nfct_open(CONNTRACK, 0);
        if (!h) {
                perror("nfct_open");
        }
        ret = nfct_query(h, NFCT_Q_GET, ct);
        printf("TEST: query conntrack ");
        if (ret == -1)
              printf("(%d)(%s)\n", ret, strerror(errno));
        else
              printf("(OK)\n");


        caller_bytes = nfct_get_attr_u32(ct, ATTR_ORIG_COUNTER_BYTES);
        callee_bytes = nfct_get_attr_u32(ct, ATTR_REPL_COUNTER_BYTES);
        caller_packets = nfct_get_attr_u32(ct, ATTR_ORIG_COUNTER_PACKETS);
        callee_packets = nfct_get_attr_u32(ct, ATTR_REPL_COUNTER_PACKETS);
        nfct_close(h);

        printf("caller_bytes=[%lu] callee_bytes=[%lu]
caller_packet=[%lu] callee_packet=[%lu]\n", (unsigned
long)caller_bytes, (unsigned long)callee_bytes, (unsigned
long)caller_packets,(unsigned long) callee_packets);




Thank you in advance for all your kind help.



thanks,
P
