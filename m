From: "andre achternaam" <andreiscmeel@hotmail.com>
Subject: Why UDP packet loss in the stack
Date: Wed, 27 Nov 2002 12:38:04 +0000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <F127ZiTETFTzfHD0lYt0000a246@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
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


We encounter UDP packet loss. We are aware of the unreliable nature of UDP 
but the way we loss packets is rather strange.  Assume 2 PCs linked with a 
cross Ethernet cable. One PC having an UDP testserver and the other an UDP 
client.

Besides the UDP client we have also a tcpdump -nn -x -i eth0 > dumpfile 
running.
Looking at the packets (every packet has a increasing number) in the UDP 
client we encounter sometimes (appears to be random…) packet loss. Sometimes 
+/-50 successive packets. Even seen losses of more than 150 packets in a 
row. Actually we never found a loss of one packet in a row, up till now.

When searching the dumpfile will learn that the packets do arrive at the pc! 
Oke so they are lost somewhere in the stack. Why?

Some context of our UDP testserver:
The UDP server streams as fast as possible (although send socket call is 
synchronize) e.g. 50 Mega bit of data and will sleep the rest of the second 
before it send the next chunk of packets (50 Mbit in total). The packet size 
is 1500 minus UDP /IP header lengths. Both PCs have a NIC that is 100 Mbit. 
Every packet has a tracking number in the payload that is increased for 
every packet.

Does anybody know where/why they are lost? Is there a max of the outstanding 
packets in the kernel? If yes how do I tweak this max. How do I detect if 
the stack desides to throw away some of the UDP packets (statistics).

At the moment the server side is not the problem but this is not proven yet.

Examining the dumpfile we found the also packet loss but not the 
packetnumbers we found in the UDP client. So this implies that the udpdump 
is not recording every packet. Is this right?

Current settings in proc/sys/net/core

hot_list_length = 128
Lo_cong = 100
Message_burst = 50
Message_cost  =  5
Mod_cong  = 290
Netdev_max_backlog = 300
No_cong = 20
No_cong_tresh  = 20
Opt_memmax = 10240
[r/w]mem_[default/max] = 65535

Grep from the web
hot_list_length, maximum number of skb-heads to be cached, default 128 What 
does this mean?
optmem_max, maximum amount of option memory buffers.  What does this mean?
net.core.rmem_max, maximum receive socket buffer size, default 65535  What 
does this mean? Do I suffer from it while sending /receiving packets with 
the size of 1500bytes



All related information is appreciated

Thanx in advance Andre

_________________________________________________________________
MSN 8 with e-mail virus protection service: 2 months FREE* 
http://join.msn.com/?page=features/virus
