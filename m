From: "Filka Michal" <Michal.Filka@sitronicsts.com>
Subject: performance questions
Date: Wed, 30 Jul 2008 13:07:54 +0200
Message-ID: <4474723F928CA640ADB2172099AEAB111E89D3@exalfa.stromtelecom.cz>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.strom.cz ([80.95.102.231]:58640 "EHLO mail.strom.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753965AbYG3LVR convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jul 2008 07:21:17 -0400
Content-class: urn:content-classes:message
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi all,

I did some performance tests focused on routing.

Traffic is generated using a traffic generator which has two interfaces
connected to two different switches. Router is connected to those
switches and routes traffic from one generator's IP to other one.
Everything works over 1Gbps Ethernet using metallic and optical
interconnection.

Case A:
The Generator created two flows. First was icmp traffic (echo request)
with packet size 64B. Average performance with zero packet loss was 28%
(cca 400.000 tx fps). Second flow was udp traffic with packet size 64B.
Traffic decreased to average performance round 23% (cca 340.000 tx fps).

Case B:
Then I decided to create a module which allows bypassing nefilter for
some traffic and study changes in performance. The module registers
netfilter callbacks at the beginning of PREROUTING and POSTROUTING
chains. It stops executing of other netfilter hooks for particular
traffic (returns NF_STOLEN (in this case runs okfn too) or NF_STOP - I
tried both). I run both tests as described earlier. First test (icmp
traffic) increased performance to 30% but the second (udp traffic)
decreased to 20%.

I need a help in explaining following questions.
1) Does anyone have any idea why is there such difference in performance
in case A? In my opinion protocol above ip (icmp or udp in this case)
shouldn't make difference and the performance should be almost
identical.

2) What could cause performance decrease of udp traffic in case B? the
result is worst than in Case A for udp traffic but better for icmp
traffic and it looks strange to me.

Thanks for your help.
Michal Filka
