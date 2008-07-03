From: Thomas Jacob <jacob@internet24.de>
Subject: Re: Patches solving the same issue!?
Date: Thu, 03 Jul 2008 16:30:03 +0200
Message-ID: <1215095403.26474.103.camel@enterprise.ims-firmen.de>
References: <> <1215021635-28691-1-git-send-email-jacob@internet24.de>
	 <1215021635-28691-2-git-send-email-jacob@internet24.de>
	 <1215032251.9467.11.camel@localhost.localdomain>
	 <486CC931.2010703@trash.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: jdb@comx.dk, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout02.ims-firmen.de ([213.174.32.97]:51294 "EHLO
	mailout02.ims-firmen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753342AbYGCOaH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Jul 2008 10:30:07 -0400
In-Reply-To: <486CC931.2010703@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 2008-07-03 at 14:42 +0200, Patrick McHardy wrote:
> Please work this out among yourselves. I think we should just pick
> the faster one since both don't look very intrusive.

Well, Jesper's version doesn't build any extra data-structures,
so you save time&space there, and the offsets stuff is really
only needed once, so the chain_index rebuilding penalty
doesn't play a role.

And since about 2/3s of time it takes to load my 50k Chains now
is system time, it's probably irrelevant whether
 0 + O(n * (log(n/40)+40)) is sometimes larger than O(n+n/1024) +
O(log(n)).

Mine vs. Jesper's:

iptables-restore  (50k chains, 120k rules), average for 10 runs:

User: 2.558 s - System: 8.672 s - Total : 11.222 s
vs
User: 2.622 s - System: 8.520 s - Total : 11.140 s


iptables -vnL SOMECHAIN (2 entries, with the above ruleset in kernel),
 average for 20 runs

User: .094 s - System: .363 s - Total : .455 s
vs
User: .085 s - System: .389 s - Total : .472 s

Those numbers are all within the standard deviations of each other,
so there is no difference for practical purposes, I think :-)

I would use Jesper's patch.



