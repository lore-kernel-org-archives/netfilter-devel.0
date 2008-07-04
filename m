From: Benny Amorsen <benny+usenet@amorsen.dk>
Subject: Re: [PATCH,RFC] Route match
Date: Fri, 04 Jul 2008 15:47:56 +0200
Message-ID: <m3mykxoj5f.fsf@ursa.amorsen.dk>
References: <20080703003942.GA2012@linuxace.com> <alpine.LNX.1.10.0807030913510.20393@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0807031140480.1816@blackhole.kfki.hu> <alpine.LNX.1.10.0807031317090.23294@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0807031749501.4958@bizon.gios.gov.pl> <alpine.LNX.1.10.0807031808550.23294@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:51668 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753516AbYGDNsH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Jul 2008 09:48:07 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1KEldr-0007ol-UY
	for netfilter-devel@vger.kernel.org; Fri, 04 Jul 2008 13:48:03 +0000
Received: from hd5b9080a.c45-01-12.sta.perspektivbredband.net ([213.185.8.10])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Fri, 04 Jul 2008 13:48:03 +0000
Received: from benny+usenet by hd5b9080a.c45-01-12.sta.perspektivbredband.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Fri, 04 Jul 2008 13:48:03 +0000
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt <jengelh@medozas.de> writes:

> I fail to see why Xtables (not just a firewall) should be slower
> than the routing table (without routing cache, to make it fair).

What about the routing cache, though?

Our Linux-based routers handle considerably less than 1Gbps peak, and
they drop packets when the cache is flushed. (So I had to set the
automatic flush to 86400 seconds instead of 10).

It would be necessary to either reinvent the route cache or come up
with something better. Preferably the latter, of course.


/Benny


