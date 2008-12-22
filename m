From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Compiler warnings on libnetfilter_*
Date: Mon, 22 Dec 2008 23:21:11 +0100
Message-ID: <495012D7.2080002@netfilter.org>
References: <alpine.LNX.1.10.0812221909100.26910@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48542 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753357AbYLVWVU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 22 Dec 2008 17:21:20 -0500
In-Reply-To: <alpine.LNX.1.10.0812221909100.26910@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Hi,
> 
> I have compiled all the libnetfilter* libraries and conntrack-tools,
> and this is the collection of compiler warnings I obtained.
> (Note: running a silenced automake is a big win.)

Is there already an option to silence automake? I found your patches in
the automake ML but I didn't find them in the official tree. I'm not a
fan of the verbose mode either.

> + make -j2
> Making all in src
> make[1]: Entering directory `/usr/src/packages/BUILD/netfilter-toolsuite-0.20081222/libnfnetlink/src'
>   CC       iftable.lo
>   CC       libnfnetlink.lo
> iftable.c:176: warning: 'iftable_up' defined but not used
>   CC       rtnl.lo
>   CCLD     libnfnetlink.la
> make[1]: Leaving directory `/usr/src/packages/BUILD/netfilter-toolsuite-0.20081222/libnfnetlink/src'
> + popd
> /usr/src/packages/BUILD/netfilter-toolsuite-0.20081222

This one is known. I left it there because I was thinking about to make
that function public. With the new libnfnetlink API (that I haven't post
yet), we will not need it so we can remove.

> + make -j2
> Making all in conntrack
> make[2]: Entering directory `/usr/src/packages/BUILD/netfilter-toolsuite-0.20081222/libnetfilter_conntrack/src/conntrack'
>   CC       api.lo
>   CC       callback.lo
> mkdir: cannot create directory `.libs': File exists

I did not know this one.

> callback.c: In function '__callback':
> callback.c:30: warning: passing argument 2 of '__parse_conntrack' from incompatible pointer type
> api.c: In function 'nfct_parse_conntrack':
> api.c:668: warning: passing argument 2 of '__parse_conntrack' from incompatible pointer type

A casting should fix this?

[...]
> + make -j2
> Making all in extensions
> make[1]: Entering directory `/usr/src/packages/BUILD/netfilter-toolsuite-0.20081222/conntrack-tools/extensions'

I did not notice compilation that conntrack-tools was not warning about
unused variables.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
