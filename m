From: Detlev Zundel <dzu@denx.de>
Subject: UDP DNAT to a broadcast address
Date: Wed, 18 May 2011 17:58:09 +0200
Message-ID: <m2wrhorofi.fsf@ohwell.denx.de>
Mime-Version: 1.0
Content-Type: text/plain
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:44832 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755620Ab1ERQPI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 May 2011 12:15:08 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gnnd-netfilter-devel@m.gmane.org>)
	id 1QMjOs-0003uo-9g
	for netfilter-devel@vger.kernel.org; Wed, 18 May 2011 18:15:06 +0200
Received: from p4fd63d4d.dip.t-dialin.net ([79.214.61.77])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Wed, 18 May 2011 18:15:06 +0200
Received: from dzu by p4fd63d4d.dip.t-dialin.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Wed, 18 May 2011 18:15:06 +0200
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

looking for the answer to this problem, I searched the web and this
mailing list, but I still couldn't find a definitive answer to the
question that I have.

In my setup I need to a UDP packet sent to the external IP of my router
to trigger a broadcast UDP packet on the local network and relay back
the answers to this packet.

It looks like this should do the trick:

iptables -t nat -I PREROUTING -i ppp0 -p udp --dport 3333 -j DNAT --to 192.168.0.255

Of course, as I write this e-mail, this does not work.  I can see the
packets entering the INPUT chain, but I see no packets on the OUTPUT
chain.  I speculate that this is because braodcast addresses are not
routable and thus the packet gets lost somewhere.

Is there any method to solve this with netfilter or do I need to write a
bi-directional UDP proxy in userspace?

Thanks
  Detlev

-- 
(3)   With sufficient thrust,  pigs fly just fine.  However, this is not
necessarily a good idea.  It is hard to be sure  where they are going to
land, and it could be dangerous sitting under them as they fly overhead.
                              -- The Twelve Networking Truths (RFC 1925)

