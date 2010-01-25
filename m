From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 00/09]: netfilter: CT target/conntrack zones
Date: Mon, 25 Jan 2010 17:47:57 +0100
Message-ID: <4B5DCB3D.1000305@trash.net>
References: <20100125153732.15305.68011.sendpatchset@x2.localnet> <alpine.LSU.2.01.1001251736170.20906@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:47404 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753883Ab0AYQsA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Jan 2010 11:48:00 -0500
In-Reply-To: <alpine.LSU.2.01.1001251736170.20906@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Monday 2010-01-25 16:37, Patrick McHardy wrote:
>> include/linux/netfilter/nf_conntrack_common.h  |   22 +++
>> include/linux/netfilter/nfnetlink_conntrack.h  |    2 +
>> include/linux/netfilter/x_tables.h             |    2 +
>> include/linux/netfilter/xt_CT.h                |   14 ++
> 
> Is there anything that prohibits using a little-more descriptive
> name, like xt_CONNTRACK?
> That btw reminds me that, perhaps, we could/should avoid
> same-name different-case (cf. xt_conntrack) in future,
> so xt_CONNTRACK would not fly too well.

I thought CT is an established term for connection tracking.
I don't care much, but I prefer a short name like CT.
