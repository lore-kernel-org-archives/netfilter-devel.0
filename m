From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 00/09]: netfilter: CT target/conntrack zones
Date: Mon, 25 Jan 2010 17:37:32 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1001251736170.20906@obet.zrqbmnf.qr>
References: <20100125153732.15305.68011.sendpatchset@x2.localnet>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:54577 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753679Ab0AYQhd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Jan 2010 11:37:33 -0500
In-Reply-To: <20100125153732.15305.68011.sendpatchset@x2.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2010-01-25 16:37, Patrick McHardy wrote:
>
> include/linux/netfilter/nf_conntrack_common.h  |   22 +++
> include/linux/netfilter/nfnetlink_conntrack.h  |    2 +
> include/linux/netfilter/x_tables.h             |    2 +
> include/linux/netfilter/xt_CT.h                |   14 ++

Is there anything that prohibits using a little-more descriptive
name, like xt_CONNTRACK?
That btw reminds me that, perhaps, we could/should avoid
same-name different-case (cf. xt_conntrack) in future,
so xt_CONNTRACK would not fly too well.

