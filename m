From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: RFC: net/netfilter reorganization
Date: Mon, 6 Oct 2008 12:17:11 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0810051102050.21891@fbirervta.pbzchgretzou.qr>
References: <48E8B439.6030608@trash.net> <alpine.LNX.1.10.0810050925350.21891@fbirervta.pbzchgretzou.qr> <48E8C90D.10202@trash.net> <alpine.LNX.1.10.0810051004230.21891@fbirervta.pbzchgretzou.qr> <48E8D3C4.60306@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:58647 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552AbYJFQRN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Oct 2008 12:17:13 -0400
In-Reply-To: <48E8D3C4.60306@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Sunday 2008-10-05 10:48, Patrick McHardy wrote:
>> 
>> That's a 43% reduction in memory.
>
> Its a clear benefit, I don't doubt that. I mainly think this is not
> netfilter specific at all and should be done on a kbuild level.

This is not easily doable with kbuild at the moment, since you cannot
have two entry functions in the same .ko, which is why that
koredux patch has to call every module's ctors and dtors.

> Linking all of them together also has some runtime impact because
> of symbol dependencies, using let say tcpudp will probably pull
> in (parts of) IPv6 and NAT. Having them grouped by dependencies
> would avoid this.

This has been avoided by providing xtables_ext, xtables_xct (for
conntrack-depending), xtables_xnat (for nat-depending) and
xtables_xv6 (for ipv6-depending). The list above only showed modules
included in _ext which have no dependency whatsoever.

>> It does not really solve anything IMHO. Protocols? FTP is one, so hm,
>> same confusion. This also got my anti-favorite 4-depth :)
>
> Well, its not *that much* confusing since I believe most people are
> aware of that part of the netfilter terminology. The main goal is
> to get the directory contents to a more reasonable level and group
> related stuff together; using just net/netfilter/ct is still a bit
> too coarse in my opinion. Under that aspect, what would your proposed
> structure be?

Taking into account that mixing helpers and trackers in the same 
namespace, I'd go for something like
net/netfilter/conntrack/
	l3_generic.c
	l4_generic.c
	l4_tcp.c
	l5_ftp.c
net/ipv4/netfilter/ / v6/netfilter
	no preference
ebtables/netfilter
	just keep it for great justice, it's nicely clean :)

The directory preference limit of 3 has so much weight for me that 
remaining tweaks need to be done on the filename.
There are only 28 nfct files, and if we - at the minimum - get rid of 
the overly long nf_conntrack_ prefix, a wide display (ls -x) won't 
have too much blanks (the criterion for splitting things up in the first 
place, imo ;-).
I .. hope that makes sense.
