From: Jamal Hadi Salim <jhs@mojatatu.com>
Subject: [Netdev ANNOUNCE]: Two new talks on network emulators and zero copy
 sendmsg
Date: Tue, 21 Mar 2017 11:15:44 -0400
Message-ID: <cfc3bb6e-67c0-2ab5-283a-b534836dcbc0@mojatatu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: tech-committee@netdevconf.org, netfilter-devel@vger.kernel.org,
        Brenda Butler <bjb@mojatatu.com>,
        Stephen Jaworski <jaws@mojatatu.com>,
        netfilter@vger.kernel.org, linux-wireless@vger.kernel.org,
        Heri Muhero <hmuhero@gmail.com>
To: people@netdevconf.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:33921 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756711AbdCUPZH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Mar 2017 11:25:07 -0400
Received: by mail-it0-f66.google.com with SMTP id z70so1926770itb.1
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Mar 2017 08:25:02 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The tech committee would like to announce two new accepted talks.

The first one is a talk on container based network emulators by
Brian Linkletter and the second one is by Willem de Bruijn
on zero copy sendmsg.

Details are as follows:

1) Investigating Linux Network Behaviour Using Open-Source Network
Emulators (Brian Linkletter)

----
There are several open source, GUI based, network emulation tools that
  are based on linux containers that could be used to replicate network
scenarios including failures. This talk will be taking a trouble-
shooting approach to introduce a sample of these tools.

* Show how a complex virtual network topology of virtual bridges, Linux
hosts, and Linux routers can be created in an ad-hoc fashion in minutes
using Linux containers and Linux bridging in a GUI-based network
emulator such as the CORE Network Emulator

*Create a troubleshooting scenario in the emulated network caused by one 
or more problems (for example: by interfering with traffic on links
in  the virtual network, or by incorrectly configuring routers in the
network) and show how the network emulator integrates with commonly
used tools, such as Wireshark, to evaluate and identify the problem.

*Show how the network emulation scenario setup may be automated using
  Python scripts and APIs

*Briefly show that the CORE network emulation tool, and similar tools, 
may be extended to add new functionality.

*Briefly show a general overview of other open-source network emulation
tools that use virtualized Linux nodes to emulate networks, emphasizing
the use-cases where each is best suited, based in hypervisor or
container technology used, scripting language used, available API's,
and integration with complementary tools.

At the end of the talk, developers would have an appreciation of the 
open-source network emulation projects available and how to use them to 
replicate network behavior while testing or debugging network 
applications or applications that use a network.
----

2)  sendmsg copy avoidance with MSG_ZEROCOPY (Willem de Bruijn)
---
  Linux offers various copy avoidance mechanisms, such as sendfile,
vmsplice and tun zerocopy. In this talk I will give an overview of
current interfaces and introduce a new MSG_ZEROCOPY extension to the
socket API. Processes converted to the interface see a cycle reduction
ranging from 90% of process cycles (62% systemwide) for a netperf micro-
benchmark to 5-8% for lightly modified production machine learning and
CDN workloads.

The feature combines a send() flag with a completion notification
channel over the socket error queue. Aside from introducing the
interface, the talk will focus on technical constraints. Primarily,
supporting complex protocols like TCP, where segmentation,
retransmission and reordering introduce a non-trivial relationship
between user buffers and packets on the wire. To handle these,
completion notification requires careful reference counting across the
transmit stack. Other concerns are bounding notification latency and
working set size, avoiding TOCTTOU attacks with shared read-write page
mappings and amortizing the cost of notification processing over the
socket error queue.
----

cheers,
jamal
