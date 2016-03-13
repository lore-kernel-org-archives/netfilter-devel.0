From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [ANNOUNCE] ipset 6.28 released
Date: Sun, 13 Mar 2016 12:13:51 +0100 (CET)
Message-ID: <alpine.LSU.2.20.1603131212410.8784@nerf40.vanv.qr>
References: <alpine.DEB.2.10.1603122210440.15491@blackhole.kfki.hu> <alpine.LSU.2.20.1603122259210.6559@nerf40.vanv.qr> <alpine.DEB.2.10.1603131133010.18557@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:35486 "EHLO ares41.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932381AbcCMLNx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 13 Mar 2016 07:13:53 -0400
In-Reply-To: <alpine.DEB.2.10.1603131133010.18557@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Sunday 2016-03-13 11:33, Jozsef Kadlecsik wrote:
>On Sat, 12 Mar 2016, Jan Engelhardt wrote:
>> >I'm happy to announce ipset 6.28 with a couple of important fixes, some 
>> >compatibility improvements and corrections.
>> >  - Support older pkg-config packages
>> 
>> it broke.

By the way, there is another issue. You are calling `modinfo` when make
install, but you are not passing  -b ${DESTDIR}, so it, too, fails
inside chroot buildroots. (because /lib/modules/V/kernel is empty;
ipset is in $DESTDIR/lib/modules/V/...)

