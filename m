From: Vladimir Kobylyanskiy <kentlinux@yandex.ru>
Subject: Re: TCP-packet with PUSH flag with wrong payload data in LOCAL_OUT
Date: Thu, 22 Jan 2009 18:40:00 +0300
Message-ID: <68611232638800@webmail51.yandex.ru>
References: <7031232632416@webmail11.yandex.ru> <alpine.LSU.2.00.0901221521450.24791@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: "Netfilter Developer Mailing List" <netfilter-devel@vger.kernel.org>
To: "Jan Engelhardt" <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from forwards6.yandex.ru ([77.88.61.38]:58631 "EHLO
	forwards6.yandex.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbZAVPuh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 Jan 2009 10:50:37 -0500
In-Reply-To: <alpine.LSU.2.00.0901221521450.24791@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

22.01.09, 17:27, "Jan Engelhardt" <jengelh@medozas.de>:

> ># define IP_PRINTF(addr) ((addr) & 0xff), (((addr) >> 8) & 0xff), (((addr) >> 16) & 0xff), (((addr) >> 24) & 0xff)
> Use NIPQUAD and NIPQUAD_FMT.

Ok. Thank you.

> >int ip_packet_from_local_host(struct iphdr *iph)
> >{
> >	struct net_device *dev   = NULL;
> >	struct in_device *in_dev = NULL;
> >	struct in_ifaddr *ifaddr = NULL;
> >	
> >	for (dev = dev_base; dev; dev = dev->next)
> >	{
> >		if (!dev->ip_ptr)
> >		{
> >			continue;
> >		}
> >		in_dev = (struct in_device *)dev->ip_ptr;
> Don't cast this.

Why?


> Now consider this - tcp_data[0] invokes undefined behavior when
>  * there is no payload
>  * or the packet is fragmented (a corner case, though)
> Most likely the former is your case.

> >    ret = check_packet(skb, (short)1); //1 - out
> Do not do redundant casts.
Ok. :)


I add more debug-print to function "check_packet" - to show You, that the packet has payload data and it is not fragmented:

Rewrited function:
==================================================================

static unsigned int check_packet(struct sk_buff *skb, short in_out)
{
    if(skb->nh.iph->protocol == IPPROTO_TCP)
    {
            struct tcphdr       *tcp;
            char                *tcp_data=NULL;
            char                tcp_flags[4];
            unsigned int        tcp_data_off=0;
            unsigned int        tcp_data_len=0;
            unsigned int        if_fragmented = 0;
            unsigned int        flag_MORE_FRAGMENTS = 0;
            unsigned int        FRAGMENT_OFFSET = 0;

            flag_MORE_FRAGMENTS = ntohs(skb->nh.iph->frag_off) & 0x2000;
            FRAGMENT_OFFSET = ntohs(skb->nh.iph->frag_off) & 0x1fff;

            if( (flag_MORE_FRAGMENTS == 1) || (FRAGMENT_OFFSET != 0))
            {
                    if_fragmented = 1;
            }

            tcp = (struct tcphdr *)((char*)skb->nh.iph + skb->nh.iph->ihl * 4);
            tcp_data_off = (tcp->doff)*4;

            tcp_data_len = ntohs(skb->nh.iph->tot_len) - (skb->nh.iph->ihl * 4) - tcp_data_off;

            tcp_data = (char *)tcp + tcp_data_off;
            tcp_flags[0]=' ';
            tcp_flags[1]=' ';
            tcp_flags[2]=' ';
            tcp_flags[3]='\0';

            if(tcp->syn)
                    tcp_flags[0] = 'S';
            if(tcp->ack)
                    tcp_flags[1] = 'A';
            if(tcp->psh)
                    tcp_flags[2] = 'P';
            info("=== HOOK_PACKET: packet src_addr=%u.%u.%u.%u:%u dst_addr=%u.%u.%u.%u:%u [%s] protocol=%u, IN_OUT=%d, DATA_OFF = %u, TCP_DATA_LEN = %u, if_fragmented = %u",
                            IP_PRINTF(skb->nh.iph->saddr),ntohs(tcp->source),IP_PRINTF(skb->nh.iph->daddr),ntohs(tcp->dest),
                            tcp_flags, skb->nh.iph->protocol, in_out, tcp_data_off, tcp_data_len, if_fragmented);
            if(tcp->psh && ntohs(tcp->dest) == 80)
            {
                    info("=== HOOK_PACKET: DATA=%02x %02x %02x %02x %02x %02x", tcp_data[0],tcp_data[1],tcp_data[2],tcp_data[3],tcp_data[4],tcp_data[5]);
//                  return NF_ACCEPT;
            }
    }

==================================================================






Syslog output:
=============
Jan 22 17:27:42 FW_EXT kernel: my_fw: fw_init(): Driver my_fw started
Jan 22 17:27:45 FW_EXT kernel: my_fw: check_packet(): === HOOK_PACKET: packet src_addr=192.168.0.198:37118 dst_addr=192.168.0.132:80 [S  ] protocol=6, IN_OUT=1, DATA_OFF = 40, TCP_DATA_LEN = 0, if_fragmented = 0
Jan 22 17:27:45 FW_EXT kernel: my_fw: check_packet(): === HOOK_PACKET: packet src_addr=192.168.0.132:80 dst_addr=192.168.0.198:37118 [SA ] protocol=6, IN_OUT=0, DATA_OFF = 40, TCP_DATA_LEN = 0, if_fragmented = 0
Jan 22 17:27:45 FW_EXT kernel: my_fw: check_packet(): === HOOK_PACKET: packet src_addr=192.168.0.198:37118 dst_addr=192.168.0.132:80 [ A ] protocol=6, IN_OUT=1, DATA_OFF = 32, TCP_DATA_LEN = 0, if_fragmented = 0
Jan 22 17:27:45 FW_EXT kernel: my_fw: check_packet(): === HOOK_PACKET: packet src_addr=192.168.0.198:37118 dst_addr=192.168.0.132:80 [ AP] protocol=6, IN_OUT=1, DATA_OFF = 32, TCP_DATA_LEN = 101, if_fragmented = 0
Jan 22 17:27:45 FW_EXT kernel: my_fw: check_packet(): === HOOK_PACKET: DATA=02 00 01 00 01 00

You see - it has 101 bytes of payload and it is not fragmented!
May be when TCP packet with PUSH flag sended from localhost, payload data stored is some special buffer?
Or kernel copy payload data after all firewall checks? (may be for some optimisation reasons )


Jan 22 17:27:45 FW_EXT kernel: my_fw: check_packet(): === HOOK_PACKET: packet src_addr=192.168.0.132:80 dst_addr=192.168.0.198:37118 [ A ] protocol=6, IN_OUT=0, DATA_OFF = 32, TCP_DATA_LEN = 0, if_fragmented = 0
Jan 22 17:27:45 FW_EXT kernel: my_fw: check_packet(): === HOOK_PACKET: packet src_addr=192.168.0.132:80 dst_addr=192.168.0.198:37118 [ AP] protocol=6, IN_OUT=0, DATA_OFF = 32, TCP_DATA_LEN = 842, if_fragmented = 0
Jan 22 17:27:45 FW_EXT kernel: my_fw: check_packet(): === HOOK_PACKET: packet src_addr=192.168.0.198:37118 dst_addr=192.168.0.132:80 [ A ] protocol=6, IN_OUT=1, DATA_OFF = 32, TCP_DATA_LEN = 0, if_fragmented = 0
Jan 22 17:27:45 FW_EXT kernel: my_fw: check_packet(): === HOOK_PACKET: packet src_addr=192.168.0.198:37118 dst_addr=192.168.0.132:80 [ A ] protocol=6, IN_OUT=1, DATA_OFF = 32, TCP_DATA_LEN = 0, if_fragmented = 0
Jan 22 17:27:45 FW_EXT kernel: my_fw: check_packet(): === HOOK_PACKET: packet src_addr=192.168.0.132:80 dst_addr=192.168.0.198:37118 [ A ] protocol=6, IN_OUT=0, DATA_OFF = 32, TCP_DATA_LEN = 0, if_fragmented = 0
Jan 22 17:27:45 FW_EXT kernel: my_fw: check_packet(): === HOOK_PACKET: packet src_addr=192.168.0.198:37118 dst_addr=192.168.0.132:80 [ A ] protocol=6, IN_OUT=1, DATA_OFF = 32, TCP_DATA_LEN = 0, if_fragmented = 0
Jan 22 17:27:49 FW_EXT kernel: my_fw: fw_cleanup(): Driver my_fw stoped

=============
