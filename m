From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [ANNOUNCE] ipset-2.3.2
Date: Mon, 7 Jul 2008 11:28:50 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0807051710240.28765@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0807021449020.32444@blackhole.kfki.hu> <200807041553.41535.ludwig.nussel@suse.de> <alpine.LNX.1.10.0807041600150.1890@fbirervta.pbzchgretzou.qr> <200807041614.35900.ludwig.nussel@suse.de> <alpine.LNX.1.10.0807041814270.1890@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0807050050510.4142@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Ludwig Nussel <ludwig.nussel@suse.de>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:58397 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905AbYGGJ2v (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Jul 2008 05:28:51 -0400
In-Reply-To: <Pine.LNX.4.64.0807050050510.4142@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Saturday 2008-07-05 01:09, Jozsef Kadlecsik wrote:
>On Fri, 4 Jul 2008, Jan Engelhardt wrote:
>
>> I have completed importing ipset and wiring up the Makefile logic
>> in xtables-addons (ipset branch). As such, there is also a SUSE rpm
>> in my repo (/suser-jengelh/SUSE-11.0/*/xtables-addons-*-1.5.4.2).
>> 
>> Jozsef, where do we go from here? ipset in xt-a, ACCEPT or DROP?
>
>As xtables-addons works with kernel 2.6.18.5 or above I cannot depend on 
>it. Even supporting 2.4 kernels is still required - and if there's a 
>single user who needs it, I do support the 2.4 series in ipset.

That is the existing code that depends on it --
there is probably a way to make it work with < 2.6.17
but I had not yet looked into it.

ipset still uses its own glue code, so is exempt from the
2.6.18.5 rule.
