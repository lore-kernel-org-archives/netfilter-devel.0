From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 0/6] nftables trace support
Date: Tue, 24 Nov 2015 11:02:05 +0100
Message-ID: <1448359331-12692-1-git-send-email-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:58366 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752994AbbKXKCX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Nov 2015 05:02:23 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi.

This is formal first-round submission of the nft trace infrastructure.

Changes since various rfc proposals:
- old nf_log_packet based infrastructure still in place
- serializes interesting parts, such as verdict, rule handle, table and chain
names into netlink attributes
- first message contains header data in exta attributes for the three bases
(ll, nh, th).

I tested this with nft ingress, bridge and ip families with ipv4 and ipv6 on top.

Sample output:

trace id 848e1d00 bridge packet src 5e:95:99:72:ea:c5 dst 52:54:00:12:34:56 src 192.168.7.1 dst 192.168.7.10 len 84 ttl 64 id 39991 protocol 1 iif eth0
trace id 848e1d00 bridge raw prerouting rule verdict continue iif eth0
trace id 848e1d00 rule limit rate 1/second nftrace set 1 
trace id 848e1d00 bridge raw prerouting policy verdict accept iif eth0
trace id 848e1d00 ip filter input rule verdict accept iif br0
trace id 848e1d00 rule ip protocol icmp accept 
trace id 848e1c00 bridge packet src 5e:95:99:72:ea:c5 dst 52:54:ea:fe:ad:a6 src dead::47ed:79b0:2f7f dst dead::6438:3436:3a34:6430 len 64 hoplimit 64 protocol 58 iif eth0
trace id 848e1c00 bridge raw prerouting rule verdict continue iif eth0
trace id 848e1c00 rule limit rate 1/second nftrace set 1 
trace id 848e1c00 bridge raw prerouting policy verdict accept iif eth0
trace id 836fe400 bridge packet src 5e:95:99:72:ea:c5 dst 52:54:00:12:34:56 arpop 0x1 iif eth0
...

Note that I did not (yet?) add json or xml format for this, I'm not sure its worth it or needed.

First three patches are for the kernel.
Next two are for libnftl (most of the print/format stuff is there).
last patch is the nftables patch.

Cheers,
Florian

