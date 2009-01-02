From: Giacomo <delleceste@gmail.com>
Subject: checksum calculation for an OUTPUT DNATted packet
Date: Fri, 2 Jan 2009 23:47:52 +0100
Message-ID: <885896af0901021447g3cdcf81as283779cfeacfe9b2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ew0-f17.google.com ([209.85.219.17]:61362 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692AbZABWr4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 2 Jan 2009 17:47:56 -0500
Received: by ewy10 with SMTP id 10so6942547ewy.13
        for <netfilter-devel@vger.kernel.org>; Fri, 02 Jan 2009 14:47:53 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi to everybody.

Implementing a kernel module that changes an IP or port in a packet in
OUTPUT (realizing the so
called OUTPUT DNAT), I have to recalculate the checksum of the packet.

It is not clear to me if I have to use tcp_v4_check or csum_tcpudp_magic.

 csum_tcpudp_magic works fine like this:

iph->check = 0;
iph->check = ip_fast_csum((u8 *) iph, iph->ihl);

th->check =  csum_tcpudp_magic(iph->saddr, iph->daddr, datalen,
IPPROTO_TCP, skb_checksum(skb, iph->ihl * 4, datalen, 0));

where datalen = skb->len - iph->ihl * 4;

and skb is struct sk_buff.

Instead the tcp_v4_check(), used as follows, does not work:

struct tcphdr tcphead;
iph->check = 0;
iph->check = ip_fast_csum((u8 *) iph, iph->ihl);

 th  = skb_header_pointer(skb, iph->ihl * 4,
                                       sizeof(tcphead), &tcphead);

th->check = tcp_v4_check(skb->len - 4 * iph->ihl, iph->saddr, iph->daddr,
                               csum_partial((char *) th, len - 4 *
iph->ihl, 0));

Can someone tell me where I am wrong?

I need to use a generic function to (re) calculate the checksum, also
compatible with the
older kernels (and so I cannot use inet_proto_csum_replace4() - or
inet_proto_csum_replace2 - for instance).

Another particular: tcp_v4_check() used as above, works when applied
to packet DNATted in PRE-ROUTING,
while it does not in OUTPUT DNAT, as in the subject of this message.

Thanks in advance.

Giacomo.

-- 
Giacomo S.
http://www.giacomos.it

- - - - - - - - - - - - - - - - - - - - - -

* Aprile 2008: iqfire-wall, un progetto
  open source che implementa un
  filtro di pacchetti di rete per Linux,
  e` disponibile per il download qui:
  http://sourceforge.net/projects/ipfire-wall

* Informazioni e pagina web ufficiale:
  http://www.giacomos.it/iqfire/index.html

- - - - - - - - - - - - - - - - - - - - - -

 . ''  `.
:   :'    :
 `.  ` '
    `- Debian GNU/Linux -- The power of freedom
        http://www.debian.org
