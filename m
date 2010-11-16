From: David Miller <davem@davemloft.net>
Subject: Re: iproute2: use automake
Date: Tue, 16 Nov 2010 09:41:32 -0800 (PST)
Message-ID: <20101116.094132.59704380.davem@davemloft.net>
References: <20101115.175928.104078108.davem@davemloft.net>
	<alpine.LNX.2.01.1011161108330.25859@obet.zrqbmnf.qr>
	<20101116075851.0de8d177@nehalam>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: jengelh@medozas.de, stephen.hemminger@vyatta.com,
	netfilter-devel@vger.kernel.org
To: shemminger@vyatta.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38379
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752419Ab0KPRlI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Nov 2010 12:41:08 -0500
In-Reply-To: <20101116075851.0de8d177@nehalam>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Stephen Hemminger <shemminger@vyatta.com>
Date: Tue, 16 Nov 2010 07:58:51 -0800

> Until you make a convincing case that the existing infrastructure
> is a problem, choosing an alternative solution is bogus.
> 
> All the fancy build systems are designed to solve the issue
> of building one piece of software in multiple environments.
> The iproute2 utilities only work on Linux and so far I haven't
> had any major complaints from any distribution maintainer about it.

I totally agree.

I can't count the amount of times I've seen major source trees
invest tons of engineering into things to decrease the pain of
using things like automake and libtool.

X11 even has a script that basically turns libtool into one big
fat NOP, because on Linux everything libtool tries to figure out
is completely superfluous.

Don't crap up the tree with unnecessary non-sense just for some
theoretical gain.  Things work just fine right now.
