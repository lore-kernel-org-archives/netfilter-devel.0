From: Nicola Padovano <nicola.padovano@gmail.com>
Subject: fragmented packet
Date: Sat, 4 Sep 2010 19:09:05 +0200
Message-ID: <AANLkTikniSd5X_ryuhWbAyDLPa7oDSDULe1iYfG02vuP@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61169 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940Ab0IDRJ0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 4 Sep 2010 13:09:26 -0400
Received: by wwj40 with SMTP id 40so4311918wwj.1
        for <netfilter-devel@vger.kernel.org>; Sat, 04 Sep 2010 10:09:25 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi all! I'm write a simple netfilter module which recognize a fragmented packet.
First of all, i've used hping to send frag packet to my host (local
host), in particular i create only one packet (40 byte for default,
20bytes of header and 20 bytes of payload) specifying an MTU of 4
byte, so in this way i've to receive 5 packet (20bytes/4bytes of MTU).

So, this is the piece of code

[CODE]
#define FRAG_OFF(x) ntohs(x->frag_off) & IP_OFFSET
#define MORE_FRAG(x) ntohs(x->frag_off) & IP_MF
...
printk(KERN_INFO "sk_buff len: %d\n",skb->size);
...
struct iphdr *ip_header = (struct iphdr *)skb_network_header(skb);
...
if (FRAG_OFF || MORE_FRAG) {
   printk(KERN_INFO "!!!fragmented!!!\n");
   printk(KERN_INFO "frag off: %d\n",FRAG_OFF);
   printk(KERN_INFO "\n\n");
}
[/CODE]

then iptables (where TAR is my new target)
[IPTABLES]
iptables -t mangle -A PREROUTING -p tcp -s localhost -j TAR
[/IPTABLES]
(note: i use mangle table to have available PREROUTING hook, where the
packets are not yet defragmented)

so hpinging in this way (-c = packets' number, -m = mtu in byte)
[HPING]
hping -m 4 -c 1 localhost
[/HPING]

Now let's a look to output
[OUTPUT]
sk_buff len: 24
!!!fragmented!!!
frag off: 0

sk_buff len: 24
!!!fragmented!!!
frag off: 0

sk_buff len: 24
!!!fragmented!!!
frag off: 1

sk_buff len: 24
!!!fragmented!!!
frag off: 1

sk_buff len: 24
!!!fragmented!!!
frag off: 2
[/OUTPUT]

As you can see, there are two couples of frag with the same frag off:
the first and the second with 0 frag_off, then the third and the
fourth with 1 frag_off.
how is it possible?

Thank you guys!

-- 
Nicola Padovano
e-mail: nicola.padovano@gmail.com
web: http://npadovano.altervista.org
