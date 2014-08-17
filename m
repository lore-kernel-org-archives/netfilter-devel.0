From: Hugo Alves <hugo.ma.alves@gmail.com>
Subject: Post_Routing hook with encapsulated packets (forwarding scenario)
Date: Sun, 17 Aug 2014 21:18:59 +0100
Message-ID: <CALjSwYcOPQ4WgsA5O-MNi9P3P1mxuEuAmseAjOa7iZn=2kexrg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:45292 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbaHQUTB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 17 Aug 2014 16:19:01 -0400
Received: by mail-la0-f52.google.com with SMTP id b17so3823098lan.39
        for <netfilter-devel@vger.kernel.org>; Sun, 17 Aug 2014 13:18:59 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi all,

I've written a small kernel module to measure packet processing times.
This module registers itself in a netfilter hook, more specifically
the NF_INET_POST_ROUTING. After that it uses the information in skb
struct to calculate some metrics for each packet.
My setup have 3 nodes, a sender, a receiver and a router where the
module is installed.

The router have two network interfaces, eth0 connected to a lan where
the sender is and the other(eth1) connected to the lan where the
receiver is. Lets assume that the traffic only flows from the sender
to the receiver.
The router has also an tunnel "interface"(ip6tnl1) that is connected
to the receiver. All traffic that goes to the receiver passes through
the tunnel.

 _____________
|  Sender          |
|_____________|
      |
      |
      |(eth0)
 ___|_________
|  Router           |
|_____________|
      |(eth1)
      |
      |
     | |
     | |
     | |  (ip6tnl1)
     | |
      |
      |
 ___|________
| Receiver      |
|___________ |

First I've tested my module in a 3.2 kernel.
In this kernel for each packet forwarded I get two calls in my
callback function of the hook. One for the original packet that is
routed from eth0 to ip6tnl1. And the other is the encapsulated packet
that goes from ip6tnl1 to eth1.
In both I have the same skb->tstamp, meaning that even when the kernel
creates the encapsulated packet it preservers the original timestamp
from when the packet entered the system. Is this assumption about the
time correct?

Then I've tested the same module in kernel 3.15.9, and in this case I
only see the encapsulated packet in the Post_routing hook. In this
case the tstamp in skb struct is the time when the original packet
entered the system or is the time when the kernel created the new
encapsulated packet? I am not sure about this tstamp.

The behaviour of the hooks have changed recently in the kernel?


The code of the module: https://gist.github.com/e646eba4765478fbd9c2.git

Regards
