From: "GoMi ." <gomiuk@hotmail.com>
Subject: Questions regarding CONNMARK
Date: Thu, 19 Jun 2003 11:56:57 +0000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Law8-F73qctrLlhEfS50003f1d1@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

  Hi there, i am using your module ip_conntrack, to set up a QoS system. Let 
me explain you my idea first:

I have 2 ADSL connections, and my box (debian + kernel 2.4.21) is doing 
loadbalancing, i have a QoS solution using HTB, and an stateful firewall to 
follow the connectios via both links. To do the QoS i need to mark the 
packets, being the marks:
  - 1 Interactive traffic
  - 2 Non-Interactive traffic
  - 3 (Used to be SYN/ACK packets)
  - 4 ICMP
  - 5 My web server

I have 200 users, nearly all using p2p (KaZaA, Imesh, etc..) Here is a 
little ASCII to clarify:



                                                     ___________   eth0
_______________             eth2     |                   |­_________ ADSL1
| User's Switch       |_____________|                   |
|_______________|                       |    Linux Box  |
                                                   |                   
|_________ ADSL2
                                                   |___________|  eth 1

What i do is mark in the post routing chain the packets using conntrack and 
string to mark he connectios and then make them go through different Qdiscs 
to apply QoS.

I have a doubt. Since my connection is asymetric, if unstead of using 
conntrack i just apply marks based on --dport and SYN or ACKS i get a better 
downspeed.

My reasoning is this is because i need to send ACK packets once the 
connection is stablished as fast as i can, so the destination host, can 
continue sending me packets.

Can you correct me if i am wrong? Am i wright thinking that for every packet 
i recieve i need to send an ack? Well, i am not sure if thats true for every 
packet or just for the window size of the tcp connection.

My final question is, does conntrack when doing --restore-mark (based on my 
reasoning) also applys the mark to the ACK packets? I attach the script for 
the mangle table. If i am right, is there a way to mark ACK packets with a 
different mark from that of the connection?

Thank you very much!!!

#!/bin/bash
iptables -t mangle -F

#############################################
## Rules
##

  iptables -t mangle -N marks
    iptables -t mangle -A marks -p icmp -j MARK --set-mark 4
    iptables -t mangle -A marks -p udp -j MARK --set-mark 1
    iptables -t mangle -A marks -p tcp --dport 80 -j MARK --set-mark 1
    iptables -t mangle -A marks -p tcp --dport 20 -j MARK --set-mark 1
    iptables -t mangle -A marks -p tcp --dport 21 -j MARK --set-mark 1
    iptables -t mangle -A marks -p tcp --dport 22 -j MARK --set-mark 1
    iptables -t mangle -A marks -p tcp --dport 23 -j MARK --set-mark 1
    iptables -t mangle -A marks -p tcp --dport 25 -j MARK --set-mark 1
    iptables -t mangle -A marks -p tcp --dport 110 -j MARK --set-mark 1
    iptables -t mangle -A marks -p tcp --dport 143 -j MARK --set-mark 1
    iptables -t mangle -A marks -p tcp --dport 443 -j MARK --set-mark 1
    iptables -t mangle -A marks -p tcp --dport 6667 -j MARK --set-mark 1
    iptables -t mangle -A marks -p tcp -s 192.168.4.2 --sport 80 -j MARK 
--set-mark 5
#    iptables -t mangle -A marks -p tcp --tcp-flags SYN,ACK,RST ACK -j MARK 
--set-mark 3
#    iptables -t mangle -A marks -p tcp --tcp-flags SYN,ACK,RST SYN -j MARK 
--set-mark 3
   iptables -t mangle -A marks -m mark --mark 0 -j MARK --set-mark 2
  iptables -t mangle -A marks -j RETURN

  iptables -t mangle -N kazaa
   iptables -t mangle -A kazaa -m string --string 'X-Kazaa-' -j MARK 
--set-mark 2
  iptables -t mangle -A kazaa -j RETURN

  iptables -t mangle -N msn
    iptables -t mangle -A msn -m string --string 'x-msn-messenger' -j MARK 
--set-mark 1
  iptables -t mangle -A msn -j RETURN


  iptables -t mangle -A POSTROUTING -j CONNMARK --restore-mark
  iptables -t mangle -A POSTROUTING -m mark ! --mark 0 -j ACCEPT
  iptables -t mangle -A POSTROUTING -m mark --mark 0 -j msn
  iptables -t mangle -A POSTROUTING -m mark --mark 0 -j kazaa
  iptables -t mangle -A POSTROUTING -m mark --mark 0 -j marks
  iptables -t mangle -A POSTROUTING -j CONNMARK --save-mark

_________________________________________________________________
Charla con tus amigos en línea mediante MSN Messenger: 
http://messenger.yupimsn.com/
