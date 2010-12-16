From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Error reporting in Netlink (Re: Xtables2 Netlink spec)
Date: Thu, 16 Dec 2010 14:51:07 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1012161444410.16086@obet.zrqbmnf.qr>
References: <alpine.LNX.2.01.1011242314580.32646@obet.zrqbmnf.qr>  <alpine.DEB.2.00.1011261950100.18019@blackhole.kfki.hu>  <alpine.LNX.2.01.1012150547590.2888@obet.zrqbmnf.qr>  <alpine.DEB.2.00.1012150921330.3983@blackhole.kfki.hu>
 <Pine.LNX.4.64.1012161041200.8276@ask.diku.dk>  <alpine.LNX.2.01.1012161322450.6728@obet.zrqbmnf.qr> <1292507013.3395.19.camel@lsx>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jesper Dangaard Brouer <hawk@diku.dk>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, netfilter@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Thomas Graf <tgraf@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:46066 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753606Ab0LPNvI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Dec 2010 08:51:08 -0500
In-Reply-To: <1292507013.3395.19.camel@lsx>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2010-12-16 14:43, Thomas Graf wrote:
>
>>It also does not look very netlinky to not use nlattrs
>
>Why not use nlattr to encode the error string? It would make error
>messages easier to extend in the future. At some point we might want
>to add an offset field which points into the original netlink
>message describing the attribute which caused the failure.

Is that a yes or a no?


>>>>But I do realize that it's much easier (and therefore quite
>>>>tempting) to construct the full error message in kernel space and
>>>>just send it back. However, that'd make quite hard to support
>>>>internationalization.
>
>Thinking of netlink protocols in general and netfilter in specific,
>maintaining a list of reserved error codes for each
>subsystem/target/ module will result in an unbearable pain if the
>error codes are not separated into individual namespaces for each
>module.

I did not plan on giving extensions a numeric namespace; here it's
largely strings only.


>> It's not like those strings change all that much.
>> 
>> >To support internationalization, we could just add an error-number-code 
>> >in front of the constructed error message?
>> 
>> Buying us what? If you change the string, but the gettext lookup is 
>> based upon a number, you will get an outdated translation, which is not 
>> nice either. IMHO: Better an English message than an inaccurate message.
>
>Do we *really* need internationalization for error messages on this
>level? Primarily userspace should be in charge of checking for all kinds
>of erroneous user input and produce meaningful context based,
>translatable error messages.

Let's see, why does iproute2 not just do that, then? Because some
things only the kernel knows about, so even if the parameters are
correct from the userspace side of view, the kernel may reject the
request nevertheless.
