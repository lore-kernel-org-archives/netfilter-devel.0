From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: fragmented packet
Date: Sat, 4 Sep 2010 20:25:57 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1009042024170.7459@obet.zrqbmnf.qr>
References: <AANLkTikniSd5X_ryuhWbAyDLPa7oDSDULe1iYfG02vuP@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Nicola Padovano <nicola.padovano@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:49572 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751678Ab0IDSZ7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 4 Sep 2010 14:25:59 -0400
In-Reply-To: <AANLkTikniSd5X_ryuhWbAyDLPa7oDSDULe1iYfG02vuP@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Saturday 2010-09-04 19:09, Nicola Padovano wrote:

>Hi all! I'm write a simple netfilter module which recognize a fragmented packet.

iptables -f? ip6tables -m frag? They already exist :)

>First of all, i've used hping to send frag packet to my host (local
>host), in particular i create only one packet (40 byte for default,
>20bytes of header and 20 bytes of payload) specifying an MTU of 4
>byte, so in this way i've to receive 5 packet (20bytes/4bytes of MTU).
>
>So, this is the piece of code
>
>[CODE]
>#define FRAG_OFF(x) ntohs(x->frag_off) & IP_OFFSET
>#define MORE_FRAG(x) ntohs(x->frag_off) & IP_MF
>...
>printk(KERN_INFO "sk_buff len: %d\n",skb->size);
>...
>struct iphdr *ip_header = (struct iphdr *)skb_network_header(skb);
>...
>if (FRAG_OFF || MORE_FRAG) {
>   printk(KERN_INFO "!!!fragmented!!!\n");
>   printk(KERN_INFO "frag off: %d\n",FRAG_OFF);
>   printk(KERN_INFO "\n\n");
>}
>[/CODE]
>
>then iptables (where TAR is my new target)
>[IPTABLES]
>iptables -t mangle -A PREROUTING -p tcp -s localhost -j TAR
>[/IPTABLES]
>(note: i use mangle table to have available PREROUTING hook, where the
>packets are not yet defragmented)

The mangle table does already receive defragmented packets (if defrag 
module is loaded).
