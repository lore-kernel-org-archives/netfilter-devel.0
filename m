From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: xt_owner-xt_socket plans
Date: Mon, 21 Jan 2008 14:16:58 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801211412380.24186@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801201914260.14598@fbirervta.pbzchgretzou.qr>
 <479461C2.1060703@balabit.hu> <Pine.LNX.4.64.0801211156320.24186@fbirervta.pbzchgretzou.qr>
 <20080121122044.GA20295@sch.bme.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Laszlo Attila Toth <panther@balabit.hu>,
	Patrick McHardy <kaber@trash.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: KOVACS Krisztian <hidden@sch.bme.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:53572 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542AbYAUNQ7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Jan 2008 08:16:59 -0500
In-Reply-To: <20080121122044.GA20295@sch.bme.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Jan 21 2008 13:20, KOVACS Krisztian wrote:
>
>No, not just UDP but it uses only the port part of the header which has
>the same layout as the TCP header. It's ugly, though. (But I'm afraid this
>is not the only place where this appears.)

Hm yeah I had that suspicion and it seems to be the case.
I added this in my floating patches..
        /*
         * All the protocols that are currently supported (see above if
         * statement) have source and destination port at the same position,
         * so we can use this udph shortcut. Why UDP? The struct is the
         * smallest.
         */
	... skb_header_pointer ...

>The skb_header_pointer() might be unnecessary,

You are inspecting the layer4 data, so header_poitner is alright.
hp->source did not tell me anything at first, but seeing that you
chose UDP, it must have been the source port (->source is a bad
wording for it, I would have expected ->sport like TCP does).

>And as already mentioned, the this match depends heavily on the other
>parts of the tproxy patchset. In fact we'd need to create a new table to
>make it work for NAT-ted connections (the current tproxy patchset has a
>problem with SNAT),

What problem? Maybe it's a bit shortsighted, but I guess if you just
use the conntrack origsrc/dst instead of iph->saddr, it should be a
no-brainer, no?

>so it wouldn't be possible to use it on
>mangle/PREROUTING... (Do you happen to have any ideas for this new table
>name? I wouldn't call it tproxy but something else which tells you its
>place in the flowchart, like 'postnat' or something like that.)
