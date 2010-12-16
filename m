From: Jan Engelhardt <jengelh@medozas.de>
Subject: Error reporting in Netlink (Re: Xtables2 Netlink spec)
Date: Thu, 16 Dec 2010 13:51:34 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1012161322450.6728@obet.zrqbmnf.qr>
References: <alpine.LNX.2.01.1011242314580.32646@obet.zrqbmnf.qr> <alpine.DEB.2.00.1011261950100.18019@blackhole.kfki.hu> <alpine.LNX.2.01.1012150547590.2888@obet.zrqbmnf.qr> <alpine.DEB.2.00.1012150921330.3983@blackhole.kfki.hu>
 <Pine.LNX.4.64.1012161041200.8276@ask.diku.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, netfilter@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>, tgraf@redhat.com
To: Jesper Dangaard Brouer <hawk@diku.dk>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:51308 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753320Ab0LPMvf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Dec 2010 07:51:35 -0500
In-Reply-To: <Pine.LNX.4.64.1012161041200.8276@ask.diku.dk>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2010-12-16 10:57, Jesper Dangaard Brouer wrote:

>Cc.ed Thomas Graf (tgraf@redhat.com), Thomas presented some interesting 
>ideas on netlink error-codes and strings during NetConf 2010, see:
>
>http://vger.kernel.org/netconf2010.html 
>http://vger.kernel.org/netconf2010_slides/tgraf_netconf10.odp

The idea is appending an error string is ok for Netlink as a protocol
(specification-wise), but the size constraints of the skbuffs in the
Linux may make its practical implementation a little harder. "Half of
the packet" is already used for the original request message, and
cramming an extra error string may bust the space.
It also does not look very netlinky to not use nlattrs ;-)


On Wed, 15 Dec 2010, Jozsef Kadlecsik came about with:
>
>>I have got a three-level error coding in my mind: general, standard 
>>error codes (ENOMEM, EPERM, etc.), general netfilter specific ones 
>>(like NFXTE_HOOKMASK_NOT_ADHERED) and table/match/target specific 
>>ones.
>>
>>But I do realize that it's much easier (and therefore quite tempting) 
>>to construct the full error message in kernel space and just send it 
>>back. However, that'd make quite hard to support internationalization.

It's not like those strings change all that much.


>To support internationalization, we could just add an error-number-code 
>in front of the constructed error message?

Buying us what? If you change the string, but the gettext lookup is 
based upon a number, you will get an outdated translation, which is not 
nice either. IMHO: Better an English message than an inaccurate message.
