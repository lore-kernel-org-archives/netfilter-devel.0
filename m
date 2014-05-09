From: Andreas Herz <andi@geekosphere.org>
Subject: ip_route_output_key returns wrong gateway info with specific ip rules
Date: Fri, 9 May 2014 15:41:10 +0200
Message-ID: <20140509134110.GI10939@kvmbude>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.geekosphere.org ([78.47.150.211]:34081 "EHLO
	mail.geekosphere.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbaEINsL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 9 May 2014 09:48:11 -0400
Received: from geekosphere.org (unknown [IPv6:2a00:f48:1026:0:f1f7:0:1545:173f])
	by mail.geekosphere.org (Postfix) with ESMTPSA id 74371F4D36
	for <netfilter-devel@vger.kernel.org>; Fri,  9 May 2014 13:41:10 +0000 (UTC)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I found some strange results when i use "ip_route_output_key" in my own
small kernel netfilter module. I narrowed it down to the issue, that the
information in "rt->gateway" seems to be wrong.
If i have a ip rule with a specific "from" IP or network, it seems that
the kernel doesn't parse/compare it correctly. As soon as i switch to
"from all" it's fine.

So my guess is, there is a problem when parsing the "from" part from ip
rules.

The setup is the following:

Client --- Server --- Gateway --- WAN

The Client has the IP 10.0.20.2, the Server has the IP 10.0.20.1 on the
side to the client. On the other side he has the IP 10.0.12.2 and
10.0.13.2 (alias IP) and the Destination is a gateway with the IPs
10.0.12.1 and 10.0.13.1 which is connected to the WAN.
The Server is using kernel 3.14 from kernel.org and debian base.
Could reproduce it on redhat, too.

I start a "ping 8.8.8.8" the server receives the package and forwards it
to the Gateway.

The server has the following routing table:

10.0.12.0/24 dev eth1  proto kernel  scope link  src 10.0.12.2 
10.0.13.0/24 dev eth1  proto kernel  scope link  src 10.0.13.2 
10.0.20.0/24 dev eth2  proto kernel  scope link  src 10.0.20.1 
default via 10.0.13.1 dev eth1

So the default gateway is the 10.0.13.1 on eth1.

What i want to achieve is, that the packets from this client/net are
send to the 10.0.12.1 with source 10.0.12.2 instead of the default
gateway and IP.
So i created some policy based routing:

0:  from all lookup local 
16: from all to 10.0.20.0/24 lookup main 
16: from all to 10.0.12.0/24 lookup main 
16: from all to 10.0.13.0/24 lookup main 
2784:   from all fwmark 0x10/0xf0 lookup eth1 
3296:   from 10.0.20.0/24 lookup GW_10.0.12.1_eth1 
32766:  from all lookup main 
32767:  from all lookup default

With "ip r list table GW_10.0.12.1_eth1":
default via 10.0.12.1 dev eth1

Now i use the ipt_MASQUERADE module as a base and just added this part
for my test:

"rt = ip_route_output_key(dev_net(skb->dev), &fl);"

And some debug outputs and also the necessary declaring of the flowi4
fl.

What i get for "rt->gateway" in this case is:

10.0.13.1

When i switch 
"from 10.0.20.0/24 lookup GW_10.0.12.1_eth1"
to
"from all lookup GW_10.0.12.1_eth1"

i get "10.0.12.1" correctly.

The only iptables rule is the rule in the nat table to jump into the
module. If i log the package i always see the same correct saddr:

"IN=eth2 OUT=eth1 SRC=10.0.20.2 DST=8.8.8.8"

So the ip rule information should be correct.
I have this behaviour since 2.6.32 in which i also used "rt->rt_src"
which is sadly gone :/
(Does anyone know why it got removed?)

Do you have any hint or suggestion for me?
If not i wil try to dig more into it and add more debug parts to
net/ipv4/route.c and recompile the kernel.

-- 
Andreas Herz
