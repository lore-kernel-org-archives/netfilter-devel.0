From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: netfilter module and shared libraries
Date: Thu, 1 Apr 2010 14:01:10 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1004011358350.17429@obet.zrqbmnf.qr>
References: <m2zdac45061004010446o99e12733m645008caac88873c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, Mark Ryden <markryde@gmail.com>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:33912 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755765Ab0DAMBM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 1 Apr 2010 08:01:12 -0400
In-Reply-To: <m2zdac45061004010446o99e12733m645008caac88873c@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2010-04-01 13:46, Mark Ryden wrote:

>Hello,
>
>I wrote a simple, short (35 lines) netfilter module (XTable target)
>The code is below.
>I build it and insmoded it.
>When I try to add this iptables rule:
>
>iptables -A OUTPUT -p UDP --dport 9998 -j ECHO

(Note that there is already an "ECHO" target in Xtables-addons ;-))

>I get this error:
>
>iptables v1.4.5: Couldn't load target `ECHO':/lib64/xtables/libipt_ECHO.so:
>cannot open shared object file: No such file or directory
>
>
>My question is: for a simple netfilter module like this ("ECHO"), must
>I create a
>corresponding shared library  (libipt_ECHO.so)?

Yes.

>Is there a way to avoid this when adding such a rule,
>using some default mechansim ?

Let's ask Patrick:

What do you think of enabling iptables to assume targets with .size=0 
(which don't have options by design) if there was no libxt_XYZ.so found? 
That would make things like libxt_NOTRACK.c obsolete, too.
