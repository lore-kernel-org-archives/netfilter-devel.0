From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Error reporting in Netlink (Re: Xtables2 Netlink spec)
Date: Fri, 17 Dec 2010 11:00:52 +0100
Message-ID: <4D0B34D4.9020208__24642.0163814493$1292580091$gmane$org@netfilter.org>
References: <alpine.LNX.2.01.1011242314580.32646@obet.zrqbmnf.qr> <alpine.DEB.2.00.1011261950100.18019@blackhole.kfki.hu> <alpine.LNX.2.01.1012150547590.2888@obet.zrqbmnf.qr> <alpine.DEB.2.00.1012150921330.3983@blackhole.kfki.hu> <Pine.LNX.4.64.1012161041200.8276@ask.diku.dk> <alpine.LNX.2.01.1012161322450.6728@obet.zrqbmnf.qr> <1292507013.3395.19.camel@lsx> <alpine.LNX.2.01.1012161444410.16086@obet.zrqbmnf.qr> <20101216141923.GB23297@canuck.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Jan Engelhardt <jengelh@medozas.de>,
	Thomas Graf <tgraf@redhat.com>,
	Jesper Dangaard Brouer <hawk@diku.dk>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Netfilter Developer Mailing L
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57904 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753146Ab0LQKA4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 17 Dec 2010 05:00:56 -0500
In-Reply-To: <20101216141923.GB23297@canuck.infradead.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 16/12/10 15:19, Thomas Graf wrote:
> On Thu, Dec 16, 2010 at 02:51:07PM +0100, Jan Engelhardt wrote:
>>> Why not use nlattr to encode the error string? It would make error
>>> messages easier to extend in the future. At some point we might want
>>> to add an offset field which points into the original netlink
>>> message describing the attribute which caused the failure.
>>
>> Is that a yes or a no?
> 
> The proposed solution at netconf involved appending the error string
> directly. Inspired by your comment I realizezd that encoding the
> error string as nlattr allow for additional attributes would be a
> better implementation.

Indeed, I'd prefer adding an extra netlink header with a new type like
NLM_ERROR2 followed by attributes like the string (or an int) that
contain the error.

This also can be added with breaking existing apps and libraries IIRC.

> As for size limitations, even though most netlink protocols do it, I
> don't see the point in appending the whole request message in a error
> message. The header would be completely sufficient for all request/reply
> based protocols. It is no problem for userspace to keep a copy of the
> last request sent.

At least, we require the netlink header of the request message in error
messages. This is useful for message batches that are sent to
kernel-space, to know which one triggered the error.
