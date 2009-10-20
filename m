From: Daniel Huhardeaux <tech@tootai.net>
Subject: DNAT and source IP
Date: Tue, 20 Oct 2009 10:16:23 +0200
Message-ID: <4ADD71D7.7090502@tootai.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Netfilter list <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ns1.tootai.net ([82.231.69.24]:54530 "EHLO mail1.tootai.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751233AbZJTIpc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 20 Oct 2009 04:45:32 -0400
Received: from [192.168.0.59] (lns-bzn-51f-81-56-133-203.adsl.proxad.net [81.56.133.203])
	by mail1.tootai.net (Postfix) with ESMTP id 9A60039891F
	for <netfilter-devel@vger.kernel.org>; Tue, 20 Oct 2009 10:16:22 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello everybody,

I'm running few virtual machines (kvm+libvirt) on a server (Debian Lenny 
+ backport kernel 2.6.30) with one public IP and having IP private range 
10.99.0.1 for host, one for mail and web VM (10.99.0.13), another for 
telephony VM (10.99.0.11).

Everything is working well (DNAT) but something is disturbing me: for 
instance, on smtp server, all incoming tcp packets are marked with 
10.99.0.1 source IP and I would like to have "transparent DNAT" which 
keep the original IP.

I also tried with xinetd and his redirect feature, same problem. For 
telephony, using udp, it's also a problem.

My question is: is there a way to achive my needs with iptables (other 
solution?) or is bridging the only way?

Thanks for any feedback/idea

-- 
Daniel
