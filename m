From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [ANNOUNCE] ipset-2.3.2
Date: Fri, 4 Jul 2008 19:01:27 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0807041814270.1890@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0807021449020.32444@blackhole.kfki.hu> <200807041553.41535.ludwig.nussel@suse.de> <alpine.LNX.1.10.0807041600150.1890@fbirervta.pbzchgretzou.qr> <200807041614.35900.ludwig.nussel@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Ludwig Nussel <ludwig.nussel@suse.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:38999 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761030AbYGDRB3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Jul 2008 13:01:29 -0400
In-Reply-To: <200807041614.35900.ludwig.nussel@suse.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2008-07-04 16:14, Ludwig Nussel wrote:

>> >AFAICS one has to manually add PF_EXT_SLIB+=set SET to
>> Not in 1.4.1 and up, which is what you should be using.
>Ah, the build system was changed. We still have 1.4.0 in the repo.
>Needs to be updated.

It is a bit unfortunate that opensuse 11 got out before 1.4.1..
(/me eyes Patrick ;-)

>> Also, since you come from @suse.de, I might infer that ipset
>> is a candidate for the distro kernel in which case one would
>> rather want it as additional modules.
>
>So far there has been no request to include ipset support in any
>SUSE distribution. I've just created ipset add-on packages in the
>openSUSE build service for personal interest.

I have completed importing ipset and wiring up the Makefile logic
in xtables-addons (ipset branch). As such, there is also a SUSE rpm
in my repo (/suser-jengelh/SUSE-11.0/*/xtables-addons-*-1.5.4.2).


Jozsef, where do we go from here? ipset in xt-a, ACCEPT or DROP?
