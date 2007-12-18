From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 00/64]: Netfilter update
Date: Mon, 17 Dec 2007 22:51:26 -0800 (PST)
Message-ID: <20071217.225126.26533748.davem@davemloft.net>
References: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55326
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752703AbXLRGv1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Dec 2007 01:51:27 -0500
In-Reply-To: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Patrick McHardy <kaber@trash.net>
Date: Tue, 18 Dec 2007 00:46:12 +0100 (MET)

> following is a rather large netfilter update for 2.6.25. The diffstat
> looks a bit worse than it is, most files are only touched due to
> __read_mostly and const annotations. The rough overview is:
...
> - Finally, the CONFIG_NETFILTER_ADVANCED patch. Its more intrusive than
>   I hoped and the choices weren't really clear, so Its last in the
>   series. Please have a look whether you think its useful like this,
>   otherwise feel free to drop it.
> 
> Please apply, thanks.

I applied everthing to net-2.6.25 and pushed it all out, including
the NETFILTER_ADVANCED thing.  It was definitely an improvement.

Can you do something for me Patrick?  Go from a config with
NETFILTER disabled, then turn it on, use NETFILTER_ADVANCED=n
and walk through the options presented to the user.

Some of those default=m cases are marked EXPERIMENTAL.  Either the
default=m or the EXPERIMENTAL are bogus, in each case.  Most of the
time it's the latter, and if you could fix these I'd appreciate it.

Thanks!
