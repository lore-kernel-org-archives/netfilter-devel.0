From: David Miller <davem@davemloft.net>
Subject: Re: iproute2: use automake
Date: Tue, 16 Nov 2010 12:18:24 -0800 (PST)
Message-ID: <20101116.121824.242115457.davem@davemloft.net>
References: <20101116075851.0de8d177@nehalam>
	<20101116.094132.59704380.davem@davemloft.net>
	<alpine.LNX.2.01.1011162017320.24880@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: shemminger@vyatta.com, stephen.hemminger@vyatta.com,
	netfilter-devel@vger.kernel.org, netdev@medozas.de
To: jengelh@medozas.de
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60393
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754409Ab0KPUSA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Nov 2010 15:18:00 -0500
In-Reply-To: <alpine.LNX.2.01.1011162017320.24880@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Jan Engelhardt <jengelh@medozas.de>
Date: Tue, 16 Nov 2010 21:11:32 +0100 (CET)

> * running make in subdirs is broken

"It hurts when I do that"
"Don't do it then"

Or, alternatively, fix it in the infrastrucutre that
exists, it cannot be so hard.

Also, we're talking about a tree with a handful of files, a full make
takes a fraction of a second, this is not  a real issue.

> * iproute2/arpd compilation fails if db_185.h, atm.h is not present
>   and
> * people could not quite opt out building arpd when they are
>   fine with not having it

Then make the detection better in the makefile and add the
necessary bits, this is what the GIT and PERF makefiles do
and it works just fine.

I don't see GIT or PERF moving to automake any time soon to
solve this kind of problem, yet it's the one most often
metioned as a great feature of the tool.

It's bloated, unnecessary rubbish.

Jan, just stop wasting our time and fix the problems in the
context which make sense.  And that context isn't adding tons
of unnecessary bloat to iproute2's build system.

Alternatively I invite you to submit automake patches to both
the git and perf projects, better wear your aesbestos suit!
