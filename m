From: "Marty Leisner" <leisner@rochester.rr.com>
Subject: figuring out the udp port number (in linux >= 2.6.22)
Date: Sun, 16 Mar 2008 19:43:02 -0500
Message-ID: <200803170043.m2H0h2Xi016908@dell2.home>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:51278 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727AbYCPXmc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 16 Mar 2008 19:42:32 -0400
Received: from dell2.home ([66.67.48.11]) by hrndva-omta01.mail.rr.com
          with ESMTP
          id <20080316234231.XYMM6098.hrndva-omta01.mail.rr.com@dell2.home>
          for <netfilter-devel@vger.kernel.org>;
          Sun, 16 Mar 2008 23:42:31 +0000
Received: from dell2.home (localhost.localdomain [127.0.0.1])
	by dell2.home (8.13.4/8.12.8) with ESMTP id m2H0h2Xi016908
	for <netfilter-devel@vger.kernel.org>; Sun, 16 Mar 2008 19:43:02 -0500
Content-ID: <16905.1205714582.1@dell2.home>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Obviously I'm doing something wrong...My UDP port 
numbers look all wrong (I took at them raw and ran them 
through ntohs to see if anything looked right)
*They're a type __be16 -- which is network byte order?)

BTW, the IP addresses look fine, I wrote my own inet_ntoa_r...

I'm running wireshark alongside my module to see if I can get it to agree..

Here's my code:
static unsigned int main_hook(unsigned int hooknum,
                  struct sk_buff **skb,
                  const struct net_device *in,
                  const struct net_device *out,
                  int (*okfn)(struct sk_buff*))
{
        struct sk_buff *sock_buff;
        struct udphdr *udp_header;
        struct iphdr *ip_header;
        char address1[20];
        char address2[20];

        sock_buff = *skb;
        if(!sock_buff)
                return NF_ACCEPT;

        ip_header = ip_hdr(sock_buff);
        if(ip_header->protocol != IPPROTO_UDP)
                return NF_ACCEPT;
        udp_header =  udp_hdr(sock_buff);
        printk("udp source = %s dest %s\n", inet_ntoa_r(*(struct in_addr *) &ip_header->saddr, address1),
                                            inet_ntoa_r(*(struct in_addr *) &ip_header->daddr, address2));
        printk("udp packet = source port = %d, dest port = %d\n",ntohs(udp_header->source),
                                                        ntohs(udp_header->dest));
        printk("no ntohs: udp packet = source port = %, dest port = %d\n",udp_header->source,
                        udp_header->dest);

        return NF_ACCEPT;



