From: Thomas Graf <tgraf@infradead.org>
Subject: Re: Error reporting in Netlink (Re: Xtables2 Netlink spec)
Date: Thu, 16 Dec 2010 09:19:23 -0500
Message-ID: <20101216141923.GB23297@canuck.infradead.org>
References: <alpine.LNX.2.01.1011242314580.32646@obet.zrqbmnf.qr>
 <alpine.DEB.2.00.1011261950100.18019@blackhole.kfki.hu>
 <alpine.LNX.2.01.1012150547590.2888@obet.zrqbmnf.qr>
 <alpine.DEB.2.00.1012150921330.3983@blackhole.kfki.hu>
 <Pine.LNX.4.64.1012161041200.8276@ask.diku.dk>
 <alpine.LNX.2.01.1012161322450.6728@obet.zrqbmnf.qr>
 <1292507013.3395.19.camel@lsx>
 <alpine.LNX.2.01.1012161444410.16086@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Thomas Graf <tgraf@redhat.com>,
	Jesper Dangaard Brouer <hawk@diku.dk>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, netfilter@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from canuck.infradead.org ([134.117.69.58]:57164 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756090Ab0LPOTi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Dec 2010 09:19:38 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.01.1012161444410.16086@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Dec 16, 2010 at 02:51:07PM +0100, Jan Engelhardt wrote:
> >Why not use nlattr to encode the error string? It would make error
> >messages easier to extend in the future. At some point we might want
> >to add an offset field which points into the original netlink
> >message describing the attribute which caused the failure.
> 
> Is that a yes or a no?

The proposed solution at netconf involved appending the error string
directly. Inspired by your comment I realizezd that encoding the
error string as nlattr allow for additional attributes would be a
better implementation.

As for size limitations, even though most netlink protocols do it, I
don't see the point in appending the whole request message in a error
message. The header would be completely sufficient for all request/reply
based protocols. It is no problem for userspace to keep a copy of the
last request sent.

> Let's see, why does iproute2 not just do that, then? Because some
> things only the kernel knows about, so even if the parameters are
> correct from the userspace side of view, the kernel may reject the
> request nevertheless.

You are not the first to come up with this but it is still a pretty
lazy excuse. iproute2 could do a lot better than it does today and
it has been improved a lot over time. The main reason for the current
situation is the atomic nature of routing netlink requests handlers.
Checking for errors in an atomic context where no interface disappears
and no route can be removed while the request is being processed simply
makes checking for errors a lot easier.

This does not mean that userspace should have a card blanche for
sending bogus combinations of netlink attributes and expect the kernel
to always come up with a perfect verbose error message.

The kernel can still send ENODEV to indicate the specified network
device does not exist but it should only cover the case where the
interface disappeared between the userspace checking for its existance
and the request being processed.
