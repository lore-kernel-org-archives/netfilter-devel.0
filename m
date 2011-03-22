From: Pierre Rondou <prondou@gmail.com>
Subject: Problem sending skb built from scratch with IPv6
Date: Wed, 23 Mar 2011 00:45:09 +0100
Message-ID: <4D893485.5050709@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:12681 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753809Ab1CVXpO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Mar 2011 19:45:14 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi all,


I'm a student at the University of Liege (Belgium) and for my master 
thesis, I have to devellop a netfilter module implementing NatIvI and Nat64.

Basically, those modules ask to "translate" an Ipv4 packet to an IPv6 
one (and in the other side aswell), you can find more detailled 
information on the IETF website.

For my modules, I use xtables-addons.

I have been able to do every step correctly, but one:
Sending the newly created IPv6 packet to the network.

The modules, as stated by the protocols, need to be able to send packet 
with IP that doesn't belong to them (i.e, sort of spoofing).
Everything works fine for the newly created IPv4 skb (I can see the 
packets in wireshark), you can see the source code at the end.

But for Ipv6, the only think I see is neighbour solicitation messages 
(ICMPv6) for both the source IP and the dest IP.
There is one only case when the program works: when the source IP of the 
packet is the same as the interface's one.

Even more curious, the two function I call for my IPv6 sending return 0 
(ip6_route_output and ip6_local_out), meaning that they were successfull.

So, my question is simple:
"How can I send an IPv6 paquet, built from scratch (new skb) to the 
network?"


Thanks in advance for your help,


Pierre Rondou




Finaly, here are some info you might find usefull:

The source code used for the new IPv4 packets (working 100%), it's 
copied from the NAT64 module available in GPL:

    newskb->protocol = htons(ETH_P_IP);

    newip = ip_hdr(newskb);

    memset(&fl, 0, sizeof(fl));
    fl.fl4_dst = newip->daddr;
    fl.fl4_tos = RT_TOS(newip->tos);
    fl.proto = newskb->protocol;
    if (ip_route_output_key(&init_net, &rt, &fl))
    {
       printk("error: ip_route_output_key failed\n");
       return NF_DROP;
    }

    if (!rt)
    {
       printk("error: rt null\n");
       return NF_DROP;
    }


    newskb->dev = rt->u.dst.dev;
    skb_dst_set(newskb, (struct dst_entry *)rt);
    if(ip_local_out(newskb)) {
           printk("error: ip_local_out failed\n");
           return NF_DROP;
    }



Here the IPv6 code, NOT WORKING:

    newskb->protocol = htons(ETH_P_IPV6);

    newip = ipv6_hdr(newskb);

    memset(&fl, 0, sizeof(fl));
    fl.fl6_src = newip->saddr;
    fl.fl6_dst = newip->daddr;
    fl.fl6_flowlabel = 0;
    fl.proto = newskb->protocol;
    dst = ip6_route_output(&init_net, NULL, &fl);
    if (!dst)
    {
       printk("error: ip_route_output_key failed\n");
       return NF_DROP;
    }

    skb_dst_set(newskb, dst);
    newskb->dev = dst->dev;
    skb_dst_set(newskb, dst);
    if(ip6_local_out(newskb)) {
       printk("error: ip_local_out failed\n");
       return NF_DROP;
    }

    pr_info("Packet sent \n");

    return NF_DROP;


my network configuration:

# The primary network interface
allow-hotplug eth1
iface eth1 inet static
         address 192.168.1.40
         netmask 255.255.255.0
         gateway 192.168.1.1

#IPV6 static configuration
iface eth1 inet6 static
         address 2001:6a8:2d80:128::0001
         netmask 64
         gateway 2001:6a8:2d80:128::0002
# END IPV6 configuration

route result:

# route --inet
Table de routage IP du noyau
Destination     Passerelle      Genmask         Indic Metric Ref    Use 
Iface
192.168.1.0     *               255.255.255.0   U     0      0        0 eth1
default         192.168.1.1     0.0.0.0         UG    0      0        0 eth1


# route --inet6
Table de routage IPv6 du noyau
Destination                    Next Hop                   Flag Met Ref 
Use If
2001:6a8:2d80:128::/64         ::                         U    256 0     
1 eth1
fe80::/64                      ::                         U    256 0     
0 eth1
::/0                           2001:6a8:2d80:128::2       UG   1   0    
35 eth1
::/0                           ::                         !n   -1  1    
61 lo
::1/128                        ::                         Un   0   1    
80 lo
2001:6a8:2d80:128::/128        ::                         Un   0   1     
0 lo
2001:6a8:2d80:128::1/128       ::                         Un   0   1    
20 lo
fe80::/128                     ::                         Un   0   1     
0 lo
fe80::20e:a6ff:feb0:e1a2/128   ::                         Un   0   1    
14 lo
ff00::/8                       ::                         U    256 0     
0 eth1
::/0                           ::                         !n   -1  1    
61 lo


