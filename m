From: Patrick McHardy <kaber@trash.net>
Subject: libnftables set element printing, DATA_CHAIN
Date: Wed, 15 Jan 2014 22:50:03 +0000
Message-ID: <20140115225002.GA13700@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: arturo.borrero.glez@gmail.com, netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49427 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506AbaAOWuH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Jan 2014 17:50:07 -0500
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[resending because of incorrect list address]

I was looking at some incorrect output in netlink debugging for set elements
and noticed a few things that seem odd:

First, the regular netlink debugging seems very incomplete, it doesn't
print verdict types, it prints [end] whether the set contains intervals
and the set is an interval end or not and its messing up the output.

Next I'm wondering about what DATA_CHAIN is supposed to be. I guess its
the chain for a jump or goto verdict, This is even encoded in the
XML and JSON output. This seems wrong to me, there is no DATA_CHAIN,
there are JUMP or GOTO verdicts that include a chain. The specific
verdict is also missing, so its not possible to distinguish these
two cases.

I could fix up the debugging output, but this looks like someone more
familiar with the XML and JSON stuff should have a look at this and
fix all of this consistently before we release it as wire format.
