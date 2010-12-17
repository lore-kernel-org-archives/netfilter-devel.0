From: Thomas Graf <tgraf@redhat.com>
Subject: Re: Error reporting in Netlink (Re: Xtables2 Netlink spec)
Date: Fri, 17 Dec 2010 07:58:06 +0100
Message-ID: <1292569086.3395.59.camel@lsx>
References: <alpine.LNX.2.01.1011242314580.32646@obet.zrqbmnf.qr>
	 <alpine.DEB.2.00.1011261950100.18019@blackhole.kfki.hu>
	 <alpine.LNX.2.01.1012150547590.2888@obet.zrqbmnf.qr>
	 <alpine.DEB.2.00.1012150921330.3983@blackhole.kfki.hu>
	 <Pine.LNX.4.64.1012161041200.8276@ask.diku.dk>
	 <alpine.LNX.2.01.1012161322450.6728@obet.zrqbmnf.qr>
	 <1292507013.3395.19.camel@lsx>  <4D0AA143.3090608@trash.net>
Reply-To: tgraf@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Jesper Dangaard Brouer <hawk@diku.dk>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, netfilter@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33528 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751869Ab0LQHQz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 17 Dec 2010 02:16:55 -0500
In-Reply-To: <4D0AA143.3090608@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 2010-12-17 at 00:31 +0100, Patrick McHardy wrote: 
> I completely disagree. As I said previously, userspace has to have
> knowledge of the kernel interpretation anyways.
> 
> We already have libc calls which define complex errors like:
> 
> stdtod(): if val == HUGE_VAL && errno == ERANGE: positive overflow
> 
> I see no reason why we can't define combination of attributes
> and errno values for netlink messages.
> 
> Something like:
> 
> [IFLA_VLAN_ID] == NULL && errno == EINVAL: missing attribute
> [IFLA_VLAN_LINK] && errno == ENODEV: lower link does not exist
> 
> and so on.

Using strings would still involve including an errno as we currently
do and as I pointed out in my other mail I am also very positive
about including an offset pointer or a attribute type to specify the
attribute that caused the failure.

Maybe I am thinking too much about other netlink protocols where
errors often occur due to complicated combinations of missing attributes
and specific attribute values having special meanings. Those cases
would benefit a lot from error strings.

I really don't want to see:

return nl_errstring(ENOMEM, "Out of memory");

I am aiming at a verbose error or status string which acts as an
additional helping point in case of complicated errors. I really
don't want to replace the method of using errno to report errors
in general.

I thought about using attrs to specify the error and the reason I
did choose strings was that when we introduce new errors in the
kernel we have to update all applications. Which is no problem if
everyone uses libraries, so it is probably trivial for netfilter but
will be less trivial for netlink users as a group.

That said, I completely understand your point of view a well.

