From: Chris Wilson <chris-netfilter-110904@aptivate.org>
Subject: Re: UDP packets sent with wrong source address after routing change
 [AV#3431]
Date: Mon, 12 Nov 2012 22:34:29 +0000 (GMT)
Message-ID: <alpine.DEB.2.00.1211122227540.4432@chris-desktop.fen.aptivate.org>
References: <alpine.DEB.2.02.1211081627150.6644@lap-x201> <alpine.LNX.2.01.1211081829150.28568@nerf07.vanv.qr> <alpine.DEB.2.00.1211081823030.5637@chris-desktop.fen.aptivate.org> <20121110140720.GA9610@1984> <alpine.LNX.2.01.1211101957320.1938@nerf07.vanv.qr>
 <alpine.DEB.2.00.1211102216540.14307@blackhole.kfki.hu> <alpine.DEB.2.02.1211121019280.23195@lap-x201> <alpine.DEB.2.00.1211121556480.18137@blackhole.kfki.hu> <alpine.DEB.2.02.1211121523190.23195@lap-x201>
 <alpine.DEB.2.00.1211122020280.18729@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Chris Wilson <chris-netfilter-110904@aptivate.org>,
	netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from one-mail.aptivate.org ([87.106.150.205]:60996 "EHLO
	one-mail.aptivate.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783Ab2KLWfT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Nov 2012 17:35:19 -0500
In-Reply-To: <alpine.DEB.2.00.1211122020280.18729@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jozsef,

On Mon, 12 Nov 2012, Jozsef Kadlecsik wrote:

> What do you think about this?
>
> - add route change notification event to the net core
> - add --update-source-address flag to the MASQUERADE target
> - add a call for such events to the MASQUERADE target, when
>  the flag is enabled
>
> The called function then can scan the conntrack table and for every entry
> which has got the update-source-address flag, can check whether the source
> IP address should be changed. Those entries are then deleted.

That sounds like a relatively easy implementation that would solve the 
main problem for us.

I think there might be one element missing from the above process: the 
actual conntrack entries created by the MASQUERADE --update-source-address 
rule should be marked with an UPDATE_SOURCE_ADDRESS flag, so that they can 
be found and deleted when the routing changes.

Perhaps the flag/option should be called "--remove-if-routing-changes" or 
"--routing-dependent" or something like that, since the source address is 
not really being (directly) changed as I proposed at the beginning?

Cheers, Chris.
-- 
Aptivate | http://www.aptivate.org | Phone: +44 1223 967 838
Future Business, Cam City FC, Milton Rd, Cambridge, CB4 1UY, UK

Aptivate is a not-for-profit company registered in England and Wales
with company number 04980791.

