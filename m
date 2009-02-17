From: Ralf <rm@amitrader.com>
Subject: userspace packetfiltering problems
Date: Tue, 17 Feb 2009 21:14:27 +0100
Message-ID: <gnf5r6$a7u$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:39270 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750980AbZBQUOp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Feb 2009 15:14:45 -0500
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1LZWL6-0004GK-Ev
	for netfilter-devel@vger.kernel.org; Tue, 17 Feb 2009 20:14:44 +0000
Received: from p57a2bf59.dip.t-dialin.net ([87.162.191.89])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Feb 2009 20:14:44 +0000
Received: from rm by p57a2bf59.dip.t-dialin.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Feb 2009 20:14:44 +0000
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The majority of the public linux servers are VPS systems.
Most are based on openVZ/Virtuozzo.

In this environment the VPS admin has IMHO unfortunately 
no possibility to use modprobe or insmod to load iptable modules.

Therefore it is impossible to write 3rd party software 
which needs packet filtering capability (QUEUE/NFQUEUE).

The iptables/netfilter developers should think about this problem
and give the VPS users the capability to load userspace modules
by themselves, and not let them beg at their hosters
as this mostly nearly never works.

Can anybody give me an advice for a packet filtering library
that works in userspace on all linux systems, without the need
for any kernel modules etc.?
I tried libipq, but it gives an error because a kernel module
(ip_queue) is not loaded, and the hoster denies to load that damn module.
Is that not worser than Microsoft's monopoly practices???
It is happening with Open Source! Isn't that a crime?

