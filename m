From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: TCP-packet with PUSH flag with wrong payload data in LOCAL_OUT
Date: Thu, 22 Jan 2009 17:11:31 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0901221705140.30491@fbirervta.pbzchgretzou.qr>
References: <7031232632416@webmail11.yandex.ru> <alpine.LSU.2.00.0901221521450.24791@fbirervta.pbzchgretzou.qr> <68611232638800@webmail51.yandex.ru>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Vladimir Kobylyanskiy <kentlinux@yandex.ru>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:43057 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753304AbZAVQLc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 Jan 2009 11:11:32 -0500
In-Reply-To: <68611232638800@webmail51.yandex.ru>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2009-01-22 16:40, Vladimir Kobylyanskiy wrote:

>> >		in_dev = (struct in_device *)dev->ip_ptr;
>> Don't cast this.
>
>Why?

Because it is not needed. ip_ptr is a void * (at least
in [dr]ecent kernels).

>I add more debug-print to function "check_packet" - to show You,
> that the packet has payload data and it is not fragmented:
>
>            info("=== HOOK_PACKET: packet src_addr=%u.%u.%u.%u:%u dst_addr=%u.%u.%u.%u:%u [%s] protocol=%u, IN_OUT=%d, DATA_OFF = %u, TCP_DATA_LEN = %u, if_fragmented = %u",
>                            IP_PRINTF(skb->nh.iph->saddr),ntohs(tcp->source),IP_PRINTF(skb->nh.iph->daddr),ntohs(tcp->dest),
>                            tcp_flags, skb->nh.iph->protocol, in_out, tcp_data_off, tcp_data_len, if_fragmented);
>            if(tcp->psh && ntohs(tcp->dest) == 80)
>            {
>                    info("=== HOOK_PACKET: DATA=%02x %02x %02x %02x %02x %02x", tcp_data[0],tcp_data[1],tcp_data[2],tcp_data[3],tcp_data[4],tcp_data[5]);
>//                  return NF_ACCEPT;
>            }

>Jan 22 17:27:42 FW_EXT kernel: my_fw: fw_init(): Driver my_fw started
>Jan 22 17:27:45 FW_EXT kernel: my_fw: check_packet(): === HOOK_PACKET: packet src_addr=192.168.0.198:37118 dst_addr=192.168.0.132:80 [S  ] protocol=6, IN_OUT=1, DATA_OFF = 40, TCP_DATA_LEN = 0, if_fragmented = 0
>Jan 22 17:27:45 FW_EXT kernel: my_fw: check_packet(): === HOOK_PACKET: packet src_addr=192.168.0.132:80 dst_addr=192.168.0.198:37118 [SA ] protocol=6, IN_OUT=0, DATA_OFF = 40, TCP_DATA_LEN = 0, if_fragmented = 0
>Jan 22 17:27:45 FW_EXT kernel: my_fw: check_packet(): === HOOK_PACKET: packet src_addr=192.168.0.198:37118 dst_addr=192.168.0.132:80 [ A ] protocol=6, IN_OUT=1, DATA_OFF = 32, TCP_DATA_LEN = 0, if_fragmented = 0
>Jan 22 17:27:45 FW_EXT kernel: my_fw: check_packet(): === HOOK_PACKET: packet src_addr=192.168.0.198:37118 dst_addr=192.168.0.132:80 [ AP] protocol=6, IN_OUT=1, DATA_OFF = 32, TCP_DATA_LEN = 101, if_fragmented = 0
>Jan 22 17:27:45 FW_EXT kernel: my_fw: check_packet(): === HOOK_PACKET: DATA=02 00 01 00 01 00
>
>You see - it has 101 bytes of payload and it is not fragmented!

Very well. But there still is another case I can think of -
non-linear skb.

	struct tcphdr tcpbuf;
	const struct tcphdr *th;
	
	th = skb_header_pointer(skb, ip_hdrlen(skb), sizeof(tcpbuf), &tcpbuf);
	if (th->psh && ntohs(tcp->dest) == 80) {
		char n[4];

		if (skb_copy_bits(skb, ip_hdrlen(skb) + 4*tcp->doff,
		    n, sizeof(n)) >= 0)
			printk("data: %02x %02x %02x %02x\n", n[0], n[1],
			       n[2], n[3]);
	}

>May be when TCP packet with PUSH flag sended from localhost, payload data stored is some special buffer?

I do not think there is a special buffer (it's not the "urgent"
tcp thing), but it may be at an alternate location.
Using skb_header_pointer/copy_bits should give some
more insight.

>Or kernel copy payload data after all firewall checks? (may be for some optimisation reasons )
>
>
>Jan 22 17:27:45 FW_EXT kernel: my_fw: check_packet(): === HOOK_PACKET: packet src_addr=192.168.0.132:80 dst_addr=192.168.0.198:37118 [ A ] protocol=6, IN_OUT=0, DATA_OFF = 32, TCP_DATA_LEN = 0, if_fragmented = 0
>Jan 22 17:27:45 FW_EXT kernel: my_fw: check_packet(): === HOOK_PACKET: packet src_addr=192.168.0.132:80 dst_addr=192.168.0.198:37118 [ AP] protocol=6, IN_OUT=0, DATA_OFF = 32, TCP_DATA_LEN = 842, if_fragmented = 0
>Jan 22 17:27:45 FW_EXT kernel: my_fw: check_packet(): === HOOK_PACKET: packet src_addr=192.168.0.198:37118 dst_addr=192.168.0.132:80 [ A ] protocol=6, IN_OUT=1, DATA_OFF = 32, TCP_DATA_LEN = 0, if_fragmented = 0
>Jan 22 17:27:45 FW_EXT kernel: my_fw: check_packet(): === HOOK_PACKET: packet src_addr=192.168.0.198:37118 dst_addr=192.168.0.132:80 [ A ] protocol=6, IN_OUT=1, DATA_OFF = 32, TCP_DATA_LEN = 0, if_fragmented = 0
>Jan 22 17:27:45 FW_EXT kernel: my_fw: check_packet(): === HOOK_PACKET: packet src_addr=192.168.0.132:80 dst_addr=192.168.0.198:37118 [ A ] protocol=6, IN_OUT=0, DATA_OFF = 32, TCP_DATA_LEN = 0, if_fragmented = 0
>Jan 22 17:27:45 FW_EXT kernel: my_fw: check_packet(): === HOOK_PACKET: packet src_addr=192.168.0.198:37118 dst_addr=192.168.0.132:80 [ A ] protocol=6, IN_OUT=1, DATA_OFF = 32, TCP_DATA_LEN = 0, if_fragmented = 0
>Jan 22 17:27:49 FW_EXT kernel: my_fw: fw_cleanup(): Driver my_fw stoped
>
>=============
>

