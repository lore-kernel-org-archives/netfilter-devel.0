From: Diego Casado Mansilla <diego.casadomansilla@gmail.com>
Subject: NAT in an already established TCP connection
Date: Tue, 28 Oct 2008 12:25:13 +0100
Message-ID: <4906F699.6010006@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org,
	netfilter@lists.samba.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:2358 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324AbYJ1LYe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 28 Oct 2008 07:24:34 -0400
Received: by fg-out-1718.google.com with SMTP id 19so2290609fgg.17
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Oct 2008 04:24:32 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello all!!!

This is my first mail in the list.

Hopefully the question is interesting and you can figure out how to help me.

I use iptables rules to manage the connections from internet to my local 
network. I know how to filter, do nat, etc...
But this days I'm trying to do NAT in connections that are already 
established. The problem is (as far as I know) the packets which pass 
throught the nat table are only the SYN packets (once), thus, the 
packets that are used to perform a NEW connection.

After that the connection is created, the maintenance and the resolution 
of the SNAT and DNAT are kept till the connection finish.
What I'm wondering is: how can I change the ports or IPs of an already 
established connection if my packets just go throught the nat table at 
the connection time?

**** Maybe doing packets' replication since those ones are redirected to 
annother machine?

**** NAT TCP Extensions??Patch-O-Matic --> window-tracking??

**** I read this in an interntet site:

--- NEW (and RELATED non-icmp)
    This is a very important part relevant for understanding the whole NAT
    subsystem. Only if the packet has the state NEW (i.e. it would establish
    a new connection, if we'd accept it), the NAT table is traversed by
    calling ip_nat_rule.c:ip_nat_rule_find(), which in turn calls
    ip_tables.c:ipt_do_table() for the actual IP table traversal. The 
traversal
    ends up in either ACCEPTing the packet as it is, or one of the nat 
targets
    (SNAT, DNAT and if loaded: REDIRECT, MASQUERADE) Please see
    chapter FIXME for further description of those targets.

--- ESTABLISHED
    This packet belongs to an already established connection. We don't need
    to traverse the NAT table again, as the necessary information
    (struct ip_nat_info) was already gained Hello everybody,


Thank you very much in advance and if my questions are not clear don't 
doubt to send me a message.

Diego.

