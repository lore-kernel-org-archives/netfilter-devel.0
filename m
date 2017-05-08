From: Sergey Yermakov <sergey@epmaki.net>
Subject: Changing destination ip and port of TEE'ed udp
Date: Mon, 8 May 2017 16:22:11 -0600
Message-ID: <fbc2b521-5f4d-dc10-ee52-c17c5fbc810c@epmaki.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mout.perfora.net ([74.208.4.197]:55251 "EHLO mout.perfora.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750941AbdEHW1P (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 May 2017 18:27:15 -0400
Received: from [10.45.134.66] ([4.68.55.4]) by mrelay.perfora.net (mreueus003
 [74.208.5.2]) with ESMTPSA (Nemesis) id 0LcQqG-1drK54282Q-00jtoG for
 <netfilter-devel@vger.kernel.org>; Tue, 09 May 2017 00:22:12 +0200
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

1. Sorry if this has been already asked before ( couldn't find the 
answer in the archives) or the wrong list.

2. Changing the destination ip and port of TEE'ed udp datagrams seems 
doable and I was just wondering if there are some arguments against 
adding it to TEE.

Something like this:

# iptables -t mangle -A PREROUTING -i lo -p udp --dport 223 -j TEE 
--gateway 192.168.0.1 --new-dst 192.168.0.21 --new-dport 201

# iptables -t mangle -L -nv --line
Chain PREROUTING (policy ACCEPT 159 packets, 14878 bytes)
num   pkts bytes target     prot opt in     out source               
destination
1        0     0 TEE        udp  --  lo     * 0.0.0.0/0            
0.0.0.0/0           udp dpt:223 TEE gw:192.168.0.1 new-dst:192.168.0.21 
new-dport:201
..

$ nc -u 0 223 <<<'test'

# tcpdump -nn -i eth0 port 201 or 223
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
..
15:59:01.618826 IP 127.0.0.1.38060 > 192.168.0.21.201: UDP, length 5


3. w/o --new-dst and --new-dport : the way it is right now.

# iptables -t mangle -A PREROUTING -i lo -p udp --dport 223 -j TEE 
--gateway 192.168.0.1
# iptables -t mangle -L -nv --line
..
num   pkts bytes target     prot opt in     out source               
destination
1        1    33 TEE        udp  --  lo     * 0.0.0.0/0            
0.0.0.0/0           udp dpt:223 TEE gw:192.168.0.1 new-dst:192.168.0.21 
new-dport:201
2        0     0 TEE        udp  --  lo     * 0.0.0.0/0            
0.0.0.0/0           udp dpt:223 TEE gw:192.168.0.1

thx,
-sergey


