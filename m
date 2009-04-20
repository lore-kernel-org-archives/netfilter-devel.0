From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] Add support to log original and NAT-ed IP addresses
Date: Mon, 20 Apr 2009 12:33:55 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0904201231270.13423@fbirervta.pbzchgretzou.qr>
References: <alpine.DEB.2.00.0904201012170.10463@blackhole.kfki.hu> <49EC474E.8090604@netfilter.org> <alpine.DEB.2.00.0904201200240.10463@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:47633 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753538AbZDTKd5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 20 Apr 2009 06:33:57 -0400
In-Reply-To: <alpine.DEB.2.00.0904201200240.10463@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2009-04-20 12:12, Jozsef Kadlecsik wrote:
>
>But ulogd2 requires the ULOG target

What purpose would NFLOG serve then?

>and ULOG cannot log the SNAT-ed address either, similarly to the
>vanilla LOG target: there's presently no hook at which the
>information is available for the LOG/ULOG targets.

I favor the patch because the raw table gets a POSTROUTING hook ;-)

>> I think that Patrick is not going to like the idea of adding more hooks,
>> what do you think Patrick?
>
>Yes, the additional hook is suboptimal. But I couldn't find any other 
>way to get the data.

The rawpost_table, as in the RAWNAT branch of Xtables-addons. While
the additional table is probably just as suboptimal, at least you
can unload it.
