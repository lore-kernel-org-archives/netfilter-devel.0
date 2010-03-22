From: Jorrit Kronjee <j.kronjee@infopact.nl>
Subject: debugging kernel during packet drops
Date: Mon, 22 Mar 2010 11:41:20 +0100
Message-ID: <4BA74950.6000305@infopact.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.infopact.nl ([212.29.160.177]:42268 "EHLO
	smtp1.infopact.nl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754462Ab0CVKl1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 22 Mar 2010 06:41:27 -0400
Received: from [127.0.0.1] (x123.infopact.nl [212.29.160.123])
	(authenticated bits=0)
	by smtp1.infopact.nl (8.13.6/8.13.6) with ESMTP id o2MAfOak029149
	for <netfilter-devel@vger.kernel.org>; Mon, 22 Mar 2010 11:41:26 +0100
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Dear list,

I've asked this question on the kernelnewbies forum, but I haven't got
any responses. I hope someone here is able to help me. I'm trying to
build a setup that allows me to limit the amount of packets/s per
destination IP address. The setup I use for this is as follows: 

[ DoS machine ] -> [ bridging firewall ] -> [ receiving network ] 

I used brctl to build the bridge. The DoS machine has a custom built
tool that allows me to send small packets at very fast rates. I've
discovered that bridging still works reliably at around 300 kpackets/s
(notice the 'k' in there). However, as said before, I was trying to
limit the amount of packets/s, so I used netfilter's hashlimit module.
This is when packet drops started to appear. 

At around 300 kpps, the amount of packet drops is 40 kpps. For me, this
amount is too significant to ignore. I see the load average go from a
comfortable 0.00 to 1.78, mainly caused by ksoftirqd processes. At 200
kpps, the average amount of packet drops is 23 kpps. At 100 kpps, it's
still 2 kpps. 

When I disable the hashlimit module the packet drops disappear again.
Now I know that hashlimit is made for more than one thing, namely
limiting packets based on source/destination host and source/destination
port, so it's not as efficient as it could be for my purposes. I could
rewrite it, but before I do that, I would like to know if the module
itself is really what's causing it, or if there's some underlying cause
that I'm not seeing. So my question in short: how can I discover why
it's dropping packets? 

Some details about the machine: 

network controllers: 
00:19.0 Ethernet controller: Intel Corporation 82566DM-2 Gigabit Network
Connection (rev 02) 
04:02.0 Ethernet controller: Intel Corporation 82541GI Gigabit Ethernet
Controller (rev 05) 

drivers: 
driver: e1000e 
version: 1.1.2.1a-NAPI 
firmware-version: 1.3-0 
bus-info: 0000:00:19.0 

driver: e1000 
version: 7.3.21-k3-NAPI 
firmware-version: N/A 
bus-info: 0000:04:02.0 

CPU: Intel Xeon CPU X3330 @ 2.66 GHz

Regards,

Jorrit Kronjee

